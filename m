Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:39388 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbaC1HdF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 03:33:05 -0400
Subject: [PATCH v2 8/8] ath10k: print chip id during boot
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 28 Mar 2014 09:33:04 +0200
Message-ID: <20140328073304.30438.94161.stgit@potku.adurom.net> (sfid-20140328_083309_195391_0EBE615D)
In-Reply-To: <20140328073040.30438.17966.stgit@potku.adurom.net>
References: <20140328073040.30438.17966.stgit@potku.adurom.net>
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
 

