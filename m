Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52568 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab2KIIsX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2012 03:48:23 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v3.7] mac80211: fix memory leak in device registration error path
Date: Fri,  9 Nov 2012 09:48:58 +0100
Message-Id: <1352450938-27533-1-git-send-email-johannes@sipsolutions.net> (sfid-20121109_094838_363840_A9CAFA83)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If the cipher suites need to be allocated, but this
allocation fails, this leaks the internal scan request.
Fix that by going to the correct error handling label.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index c80c449..f57f597 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -871,8 +871,10 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 				local->hw.wiphy->cipher_suites,
 				sizeof(u32) * local->hw.wiphy->n_cipher_suites,
 				GFP_KERNEL);
-			if (!suites)
-				return -ENOMEM;
+			if (!suites) {
+				result = -ENOMEM;
+				goto fail_wiphy_register;
+			}
 			for (r = 0; r < local->hw.wiphy->n_cipher_suites; r++) {
 				u32 suite = local->hw.wiphy->cipher_suites[r];
 				if (suite == WLAN_CIPHER_SUITE_WEP40 ||
-- 
1.8.0

