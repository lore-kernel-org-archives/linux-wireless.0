Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:56979
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932226AbXCXQv3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Mar 2007 12:51:29 -0400
From: Michael Buesch <mb@bu3sch.de>
To: jt@hpl.hp.com
Subject: Re: [stable] [PATCH] fix information leak in wireless extensions on 64-bit platforms
Date: Sat, 24 Mar 2007 17:50:21 +0100
Cc: Chris Wright <chrisw@sous-sol.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>, stable@kernel.org
References: <1174640787.3588.65.camel@johannes.berg> <200703232127.17790.mb@bu3sch.de> <20070323205142.GA5363@bougret.hpl.hp.com>
In-Reply-To: <20070323205142.GA5363@bougret.hpl.hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200703241750.21630.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 23 March 2007 21:51, Jean Tourrilhes wrote:
> On Fri, Mar 23, 2007 at 09:27:17PM +0100, Michael Buesch wrote:
> > On Friday 23 March 2007 21:00, Jean Tourrilhes wrote:
> > 
> > I finally have an USB ZD stick now, too. So I can test stuff, too.
> > Should I test this somehow?
> 
> 	Ok, here it goes.
> 	Pick the latest version of wtools. You may want to compile it
> static to avoid the need to install it.
> 
> 	To test the wpa patch, you need 32 bit userspace on 64 bit
> kernel, and you need to try :
> 		'iwlist genie'
> 
> 	To test the leak patch, you need a 64 kernel and any

Ok, so the most important question: Where to get the latest
versions of these patches? :)
I kind of lost track of what was agreed on and what's latest, etc..
Some link to the mail?

> userspace. You need two changes to enable the debugging code.
> 	1) Put '#define DEBUG 1' on top of iwlib.c.
> 	2) Change '#if 0' to '#if 1' line 783 of iwlist.c, at the
> bottom of print_scanning_info().
> 	Compile everything.
> 	If you do a 'iwlist scan', it should dump the full content of
> the stream. The first 4 bytes is the header (length + type). The next
> 4 bytes on 64 bits should be all zero.
> 	This is what I don't want to see :
> [19:00:1B:8B:50:8A:35:E0:09:00:01:00:50:8A:35:F0:47:6F:6C:6F:73:4E:65:74:7A
> 	This is what I want to see :
> [19:00:1B:8B:00:00:00:00:09:00:01:00:50:8A:35:F0:47:6F:6C:6F:73:4E:65:74:7A
> 	Note that du to endian considerations you may have some of
> your bytes swapped.
> 
> > Greetings Michael.
> 
> 	Good luck...
> 
> 	Jean
> 
> 

-- 
Greetings Michael.
