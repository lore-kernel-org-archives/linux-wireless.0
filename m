Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17442 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab2DPQ2I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 12:28:08 -0400
Date: Mon, 16 Apr 2012 19:28:03 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH] ath6kl: Configure probed SSID list consistently
Message-ID: <20120416162803.GA9671@jouni.qca.qualcomm.com> (sfid-20120416_182813_373730_2DA42B0C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set max_scan_ssids and max_sched_scan_ssids to same value. These use the
same probed SSID list, so there is no point in using different maximum
number of SSIDs.

Clear probed SSID entries that are not used. This was already done for
sched_scan, but not for scan. Be consistent and clear the table for both
cases to avoid leaving bogus entries.

In addition, share the same function for setting the probed SSIDs for
scan and sched_scan paths. This fixes setting of wildcard SSID flag
(ANY_SSID_FLAG) and changes the scan path to use probed SSID index
consistently (i.e., start with 0 similarly to sched_scan; firmware
will handle the needed internal mapping).

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   63 +++++++++++++++------------
 1 files changed, 35 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index c5e90d3..5b988aa 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -882,6 +882,32 @@ void ath6kl_cfg80211_disconnect_event(struct ath6kl_vif *vif, u8 reason,
 	vif->sme_state = SME_DISCONNECTED;
 }
 
+static int ath6kl_set_probed_ssids(struct ath6kl *ar,
+				   struct ath6kl_vif *vif,
+				   struct cfg80211_ssid *ssids, int n_ssids)
+{
+	u8 i;
+
+	if (n_ssids > MAX_PROBED_SSID_INDEX)
+		return -EINVAL;
+
+	for (i = 0; i < n_ssids; i++) {
+		ath6kl_wmi_probedssid_cmd(ar->wmi, vif->fw_vif_idx, i,
+					  ssids[i].ssid_len ?
+					  SPECIFIC_SSID_FLAG : ANY_SSID_FLAG,
+					  ssids[i].ssid_len,
+					  ssids[i].ssid);
+	}
+
+	/* Make sure no old entries are left behind */
+	for (i = n_ssids; i < MAX_PROBED_SSID_INDEX; i++) {
+		ath6kl_wmi_probedssid_cmd(ar->wmi, vif->fw_vif_idx, i,
+					  DISABLE_SSID_FLAG, 0, NULL);
+	}
+
+	return 0;
+}
+
 static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 				struct cfg80211_scan_request *request)
 {
@@ -909,18 +935,10 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 		}
 	}
 
-	if (request->n_ssids && request->ssids[0].ssid_len) {
-		u8 i;
-
-		if (request->n_ssids > (MAX_PROBED_SSID_INDEX - 1))
-			request->n_ssids = MAX_PROBED_SSID_INDEX - 1;
-
-		for (i = 0; i < request->n_ssids; i++)
-			ath6kl_wmi_probedssid_cmd(ar->wmi, vif->fw_vif_idx,
-						  i + 1, SPECIFIC_SSID_FLAG,
-						  request->ssids[i].ssid_len,
-						  request->ssids[i].ssid);
-	}
+	ret = ath6kl_set_probed_ssids(ar, vif, request->ssids,
+				      request->n_ssids);
+	if (ret < 0)
+		return ret;
 
 	/* this also clears IE in fw if it's not set */
 	ret = ath6kl_wmi_set_appie_cmd(ar->wmi, vif->fw_vif_idx,
@@ -3100,7 +3118,6 @@ static int ath6kl_cfg80211_sscan_start(struct wiphy *wiphy,
 	struct ath6kl_vif *vif = netdev_priv(dev);
 	u16 interval;
 	int ret;
-	u8 i;
 
 	if (ar->state != ATH6KL_STATE_ON)
 		return -EIO;
@@ -3110,11 +3127,10 @@ static int ath6kl_cfg80211_sscan_start(struct wiphy *wiphy,
 
 	ath6kl_cfg80211_scan_complete_event(vif, true);
 
-	for (i = 0; i < ar->wiphy->max_sched_scan_ssids; i++) {
-		ath6kl_wmi_probedssid_cmd(ar->wmi, vif->fw_vif_idx,
-					  i, DISABLE_SSID_FLAG,
-					  0, NULL);
-	}
+	ret = ath6kl_set_probed_ssids(ar, vif, request->ssids,
+				      request->n_ssids);
+	if (ret < 0)
+		return ret;
 
 	/* fw uses seconds, also make sure that it's >0 */
 	interval = max_t(u16, 1, request->interval / 1000);
@@ -3123,15 +3139,6 @@ static int ath6kl_cfg80211_sscan_start(struct wiphy *wiphy,
 				  interval, interval,
 				  10, 0, 0, 0, 3, 0, 0, 0);
 
-	if (request->n_ssids && request->ssids[0].ssid_len) {
-		for (i = 0; i < request->n_ssids; i++) {
-			ath6kl_wmi_probedssid_cmd(ar->wmi, vif->fw_vif_idx,
-						  i, SPECIFIC_SSID_FLAG,
-						  request->ssids[i].ssid_len,
-						  request->ssids[i].ssid);
-		}
-	}
-
 	ret = ath6kl_wmi_set_wow_mode_cmd(ar->wmi, vif->fw_vif_idx,
 					  ATH6KL_WOW_MODE_ENABLE,
 					  WOW_FILTER_SSID,
@@ -3448,7 +3455,7 @@ int ath6kl_cfg80211_init(struct ath6kl *ar)
 	wiphy->wowlan.pattern_min_len = 1;
 	wiphy->wowlan.pattern_max_len = WOW_PATTERN_SIZE;
 
-	wiphy->max_sched_scan_ssids = 10;
+	wiphy->max_sched_scan_ssids = MAX_PROBED_SSID_INDEX;
 
 	ar->wiphy->flags |= WIPHY_FLAG_SUPPORTS_FW_ROAM |
 			    WIPHY_FLAG_HAVE_AP_SME |
-- 
1.7.5.4


-- 
Jouni Malinen                                            PGP id EFC895FA
