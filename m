Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42824 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839Ab3BKK5X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 05:57:23 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: allow driver to be stateless wrt. SMSP requests
Date: Mon, 11 Feb 2013 11:57:17 +0100
Message-Id: <1360580237-6149-1-git-send-email-johannes@sipsolutions.net> (sfid-20130211_115726_883650_F746ECF9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Bail out if no update is made to the SMPS state. This
allows the driver to avoid duplicating the state.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ht.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 61ac7c4..9e7560b 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -406,6 +406,9 @@ void ieee80211_request_smps(struct ieee80211_vif *vif,
 	if (WARN_ON(smps_mode == IEEE80211_SMPS_OFF))
 		smps_mode = IEEE80211_SMPS_AUTOMATIC;
 
+	if (sdata->u.mgd.driver_smps_mode == smps_mode)
+		return;
+
 	sdata->u.mgd.driver_smps_mode = smps_mode;
 
 	ieee80211_queue_work(&sdata->local->hw,
-- 
1.8.0

