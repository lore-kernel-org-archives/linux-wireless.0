Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:51911 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbbKYNrP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2015 08:47:15 -0500
Subject: [PATCH 3/6] ath10k: always show bmi chip ids and subdevice ids
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 25 Nov 2015 15:38:19 +0200
Message-ID: <20151125133819.25507.20279.stgit@potku.adurom.net> (sfid-20151125_144720_867602_2ED16FE4)
In-Reply-To: <20151125133654.25507.10863.stgit@potku.adurom.net>
References: <20151125133654.25507.10863.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

That way we can split the messages to be printed in different stages of
device initialisation.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/debug.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 4c0e0a1ef0f1..2bc7ae21ade4 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -130,25 +130,25 @@ void ath10k_print_driver_info(struct ath10k *ar)
 	ath10k_core_get_fw_features_str(ar, fw_features, sizeof(fw_features));
 
 	if (ar->id.bmi_ids_valid)
-		scnprintf(boardinfo, sizeof(boardinfo), "bmi %d:%d",
+		scnprintf(boardinfo, sizeof(boardinfo), "%d:%d",
 			  ar->id.bmi_chip_id, ar->id.bmi_board_id);
 	else
-		scnprintf(boardinfo, sizeof(boardinfo), "sub %04x:%04x",
-			  ar->id.subsystem_vendor, ar->id.subsystem_device);
+		scnprintf(boardinfo, sizeof(boardinfo), "N/A");
 
-	ath10k_info(ar, "%s target 0x%08x chip_id 0x%08x %s",
+	ath10k_info(ar, "%s target 0x%08x chip_id 0x%08x sub %04x:%04x",
 		    ar->hw_params.name,
 		    ar->target_version,
 		    ar->chip_id,
-		    boardinfo);
+		    ar->id.subsystem_vendor, ar->id.subsystem_device);
 
 	ath10k_info(ar, "firmware ver %s api %d features %s\n",
 		    ar->hw->wiphy->fw_version,
 		    ar->fw_api,
 		    fw_features);
 
-	ath10k_info(ar, "board_file api %d",
-		    ar->bd_api);
+	ath10k_info(ar, "board_file api %d bmi_id %s",
+		    ar->bd_api,
+		    boardinfo);
 
 	ath10k_info(ar, "kconfig debug %d debugfs %d tracing %d dfs %d testmode %d\n",
 		    config_enabled(CONFIG_ATH10K_DEBUG),

