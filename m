Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:22582 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828Ab0DFJhm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Apr 2010 05:37:42 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 06 Apr 2010 02:37:42 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19387.1459.438884.832345@gargle.gargle.HOWL>
Date: Tue, 6 Apr 2010 15:28:11 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/5] ath9k_htc: Protect RX stream variables
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use a spin lock to prevent concurrent access
to variables dealing with RX stream mode handling.
Currently, no protection is implemented - which
causes problems in RX.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |    8 ++++++++
 drivers/net/wireless/ath/ath9k/hif_usb.h |    1 +
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 3afc747..8838cdf 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -330,6 +330,8 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 	u16 pkt_len, pkt_tag, pool_index = 0;
 	u8 *ptr;
 
+	spin_lock(&hif_dev->rx_lock);
+
 	rx_remain_len = hif_dev->rx_remain_len;
 	rx_pkt_len = hif_dev->rx_transfer_len;
 
@@ -356,6 +358,8 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 		}
 	}
 
+	spin_unlock(&hif_dev->rx_lock);
+
 	while (index < len) {
 		ptr = (u8 *) skb->data;
 
@@ -373,6 +377,7 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 			index = index + 4 + pkt_len + pad_len;
 
 			if (index > MAX_RX_BUF_SIZE) {
+				spin_lock(&hif_dev->rx_lock);
 				hif_dev->rx_remain_len = index - MAX_RX_BUF_SIZE;
 				hif_dev->rx_transfer_len =
 					MAX_RX_BUF_SIZE - chk_idx - 4;
@@ -384,6 +389,7 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 					dev_err(&hif_dev->udev->dev,
 					"ath9k_htc: RX memory allocation"
 					" error\n");
+					spin_unlock(&hif_dev->rx_lock);
 					goto err;
 				}
 				skb_reserve(nskb, 32);
@@ -394,6 +400,7 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 
 				/* Record the buffer pointer */
 				hif_dev->remain_skb = nskb;
+				spin_unlock(&hif_dev->rx_lock);
 			} else {
 				nskb = __dev_alloc_skb(pkt_len + 32, GFP_ATOMIC);
 				if (!nskb) {
@@ -612,6 +619,7 @@ static int ath9k_hif_usb_alloc_rx_urbs(struct hif_device_usb *hif_dev)
 	int i, ret;
 
 	init_usb_anchor(&hif_dev->rx_submitted);
+	spin_lock_init(&hif_dev->rx_lock);
 
 	for (i = 0; i < MAX_RX_URB_NUM; i++) {
 
diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.h b/drivers/net/wireless/ath/ath9k/hif_usb.h
index ea9257b..ed9708c 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.h
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.h
@@ -93,6 +93,7 @@ struct hif_device_usb {
 	int rx_pkt_len;
 	int rx_transfer_len;
 	int rx_pad_len;
+	spinlock_t rx_lock;
 	u8 flags; /* HIF_USB_* */
 };
 
-- 
1.7.0.3

