Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:58537 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757246AbZKWVpN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 16:45:13 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH v2 6/8] rt2x00: Centralize setting of extra TX headroom requested by rt2x00.
Date: Mon, 23 Nov 2009 22:44:52 +0100
Message-Id: <1259012694-14869-7-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1259012694-14869-6-git-send-email-gwingerde@gmail.com>
References: <1259012694-14869-1-git-send-email-gwingerde@gmail.com>
 <1259012694-14869-2-git-send-email-gwingerde@gmail.com>
 <1259012694-14869-3-git-send-email-gwingerde@gmail.com>
 <1259012694-14869-4-git-send-email-gwingerde@gmail.com>
 <1259012694-14869-5-git-send-email-gwingerde@gmail.com>
 <1259012694-14869-6-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set the value of extra_tx_headroom in a central place, rather than in each
of the drivers. This is preparatory for taking alignment space into account
in the TX headroom requested by rt2x00.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |    2 +-
 drivers/net/wireless/rt2x00/rt2500pci.c |    3 +--
 drivers/net/wireless/rt2x00/rt2500usb.c |    3 +--
 drivers/net/wireless/rt2x00/rt2800lib.c |    6 ------
 drivers/net/wireless/rt2x00/rt2800pci.c |    7 ++++---
 drivers/net/wireless/rt2x00/rt2800usb.c |    1 +
 drivers/net/wireless/rt2x00/rt2x00.h    |    1 +
 drivers/net/wireless/rt2x00/rt2x00dev.c |    5 +++++
 drivers/net/wireless/rt2x00/rt61pci.c   |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.c   |    2 +-
 10 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 7f900be..e7f4640 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1432,7 +1432,6 @@ static int rt2400pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 			       IEEE80211_HW_SIGNAL_DBM |
 			       IEEE80211_HW_SUPPORTS_PS |
 			       IEEE80211_HW_PS_NULLFUNC_STACK;
