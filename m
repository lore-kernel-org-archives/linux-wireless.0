Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx07-00252a01.pphosted.com ([62.209.51.214]:44767 "EHLO
        mx07-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1428794AbdDYJgt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 05:36:49 -0400
Received: from pps.filterd (m0102628.ppops.net [127.0.0.1])
        by mx07-00252a01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3P9ZVrj032502
        for <linux-wireless@vger.kernel.org>; Tue, 25 Apr 2017 10:36:47 +0100
Received: from mail-wr0-f197.google.com (mail-wr0-f197.google.com [209.85.128.197])
        by mx07-00252a01.pphosted.com with ESMTP id 29yvjysgbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-wireless@vger.kernel.org>; Tue, 25 Apr 2017 10:36:47 +0100
Received: by mail-wr0-f197.google.com with SMTP id q91so4414217wrb.8
        for <linux-wireless@vger.kernel.org>; Tue, 25 Apr 2017 02:36:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1493111408-27692-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1493111408-27692-1-git-send-email-arend.vanspriel@broadcom.com>
From: James Hughes <james.hughes@raspberrypi.org>
Date: Tue, 25 Apr 2017 10:36:46 +0100
Message-ID: <CAE_XsML=O-Ga9VXxifuE_rUqG47uKVyjwSHGXNSMorPa6340Og@mail.gmail.com> (sfid-20170425_113738_232012_52CF9486)
Subject: Re: [PATCH] ath6kl: assure headroom of skbuff is writable in .start_xmit()
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 April 2017 at 10:10, Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
> An issue was found brcmfmac driver in which a skbuff in .start_xmit()
> callback was actually cloned. So instead of checking for sufficient
> headroom it should also be writable. Hence use skb_cow_head() to
> check and expand the headroom appropriately.
>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> ---
> Hi Kalle,
>
> Did a recursive grep in drivers/net/wireless and found a similar
> case in ath6kl. I do not have the hardware to test so this is
> only compile tested.
>
> Regards,
> Arend
> ---
>  drivers/net/wireless/ath/ath6kl/txrx.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
> index a531e0c..e6b2517 100644
> --- a/drivers/net/wireless/ath/ath6kl/txrx.c
> +++ b/drivers/net/wireless/ath/ath6kl/txrx.c
> @@ -399,15 +399,10 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
>                         csum_dest = skb->csum_offset + csum_start;
>                 }
>
> -               if (skb_headroom(skb) < dev->needed_headroom) {
> -                       struct sk_buff *tmp_skb = skb;
> -
> -                       skb = skb_realloc_headroom(skb, dev->needed_headroom);
> -                       kfree_skb(tmp_skb);
> -                       if (skb == NULL) {
> -                               dev->stats.tx_dropped++;
> -                               return 0;
> -                       }
> +               if (skb_cow_head(skb, dev->needed_headroom)) {
> +                       dev->stats.tx_dropped++;
> +                       kfree_skb(skb);
> +                       return 0;
>                 }
>
>                 if (ath6kl_wmi_dix_2_dot3(ar->wmi, skb)) {
> --
> 1.9.1
>

Not sure if this is the right place to comment on this, but I've had a
quick look around various network drivers, and there are similar
constructs in a LOT of drivers. I've picked two at random, and both
seem to show this issue. When the issue first came up in a USB
attached smsc ethernet driver, at least 6 other drivers with similar
faults were found in the net/usb tree.  Now I could just be being
paranoid, and am missing something, so here are the files I looked
at...

drivers/net/marvell/mwifiex/uap_txrx.c line 161 - no relevant skb_cow
operations in this file, but changes are made to the buffers
/drivers/net/ethernet/sun/niu.c line 6657 - ditto

I'm a bit of a beginner at this stuff, so not sure how this should be
taken forward.

James
