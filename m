Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3729 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724AbYA1SdO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2008 13:33:14 -0500
Date: Mon, 28 Jan 2008 13:19:00 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>, Tomas Winkler <tomasw@gmail.com>,
	stefano.brivio@polimi.it,
	Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: mac80211 crash in ieee80211_sta_scan_work
Message-ID: <20080128181900.GF5835@tuxdriver.com> (sfid-20080128_183317_446516_7E09114D)
References: <479D9B5F.5000304@lwfinger.net> <1ba2fa240801280148r27fac26ep5403bc8ccfc6d37a@mail.gmail.com> <20080128151200.GC5835@tuxdriver.com> <200801281807.26267.mb@bu3sch.de> <479E14FA.2010206@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <479E14FA.2010206@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 28, 2008 at 10:46:34AM -0700, Larry Finger wrote:
> Michael Buesch wrote:
>> On Monday 28 January 2008 16:12:00 John W. Linville wrote:
>>> I'm going to hold it back from 2.6.25.  We can work on it for 2.6.26.

>> Please apply this patch and apply fixes inside of the 2.6.25 development
>> cycle. We are in a _development_ kernel. Kernels _do_ break in development
>> stages. That is the whole reason why development kernels exist.

> I agree with Michael on this issue. Due to the uncertainty of the quality 
> of my Internet connection this winter, I no longer subscribe to 
> linux-wireless, and I'm not sure of all the discussion that went into the 
> API change. I have, however, seen the FIXME's in b43. In addition, getting 
> the code into 2.6.25-rc1 will get a lot more testers.

I think you guys are missing a couple of points...

One is that the 2.6.25 development cycle is closed.  The merge window
is now open and when it closes the stabilization period will begin,
leading until the release of 2.6.25 in several weeks or 2-3 months.
Ideally any patches sent in the merge window should already have spent
time in the -mm tree.  While that isn't always strictly enforced,
it does imply that huge patches with known breakages and unknown
remedies are not entirely welcome. :-)

The other point is that I am happy to keep this API change in
the wireless-2.6 tree for the 2.6.26 development cycle (which has
effectively already started).  Those using wireless-2.6 and -mm will
have plenty of exposure to this patch.  There will be plenty of time
to develop on top of this patch while avoiding unnecessary breakage
for normal users.

Please understand that this is the normal process.  Since the API
change that was only merged into my tree on the same day as 2.6.24 was
released, merging the patch for 2.6.25 would be the (IMHO unnecessary)
exception.

Thanks

John
-- 
John W. Linville
linville@tuxdriver.com
