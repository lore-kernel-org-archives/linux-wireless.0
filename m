Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:33353 "EHLO
	mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbcGSKiq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 06:38:46 -0400
Received: by mail-pf0-f181.google.com with SMTP id y134so6269088pfg.0
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jul 2016 03:38:46 -0700 (PDT)
Subject: Re: [PATCH 3/4] brcmsmac: Fix invalid memcpy() size in
 brcms_c_d11hdrs_mac80211
To: Florian Fainelli <f.fainelli@gmail.com>,
	brcm80211-dev-list.pdl@broadcom.com
References: <1468884277-18606-1-git-send-email-f.fainelli@gmail.com>
 <1468884277-18606-4-git-send-email-f.fainelli@gmail.com>
Cc: linux-wireless@vger.kernel.org, pieterpg@broadcom.com,
	kvalo@codeaurora.org, hante.meuleman@broadcom.com
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <685abc5d-2e3d-cdce-4849-f7e5beb3309d@broadcom.com> (sfid-20160719_123850_472761_AE2459BD)
Date: Tue, 19 Jul 2016 12:38:40 +0200
MIME-Version: 1.0
In-Reply-To: <1468884277-18606-4-git-send-email-f.fainelli@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19-7-2016 1:24, Florian Fainelli wrote:
> struct ieee80211_rts::ra is only ETH_ALEN wide, yet we attempt to copy 2
> * ETH_ALEN, which will potentially overrun the destination buffer.

NACK - this is intentional. Have to admit it is a bit of trickery.
struct ieee80211_rts is mapped over struct d11txh which is sent to
hardware. The struct is used for both RTS and CTS. Transmitting CTS will
only fill 802.11 addr2 in struct ieee80211_rts::ra. Transmitting RTS
fills 802.11 addr1 in ra and 802.11 addr2 in ta using single memcpy().
Not very clear, but your change is not the way to go here.

Regards,
Arend

> Reported-by: coverity (CID 145657)
> Fixes: 5b435de0d7868 ("net: wireless: add brcm80211 drivers")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
> index c2a938b59044..59813a3666eb 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
> @@ -6671,7 +6671,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
>  			rts->frame_control = cpu_to_le16(IEEE80211_FTYPE_CTL |
>  							 IEEE80211_STYPE_RTS);
>  
> -			memcpy(&rts->ra, &h->addr1, 2 * ETH_ALEN);
> +			memcpy(&rts->ra, &h->addr1, ETH_ALEN);
>  		}
>  
>  		/* mainrate
> 
