Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36478 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab2JALNy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Oct 2012 07:13:54 -0400
Message-ID: <1349090067.10330.23.camel@jlt4.sipsolutions.net> (sfid-20121001_131440_790560_1CAE4D44)
Subject: Re: [PATCH v2 1/5] {nl,cfg}80211: add a flags word to scan requests
From: Johannes Berg <johannes@sipsolutions.net>
To: Sam Leffler <sleffler@chromium.org>
Cc: Bing Zhao <bzhao@marvell.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Mon, 01 Oct 2012 13:14:27 +0200
In-Reply-To: <CA+yqC4bMwqLr8oMuWYKWz+QhVscBe_KGnzHLEORKLVh2Ruj3bw@mail.gmail.com> (sfid-20120928_223611_662533_D20F3BE5)
References: <1348772354-15936-1-git-send-email-bzhao@marvell.com>
	 <1348772354-15936-2-git-send-email-bzhao@marvell.com>
	 <1348830066.13298.21.camel@jlt4.sipsolutions.net>
	 <CA+yqC4bMwqLr8oMuWYKWz+QhVscBe_KGnzHLEORKLVh2Ruj3bw@mail.gmail.com>
	 (sfid-20120928_223611_662533_D20F3BE5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-09-28 at 13:36 -0700, Sam Leffler wrote:
> On Fri, Sep 28, 2012 at 4:01 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Thu, 2012-09-27 at 11:59 -0700, Bing Zhao wrote:
> >> From: Sam Leffler <sleffler@chromium.org>
> >>
> >> Add a flags word to direct and scheduled scan requests; it will
> >> be used for control of optional behaviours such as flushing the
> >> bss cache prior to doing a scan.
> >
> > Why for scheduled scan as well?
> 
> Because I thought the scheduled scan mechanism is used to trigger
> periodic scans w/o involving user space and so might be used to do
> bgscan's.  Please enlighten me.

It could be used for that, but I don't see any handling for scheduled
scans in this code. And this also goes into the question about
advertising the features, since scheduled scan is always implemented by
the driver -- there's little value in implementing it in mac80211 since
then it's software anyway and wpa_s can just do the triggering. Then the
question will be: does the driver support it or not, and should we
advertise whether it's supported or not.

Also for scheduled scan, I'm not sure how the flushing would work? You
don't seem to have implemented that.

> >> + * @NL80211_ATTR_SCAN_FLAGS: scan request control flags (u32)
> >
> > One thing that might be useful is to advertise which flags are even
> > supported at all by a driver, if we add different ones? We might then
> > ignore the flags that we don't support anyway, but at least userspace
> > would know that it can't expect flushing (for example) on an older
> > kernel version and might have to use some workarounds or whatever.
> 
> Yes I considered this. I don't know what the model is for nl80211 in
> this regard (think we've talked about this in the past).  The low
> priority scan flag is somewhat advisory so applications should be able
> to deal w/ it being ignored.  The flush flag however may be cause some
> misbehaviour--e.g. you wakeup, scan, and then act on stale results
> that may cause you try and associate to an ap that's out of range in
> which case you'll end up doing the equivalent to the flush in user
> space to make sure the right thing happens.

I'd say there are different possible implementations here. One way would
be to advertise the nl80211 scan flags attribute with the device
information and set all the supported bits, at least the ones that are
important like the flush one, and document the advisory ones as such.

For other more generic features we'd probably use nl80211_feature_flags,
but here I'd suggest the above, putting the attribute into the device
information with the supported bits set, which today would be only the
flush one which is handled in cfg80211 so we don't (yet) need driver
information for it if low-prio is advisory.

There's one complication though with scheduled scan, since that'd
require a different feature attribute unless we want to mandate that all
flags must always be supported in both or neither, which I'm not sure is
realistic.

How if "flush" supposed to behave in scheduled scan anyway?

> >> +/**
> >> + * enum nl80211_scan_flags -  scan request control flags

> >> + * enum cfg80211_scan_flags -  scan request control flags

> > That doesn't make a lot of sense? A single enum seems sufficient?
> 
> I thought cfg80211's name space was separate from nl80211's?  Was just
> trying to follow what I found elsewhere...

Yeah there are a few (old) examples of this (e.g. band enum), but they
aren't really separate any more, we have the namespaces more like this
(in maths/latex notation):

nl80211 $\subset$ cfg80211 $\subset$ mac80211

At some point maybe I'll clean up the old examples. I think there might
also be a few where the cfg80211 value is BIT() of the nl80211 value,
but I'm not really sure.

johannes


