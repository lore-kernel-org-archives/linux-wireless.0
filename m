Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36449 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514Ab2JALFz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Oct 2012 07:05:55 -0400
Message-ID: <1349089586.10330.15.camel@jlt4.sipsolutions.net> (sfid-20121001_130603_511622_093A00B8)
Subject: Re: [PATCH v2 3/5] cfg80211: add support for flushing old scan
 results
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Sam Leffler <sleffler@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Mon, 01 Oct 2012 13:06:26 +0200
In-Reply-To: <477F20668A386D41ADCC57781B1F7043083B590CDE@SC-VEXCH1.marvell.com>
References: <1348772354-15936-1-git-send-email-bzhao@marvell.com>
	 <1348772354-15936-4-git-send-email-bzhao@marvell.com>
	 <1348830246.13298.24.camel@jlt4.sipsolutions.net>
	 <477F20668A386D41ADCC57781B1F7043083B590CDE@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-09-28 at 12:47 -0700, Bing Zhao wrote:

> > Here, you could just pass "jiffies - SCAN_RESULT_EXPIRE" as the maxage
> > and get pretty much the same behaviour as before without a second
> > parameter.
> 
> __cfg80211_bss_expire(dev, jiffies - IEEE80211_SCAN_RESULT_EXPIRE);
> 
> This is similar to the code in v1 (below):
> 
> __cfg80211_bss_expire(rdev, jiffies - request->scan_start);

Well, they look similar, but these are different calculations. The first
yields an absolute time, while the second yields a relative time. With
these, say we call them T_abs and T_rel, you'd do the following
comparisons

 remove = (timestamp < T_abs)

or

 remove = (timestamp < jiffies - T_rel)

respectively. The "problem" that I pointed out is that in the latter
case jiffies keeps running, so you would really have (resolving T_rel)

 remove = (timestamp < jiffies_1 - (jiffies_2 - scan_start))
        = (timestamp < jiffies_1 - jiffies_2 + scan_start)

when you really want
 remove = timestamp < scan_start

If jiffies_1 == jiffies_2, then the two are the same, obviously, but
since you're doing calculations against a running counter it's not
guaranteed. With the absolute timestamp based calculations (T_abs above)
you don't run into that problem.

> It may still have the small race condition you commented in v1?
> Please let me know if I misunderstood it.

Well I should also say that the race condition is really fairly
theoretical, unless you have a very small HZ and calculate T_rel just
before the roll-over, in which case jiffies_1 and jiffies_2 above could
actually differ by a fair amount (tens of milliseconds in wall time.)

Regardless, I think if we're going to have absolute time here in any way
(today we only have relative time for age-based expiry) we should do
calculations and comparisons in absolute rather than relative time.

Hth!

johannes