-	rt2x00dev->hw->extra_tx_headroom = 0;
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
@@ -1629,6 +1628,7 @@ static const struct rt2x00_ops rt2400pci_ops = {
 	.eeprom_size		= EEPROM_SIZE,
 	.rf_size		= RF_SIZE,
 	.tx_queues		= NUM_TX_QUEUES,
+	.extra_tx_headroom	= 0,
 	.rx			= &rt2400pci_queue_rx,
 	.tx			= &rt2400pci_queue_tx,
 	.bcn			= &rt2400pci_queue_bcn,
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 30960fd..408fcfc 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1733,8 +1733,6 @@ static int rt2500pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 			       IEEE80211_HW_SUPPORTS_PS |
 			       IEEE80211_HW_PS_NULLFUNC_STACK;
 
-	rt2x00dev->hw->extra_tx_headroom = 0;
-
 	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
 				rt2x00_eeprom_addr(rt2x00dev,
@@ -1928,6 +1926,7 @@ static const struct rt2x00_ops rt2500pci_ops = {
 	.eeprom_size		= EEPROM_SIZE,
 	.rf_size		= RF_SIZE,
 	.tx_queues		= NUM_TX_QUEUES,
+	.extra_tx_headroom	= 0,
 	.rx			= &rt2500pci_queue_rx,
 	.tx			= &rt2500pci_queue_tx,
 	.bcn			= &rt2500pci_queue_bcn,
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 02290f6..83f2592 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1656,8 +1656,6 @@ static int rt2500usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	    IEEE80211_HW_SUPPORTS_PS |
 	    IEEE80211_HW_PS_NULLFUNC_STACK;
 
-	rt2x00dev->hw->extra_tx_headroom = TXD_DESC_SIZE;
-
 	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
 				rt2x00_eeprom_addr(rt2x00dev,
@@ -1829,6 +1827,7 @@ static const struct rt2x00_ops rt2500usb_ops = {
 	.eeprom_size		= EEPROM_SIZE,
 	.rf_size		= RF_SIZE,
 	.tx_queues		= NUM_TX_QUEUES,
+	.extra_tx_headroom	= TXD_DESC_SIZE,
 	.rx			= &rt2500usb_queue_rx,
 	.tx			= &rt2500usb_queue_tx,
 	.bcn			= &rt2500usb_queue_bcn,
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 02ffcf5..eb1e1d0 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2030,12 +2030,6 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	    IEEE80211_HW_SUPPORTS_PS |
 	    IEEE80211_HW_PS_NULLFUNC_STACK;
 
-	if (rt2x00_intf_is_usb(rt2x00dev))
-		rt2x00dev->hw->extra_tx_headroom =
-			TXINFO_DESC_SIZE + TXWI_DESC_SIZE;
-	else if (rt2x00_intf_is_pci(rt2x00dev))
-		rt2x00dev->hw->extra_tx_headroom = TXWI_DESC_SIZE;
-
 	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
 				rt2x00_eeprom_addr(rt2x00dev,
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 029a45f..dfc886f 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -652,7 +652,7 @@ static void rt2800pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 {
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
 	__le32 *txd = skbdesc->desc;
-	__le32 *txwi = (__le32 *)(skb->data - rt2x00dev->hw->extra_tx_headroom);
+	__le32 *txwi = (__le32 *)(skb->data - rt2x00dev->ops->extra_tx_headroom);
 	u32 word;
 
 	/*
@@ -725,14 +725,14 @@ static void rt2800pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W1_BURST,
 			   test_bit(ENTRY_TXD_BURST, &txdesc->flags));
 	rt2x00_set_field32(&word, TXD_W1_SD_LEN0,
-			   rt2x00dev->hw->extra_tx_headroom);
+			   rt2x00dev->ops->extra_tx_headroom);
 	rt2x00_set_field32(&word, TXD_W1_LAST_SEC0, 0);
 	rt2x00_set_field32(&word, TXD_W1_DMA_DONE, 0);
 	rt2x00_desc_write(txd, 1, word);
 
 	rt2x00_desc_read(txd, 2, &word);
 	rt2x00_set_field32(&word, TXD_W2_SD_PTR1,
-			   skbdesc->skb_dma + rt2x00dev->hw->extra_tx_headroom);
+			   skbdesc->skb_dma + rt2x00dev->ops->extra_tx_headroom);
 	rt2x00_desc_write(txd, 2, word);
 
 	rt2x00_desc_read(txd, 3, &word);
@@ -1207,6 +1207,7 @@ static const struct rt2x00_ops rt2800pci_ops = {
 	.eeprom_size		= EEPROM_SIZE,
 	.rf_size		= RF_SIZE,
 	.tx_queues		= NUM_TX_QUEUES,
+	.extra_tx_headroom	= TXWI_DESC_SIZE,
 	.rx			= &rt2800pci_queue_rx,
 	.tx			= &rt2800pci_queue_tx,
 	.bcn			= &rt2800pci_queue_bcn,
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 208316a..af85d18 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -796,6 +796,7 @@ static const struct rt2x00_ops rt2800usb_ops = {
 	.eeprom_size		= EEPROM_SIZE,
 	.rf_size		= RF_SIZE,
 	.tx_queues		= NUM_TX_QUEUES,
+	.extra_tx_headroom	= TXINFO_DESC_SIZE + TXWI_DESC_SIZE,
 	.rx			= &rt2800usb_queue_rx,
 	.tx			= &rt2800usb_queue_tx,
 	.bcn			= &rt2800usb_queue_bcn,
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 1cbb7ac..4d841c0 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -588,6 +588,7 @@ struct rt2x00_ops {
 	const unsigned int eeprom_size;
 	const unsigned int rf_size;
 	const unsigned int tx_queues;
+	const unsigned int extra_tx_headroom;
 	const struct data_queue_desc *rx;
 	const struct data_queue_desc *tx;
 	const struct data_queue_desc *bcn;
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 4a4b7e4..06c43ca 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -684,6 +684,11 @@ static int rt2x00lib_probe_hw(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->hw->queues = rt2x00dev->ops->tx_queues;
 
 	/*
+	 * Initialize extra TX headroom required.
+	 */
+	rt2x00dev->hw->extra_tx_headroom = rt2x00dev->ops->extra_tx_headroom;
+
+	/*
 	 * Register HW.
 	 */
 	status = ieee80211_register_hw(rt2x00dev->hw);
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 4cb9afe..687e17d 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2546,7 +2546,6 @@ static int rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	    IEEE80211_HW_SIGNAL_DBM |
 	    IEEE80211_HW_SUPPORTS_PS |
 	    IEEE80211_HW_PS_NULLFUNC_STACK;
-	rt2x00dev->hw->extra_tx_headroom = 0;
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
@@ -2794,6 +2793,7 @@ static const struct rt2x00_ops rt61pci_ops = {
 	.eeprom_size		= EEPROM_SIZE,
 	.rf_size		= RF_SIZE,
 	.tx_queues		= NUM_TX_QUEUES,
+	.extra_tx_headroom	= 0,
 	.rx			= &rt61pci_queue_rx,
 	.tx			= &rt61pci_queue_tx,
 	.bcn			= &rt61pci_queue_bcn,
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index d13a051..ced3b6a 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2069,7 +2069,6 @@ static int rt73usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	    IEEE80211_HW_SIGNAL_DBM |
 	    IEEE80211_HW_SUPPORTS_PS |
 	    IEEE80211_HW_PS_NULLFUNC_STACK;
-	rt2x00dev->hw->extra_tx_headroom = TXD_DESC_SIZE;
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
@@ -2312,6 +2311,7 @@ static const struct rt2x00_ops rt73usb_ops = {
 	.eeprom_size		= EEPROM_SIZE,
 	.rf_size		= RF_SIZE,
 	.tx_queues		= NUM_TX_QUEUES,
+	.extra_tx_headroom	= TXD_DESC_SIZE,
 	.rx			= &rt73usb_queue_rx,
 	.tx			= &rt73usb_queue_tx,
 	.bcn			= &rt73usb_queue_bcn,
-- 
1.6.5.3

