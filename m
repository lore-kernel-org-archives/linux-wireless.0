Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57C5DC282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 11:58:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25D3F206BA
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 11:58:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728546AbfBLL6t (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 06:58:49 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33561 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728041AbfBLL6s (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 06:58:48 -0500
Received: by mail-wr1-f65.google.com with SMTP id i12so2410569wrw.0
        for <linux-wireless@vger.kernel.org>; Tue, 12 Feb 2019 03:58:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MBq4MK1irna6zYc+WgwDk4eBYBJ/c7xw2urAyBWvO+w=;
        b=tGZ9EXWC7SEV1aqSx/oTjZGUD4tY5mKj9KpvDVgof/Ha3LaVvHuzacTVRqI2zPxVmk
         6PxdHxenDwt7+eP2czu4DbYW9kD4ejeYxa+pFd1zB6lRWJNi/umIn1PdDHmZd0Wg3ZRK
         oEAOjvQzkxEyMy0WYphssuTSdediC+hi3Fmm/sHcH2i3i1TOIKBVUHQT3dcSrQ58QTbq
         ji8auDx2QLZaOU0QADJH0S/SNuSoU2RuexA25LIXnK8cPOHlgCEuHodxHZ0q41iDj6PF
         ol/q7fXsv5PlrT/gx09cPyj045r82xwD6Cy52Jeqoyk2q4NYJgTOwUCxPRgyq/ZUSWhv
         l6MA==
X-Gm-Message-State: AHQUAub24gWyn1aJ4J6S2sqJB1AFonBX7r0SxZnCzie72y8T6qcyoKJ8
        6yJ9XDlPD4aRpyXjboWomqGYrg==
X-Google-Smtp-Source: AHgI3IafYduaHimbP98PlzWdrIpqHl4rjD5Co0pR4qgJE5A510a8oEH/Cb63sJONWEUQV46bSlBXcQ==
X-Received: by 2002:a5d:474f:: with SMTP id o15mr2681702wrs.70.1549972726373;
        Tue, 12 Feb 2019 03:58:46 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id e9sm24433114wrc.56.2019.02.12.03.58.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Feb 2019 03:58:45 -0800 (PST)
Date:   Tue, 12 Feb 2019 12:58:43 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Felix Fietkau <nbd@nbd.name>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        USB list <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
Message-ID: <20190212115842.GA24197@localhost.localdomain>
References: <20190211173315.GE6292@redhat.com>
 <Pine.LNX.4.44L0.1902111246410.1543-100000@iolanthe.rowland.org>
 <CAJ0CqmVFVBXi5E07-ZsYojC7mP4ogpwbcDkDTeebHwX+ayz2DQ@mail.gmail.com>
 <20190212093035.GB12906@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190212093035.GB12906@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


[...]

> In usb_sg_init() urb->num_sgs is set 0 for sg_tablesize = 0 controllers.
> In mt76 we set urb->num_sgs to 1. I thought it is fine, but now I think
> this is bug. We can fix that without changing allocation method and
> still use SG allocation. Attached patch do this, please check if it works
> on rpi. Patch is on top of your error path fixes.
> 
> Stanislaw

> From f79ac0df967d406523d0a1c03a138d1394e7665a Mon Sep 17 00:00:00 2001
> From: Stanislaw Gruszka <sgruszka@redhat.com>
> Date: Tue, 12 Feb 2019 10:02:53 +0100
> Subject: [PATCH] mt76usb: do not set urb->num_sgs to 1 for non SG usb host
>  drivers
> 
> Track number of segments in mt76u_buf structure and do not
> submit urbs with urb->num_sgs = 1 if usb host driver
> sg_tablesize is zero.
> 
> This suppose fix problem of mt76 not working with some usb
> host controllers like dwc2.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt76.h |  1 +
>  drivers/net/wireless/mediatek/mt76/usb.c  | 55 ++++++++++++++---------
>  2 files changed, 36 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
> index 2e5bcb3fdff7..eadc913c37b6 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76.h
> +++ b/drivers/net/wireless/mediatek/mt76/mt76.h
> @@ -86,6 +86,7 @@ struct mt76_queue_buf {
>  struct mt76u_buf {
>  	struct mt76_dev *dev;
>  	struct urb *urb;
> +	int num_sgs;
>  	size_t len;
>  	bool done;
>  };
> diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
> index a1811c39415e..d82de59ec6dc 100644
> --- a/drivers/net/wireless/mediatek/mt76/usb.c
> +++ b/drivers/net/wireless/mediatek/mt76/usb.c
> @@ -299,14 +299,14 @@ mt76u_fill_rx_sg(struct mt76_dev *dev, struct mt76u_buf *buf,
>  	if (i < nsgs) {
>  		int j;
>  
> -		for (j = nsgs; j < urb->num_sgs; j++)
> +		for (j = nsgs; j < buf->num_sgs; j++)
>  			skb_free_frag(sg_virt(&urb->sg[j]));
> -		urb->num_sgs = i;
> +		buf->num_sgs = i;
>  	}
>  
> -	urb->num_sgs = max_t(int, i, urb->num_sgs);
> -	buf->len = urb->num_sgs * sglen,
> -	sg_init_marker(urb->sg, urb->num_sgs);
> +	buf->num_sgs = max_t(int, i, buf->num_sgs);
> +	buf->len = buf->num_sgs * sglen,
> +	sg_init_marker(urb->sg, buf->num_sgs);
>  
>  	return i ? : -ENOMEM;
>  }
> @@ -325,6 +325,7 @@ int mt76u_buf_alloc(struct mt76_dev *dev, struct mt76u_buf *buf,
>  
>  	sg_init_table(buf->urb->sg, nsgs);
>  	buf->dev = dev;
> +	buf->num_sgs = nsgs;
>  
>  	return mt76u_fill_rx_sg(dev, buf, nsgs, len, sglen);
>  }
> @@ -336,7 +337,7 @@ void mt76u_buf_free(struct mt76u_buf *buf)
>  	struct scatterlist *sg;
>  	int i;
>  
> -	for (i = 0; i < urb->num_sgs; i++) {
> +	for (i = 0; i < buf->num_sgs; i++) {
>  		sg = &urb->sg[i];
>  		if (!sg)
>  			continue;
> @@ -347,9 +348,10 @@ void mt76u_buf_free(struct mt76u_buf *buf)
>  }
>  EXPORT_SYMBOL_GPL(mt76u_buf_free);
>  
> -int mt76u_submit_buf(struct mt76_dev *dev, int dir, int index,
> -		     struct mt76u_buf *buf, gfp_t gfp,
> -		     usb_complete_t complete_fn, void *context)
> +static void
> +mt76u_fill_bulk_urb(struct mt76_dev *dev, int dir, int index,
> +		    struct mt76u_buf *buf, usb_complete_t complete_fn,
> +		    void *context)
>  {
>  	struct usb_interface *intf = to_usb_interface(dev->dev);
>  	struct usb_device *udev = interface_to_usbdev(intf);
> @@ -360,9 +362,25 @@ int mt76u_submit_buf(struct mt76_dev *dev, int dir, int index,
>  	else
>  		pipe = usb_sndbulkpipe(udev, dev->usb.out_ep[index]);
>  
> -	usb_fill_bulk_urb(buf->urb, udev, pipe, NULL, buf->len,
> -			  complete_fn, context);
> +	usb_fill_bulk_urb(buf->urb, udev, pipe, NULL, buf->len, complete_fn,
> +			  context);
> +
> +	if (udev->bus->sg_tablesize > 0) {
> +		buf->urb->num_sgs = buf->num_sgs;
> +	} else {
> +		WARN_ON_ONCE(buf->num_sgs != 1);
> +		/* See usb_sg_init() */
> +		buf->urb->num_sgs = 0;
> +		if (!PageHighMem(sg_page(buf->urb->sg)))
> +			buf->urb->transfer_buffer = sg_virt(buf->urb->sg);

please correct me if I am wrong but doing so we will use transfer_buffer
for 95% of the use cases, right? If so why not keep it simple and always
use it when sg_tablesize is 0 (avoiding SG I/O)?
Btw this is what I proposed with the RFC series actually :) (always use
transfer_buffer in the usb 2.0 case)

Regards,
Lorenzo

> +	}
> +}
>  
> +int mt76u_submit_buf(struct mt76_dev *dev, int dir, int index,
> +		     struct mt76u_buf *buf, gfp_t gfp,
> +		     usb_complete_t complete_fn, void *context)
> +{
> +	mt76u_fill_bulk_urb(dev, dir, index, buf, complete_fn, context);
>  	return usb_submit_urb(buf->urb, gfp);
>  }
>  EXPORT_SYMBOL_GPL(mt76u_submit_buf);
> @@ -672,10 +690,11 @@ static void mt76u_complete_tx(struct urb *urb)
>  }
>  
>  static int
> -mt76u_tx_build_sg(struct sk_buff *skb, struct urb *urb)
> +mt76u_tx_build_sg(struct sk_buff *skb, struct mt76u_buf *buf)
>  {
>  	int nsgs = 1 + skb_shinfo(skb)->nr_frags;
>  	struct sk_buff *iter;
> +	struct urb *urb = buf->urb;
>  
>  	skb_walk_frags(skb, iter)
>  		nsgs += 1 + skb_shinfo(iter)->nr_frags;
> @@ -684,7 +703,8 @@ mt76u_tx_build_sg(struct sk_buff *skb, struct urb *urb)
>  
>  	nsgs = min_t(int, MT_SG_MAX_SIZE, nsgs);
>  	sg_init_marker(urb->sg, nsgs);
> -	urb->num_sgs = nsgs;
> +	buf->num_sgs = nsgs;
> +	buf->len = skb->len;
>  
>  	return skb_to_sgvec_nomark(skb, urb->sg, 0, skb->len);
>  }
> @@ -694,12 +714,9 @@ mt76u_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
>  		   struct sk_buff *skb, struct mt76_wcid *wcid,
>  		   struct ieee80211_sta *sta)
>  {
> -	struct usb_interface *intf = to_usb_interface(dev->dev);
> -	struct usb_device *udev = interface_to_usbdev(intf);
>  	u8 ep = q2ep(q->hw_idx);
>  	struct mt76u_buf *buf;
>  	u16 idx = q->tail;
> -	unsigned int pipe;
>  	int err;
>  
>  	if (q->queued == q->ndesc)
> @@ -712,13 +729,11 @@ mt76u_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
>  	buf = &q->entry[idx].ubuf;
>  	buf->done = false;
>  
> -	err = mt76u_tx_build_sg(skb, buf->urb);
> +	err = mt76u_tx_build_sg(skb, buf);
>  	if (err < 0)
>  		return err;
>  
> -	pipe = usb_sndbulkpipe(udev, dev->usb.out_ep[ep]);
> -	usb_fill_bulk_urb(buf->urb, udev, pipe, NULL, skb->len,
> -			  mt76u_complete_tx, buf);
> +	mt76u_fill_bulk_urb(dev, USB_DIR_OUT, ep, buf, mt76u_complete_tx, buf);
>  
>  	q->tail = (q->tail + 1) % q->ndesc;
>  	q->entry[idx].skb = skb;
> -- 
> 2.19.2
> 

