Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505Ab2BCMH4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 07:07:56 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 05/25] iwlegacy: get rid of qos_cmd
Date: Fri,  3 Feb 2012 13:07:05 +0100
Message-Id: <1328270845-16891-6-git-send-email-sgruszka@redhat.com> (sfid-20120203_130801_821915_E120A41D)
In-Reply-To: <1328270845-16891-1-git-send-email-sgruszka@redhat.com>
References: <1328270845-16891-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c |    1 -
 drivers/net/wireless/iwlegacy/4965-mac.c |    1 -
 drivers/net/wireless/iwlegacy/common.c   |    2 +-
 drivers/net/wireless/iwlegacy/common.h   |    1 -
 4 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index e5857df..bbbac26 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -3619,7 +3619,6 @@ il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	il->ctx.ctxid = 0;
 
-	il->ctx.qos_cmd = C_QOS_PARAM;
 	il->ctx.ap_sta_id = IL_AP_ID;
 	il->ctx.wep_key_cmd = C_WEPKEY;
 	il->ctx.interface_modes =
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index bd83299..2ee5de3 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -6135,7 +6135,6 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	il->ctx.always_active = true;
 	il->ctx.is_active = true;
-	il->ctx.qos_cmd = C_QOS_PARAM;
 	il->ctx.ap_sta_id = IL_AP_ID;
 	il->ctx.wep_key_cmd = C_WEPKEY;
 	il->ctx.ac_to_fifo = il4965_bss_ac_to_fifo;
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 9025214..b95f832 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -5269,7 +5269,7 @@ il_update_qos(struct il_priv *il, struct il_rxon_context *ctx)
 	D_QOS("send QoS cmd with Qos active=%d FLAGS=0x%X\n",
 	      ctx->qos_data.qos_active, ctx->qos_data.def_qos_parm.qos_flags);
 
-	il_send_cmd_pdu_async(il, ctx->qos_cmd, sizeof(struct il_qosparam_cmd),
+	il_send_cmd_pdu_async(il, C_QOS_PARAM, sizeof(struct il_qosparam_cmd),
 			      &ctx->qos_data.def_qos_parm, NULL);
 }
 
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index d8e309a..b08ddd1 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1175,7 +1175,6 @@ struct il_rxon_context {
 
 	u8 bcast_sta_id, ap_sta_id;
 
-	u8 qos_cmd;
 	u8 wep_key_cmd;
 
 	struct il_wep_key wep_keys[WEP_KEYS_MAX];
-- 
1.7.1

