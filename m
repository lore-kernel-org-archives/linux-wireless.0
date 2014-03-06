Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:40720 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbaCFSCW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2014 13:02:22 -0500
Message-ID: <5318B82B.5050008@broadcom.com> (sfid-20140306_190226_121638_EAE8F58F)
Date: Thu, 6 Mar 2014 19:02:19 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	<linville@tuxdriver.com>, <linux-coverity@vger.kernel.org>
Subject: Re: brcmfmac: fix skb leak in brcmf_sdio_txpkt_prep_sg error path.
References: <20140305192636.D06AA660D72@gitolite.kernel.org> <20140306060936.GB26578@redhat.com> <53183722.7000301@broadcom.com> <20140306170354.GA31372@redhat.com>
In-Reply-To: <20140306170354.GA31372@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

- netdev
+ linux-wireless

On 03/06/14 18:03, Dave Jones wrote:
> Commit 1eb4301867 added an allocation of an skb via brcmu_pkt_buf_get_skb()
> but forgot to free it on one of the error paths.
>
- Cc: Arend van Spriel<arend@broadcom.com>
+ Acked-by: Arend van Spriel <arend@broadcom.com
> Signed-off-by: Dave Jones<davej@fedoraproject.org>
---
I guess you intend John to take this patch, right?

Regards,
Arend

> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
> index 119ee6eaf1c3..ddaa9efd053d 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
> @@ -1948,8 +1948,10 @@ static int brcmf_sdio_txpkt_prep_sg(struct brcmf_sdio *bus,
>   		if (pkt_pad == NULL)
>   			return -ENOMEM;
>   		ret = brcmf_sdio_txpkt_hdalign(bus, pkt_pad);
> -		if (unlikely(ret<  0))
> +		if (unlikely(ret<  0)) {
> +			kfree_skb(pkt_pad);
>   			return ret;
> +		}
>   		memcpy(pkt_pad->data,
>   		       pkt->data + pkt->len - tail_chop,
>   		       tail_chop);
>
>

