Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:44373
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbXHGJ6S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2007 05:58:18 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH stable] softmac: Fix deadlock of wx_set_essid with assoc work
Date: Tue, 7 Aug 2007 11:57:20 +0200
Cc: stable@kernel.org, John Linville <linville@tuxdriver.com>,
	David Woodhouse <dwmw2@infradead.org>,
	linux-wireless@vger.kernel.org
References: <200708011253.06569.mb@bu3sch.de> <200708031250.51161.mb@bu3sch.de> <1186410230.28655.75.camel@johannes.berg>
In-Reply-To: <1186410230.28655.75.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200708071157.21105.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 06 August 2007 16:23:50 Johannes Berg wrote:
> On Fri, 2007-08-03 at 12:50 +0200, Michael Buesch wrote:
> 
> > Ah, Ok. I didn't see that rtnl is locked there, too.
> > cancel_delayed_work_sync could probably work. Care to test that?
> 
> It's harder than thought, runs into the next use of flush_scheduled_work
> under rtnl. I think the only solution is to go with your patch and then
> add an own single-threaded workqueue to softmac again and use that
> everywhere instead of the global one; at least that way the rtnl doesn't
> get into the way.

Yep, but this patch turns the bug from a
"It will 100% deadlock all the time"
into a
"It might possibly deadlock, although unlikely"
So it's a win for that crap softmac code.

-- 
Greetings Michael.
