Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:12646 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814AbbJYJAN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 05:00:13 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/10] mac80211: further improve "no supported rates" warning
Date: Sun, 25 Oct 2015 10:59:42 +0200
Message-Id: <1445763582-11421-10-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151025_100023_992130_399C7D5F)
In-Reply-To: <1445763582-11421-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1445763582-11421-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Allow distinguishing the non-station case from the case of a
station without rates, by using -1 for the non-station case.
This value cannot be reached with a station since that many
legacy rates don't exist.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/rate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index b07e2f7..a4e2f4e 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -307,7 +307,7 @@ static void __rate_control_send_low(struct ieee80211_hw *hw,
 	}
 	WARN_ONCE(i == sband->n_bitrates,
 		  "no supported rates (0x%x) in rate_mask 0x%x with flags 0x%x\n",
-		  sta ? sta->supp_rates[sband->band] : 0,
+		  sta ? sta->supp_rates[sband->band] : -1,
 		  rate_mask, rate_flags);
 
 	info->control.rates[0].count =
-- 
2.1.4

