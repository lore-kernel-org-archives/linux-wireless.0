Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:42995 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242AbYLSJ6j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2008 04:58:39 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Werner Almesberger <werner@openmoko.org>
Subject: Re: AR6k: to rfkill or not to rfkill ?
Date: Fri, 19 Dec 2008 10:54:11 +0100
Cc: linux-wireless@vger.kernel.org
References: <20081218212234.GI5019@almesberger.net> <200812182320.17457.mb@bu3sch.de> <20081218235916.GS5020@almesberger.net>
In-Reply-To: <20081218235916.GS5020@almesberger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200812191054.11532.mb@bu3sch.de> (sfid-20081219_105857_586113_33D16965)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 19 December 2008 00:59:16 Werner Almesberger wrote:
> Michael Buesch wrote:
> > I think you should probably implement it.
> 
> Okay, thanks for the explanation !
> 
> > Rfkill is supposed to stop TX _immediately_.
> > So no MAC cleanup, etc...
> 
> Hmm, I'll have to measure how quick this really gets. All this happens
> in the "black box" that is the firmware. A few ms for sure, already
> for SDIO communication. Hopefully faster than hundreds of milliseconds.

Yeah, it doesn't really matter, if it's within, say 100-200ms.
I just wanted to say, you should not _generate_ new traffic (disassoc, etc..)
if you get a kill signal. Instead you should immediately drop any connection
and kill the radio.

> > Note that current rfkill subsystem implementation is not that nice and you
> > might get some headache from it. ;)
> 
> Ah, that'll be the least of my worries :-)

My head is still burning for over the last couple of months. ;)

-- 
Greetings, Michael.
