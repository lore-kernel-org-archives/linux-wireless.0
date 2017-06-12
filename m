Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:36100 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751969AbdFLLcz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Jun 2017 07:32:55 -0400
Received: by mail-wr0-f174.google.com with SMTP id v111so93349279wrc.3
        for <linux-wireless@vger.kernel.org>; Mon, 12 Jun 2017 04:32:55 -0700 (PDT)
Subject: Re: [PATCH V3] brcmfmac: Fix glom_skb leak in brcmf_sdiod_recv_chain
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, "Peter S. Housel" <housel@acm.org>
References: <1497264382-2290-1-git-send-email-arend.vanspriel@broadcom.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <78a8b9d2-4688-051b-26ce-df447530fa30@broadcom.com> (sfid-20170612_133258_897581_3982C7B1)
Date: Mon, 12 Jun 2017 13:32:52 +0200
MIME-Version: 1.0
In-Reply-To: <1497264382-2290-1-git-send-email-arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/12/2017 12:46 PM, Arend van Spriel wrote:
> From: "Peter S. Housel" <housel@acm.org>
> 
> An earlier change to this function (3bdae810721b) fixed a leak in the
> case of an unsuccessful call to brcmf_sdiod_buffrw(). However, the
> glom_skb buffer, used for emulating a scattering read, is never used
> or referenced after its contents are copied into the destination
> buffers, and therefore always needs to be freed by the end of the
> function.
> 

Kalle,

Can you add stable tag:

Cc: stable@vger.kernel.org # 4.9.x-
> Fixes: 3bdae810721b ("brcmfmac: Fix glob_skb leak in brcmf_sdiod_recv_chain")
> Fixes: a413e39a38573 ("brcmfmac: fix brcmf_sdcard_recv_chain() for host without sg support")
> Signed-off-by: Peter S. Housel <housel@acm.org>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> ---
>   changes:
>    V2:
>     - avoid goto using if (!err) {}.
>    V3:
>     - free glom_skb at done label.
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> index 9b970dc..844c1e6 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> @@ -706,7 +706,7 @@ int brcmf_sdiod_recv_pkt(struct brcmf_sdio_dev *sdiodev, struct sk_buff *pkt)
>   int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev,
>   			   struct sk_buff_head *pktq, uint totlen)
>   {
> -	struct sk_buff *glom_skb;
> +	struct sk_buff *glom_skb = NULL;
>   	struct sk_buff *skb;
>   	u32 addr = sdiodev->sbwad;
>   	int err = 0;
> @@ -727,10 +727,8 @@ int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev,
>   			return -ENOMEM;
>   		err = brcmf_sdiod_buffrw(sdiodev, SDIO_FUNC_2, false, addr,
>   					 glom_skb);
> -		if (err) {
> -			brcmu_pkt_buf_free_skb(glom_skb);
> +		if (err)
>   			goto done;
> -		}
>   
>   		skb_queue_walk(pktq, skb) {
>   			memcpy(skb->data, glom_skb->data, skb->len);
> @@ -741,6 +739,7 @@ int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev,
>   					    pktq);
>   
>   done:
> +	brcmu_pkt_buf_free_skb(glom_skb);
>   	return err;
>   }
>   
> 
