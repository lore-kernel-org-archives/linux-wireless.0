Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:40450 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbeHTLXb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Aug 2018 07:23:31 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        =?UTF-8?q?Grzegorz=20Duszy=C5=84ski?= <gfduszynski@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: remove division by size of sizeof(struct ieee80211_wmm_rule)
Date: Mon, 20 Aug 2018 09:37:05 +0200
Message-Id: <20180820073705.9683-1-johannes@sipsolutions.net> (sfid-20180820_100856_002045_44BFB39F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Pointer arithmetic already adjusts by the size of the struct,
so the sizeof() calculation is wrong. This is basically the
same as Colin King's patch for similar code in the iwlwifi
driver.

Fixes: 230ebaa189af ("cfg80211: read wmm rules from regulatory database")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 4fc66a117b7d..283902974fbf 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -452,8 +452,7 @@ reg_copy_regd(const struct ieee80211_regdomain *src_regd)
 			continue;
 
 		regd->reg_rules[i].wmm_rule = d_wmm +
-			(src_regd->reg_rules[i].wmm_rule - s_wmm) /
-			sizeof(struct ieee80211_wmm_rule);
+			(src_regd->reg_rules[i].wmm_rule - s_wmm);
 	}
 	return regd;
 }
-- 
2.14.4
