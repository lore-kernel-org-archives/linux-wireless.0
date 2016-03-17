Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:34474 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031417AbcCQP00 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 11:26:26 -0400
Received: by mail-wm0-f48.google.com with SMTP id p65so31189477wmp.1
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2016 08:26:25 -0700 (PDT)
Date: Thu, 17 Mar 2016 16:26:22 +0100
From: Vishal Thanki <vishalthanki@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: helmut.schaa@googlemail.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] rt2x00usb: Use usb anchor to manage URB
Message-ID: <20160317152620.GC12775@c50.bag.software> (sfid-20160317_162629_445758_D7A41960)
References: <1458215759-12641-1-git-send-email-vishalthanki@gmail.com>
 <20160317145642.GA2846@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160317145642.GA2846@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 17, 2016 at 03:56:43PM +0100, Stanislaw Gruszka wrote:
> On Thu, Mar 17, 2016 at 12:55:59PM +0100, Vishal Thanki wrote:
> > @@ -840,6 +857,8 @@ void rt2x00usb_disconnect(struct usb_interface *usb_intf)
> >  	struct ieee80211_hw *hw = usb_get_intfdata(usb_intf);
> >  	struct rt2x00_dev *rt2x00dev = hw->priv;
> >  
> > +	usb_kill_anchored_urbs(rt2x00dev->anchor);
> 
> Driver can still submit urb's after that. This should be placed
> after we disable radio and flush queues and race conditions with
> hrtimer rt2800usb_tx_sta_fifo_timeout() should be handled.
> 

I think rt2x00usb_uninitialize() is a good place which gets called from
rt2x00lib_remove_dev() and is called after the radio is disabled,
timer is stopped, workqueue is destroyed and tasklets are killed. Please
let me know if there is a better suggestion.

Vishal

> Stanislaw
