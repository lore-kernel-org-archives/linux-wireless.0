Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:54749 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758550AbZFOPi0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2009 11:38:26 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Samuel Ortiz <samuel.ortiz@intel.com>
Subject: [PATCH 04/12][2.6.31 and w-t] iwmc3200wifi: fix potential kernel oops on module removal
Date: Mon, 15 Jun 2009 17:39:20 +0200
Message-Id: <ed1078e3b1524ac3bf3888b0881e40bddc8fb690.1245076752.git.samuel@sortiz.org>
In-Reply-To: <9b2b9b463d1313b871f56ad77b48b4960653b766.1245076752.git.samuel@sortiz.org>
References: <cover.1245076752.git.samuel@sortiz.org>
 <8843005a4ec0cad33483426a4ecc7656bce24243.1245076752.git.samuel@sortiz.org>
 <afbb543a0654cc171faa882457cc603d3f038d27.1245076752.git.samuel@sortiz.org>
 <9b2b9b463d1313b871f56ad77b48b4960653b766.1245076752.git.samuel@sortiz.org>
In-Reply-To: <cover.1245076752.git.samuel@sortiz.org>
References: <cover.1245076752.git.samuel@sortiz.org>
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
index 057a588..462bbf6 100644
--- a/drivers/net/wireless/iwmc3200wifi/sdio.c
+++ b/drivers/net/wireless/iwmc3200wifi/sdio.c
@@ -482,10 +482,10 @@ static void iwm_sdio_remove(struct sdio_func *func)
 	struct iwm_priv *iwm = hw_to_iwm(hw);
 	struct device *dev = &func->dev;
 
-	iwm_debugfs_exit(iwm);
 	iwm_if_remove(iwm);
-	iwm_if_free(iwm);
 	destroy_workqueue(hw->isr_wq);
+	iwm_debugfs_exit(iwm);
+	iwm_if_free(iwm);
 
 	sdio_set_drvdata(func, NULL);
 	clear_bit(IWM_STATUS_BUS_READY, &iwm->status);
-- 
1.6.3.1

