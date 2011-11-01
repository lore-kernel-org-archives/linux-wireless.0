Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:44009 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab1KAGok (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Nov 2011 02:44:40 -0400
Subject: [PATCH v2 6/7] ath6kl: refactor sdio configuration to a separate
	function
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 01 Nov 2011 08:44:36 +0200
Message-ID: <20111101064436.6798.86981.stgit@localhost6.localdomain6> (sfid-20111101_074443_804469_5517770C)
In-Reply-To: <20111101064140.6798.7006.stgit@localhost6.localdomain6>
References: <20111101064140.6798.7006.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These commands are also needed after cutpower suspend so create
a function for them. Also fix memory leaks in ath6kl_sdio_probe() error
path.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/sdio.c |   77 ++++++++++++++++++--------------
 1 files changed, 44 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 75b1eaa..b02ecea 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -733,6 +733,46 @@ static int ath6kl_sdio_enable_scatter(struct ath6kl *ar)
 	return 0;
 }
 
+static int ath6kl_sdio_config(struct ath6kl *ar)
+{
+	struct ath6kl_sdio *ar_sdio = ath6kl_sdio_priv(ar);
+	struct sdio_func *func = ar_sdio->func;
+	int ret;
+
+	sdio_claim_host(func);
+
+	if ((ar_sdio->id->device & MANUFACTURER_ID_ATH6KL_BASE_MASK) >=
+	    MANUFACTURER_ID_AR6003_BASE) {
+		/* enable 4-bit ASYNC interrupt on AR6003 or later */
+		ret = ath6kl_sdio_func0_cmd52_wr_byte(func->card,
+						CCCR_SDIO_IRQ_MODE_REG,
+						SDIO_IRQ_MODE_ASYNC_4BIT_IRQ);
+		if (ret) {
+			ath6kl_err("Failed to enable 4-bit async irq mode %d\n",
+				   ret);
+			goto out;
+		}
+
+		ath6kl_dbg(ATH6KL_DBG_BOOT, "4-bit async irq mode enabled\n");
+	}
+
+	/* give us some time to enable, in ms */
+	func->enable_timeout = 100;
+
+	ret = sdio_set_block_size(func, HIF_MBOX_BLOCK_SIZE);
+	if (ret) {
+		ath6kl_err("Set sdio block size %d failed: %d)\n",
+			   HIF_MBOX_BLOCK_SIZE, ret);
+		sdio_release_host(func);
+		goto out;
+	}
+
+out:
+	sdio_release_host(func);
+
+	return ret;
+}
+
 static int ath6kl_sdio_suspend(struct ath6kl *ar)
 {
 	struct ath6kl_sdio *ar_sdio = ath6kl_sdio_priv(ar);
@@ -873,45 +913,16 @@ static int ath6kl_sdio_probe(struct sdio_func *func,
 
 	ath6kl_sdio_set_mbox_info(ar);
 
-	sdio_claim_host(func);
-
-	if ((ar_sdio->id->device & MANUFACTURER_ID_ATH6KL_BASE_MASK) >=
-	    MANUFACTURER_ID_AR6003_BASE) {
-		/* enable 4-bit ASYNC interrupt on AR6003 or later */
-		ret = ath6kl_sdio_func0_cmd52_wr_byte(func->card,
-						CCCR_SDIO_IRQ_MODE_REG,
-						SDIO_IRQ_MODE_ASYNC_4BIT_IRQ);
-		if (ret) {
-			ath6kl_err("Failed to enable 4-bit async irq mode %d\n",
-				   ret);
-			sdio_release_host(func);
-			goto err_core_alloc;
-		}
-
-		ath6kl_dbg(ATH6KL_DBG_BOOT, "4-bit async irq mode enabled\n");
-	}
-
-	/* give us some time to enable, in ms */
-	func->enable_timeout = 100;
-
-	sdio_release_host(func);
-
-	sdio_claim_host(func);
-
-	ret = sdio_set_block_size(func, HIF_MBOX_BLOCK_SIZE);
+	ret = ath6kl_sdio_config(ar);
 	if (ret) {
-		ath6kl_err("Set sdio block size %d failed: %d)\n",
-			   HIF_MBOX_BLOCK_SIZE, ret);
-		sdio_release_host(func);
-		goto err_hif;
+		ath6kl_err("Failed to config sdio: %d\n", ret);
+		goto err_core_alloc;
 	}
 
-	sdio_release_host(func);
-
 	ret = ath6kl_core_init(ar);
 	if (ret) {
 		ath6kl_err("Failed to init ath6kl core\n");
-		goto err_hif;
+		goto err_core_alloc;
 	}
 
 	return ret;

