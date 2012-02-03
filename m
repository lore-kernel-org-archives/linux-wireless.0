Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756871Ab2BCQcu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 11:32:50 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v2 03/25] iwlegacy: get rid of ctx->rxon_timing_cmd
Date: Fri,  3 Feb 2012 17:31:39 +0100
Message-Id: <1328286721-11309-4-git-send-email-sgruszka@redhat.com> (sfid-20120203_173253_513856_0D12A014)
In-Reply-To: <1328286721-11309-1-git-send-email-sgruszka@redhat.com>
References: <1328286721-11309-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c |    1 -
 drivers/net/wireless/iwlegacy/4965-mac.c |    1 -
 drivers/net/wireless/iwlegacy/common.c   |    2 +-
 drivers/net/wireless/iwlegacy/common.h   |    2 +-
 4 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index 8de8355..5ca8a78 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -3619,7 +3619,6 @@ il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	il->ctx.ctxid = 0;
 
-	il->ctx.rxon_timing_cmd = C_RXON_TIMING;
 	il->ctx.rxon_assoc_cmd = C_RXON_ASSOC;
 	il->ctx.qos_cmd = C_QOS_PARAM;
 	il->ctx.ap_sta_id = IL_AP_ID;
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 2368f3a..9539acc 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -6135,7 +6135,6 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	il->ctx.always_active = true;
 	il->ctx.is_active = true;
-	il->ctx.rxon_timing_cmd = C_RXON_TIMING;
 	il->ctx.rxon_assoc_cmd = C_RXON_ASSOC;
 	il->ctx.qos_cmd = C_QOS_PARAM;
 	il->ctx.ap_sta_id = IL_AP_ID;
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 2b56226..9025214 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -3664,7 +3664,7 @@ il_send_rxon_timing(struct il_priv *il, struct il_rxon_context *ctx)
 		le32_to_cpu(il->timing.beacon_init_val),
 		le16_to_cpu(il->timing.atim_win));
 
-	return il_send_cmd_pdu(il, il->ctx.rxon_timing_cmd, sizeof(il->timing),
+	return il_send_cmd_pdu(il, C_RXON_TIMING, sizeof(il->timing),
 			       &il->timing);
 }
 EXPORT_SYMBOL(il_send_rxon_timing);
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index 80c60e5..d1d5055 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1175,7 +1175,7 @@ struct il_rxon_context {
 
 	u8 bcast_sta_id, ap_sta_id;
 
-	u8 rxon_assoc_cmd, rxon_timing_cmd;
+	u8 rxon_assoc_cmd;
 	u8 qos_cmd;
 	u8 wep_key_cmd;
 
-- 
1.7.1

