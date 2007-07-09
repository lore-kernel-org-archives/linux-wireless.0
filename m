Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:63299 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbXGIQtN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2007 12:49:13 -0400
Date: Mon, 9 Jul 2007 09:46:32 -0700
To: Johannes Berg <johannes@sipsolutions.net>,
	Jouni Malinen <jkmaline@cc.hut.fi>
Cc: Masakazu Mokuno <mokuno@sm.sony.co.jp>,
	linux-wireless@vger.kernel.org,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	geoffrey.levand@am.sony.com
Subject: Re: alignment issue between 32bit userland and 64bit kernel
Message-ID: <20070709164632.GA32350@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
References: <20070709201037.D02C.MOKUNO@sm.sony.co.jp> <1183982603.18986.6.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1183982603.18986.6.camel@johannes.berg>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 09, 2007 at 02:03:23PM +0200, Johannes Berg wrote:
> Hi,
> 
> > While developing the wireless support for PS3, I'd noticed there were alignment
> > issues if we issued some wireless ioctl from 32bit userland to 64bit
> > kernel (ppc64 PS3 does have). 
> > 
> >  - IW_EV_LCP_LEN in 32bit userland and 64bit kernel differ
> >  - offsetof(struct iw_point, length) differ
> 
> Yeah, we're aware of them.
> 
> > The former issue could be fixed if we added 'packed' attribute to
> > iw_event structure, but it would break existing 64bit userland.  I have
> > no idea to resolve latter issue because the first member of struct
> > iw_point is a pointer.
> > 
> > Does anyone have idea to fix these issues?
> > (except compiling all userland apps in 64bit mode...)
> 
> Jean wants to fix them in userspace. In fact, if you upgrade your
> userspace to the really latest version it *should* work. wpa_supplicant
> still doesn't work, nor do most distribution's versions of network
> manager because the fixes haven't been backported.

	You need :
		Wireless Tools 29-pre20 or later
		network manager 0.6.5 or later
	Distro that have those versions :
		Gentoo 2007.0
		Debian unstable
		Ubuntu Gutsy
		OpenSuSE 10.3a5
	We are getting there...
	The situation with wpa_supplicant is most unfortunate,
fortunately x-supplicant should work properly, as it uses libiw.

> johannes

	Thanks...

	Jean

