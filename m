Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:3409 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbZAVPaF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 10:30:05 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linville@tuxdriver.com, jirislaby@gmail.com,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Subject: Re: [ath5k-devel] [PATCH 0/6] ath5k: various misc fixes
Date: Thu, 22 Jan 2009 10:29:38 -0500
Message-Id: <20090122152204.M73296@bobcopeland.com> (sfid-20090122_163010_695049_5A73DE2B)
In-Reply-To: <1232637118.19795.3.camel@maxim-laptop>
References: <1232631861-6028-1-git-send-email-me@bobcopeland.com> <1232637118.19795.3.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 22 Jan 2009 17:11:58 +0200, Maxim Levitsky wrote
> On Thu, 2009-01-22 at 08:44 -0500, Bob Copeland wrote:
> > Hi, here are some various updates for ath5k, some minor fixes, it's 
> > probably all 2.6.30 material.
> > 
> > - patch 1 fixes a locking bug, but for consistency, not to fix any reported
> >   issue
> > - patches 2 and 4 are cleanups
> > - patch 3 makes reset() more closely match the HAL, it may help with reset
> >   errors but really is unlikely to fix any problem
> > - patches 5 and 6 add missing support for some rate flags that have been
> >   ignored by ath5k since forever
> 
> I tried using those 4 patches that were your attempt to fix hangs
> the first one, probably helps a bit, but with them I got those 'failed
> to wakeup PHY' errors that persist even after suspend/resume cycle.
> 
> Now I only use the 'continue reset sequence' and while chip locks up
> from time to time, I don't see the messages about failed PHY wakeup.

Cool, thanks for the feedback.  For the record that is patch 3 in this
series.  I sent everything except the one that puts a spinlock around
reset; that still hangs for me so I'd rather not send it until I know
why.  Consequently, the other 2 patches (1 and 2) don't have any major
effect.

I suspect patch 3 helps but doesn't cure anything.

-- 
Bob Copeland %% www.bobcopeland.com


