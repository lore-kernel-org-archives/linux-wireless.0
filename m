Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:34594 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932827AbZJ3SoQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2009 14:44:16 -0400
Received: by ewy28 with SMTP id 28so3310768ewy.18
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2009 11:44:20 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] libertas if_usb: Fix crash on 64-bit machines
Date: Fri, 30 Oct 2009 19:44:14 +0100
Cc: David Woodhouse <dwmw2@infradead.org>, linville@tuxdriver.com,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	dcbw@redhat.com, stern@rowland.harvard.edu, davem@davemloft.net
References: <1256924714.4030.44.camel@macbook.infradead.org> <4AEB2F13.50102@lwfinger.net>
In-Reply-To: <4AEB2F13.50102@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <200910301944.14740.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 30 October 2009 19:23:15 Larry Finger wrote:
> David Woodhouse wrote:
> > On a 64-bit kernel, skb->tail is an offset, not a pointer. The libertas
> > usb driver passes it to usb_fill_bulk_urb() anyway, causing interesting
> > crashes. Fix that by using skb->data instead.
> > 
> > This highlights a problem with usb_fill_bulk_urb(). It doesn't notice
> > when dma_map_single() fails and return the error to its caller as it
> > should. In fact it _can't_ currently return the error, since it returns
> > void.
> 
> This should be fixed. If changing the code to return the error would
> be too invasive (It is used in 30+ drivers), perhaps the routine
> should be modified to log a warning when dma mapping fails. I will
> submit an RFC to do that.

err, hold on a sec:


 - include/linux/usb.h -

static inline void usb_fill_bulk_urb(struct urb *urb,
                                     struct usb_device *dev,
                                     unsigned int pipe,
                                     void *transfer_buffer,
                                     int buffer_length,
                                     usb_complete_t complete_fn,
                                     void *context)
{
        urb->dev = dev;
        urb->pipe = pipe;
        urb->transfer_buffer = transfer_buffer;
        urb->transfer_buffer_length = buffer_length;
        urb->complete = complete_fn;
        urb->context = context;
}

that's just a fill-in macro.
AFAICT usb_submit_urb does the tricky dma mapping.

Regards,
	Chr
