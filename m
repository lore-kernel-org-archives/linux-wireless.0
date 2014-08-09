Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:33472 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbaHISI7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Aug 2014 14:08:59 -0400
Subject: [PATCH v6 8/8] ath10k: print more driver info when firmware crashes
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sat, 09 Aug 2014 21:08:54 +0300
Message-ID: <20140809180854.29215.17531.stgit@potku.adurom.net> (sfid-20140809_200901_564693_7C5FCA5B)
In-Reply-To: <20140809180552.29215.58612.stgit@potku.adurom.net>
References: <20140809180552.29215.58612.stgit@potku.adurom.net>
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
index 39b7383b395c..a34066b85b65 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -870,21 +870,8 @@ int ath10k_core_start(struct ath10k *ar)
 
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
index a335d29f3528..96f85a542514 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -154,6 +154,24 @@ int ath10k_info(const char *fmt, ...)
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
index 7fc2f02f53c4..a17cb8d103be 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1068,9 +1068,7 @@ static void ath10k_pci_firmware_crashed(struct ath10k *ar)
 		scnprintf(uuid, sizeof(uuid), "n/a");
 
 	ath10k_err("firmware crashed! (uuid %s)\n", uuid);
-	ath10k_err("hardware name %s version 0x%x\n",
-		   ar->hw_params.name, ar->target_version);
-	ath10k_err("firmware version: %s\n", ar->hw->wiphy->fw_version);
+	ath10k_print_driver_info(ar);
 
 	if (!crash_data)
 		goto exit;

