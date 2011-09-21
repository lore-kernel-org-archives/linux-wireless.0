Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3016 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256Ab1IUSdf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 14:33:35 -0400
From: "Brett Rudley" <brudley@broadcom.com>
To: "Greg KH" <greg@kroah.com>,
	"John W. Linville" <linville@tuxdriver.com>
cc: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 21 Sep 2011 11:33:25 -0700
Subject: RE: [PATCH 00/20] staging: brcm80211: 7th reaction for mainline
 patch #2
Message-ID: <7A94256FD72B884D9E7C55586C3CBCEE195814DD85@SJEXCHCCR01.corp.ad.broadcom.com> (sfid-20110921_203340_421339_EDE6DADE)
References: <1316467568-27683-1-git-send-email-frankyl@broadcom.com>
 <20110920130338.GA9885@kroah.com> <20110920132203.GB7800@tuxdriver.com>
 <20110920140020.GA11386@kroah.com>
In-Reply-To: <20110920140020.GA11386@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Tue, Sep 20, 2011 at 09:22:03AM -0400, John W. Linville wrote:
> > On Tue, Sep 20, 2011 at 06:03:38AM -0700, Greg KH wrote:
> > > On Mon, Sep 19, 2011 at 02:25:48PM -0700, Franky Lin wrote:
> > > > Code clean up for fullmac.
> > >
> > > Ok, this is the 7th patch series since the last round of "how do we
> get
> > > our driver into mainline" happened.
> > >
> > > And while code is great and nice, I still haven't seen any real
> answers
> > > to all of the questions that were asked of the Broadcom driver team
> > > during that review by the linux-wireless developers about how things
> > > will be handled properly due to the overlap in functionality with the
> > > existing "real" driver in the tree.
> > >
> > > So, can you please start answering these questions?  I'm loath to
> keep
> > > accepting patches until that all gets straightened out as it
> potentially
> > > wastes my, and your, time by doing so.
> > >
> > > In other words, I'm not going to apply any more patches until this
> gets
> > > resolved.  Consider this patchset dropped from my to-apply queue for
> now
> > > because of that.
> >
> > I think most of the outstanding series from Broadcom are
> > (almost?) exclusively for their fullmac driver, which has not overlap
> > with b43.  We should be moving forward toward getting the fullmac
> > driver into wireless-next.
> 
> Ok, that's great, but again, no one from Broadcom has said what their
> plans are, only sent lots of patches, which while wonderful, has caused
> some confusion on my and other parts.
> 
> greg k-h

Our original plan was to remain a separate driver from b43. We were aware of it and all the good work that had been done to create it and we had no intention of interfering with it.  At that point there had not been very much recent movement in b43 and it did not support any of our AXI based chips.  We figured that ssb vs AXI was a good dividing line and there would be no conflict, and there wasn't initially.

Internally, prior to releasing to staging tree, development had gone quickly and it didn't take long at all to get the driver up and running.  We did not anticipate that things would go somewhat slower in the staging tree and a year (and hundreds of patches) later we are still there.  During that year b43 got some limited support for the same new chips brcmsmac already had, into its driver.  So now, here we are... both drivers supporting the new chips and b43 also supporting the old.  

We have seen the requests for us to add AXI based chipset support into b43.  I don't think that will happen in a substantial way:
- Our driver is already stable and performance is better than b43 in terms of AXI chips.  B43 seems quite raw: its full of TODO and FIXME notes and performance is 1/10th of brcmsmac on our testing. Spending another round of time and effort on b43 to get it to the place where smac already is, seems redundant and unattractive. 

- Much of brcmsmac code comes from our internal source which has whole organizations charged with testing it for compliance, compatibility, performance, etc. We understand that that is of no direct consequence but since brcmsmac code is a direct descendent of that code, much of that background still applies. Switching to b43 would mean throwing all that infrastructure and testing away and going with a driver that has none of that (that I know of).

- Most of the recent b43 additions support comes from a single person doing reverse engineering. brcmsmac has a few software people working on it directly and hundreds of people working on it indirectly (through the internal version) including engineers working on firmware, RTL, testing, etc.   

- B43 team has made the case several times that it has more features than brcmsmac.  A reminder: We were specifically asked NOT to add features while in staging tree and we have held back on features to honor that request.  AP, IBSS, 40 Mhz, using bcma, hw crypto and others, are all features we have been waiting to do.   We also have a backlog of several new chips we want to add.  And of course, we will would be adding future chips and features as they come out.

We invested a year trying to be good Linux citizens, laying out our initial plans, following the rules, working transparently, folding in feedback, submitting hundreds of patches in plain sight of everyone and now folks are asking about our plan.  Our plan is get the brcmsmac and brcmfmac into mainline and keep following that up with new features, new chips and continuing support.

Other than barely supporting one of our chips first in mainline, I would really like to understand what are the benefits and justifications of using b43 over brcmsmac for AXI based chips in the long run.  Can someone explain them?


Brett


