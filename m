Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:56545 "EHLO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750969Ab3CWEtS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Mar 2013 00:49:18 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/3] mwifiex: use fw_status register to wake up PCIe card
Date: Fri, 22 Mar 2013 21:49:07 -0700
Message-ID: <1364014147-13986-4-git-send-email-bzhao@marvell.com> (sfid-20130323_054932_098896_C30A99EB)
In-Reply-To: <1364014147-13986-1-git-send-email-bzhao@marvell.com>
References: <1364014147-13986-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

FW can be woken up even by accessing device registers; we need
not explicitily enable interrupts for doing this. Future PCIe
devices will not be woken up by writing to host registers.
This patch enables driver to wake up device by reading FW status
register.

Also devices with sleep cookie enabled need some more time before
proceeding with processing. Handle this by adding a delay loop.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c |   37 ++++++++++++++++++++++------------
 1 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 63c2921..856959b 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -287,18 +287,13 @@ static int mwifiex_read_reg(struct mwifiex_adapter *adapter, int reg, u32 *data)
 }
 
 /*
- * This function wakes up the card.
- *
- * A host power up command is written to the card configuration
- * register to wake up the card.
+ * This function adds delay loop to ensure FW is awake before proceeding.
  */
-static int mwifiex_pm_wakeup_card(struct mwifiex_adapter *adapter)
+static void mwifiex_pcie_dev_wakeup_delay(struct mwifiex_adapter *adapter)
 {
 	int i = 0;
-	struct pcie_service_card *card = adapter->card;
-	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 
-	while (reg->sleep_cookie && mwifiex_pcie_ok_to_access_hw(adapter)) {
+	while (mwifiex_pcie_ok_to_access_hw(adapter)) {
 		i++;
 		usleep_range(10, 20);
 		/* 50ms max wait */
@@ -306,16 +301,32 @@ static int mwifiex_pm_wakeup_card(struct mwifiex_adapter *adapter)
 			break;
 	}
 
+	return;
+}
+
+/* This function wakes up the card by reading fw_status register. */
+static int mwifiex_pm_wakeup_card(struct mwifiex_adapter *adapter)
+{
+	u32 fw_status;
+	struct pcie_service_card *card = adapter->card;
+	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
+
 	dev_dbg(adapter->dev, "event: Wakeup device...\n");
 
-	/* Enable interrupts or any chip access will wakeup device */
-	if (mwifiex_write_reg(adapter, PCIE_HOST_INT_MASK, HOST_INTR_MASK)) {
-		dev_warn(adapter->dev, "Enable host interrupt failed\n");
+	if (reg->sleep_cookie)
+		mwifiex_pcie_dev_wakeup_delay(adapter);
+
+	/* Reading fw_status register will wakeup device */
+	if (mwifiex_read_reg(adapter, reg->fw_status, &fw_status)) {
+		dev_warn(adapter->dev, "Reading fw_status register failed\n");
 		return -1;
 	}
 
-	dev_dbg(adapter->dev, "PCIE wakeup: Setting PS_STATE_AWAKE\n");
-	adapter->ps_state = PS_STATE_AWAKE;
+	if (reg->sleep_cookie) {
+		mwifiex_pcie_dev_wakeup_delay(adapter);
+		dev_dbg(adapter->dev, "PCIE wakeup: Setting PS_STATE_AWAKE\n");
+		adapter->ps_state = PS_STATE_AWAKE;
+	}
 
 	return 0;
 }
-- 
1.7.0.2

