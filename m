Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:10174 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbaLQKVI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2014 05:21:08 -0500
Subject: [PATCH v2 3/8] ath10k: print ath10k wmi op version
To: <ath10k@lists.infradead.org>
From: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Date: Wed, 17 Dec 2014 12:21:03 +0200
Message-ID: <20141217102103.15964.40410.stgit@potku.adurom.net> (sfid-20141217_112111_759830_9F3A1198)
In-Reply-To: <20141217101755.15964.2625.stgit@potku.adurom.net>
References: <20141217101755.15964.2625.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The internal firmware version doesn't tell much to the user, it's more
informative to use that field to print the wmi op version.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/debug.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 70a9599aeb7a..6ca24427e184 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -124,7 +124,7 @@ EXPORT_SYMBOL(ath10k_info);
 
 void ath10k_print_driver_info(struct ath10k *ar)
 {
-	ath10k_info(ar, "%s (0x%08x, 0x%08x) fw %s api %d htt %d.%d wmi %d.%d.%d.%d cal %s max_sta %d\n",
+	ath10k_info(ar, "%s (0x%08x, 0x%08x) fw %s api %d htt %d.%d wmi %d cal %s max_sta %d\n",
 		    ar->hw_params.name,
 		    ar->target_version,
 		    ar->chip_id,
@@ -132,10 +132,7 @@ void ath10k_print_driver_info(struct ath10k *ar)
 		    ar->fw_api,
 		    ar->htt.target_version_major,
 		    ar->htt.target_version_minor,
-		    ar->fw_version_major,
-		    ar->fw_version_minor,
-		    ar->fw_version_release,
-		    ar->fw_version_build,
+		    ar->wmi.op_version,
 		    ath10k_cal_mode_str(ar->cal_mode),
 		    ar->max_num_stations);
 	ath10k_info(ar, "debug %d debugfs %d tracing %d dfs %d testmode %d\n",

