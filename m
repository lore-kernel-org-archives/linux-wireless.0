Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:51999 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbYCRBVH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2008 21:21:07 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH 1/5] b43: Use the b43_phy_maskset where possible
Date: Tue, 18 Mar 2008 02:20:44 +0100
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <1205801249.2329.49.camel@brick> <200803180200.09331.mb@bu3sch.de> <1205802651.2329.59.camel@brick>
In-Reply-To: <1205802651.2329.59.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200803180220.44825.mb@bu3sch.de> (sfid-20080318_012111_119418_B4DFFE79)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 18 March 2008 02:10:51 Harvey Harrison wrote:
> On Tue, 2008-03-18 at 02:00 +0100, Michael Buesch wrote:
> > On Tuesday 18 March 2008 01:47:29 Harvey Harrison wrote:
> > > [lots of patches]
> > 
> > What do these patches actually fix?
> > I see they shuffle a _lot_ of code around, but what does that
> > actually fix? As I said, I won't apply any patch that just shuffles
> > code without fixing anything.
> 
> This was done as I checked through the remaining nested cases for
> mismatched registers being read/written to after sending the fix
> for the braces typo last week.  The easiest way I found to do that
> was convert them over as I checked them.

Ok nice.

> > This shuffling has a _HUGE_ risk of introducing bugs that I am NOT
> > going to debug and fix afterwards.
> > The code works pretty well. There's absolutely no need to rewrite it.
> > 
> > And no, "this makes the code 200bytes smaller" doesn't count as a fix. :)
> > 
> 
> Well, I think in some cases it looks a _lot_ better,

I _completely_ agree with you. That was the reason I introduced the functions
in the first place.

> but I understand 
> your reluctance to mess with something lacking docs.

Yep. These functions were never meant to replace the old G-PHY code.
They were only meant to be used in _new_ code, like the N-PHY and
possibly LP-PHY code.

> I'm done here, just thought as I had done the work while checking it
> I may as well make it available in case someone wanted it.

Yeah, cool. Thanks a lot for checking. I really appreciate that a lot.
While I still reject the patches, the actual review-work is a _lot_ more
valueable anyway.
Thanks a lot. Nice work.

-- 
Greetings Michael.
