Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:34363 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752099AbeDJSR6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Apr 2018 14:17:58 -0400
Received: by mail-qt0-f194.google.com with SMTP id j17so5991463qtp.1
        for <linux-wireless@vger.kernel.org>; Tue, 10 Apr 2018 11:17:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180410173558.32425-1-daniel@zonque.org>
References: <20180410173558.32425-1-daniel@zonque.org>
From: Ramon Fried <ramon.fried@linaro.org>
Date: Tue, 10 Apr 2018 21:17:57 +0300
Message-ID: <CAODu4NpGnT_j5jWgCrNKFxetJSbgKKvp0LzNZdhZJB68s48JgQ@mail.gmail.com> (sfid-20180410_201802_151106_14DDDF03)
Subject: Re: [PATCH] wcn36xx: use READ_ONCE() to access desc->ctrl
To: Daniel Mack <daniel@zonque.org>
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
        kvalo@codeaurora.org, Ramon Fried <rfried@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 April 2018 at 20:35, Daniel Mack <daniel@zonque.org> wrote:
> When accessing shared memory to check for the stat of submitted
> descriptors, make sure to use READ_ONCE(). This will guarantee the
> compiler treats these memory locations as volatile and doesn't apply
> any caching.
The structure that is tested is not shared memory. It's accessed only
by the apps processor.
In this case, caching does make sense.
I'm not sure regarding READ_ONCE in that context I'll have to do some
reading regarding that.
But I don't think this is right here.

Thanks,
Ramon
>
> While this doesn't fix any particular problem I ran into, it's best
> practice to do it this way.
>
> Note that this patch also removes the superflous extra condition check
> in the do-while loop in reap_tx_dxes(), as the loop will break
> instantly anyway in that case.
>
> Signed-off-by: Daniel Mack <daniel@zonque.org>
> ---
>  drivers/net/wireless/ath/wcn36xx/dxe.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
> index 26e6c42f886a..c52f1c21ece9 100644
> --- a/drivers/net/wireless/ath/wcn36xx/dxe.c
> +++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
> @@ -363,7 +363,7 @@ static void reap_tx_dxes(struct wcn36xx *wcn, struct wcn36xx_dxe_ch *ch)
>         spin_lock_irqsave(&ch->lock, flags);
>         ctl = ch->tail_blk_ctl;
>         do {
> -               if (ctl->desc->ctrl & WCN36xx_DXE_CTRL_VLD)
> +               if (READ_ONCE(ctl->desc->ctrl) & WCN36xx_DXE_CTRL_VLD)
>                         break;
>                 if (ctl->skb) {
>                         dma_unmap_single(wcn->dev, ctl->desc->src_addr_l,
> @@ -382,8 +382,7 @@ static void reap_tx_dxes(struct wcn36xx *wcn, struct wcn36xx_dxe_ch *ch)
>                         ctl->skb = NULL;
>                 }
>                 ctl = ctl->next;
> -       } while (ctl != ch->head_blk_ctl &&
> -              !(ctl->desc->ctrl & WCN36xx_DXE_CTRL_VLD));
> +       } while (ctl != ch->head_blk_ctl);
>
>         ch->tail_blk_ctl = ctl;
>         spin_unlock_irqrestore(&ch->lock, flags);
> @@ -525,7 +524,7 @@ static int wcn36xx_rx_handle_packets(struct wcn36xx *wcn,
>                 int_mask = WCN36XX_DXE_INT_CH3_MASK;
>         }
>
> -       while (!(dxe->ctrl & WCN36xx_DXE_CTRL_VLD)) {
> +       while (!(READ_ONCE(dxe->ctrl) & WCN36xx_DXE_CTRL_VLD)) {
>                 skb = ctl->skb;
>                 dma_addr = dxe->dst_addr_l;
>                 ret = wcn36xx_dxe_fill_skb(wcn->dev, ctl, GFP_ATOMIC);
> --
> 2.14.3
>
