Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from deine-taler.de ([217.160.107.63]:49398 "EHLO
	p15091797.pureserver.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbXCKULu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Mar 2007 16:11:50 -0400
Date: Sun, 11 Mar 2007 21:11:49 +0100
From: Ulrich Kunitz <kune@deine-taler.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: jt@hpl.hp.com, Jouni Malinen <jkm@devicescape.com>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	netdev <netdev@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
	Dan Williams <dcbw@redhat.com>
Subject: Re: wireless extensions vs. 64-bit architectures
Message-ID: <20070311201148.GA25938@p15091797.pureserver.info>
References: <20070307020310.GA20466@bougret.hpl.hp.com> <1173364747.14001.7.camel@johannes.berg> <20070308184954.GA24485@bougret.hpl.hp.com> <1173382042.3248.63.camel@johannes.berg> <20070308193412.GG23040@devicescape.com> <1173382802.3248.68.camel@johannes.berg> <20070308221128.GA24884@bougret.hpl.hp.com> <1173393326.3831.21.camel@johannes.berg> <20070309213531.GA28070@bougret.hpl.hp.com> <1173634801.3382.8.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1173634801.3382.8.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I'm still not convinced that papering over the problem in userspace is a
> real solution.
> 
> johannes

Just my 2 cents. I support this. What are the options? I see only
two:

1. Use different magic numbers for 32 bit and 64 bit structures. A
   flag is an alternative, but will be more difficult to debug.
   Generation of the magic should be easy, use sizeof(unsigned
   long) as test. User space has to care than for the rest.

2. Make the data representation identical in 32 bit and 64 bit.

   This shouldn't be to difficult, if only u8, u16 and u32 types
   are used. Pointers should be given as offsets. If necessary
   align and/or packed attributes could be used.

If the kernel interface can be changed, I vote for option 2,
because user space has then to deal with a unique data layout.
If the wext kernel interface cannot be changed to maintain
backward compatibility, then I have to admit band-aids in user
space are needed. However cfg80211 must not suffer from the same issues.

-- 
Uli Kunitz
