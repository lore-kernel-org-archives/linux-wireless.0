Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:37826 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbaFKGzf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 02:55:35 -0400
Received: by mail-we0-f179.google.com with SMTP id w62so4181249wes.10
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jun 2014 23:55:33 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 3/5] cfg80211: treat the special "unknown" alpha2 as valid
Date: Wed, 11 Jun 2014 09:55:22 +0300
Message-Id: <1402469724-22358-3-git-send-email-arik@wizery.com> (sfid-20140611_085539_642507_B3A6B630)
In-Reply-To: <1402469724-22358-1-git-send-email-arik@wizery.com>
References: <1402469724-22358-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the regulatory request contains the special "99" unknown-country code,
allow a different alpha2 as response.

This special alpha2 is used when the real alpha2 is unknown and should
be provided by the driver via its get_regd() wiphy callback, as part of
the regdomain info.

Change-Id: I286e3aed828cabf22292b6fe320fdcfa61f0b951
Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-on: https://gerrit.rds.intel.com/32266
Tested-by: IWL Jenkins
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
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
1.9.1

