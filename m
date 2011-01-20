Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56006 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839Ab1ATJtt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 04:49:49 -0500
Subject: Re: [RFC 4/4] mac80211: support for IEEE80211N in IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Simon <alexander.simon@saxnet.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <loom.20110120T102902-813@post.gmane.org>
References: <201101191438.01161.alexander.simon@saxnet.de>
	 <1295447708.4685.5.camel@jlt3.sipsolutions.net>
	 <loom.20110120T102902-813@post.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Jan 2011 10:49:48 +0100
Message-ID: <1295516988.3693.28.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-01-20 at 09:37 +0000, Alexander Simon wrote:
> This adds some ifs to let the packet aggregation also
> work while being in IBSS mode.
> 

Ok this one's a pretty well-split up patch, but

 * the subject should be more specific, like
   "mac80211: allow aggregation in IBSS mode"
 * the description should be more results-oriented,
   for example: "Allow aggregation sessions to be
   started in IBSS mode." The stuff about "add ifs"
   really isn't necessary we can all look at the code :-)
 * you missed Signed-off-by
 * your patch was line-wrapped, so it can't be applied

As for the other three patches, I don't think they were split up well --
the first one should be cfg80211 specific, and 2/3 should probably be
just one patch? Also for patches 1-3 the line wrapping in the commit log
was very awkward, try to stay < 72 characters per line.

However, if you combine 2 and 3, I still think you need a preliminary
patch to do the refactoring between the code that builds the HT IEs for
IBSS and ieee80211_add_ht_ie(). In fact, I notice there's similar code
in ieee80211_build_preq_ies() so a really good refactoring would take
code from both and replace it with a shared version that IBSS becomes
the third user of.

Have you seen
http://wireless.kernel.org/en/developers/Documentation/SubmittingPatches?

Thanks for your effort!

johannes

