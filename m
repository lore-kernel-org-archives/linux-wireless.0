Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:51622 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752737AbZCUNOE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2009 09:14:04 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC][PATCH 4/5] ar9170: USB frontend driver
Date: Sat, 21 Mar 2009 14:12:52 +0100
Cc: Christian Lamparter <chunkeey@web.de>,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
References: <200903170410.20261.chunkeey@web.de> <200903211349.02761.mb@bu3sch.de> <1237640079.5100.185.camel@johannes.local>
In-Reply-To: <1237640079.5100.185.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200903211412.52749.mb@bu3sch.de> (sfid-20090321_141425_441393_717E3FBD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 21 March 2009 13:54:39 Johannes Berg wrote:
> On Sat, 2009-03-21 at 13:49 +0100, Michael Buesch wrote:
> 
> > > > Well I think it would currently generate lots of errors, because we have
> > > > code like this in the kernel:
> > > > 
> > > > if (x)
> > > > 	mutex_lock();
> > > > ...
> > > > if (x)
> > > > 	mutex_unlock();
> > > 
> > > That's sloppy code anyway. Not to be encouraged.
> > 
> > That's not true. Sometimes it is the cleanest way to do things.
> > Look at drivers/ssb/main.c. To make this mutex-sparse compliant, we'd
> > need to introduce quite a few sub-functions.
> > 
> > It simply is a limitation of sparse. Nothing else.
> 
> No, I still think it's sloppy code;

Patches that change the code into code with _better_ style are accepted.
However, I don't think introducing more foo(); calls __foo(); style stuff is better.
It's just a workaround to sparse.

> some future work will in most cases 
> invariably move the conditions further apart, at which point it becomes
> more and more unlikely that the invariant that the "x" doesn't change
> inbetween is maintained.

Did you look at the example I gave?

-- 
Greetings, Michael.
