Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:36126 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933523AbZHWMzw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Aug 2009 08:55:52 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Abour linux driver supports BCM4325
Date: Sun, 23 Aug 2009 14:55:50 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	feng tian <feng.of.tian@gmail.com>,
	linux-wireless@vger.kernel.org
References: <f42a38140908202319y5c352aa3s37fec67e5cb8d7a3@mail.gmail.com> <4A90B086.1020503@lwfinger.net> <1251018830.23605.32.camel@johannes.local>
In-Reply-To: <1251018830.23605.32.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908231455.51140.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 23 August 2009 11:13:50 Johannes Berg wrote:
> On Sat, 2009-08-22 at 21:59 -0500, Larry Finger wrote:
> > feng tian wrote:
> > > Thank you for the information.
> > > I get your point. As for the radio and phy driver, I think it's  some
> > > command based configurations for the chip via SDIO. And that I can
> > > refer to the BCM 43xx PCI driver codes.
> > > Wonder if it's feasible. Needs your comments.
> > > Thanks
> > 
> > The first step is to be able to read/write the various registers via
> > SDIO. That will be similar to the PCI operations. The next step is
> > knowing what to read/write and when. We are still working that out for
> > PCI. It is not trivial. See the recent postings of patches for the LP
> > pHY in the linux-wireless mailing list. These are _NOT_ complete.
> 
> Right.
> 
> You have two completely orthogonal problems:
> 
>  1) changing b43 so it knows how to talk not just to SSB/PCI/PCMCIA
>     chips but also SDIO chips

We already have working support for that and we're currently merging it mainline.
If you want to help, please test the spinlock removal patchset I just posted.

>  2) changing b43 so it knows how to talk to your specific radio/PHY
>     chip, and LP PHY

Also almost working and in the progress of merging mainline.

-- 
Greetings, Michael.
