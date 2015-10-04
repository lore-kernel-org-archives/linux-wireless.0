Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:49130 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbbJDVBt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Oct 2015 17:01:49 -0400
Message-ID: <561193AD.7080904@broadcom.com> (sfid-20151004_230207_851362_96FC7B69)
Date: Sun, 4 Oct 2015 23:01:33 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Nicholas Krause <xerofoify@gmail.com>, <brudley@broadcom.com>
CC: <frankyl@broadcom.com>, <meuleman@broadcom.com>,
	<kvalo@codeaurora.org>, <pieterpg@broadcom.com>,
	<linux-wireless@vger.kernel.org>,
	<brcm80211-dev-list@broadcom.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] brcm80211:Use proper skb wrapper function in the function
 brcmf_sdio_txpkt_postp
References: <1443846257-21038-1-git-send-email-xerofoify@gmail.com>
In-Reply-To: <1443846257-21038-1-git-send-email-xerofoify@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/03/2015 06:24 AM, Nicholas Krause wrote:
> This uses the proper skb wrapper function sk_unlink in the function
> brcmf_sdio_txpkt_postp to properly protect against concurrent users
> accessing this skb_buff pointer or skb_buff_head pointer by locking
> the spinlock as part of the passed skb_buff_head's definition due to
> neither this function nor its callers locking this spinlock before
> calling skb_unlink in order to avoid possible concurrent access on
> either of these possibly shared structure pointers.
>
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>   drivers/net/wireless/brcm80211/brcmfmac/sdio.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
> index f990e3d..6b66542 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
> @@ -2308,7 +2308,7 @@ brcmf_sdio_txpkt_postp(struct brcmf_sdio *bus, struct sk_buff_head *pktq)
>   				pkt_prev = pkt_next->prev;
>   				skb_put(pkt_prev, chop_len);
>   			}
> -			__skb_unlink(pkt_next, pktq);
> +			skb_unlink(pkt_next, pktq);

Not sure what issue you are trying to solve here. I am pretty sure I 
used __skb_unlink here on purpose. To my knowledge there is no 
concurrency issue so please elaborate. Your commit message seems a bit 
hypothetical.

Regards,
Arend

>   			brcmu_pkt_buf_free_skb(pkt_next);
>   		} else {
>   			hdr = pkt_next->data + bus->tx_hdrlen - SDPCM_SWHDR_LEN;
>

