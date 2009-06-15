Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24053 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200AbZFOT5s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2009 15:57:48 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Samuel Ortiz <samuel.ortiz@intel.com>
Subject: [PATCH 03/11 v2][2.6.31 and w-t] iwmc3200wifi: fix potential kernel oops on module removal
Date: Mon, 15 Jun 2009 21:59:48 +0200
Message-Id: <7413d2605b449b8e43bcfe61719ee30fccb592b7.1245091931.git.samuel@sortiz.org>
In-Reply-To: <cover.1245091931.git.samuel@sortiz.org>
References: <cover.1245091931.git.samuel@sortiz.org>
In-Reply-To: <cover.1245091931.git.samuel@sortiz.org>
References: <cover.1245091931.git.samuel@sortiz.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>

The iwm_if_free() is called before destroy_workqueue for isr_wq on
device remove method. But if there is still some pending work in
the isr_wq, the required data structures are already freed at this
point. This leeds a kernel oops. The patch fixes this problem by
moving iwm_if_free after destroy_workqueue.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/sdio.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/sdio.c b/drivers/net/wireless/iwmc3200wifi/sdio.c
index c040571..9166818 100644
--- a/drivers/net/wireless/iwmc3200wifi/sdio.c
+++ b/drivers/net/wireless/iwmc3200wifi/sdio.c
@@ -479,10 +479,10 @@ static void iwm_sdio_remove(struct sdio_func *func)
 	struct iwm_priv *iwm = hw_to_iwm(hw);
 	struct device *dev = &func->dev;
 
-	iwm_debugfs_exit(iwm);
 	iwm_if_remove(iwm);
-	iwm_if_free(iwm);
 	destroy_workqueue(hw->isr_wq);
+	iwm_debugfs_exit(iwm);
+	iwm_if_free(iwm);
 
 	sdio_set_drvdata(func, NULL);
 
-- 
1.6.3.1

