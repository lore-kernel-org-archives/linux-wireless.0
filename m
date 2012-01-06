Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:35769 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995Ab2AFWTr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jan 2012 17:19:47 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2/7] iwlwifi: Sanity check for sta_id
Date: Fri,  6 Jan 2012 13:16:28 -0800
Message-Id: <1325884593-31298-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120106_232024_136328_4E5D5F8F)
In-Reply-To: <1325884593-31298-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1325884593-31298-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On my testing, I saw some strange behavior

[  421.739708] iwlwifi 0000:01:00.0: ACTIVATE a non DRIVER active station id 148 addr 00:00:00:00:00:00
[  421.739719] iwlwifi 0000:01:00.0: iwl_sta_ucode_activate Added STA id 148 addr 00:00:00:00:00:00 to uCode

not sure how it happen, but adding the sanity check to prevent memory
corruption

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index 7353826..8d4353a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -35,9 +35,12 @@
 #include "iwl-trans.h"
 
 /* priv->shrd->sta_lock must be held */
-static void iwl_sta_ucode_activate(struct iwl_priv *priv, u8 sta_id)
+static int iwl_sta_ucode_activate(struct iwl_priv *priv, u8 sta_id)
 {
-
+	if (sta_id >= IWLAGN_STATION_COUNT) {
+		IWL_ERR(priv, "invalid sta_id %u", sta_id);
+		return -EINVAL;
+	}
 	if (!(priv->stations[sta_id].used & IWL_STA_DRIVER_ACTIVE))
 		IWL_ERR(priv, "ACTIVATE a non DRIVER active station id %u "
 			"addr %pM\n",
@@ -53,6 +56,7 @@ static void iwl_sta_ucode_activate(struct iwl_priv *priv, u8 sta_id)
 		IWL_DEBUG_ASSOC(priv, "Added STA id %u addr %pM to uCode\n",
 				sta_id, priv->stations[sta_id].sta.sta.addr);
 	}
+	return 0;
 }
 
 static int iwl_process_add_sta_resp(struct iwl_priv *priv,
@@ -77,8 +81,7 @@ static int iwl_process_add_sta_resp(struct iwl_priv *priv,
 	switch (pkt->u.add_sta.status) {
 	case ADD_STA_SUCCESS_MSK:
 		IWL_DEBUG_INFO(priv, "REPLY_ADD_STA PASSED\n");
-		iwl_sta_ucode_activate(priv, sta_id);
-		ret = 0;
+		ret = iwl_sta_ucode_activate(priv, sta_id);
 		break;
 	case ADD_STA_NO_ROOM_IN_TABLE:
 		IWL_ERR(priv, "Adding station %d failed, no room in table.\n",
-- 
1.7.0.4

