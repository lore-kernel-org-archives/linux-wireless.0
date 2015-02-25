Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:33774 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbbBYKeN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 05:34:13 -0500
Received: by wghb13 with SMTP id b13so2744123wgh.0
        for <linux-wireless@vger.kernel.org>; Wed, 25 Feb 2015 02:34:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1424850911-21017-5-git-send-email-marek.puzyniak@tieto.com>
References: <1424850911-21017-1-git-send-email-marek.puzyniak@tieto.com>
	<1424850911-21017-5-git-send-email-marek.puzyniak@tieto.com>
Date: Wed, 25 Feb 2015 11:34:11 +0100
Message-ID: <CA+BoTQnxD4JpXARQGzSgEvypzn9vS__rVk5JcwOvaT1zh4CtJw@mail.gmail.com> (sfid-20150225_113417_543924_406927B7)
Subject: Re: [PATCH v2 4/4] ath10k: introduce basic tdls functionality
From: Michal Kazior <michal.kazior@tieto.com>
To: Marek Puzyniak <marek.puzyniak@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	Marek Kwaczynski <marek.kwaczynski@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 February 2015 at 08:55, Marek Puzyniak <marek.puzyniak@tieto.com> wrote:
[...]
> diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
> index 94a8788..14b99c8 100644
> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -604,6 +604,7 @@ struct ath10k {
>         /* protected by conf_mutex */
>         int num_peers;
>         int num_stations;
> +       int tdls_peers;

I don't like the idea of having another var in ath10k which isn't on
hotpath and can be derived from other structures/tools we already
have, i.e. ieee80211_iterate_stations_atomic(). You can use that to
implement ath10k_mac_tdls_num_peers(arvif).


>
>         int max_num_peers;
>         int max_num_stations;
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index 7378656..21720b8 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -518,6 +518,73 @@ static void ath10k_peer_cleanup_all(struct ath10k *ar)
>         ar->num_stations = 0;
>  }
>
> +static int ath10k_mac_enable_tdls(struct ath10k *ar, u32 vdev_id, bool enable)

With number of tdls peers being derived you won't be able to have this
kind of "recalc" logic anymore. I guess that's a good thing. You'll
need to call ath10k_wmi_update_fw_tdls_state() explicitly in
ath10k_sta_state() depending on context and numbers of peers.


> +static int ath10k_mac_tdls_peer_update(struct ath10k *ar, u32 vdev_id,
> +                                      struct ieee80211_sta *sta,
> +                                      enum wmi_tdls_peer_state state)
> +{
> +       int ret;
> +       struct wmi_tdls_peer_update_cmd_arg arg;

I would `arg = {};` to make sure it's clean. Even if you're positive
you fill all `arg` members here it leaves it open for bugs sneaking in
when you extend the structure later on and forget to init new members
here as well.


> +       struct wmi_tdls_peer_capab_arg cap = {};
> +       struct wmi_channel_arg chan_arg = {};
> +
> +       lockdep_assert_held(&ar->conf_mutex);
> +
> +       arg.vdev_id = vdev_id;
> +       arg.peer_state = state;
> +       ether_addr_copy(arg.addr, sta->addr);
> +
> +       cap.peer_max_sp = sta->max_sp;
> +       cap.peer_uapsd_queues = sta->uapsd_queues;
> +
> +       if (state == WMI_TDLS_PEER_STATE_CONNECTED) {
> +               if (!sta->tdls_initiator)
> +                       cap.is_peer_responder = 1;
> +       }

You can probably make it into a single if() ?


> @@ -4092,9 +4193,30 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
>                         ath10k_warn(ar, "failed to associate station %pM for vdev %i: %i\n",
>                                     sta->addr, arvif->vdev_id, ret);
>         } else if (old_state == IEEE80211_STA_ASSOC &&
> -                  new_state == IEEE80211_STA_AUTH &&
> -                  (vif->type == NL80211_IFTYPE_AP ||
> -                   vif->type == NL80211_IFTYPE_ADHOC)) {
> +                  new_state == IEEE80211_STA_AUTHORIZED &&
> +                  sta->tdls) {
> +               /*
> +                * Tdls station authorized.
> +                */
> +               ath10k_dbg(ar, ATH10K_DBG_MAC, "mac tdls sta %pM authorized\n",
> +                          sta->addr);
> +
> +               ret = ath10k_station_assoc(ar, vif, sta, false);
> +               if (ret) {
> +                       ath10k_warn(ar, "failed to associate station %pM for vdev %i: %i\n",

"failed to associate tdls station...." would be nicer I guess?


> +static u32 ath10k_wmi_tlv_prepare_peer_qos(u8 uapsd_queues, u8 sp)
> +{
> +       u32 peer_qos = 0;
> +
> +       if (uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_VO)
> +               peer_qos |= WMI_TLV_TDLS_PEER_QOS_AC_VO;
> +       if (uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_VI)
> +               peer_qos |= WMI_TLV_TDLS_PEER_QOS_AC_VI;
> +       if (uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_BK)
> +               peer_qos |= WMI_TLV_TDLS_PEER_QOS_AC_BK;
> +       if (uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_BE)
> +               peer_qos |= WMI_TLV_TDLS_PEER_QOS_AC_BE;
> +       peer_qos |= (sp << WMI_TLV_TDLS_PEER_SP_POS);

peer_qos |= (sp << WMI_TLV_TDLS_PEER_SP_SHIFT);

Or even provide _MASK + _SHIFT defines and use SM/MS macros.


> +struct wmi_tdls_peer_update_cmd_arg {
> +       u32 vdev_id;
> +       enum wmi_tdls_peer_state peer_state;
> +       u8 addr[ETH_ALEN];
> +} __packed;

No need to pack local/driver-only structures.


> +struct wmi_tdls_peer_capab_arg {
> +       u8 peer_uapsd_queues;
> +       u8 peer_max_sp;
> +       u32 buff_sta_support;
> +       u32 off_chan_support;
> +       u32 peer_curr_operclass;
> +       u32 self_curr_operclass;
> +       u32 peer_chan_len;
> +       u32 peer_operclass_len;
> +       u8 peer_operclass[WMI_TDLS_MAX_SUPP_OPER_CLASSES];
> +       u32 is_peer_responder;
> +       u32 pref_offchan_num;
> +       u32 pref_offchan_bw;
> +} __packed;

No need to pack local/driver-only structures.


Michał
