Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:28629 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761411AbZJIUXL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2009 16:23:11 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 16/17] iwl3945: rearrange the code.
Date: Fri,  9 Oct 2009 13:20:33 -0700
Message-Id: <1255119634-3060-18-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1255119634-3060-1-git-send-email-reinette.chatre@intel.com>
References: <1255119634-3060-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Rearrange the code and groups setting of
retry_limit and data_retry_limits code together.
Make 'data_retry_limit' setting similar to iwlwifi
for better readability.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index eb874e0..8012381 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -794,17 +794,22 @@ void iwl3945_hw_build_tx_cmd_rate(struct iwl_priv *priv,
 	 * in this running context */
 	rate_mask = IWL_RATES_MASK;
 
+
+	/* Set retry limit on DATA packets and Probe Responses*/
+	if (ieee80211_is_probe_resp(fc))
+		data_retry_limit = 3;
+	else
+		data_retry_limit = IWL_DEFAULT_TX_RETRY;
+	tx_cmd->data_retry_limit = data_retry_limit;
+
 	if (tx_id >= IWL_CMD_QUEUE_NUM)
 		rts_retry_limit = 3;
 	else
 		rts_retry_limit = 7;
 
-	if (ieee80211_is_probe_resp(fc)) {
-		data_retry_limit = 3;
-		if (data_retry_limit < rts_retry_limit)
-			rts_retry_limit = data_retry_limit;
-	} else
-		data_retry_limit = IWL_DEFAULT_TX_RETRY;
+	if (data_retry_limit < rts_retry_limit)
+		rts_retry_limit = data_retry_limit;
+	tx_cmd->rts_retry_limit = rts_retry_limit;
 
 	if (ieee80211_is_mgmt(fc)) {
 		switch (fc & cpu_to_le16(IEEE80211_FCTL_STYPE)) {
@@ -822,8 +827,6 @@ void iwl3945_hw_build_tx_cmd_rate(struct iwl_priv *priv,
 		}
 	}
 
-	tx_cmd->rts_retry_limit = rts_retry_limit;
-	tx_cmd->data_retry_limit = data_retry_limit;
 	tx_cmd->rate = rate;
 	tx_cmd->tx_flags = tx_flags;
 
-- 
1.5.6.3

