Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:39703 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297AbZFFJe5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Jun 2009 05:34:57 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC V2] b43/legacy: port to cfg80211 rfkill
Date: Sat, 6 Jun 2009 11:34:47 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
References: <4a2961a7.RxVbjEA4JdOf01BF%Larry.Finger@lwfinger.net> <200906052338.05653.mb@bu3sch.de> <1244241126.15640.3.camel@johannes.local>
In-Reply-To: <1244241126.15640.3.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200906061134.47483.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 06 June 2009 00:32:06 Johannes Berg wrote:
> On Fri, 2009-06-05 at 23:38 +0200, Michael Buesch wrote:
> 
> > Hell, just return a freaking error from b43_rfkill_poll(), if the interface
> > is down. If rfkill can't handle that, it should probably be taught to handle it.
> > Especially as there can be other errors as well, like memory allocation failures.
> 
> Be my guest. You'll notice eventually that it's not really easy or
> possible to do. I've explained the currently broken scenario already.
> And even if you introduce the 'unknown' state, you still end up having
> to poll the bit when userspace tries to turn on the device... doesn't
> help much.

It is OK to poll the bit while the device is supposed to be on. But it's not
OK to turn it on to check the bit.

> Larry, thanks for your patch, I'll modify it to turn off the core again
> after checking the rfkill bit tomorrow.

How frequent will that polling happen?

-- 
Greetings, Michael.
