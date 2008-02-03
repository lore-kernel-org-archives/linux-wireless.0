Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:27351 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbYBCO4l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Feb 2008 09:56:41 -0500
Received: by fg-out-1718.google.com with SMTP id e21so1676598fga.17
        for <linux-wireless@vger.kernel.org>; Sun, 03 Feb 2008 06:56:40 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 11/19] rt2x00: Remove TX_MGMT queue usage
Date: Sun, 3 Feb 2008 15:51:47 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802031541.52167.IvDoorn@gmail.com>
In-Reply-To: <200802031541.52167.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802031551.47373.IvDoorn@gmail.com> (sfid-20080203_145651_625959_DAE32BF6)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt73usb doesn't have a 5th queue, correctly initialize hw->queues
rt61pci had a 5th queue but was removed recently, correctly initialize
hw->queues and remove the last remnants.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt61pci.c |    5 +----
 drivers/net/wireless/rt2x00/rt73usb.c |    2 +-
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index aa6b1cf..2f1db99 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1435,7 +1435,6 @@ static void rt61pci_disable_radio(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, TX_CNTL_CSR_ABORT_TX_AC1, 1);
 	rt2x00_set_field32(&reg, TX_CNTL_CSR_ABORT_TX_AC2, 1);
 	rt2x00_set_field32(&reg, TX_CNTL_CSR_ABORT_TX_AC3, 1);
-	rt2x00_set_field32(&reg, TX_CNTL_CSR_ABORT_TX_MGMT, 1);
 	rt2x00pci_register_write(rt2x00dev, TX_CNTL_CSR, reg);
 
 	/*
@@ -1608,8 +1607,6 @@ static void rt61pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 			   (queue == IEEE80211_TX_QUEUE_DATA2));
 	rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC3,
 			   (queue == IEEE80211_TX_QUEUE_DATA3));
-	rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_MGMT,
-			   (queue == IEEE80211_TX_QUEUE_DATA4));
 	rt2x00pci_register_write(rt2x00dev, TX_CNTL_CSR, reg);
 }
 
@@ -2209,7 +2206,7 @@ static void rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->hw->extra_tx_headroom = 0;
 	rt2x00dev->hw->max_signal = MAX_SIGNAL;
 	rt2x00dev->hw->max_rssi = MAX_RX_SSI;
-	rt2x00dev->hw->queues = 5;
+	rt2x00dev->hw->queues = 4;
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, &rt2x00dev_pci(rt2x00dev)->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index be8bfc5..cff5eb4 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1793,7 +1793,7 @@ static void rt73usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->hw->extra_tx_headroom = TXD_DESC_SIZE;
 	rt2x00dev->hw->max_signal = MAX_SIGNAL;
 	rt2x00dev->hw->max_rssi = MAX_RX_SSI;
-	rt2x00dev->hw->queues = 5;
+	rt2x00dev->hw->queues = 4;
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, &rt2x00dev_usb(rt2x00dev)->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
-- 
1.5.3.8

