Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:45166 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab0LCVSV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Dec 2010 16:18:21 -0500
Date: Fri, 3 Dec 2010 13:15:57 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Meelis Roos <mroos@linux.ee>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Richard Purdie <rpurdie@rpsys.net>
Subject: Re: link failure with led_brightness_set - dependencies?
Message-Id: <20101203131557.5f7d497f.randy.dunlap@oracle.com>
In-Reply-To: <alpine.SOC.1.00.1012032204150.26842@math.ut.ee>
References: <alpine.SOC.1.00.1012032204150.26842@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 3 Dec 2010 22:39:23 +0200 (EET) Meelis Roos wrote:

> Tried to compile 2.6.37-rc4+git on sparc64 and got this failure during 
> linking:

Does that include this recent commit for this problem?

http://marc.info/?l=git-commits-head&m=129134154722155&w=2


>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `led_trigger_set':
> (.text+0xa48cc): undefined reference to `led_brightness_set'
> 
> It seems MAC80211_LEDS select LEDS_TRIGGERS automatically without me 
> having selected LEDS manually - only Wireless stack LED triggers.
> EXPORT_SYMBOL(led_brightness_set) is in led-calss.c so maybe 
> MAC80211_LEDS needs to select LEDS_CLASS too (or instead)?


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
