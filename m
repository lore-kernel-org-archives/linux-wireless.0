Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:54300 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992555AbXCWUy7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 16:54:59 -0400
Date: Fri, 23 Mar 2007 13:51:42 -0700
To: Michael Buesch <mb@bu3sch.de>
Cc: Chris Wright <chrisw@sous-sol.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>, stable@kernel.org
Subject: Re: [stable] [PATCH] fix information leak in wireless extensions on 64-bit platforms
Message-ID: <20070323205142.GA5363@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
References: <1174640787.3588.65.camel@johannes.berg> <20070323193643.GY10574@sequoia.sous-sol.org> <20070323200037.GA5165@bougret.hpl.hp.com> <200703232127.17790.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200703232127.17790.mb@bu3sch.de>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 23, 2007 at 09:27:17PM +0100, Michael Buesch wrote:
> On Friday 23 March 2007 21:00, Jean Tourrilhes wrote:
> 
> I finally have an USB ZD stick now, too. So I can test stuff, too.
> Should I test this somehow?

	Ok, here it goes.
	Pick the latest version of wtools. You may want to compile it
static to avoid the need to install it.

	To test the wpa patch, you need 32 bit userspace on 64 bit
kernel, and you need to try :
		'iwlist genie'

	To test the leak patch, you need a 64 kernel and any
userspace. You need two changes to enable the debugging code.
	1) Put '#define DEBUG 1' on top of iwlib.c.
	2) Change '#if 0' to '#if 1' line 783 of iwlist.c, at the
bottom of print_scanning_info().
	Compile everything.
	If you do a 'iwlist scan', it should dump the full content of
the stream. The first 4 bytes is the header (length + type). The next
4 bytes on 64 bits should be all zero.
	This is what I don't want to see :
[19:00:1B:8B:50:8A:35:E0:09:00:01:00:50:8A:35:F0:47:6F:6C:6F:73:4E:65:74:7A
	This is what I want to see :
[19:00:1B:8B:00:00:00:00:09:00:01:00:50:8A:35:F0:47:6F:6C:6F:73:4E:65:74:7A
	Note that du to endian considerations you may have some of
your bytes swapped.

> Greetings Michael.

	Good luck...

	Jean
