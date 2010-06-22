Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:40363 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641Ab0FVGiH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jun 2010 02:38:07 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 21 Jun 2010 23:38:07 -0700
Date: Tue, 22 Jun 2010 12:08:00 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Vivek Natarajan <Vivek.Natarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k: Modify LED blinking pattern during wifi
	activity.
Message-ID: <20100622063800.GC9292@vasanth-laptop>
References: <1276579217-6837-1-git-send-email-vnatarajan@atheros.com> <1276587140.3648.6.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1276587140.3648.6.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 15, 2010 at 01:02:20PM +0530, Johannes Berg wrote:
> On Tue, 2010-06-15 at 10:50 +0530, Vivek Natarajan wrote:
> 
> >  	case LED_FULL:
> 
> I wonder if you can just use different triggers which may be easier?
> Look at what I suggested earlier for integrating the LEDs with iwlwifi:
> 
> http://thread.gmane.org/gmane.linux.kernel.wireless.general/51218/focus=51520

Sorry for a late reply. LED implementation with ath9k is completely
manual, fully controlled by driver (We have to set/clear a particular
gpio pin to turn on/off the LED every time). on/off period during blink
is based on the number of brightness_set() on tx/rx led trigger. Do
you think your suggested implementation would help in this case too? 

thanks,

Vasanth
