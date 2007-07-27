Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:44073 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760697AbXG0J3N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2007 05:29:13 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Ben Cahill <ben.m.cahill@intel.com>
Subject: [PATCH 16/17] iwlwifi: Add uCode/driver compatibility version number
Date: Fri, 27 Jul 2007 17:26:40 +0800
Message-Id: <11855284303672-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11855284281570-git-send-email-yi.zhu@intel.com>
References: <11855284012123-git-send-email-yi.zhu@intel.com>
 <11855284032407-git-send-email-yi.zhu@intel.com>
 <11855284053896-git-send-email-yi.zhu@intel.com>
 <11855284072074-git-send-email-yi.zhu@intel.com>
 <1185528408776-git-send-email-yi.zhu@intel.com>
 <11855284103871-git-send-email-yi.zhu@intel.com>
 <11855284122218-git-send-email-yi.zhu@intel.com>
 <11855284142478-git-send-email-yi.zhu@intel.com>
 <11855284161716-git-send-email-yi.zhu@intel.com>
 <11855284183313-git-send-email-yi.zhu@intel.com>
 <11855284201330-git-send-email-yi.zhu@intel.com>
 <11855284212390-git-send-email-yi.zhu@intel.com>
 <1185528423816-git-send-email-yi.zhu@intel.com>
 <11855284253382-git-send-email-yi.zhu@intel.com>
 <11855284263627-git-send-email-yi.zhu@intel.com>
 <11855284281570-git-send-email-yi.zhu@intel.com>
To: ipwpatch@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add uCode/driver compatibility version number in firmware
filename, to enable compatibility enforcement and coexistence
of old/new drivers.

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-base.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index 8558ea8..e3cd459 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -110,6 +110,13 @@ BUILD_BUG()
 #define DRV_COPYRIGHT	"Copyright(c) 2003-2007 Intel Corporation"
 #define DRV_VERSION     IWLWIFI_VERSION
 
+/* Change firmware file name, using "-" and incrementing number,
+ *   *only* when uCode interface or architecture changes so that it
+ *   is not compatible with earlier drivers.
+ * This number will also appear in << 8 position of 1st dword of uCode file */
+#define IWL3945_UCODE_API "-1"
+#define IWL4965_UCODE_API "-1"
+
 MODULE_DESCRIPTION(DRV_DESCRIPTION);
 MODULE_VERSION(DRV_VERSION);
 MODULE_AUTHOR(DRV_COPYRIGHT);
@@ -6191,21 +6198,17 @@ static int iwl_read_ucode(struct iwl_priv *priv)
 	int rc = 0;
 	const struct firmware *ucode_raw;
 #if IWL == 3945
-	const char *name = "iwlwifi-3945.ucode";	/* firmware file name */
+	/* firmware file name contains uCode/driver compatibility version */
+	const char *name = "iwlwifi-3945" IWL3945_UCODE_API ".ucode";
 #elif IWL == 4965
-	const char *name = "iwlwifi-4965.ucode";	/* firmware file name */
+	const char *name = "iwlwifi-4965" IWL4965_UCODE_API ".ucode";
 #endif
 	u8 *src;
 	size_t len;
 	u32 ver, inst_size, data_size, init_size, init_data_size, boot_size;
 
 	/* Ask kernel firmware_class module to get the boot firmware off disk.
-	 * request_firmware() is synchronous call, file is in memory on return.
-	 * TODO:  Would it be more polite to use asynchronous
-	 *        request_firmware_nowait()??  If so, put request back into
-	 *        iwl_pci_probe(), and rest of this function would serve as
-	 *        the callback for request_firmware_nowait().  Also need to
-	 *        make sure everything waits for this callback to complete! */
+	 * request_firmware() is synchronous, file is in memory on return. */
 	rc = request_firmware(&ucode_raw, name, &priv->pci_dev->dev);
 	if (rc < 0) {
 		IWL_ERROR("%s firmware file req failed: Reason %d\n", name, rc);
-- 
1.5.2
