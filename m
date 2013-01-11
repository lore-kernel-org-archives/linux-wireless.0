Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:59462 "EHLO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751102Ab3AKFAG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2013 00:00:06 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Tim Shepard <shep@laptop.org>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: change is_suspended variable type to atomic_t
Date: Thu, 10 Jan 2013 20:57:24 -0800
Message-Id: <1357880244-14610-1-git-send-email-bzhao@marvell.com> (sfid-20130111_060013_448876_78450B81)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

is_suspended flag can be accessed by multiple threads.
Use atomic variable type for is_suspended to ensure that there
are no undefined behaviours.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c |    2 +-
 drivers/net/wireless/mwifiex/main.c   |    2 +-
 drivers/net/wireless/mwifiex/main.h   |    2 +-
 drivers/net/wireless/mwifiex/pcie.c   |    8 ++++----
 drivers/net/wireless/mwifiex/sdio.c   |   10 +++++-----
 drivers/net/wireless/mwifiex/usb.c    |   14 +++++++-------
 6 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 5f438e6..34a1485 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -519,7 +519,7 @@ int mwifiex_send_cmd_async(struct mwifiex_private *priv, uint16_t cmd_no,
 		return -1;
 	}
 
-	if (adapter->is_suspended) {
+	if (atomic_read(&adapter->is_suspended)) {
 		dev_err(adapter->dev, "PREP_CMD: device in suspended state\n");
 		return -1;
 	}
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 9c802ed..17c4c8c 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -735,7 +735,7 @@ mwifiex_add_card(void *card, struct semaphore *sem,
 	adapter->hw_status = MWIFIEX_HW_STATUS_INITIALIZING;
 	adapter->surprise_removed = false;
 	init_waitqueue_head(&adapter->init_wait_q);
-	adapter->is_suspended = false;
+	atomic_set(&adapter->is_suspended, 0);
 	adapter->hs_activated = false;
 	init_waitqueue_head(&adapter->hs_activate_wait_q);
 	adapter->cmd_wait_q_required = false;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 51044e3..5fb642b 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -704,7 +704,7 @@ struct mwifiex_adapter {
 	u8 hs_activated;
 	u16 hs_activate_wait_q_woken;
 	wait_queue_head_t hs_activate_wait_q;
-	bool is_suspended;
+	atomic_t is_suspended;
 	u8 event_body[MAX_EVENT_SIZE];
 	u32 hw_dot_11n_dev_cap;
 	u8 hw_dev_mcs_support;
diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 3da89b4..091188c 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -127,7 +127,7 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
 
 	if (user_rmmod) {
 #ifdef CONFIG_PM
-		if (adapter->is_suspended)
+		if (atomic_read(&adapter->is_suspended))
 			mwifiex_pcie_resume(pdev);
 #endif
 
@@ -178,7 +178,7 @@ static int mwifiex_pcie_suspend(struct pci_dev *pdev, pm_message_t state)
 	hs_actived = mwifiex_enable_hs(adapter);
 
 	/* Indicate device suspended */
-	adapter->is_suspended = true;
+	atomic_set(&adapter->is_suspended, 1);
 
 	for (i = 0; i < adapter->priv_num; i++)
 		netif_carrier_off(adapter->priv[i]->netdev);
@@ -213,12 +213,12 @@ static int mwifiex_pcie_resume(struct pci_dev *pdev)
 
 	adapter = card->adapter;
 
-	if (!adapter->is_suspended) {
+	if (!atomic_read(&adapter->is_suspended)) {
 		dev_warn(adapter->dev, "Device already resumed\n");
 		return 0;
 	}
 
-	adapter->is_suspended = false;
+	atomic_set(&adapter->is_suspended, 0);
 
 	for (i = 0; i < adapter->priv_num; i++)
 		if (adapter->priv[i]->media_connected)
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index f2874c3..ad3ab91 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -127,7 +127,7 @@ mwifiex_sdio_remove(struct sdio_func *func)
 	wait_for_completion(&adapter->fw_load);
 
 	if (user_rmmod) {
-		if (adapter->is_suspended)
+		if (atomic_read(&adapter->is_suspended))
 			mwifiex_sdio_resume(adapter->dev);
 
 		for (i = 0; i < adapter->priv_num; i++)
@@ -196,7 +196,7 @@ static int mwifiex_sdio_suspend(struct device *dev)
 	ret = sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
 
 	/* Indicate device suspended */
-	adapter->is_suspended = true;
+	atomic_set(&adapter->is_suspended, 1);
 
 	for (i = 0; i < adapter->priv_num; i++)
 		netif_carrier_off(adapter->priv[i]->netdev);
@@ -236,12 +236,12 @@ static int mwifiex_sdio_resume(struct device *dev)
 
 	adapter = card->adapter;
 
-	if (!adapter->is_suspended) {
+	if (!atomic_read(&adapter->is_suspended)) {
 		dev_warn(adapter->dev, "device already resumed\n");
 		return 0;
 	}
 
-	adapter->is_suspended = false;
+	atomic_set(&adapter->is_suspended, 0);
 
 	for (i = 0; i < adapter->priv_num; i++)
 		if (adapter->priv[i]->media_connected)
@@ -342,7 +342,7 @@ mwifiex_write_data_sync(struct mwifiex_adapter *adapter,
 				MWIFIEX_SDIO_BLOCK_SIZE) : pkt_len;
 	u32 ioport = (port & MWIFIEX_SDIO_IO_PORT_MASK);
 
-	if (adapter->is_suspended) {
+	if (atomic_read(&adapter->is_suspended)) {
 		dev_err(adapter->dev,
 			"%s: not allowed while suspended\n", __func__);
 		return -1;
diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
index 5d4a10a..79cde47 100644
--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -197,7 +197,7 @@ static void mwifiex_usb_rx_complete(struct urb *urb)
 				dev_kfree_skb_any(skb);
 		}
 	} else if (urb->status) {
-		if (!adapter->is_suspended) {
+		if (!atomic_read(&adapter->is_suspended)) {
 			dev_warn(adapter->dev,
 				 "Card is removed: %d\n", urb->status);
 			adapter->surprise_removed = true;
@@ -433,7 +433,7 @@ static int mwifiex_usb_suspend(struct usb_interface *intf, pm_message_t message)
 	}
 	adapter = card->adapter;
 
-	if (unlikely(adapter->is_suspended))
+	if (unlikely(atomic_read(&adapter->is_suspended)))
 		dev_warn(adapter->dev, "Device already suspended\n");
 
 	mwifiex_enable_hs(adapter);
@@ -444,7 +444,7 @@ static int mwifiex_usb_suspend(struct usb_interface *intf, pm_message_t message)
 	 * this flag is used in combination to distinguish between a
 	 * 'suspended' state and a 'disconnect' one.
 	 */
-	adapter->is_suspended = true;
+	atomic_set(&adapter->is_suspended, 1);
 
 	for (i = 0; i < adapter->priv_num; i++)
 		netif_carrier_off(adapter->priv[i]->netdev);
@@ -486,7 +486,7 @@ static int mwifiex_usb_resume(struct usb_interface *intf)
 	}
 	adapter = card->adapter;
 
-	if (unlikely(!adapter->is_suspended)) {
+	if (unlikely(!atomic_read(&adapter->is_suspended))) {
 		dev_warn(adapter->dev, "Device already resumed\n");
 		return 0;
 	}
@@ -494,7 +494,7 @@ static int mwifiex_usb_resume(struct usb_interface *intf)
 	/* Indicate device resumed. The netdev queue will be resumed only
 	 * after the urbs have been re-submitted
 	 */
-	adapter->is_suspended = false;
+	atomic_set(&adapter->is_suspended, 0);
 
 	if (!atomic_read(&card->rx_data_urb_pending))
 		for (i = 0; i < MWIFIEX_RX_DATA_URB; i++)
@@ -550,7 +550,7 @@ static void mwifiex_usb_disconnect(struct usb_interface *intf)
 
 	if (user_rmmod) {
 #ifdef CONFIG_PM
-		if (adapter->is_suspended)
+		if (atomic_read(&adapter->is_suspended))
 			mwifiex_usb_resume(intf);
 #endif
 		for (i = 0; i < adapter->priv_num; i++)
@@ -709,7 +709,7 @@ static int mwifiex_usb_host_to_card(struct mwifiex_adapter *adapter, u8 ep,
 	u8 *data = (u8 *)skb->data;
 	struct urb *tx_urb;
 
-	if (adapter->is_suspended) {
+	if (atomic_read(&adapter->is_suspended)) {
 		dev_err(adapter->dev,
 			"%s: not allowed while suspended\n", __func__);
 		return -1;
-- 
1.7.0.2

