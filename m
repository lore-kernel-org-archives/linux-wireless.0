Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:33666 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbZFKQkP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2009 12:40:15 -0400
Date: Fri, 12 Jun 2009 00:30:29 +0800
From: Harald Welte <HaraldWelte@viatech.com>
To: Forest Bond <forest@alittletooquiet.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: Re: VT6656 driver source now GPL
Message-ID: <20090611163029.GF21446@prithivi.gnumonks.org>
References: <20090319164256.GA25237@storm.local.network> <43e72e890903190945m4d8920f5y69f5847b688b0aa1@mail.gmail.com> <20090320131014.GG25237@storm.local.network> <20090414000835.GA31504@storm.local.network> <20090611132954.GA20845@prithivi.gnumonks.org> <20090611135041.GE26234@alittletooquiet.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090611135041.GE26234@alittletooquiet.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 11, 2009 at 09:50:42AM -0400, Forest Bond wrote:

> You mention the idea of working on a new driver.  Do you see any value in
> merging the vendor drivers and cleaning up from there?

I don't really know.  It makes sense to have some repository somewhere public,
where the community can put in fixes and support for new kernel versions as
they come out.  Whether or not that should be part of staging, I can't really
comment on it, as I have not been involved with that tree.  Also, my opinion
doesn't matter.  Greg takes everything that is GPL licensed, builds and
somebody sends to him :)

As for actually cleaning up the driver: I suppose you have seen it. Not only
does it contain its own 802.11 stack, firmware-as-hex-arrays but also its own
OS abstraction layer - similar to many other drivers like some of the early 8686
code that marvell released before the new libertas driver was started.

> BTW, these drivers could certainly use more expert attention than what I can
> offer.  I'd be interested in working with you to get the vendor drivers in
> shape, if you think it is worthwhile.  I take it no one at VIA is able to look
> at the staging drivers in -next?

No, nobody at VIA's wireless R&D will be able to look at it.

Starting from scratch with a real 'native' linux driver, using the correct
coding style and whatever useful bits from the in-mainline 80211 code is
probably considerably less work than trying to 'clean them up'.

At least we do have some known-working FOSS code that can be used as a reference
and for debugging.  And if there is some kind of odd behaviour or a specific
question, I can try to hunt down somebody internally who might have an answer.
That's more than many other linux mainline/community wifi drivers had ;)

Regards.
-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
============================================================================
VIA Free and Open Source Software Liaison
