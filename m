Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:56170 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbXLDADN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2007 19:03:13 -0500
Date: Mon, 3 Dec 2007 16:01:38 -0800
To: Shaddy Baddah <shaddy_baddah@hotmail.com>
Cc: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	David Miller <davem@davemloft.net>
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
Message-ID: <20071204000138.GA1363@bougret.hpl.hp.com> (sfid-20071204_000316_304090_82EDA755)
Reply-To: jt@hpl.hp.com
References: <4740DF47.4040206@hotmail.com> <20071119.002755.77617097.davem@davemloft.net> <1195484582.8642.18.camel@johannes.berg> <20071119180423.GA19250@bougret.hpl.hp.com> <47443035.1070702@hotmail.com> <20071121184459.GA17199@bougret.hpl.hp.com> <474F86AD.4040403@hotmail.com> <20071130202115.GA32444@bougret.hpl.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071130202115.GA32444@bougret.hpl.hp.com>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 30, 2007 at 12:21:15PM -0800, jt wrote:
> On Fri, Nov 30, 2007 at 02:42:37PM +1100, Shaddy Baddah wrote:
> > 
> > No, it does not seem to have. An iwlist eth2 scanning command still 
> > lists a single access point, then fails with a bus error.
> 
> 	Hmm... That's strange as I was seeing my code behaving as
> expected.
> 	I will ask you to compile a version of wireless tools with
> debugging enabled and run it with gdb. See my other e-mail.

	Hi,

	Sorry to bother you again. Next week I will go on vacation,
and may not be able to continue working on that bug. Your best bet for
a fix is this week.

	Now, this is what you will do :
	1) Get wireless_tools.30.pre3-debug2.tar.gz I sent you a while
ago. I know you have it, as you sent me debug log from it.
	2) Go in the wireless_tools.30 directory.
        3) edit Makefile. Go to line defining CFLAGS, replace "-Os"
with "-g". It should look like :
---------------------------------------
CFLAGS=-g -W -Wall -Wstrict-prototypes -Wmissing-prototypes -Wshadow \
	-Wpointer-arith -Wcast-qual -Winline -I.
---------------------------------------
        4) Recompile : make clean ; make
        5) Start the debugger : gdb --args iwlist eth0 scan
        6) Run the program : run
        7) Get a stack trace : bt

	If you have properly enabled debug, the stack trace will show
the precise line number where it crashes. That's mostly what I'm
after.
	I would also like to have the debugging output of iwlist. The
function where it seems to crash is called many time, I want to know
in which context it is called. Feel free to send it private.

	Thanks in advance...

	Jean
