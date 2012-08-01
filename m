Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:60752 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531Ab2HARjJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 13:39:09 -0400
Date: Wed, 1 Aug 2012 13:38:47 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <stable@vger.kernel.org>,
	<liang.li@windriver.com>
Subject: Re: [RFC/PATCH 0/1] Fix inability to configure adhoc in 3.4.x
Message-ID: <20120801173847.GA13879@windriver.com> (sfid-20120801_193916_345285_BE50CF01)
References: <1343837663-12645-1-git-send-email-paul.gortmaker@windriver.com>
 <1343838717.4638.9.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1343838717.4638.9.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[Re: [RFC/PATCH 0/1] Fix inability to configure adhoc in 3.4.x] On 01/08/2012 (Wed 18:31) Johannes Berg wrote:

> On Wed, 2012-08-01 at 12:14 -0400, Paul Gortmaker wrote:
> 
> [...]
> 
> > However, things still weren't right unless he also cherry picked the
> > 8e8b41f9d8c8e6 ("cfg80211: enforce lack of interface combinations")
> > to get the later mentioned "total == 1" check within, so that we
> > avoid the EBUSY above.  But this commit causes other regressions
> > (as described in the commit log of the attached patch) so we didn't
> > think it best to go that route for 3.4.x.
> > 
> > So, the options we considered (to fix 3.4.x stable) were:
> > 
> > 1) cherry pick 8e8b41f9d, and all the driver specific changes it requires
> > 
> > 2) make a sub-commit for stable that just takes the total==1 from #1.
> > 
> > 3) patch iwlwifi/iwl-mac80211.c and add ".types = BIT(NL80211_IFTYPE_ADHOC)"
> > 
> > 4) treat ADHOC as a universal feature that everyone has.
> > 
> > The following patch does #4, and in theory it could be used in mainline
> > and then cherry picked back to stable.  But we weren't 100% sure if that
> > was the best solution, since neither of us are really wireless people,
> > hence all the detail here.
> 
> Thanks for the detailed analysis. Given 8e8b41f9d, I don't think any
> mainline changes are actually needed?

Perhaps not.  I know Liang was looking at the ath5k and ath9k changes:

  9b4760e  ath5k: add possible wiphy interface combinations
  20c8e8d  ath9k: add possible wiphy interface combinations

and thinking that the above commits plus the "total==1" change
wouldn't fix any ATH multifunction cards (if they exist) in the
ad-hoc use case - but we didn't have such hardware to test with.

And from what you say below, maybe they should not be, if there
are cards which don't support it.

> 
> I don't think #4 is right, not all drivers do in fact support IBSS.
> Making them advertise it will just cause issues.
> 
> I think #2 would be the best option.

OK, no problem.  We can do that and resend.  I'll give Liang a chance
to catch up on the reading (different time zone) and confirm I've
captured all his descriptions properly before resending.

Thanks,
Paul.

> 
> johannes
> 
