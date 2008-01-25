Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32972 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753659AbYAYSYx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 13:24:53 -0500
Date: Fri, 25 Jan 2008 10:22:13 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dan Williams <dcbw@redhat.com>
cc: Michael Buesch <mb@bu3sch.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Linux 2.6.24-rc7
In-Reply-To: <alpine.LFD.1.00.0801250934030.14161@hp.linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0801251011590.14161@hp.linux-foundation.org> (sfid-20080125_182456_473440_6835E9B5)
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org>  <1201264166.12870.16.camel@johannes.berg>  <alpine.LFD.1.00.0801250753240.14161@hp.linux-foundation.org>  <200801251723.58891.mb@bu3sch.de>  <alpine.LFD.1.00.0801250841080.14161@hp.linux-foundation.org>
 <1201282027.3422.15.camel@localhost.localdomain> <alpine.LFD.1.00.0801250934030.14161@hp.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Fri, 25 Jan 2008, Linus Torvalds wrote:
> 
> But complaining about a vendor who does a good job technically, for 
> non-technical reasons, I really don't see that as being fine.

Side note: I also think the wireless parts here are doing things wrong. 

Why _would_ you care about alignment? We used to have issues like that in 
the normal networking code, and it was a mistake there too. Why isn't the 
wireless stack just extracting the header explicitly, or using 
"get_unaligned()" like regular networking?

With ethernet, there were chips that could only do DMA at certain 
alignments etc, together with various other headers being involved, making 
it impossible to require alignment without memcpy(), and I don't think 
we've had any issues there.

People have to add in the proper "get_unaligned()" calls that they forgot 
or didn't think about to various pieces every once in a while, but on most 
platforms you get a nice warning when something isn't doing the right 
thing (I think some borken ARM cores are the exception and will just 
silently do the wrong thing entirely).

So it's not like this is a new issue, and I can't recall us ever before 
having ended up requiring alignment when it hit us.

			Linus
