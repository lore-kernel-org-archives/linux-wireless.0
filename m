Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:46888 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751989AbeB1HuY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Feb 2018 02:50:24 -0500
Received: by mail-pf0-f195.google.com with SMTP id z10so682539pfh.13
        for <linux-wireless@vger.kernel.org>; Tue, 27 Feb 2018 23:50:24 -0800 (PST)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 2/3] rsi: use dynamic RX control blocks instead of MAX_RX_URB
Date: Wed, 28 Feb 2018 13:08:27 +0530
Message-Id: <1519803508-27737-3-git-send-email-amitkarwar@gmail.com> (sfid-20180228_085028_901408_8F3D72A7)
In-Reply-To: <1519803508-27737-1-git-send-email-amitkarwar@gmail.com>
References: <1519803508-27737-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

Currently 2 RX control blocks are allocated by default.
If wifi alone mode is used rx control block 2 is unusable.
So, changes are done accordingly in all places to use
RX control blocks dynamically based on coex mode check.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_usb.c     | 34 ++++++++++++++++++------------
 drivers/net/wireless/rsi/rsi_91x_usb_ops.c |  5 +++--
 2 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 0a50cff..64781a3 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -497,15 +497,15 @@ static struct rsi_host_intf_ops usb_host_intf_ops = {
  */
 static void rsi_deinit_usb_interface(struct rsi_hw *adapter)
 {
-	u8 idx;
-
 	struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)adapter->rsi_dev;
 
 	rsi_kill_thread(&dev->rx_thread);
 
-	for (idx = 0; idx < MAX_RX_URBS; idx++) {
-		usb_free_urb(dev->rx_cb[idx].rx_urb);
-		kfree(dev->rx_cb[idx].rx_buffer);
+	usb_free_urb(dev->rx_cb[0].rx_urb);
+	kfree(dev->rx_cb[0].rx_buffer);
+	if (adapter->priv->coex_mode > 1) {
+		usb_free_urb(dev->rx_cb[1].rx_urb);
+		kfree(dev->rx_cb[1].rx_buffer);
 	}
 
 	kfree(adapter->priv->rx_data_pkt);
@@ -516,9 +516,11 @@ static int rsi_usb_init_rx(struct rsi_hw *adapter)
 {
 	struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)adapter->rsi_dev;
 	struct rx_usb_ctrl_block *rx_cb;
-	u8 idx;
+	u8 idx, num_rx_cb;
+
+	num_rx_cb = (adapter->priv->coex_mode > 1 ? 2 : 1);
 
-	for (idx = 0; idx < MAX_RX_URBS; idx++) {
+	for (idx = 0; idx < num_rx_cb; idx++) {
 		rx_cb = &dev->rx_cb[idx];
 
 		rx_cb->rx_buffer = kzalloc(RSI_USB_BUF_SIZE * 2,
@@ -538,9 +540,11 @@ static int rsi_usb_init_rx(struct rsi_hw *adapter)
 	return 0;
 
 err:
-	for (idx = 0; idx < MAX_RX_URBS; idx++) {
-		kfree(dev->rx_cb[idx].rx_buffer);
-		kfree(dev->rx_cb[idx].rx_urb);
+	kfree(dev->rx_cb[0].rx_buffer);
+	usb_free_urb(dev->rx_cb[0].rx_urb);
+	if (adapter->priv->coex_mode > 1) {
+		kfree(dev->rx_cb[1].rx_buffer);
+		usb_free_urb(dev->rx_cb[1].rx_urb);
 	}
 	return -1;
 }
@@ -557,7 +561,7 @@ static int rsi_init_usb_interface(struct rsi_hw *adapter,
 {
 	struct rsi_91x_usbdev *rsi_dev;
 	struct rsi_common *common = adapter->priv;
-	int status, i;
+	int status;
 
 	rsi_dev = kzalloc(sizeof(*rsi_dev), GFP_KERNEL);
 	if (!rsi_dev)
@@ -617,9 +621,11 @@ static int rsi_init_usb_interface(struct rsi_hw *adapter,
 	return 0;
 
 fail_thread:
-	for (i = 0; i < MAX_RX_URBS; i++) {
-		kfree(rsi_dev->rx_cb[i].rx_buffer);
-		kfree(rsi_dev->rx_cb[i].rx_urb);
+	kfree(rsi_dev->rx_cb[0].rx_buffer);
+	usb_free_urb(rsi_dev->rx_cb[0].rx_urb);
+	if (common->coex_mode > 1) {
+		kfree(rsi_dev->rx_cb[1].rx_buffer);
+		usb_free_urb(rsi_dev->rx_cb[1].rx_urb);
 	}
 fail_tx:
 	kfree(common->rx_data_pkt);
diff --git a/drivers/net/wireless/rsi/rsi_91x_usb_ops.c b/drivers/net/wireless/rsi/rsi_91x_usb_ops.c
index d0650ea..fc25b1b 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb_ops.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb_ops.c
@@ -30,15 +30,16 @@ void rsi_usb_rx_thread(struct rsi_common *common)
 	struct rsi_hw *adapter = common->priv;
 	struct rsi_91x_usbdev *dev = (struct rsi_91x_usbdev *)adapter->rsi_dev;
 	struct rx_usb_ctrl_block *rx_cb;
-	int status, idx;
+	int status, idx, num_rx_cb;
 
+	num_rx_cb = (adapter->priv->coex_mode > 1 ? 2 : 1);
 	do {
 		rsi_wait_event(&dev->rx_thread.event, EVENT_WAIT_FOREVER);
 
 		if (atomic_read(&dev->rx_thread.thread_done))
 			goto out;
 
-		for (idx = 0; idx < MAX_RX_URBS; idx++) {
+		for (idx = 0; idx < num_rx_cb; idx++) {
 			rx_cb = &dev->rx_cb[idx];
 			if (!rx_cb->pend)
 				continue;
-- 
2.7.4
