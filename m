Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:55357 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260AbYAYQ0B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 11:26:01 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.24-rc7
Date: Fri, 25 Jan 2008 17:23:58 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <1201264166.12870.16.camel@johannes.berg> <alpine.LFD.1.00.0801250753240.14161@hp.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0801250753240.14161@hp.linux-foundation.org>
MIME-Version: 1.0
Message-Id: <200801251723.58891.mb@bu3sch.de> (sfid-20080125_162606_913424_A27F8EA4)
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 25 January 2008 17:08:51 Linus Torvalds wrote:
> 
> On Fri, 25 Jan 2008, Johannes Berg wrote:
> > 
> > Since the only problematic driver is Intel's, they really should be able
> > to get their act together for .25 and fix their firmware, if not then
> > we'll have to think of something else like making their drivers
> > memmove() the packets to the right place.
> 
> Well, there *is* a really simple solution:
> 
>  - realize that x86 (along with some few other architectures) is sane, and 
>    not a crapola architecture that cannot do unaligneds well.
...
> because the thing is, we should give Intel credit for doing the right 
> thing (in the CPU), rather than complain about the fact that they don't 
> care about insane architectures that do the wrong thing and can't even 
> work with the wireless driver in the first place!

If we are talking about what's sane or not...
It's trivial to fix this in the firmware, like sane vendors like
Broadcom do.

Architectures that can't do unaligned access are heavily used in
wireless embedded routers. So we are not going to pay a huge
price there so just one vendor doesn't have to fix his firmware.

-- 
Greetings Michael.
