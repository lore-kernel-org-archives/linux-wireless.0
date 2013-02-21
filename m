Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:52299 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751002Ab3BUFO0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2013 00:14:26 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.9] mwifiex: fix system freeze while reloading driver
Date: Wed, 20 Feb 2013 21:12:58 -0800
Message-Id: <1361423578-14967-1-git-send-email-bzhao@marvell.com> (sfid-20130221_061430_299995_DB072E47)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

Unload sequence for mwifiex PCIE driver is as follows:
1. Invoking cleanup module from kernel results into
   pci_unregister_driver
2. Kernel invokes PCIE remove() handler which disconnects all
   interfaces.
3. One step during disconnect is to clean PCIE TX rings.
   During this we read txbd_rdptr from FW.

While loading driver next time, we see pci_enable_device()
results into system freeze. This may have happened because we
accessed PCI device after unregistering from bus driver.
Removing this ioread() operation resolves this bug.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 4b54bcf..c4627bc 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -916,17 +916,8 @@ static int mwifiex_pcie_delete_sleep_cookie_buf(struct mwifiex_adapter *adapter)
 static int mwifiex_clean_pcie_ring_buf(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
-	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
-	u32 rdptr;
-
-	/* Read the TX ring read pointer set by firmware */
-	if (mwifiex_read_reg(adapter, reg->tx_rdptr, &rdptr)) {
-		dev_err(adapter->dev,
-			"Flush TXBD: failed to read reg->tx_rdptr\n");
-		return -1;
-	}
 
-	if (!mwifiex_pcie_txbd_empty(card, rdptr)) {
+	if (!mwifiex_pcie_txbd_empty(card, card->txbd_rdptr)) {
 		card->txbd_flush = 1;
 		/* write pointer already set at last send
 		 * send dnld-rdy intr again, wait for completion.
-- 
1.7.0.2

