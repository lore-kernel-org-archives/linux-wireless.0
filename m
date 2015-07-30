Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:36497 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbbG3Kyp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 06:54:45 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v3 11/19] wil6210: sort IEs handling
Date: Thu, 30 Jul 2015 13:51:59 +0300
Message-Id: <1438253527-3372-12-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150730_130716_771647_9BCD26AE)
In-Reply-To: <1438253527-3372-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1438253527-3372-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sort overall IE's handling
prepare code (disabled for now) to add IEs for the beacon

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 78 +++++++++++------------------
 1 file changed, 29 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index e4be2d9..8811174 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -722,46 +722,51 @@ static int wil_fix_bcon(struct wil6210_priv *wil,
 {
 	struct ieee80211_mgmt *f = (struct ieee80211_mgmt *)bcon->probe_resp;
 	size_t hlen = offsetof(struct ieee80211_mgmt, u.probe_resp.variable);
-	int rc = 0;
 
 	if (bcon->probe_resp_len <= hlen)
 		return 0;
 
+/* always use IE's from full probe frame, they has more info
+ * notable RSN
+ */
+	bcon->proberesp_ies = f->u.probe_resp.variable;
+	bcon->proberesp_ies_len = bcon->probe_resp_len - hlen;
 	if (!bcon->assocresp_ies) {
-		bcon->assocresp_ies = f->u.probe_resp.variable;
-		bcon->assocresp_ies_len = bcon->probe_resp_len - hlen;
-		rc = 1;
+		bcon->assocresp_ies = bcon->proberesp_ies;
+		bcon->assocresp_ies_len = bcon->proberesp_ies_len;
 	}
 
-	return rc;
+	return 1;
 }
 
 /* internal functions for device reset and starting AP */
 static int _wil_cfg80211_set_ies(struct wiphy *wiphy,
-				 size_t probe_ies_len, const u8 *probe_ies,
-				 size_t assoc_ies_len, const u8 *assoc_ies)
-
+				 struct cfg80211_beacon_data *bcon)
 {
 	int rc;
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
 
-	/* FW do not form regular beacon, so bcon IE's are not set
-	 * For the DMG bcon, when it will be supported, bcon IE's will
-	 * be reused; add something like:
-	 * wmi_set_ie(wil, WMI_FRAME_BEACON, bcon->beacon_ies_len,
-	 * bcon->beacon_ies);
-	 */
-	rc = wmi_set_ie(wil, WMI_FRAME_PROBE_RESP, probe_ies_len, probe_ies);
+	rc = wmi_set_ie(wil, WMI_FRAME_PROBE_RESP, bcon->proberesp_ies_len,
+			bcon->proberesp_ies);
 	if (rc) {
 		wil_err(wil, "set_ie(PROBE_RESP) failed\n");
 		return rc;
 	}
 
-	rc = wmi_set_ie(wil, WMI_FRAME_ASSOC_RESP, assoc_ies_len, assoc_ies);
+	rc = wmi_set_ie(wil, WMI_FRAME_ASSOC_RESP, bcon->assocresp_ies_len,
+			bcon->assocresp_ies);
 	if (rc) {
 		wil_err(wil, "set_ie(ASSOC_RESP) failed\n");
 		return rc;
 	}
+#if 0 /* to use beacon IE's, remove this #if 0 */
+	rc = wmi_set_ie(wil, WMI_FRAME_BEACON, bcon->tail_len,
+			bcon->tail);
+	if (rc) {
+		wil_err(wil, "set_ie(BEACON) failed\n");
+		return rc;
+	}
+#endif
 
 	return 0;
 }
