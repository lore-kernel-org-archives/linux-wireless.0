Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:58186 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753848AbYLRWrG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 17:47:06 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Andy Green <andy@warmcat.com>
Subject: Re: AR6k: to rfkill
Date: Thu, 18 Dec 2008 23:43:09 +0100
Cc: Werner Almesberger <werner@openmoko.org>,
	linux-wireless@vger.kernel.org
References: <20081218212234.GI5019@almesberger.net> <200812182337.56050.mb@bu3sch.de> <494AD243.5070602@warmcat.com>
In-Reply-To: <494AD243.5070602@warmcat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200812182343.09528.mb@bu3sch.de> (sfid-20081218_234722_336118_4193871C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 18 December 2008 23:44:19 Andy Green wrote:
> Somebody in the thread at some point said:
> > On Thursday 18 December 2008 23:28:43 Andy Green wrote:
> >> Somebody in the thread at some point said:
> >>
> >>> In Openmoko, we're wondering whether we should make the Atheros AR6k
> >> Let me put that simpler for you Werner :-)
> >>
> >> "In Openmoko" we already use the nice rfkill interface to turn our USB 
> >> bluetooth device on and off... it certainly stops RF emissions from it.
> >>
> >> Now we plan to do the same for our AR6001 implementation... it has no 
> >> switched power to the module, it is "always on".  It seems the only way 
> >> to get it to a low power state is an IOCTL that currently needs to be 
> >> set by a userspace app.
> >>
> >> In the same manner as we switch bluetooth, I have asked Werner to write 
> >> a patch that will use rfkill to issue the IOCTL to switch the AR6001 
> >> into low power / no RF mode.
> >>
> >> Does that raise any eyebrows?
> > 
> > Is the wireless kernel driver a binary blob?
> 
> No, Openmoko won't have anything to do with in-kernel binary blobs. 
> There is binary firmware in it in flash though.

Ok, it just sounded like this, because you were talking about ioctl and stuff...

So if you receive a kill event, just send the command that puts the device into
low power state to the device. I think that's perfectly fine.

-- 
Greetings, Michael.
