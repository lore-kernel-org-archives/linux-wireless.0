Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:41085 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbbJDUyl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Oct 2015 16:54:41 -0400
Message-ID: <5611920D.60500@broadcom.com> (sfid-20151004_225501_741668_A756414A)
Date: Sun, 4 Oct 2015 22:54:37 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Nicholas Krause <xerofoify@gmail.com>, <brudley@broadcom.com>
CC: <frankyl@broadcom.com>, <meuleman@broadcom.com>,
	<kvalo@codeaurora.org>, <pieterpg@broadcom.com>,
	<linux-wireless@vger.kernel.org>,
	<brcm80211-dev-list@broadcom.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] brcm80211:Fix locking region in the function  brcmf_sdio_sendfromq
References: <1443889148-22678-1-git-send-email-xerofoify@gmail.com>
In-Reply-To: <1443889148-22678-1-git-send-email-xerofoify@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/03/2015 06:19 PM, Nicholas Krause wrote:
> This fixes the locking region in the function brcmf_sdio_sendfromq
> to properly lock around the call to the function brcmrf_sdio_txpkt
> in order to avoid concurrent access issues when calling this
> function as stated in the function's comments about the caller
> being required to lock around the call to this particular function.
>
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>   drivers/net/wireless/brcm80211/brcmfmac/sdio.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
> index f990e3d..da59683 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
> @@ -2388,11 +2388,11 @@ static uint brcmf_sdio_sendfromq(struct brcmf_sdio *bus, uint maxframes)
>   				break;
>   			__skb_queue_tail(&pktq, pkt);
>   		}
> -		spin_unlock_bh(&bus->txq_lock);
>   		if (i == 0)
>   			break;

So what if we break here. Seems you need to do unlock if i == 0 here.

Regards,
Arend

>
>   		ret = brcmf_sdio_txpkt(bus, &pktq, SDPCM_DATA_CHANNEL);
> +		spin_unlock_bh(&bus->txq_lock);
>
>   		cnt += i;
>
>

