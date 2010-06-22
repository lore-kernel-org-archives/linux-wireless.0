Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:41897 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759055Ab0FVJad (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jun 2010 05:30:33 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 22 Jun 2010 02:30:33 -0700
Date: Tue, 22 Jun 2010 15:00:26 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	Vivek Natarajan <Vivek.Natarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k: Modify LED blinking pattern during wifi
	activity.
Message-ID: <20100622093026.GD9292@vasanth-laptop>
References: <1276579217-6837-1-git-send-email-vnatarajan@atheros.com> <1276587140.3648.6.camel@jlt3.sipsolutions.net> <20100622063800.GC9292@vasanth-laptop> <1277190087.3637.7.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1277190087.3637.7.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 22, 2010 at 12:31:27PM +0530, Johannes Berg wrote:
> On Tue, 2010-06-22 at 12:08 +0530, Vasanthakumar Thiagarajan wrote:
> 
> > > http://thread.gmane.org/gmane.linux.kernel.wireless.general/51218/focus=51520
> > 
> > Sorry for a late reply. LED implementation with ath9k is completely
> > manual, fully controlled by driver (We have to set/clear a particular
> > gpio pin to turn on/off the LED every time). on/off period during blink
> > is based on the number of brightness_set() on tx/rx led trigger. Do
> > you think your suggested implementation would help in this case too? 
> 
> I'm not sure. I was mostly describing the use in iwlwifi, and since I
> don't know how ath9k works I can't really comment much.

With ath9k hw itself does not blink LED based on the traffic, it is
the driver which turns on/off LED based on tx/rx.

> It just seemed 
> to me that the driver was also hard-coding the behaviour of the LEDs,
> which the user in that thread didn't like for iwlwifi.

Yeah, before Vivek's patch the driver was hard-coding the LED
behaviour. After this patch, the behaviour would be based on
a modparam.

> so integrating
> with the LED trigger stuff could be worthwhile for ath9k? Or maybe it
> does and I'm reading the patches incorrectly.

The existing LED implementation looks simple. As the blink rate is
determined in driver dynamically, I'm not quite sure integrating LED
trigger, would review this in detail later.

Vasanth
