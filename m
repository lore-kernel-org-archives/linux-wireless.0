Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:36601 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751283Ab1HJTyh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 15:54:37 -0400
Received: by mail-fx0-f50.google.com with SMTP id 2so1500583fxh.23
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2011 12:54:35 -0700 (PDT)
Subject: Re: [PATCH 23/40] wl12xx: re-enable block ack session support
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1312881233-9366-24-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
	 <1312881233-9366-24-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 22:54:32 +0300
Message-ID: <1313006072.2407.731.camel@cumari> (sfid-20110810_215440_408637_EE1D9398)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-09 at 12:13 +0300, Eliad Peller wrote: 
> diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
> index 6885568..02b9c7e 100644
> --- a/drivers/net/wireless/wl12xx/acx.c
> +++ b/drivers/net/wireless/wl12xx/acx.c
> @@ -1320,25 +1320,21 @@ int wl1271_acx_set_ht_capabilities(struct wl1271 *wl,
>         acx = kzalloc(sizeof(*acx), GFP_KERNEL);
>         if (!acx) {
>                 ret = -ENOMEM;
>                 goto out;
>         }
>  
> -       /* Allow HT Operation ? */
>         if (allow_ht_operation) {
> -               ht_capabilites =
> -                       WL1271_ACX_FW_CAP_HT_OPERATION;
> -               if (ht_cap->cap & IEEE80211_HT_CAP_GRN_FLD)
> -                       ht_capabilites |=
> -                               WL1271_ACX_FW_CAP_GREENFIELD_FRAME_FORMAT;
> -               if (ht_cap->cap & IEEE80211_HT_CAP_SGI_20)
> -                       ht_capabilites |=
> -                               WL1271_ACX_FW_CAP_SHORT_GI_FOR_20MHZ_PACKETS;
> -               if (ht_cap->cap & IEEE80211_HT_CAP_LSIG_TXOP_PROT)
> -                       ht_capabilites |=
> -                               WL1271_ACX_FW_CAP_LSIG_TXOP_PROTECTION;
> +               /* no need to translate capabilities - use the spec values */
> +               ht_capabilites = ht_cap->cap;
> +
> +               /*
> +                * this bit is not employed by the spec but only by FW to
> +                * indicate peer HT support
> +                */
> +               ht_capabilites |= WL12XX_HT_CAP_HT_OPERRATION;

Typo, OPERATION.


>  /* setup BA session receiver setting in the FW. */
> -int wl1271_acx_set_ba_receiver_session(struct wl1271 *wl, u8 tid_index, u16 ssn,
> -                                       bool enable)
> +int wl1271_acx_set_ba_receiver_session(struct wl1271 *wl, u8 tid_index,
> +                                        u16 ssn, bool enable, u8 peer_hlid)

Indentation.


> -       /* Single link for now */
> -       acx->link_id = 1;
> +       acx->hlid = peer_hlid;
>         acx->tid = tid_index;
>         acx->enable = enable;
> -       acx->win_size = 0;
> +       acx->win_size = RX_BA_WIN_SIZE;

Shouldn't we put this one in the conf structure as well?


> diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
> index ac6194e..ba70f38 100644
> --- a/drivers/net/wireless/wl12xx/acx.h
> +++ b/drivers/net/wireless/wl12xx/acx.h
> @@ -894,33 +894,26 @@ struct wl1271_acx_rssi_snr_avg_weights {
>         u8 rssi_beacon;
>         u8 rssi_data;
>         u8 snr_beacon;
>         u8 snr_data;
>  };
>  
> +
> +/* special capability bit (not employed by the 802.11n spec) */
> +#define WL12XX_HT_CAP_HT_OPERRATION BIT(16)

Same typo as earlier.


> @@ -1215,13 +1191,13 @@ enum {
>         ACX_FRAG_CFG                = 0x004F,
>         ACX_BET_ENABLE              = 0x0050,
>         ACX_RSSI_SNR_TRIGGER        = 0x0051,
>         ACX_RSSI_SNR_WEIGHTS        = 0x0052,
>         ACX_KEEP_ALIVE_MODE         = 0x0053,
>         ACX_SET_KEEP_ALIVE_CONFIG   = 0x0054,
> -       ACX_BA_SESSION_POLICY_CFG   = 0x0055,
> +       ACX_BA_SESSION_INITIATOR_POLICY = 0x0055,

Use ACX_BA_SESSION_INIT_POLICY to keep it small.  Unless you want to
realign all the values.


> @@ -1295,17 +1271,15 @@ int wl1271_acx_rssi_snr_trigger(struct wl1271 *wl, bool enable,
>  int wl1271_acx_rssi_snr_avg_weights(struct wl1271 *wl);
>  int wl1271_acx_set_ht_capabilities(struct wl1271 *wl,
>                                     struct ieee80211_sta_ht_cap *ht_cap,
>                                     bool allow_ht_operation);
>  int wl1271_acx_set_ht_information(struct wl1271 *wl,
>                                    u16 ht_operation_mode);
> -int wl1271_acx_set_ba_session(struct wl1271 *wl,
> -                             enum ieee80211_back_parties direction,
> -                             u8 tid_index, u8 policy);
> -int wl1271_acx_set_ba_receiver_session(struct wl1271 *wl, u8 tid_index, u16 ssn,
> -                                      bool enable);
> +int wl1271_acx_set_ba_initiator_policy(struct wl1271 *wl);
> +int wl1271_acx_set_ba_receiver_session(struct wl1271 *wl, u8 tid_index,
> +                                        u16 ssn, bool enable, u8 peer_hlid);

Indentation.


-- 
Cheers,
Luca.

