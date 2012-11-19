Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46834 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab2KSWjg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 17:39:36 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so1393003eek.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2012 14:39:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1353343170-26516-4-git-send-email-eliad@wizery.com>
References: <1353343170-26516-1-git-send-email-eliad@wizery.com> <1353343170-26516-4-git-send-email-eliad@wizery.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 20 Nov 2012 09:39:15 +1100
Message-ID: <CAGRGNgV=4Lyumy=ivykkEgY=EVRjWM4MWPvGh-uUmPdGyJUxJw@mail.gmail.com> (sfid-20121119_233939_938337_FA7432DD)
Subject: Re: [PATCH 03/15] wlcore: always use sta.hlid
To: Eliad Peller <eliad@wizery.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Eliad,

On Tue, Nov 20, 2012 at 3:39 AM, Eliad Peller <eliad@wizery.com> wrote:
> since we no longer use dev role in the connection flow,
> we should always use the hlid of the sta role.

I don't really know the hardware, but this seems like something
something that should be combined with the first patch.

> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---
>  drivers/net/wireless/ti/wlcore/tx.c |   10 +---------
>  1 files changed, 1 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
> index a90d3cd..a555a70 100644
> --- a/drivers/net/wireless/ti/wlcore/tx.c
> +++ b/drivers/net/wireless/ti/wlcore/tx.c
> @@ -155,21 +155,13 @@ static u8 wl12xx_tx_get_hlid_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif,
>  u8 wl12xx_tx_get_hlid(struct wl1271 *wl, struct wl12xx_vif *wlvif,
>                       struct sk_buff *skb, struct ieee80211_sta *sta)
>  {
> -       struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
> -
>         if (!wlvif || wl12xx_is_dummy_packet(wl, skb))
>                 return wl->system_hlid;
>
>         if (wlvif->bss_type == BSS_TYPE_AP_BSS)
>                 return wl12xx_tx_get_hlid_ap(wl, wlvif, skb, sta);
>
> -       if ((test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags) ||
> -            test_bit(WLVIF_FLAG_IBSS_JOINED, &wlvif->flags)) &&
> -           !ieee80211_is_auth(hdr->frame_control) &&
> -           !ieee80211_is_assoc_req(hdr->frame_control))
> -               return wlvif->sta.hlid;
> -       else
> -               return wlvif->dev_hlid;
> +       return wlvif->sta.hlid;
>  }
>
>  unsigned int wlcore_calc_packet_alignment(struct wl1271 *wl,
> --
> 1.7.6.401.g6a319
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
