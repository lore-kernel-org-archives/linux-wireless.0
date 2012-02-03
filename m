Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778Ab2BCMIG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 07:08:06 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 02/25] iwlegacy: get rid of ctx->rxon_cmd
Date: Fri,  3 Feb 2012 13:07:02 +0100
Message-Id: <1328270845-16891-3-git-send-email-sgruszka@redhat.com> (sfid-20120203_130810_496596_B567705A)
In-Reply-To: <1328270845-16891-1-git-send-email-sgruszka@redhat.com>
References: <1328270845-16891-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c |    1 -
 drivers/net/wireless/iwlegacy/4965-mac.c |    1 -
 drivers/net/wireless/iwlegacy/4965.c     |    6 +++---
 drivers/net/wireless/iwlegacy/common.h   |    2 +-
 4 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index 980566f..8de8355 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -3619,7 +3619,6 @@ il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	il->ctx.ctxid = 0;
 
-	il->ctx.rxon_cmd = C_RXON;
 	il->ctx.rxon_timing_cmd = C_RXON_TIMING;
 	il->ctx.rxon_assoc_cmd = C_RXON_ASSOC;
 	il->ctx.qos_cmd = C_QOS_PARAM;
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 6a77f41..2368f3a 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -6135,7 +6135,6 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	il->ctx.always_active = true;
 	il->ctx.is_active = true;
-	il->ctx.rxon_cmd = C_RXON;
 	il->ctx.rxon_timing_cmd = C_RXON_TIMING;
 	il->ctx.rxon_assoc_cmd = C_RXON_ASSOC;
 	il->ctx.qos_cmd = C_QOS_PARAM;
diff --git a/drivers/net/wireless/iwlegacy/4965.c b/drivers/net/wireless/iwlegacy/4965.c
index b34de14..8926108 100644
--- a/drivers/net/wireless/iwlegacy/4965.c
+++ b/drivers/net/wireless/iwlegacy/4965.c
@@ -1472,7 +1472,7 @@ il4965_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 		active_rxon->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 
 		ret =
-		    il_send_cmd_pdu(il, ctx->rxon_cmd,
+		    il_send_cmd_pdu(il, C_RXON,
 				    sizeof(struct il_rxon_cmd), active_rxon);
 
 		/* If the mask clearing failed then we set
@@ -1503,7 +1503,7 @@ il4965_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 	 */
 	if (!new_assoc) {
 		ret =
-		    il_send_cmd_pdu(il, ctx->rxon_cmd,
+		    il_send_cmd_pdu(il, C_RXON,
 				    sizeof(struct il_rxon_cmd), &il->staging);
 		if (ret) {
 			IL_ERR("Error setting new RXON (%d)\n", ret);
@@ -1525,7 +1525,7 @@ il4965_commit_rxon(struct il_priv *il, struct il_rxon_context *ctx)
 		 * RXON assoc doesn't clear the station table in uCode,
 		 */
 		ret =
-		    il_send_cmd_pdu(il, ctx->rxon_cmd,
+		    il_send_cmd_pdu(il, C_RXON,
 				    sizeof(struct il_rxon_cmd), &il->staging);
 		if (ret) {
 			IL_ERR("Error setting new RXON (%d)\n", ret);
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index ba801c7..80c60e5 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1175,7 +1175,7 @@ struct il_rxon_context {
 
 	u8 bcast_sta_id, ap_sta_id;
 
-	u8 rxon_cmd, rxon_assoc_cmd, rxon_timing_cmd;
+	u8 rxon_assoc_cmd, rxon_timing_cmd;
 	u8 qos_cmd;
 	u8 wep_key_cmd;
 
-- 
1.7.1

