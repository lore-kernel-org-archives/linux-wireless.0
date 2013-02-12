Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:43460 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752494Ab3BLWil (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 17:38:41 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: device specific sleep cookie handling for PCIe
Date: Tue, 12 Feb 2013 14:38:32 -0800
Message-Id: <1360708712-23862-1-git-send-email-bzhao@marvell.com> (sfid-20130212_233845_162953_EB8E9BD1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch adds support for handling of PCIe sleep cookie depending
upon device properties. Some PCIe devices need sleep cookie probing
before accessing HW while some others don't. A new sleep_cookie
variable is defined as part of mwifiex_pcie_card_reg strcture and
set/reset as per device capability.

Sleep cookie is allocated/accessed/freed only when flag sleep_cookie
for this particular device is enabled.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c |   30 ++++++++++++++++++++++--------
 drivers/net/wireless/mwifiex/pcie.h |    3 +++
 2 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 3b9be7c..492655c 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -62,6 +62,10 @@ static bool mwifiex_pcie_ok_to_access_hw(struct mwifiex_adapter *adapter)
 {
 	u32 *cookie_addr;
 	struct pcie_service_card *card = adapter->card;
+	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
+
+	if (!reg->sleep_cookie)
+		return true;
 
 	if (card->sleep_cookie_vbase) {
 		cookie_addr = (u32 *)card->sleep_cookie_vbase;
@@ -299,8 +303,10 @@ static int mwifiex_read_reg(struct mwifiex_adapter *adapter, int reg, u32 *data)
 static int mwifiex_pm_wakeup_card(struct mwifiex_adapter *adapter)
 {
 	int i = 0;
+	struct pcie_service_card *card = adapter->card;
+	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 
-	while (mwifiex_pcie_ok_to_access_hw(adapter)) {
+	while (reg->sleep_cookie && mwifiex_pcie_ok_to_access_hw(adapter)) {
 		i++;
 		usleep_range(10, 20);
 		/* 50ms max wait */
@@ -1513,8 +1519,8 @@ static int mwifiex_pcie_process_cmd_complete(struct mwifiex_adapter *adapter)
 		if (adapter->ps_state == PS_STATE_SLEEP_CFM) {
 			mwifiex_process_sleep_confirm_resp(adapter, skb->data,
 							   skb->len);
-			while (mwifiex_pcie_ok_to_access_hw(adapter) &&
-							(count++ < 10))
+			while (reg->sleep_cookie && (count++ < 10) &&
+			       mwifiex_pcie_ok_to_access_hw(adapter))
 				usleep_range(50, 60);
 		} else {
 			dev_err(adapter->dev,
@@ -2172,6 +2178,7 @@ static int mwifiex_pcie_init(struct mwifiex_adapter *adapter)
 	struct pcie_service_card *card = adapter->card;
 	int ret;
 	struct pci_dev *pdev = card->dev;
+	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 
 	pci_set_drvdata(pdev, card);
 
@@ -2234,10 +2241,13 @@ static int mwifiex_pcie_init(struct mwifiex_adapter *adapter)
 	ret = mwifiex_pcie_alloc_cmdrsp_buf(adapter);
 	if (ret)
 		goto err_alloc_cmdbuf;
-	ret = mwifiex_pcie_alloc_sleep_cookie_buf(adapter);
-	if (ret)
-		goto err_alloc_cookie;
-
+	if (reg->sleep_cookie) {
+		ret = mwifiex_pcie_alloc_sleep_cookie_buf(adapter);
+		if (ret)
+			goto err_alloc_cookie;
+	} else {
+		card->sleep_cookie_vbase = NULL;
+	}
 	return ret;
 
 err_alloc_cookie:
@@ -2334,12 +2344,16 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 static void mwifiex_unregister_dev(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
+	const struct mwifiex_pcie_card_reg *reg;
 
 	if (card) {
 		dev_dbg(adapter->dev, "%s(): calling free_irq()\n", __func__);
 		free_irq(card->dev->irq, card->dev);
 
-		mwifiex_pcie_delete_sleep_cookie_buf(adapter);
+		reg = card->pcie.reg;
+		if (reg->sleep_cookie)
+			mwifiex_pcie_delete_sleep_cookie_buf(adapter);
+
 		mwifiex_pcie_delete_cmdrsp_buf(adapter);
 		mwifiex_pcie_delete_evtbd_ring(adapter);
 		mwifiex_pcie_delete_rxbd_ring(adapter);
diff --git a/drivers/net/wireless/mwifiex/pcie.h b/drivers/net/wireless/mwifiex/pcie.h
index 6080615..d322ab8 100644
--- a/drivers/net/wireless/mwifiex/pcie.h
+++ b/drivers/net/wireless/mwifiex/pcie.h
@@ -126,6 +126,7 @@ struct mwifiex_pcie_card_reg {
 	u8 ring_flag_xs_eop;
 	u32 ring_tx_start_ptr;
 	u8 pfu_enabled;
+	u8 sleep_cookie;
 };
 
 static const struct mwifiex_pcie_card_reg mwifiex_reg_8766 = {
@@ -156,6 +157,7 @@ static const struct mwifiex_pcie_card_reg mwifiex_reg_8766 = {
 	.ring_flag_xs_eop = 0,
 	.ring_tx_start_ptr = 0,
 	.pfu_enabled = 0,
+	.sleep_cookie = 1,
 };
 
 static const struct mwifiex_pcie_card_reg mwifiex_reg_8897 = {
@@ -186,6 +188,7 @@ static const struct mwifiex_pcie_card_reg mwifiex_reg_8897 = {
 	.ring_flag_xs_eop = MWIFIEX_BD_FLAG_XS_EOP,
 	.ring_tx_start_ptr = MWIFIEX_BD_FLAG_TX_START_PTR,
 	.pfu_enabled = 1,
+	.sleep_cookie = 0,
 };
 
 struct mwifiex_pcie_device {
-- 
1.7.0.2

