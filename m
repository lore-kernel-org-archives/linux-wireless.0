Return-Path: <SRS0=+yu+=PF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C709C43387
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Dec 2018 13:34:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E13020879
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Dec 2018 13:34:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729384AbeL1NeR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Dec 2018 08:34:17 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:42105 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727249AbeL1NeQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Dec 2018 08:34:16 -0500
Received: by mail-io1-f65.google.com with SMTP id x6so16743420ioa.9
        for <linux-wireless@vger.kernel.org>; Fri, 28 Dec 2018 05:34:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B0f/eLDh9T8YdCl02BPQwyDt2helXcHGNszZP1wmyIY=;
        b=KBxFmb2K19u0GuOmXRt2xRSZUN5mewusX1X2DsQbRHflBYCmAcB5zgvpCvX0j2JVfd
         /6JgVgjPm/z5GHNf/zZWjNXrEWxg4MDq6fTQGBGdtL1rL2pbyImm9NJ3uAr3dIYaB19F
         jAVctqxjx0uoN/2VZ+ajINYQRelqLsAsFrQK4kpmWwZ2jEkYQbj/auzWyjWTtl1BBM9r
         iberHKn+4V3m1tA/UJ7X0mwMQ1VPqni64x7oWICyGLk3+UmMWwBcvoh26jnYdsRs8p5p
         0MQAbTeeltEHlRJsPU0xWGElD3ReqBv3/zvDIUzEWFj3N957w2IF/aRQFVd0n1g+aP93
         /phg==
X-Gm-Message-State: AJcUukdkpE/MZbRRJ7TjcGXxZl70fKbRt7g/q172AVxVqR57uVoC45RI
        +J3VR0QgryfUlpOpsBWs/if80i4vPdt6brcywvxYJjNY
X-Google-Smtp-Source: ALg8bN6eVDACL2iVBeALQfXPDyZU8kgjAkZzQhrl6JYsdP+D29ZcB+tjhuRAFWJBVNMRCvPW1vY/W3zDEir/79D62MU=
X-Received: by 2002:a5d:980b:: with SMTP id a11mr2990255iol.181.1546004055754;
 Fri, 28 Dec 2018 05:34:15 -0800 (PST)
MIME-Version: 1.0
References: <cover.1543846816.git.lorenzo.bianconi@redhat.com> <0583d3f607ef493df9a2ff12bbe773174008027d.1543846816.git.lorenzo.bianconi@redhat.com>
In-Reply-To: <0583d3f607ef493df9a2ff12bbe773174008027d.1543846816.git.lorenzo.bianconi@redhat.com>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Fri, 28 Dec 2018 14:34:07 +0100
Message-ID: <CAJ0CqmXRdxpJ5dmcGVh6-zqTzC77-iW7DN+H1RUmpbiw+P1GSw@mail.gmail.com>
Subject: Re: [PATCH 1/2] mt76: dma: do not build skb if reported len does not
 fit in buf_size
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>
> Precompute data length in order to avoid to allocate the related
> skb data structure if reported length does not fit in queue buf_size
>
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> ---
>  drivers/net/wireless/mediatek/mt76/dma.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
> index b7fd2e110663..1db163c40dcf 100644
> --- a/drivers/net/wireless/mediatek/mt76/dma.c
> +++ b/drivers/net/wireless/mediatek/mt76/dma.c
> @@ -417,10 +417,9 @@ mt76_add_fragment(struct mt76_dev *dev, struct mt76_queue *q, void *data,
>  static int
>  mt76_dma_rx_process(struct mt76_dev *dev, struct mt76_queue *q, int budget)
>  {
> +       int len, data_len, done = 0;
>         struct sk_buff *skb;
>         unsigned char *data;
> -       int len;
> -       int done = 0;
>         bool more;
>
>         while (done < budget) {
> @@ -430,7 +429,12 @@ mt76_dma_rx_process(struct mt76_dev *dev, struct mt76_queue *q, int budget)
>                 if (!data)
>                         break;
>
> -               if (q->buf_size < len + q->buf_offset) {
> +               if (q->rx_head)
> +                       data_len = q->buf_size;
> +               else
> +                       data_len = SKB_WITH_OVERHEAD(q->buf_size);
> +
> +               if (data_len < len + q->buf_offset) {
>                         dev_kfree_skb(q->rx_head);
>                         q->rx_head = NULL;
>
> @@ -448,12 +452,7 @@ mt76_dma_rx_process(struct mt76_dev *dev, struct mt76_queue *q, int budget)
>                         skb_free_frag(data);
>                         continue;
>                 }
> -
>                 skb_reserve(skb, q->buf_offset);
> -               if (skb->tail + len > skb->end) {
> -                       dev_kfree_skb(skb);
> -                       continue;
> -               }
>
>                 if (q == &dev->q_rx[MT_RXQ_MCU]) {
>                         u32 *rxfce = (u32 *) skb->cb;
> --
> 2.19.2
>

Hi Felix,

what about this patch?

Regards,
Lorenzo
