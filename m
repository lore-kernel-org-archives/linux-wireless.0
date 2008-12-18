Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:53824 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659AbYLRWYs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 17:24:48 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Werner Almesberger <werner@openmoko.org>
Subject: Re: AR6k: to rfkill or not to rfkill ?
Date: Thu, 18 Dec 2008 23:20:17 +0100
Cc: linux-wireless@vger.kernel.org
References: <20081218212234.GI5019@almesberger.net>
In-Reply-To: <20081218212234.GI5019@almesberger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200812182320.17457.mb@bu3sch.de> (sfid-20081218_232451_711545_B509F744)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 18 December 2008 22:22:34 Werner Almesberger wrote:
> So, first of all, given that TX power is controlled only indirectly
> anyway, should we implement rfkill control or not ? There is no kill
> switch, so there would be no rfkill input.
> 
> If the answer is "yes", would the following semantics be right for
> the disabled state ?

I think you should probably implement it.
Rfkill is supposed to be a central place for userspace to turn the radios
off. So if your radio doesn't register an rfkill device, it will result in
inconsistent userspace state. Userspace (network manager, or whatever app)
thinks that it disabled all radios, but it didn't, in fact.

So yes, I think you should implement rfkill by stopping any TX actions
immediately if it hits. The state callback would simply be emulated in software.

> - we de-associate

Rfkill is supposed to stop TX _immediately_.
So no MAC cleanup, etc...

> - we stop scanning
> - all ioctls still work as usual, but they have no effect on
>   association and scanning until rfkill re-enables the device

basically, yes.


Note that current rfkill subsystem implementation is not that nice and you
might get some headache from it. ;)

-- 
Greetings, Michael.
