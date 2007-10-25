Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:44560 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754501AbXJYJW4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 05:22:56 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 20/30] iwlwifi: Renames struct fw_image_desc to struct fw_desc
Date: Thu, 25 Oct 2007 17:15:41 +0800
Message-Id: <11933037812209-git-send-email-yi.zhu@intel.com> (sfid-20071025_104103_135865_3B48DA6A)
In-Reply-To: <11933037794199-git-send-email-yi.zhu@intel.com>
References: <11933037512140-git-send-email-yi.zhu@intel.com>
 <11933037541699-git-send-email-yi.zhu@intel.com>
 <11933037553170-git-send-email-yi.zhu@intel.com>
 <119330375796-git-send-email-yi.zhu@intel.com>
 <11933037584069-git-send-email-yi.zhu@intel.com>
 <11933037601236-git-send-email-yi.zhu@intel.com>
 <11933037613709-git-send-email-yi.zhu@intel.com>
 <1193303762680-git-send-email-yi.zhu@intel.com>
 <11933037641168-git-send-email-yi.zhu@intel.com>
 <11933037663659-git-send-email-yi.zhu@intel.com>
 <11933037674045-git-send-email-yi.zhu@intel.com>
 <11933037692766-git-send-email-yi.zhu@intel.com>
 <1193303770550-git-send-email-yi.zhu@intel.com>
 <11933037721573-git-send-email-yi.zhu@intel.com>
 <1193303773185-git-send-email-yi.zhu@intel.com>
 <11933037743841-git-send-email-yi.zhu@intel.com>
 <11933037762104-git-send-email-yi.zhu@intel.com>
 <11933037784073-git-send-email-yi.zhu@intel.com>
 <11933037794199-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patche shortens the name of struct fw_image_desc to be struct
fw_desc.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-priv.h |   12 ++++++------
 drivers/net/wireless/iwlwifi/iwlwifi.h  |    2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-priv.h b/drivers/net/wireless/iwlwifi/iwl-priv.h
index f43679a..c25f2ff 100644
--- a/drivers/net/wireless/iwlwifi/iwl-priv.h
+++ b/drivers/net/wireless/iwlwifi/iwl-priv.h
@@ -102,12 +102,12 @@ struct iwl_priv {
 	void __iomem *hw_base;
 
 	/* uCode images, save to reload in case of failure */
-	struct fw_image_desc ucode_code;	/* runtime inst */
-	struct fw_image_desc ucode_data;	/* runtime data original */
-	struct fw_image_desc ucode_data_backup;	/* runtime data save/restore */
-	struct fw_image_desc ucode_init;	/* initialization inst */
-	struct fw_image_desc ucode_init_data;	/* initialization data */
-	struct fw_image_desc ucode_boot;	/* bootstrap inst */
+	struct fw_desc ucode_code;	/* runtime inst */
+	struct fw_desc ucode_data;	/* runtime data original */
+	struct fw_desc ucode_data_backup;	/* runtime data save/restore */
+	struct fw_desc ucode_init;	/* initialization inst */
+	struct fw_desc ucode_init_data;	/* initialization data */
+	struct fw_desc ucode_boot;	/* bootstrap inst */
 
 
 	struct iwl_rxon_time_cmd rxon_timing;
diff --git a/drivers/net/wireless/iwlwifi/iwlwifi.h b/drivers/net/wireless/iwlwifi/iwlwifi.h
index c5c9c5d..9071600 100644
--- a/drivers/net/wireless/iwlwifi/iwlwifi.h
+++ b/drivers/net/wireless/iwlwifi/iwlwifi.h
@@ -497,7 +497,7 @@ struct iwl_station_entry {
 };
 
 /* one for each uCode image (inst/data, boot/init/runtime) */
-struct fw_image_desc {
+struct fw_desc {
 	void *v_addr;		/* access by driver */
 	dma_addr_t p_addr;	/* access by card's busmaster DMA */
 	u32 len;		/* bytes */
-- 
1.5.2
