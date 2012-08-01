Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:46740 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab2HAQOo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 12:14:44 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Johannes Berg <johannes.berg@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, stable@vger.kernel.org,
	liang.li@windriver.com,
	Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [RFC/PATCH 0/1] Fix inability to configure adhoc in 3.4.x
Date: Wed,  1 Aug 2012 12:14:22 -0400
Message-Id: <1343837663-12645-1-git-send-email-paul.gortmaker@windriver.com> (sfid-20120801_181448_175333_E1A6DA81)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Normally a single patch doesn't warrant a 0/1, but Liang did some
digging on this problem and came up with important background, and
several possible solutions, so I wanted to capture what he'd learned.

The issues with creating an ad-hoc network started in 3.4.3 with the
cherry pick of 463454b5dbd ("cfg80211: fix interface combinations check")
on intel hardware (iwl-mac80211.c) that doesn't support multi-function
or virtual interfaces.  Specifically, it adds this:

+               if ((all_iftypes & used_iftypes) != used_iftypes)
+                       goto cont;

and we have the case for Intel cards that all_iftypes equal to 0b1100
but used_iftypes equal to 0b0010 hence we hit 'goto cont' to miss the
'return 0' and now get EBUSY.

Liang identified f8cdddb8d61d ("cfg80211: check iface combinations
only when iface is running") as part of the fix (now in 3.4.6)

However, things still weren't right unless he also cherry picked the
8e8b41f9d8c8e6 ("cfg80211: enforce lack of interface combinations")
to get the later mentioned "total == 1" check within, so that we
avoid the EBUSY above.  But this commit causes other regressions
(as described in the commit log of the attached patch) so we didn't
think it best to go that route for 3.4.x.

So, the options we considered (to fix 3.4.x stable) were:

1) cherry pick 8e8b41f9d, and all the driver specific changes it requires

2) make a sub-commit for stable that just takes the total==1 from #1.

3) patch iwlwifi/iwl-mac80211.c and add ".types = BIT(NL80211_IFTYPE_ADHOC)"

4) treat ADHOC as a universal feature that everyone has.

The following patch does #4, and in theory it could be used in mainline
and then cherry picked back to stable.  But we weren't 100% sure if that
was the best solution, since neither of us are really wireless people,
hence all the detail here.

Thanks,
Paul.
---

Liang Li (1):
  cfg80211: fix combination check for ADHOC

 net/wireless/util.c | 2 ++
 1 file changed, 2 insertions(+)

-- 
1.7.11.1

