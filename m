Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:40300 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933967AbZHWNaE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Aug 2009 09:30:04 -0400
From: Michael Buesch <mb@bu3sch.de>
To: =?iso-8859-1?q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Subject: Re: Abour linux driver supports BCM4325
Date: Sun, 23 Aug 2009 15:30:03 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	feng tian <feng.of.tian@gmail.com>,
	linux-wireless@vger.kernel.org
References: <f42a38140908202319y5c352aa3s37fec67e5cb8d7a3@mail.gmail.com> <200908231455.51140.mb@bu3sch.de> <69e28c910908230624s1600a9d4k3918875551bfbf4d@mail.gmail.com>
In-Reply-To: <69e28c910908230624s1600a9d4k3918875551bfbf4d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200908231530.04236.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 23 August 2009 15:24:29 Gábor Stefanik wrote:
> On Sun, Aug 23, 2009 at 2:55 PM, Michael Buesch<mb@bu3sch.de> wrote:
> > On Sunday 23 August 2009 11:13:50 Johannes Berg wrote:
> >> On Sat, 2009-08-22 at 21:59 -0500, Larry Finger wrote:
> >> > feng tian wrote:
> >> > > Thank you for the information.
> >> > > I get your point. As for the radio and phy driver, I think it's  some
> >> > > command based configurations for the chip via SDIO. And that I can
> >> > > refer to the BCM 43xx PCI driver codes.
> >> > > Wonder if it's feasible. Needs your comments.
> >> > > Thanks
> >> >
> >> > The first step is to be able to read/write the various registers via
> >> > SDIO. That will be similar to the PCI operations. The next step is
> >> > knowing what to read/write and when. We are still working that out for
> >> > PCI. It is not trivial. See the recent postings of patches for the LP
> >> > pHY in the linux-wireless mailing list. These are _NOT_ complete.
> >>
> >> Right.
> >>
> >> You have two completely orthogonal problems:
> >>
> >>  1) changing b43 so it knows how to talk not just to SSB/PCI/PCMCIA
> >>     chips but also SDIO chips
> >
> > We already have working support for that and we're currently merging it mainline.
> > If you want to help, please test the spinlock removal patchset I just posted.
> >
> >>  2) changing b43 so it knows how to talk to your specific radio/PHY
> >>     chip, and LP PHY
> >
> > Also almost working and in the progress of merging mainline.
> 
> Not necessarily true in this case - an important 4325-specific routine
> (SSB PMU recalibration) is still missing. (And I don't tink I'm
> familiar enough with ssb to do that, unfortunately.)

I can do that later. It's a fairly simple routine (to me knowing the code :).

-- 
Greetings, Michael.
