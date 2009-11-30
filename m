Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:44108 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbZK3Qys convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 11:54:48 -0500
Received: by iwn1 with SMTP id 1so2374854iwn.33
        for <linux-wireless@vger.kernel.org>; Mon, 30 Nov 2009 08:54:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091130154300.647360542@sipsolutions.net>
References: <20091130153857.963079149@sipsolutions.net> <20091130154300.647360542@sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 30 Nov 2009 08:54:34 -0800
Message-ID: <43e72e890911300854i69ddb18dxcd34d38f0d610004@mail.gmail.com>
Subject: Re: [PATCH 2/2] mac80211: enable spatial multiplexing powersave
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> --- wireless-testing.orig/net/mac80211/cfg.c    2009-11-29 11:33:00.000000000 +0100
> +++ wireless-testing/net/mac80211/cfg.c 2009-11-29 11:40:29.000000000 +0100
> @@ -1316,6 +1316,54 @@ static int ieee80211_testmode_cmd(struct
>  }
>  #endif
>
> +static int ieee80211_request_smps(struct ieee80211_sub_if_data *sdata,
> +                                 enum nl80211_smps_mode smps_mode)
> +{
> +       const u8 *ap;
> +       enum nl80211_smps_mode old_req;
> +       int err = 0;
> +
> +       mutex_lock(&sdata->u.mgd.mtx);
> +
> +       old_req = sdata->u.mgd.req_smps;
> +       sdata->u.mgd.req_smps = smps_mode;

sdata->u.mgd.mtx seems protected by sdata->u.mgd.mtx.

> +
> +       if (old_req == smps_mode &&
> +           smps_mode != NL80211_SMPS_AUTOMATIC)
> +               goto out;
> +
> +       /*
> +        * If not associated, or current sasociation is not an HT
> +        * association, there's no need to send an action frame.
> +        */
> +       if (!sdata->u.mgd.associated ||
> +           sdata->local->oper_channel_type == NL80211_CHAN_NO_HT) {
> +               mutex_lock(&sdata->local->iflist_mtx);
> +               ieee80211_recalc_smps(sdata->local, sdata);
> +               mutex_unlock(&sdata->local->iflist_mtx);
> +               goto out;
> +       }
> +
> +       ap = sdata->u.mgd.associated->cbss.bssid;
> +
> +       if (smps_mode == NL80211_SMPS_AUTOMATIC) {
> +               if (sdata->u.mgd.powersave)
> +                       smps_mode = NL80211_SMPS_DYNAMIC;
> +               else
> +                       smps_mode = NL80211_SMPS_OFF;
> +       }
> +
> +       /* send SM PS frame to AP */
> +       err = ieee80211_send_smps_action(sdata, smps_mode,
> +                                        ap, ap);
> +       if (err)
> +               sdata->u.mgd.req_smps = old_req;
> + out:
> +       mutex_unlock(&sdata->u.mgd.mtx);
> +
> +       return err;
> +}
>  static int ieee80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
>                                    bool enabled, int timeout)
>  {
> @@ -1333,6 +1381,9 @@ static int ieee80211_set_power_mgmt(stru
>        sdata->u.mgd.powersave = enabled;
>        conf->dynamic_ps_timeout = timeout;
>
> +       /* no change, but if automatic follow powersave */
> +       ieee80211_request_smps(sdata, sdata->u.mgd.req_smps);

But yet the caller uses it without any locking. Seems racy between
here and the respective mutex_lock().



> @@ -932,6 +981,7 @@ static void ieee80211_set_associated(str
>
>        mutex_lock(&local->iflist_mtx);
>        ieee80211_recalc_ps(local, -1);
> +       ieee80211_recalc_smps(local, sdata);
>        mutex_unlock(&local->iflist_mtx);
>
>        netif_start_queue(sdata->dev);
> @@ -2328,6 +2378,11 @@ void ieee80211_sta_setup_sdata(struct ie
>                ifmgd->flags |= IEEE80211_STA_WMM_ENABLED;
>
>        mutex_init(&ifmgd->mtx);
> +
> +       if (sdata->local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS)
> +               ifmgd->req_smps = NL80211_SMPS_AUTOMATIC;
> +       else
> +               ifmgd->req_smps = NL80211_SMPS_OFF;

How about just checking the HT cap as well and if no HT cap has been
set warn as it would indicate a driver bug actually.

> --- wireless-testing.orig/net/mac80211/status.c 2009-11-29 11:33:00.000000000 +0100
> +++ wireless-testing/net/mac80211/status.c      2009-11-29 11:35:06.000000000 +0100
> @@ -134,6 +134,40 @@ static void ieee80211_handle_filtered_fr
>        dev_kfree_skb(skb);
>  }
>
> +static void ieee80211_frame_acked(struct sta_info *sta, struct sk_buff *skb)
> +{
> +       struct ieee80211_mgmt *mgmt = (void *) skb->data;
> +       struct ieee80211_local *local = sta->local;
> +       struct ieee80211_sub_if_data *sdata = sta->sdata;
> +
> +       if (ieee80211_is_action(mgmt->frame_control) &&
> +           sdata->vif.type == NL80211_IFTYPE_STATION &&
> +           mgmt->u.action.category == WLAN_CATEGORY_HT &&
> +           mgmt->u.action.u.ht_smps.action == WLAN_HT_ACTION_SMPS) {
> +               /*
> +                * This update looks racy, but isn't -- if we come
> +                * here we've definitely got a station that we're
> +                * talking to, and on a managed interface that can
> +                * only be the AP. And the only other place updating
> +                * this variable is before we're associated.
> +                */
> +               switch (mgmt->u.action.u.ht_smps.smps_control) {
> +               case WLAN_HT_SMPS_CONTROL_DYNAMIC:
> +                       sta->sdata->u.mgd.ap_smps = NL80211_SMPS_DYNAMIC;
> +                       break;
> +               case WLAN_HT_SMPS_CONTROL_STATIC:
> +                       sta->sdata->u.mgd.ap_smps = NL80211_SMPS_STATIC;
> +                       break;
> +               case WLAN_HT_SMPS_CONTROL_DISABLED:
> +               default: /* shouldn't happen since we don't send that */
> +                       sta->sdata->u.mgd.ap_smps = NL80211_SMPS_OFF;
> +                       break;
> +               }
> +
> +               ieee80211_queue_work(&local->hw, &local->recalc_smps);

OK from what I gather so far we just queue work if we received an ACK
from the action frame we sent. Since we tell the device to
ieee80211_stop_device() the device should have stopped RX'ing and that
*should* mean preventing processing future tx status reports. We'll
find out if that assumption is wrong.

> +       }
> +}
> +
>  void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
>  {
>        struct sk_buff *skb2;
> @@ -209,6 +243,10 @@ void ieee80211_tx_status(struct ieee8021
>                rate_control_tx_status(local, sband, sta, skb);
>                if (ieee80211_vif_is_mesh(&sta->sdata->vif))
>                        ieee80211s_update_metric(local, sta, skb);
> +
> +               if (!(info->flags & IEEE80211_TX_CTL_INJECTED) &&
> +                   (info->flags & IEEE80211_TX_STAT_ACK))
> +                       ieee80211_frame_acked(sta, skb);
>        }
>
>        rcu_read_unlock();

Nice, should the nullfunc ack check be handled here as well?

> --- wireless-testing.orig/net/mac80211/main.c   2009-11-29 11:33:00.000000000 +0100
> +++ wireless-testing/net/mac80211/main.c        2009-11-29 22:18:07.000000000 +0100
> @@ -113,6 +113,18 @@ int ieee80211_hw_config(struct ieee80211
>                changed |= IEEE80211_CONF_CHANGE_CHANNEL;
>        }
>
> +       if (!conf_is_ht(&local->hw.conf)) {
> +               /*
> +                * mac80211.h documents that this is only valid
> +                * when the channel is set to an HT type, and
> +                * that otherwise STATIC is used.
> +                */
> +               local->hw.conf.smps_mode = NL80211_SMPS_STATIC;

Why wouldn't this just be SMPS_OFF ?


> --- wireless-testing.orig/net/mac80211/util.c   2009-11-29 11:33:00.000000000 +0100
> +++ wireless-testing/net/mac80211/util.c        2009-11-29 11:35:06.000000000 +0100
> @@ -1170,3 +1170,77 @@ int ieee80211_reconfig(struct ieee80211_
>        return 0;
>  }
>
> +static int check_mgd_smps(struct ieee80211_if_managed *ifmgd,
> +                         enum nl80211_smps_mode *smps_mode)
> +{
> +       if (ifmgd->associated) {
> +               *smps_mode = ifmgd->ap_smps;
> +
> +               if (smps_mode == NL80211_SMPS_AUTOMATIC) {

This should be *smps_mode.

  Luis
