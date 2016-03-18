Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753766AbcCRKbr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2016 06:31:47 -0400
Date: Fri, 18 Mar 2016 11:29:30 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Vishal Thanki <vishalthanki@gmail.com>
Cc: helmut.schaa@googlemail.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3] rt2x00usb: Use usb anchor to manage URB
Message-ID: <20160318102929.GB24990@redhat.com> (sfid-20160318_113151_310052_84B6B3FC)
References: <1458289836-7219-1-git-send-email-vishalthanki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1458289836-7219-1-git-send-email-vishalthanki@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 18, 2016 at 09:30:36AM +0100, Vishal Thanki wrote:
> @@ -734,6 +744,8 @@ void rt2x00usb_uninitialize(struct rt2x00_dev *rt2x00dev)
>  {
>  	struct data_queue *queue;
>  
> +	usb_kill_anchored_urbs(rt2x00dev->anchor);

As already pointed in different email this is not good place either ...

This should be placed in rt2x00lib_remove_dev() i.e:

       if (rt2x00_is_usb(rt2x00dev)) {
		usb_kill_anchored_urbs(rt2x00dev->anchor);
                hrtimer_cancel(&rt2x00dev->txstatus_timer);
                cancel_work_sync(&rt2x00dev->rxdone_work);
                cancel_work_sync(&rt2x00dev->txdone_work);
       }

Since queues are flushed, hrtimer and works will not rearm, so
this should be enough to stop the driver properly.

Stanislaw
