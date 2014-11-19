Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38282 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbaKSLmD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 06:42:03 -0500
Message-ID: <1416397317.9374.1.camel@sipsolutions.net> (sfid-20141119_124207_571323_EAB3B67F)
Subject: Re: [PATCH 16/16] mac80211: synchronously reserve TID per station
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Liad Kaufman <liad.kaufman@intel.com>
Date: Wed, 19 Nov 2014 12:41:57 +0100
In-Reply-To: <CA+XVXfefE7=o3v52-_a9QZ3FemNJ1KxOHXG6Qt3896Q=Y4CA=A@mail.gmail.com> (sfid-20141119_124025_835027_B0C2CEB6)
References: <1415551822-20121-1-git-send-email-arik@wizery.com>
	 <1415551822-20121-16-git-send-email-arik@wizery.com>
	 <1416396152.9374.0.camel@sipsolutions.net>
	 <CA+XVXfefE7=o3v52-_a9QZ3FemNJ1KxOHXG6Qt3896Q=Y4CA=A@mail.gmail.com>
	 (sfid-20141119_124025_835027_B0C2CEB6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-11-19 at 13:40 +0200, Arik Nemtsov wrote:
> On Wed, Nov 19, 2014 at 1:22 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Sun, 2014-11-09 at 18:50 +0200, Arik Nemtsov wrote:
> >
> >> +     if (WARN_ON(tid >= IEEE80211_NUM_TIDS))
> >> +             return -EINVAL;
> >
> > That validates < 16
> >
> >> +     queues = BIT(sdata->vif.hw_queue[ieee802_1d_to_ac[tid]]);
> >
> > but that's only valid for < 8, causing a smatch warning.
> 
> It's a valid warning. It should be tid & 7 here. I'll send a fix.

yes, but I think &7 is wrong too - TIDs (really TSIDs) 8-15 don't have a
static AC mapping, and we don't support them anyway. I think the sanity
check should just make sure it's < 8.

johannes

