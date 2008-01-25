Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40565 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752323AbYAYSg2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 13:36:28 -0500
Date: Fri, 25 Jan 2008 10:34:46 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Linux 2.6.24-rc7
In-Reply-To: <200801251921.48862.mb@bu3sch.de>
Message-ID: <alpine.LFD.1.00.0801251032330.2979@hp.linux-foundation.org> (sfid-20080125_183632_781077_D7A7847E)
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <200801251723.58891.mb@bu3sch.de> <alpine.LFD.1.00.0801250841080.14161@hp.linux-foundation.org> <200801251921.48862.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Fri, 25 Jan 2008, Michael Buesch wrote:
> 
> I'm not sure what's so hard about adding this trivial fix to the firmware.
> The _fact_ that this warning triggered for lots of drivers means that
> developers are not aware of the problem. So why should we go on hiding bugs
> that are _trivial_ to fix?

.. mainly because I don't think it's a bug in the network driver.

It really sounds like you're creating a warning for a bug in the wireless 
infrastructure, and then trying to blame the drivers that don't agree with 
that warning being valid in the first place.

> I absolutely hate the attitude "The problem does not happen on most
> of the stuff intel uses, so they don't need to fix this".

That's not *my* attitude at least.

My attitude is: CPU's that do unaligned accesses right are the *good* 
CPU's. We should encourage them, and put the onus of being crap on the 
ones that are crap, rather than penalizing the ones that aren't.

In other words, we should use "get_unaligned()".

		Linus
