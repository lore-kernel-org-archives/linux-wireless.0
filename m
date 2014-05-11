Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:57928 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758064AbaEKIxn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 May 2014 04:53:43 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 4/7] cfg80211: treat the special "unknown" alpha2 as valid
Date: Sun, 11 May 2014 11:50:47 +0300
Message-Id: <1399798250-20987-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140511_105348_556829_DD408BAE)
In-Reply-To: <1399798250-20987-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1399798250-20987-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

If the regulatory request contains the special "99" unknown-country code,
allow a different alpha2 as response.

This special alpha2 is used when the real alpha2 is unknown and should
be provided by the driver via its get_regd() wiphy callback, as part of
the regdomain info.

Change-Id: Ia667ebd6b018bce1a32da7da7c5143a5b8a656a7
Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/wireless/reg.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index e2f33d7..c429ec5 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -418,7 +418,8 @@ static bool is_user_regdom_saved(void)
 		return false;
 
 	/* This would indicate a mistake on the design */
-	if (WARN(!is_world_regdom(user_alpha2) && !is_an_alpha2(user_alpha2),
+	if (WARN(!is_world_regdom(user_alpha2) && !is_an_alpha2(user_alpha2) &&
+		 !is_unknown_alpha2(user_alpha2),
 		 "Unexpected user alpha2: %c%c\n",
 		 user_alpha2[0], user_alpha2[1]))
 		return false;
@@ -595,7 +596,8 @@ bool reg_is_valid_request(const char *alpha2)
 	if (!lr || lr->processed)
 		return false;
 
-	return alpha2_equal(lr->alpha2, alpha2);
+	return alpha2_equal(lr->alpha2, alpha2) ||
+	       is_unknown_alpha2(lr->alpha2);
 }
 
 static const struct ieee80211_regdomain *reg_get_regdomain(struct wiphy *wiphy)
-- 
1.8.3.2

