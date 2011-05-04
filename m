Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37317 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253Ab1EDUJb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 16:09:31 -0400
Received: by eyx24 with SMTP id 24so468890eyx.19
        for <linux-wireless@vger.kernel.org>; Wed, 04 May 2011 13:09:29 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "Andrew V. Stepanov" <stanv@altlinux.org>
Subject: Re: carl9170.ko RX - DMA, TX - COPY
Date: Wed, 4 May 2011 22:09:29 +0000
Cc: linux-wireless@vger.kernel.org
References: <BANLkTiniamP_zXeGkW2TgatdkSv1+rdfeg@mail.gmail.com> <201105041558.00377.chunkeey@googlemail.com> <BANLkTin3nks48iCQw34kFfMAwT3QyhG08A@mail.gmail.com>
In-Reply-To: <BANLkTin3nks48iCQw34kFfMAwT3QyhG08A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201105042209.29950.chunkeey@googlemail.com> (sfid-20110504_220935_137843_240637E5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 04 May 2011 18:52:58 Andrew V. Stepanov wrote:
> I think it is possible to align SKB frames in carl9170.ko driver.
> 
> rt2800usb do such think in next way:
> 
> void rt2x00queue_align_frame(struct sk_buff *skb)
> {
> 环贩unsigned int frame_length = skb->len;
> 环贩unsigned int align = ALIGN_SIZE(skb, 0);
> 
> 环贩if (!align)
> 环贩环贩return;
> 
> 环贩skb_push(skb, align);
> 环贩memmove(skb->data, skb->data + align, frame_length);
> 环贩skb_trim(skb, frame_length);
> }
> 
> What do you think about this?
No that's wrong, here's the comment from rt2x00queue.c

"When DMA allocation is required we should guarantee to the
 driver that the DMA is aligned to a 4-byte boundary.
 However some drivers require L2 padding to pad the payload
 rather then the header. This could be a requirement for
 PCI and USB devices, while header alignment only is valid
 for PCI devices."

Do you see the difference there; header alignment is only needed
for PCI whereas rt2800usb hw/fw allows just the L2 data to be
padded and sadly AR9170 hw does not have this feature. 

Also, someone <https://patchwork.kernel.org/patch/98997/> added
bounce buffers to musb some time ago, so why not use this approach
instead? The advantage is that you won't need to modify any other
drivers when you will (inevitable) replace the device with a
better one, right?

Regards,
	Chr
