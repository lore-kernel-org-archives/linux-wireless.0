Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:6260 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932619Ab3LDPmo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Dec 2013 10:42:44 -0500
From: Max.Stepanov@intel.com
To: linux-wireless@vger.kernel.org
Cc: Max Stepanov <Max.Stepanov@intel.com>
Subject: [PATCH] cfg80211: check pairwise key_idx on get_key call
Date: Wed,  4 Dec 2013 17:42:22 +0200
Message-Id: <1386171742-5382-1-git-send-email-Max.Stepanov@intel.com> (sfid-20131204_164250_559785_A21BB23D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Max Stepanov <Max.Stepanov@intel.com>

Verify that a pairwise key index value on ieee80211_get_key call
doesn't exceed the boundaries of the pairwise key array.

Signed-off-by: Max Stepanov <Max.Stepanov@intel.com>
---
 net/mac80211/cfg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 8e70df0..00fa219 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -301,9 +301,9 @@ static int ieee80211_get_key(struct wiphy *wiphy, struct net_device *dev,
 		if (!sta)
 			goto out;
 
-		if (pairwise)
+		if (pairwise && key_idx < NUM_DEFAULT_KEYS)
 			key = rcu_dereference(sta->ptk[key_idx]);
-		else if (key_idx < NUM_DEFAULT_KEYS)
+		else if (!pairwise && key_idx < NUM_DEFAULT_KEYS)
 			key = rcu_dereference(sta->gtk[key_idx]);
 	} else
 		key = rcu_dereference(sdata->keys[key_idx]);
-- 
1.8.5.rc2

