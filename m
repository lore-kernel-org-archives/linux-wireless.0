Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858Ab1BHIcJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 03:32:09 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 1/5] iwlwifi: cleanup iwl_recover_from_statistics
Date: Tue,  8 Feb 2011 09:31:55 +0100
Message-Id: <1297153919-18766-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No functional change, make recover from statistics code
easies to read.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-rx.c |   37 ++++++++++----------------------
 1 files changed, 12 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 87a6fd8..bc89393 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -234,33 +234,20 @@ EXPORT_SYMBOL(iwl_rx_spectrum_measure_notif);
 void iwl_recover_from_statistics(struct iwl_priv *priv,
 				struct iwl_rx_packet *pkt)
 {
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status) ||
+	    !iwl_is_any_associated(priv))
 		return;
-	if (iwl_is_any_associated(priv)) {
-		if (priv->cfg->ops->lib->check_ack_health) {
-			if (!priv->cfg->ops->lib->check_ack_health(
-			    priv, pkt)) {
-				/*
-				 * low ack count detected
-				 * restart Firmware
-				 */
-				IWL_ERR(priv, "low ack count detected, "
-					"restart firmware\n");
-				if (!iwl_force_reset(priv, IWL_FW_RESET, false))
-					return;
-			}
-		}
-		if (priv->cfg->ops->lib->check_plcp_health) {
-			if (!priv->cfg->ops->lib->check_plcp_health(
-			    priv, pkt)) {
-				/*
-				 * high plcp error detected
-				 * reset Radio
-				 */
-				iwl_force_reset(priv, IWL_RF_RESET, false);
-			}
-		}
+
+	if (priv->cfg->ops->lib->check_ack_health &&
+	    !priv->cfg->ops->lib->check_ack_health(priv, pkt)) {
+		IWL_ERR(priv, "low ack count detected, restart firmware\n");
+		if (!iwl_force_reset(priv, IWL_FW_RESET, false))
+			return;
 	}
+
+	if (priv->cfg->ops->lib->check_plcp_health &&
+	    !priv->cfg->ops->lib->check_plcp_health(priv, pkt))
+		iwl_force_reset(priv, IWL_RF_RESET, false);
 }
 EXPORT_SYMBOL(iwl_recover_from_statistics);
 
-- 
1.7.1

