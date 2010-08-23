Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24115 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753971Ab0HWOxf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 10:53:35 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 24/26] iwlagn: update bt status upon scan complete
Date: Mon, 23 Aug 2010 07:57:15 -0700
Message-Id: <1282575437-23270-25-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Update bt status upon receive scan complete notification

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c     |   20 ++++++++++++++++++++
 2 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 8ed2412..9b53583 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -3013,7 +3013,7 @@ struct iwl_scanresults_notification {
 struct iwl_scancomplete_notification {
 	u8 scanned_channels;
 	u8 status;
-	u8 reserved;
+	u8 bt_status;	/* BT On/Off status */
 	u8 last_channel;
 	__le32 tsf_low;
 	__le32 tsf_high;
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 8d7fa59..33aa7a5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -236,6 +236,26 @@ static void iwl_rx_scan_complete_notif(struct iwl_priv *priv,
 
 	clear_bit(STATUS_SCANNING, &priv->status);
 
+	if (priv->iw_mode != NL80211_IFTYPE_ADHOC &&
+	    priv->cfg->advanced_bt_coexist && priv->bt_status !=
+	    scan_notif->bt_status) {
+		if (scan_notif->bt_status) {
+			/* BT on */
+			if (!priv->bt_ch_announce)
+				priv->bt_traffic_load =
+					IWL_BT_COEX_TRAFFIC_LOAD_HIGH;
+			/*
+			 * otherwise, no traffic load information provided
+			 * no changes made
+			 */
+		} else {
+			/* BT off */
+			priv->bt_traffic_load =
+				IWL_BT_COEX_TRAFFIC_LOAD_NONE;
+		}
+		priv->bt_status = scan_notif->bt_status;
+		queue_work(priv->workqueue, &priv->bt_traffic_change_work);
+	}
 	queue_work(priv->workqueue, &priv->scan_completed);
 }
 
-- 
1.7.0.4

