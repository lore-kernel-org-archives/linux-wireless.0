Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:33088 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377Ab1GPJXo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jul 2011 05:23:44 -0400
To: ali@internetdog.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: r8712u: Most return-values changed from -1 to proper errno macros.
References: <20110703010605.GA3736@internetdog.org>
	<1310749876-32632-1-git-send-email-ali@internetDog.org>
	<1310749876-32632-2-git-send-email-ali@internetDog.org>
	<4E20AA5A.6020101@lwfinger.net>
	<20110716032100.GA3274@internetdog.org>
From: Kalle Valo <kvalo@adurom.com>
Date: Sat, 16 Jul 2011 12:23:42 +0300
In-Reply-To: <20110716032100.GA3274@internetdog.org> (Ali Bahar's message of "Sat\, 16 Jul 2011 11\:21\:01 +0800")
Message-ID: <87zkkevash.fsf@purkki.adurom.net> (sfid-20110716_112354_005105_E19637FD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ali Bahar <ali@internetdog.org> writes:

> I am aware of the current state of the Linux code's documentation.
> Habitually, I comment the big-picture as I go along. Industry
> practice wrt comments differs from Linux's, of course. The comments
> were in the function heads, not in the bodies, as per
> Documentation/CodingStyle. The big-picture of the functions is clear
> once you are familiar enough to begin to modify the code. However,
> and especially for linux, code is read a thousand times for every
> time it is written. Most eyeballs could do with a line or two of
> explanation. To me, Documentation/kernel-docs.txt echoed the need
> for a big-picture view. 

The problem with comments is that they quickly get out of date
(usually people change the code but forget the comments). It's better
to write code so that everyone understands and, like Larry said, only
the cases which are not obvious need comments.

> If the goal is to attract more developers (as it is at least Greg
> KH's intent), then Linux's code-base has a long way to go. I meant
> only to start chipping away at the task.

There's always a maintenance cost, even on code comments. If we start
documenting every piece of code, we would have a lot less time writing
the actual code. So there needs to be a trade-off and in Linux it has
been that code should be of good quality so that it's easy to read for
everyone but there will be less comments.

And personally I will always choose good code with few comments over
crappy code with full of comments. So IMHO the style decision made in
Linux kernel has been a good one.

Of course I'm not saying that there should not be any comments. It's
very important to document public interfaces, like mac80211.h and
sdio_func.h, as these are used by a lot of people. 

Also having a general overview how a component/driver works would not
be bad at all, it just should just not clutter the code. That could be
in the beginning of the file or maybe in a separate file. But as I
said, they will easily get obsolete.

-- 
Kalle Valo
