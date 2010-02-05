Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:28731 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753751Ab0BETeP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2010 14:34:15 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Samuel Ortiz <sameo@linux.intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/3] iwlwifi: Send broadcast probe request only when asked to
Date: Fri,  5 Feb 2010 11:33:48 -0800
Message-Id: <1265398428-8048-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1265398428-8048-1-git-send-email-reinette.chatre@intel.com>
References: <1265398428-8048-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <sameo@linux.intel.com>

When running directed active scans we currently end up sending both the SSID
probe requests and an additional broadcast one.
This is due to the fact that we always leave the probe request template SSID IE
length to 0. Instead we should set it to the first SSID to scan, and fill the
direct_scan array with the remaining SSIDs to scan for. This way we only send
what we've been asked to: a broadcast probe request when no directed scan is
requested, and directed probe requests otherwise.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c |   49 +++++++++++++++++++++----------
 2 files changed, 34 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index b528a20..f51b8cd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2631,7 +2631,7 @@ static int iwl_mac_setup_register(struct iwl_priv *priv)
 	 */
 	hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
-	hw->wiphy->max_scan_ssids = PROBE_OPTION_MAX;
+	hw->wiphy->max_scan_ssids = PROBE_OPTION_MAX + 1;
 	/* we create the 802.11 header and a zero-length SSID element */
 	hw->wiphy->max_scan_ie_len = IWL_MAX_PROBE_REQUEST - 24 - 2;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 08faafa..f786a40 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -651,9 +651,20 @@ u16 iwl_fill_probe_req(struct iwl_priv *priv, struct ieee80211_mgmt *frame,
 	if (left < 0)
 		return 0;
 	*pos++ = WLAN_EID_SSID;
-	*pos++ = 0;
-
-	len += 2;
+	if (!priv->is_internal_short_scan &&
+	    priv->scan_request->n_ssids) {
+		struct cfg80211_ssid *ssid =
+			priv->scan_request->ssids;
+
+		/* Broadcast if ssid_len is 0 */
+		*pos++ = ssid->ssid_len;
+		memcpy(pos, ssid->ssid, ssid->ssid_len);
+		pos += ssid->ssid_len;
+		len += 2 + ssid->ssid_len;
+	} else {
+		*pos++ = 0;
+		len += 2;
+	}
 
 	if (WARN_ON(left < ie_len))
 		return len;
@@ -782,20 +793,26 @@ static void iwl_bg_request_scan(struct work_struct *data)
 	if (priv->is_internal_short_scan) {
 		IWL_DEBUG_SCAN(priv, "Start internal passive scan.\n");
 	} else if (priv->scan_request->n_ssids) {
-		int i, p = 0;
 		IWL_DEBUG_SCAN(priv, "Kicking off active scan\n");
-		for (i = 0; i < priv->scan_request->n_ssids; i++) {
-			/* always does wildcard anyway */
-			if (!priv->scan_request->ssids[i].ssid_len)
-				continue;
-			scan->direct_scan[p].id = WLAN_EID_SSID;
-			scan->direct_scan[p].len =
-				priv->scan_request->ssids[i].ssid_len;
-			memcpy(scan->direct_scan[p].ssid,
-			       priv->scan_request->ssids[i].ssid,
-			       priv->scan_request->ssids[i].ssid_len);
-			n_probes++;
-			p++;
+		/*
+		 * The first SSID to scan is stuffed into the probe request
+		 * template and the remaining ones are handled through the
+		 * direct_scan array.
+		 */
+		if (priv->scan_request->n_ssids > 1) {
+			int i, p = 0;
+			for (i = 1; i < priv->scan_request->n_ssids; i++) {
+				if (!priv->scan_request->ssids[i].ssid_len)
+					continue;
+				scan->direct_scan[p].id = WLAN_EID_SSID;
+				scan->direct_scan[p].len =
+					priv->scan_request->ssids[i].ssid_len;
+				memcpy(scan->direct_scan[p].ssid,
+				       priv->scan_request->ssids[i].ssid,
+				       priv->scan_request->ssids[i].ssid_len);
+				n_probes++;
+				p++;
+			}
 		}
 		is_active = true;
 	} else
-- 
1.6.3.3

