Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:44388 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab1IVHuX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 03:50:23 -0400
Received: by yib18 with SMTP id 18so1689999yib.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Sep 2011 00:50:22 -0700 (PDT)
From: ilanelias78@gmail.com
To: aloisio.almeida@openbossa.org, lauro.venancio@openbossa.org,
	samuel@sortiz.org, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Ilan Elias <ilane@ti.com>
Subject: [PATCH] NFC: improve readability of an 'if' in nci core.c
Date: Thu, 22 Sep 2011 10:47:52 +0300
Message-Id: <1316677672-4812-1-git-send-email-ilane@ti.com> (sfid-20110922_095026_493366_AD46AF78)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Elias <ilane@ti.com>

Signed-off-by: Ilan Elias <ilane@ti.com>
---
 net/nfc/nci/core.c |   32 ++++++++++++++------------------
 1 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 895e5fd..c3dfd4e 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -135,8 +135,10 @@ static void nci_init_req(struct nci_dev *ndev, unsigned long opt)
 
 static void nci_init_complete_req(struct nci_dev *ndev, unsigned long opt)
 {
-	struct nci_rf_disc_map_cmd cmd;
 	struct nci_core_conn_create_cmd conn_cmd;
+	struct nci_rf_disc_map_cmd cmd;
+	struct disc_map_config *cfg = cmd.mapping_configs;
+	__u8 *num = &cmd.num_mapping_configs;
 	int i;
 
 	/* create static rf connection */
@@ -145,36 +147,30 @@ static void nci_init_complete_req(struct nci_dev *ndev, unsigned long opt)
 	nci_send_cmd(ndev, NCI_OP_CORE_CONN_CREATE_CMD, 2, &conn_cmd);
 
 	/* set rf mapping configurations */
-	cmd.num_mapping_configs = 0;
+	*num = 0;
 
 	/* by default mapping is set to NCI_RF_INTERFACE_FRAME */
 	for (i = 0; i < ndev->num_supported_rf_interfaces; i++) {
 		if (ndev->supported_rf_interfaces[i] ==
 			NCI_RF_INTERFACE_ISO_DEP) {
-			cmd.mapping_configs[cmd.num_mapping_configs]
-			.rf_protocol = NCI_RF_PROTOCOL_ISO_DEP;
-			cmd.mapping_configs[cmd.num_mapping_configs]
-			.mode = NCI_DISC_MAP_MODE_BOTH;
-			cmd.mapping_configs[cmd.num_mapping_configs]
-			.rf_interface_type = NCI_RF_INTERFACE_ISO_DEP;
-			cmd.num_mapping_configs++;
+			cfg[*num].rf_protocol = NCI_RF_PROTOCOL_ISO_DEP;
+			cfg[*num].mode = NCI_DISC_MAP_MODE_BOTH;
+			cfg[*num].rf_interface_type = NCI_RF_INTERFACE_ISO_DEP;
+			(*num)++;
 		} else if (ndev->supported_rf_interfaces[i] ==
 			NCI_RF_INTERFACE_NFC_DEP) {
-			cmd.mapping_configs[cmd.num_mapping_configs]
-			.rf_protocol = NCI_RF_PROTOCOL_NFC_DEP;
-			cmd.mapping_configs[cmd.num_mapping_configs]
-			.mode = NCI_DISC_MAP_MODE_BOTH;
-			cmd.mapping_configs[cmd.num_mapping_configs]
-			.rf_interface_type = NCI_RF_INTERFACE_NFC_DEP;
-			cmd.num_mapping_configs++;
+			cfg[*num].rf_protocol = NCI_RF_PROTOCOL_NFC_DEP;
+			cfg[*num].mode = NCI_DISC_MAP_MODE_BOTH;
+			cfg[*num].rf_interface_type = NCI_RF_INTERFACE_NFC_DEP;
+			(*num)++;
 		}
 
-		if (cmd.num_mapping_configs == NCI_MAX_NUM_MAPPING_CONFIGS)
+		if (*num == NCI_MAX_NUM_MAPPING_CONFIGS)
 			break;
 	}
 
 	nci_send_cmd(ndev, NCI_OP_RF_DISCOVER_MAP_CMD,
-		(1 + (cmd.num_mapping_configs*sizeof(struct disc_map_config))),
+		(1 + ((*num)*sizeof(struct disc_map_config))),
 		&cmd);
 }
 
-- 
1.7.0.4

