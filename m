Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:54071 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186AbaIWIdl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2014 04:33:41 -0400
Received: by mail-wi0-f172.google.com with SMTP id em10so4353059wid.17
        for <linux-wireless@vger.kernel.org>; Tue, 23 Sep 2014 01:33:39 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 1/3] ath10k: print wmi version info
Date: Tue, 23 Sep 2014 10:22:52 +0200
Message-Id: <1411460574-5424-2-git-send-email-michal.kazior@tieto.com> (sfid-20140923_103353_556017_5E5FBE97)
In-Reply-To: <1411460574-5424-1-git-send-email-michal.kazior@tieto.com>
References: <1411460574-5424-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HTT version is already printed so print WMI
version as well for consistency.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/debug.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 3756feb..f1e5916 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -126,14 +126,18 @@ EXPORT_SYMBOL(ath10k_info);
 
 void ath10k_print_driver_info(struct ath10k *ar)
 {
-	ath10k_info(ar, "%s (0x%08x, 0x%08x) fw %s api %d htt %d.%d\n",
+	ath10k_info(ar, "%s (0x%08x, 0x%08x) fw %s api %d htt %d.%d wmi %d.%d.%d.%d\n",
 		    ar->hw_params.name,
 		    ar->target_version,
 		    ar->chip_id,
 		    ar->hw->wiphy->fw_version,
 		    ar->fw_api,
 		    ar->htt.target_version_major,
-		    ar->htt.target_version_minor);
+		    ar->htt.target_version_minor,
+		    ar->fw_version_major,
+		    ar->fw_version_minor,
+		    ar->fw_version_release,
+		    ar->fw_version_build);
 	ath10k_info(ar, "debug %d debugfs %d tracing %d dfs %d testmode %d\n",
 		    config_enabled(CONFIG_ATH10K_DEBUG),
 		    config_enabled(CONFIG_ATH10K_DEBUGFS),
-- 
1.8.5.3

