Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:32470 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483Ab0CJFWY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 00:22:24 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/2] Revert "iwlwifi: Send broadcast probe request only when asked to"
Date: Tue,  9 Mar 2010 21:22:19 -0800
Message-Id: <1268198539-6656-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1268198539-6656-1-git-send-email-reinette.chatre@intel.com>
References: <1268198539-6656-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

This reverts commit 21b2d8bd2f0d4e0f21ade147fd193c8b9c1fd2b9.

As explained by Johannes Berg <johannes.berg@intel.com>:
When we
build a probe request frame in the buffer with the SSID, we could
arrive over the limit of 200 bytes. When we build it in the buffer
without the SSID (wildcard) we don't arrive over 200 bytes, but the
ucode still allows direct probe in addition because it has an internal
buffer that is larger when it inserts the SSID...

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c |   49 ++++++++++---------------------
 2 files changed, 17 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 47b0214..818367b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2653,7 +2653,7 @@ static int iwl_mac_setup_register(struct iwl_priv *priv)
 	 */
 	hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
-	hw->wiphy->max_scan_ssids = PROBE_OPTION_MAX + 1;
+	hw->wiphy->max_scan_ssids = PROBE_OPTION_MAX;
 	/* we create the 802.11 header and a zero-length SSID element */
 	hw->wiphy->max_scan_ie_len = IWL_MAX_PROBE_REQUEST - 24 - 2;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index dd9ff2e..bd2f7c4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -638,20 +638,9 @@ u16 iwl_fill_probe_req(struct iwl_priv *priv, struct ieee80211_mgmt *frame,
 	if (left < 0)
 		return 0;
 	*pos++ = WLAN_EID_SSID;
-	if (!priv->is_internal_short_scan &&
-	    priv->scan_request->n_ssids) {
-		struct cfg80211_ssid *ssid =
-			priv->scan_request->ssids;
-
-		/* Broadcast if ssid_len is 0 */
-		*pos++ = ssid->ssid_len;
-		memcpy(pos, ssid->ssid, ssid->ssid_len);
-		pos += ssid->ssid_len;
-		len += 2 + ssid->ssid_len;
-	} else {
-		*pos++ = 0;
-		len += 2;
-	}
+	*pos++ = 0;
+
+	len += 2;
 
 	if (WARN_ON(left < ie_len))
 		return len;
@@ -780,26 +769,20 @@ static void iwl_bg_request_scan(struct work_struct *data)
 	if (priv->is_internal_short_scan) {
 		IWL_DEBUG_SCAN(priv, "Start internal passive scan.\n");
 	} else if (priv->scan_request->n_ssids) {
+		int i, p = 0;
 		IWL_DEBUG_SCAN(priv, "Kicking off active scan\n");
-		/*
-		 * The first SSID to scan is stuffed into the probe request
-		 * template and the remaining ones are handled through the
-		 * direct_scan array.
-		 */
-		if (priv->scan_request->n_ssids > 1) {
-			int i, p = 0;
-			for (i = 1; i < priv->scan_request->n_ssids; i++) {
-				if (!priv->scan_request->ssids[i].ssid_len)
-					continue;
-				scan->direct_scan[p].id = WLAN_EID_SSID;
-				scan->direct_scan[p].len =
-					priv->scan_request->ssids[i].ssid_len;
-				memcpy(scan->direct_scan[p].ssid,
-				       priv->scan_request->ssids[i].ssid,
-				       priv->scan_request->ssids[i].ssid_len);
-				n_probes++;
-				p++;
-			}
+		for (i = 0; i < priv->scan_request->n_ssids; i++) {
+			/* always does wildcard anyway */
+			if (!priv->scan_request->ssids[i].ssid_len)
+				continue;
+			scan->direct_scan[p].id = WLAN_EID_SSID;
+			scan->direct_scan[p].len =
+				priv->scan_request->ssids[i].ssid_len;
+			memcpy(scan->direct_scan[p].ssid,
+			       priv->scan_request->ssids[i].ssid,
+			       priv->scan_request->ssids[i].ssid_len);
+			n_probes++;
+			p++;
 		}
 		is_active = true;
 	} else
-- 
1.6.3.3

