Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:57497 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbaCYJPr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2014 05:15:47 -0400
Subject: [PATCH 8/8] ath10k: print chip id during boot
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 25 Mar 2014 11:15:46 +0200
Message-ID: <20140325091546.16651.33866.stgit@potku.adurom.net> (sfid-20140325_101550_644901_1FE95177)
In-Reply-To: <20140325091311.16651.15747.stgit@potku.adurom.net>
References: <20140325091311.16651.15747.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes it easier to debug what kind of board is used.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 471c219e5137..0077ba17e5c0 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -844,9 +844,12 @@ int ath10k_core_start(struct ath10k *ar)
 	INIT_LIST_HEAD(&ar->arvifs);
 
 	if (!test_bit(ATH10K_FLAG_FIRST_BOOT_DONE, &ar->dev_flags))
-		ath10k_info("%s (0x%x) fw %s api %d htt %d.%d\n",
-			    ar->hw_params.name, ar->target_version,
-			    ar->hw->wiphy->fw_version, ar->fw_api,
+		ath10k_info("%s (0x%08x, 0x%08x) fw %s api %d htt %d.%d\n",
+			    ar->hw_params.name,
+			    ar->target_version,
+			    ar->chip_id,
+			    ar->hw->wiphy->fw_version,
+			    ar->fw_api,
 			    ar->htt.target_version_major,
 			    ar->htt.target_version_minor);
 

