Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:36888 "HELO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751872Ab1LIEl0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 23:41:26 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: failure case handling for PCIe events
Date: Thu,  8 Dec 2011 20:41:03 -0800
Message-Id: <1323405665-21942-1-git-send-email-bzhao@marvell.com> (sfid-20111209_054135_059587_AFC02016)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Event buffers for PCIe interface are allocated during driver
initialisation, and respective physical addresses are sent to FW
in *_PCIE_DESC_DETAILS command so that FW can do DMA. These buffers
will be freed while unloading the driver. Therefore we should not
free them in event handling error path. Also we should skip next
pending events in failure case.

Also fixed 'returning -1 instead of -ENOMEM is sloppy' warnings.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c |   20 ++++++--------------
 1 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index a2f3200..4053509 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -386,7 +386,7 @@ static int mwifiex_pcie_create_txbd_ring(struct mwifiex_adapter *adapter)
 	card->txbd_ring_vbase = kzalloc(card->txbd_ring_size, GFP_KERNEL);
 	if (!card->txbd_ring_vbase) {
 		dev_err(adapter->dev, "Unable to allocate buffer for txbd ring.\n");
-		return -1;
+		return -ENOMEM;
 	}
 	card->txbd_ring_pbase = virt_to_phys(card->txbd_ring_vbase);
 
@@ -476,7 +476,7 @@ static int mwifiex_pcie_create_rxbd_ring(struct mwifiex_adapter *adapter)
 	if (!card->rxbd_ring_vbase) {
 		dev_err(adapter->dev, "Unable to allocate buffer for "
 				"rxbd_ring.\n");
-		return -1;
+		return -ENOMEM;
 	}
 	card->rxbd_ring_pbase = virt_to_phys(card->rxbd_ring_vbase);
 
@@ -569,7 +569,7 @@ static int mwifiex_pcie_create_evtbd_ring(struct mwifiex_adapter *adapter)
 	if (!card->evtbd_ring_vbase) {
 		dev_err(adapter->dev, "Unable to allocate buffer. "
 				"Terminating download\n");
-		return -1;
+		return -ENOMEM;
 	}
 	card->evtbd_ring_pbase = virt_to_phys(card->evtbd_ring_vbase);
 
@@ -1231,15 +1231,13 @@ static int mwifiex_pcie_event_complete(struct mwifiex_adapter *adapter,
 	if (rdptr >= MWIFIEX_MAX_EVT_BD) {
 		dev_err(adapter->dev, "event_complete: Invalid rdptr 0x%x\n",
 					rdptr);
-		ret = -EINVAL;
-		goto done;
+		return -EINVAL;
 	}
 
 	/* Read the event ring write pointer set by firmware */
 	if (mwifiex_read_reg(adapter, REG_EVTBD_WRPTR, &wrptr)) {
 		dev_err(adapter->dev, "event_complete: failed to read REG_EVTBD_WRPTR\n");
-		ret = -1;
-		goto done;
+		return -1;
 	}
 
 	if (!card->evt_buf_list[rdptr]) {
@@ -1268,15 +1266,9 @@ static int mwifiex_pcie_event_complete(struct mwifiex_adapter *adapter,
 	/* Write the event ring read pointer in to REG_EVTBD_RDPTR */
 	if (mwifiex_write_reg(adapter, REG_EVTBD_RDPTR, card->evtbd_rdptr)) {
 		dev_err(adapter->dev, "event_complete: failed to read REG_EVTBD_RDPTR\n");
-		ret = -1;
-		goto done;
+		return -1;
 	}
 
-done:
-	/* Free the buffer for failure case */
-	if (ret && skb)
-		dev_kfree_skb_any(skb);
-
 	dev_dbg(adapter->dev, "info: Check Events Again\n");
 	ret = mwifiex_pcie_process_event_ready(adapter);
 
-- 
1.7.0.2

