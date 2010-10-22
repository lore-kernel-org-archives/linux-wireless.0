Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63015 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756897Ab0JVPBo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Oct 2010 11:01:44 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 7/7] iwlwifi: avoid commit rxon during scan in iwl_set_no_assoc
Date: Fri, 22 Oct 2010 17:04:30 +0200
Message-Id: <1287759870-5758-7-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1287759870-5758-1-git-send-email-sgruszka@redhat.com>
References: <1287759870-5758-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently we are canceling scan when changing BSSID. Behave the same
when changing association and beacon enablement, to avoid committing
rxon during scan in iwl_set_no_assoc().

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 8bbd152..87c1800 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1590,6 +1590,19 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 
 	mutex_lock(&priv->mutex);
 
+	if (changes & (BSS_CHANGED_BSSID | BSS_CHANGED_ASSOC |
+		       BSS_CHANGED_BEACON_ENABLED)) {
+		/*
+		 * If there is currently a HW scan going on in the
+		 * background then we need to cancel it else the RXON
+		 * below in post_associate or set_no_assoc can fail.
+		 */
+		if (iwl_scan_cancel_timeout(priv, 200)) {
+			IWL_WARN(priv, "Can not cancel scan\n");
+			goto out;
+		}
+	}
+
 	if (changes & BSS_CHANGED_QOS) {
 		unsigned long flags;
 
@@ -1622,18 +1635,6 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 	if (changes & BSS_CHANGED_BSSID) {
 		IWL_DEBUG_MAC80211(priv, "BSSID %pM\n", bss_conf->bssid);
 
-		/*
-		 * If there is currently a HW scan going on in the
-		 * background then we need to cancel it else the RXON
-		 * below/in post_associate will fail.
-		 */
-		if (iwl_scan_cancel_timeout(priv, 100)) {
-			IWL_WARN(priv, "Aborted scan still in progress after 100ms\n");
-			IWL_DEBUG_MAC80211(priv, "leaving - scan abort failed.\n");
-			mutex_unlock(&priv->mutex);
-			return;
-		}
-
 		/* mac80211 only sets assoc when in STATION mode */
 		if (vif->type == NL80211_IFTYPE_ADHOC || bss_conf->assoc) {
 			memcpy(ctx->staging.bssid_addr,
@@ -1752,6 +1753,7 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 			IWL_ERR(priv, "failed to update PAN params\n");
 	}
 
+out:
 	mutex_unlock(&priv->mutex);
 
 	IWL_DEBUG_MAC80211(priv, "leave\n");
-- 
1.7.1

