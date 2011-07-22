Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3158 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab1GVFno (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 01:43:44 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 29/31] ath6kl: fix crash when interface is closed but scan is ongoing
Date: Fri, 22 Jul 2011 08:42:02 +0300
Message-ID: <1311313324-6766-31-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110722_074349_239187_681C7409)
In-Reply-To: <1311313324-6766-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1311313324-6766-1-git-send-email-kvalo@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When ath6kl module was removed while a scan was ongoing the driver would
crash in ath6kl_cfg80211_scan_complete_event().

Fix the function not to iterate nodes when the scan is aborted. The nodes
are already freed when the module is being unloaded. This patch removes the
null check entirely as the wmi structure is not accessed anymore during
module unload.

Also fix a bug where the status was checked as a bitfield with '&' operator.
But it's not a bitfield, just a regular error code.

This is a port of my patch from ath6kl staging with the same title.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   41 +++++++++++++++------------
 1 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index eff9983..d1d4794 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -820,29 +820,34 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 
 void ath6kl_cfg80211_scan_complete_event(struct ath6kl *ar, int status)
 {
+	int i;
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: status %d\n", __func__, status);
 
-	if (ar->scan_req) {
-		/* Translate data to cfg80211 mgmt format */
-		ath6kl_wmi_iterate_nodes(ar->wmi, ath6kl_cfg80211_scan_node,
-					 ar->wdev->wiphy);
-
-		cfg80211_scan_done(ar->scan_req, ((status & -ECANCELED)
-						  || (status & -EBUSY)) ? true :
-				   false);
-
-		if (ar->scan_req->n_ssids && ar->scan_req->ssids[0].ssid_len) {
-			u8 i;
-
-			for (i = 0; i < ar->scan_req->n_ssids; i++) {
-				ath6kl_wmi_probedssid_cmd(ar->wmi, i + 1,
-							  DISABLE_SSID_FLAG,
-							  0, NULL);
-			}
+	if (!ar->scan_req)
+		return;
+
+	if ((status == -ECANCELED) || (status == -EBUSY)) {
+		cfg80211_scan_done(ar->scan_req, true);
+		goto out;
+	}
+
+	/* Translate data to cfg80211 mgmt format */
+	ath6kl_wmi_iterate_nodes(ar->wmi, ath6kl_cfg80211_scan_node,
+				 ar->wdev->wiphy);
+
+	cfg80211_scan_done(ar->scan_req, false);
+
+	if (ar->scan_req->n_ssids && ar->scan_req->ssids[0].ssid_len) {
+		for (i = 0; i < ar->scan_req->n_ssids; i++) {
+			ath6kl_wmi_probedssid_cmd(ar->wmi, i + 1,
+						  DISABLE_SSID_FLAG,
+						  0, NULL);
 		}
-		ar->scan_req = NULL;
 	}
+
+out:
+	ar->scan_req = NULL;
 }
 
 static int ath6kl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
-- 
1.7.1