@@ -770,8 +775,7 @@ static int _wil_cfg80211_start_ap(struct wiphy *wiphy,
 				  struct net_device *ndev,
 				  const u8 *ssid, size_t ssid_len, u32 privacy,
 				  int bi, u8 chan,
-				  size_t probe_ies_len, const u8 *probe_ies,
-				  size_t assoc_ies_len, const u8 *assoc_ies,
+				  struct cfg80211_beacon_data *bcon,
 				  u8 hidden_ssid)
 {
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
@@ -792,8 +796,7 @@ static int _wil_cfg80211_start_ap(struct wiphy *wiphy,
 	if (rc)
 		goto out;
 
-	rc = _wil_cfg80211_set_ies(wiphy, probe_ies_len, probe_ies,
-				   assoc_ies_len, assoc_ies);
+	rc = _wil_cfg80211_set_ies(wiphy, bcon);
 	if (rc)
 		goto out;
 
@@ -827,27 +830,20 @@ static int wil_cfg80211_change_beacon(struct wiphy *wiphy,
 				      struct cfg80211_beacon_data *bcon)
 {
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
-	struct ieee80211_mgmt *f = (struct ieee80211_mgmt *)bcon->probe_resp;
-	size_t hlen = offsetof(struct ieee80211_mgmt, u.probe_resp.variable);
-	const u8 *pr_ies = NULL;
-	size_t pr_ies_len = 0;
 	int rc;
 	u32 privacy = 0;
 
 	wil_dbg_misc(wil, "%s()\n", __func__);
 	wil_print_bcon_data(bcon);
 
-	if (bcon->probe_resp_len > hlen) {
-		pr_ies = f->u.probe_resp.variable;
-		pr_ies_len = bcon->probe_resp_len - hlen;
-	}
-
 	if (wil_fix_bcon(wil, bcon)) {
 		wil_dbg_misc(wil, "Fixed bcon\n");
 		wil_print_bcon_data(bcon);
 	}
 
-	if (pr_ies && cfg80211_find_ie(WLAN_EID_RSN, pr_ies, pr_ies_len))
+	if (bcon->proberesp_ies &&
+	    cfg80211_find_ie(WLAN_EID_RSN, bcon->proberesp_ies,
+			     bcon->proberesp_ies_len))
 		privacy = 1;
 
 	/* in case privacy has changed, need to restart the AP */
@@ -860,14 +856,10 @@ static int wil_cfg80211_change_beacon(struct wiphy *wiphy,
 		rc = _wil_cfg80211_start_ap(wiphy, ndev, wdev->ssid,
 					    wdev->ssid_len, privacy,
 					    wdev->beacon_interval,
-					    wil->channel, pr_ies_len, pr_ies,
-					    bcon->assocresp_ies_len,
-					    bcon->assocresp_ies,
+					    wil->channel, bcon,
 					    wil->hidden_ssid);
 	} else {
-		rc = _wil_cfg80211_set_ies(wiphy, pr_ies_len, pr_ies,
-					   bcon->assocresp_ies_len,
-					   bcon->assocresp_ies);
+		rc = _wil_cfg80211_set_ies(wiphy, bcon);
 	}
 
 	return rc;
@@ -882,10 +874,6 @@ static int wil_cfg80211_start_ap(struct wiphy *wiphy,
 	struct ieee80211_channel *channel = info->chandef.chan;
 	struct cfg80211_beacon_data *bcon = &info->beacon;
 	struct cfg80211_crypto_settings *crypto = &info->crypto;
-	struct ieee80211_mgmt *f = (struct ieee80211_mgmt *)bcon->probe_resp;
-	size_t hlen = offsetof(struct ieee80211_mgmt, u.probe_resp.variable);
-	const u8 *pr_ies = NULL;
-	size_t pr_ies_len = 0;
 	u8 hidden_ssid;
 
 	wil_dbg_misc(wil, "%s()\n", __func__);
@@ -925,11 +913,6 @@ static int wil_cfg80211_start_ap(struct wiphy *wiphy,
 	wil_print_bcon_data(bcon);
 	wil_print_crypto(wil, crypto);
 
-	if (bcon->probe_resp_len > hlen) {
-		pr_ies = f->u.probe_resp.variable;
-		pr_ies_len = bcon->probe_resp_len - hlen;
-	}
-
 	if (wil_fix_bcon(wil, bcon)) {
 		wil_dbg_misc(wil, "Fixed bcon\n");
 		wil_print_bcon_data(bcon);
@@ -938,10 +921,7 @@ static int wil_cfg80211_start_ap(struct wiphy *wiphy,
 	rc = _wil_cfg80211_start_ap(wiphy, ndev,
 				    info->ssid, info->ssid_len, info->privacy,
 				    info->beacon_interval, channel->hw_value,
-				    pr_ies_len, pr_ies,
-				    bcon->assocresp_ies_len,
-				    bcon->assocresp_ies,
-				    hidden_ssid);
+				    bcon, hidden_ssid);
 
 	return rc;
 }
-- 
2.1.4

