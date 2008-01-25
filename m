Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:54201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755453AbYAYRb6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 12:31:58 -0500
Subject: Re: Linux 2.6.24-rc7
From: Dan Williams <dcbw@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michael Buesch <mb@bu3sch.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <alpine.LFD.1.00.0801250841080.14161@hp.linux-foundation.org>
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org>
	 <1201264166.12870.16.camel@johannes.berg>
	 <alpine.LFD.1.00.0801250753240.14161@hp.linux-foundation.org>
	 <200801251723.58891.mb@bu3sch.de>
	 <alpine.LFD.1.00.0801250841080.14161@hp.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 25 Jan 2008 12:27:07 -0500
Message-Id: <1201282027.3422.15.camel@localhost.localdomain> (sfid-20080125_173203_761600_27B0A2E9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-01-25 at 08:43 -0800, Linus Torvalds wrote:
> 
> On Fri, 25 Jan 2008, Michael Buesch wrote:
> > 
> > If we are talking about what's sane or not...
> > It's trivial to fix this in the firmware, like sane vendors like
> > Broadcom do.
> 
> You just showed your total disregard for any sanity by calling broadcom 
> "sane".
> 
> Quite frankly, Broadcom is probably the single worst chip manufacturer in 
> terms of both bugginess of the silicon itself and in terms of lack of 
> support.
> 
> > Architectures that can't do unaligned access are heavily used in
> > wireless embedded routers. So we are not going to pay a huge
> > price there so just one vendor doesn't have to fix his firmware.
> 
> .. and you also showed that you didn't even read my email and the options 
> I outlined. The fact is, the Intel wireless chipset only works with x86 
> CPU's. There is absolutely zero "price" on crap CPU's, because they are 
> simply not relevant to this driver.

Except that some kernel developers (not you) have made noise about
requiring Intel to ensure their hardware and drivers work on platforms
that they are unlikely ever to work on.  There was resistance to merging
iwlwifi because it wasn't quite endian-safe at the time (even though
99.99% of iwl3945 and 4965 cards will be on x86) and Intel's track
record in not endian-safing ipw2200 and ipw2100 was brought up.
Eventually Intel developers did go through and try to do the correct
sparse annotations and endian conversions and the driver got merged.

Does Intel need to make iwlwifi and ipw2x00 work reliably on platforms
other than x86?  Or don't they?

Dan

