Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:36669 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752680AbcLNONH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Dec 2016 09:13:07 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>, Xinming Hu <huxm@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 2/5] mwifiex: cleanup in PCIe flr code path
Date: Wed, 14 Dec 2016 19:40:48 +0530
Message-ID: <1481724651-30397-2-git-send-email-akarwar@marvell.com> (sfid-20161214_151338_306269_6D3B3D3B)
In-Reply-To: <1481724651-30397-1-git-send-email-akarwar@marvell.com>
References: <1481724651-30397-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

adapter and card variables don't get freed during PCIe function level
reset. "adapter->ext_scan" variable need not be re-initialized.
fw_name and tx_buf_size initialization is moved to pcie specific code
so that mwifiex_reinit_sw() can be used by SDIO.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/main.c |  9 ---------
 drivers/net/wireless/marvell/mwifiex/pcie.c | 12 +++++++++++-
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 3fc6221..9d80180 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -1425,9 +1425,6 @@ static void mwifiex_main_work_queue(struct work_struct *work)
 int
 mwifiex_reinit_sw(struct mwifiex_adapter *adapter)
 {
-	char fw_name[32];
-	struct pcie_service_card *card = adapter->card;
-
 	mwifiex_init_lock_list(adapter);
 	if (adapter->if_ops.up_dev)
 		adapter->if_ops.up_dev(adapter);
@@ -1468,18 +1465,12 @@ static void mwifiex_main_work_queue(struct work_struct *work)
 	 * mwifiex_register_dev()
 	 */
 	mwifiex_dbg(adapter, INFO, "%s, mwifiex_init_hw_fw()...\n", __func__);
-	strcpy(fw_name, adapter->fw_name);
-	strcpy(adapter->fw_name, PCIE8997_DEFAULT_WIFIFW_NAME);
 
-	adapter->tx_buf_size = card->pcie.tx_buf_size;
-	adapter->ext_scan = card->pcie.can_ext_scan;
 	if (mwifiex_init_hw_fw(adapter, false)) {
-		strcpy(adapter->fw_name, fw_name);
 		mwifiex_dbg(adapter, ERROR,
 			    "%s: firmware init failed\n", __func__);
 		goto err_init_fw;
 	}
-	strcpy(adapter->fw_name, fw_name);
 	mwifiex_dbg(adapter, INFO, "%s, successful\n", __func__);
 
 	complete_all(adapter->fw_done);
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 02f6db0..66226c6 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -3082,6 +3082,17 @@ static void mwifiex_pcie_up_dev(struct mwifiex_adapter *adapter)
 	struct pci_dev *pdev = card->dev;
 	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 
+	/* Bluetooth is not on pcie interface. Download Wifi only firmware
+	 * during pcie FLR, so that bluetooth part of firmware which is
+	 * already running doesn't get affected.
+	 */
+	strcpy(adapter->fw_name, PCIE8997_DEFAULT_WIFIFW_NAME);
+
+	/* tx_buf_size might be changed to 3584 by firmware during
+	 * data transfer, we should reset it to default size.
+	 */
+	adapter->tx_buf_size = card->pcie.tx_buf_size;
+
 	card->cmdrsp_buf = NULL;
 	ret = mwifiex_pcie_create_txbd_ring(adapter);
 	if (ret) {
@@ -3143,7 +3154,6 @@ static void mwifiex_pcie_down_dev(struct mwifiex_adapter *adapter)
 		mwifiex_dbg(adapter, ERROR, "Failed to write driver not-ready signature\n");
 
 	adapter->seq_num = 0;
-	adapter->tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K;
 
 	if (reg->sleep_cookie)
 		mwifiex_pcie_delete_sleep_cookie_buf(adapter);
-- 
1.9.1
