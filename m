Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:50654 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab3KORZm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Nov 2013 12:25:42 -0500
Subject: [PATCH 3/3] ath10k: show hardware and firmware info prints only once
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 15 Nov 2013 19:25:39 +0200
Message-ID: <20131115172539.10646.6643.stgit@localhost6.localdomain6> (sfid-20131115_182544_700288_2224A577)
In-Reply-To: <20131115172526.10646.35233.stgit@localhost6.localdomain6>
References: <20131115172526.10646.35233.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes ath10k a lot less spammy by default.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c |   12 ++++++++----
 drivers/net/wireless/ath/ath10k/core.h |    1 +
 drivers/net/wireless/ath/ath10k/pci.c  |    4 +++-
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index e6c468b..3b59af3 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -832,10 +832,14 @@ int ath10k_core_start(struct ath10k *ar)
 	ar->free_vdev_map = (1 << TARGET_NUM_VDEVS) - 1;
 	INIT_LIST_HEAD(&ar->arvifs);
 
-	ath10k_info("%s (0x%x) fw %s api %d htt %d.%d\n",
-		    ar->hw_params.name, ar->target_version,
-		    ar->hw->wiphy->fw_version, ar->fw_api,
-		    ar->htt.target_version_major, ar->htt.target_version_minor);
+	if (!test_bit(ATH10K_FLAG_FIRST_BOOT_DONE, &ar->dev_flags))
+		ath10k_info("%s (0x%x) fw %s api %d htt %d.%d\n",
+			    ar->hw_params.name, ar->target_version,
+			    ar->hw->wiphy->fw_version, ar->fw_api,
+			    ar->htt.target_version_major,
+			    ar->htt.target_version_minor);
+
+	__set_bit(ATH10K_FLAG_FIRST_BOOT_DONE, &ar->dev_flags);
 
 	return 0;
 
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 7721e3b..79726e0 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -313,6 +313,7 @@ enum ath10k_fw_features {
 enum ath10k_dev_flags {
 	/* Indicates that ath10k device is during CAC phase of DFS */
 	ATH10K_CAC_RUNNING,
+	ATH10K_FLAG_FIRST_BOOT_DONE,
 };
 
 struct ath10k {
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index a3cdd72..2457c8b 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -19,6 +19,7 @@
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/spinlock.h>
+#include <linux/bitops.h>
 
 #include "core.h"
 #include "debug.h"
@@ -1925,7 +1926,8 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar)
 	else
 		irq_mode = "legacy";
 
-	ath10k_info("pci irq %s\n", irq_mode);
+	if (!test_bit(ATH10K_FLAG_FIRST_BOOT_DONE, &ar->dev_flags))
+		ath10k_info("pci irq %s\n", irq_mode);
 
 	return 0;
 

