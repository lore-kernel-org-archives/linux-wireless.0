Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:44900 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbaHSIXp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2014 04:23:45 -0400
Subject: [PATCH v7 8/8] ath10k: print more driver info when firmware crashes
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 19 Aug 2014 11:23:41 +0300
Message-ID: <20140819082341.16842.1298.stgit@potku.adurom.net> (sfid-20140819_102406_726821_DB18BF2A)
In-Reply-To: <20140819082038.16842.46876.stgit@potku.adurom.net>
References: <20140819082038.16842.46876.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c  |   17 ++---------------
 drivers/net/wireless/ath/ath10k/debug.c |   18 ++++++++++++++++++
 drivers/net/wireless/ath/ath10k/debug.h |    1 +
 drivers/net/wireless/ath/ath10k/pci.c   |    4 +---
 4 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 1472c0a767e2..e90f41dc6ae6 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -869,21 +869,8 @@ int ath10k_core_start(struct ath10k *ar)
 
 	INIT_LIST_HEAD(&ar->arvifs);
 
-	if (!test_bit(ATH10K_FLAG_FIRST_BOOT_DONE, &ar->dev_flags)) {
-		ath10k_info("%s (0x%08x, 0x%08x) fw %s api %d htt %d.%d\n",
-			    ar->hw_params.name,
-			    ar->target_version,
-			    ar->chip_id,
-			    ar->hw->wiphy->fw_version,
-			    ar->fw_api,
-			    ar->htt.target_version_major,
-			    ar->htt.target_version_minor);
-		ath10k_info("debug %d debugfs %d tracing %d dfs %d\n",
-			    config_enabled(CONFIG_ATH10K_DEBUG),
-			    config_enabled(CONFIG_ATH10K_DEBUGFS),
-			    config_enabled(CONFIG_ATH10K_TRACING),
-			    config_enabled(CONFIG_ATH10K_DFS_CERTIFIED));
-	}
+	if (!test_bit(ATH10K_FLAG_FIRST_BOOT_DONE, &ar->dev_flags))
+		ath10k_print_driver_info(ar);
 
 	__set_bit(ATH10K_FLAG_FIRST_BOOT_DONE, &ar->dev_flags);
 
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 67bb53c64ead..27ddce6ca1da 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -152,6 +152,24 @@ int ath10k_info(const char *fmt, ...)
 }
 EXPORT_SYMBOL(ath10k_info);
 
+void ath10k_print_driver_info(struct ath10k *ar)
+{
+	ath10k_info("%s (0x%08x, 0x%08x) fw %s api %d htt %d.%d\n",
+		    ar->hw_params.name,
+		    ar->target_version,
+		    ar->chip_id,
+		    ar->hw->wiphy->fw_version,
+		    ar->fw_api,
+		    ar->htt.target_version_major,
+		    ar->htt.target_version_minor);
+	ath10k_info("debug %d debugfs %d tracing %d dfs %d\n",
+		    config_enabled(CONFIG_ATH10K_DEBUG),
+		    config_enabled(CONFIG_ATH10K_DEBUGFS),
+		    config_enabled(CONFIG_ATH10K_TRACING),
+		    config_enabled(CONFIG_ATH10K_DFS_CERTIFIED));
+}
+EXPORT_SYMBOL(ath10k_print_driver_info);
+
 int ath10k_err(const char *fmt, ...)
 {
 	struct va_format vaf = {
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 80ff14e4db9b..494044a89226 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -42,6 +42,7 @@ extern unsigned int ath10k_debug_mask;
 __printf(1, 2) int ath10k_info(const char *fmt, ...);
 __printf(1, 2) int ath10k_err(const char *fmt, ...);
 __printf(1, 2) int ath10k_warn(const char *fmt, ...);
+void ath10k_print_driver_info(struct ath10k *ar);
 
 #ifdef CONFIG_ATH10K_DEBUGFS
 int ath10k_debug_start(struct ath10k *ar);
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 8aaaeda7d20b..55b027a77b8e 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1033,9 +1033,7 @@ static void ath10k_pci_fw_crashed_dump(struct ath10k *ar)
 		scnprintf(uuid, sizeof(uuid), "n/a");
 
 	ath10k_err("firmware crashed! (uuid %s)\n", uuid);
-	ath10k_err("hardware name %s version 0x%x\n",
-		   ar->hw_params.name, ar->target_version);
-	ath10k_err("firmware version: %s\n", ar->hw->wiphy->fw_version);
+	ath10k_print_driver_info(ar);
 
 	if (!crash_data)
 		goto exit;

