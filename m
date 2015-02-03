Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:52787 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933798AbbBCMtX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 07:49:23 -0500
Received: by mail-we0-f172.google.com with SMTP id q59so44682937wes.3
        for <linux-wireless@vger.kernel.org>; Tue, 03 Feb 2015 04:49:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1422960114-25137-5-git-send-email-marek.puzyniak@tieto.com>
References: <1422960114-25137-1-git-send-email-marek.puzyniak@tieto.com>
	<1422960114-25137-5-git-send-email-marek.puzyniak@tieto.com>
Date: Tue, 3 Feb 2015 13:49:22 +0100
Message-ID: <CA+BoTQnKvNwcCxQWQe1Ck11oTE4yGTPpV65r5D02fHbLkrvpFQ@mail.gmail.com> (sfid-20150203_134928_189592_ADC81596)
Subject: Re: [RFC 4/4] ath10k: introduce basic tdls functionality
From: Michal Kazior <michal.kazior@tieto.com>
To: Marek Puzyniak <marek.puzyniak@tieto.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Marek Kwaczynski <marek.kwaczynski@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3 February 2015 at 11:41, Marek Puzyniak <marek.puzyniak@tieto.com> wrote:
[...]
> +static int ath10k_enable_tdls(struct ath10k *ar, u32 vdev_id, bool enable)

Function in mac.c should have a `ath10k_mac_` prefix.

> +{
> +       int ret;
> +       enum wmi_tdls_state state = WMI_TDLS_DISABLE;
> +
> +       lockdep_assert_held(&ar->conf_mutex);
> +
> +       if (enable)
> +               state = WMI_TDLS_ENABLE_ACTIVE;
> +
> +       ret = ath10k_wmi_update_fw_tdls_state(ar, vdev_id, state);

Anyway I see little point in having this wrapper function just to call
wmi function?


[...]
> +static int ath10k_tdls_peer_update(struct ath10k *ar, u32 vdev_id,
> +                                  struct ieee80211_sta *sta,
> +                                  enum wmi_tdls_peer_state state)

The ath10k_mac_ prefix is missing: ath10k_mac_tdls_peer_update().


> +{
> +       int ret;
> +       struct wmi_tdls_peer_update_cmd_arg arg;
> +       struct wmi_tdls_peer_capab_arg cap;
> +       struct wmi_channel_arg chan_arg;

I would `xxx = {}` to make these are zero-ed. Right now you pass
uninitialized vars from the stack..


> +       int i;
> +
> +       lockdep_assert_held(&ar->conf_mutex);
> +
> +       arg.vdev_id = vdev_id;
> +       arg.peer_state = state;
> +       ether_addr_copy(arg.addr, sta->addr);
> +
> +       cap.peer_max_sp = sta->max_sp;
> +       cap.peer_uapsd_queues = sta->uapsd_queues;
> +       cap.peer_curr_operclass = 0;
> +       cap.self_curr_operclass = 0;
> +       cap.peer_chan_len = 0;
> +       cap.peer_operclass_len = 0;
> +       cap.is_peer_responder = 0;
> +       cap.buff_sta_support = 0;
> +       cap.off_chan_support = 0;
> +       cap.pref_offchan_num = 0;
> +       cap.pref_offchan_bw = 0;

Once you `= {}` it's probably redundant to zero each structure member like that.


[...]
> @@ -4462,6 +4553,8 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
>                 if (ret)
>                         ath10k_warn(ar, "failed to delete peer %pM for vdev %d: %i\n",
>                                     sta->addr, arvif->vdev_id, ret);
> +               if (sta->tdls)
> +                       ath10k_enable_tdls(ar, arvif->vdev_id, false);

What if you have 2 TDLS peers? If you disconnect the first one you'll
disable TDLS on the entire vdev while the other peer is still
connected. I don't think that's desired.

Perhaps the per-vdev TDLS command can be called in
add_interface()/remove_interface()? If that's not possible I guess you
could use ieee80211_iterate_stations_atomic() to look if there's still
at least one TDLS peer present.


>
>                 ath10k_mac_dec_num_stations(arvif);
>         } else if (old_state == IEEE80211_STA_AUTH &&
> @@ -4479,9 +4572,28 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
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
> +               if (ret)
> +                       ath10k_warn(ar, "failed to associate station %pM for vdev %i: %i\n",
> +                                   sta->addr, arvif->vdev_id, ret);

It's meaningless to call tdls_peer_update() if assoc failed. From
practical standpoint fw is probably dead at that point and subsequent
commands will timeout. You can `goto exit`.


[...]
> +static struct sk_buff *
> +ath10k_wmi_tlv_op_gen_update_fw_tdls_state(struct ath10k *ar, u32 vdev_id,
> +                                          enum wmi_tdls_state state)
> +{
> +       struct wmi_tdls_set_state_cmd *cmd;
> +       struct wmi_tlv *tlv;
> +       struct sk_buff *skb;
> +       void *ptr;
> +       size_t len;
> +       /* Set to options from wmi_tlv_tdls_options,
> +        * for now none of then are enabled.

Typo: s/then/them/


> +        */
> +       u32 options = 0;
> +
> +       len = sizeof(*tlv) + sizeof(*cmd);
> +       skb = ath10k_wmi_alloc_skb(ar, sizeof(*tlv) + sizeof(*cmd));

Why not use `len` for alloc_skb()?


[...]
> +static struct sk_buff *
> +ath10k_wmi_tlv_op_gen_tdls_peer_update(struct ath10k *ar,
> +                                      struct wmi_tdls_peer_update_cmd_arg *arg,
> +                                      struct wmi_tdls_peer_capab_arg *cap,
> +                                      struct wmi_channel_arg *chan_arg)

Could be const struct on these _args.


[...]
> diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
> index 5f0fe84..8c219f0 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
> +++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
> @@ -1516,6 +1516,58 @@ struct wmi_tlv_p2p_noa_ev {
>         __le32 vdev_id;
>  } __packed;
>
> +/* TDLS Options */
> +enum wmi_tlv_tdls_options {
> +       WMI_TLV_TDLS_OFFCHAN_EN = BIT(0), /* TDLS Off Channel support */
> +       WMI_TLV_TDLS_BUFFER_STA_EN = BIT(1), /* TDLS Buffer STA support */
> +       WMI_TLV_TDLS_SLEEP_STA_EN = BIT(2), /* TDLS Sleep STA support */

These comments seem redundant and don't introduce any extra info..


Michał
