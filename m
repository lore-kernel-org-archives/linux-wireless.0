Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44085 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab2HAQcB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 12:32:01 -0400
Message-ID: <1343838717.4638.9.camel@jlt3.sipsolutions.net> (sfid-20120801_183227_820051_48947417)
Subject: Re: [RFC/PATCH 0/1] Fix inability to configure adhoc in 3.4.x
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, stable@vger.kernel.org,
	liang.li@windriver.com
Date: Wed, 01 Aug 2012 18:31:57 +0200
In-Reply-To: <1343837663-12645-1-git-send-email-paul.gortmaker@windriver.com> (sfid-20120801_181448_175333_E1A6DA81)
References: <1343837663-12645-1-git-send-email-paul.gortmaker@windriver.com>
	 (sfid-20120801_181448_175333_E1A6DA81)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-08-01 at 12:14 -0400, Paul Gortmaker wrote:

[...]

> However, things still weren't right unless he also cherry picked the
> 8e8b41f9d8c8e6 ("cfg80211: enforce lack of interface combinations")
> to get the later mentioned "total == 1" check within, so that we
> avoid the EBUSY above.  But this commit causes other regressions
> (as described in the commit log of the attached patch) so we didn't
> think it best to go that route for 3.4.x.
> 
> So, the options we considered (to fix 3.4.x stable) were:
> 
> 1) cherry pick 8e8b41f9d, and all the driver specific changes it requires
> 
> 2) make a sub-commit for stable that just takes the total==1 from #1.
> 
> 3) patch iwlwifi/iwl-mac80211.c and add ".types = BIT(NL80211_IFTYPE_ADHOC)"
> 
> 4) treat ADHOC as a universal feature that everyone has.
> 
> The following patch does #4, and in theory it could be used in mainline
> and then cherry picked back to stable.  But we weren't 100% sure if that
> was the best solution, since neither of us are really wireless people,
> hence all the detail here.

Thanks for the detailed analysis. Given 8e8b41f9d, I don't think any
mainline changes are actually needed?

I don't think #4 is right, not all drivers do in fact support IBSS.
Making them advertise it will just cause issues.

I think #2 would be the best option.

johannes

