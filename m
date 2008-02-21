Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pasmtpb.tele.dk ([80.160.77.98]:42192 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758366AbYBUWc2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2008 17:32:28 -0500
Date: Thu, 21 Feb 2008 23:32:39 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Harvey Harrison <harvey.harrison@gmail.com>,
	Al Viro <viro@ftp.linux.org.uk>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: __bitwise versus __bitwise__ [Was: [PATCH] mac80211: check endianness/types in sparse runs]
Message-ID: <20080221223239.GA31048@uranus.ravnborg.org> (sfid-20080221_223255_667833_EE67823A)
References: <1203503909.17534.14.camel@johannes.berg> <20080220195913.GE21139@uranus.ravnborg.org> <1203597776.20331.5.camel@johannes.berg> <1203624091.20345.63.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1203624091.20345.63.camel@brick>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Al - can I ask you to explain the difference between __bitwise
and __bitwise__ as used by the kernel.

Se below for a bit of background info.

Thanks,
	Sam

On Thu, Feb 21, 2008 at 12:01:31PM -0800, Harvey Harrison wrote:
> On Thu, 2008-02-21 at 13:42 +0100, Johannes Berg wrote:
> > >> [patch doing CHECKFLAGS += -D__CHECK_ENDIAN__ in the
> > >> net/mac80211/Makefile]
> > 
> > > I would prefer it to be kernel wide enabled.
> > > Tried a defconfig build.
> > 
> > Hm. I tend to think there was a reason for this, since this is actually
> > explicitly disabled by include/linux/types.h:
> > 
> > #ifdef __CHECKER__
> > #define __bitwise__ __attribute__((bitwise))
> > #else 
> > #define __bitwise__
> > #endif
> > 
> > #ifdef __CHECK_ENDIAN__
> > #define __bitwise __bitwise__
> > #else
> > #define __bitwise
> > #endif
> > 
> 
> This seems somewhat suspect.
> 
> > I recently ran sparse on my config and was surprised by the number of
> > warnings. Then again, something in mmzone.h or so generated billions of
> > them...
> 
> Potentially expensive pointer subtraction 640:....
> 
> Patch in -mm.
> 
> > 
> > In any case, I would love to have __CHECK_ENDIAN__ enabled by default at
> > least on the wireless code (just caught another bug with it...)
> > 
> 
> I'd love to have it too, but there are so many trivial warnings that
> clutter up valid warnings that it is prohibitive.  I'm working on
> reducing the noise level a bit for 2.6.26, we'll see about turning
> it on then.
> 
> Harvey
> 
