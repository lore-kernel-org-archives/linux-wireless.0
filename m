Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:53116 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753282AbYJCWf7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Oct 2008 18:35:59 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH 3/8] b43: remove b43_radio_{read|write}16 from lo.c
Date: Sat, 4 Oct 2008 00:35:35 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <1223066926.6512.28.camel@brick> <1223069584.6512.42.camel@brick> <200810032356.38798.mb@bu3sch.de>
In-Reply-To: <200810032356.38798.mb@bu3sch.de>
MIME-Version: 1.0
Message-Id: <200810040035.35990.mb@bu3sch.de> (sfid-20081004_003602_970812_B300267C)
Content-Type: text/plain;
  charset="iso-8859-15"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 03 October 2008 23:56:38 Michael Buesch wrote:
> On Friday 03 October 2008 23:33:04 Harvey Harrison wrote:
> > OK, but you should still look at patch 1 for the unaligned access
> > helpers.
> 
> Yeah it's broken (it removes bounds checks at the end)
> and unaligned is not needed.
> 
> > The rest I'll kick to the bitbucket...although I think you should look
> > at the portion of patch 5 that touches the function b43_radio_init2060
> > as it points out the _one_ place where a register is masking the value
> > of some other register...which is absolutely impossible to see unless
> > you do a series of patches like this.
> > 
> > It may be that it is intentional, and it has been this way as far back
> > in the git history as I can find, but at least now it can be seen.
> > 
> > -       b43_radio_write16(dev, 0x0005,
> > -                         (b43_radio_read16(dev, 0x0081) & ~0x0008) | 0x0008);
> 
> That's a bug in the dead code. We have more such bugs in the A-PHY code,
> but nobody cares.
> If you want to fix it, please read the specs and find out what should be
> here instead. Then send a patch that fixes this single line of code.
> 

ah and you can also send a patch that removes all radio_read16/write16, if
you like to.
This can be proven correct by comparing the .ko sha1sum checksum before
and after applying it.

But no replacing of expressions by maskset and stuff. These can't be proven
correct (easily) and are simply not worth the danger of typo-regressions.

-- 
Greetings Michael.
