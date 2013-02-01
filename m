Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58545 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755700Ab3BAK1S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2013 05:27:18 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/3] iwlwifi: lower BT coex aggregation message severity
Date: Fri,  1 Feb 2013 11:27:34 +0100
Message-Id: <1359714456-15427-1-git-send-email-johannes@sipsolutions.net> (sfid-20130201_112725_389379_AA0EA423)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

As the rate scaling algorithm will attempt to enable
aggregation over and over again, the message will
flood the log if there is, for example, Bluetooth
streaming music. Make it a debug messages instead of
printing it all the time.

Reported-by: Jan-Michael Brummer <jan.brummer@tabos.org>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/rs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/rs.c b/drivers/net/wireless/iwlwifi/dvm/rs.c
index 2eb4277..a131227 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rs.c
@@ -411,8 +411,9 @@ static int rs_tl_turn_on_agg_for_tid(struct iwl_priv *priv,
 	 * BT traffic, as they would just be disrupted by BT.
 	 */
 	if (priv->bt_traffic_load >= IWL_BT_COEX_TRAFFIC_LOAD_HIGH) {
-		IWL_ERR(priv, "BT traffic (%d), no aggregation allowed\n",
-			priv->bt_traffic_load);
+		IWL_DEBUG_COEX(priv,
+			       "BT traffic (%d), no aggregation allowed\n",
+			       priv->bt_traffic_load);
 		return ret;
 	}
 
-- 
1.8.0

