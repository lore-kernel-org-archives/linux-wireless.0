Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:56748 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554Ab1H0VbU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Aug 2011 17:31:20 -0400
Date: Sat, 27 Aug 2011 23:31:11 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] b43: Fix smatch warning
Message-ID: <20110827233111.6480df17@milhouse> (sfid-20110827_233126_188746_74F19B38)
In-Reply-To: <4E59426F.1050401@lwfinger.net>
References: <1314469560-28255-1-git-send-email-Larry.Finger@lwfinger.net>
	<20110827205404.62de7b31@milhouse>
	<4E59426F.1050401@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 27 Aug 2011 14:15:59 -0500
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> On 08/27/2011 01:54 PM, Michael Büsch wrote:
> > On Sat, 27 Aug 2011 13:26:00 -0500
> > Larry Finger<Larry.Finger@lwfinger.net>  wrote:
> >
> >>    CHECK   drivers/net/wireless/b43/main.c
> >> drivers/net/wireless/b43/main.c +4115 b43_wireless_core_stop(7) warn: variable dereferenced before check 'dev'
> >
> >> This is next material.
> >
> > -next, just because the bug is not in the current kernel?
> > Or because you think this is harmless?
> >
> > I'm not sure whether this is harmless. It effectively is that kind
> > of bug that triggers dangerous compiler optimizations.
> > I think the compiler has some freedom to assume dev can not be NULL when
> > the function is entered and thus optimize out the !dev check.
> 
> No, the check has to be left in due to the changing of dev in the routine 
> followed by a 'goto redo'.

I think the compiler is still free to emit the !dev check twice.
Or the other way around: Emit it correctly for the "goto" case and
don't emit it for the function-enter case (and directly check dev->status).

> In fact, a bug in the original code is unlikely, but my patch did add one. I 
> think the code should be
> 
> 	if (!dev)
> 		return NULL;
> 	wl = dev->wl;
> redo:

yes


-- 
Greetings, Michael.
