Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:35846 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393AbaE3JTf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2014 05:19:35 -0400
Received: by mail-we0-f174.google.com with SMTP id k48so1678831wev.5
        for <linux-wireless@vger.kernel.org>; Fri, 30 May 2014 02:19:34 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] ath10k: print Kconfig options
Date: Fri, 30 May 2014 11:19:23 +0200
Message-Id: <1401441563-9921-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140530_111945_384908_36C93DB9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Print Kconfig options enabled/disabled in the build.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 82017f5..68bed4e 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -798,7 +798,7 @@ int ath10k_core_start(struct ath10k *ar)
 	ar->free_vdev_map = (1 << TARGET_NUM_VDEVS) - 1;
 	INIT_LIST_HEAD(&ar->arvifs);
 
-	if (!test_bit(ATH10K_FLAG_FIRST_BOOT_DONE, &ar->dev_flags))
+	if (!test_bit(ATH10K_FLAG_FIRST_BOOT_DONE, &ar->dev_flags)) {
 		ath10k_info("%s (0x%08x, 0x%08x) fw %s api %d htt %d.%d\n",
 			    ar->hw_params.name,
 			    ar->target_version,
@@ -807,6 +807,12 @@ int ath10k_core_start(struct ath10k *ar)
 			    ar->fw_api,
 			    ar->htt.target_version_major,
 			    ar->htt.target_version_minor);
+		ath10k_info("debug %d debugfs %d tracing %d dfs %d\n",
+			    config_enabled(CONFIG_ATH10K_DEBUG),
+			    config_enabled(CONFIG_ATH10K_DEBUGFS),
+			    config_enabled(CONFIG_ATH10K_TRACING),
+			    config_enabled(CONFIG_ATH10K_DFS_CERTIFIED));
+	}
 
 	__set_bit(ATH10K_FLAG_FIRST_BOOT_DONE, &ar->dev_flags);
 
-- 
1.7.9.5

