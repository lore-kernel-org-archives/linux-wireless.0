Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:37145 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084AbcCQJxW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 05:53:22 -0400
Received: by mail-wm0-f50.google.com with SMTP id p65so108865297wmp.0
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2016 02:53:22 -0700 (PDT)
Date: Thu, 17 Mar 2016 10:53:18 +0100
From: Vishal Thanki <vishalthanki@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: helmut.schaa@googlemail.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt2x00usb: Use usb anchors to manage URB
Message-ID: <20160317095317.GA6518@c50.bag.software> (sfid-20160317_105327_253759_7F1979E4)
References: <1458149331-2106-1-git-send-email-vishalthanki@gmail.com>
 <20160317084331.GA19458@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160317084331.GA19458@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, Mar 17, 2016 at 09:43:32AM +0100, Stanislaw Gruszka wrote:
> Hi
> 
> On Wed, Mar 16, 2016 at 06:28:51PM +0100, Vishal Thanki wrote:
> > +struct rt2x00usb_anchors {
> > +	struct usb_anchor async_urb;
> > +	struct usb_anchor tx_submitted;
> > +	struct usb_anchor rx_submitted;
> > +};
> 
> I don't think we need 3 different usb_anchor's, one should be
> enough.
> 

Ok, I will change that.

> > +static struct rt2x00usb_anchors *anchors;
> 
> usb_anchor structure should be embedded in rt2x00_dev structure,
> otherwise you can kill urb's from other rt2x00 devices, when
> disconnecting another one.
> 

rt2x00_dev structure does not contain any bus specific data structures
(for example no structures present for USB/PCI). Should I add a void
*ptr in rt2x00_dev and cast it as usb_anchor in rt2x00usb.c?

Thanks,
Vishal

> Stanislaw
