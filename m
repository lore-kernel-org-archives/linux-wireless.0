Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39197 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab0FVHBc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jun 2010 03:01:32 -0400
Subject: Re: [PATCH] ath9k: Modify LED blinking pattern during wifi
 activity.
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: Vivek Natarajan <Vivek.Natarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20100622063800.GC9292@vasanth-laptop>
References: <1276579217-6837-1-git-send-email-vnatarajan@atheros.com>
	 <1276587140.3648.6.camel@jlt3.sipsolutions.net>
	 <20100622063800.GC9292@vasanth-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Jun 2010 09:01:27 +0200
Message-ID: <1277190087.3637.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-06-22 at 12:08 +0530, Vasanthakumar Thiagarajan wrote:

> > http://thread.gmane.org/gmane.linux.kernel.wireless.general/51218/focus=51520
> 
> Sorry for a late reply. LED implementation with ath9k is completely
> manual, fully controlled by driver (We have to set/clear a particular
> gpio pin to turn on/off the LED every time). on/off period during blink
> is based on the number of brightness_set() on tx/rx led trigger. Do
> you think your suggested implementation would help in this case too? 

I'm not sure. I was mostly describing the use in iwlwifi, and since I
don't know how ath9k works I can't really comment much. It just seemed
to me that the driver was also hard-coding the behaviour of the LEDs,
which the user in that thread didn't like for iwlwifi, so integrating
with the LED trigger stuff could be worthwhile for ath9k? Or maybe it
does and I'm reading the patches incorrectly.

johannes

