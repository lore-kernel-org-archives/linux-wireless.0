Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45656 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab2BXHel (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 02:34:41 -0500
Subject: Re: [RFC] mac80211: Filter duplicate IE ids
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@chromium.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20120224033729.9256A205A0@glenhelen.mtv.corp.google.com> (sfid-20120224_043736_015339_A91A0A49)
References: <20120224033729.9256A205A0@glenhelen.mtv.corp.google.com>
	 (sfid-20120224_043736_015339_A91A0A49)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Feb 2012 08:34:37 +0100
Message-ID: <1330068877.3426.6.camel@jlt3.sipsolutions.net> (sfid-20120224_083453_955533_3FB4DC8E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-02-23 at 17:59 -0800, Paul Stewart wrote:
> mac80211 is lenient with respect to reception of corrupted beacons.
> Even if the frame is corrupted as a whole, the available IE elements
> are still passed back and accepted, sometimes replacing legitimate
> data.  It is unknown to what extent this "feature" is made use of,
> but it is clear that in some cases, this is detrimental.  One such
> case is reported in http://crosbug.com/26832 where an AP corrupts
> its beacons but not its probe responses.
> 
> One approach would be to completely reject frames with invaid data
> (for example, if the last tag extends beyond the end of the enclosing
> PDU).  The enclosed approach is much more conservative: we simply
> prevent later IEs from overwriting the state from previous ones.
> This approach hopes that there might be some salient data in the
> IE stream before the corruption, and seeks to at least prevent that
> data from being overwritten.  This approach will fix the case above.
> 
> Short of any statistics gathering in the various forms of AP breakage,
> it's not possible to ascertain the side effects of more stringent
> discarding of data.

Hmmm. This seems reasonable, but in the given example (in the bug
report) it will at least lose the WMM info (since it's corrupt) and the
HT info, as well as WPS (which is probably not relevant.)

I suppose better to accept such service degradation than not connect,
but I wonder if we should log a warning when we actually try to use such
an AP?

johannes


