Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47716 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933241Ab3BLQCm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 11:02:42 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 11/15] iwlwifi: dvm: apply beacon changes immediately
Date: Tue, 12 Feb 2013 17:02:03 +0100
Message-Id: <1360684927-1367-11-git-send-email-johannes@sipsolutions.net> (sfid-20130212_170256_196094_5CCC4E77)
In-Reply-To: <1360684927-1367-1-git-send-email-johannes@sipsolutions.net>
References: <1360684891.29913.4.camel@jlt4.sipsolutions.net>
 <1360684927-1367-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If the AP/GO beacon changes, apply such a change
immediately, otherwise the AP/GO beacon can be
stale for a long time.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/rxon.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/rxon.c b/drivers/net/wireless/iwlwifi/dvm/rxon.c
index 9fabd26..23be948 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rxon.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rxon.c
@@ -1545,10 +1545,9 @@ void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
 				bss_conf->bssid);
 	}
 
-	if (changes & BSS_CHANGED_BEACON && vif->type == NL80211_IFTYPE_ADHOC &&
-	    priv->beacon_ctx) {
+	if (changes & BSS_CHANGED_BEACON && priv->beacon_ctx == ctx) {
 		if (iwlagn_update_beacon(priv, vif))
-			IWL_ERR(priv, "Error sending IBSS beacon\n");
+			IWL_ERR(priv, "Error updating beacon\n");
 	}
 
 	mutex_unlock(&priv->mutex);
-- 
1.8.0

