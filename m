Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49143 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753293AbdCOPqN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Mar 2017 11:46:13 -0400
Subject: [PATCH v6 06/10] ath10k: add sdio extra initializations
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Date: Wed, 15 Mar 2017 17:46:01 +0200
Message-ID: <148959276143.31432.4108050733445067980.stgit@potku.adurom.net> (sfid-20170315_164929_097451_244CCBDA)
In-Reply-To: <148959263520.31432.8488419244476213373.stgit@potku.adurom.net>
References: <148959263520.31432.8488419244476213373.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Erik Stromdahl <erik.stromdahl@gmail.com>

Extra initializations needed by all sdio boards.
Derived from qcacld.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index f450ebbb28d5..6b6ea8a571fa 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -377,7 +377,22 @@ static void ath10k_send_suspend_complete(struct ath10k *ar)
 	complete(&ar->target_suspend);
 }
 
-static int ath10k_init_configure_target(struct ath10k *ar)
+static void ath10k_sdio_extra_initialization(struct ath10k *ar)
+{
+	u32 param = 0;
+
+	ath10k_bmi_write32(ar, hi_mbox_io_block_sz, 256);
+	ath10k_bmi_write32(ar, hi_mbox_isr_yield_limit, 99);
+	ath10k_bmi_read32(ar, hi_acs_flags, &param);
+
+	param |= (HI_ACS_FLAGS_SDIO_SWAP_MAILBOX_SET |
+		  HI_ACS_FLAGS_SDIO_REDUCE_TX_COMPL_SET |
+		  HI_ACS_FLAGS_ALT_DATA_CREDIT_SIZE);
+
+	ath10k_bmi_write32(ar, hi_acs_flags, param);
+}
+
+static int ath10k_init_sdio(struct ath10k *ar)
 {
 	u32 param_host;
 	int ret;
@@ -1900,7 +1915,7 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
 
 	ath10k_bmi_start(ar);
 
-	if (ath10k_init_configure_target(ar)) {
+	if (ath10k_init_sdio(ar)) {
 		status = -EINVAL;
 		goto err;
 	}
@@ -1933,6 +1948,9 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
 	if (status)
 		goto err;
 
+	if (ar->hif.bus == ATH10K_BUS_SDIO)
+		ath10k_sdio_extra_initialization(ar);
+
 	ar->htc.htc_ops.target_send_suspend_complete =
 		ath10k_send_suspend_complete;
 
