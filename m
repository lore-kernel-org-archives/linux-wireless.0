Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753560AbcCRKY5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2016 06:24:57 -0400
Date: Fri, 18 Mar 2016 11:22:39 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Vishal Thanki <vishalthanki@gmail.com>
Cc: helmut.schaa@googlemail.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] rt2x00usb: Use usb anchor to manage URB
Message-ID: <20160318102239.GA24990@redhat.com> (sfid-20160318_112501_041076_B7521CB3)
References: <1458215759-12641-1-git-send-email-vishalthanki@gmail.com>
 <20160317145642.GA2846@redhat.com>
 <20160317152620.GC12775@c50.bag.software>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160317152620.GC12775@c50.bag.software>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 17, 2016 at 04:26:22PM +0100, Vishal Thanki wrote:
> On Thu, Mar 17, 2016 at 03:56:43PM +0100, Stanislaw Gruszka wrote:
> > On Thu, Mar 17, 2016 at 12:55:59PM +0100, Vishal Thanki wrote:
> > > @@ -840,6 +857,8 @@ void rt2x00usb_disconnect(struct usb_interface *usb_intf)
> > >  	struct ieee80211_hw *hw = usb_get_intfdata(usb_intf);
> > >  	struct rt2x00_dev *rt2x00dev = hw->priv;
> > >  
> > > +	usb_kill_anchored_urbs(rt2x00dev->anchor);
> > 
> > Driver can still submit urb's after that. This should be placed
> > after we disable radio and flush queues and race conditions with
> > hrtimer rt2800usb_tx_sta_fifo_timeout() should be handled.
> > 
> 
> I think rt2x00usb_uninitialize() is a good place which gets called from
> rt2x00lib_remove_dev() and is called after the radio is disabled,
> timer is stopped, workqueue is destroyed and tasklets are killed. Please
> let me know if there is a better suggestion.

Since rt2800usb_tx_sta_fifo_read_completed() can queue txdone_work
to rt2x00dev->workqueue, killing urb's should be done before destroying
workqueue (and also before free kfifo).

Stanislaw
