Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:57584 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128AbYAYScQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 13:32:16 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.24-rc7
Date: Fri, 25 Jan 2008 19:30:26 +0100
Cc: Dan Williams <dcbw@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <alpine.LFD.1.00.0801250934030.14161@hp.linux-foundation.org> <alpine.LFD.1.00.0801251011590.14161@hp.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0801251011590.14161@hp.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801251930.27022.mb@bu3sch.de> (sfid-20080125_183219_613306_59158400)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 25 January 2008 19:22:13 Linus Torvalds wrote:
> 
> On Fri, 25 Jan 2008, Linus Torvalds wrote:
> > 
> > But complaining about a vendor who does a good job technically, for 
> > non-technical reasons, I really don't see that as being fine.
> 
> Side note: I also think the wireless parts here are doing things wrong. 
> 
> Why _would_ you care about alignment? We used to have issues like that in 
> the normal networking code, and it was a mistake there too. Why isn't the 
> wireless stack just extracting the header explicitly, or using 
> "get_unaligned()" like regular networking?

The problem is _not_ the wireless header access, but the alignment of the embedded
protocol stack, if the header does not have a size aligned to 4.
Do we want to clutter the whole networking stack below wireless with
get_unaligned() or attribute(packed) or something like that?

-- 
Greetings Michael.
