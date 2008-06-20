Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:35000 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759035AbYFTP4m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2008 11:56:42 -0400
Date: Fri, 20 Jun 2008 17:55:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Michael Buesch <mb@bu3sch.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel list <linux-kernel@vger.kernel.org>,
	David Ellingsworth <david@identd.dyndns.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH/RFC] remove irqs_disabled warning from local_bh_enable
Message-ID: <20080620155541.GC6656@elte.hu> (sfid-20080620_175659_711140_A3A9F1AC)
References: <1213739834.3803.137.camel@johannes.berg> <20080620134637.GA8135@elte.hu> <20080620152748.GA21245@elte.hu> <200806201736.23916.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200806201736.23916.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


* Michael Buesch <mb@bu3sch.de> wrote:

> On Friday 20 June 2008 17:27:48 Ingo Molnar wrote:
> >  [<c012b361>] local_bh_enable_ip+0xd1/0xe0
> >  [<c08d9f9f>] _spin_unlock_bh+0x2f/0x40
> >  [<c0471b92>] vortex_timer+0xe2/0x3e0
> 
> > real bug or false positive?
> 
> Well, a timer runs with IRQs disabled, no? So this would be a bug.

indeed - agreed :) [no time for me to fix it, but can test any rfc patch.]

so score +1 for Johannes's patch. I think if it works out fine and there 
are no false positives in further testing i'll put it up for pull into 
v2.6.26 as well, as it is catching real bugs.

	Ingo
