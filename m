Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp126.mail.ukl.yahoo.com ([77.238.184.57]:48842 "HELO
	smtp126.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933289AbZJFWIY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 18:08:24 -0400
From: Albert Herranz <albert_herranz@yahoo.es>
To: bcm43xx-dev@lists.berlios.de, mb@bu3sch.de
Cc: linux-wireless@vger.kernel.org,
	Albert Herranz <albert_herranz@yahoo.es>
Subject: [PATCH v2] b43: do not stack-allocate pio rx/tx header and tail buffers
Date: Wed,  7 Oct 2009 00:07:44 +0200
Message-Id: <1254866864-18265-1-git-send-email-albert_herranz@yahoo.es>
In-Reply-To: <200910062252.17565.mb@bu3sch.de>
References: <200910062252.17565.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The DMA-API debugging facility complains about b43 mapping memory from
stack for SDIO-based cards.

Indeed, b43 currently allocates the PIO RX/TX header and tail buffers
from stack. The solution here is to use heap-allocated buffers instead.

Signed-off-by: Albert Herranz <albert_herranz@yahoo.es>
---
v2
- embed buffers into struct b43_wl, and make them depend on CONFIG_B43_PIO
- take into account tail buffers for unaligned length transfers

 drivers/net/wireless/b43/b43.h  |  168 +++++++++++++++++++++------------------
 drivers/net/wireless/b43/pio.c  |   78 +++++++++---------
 drivers/net/wireless/b43/xmit.c |    2 +-
 3 files changed, 132 insertions(+), 116 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index fa1549a..6607162 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -607,82 +607,7 @@ struct b43_qos_params {
 	struct ieee80211_tx_queue_params p;
 };
 
-struct b43_wldev;
-
-/* Data structure for the WLAN parts (802.11 cores) of the b43 chip. */
-struct b43_wl {
-	/* Pointer to the active wireless device on this chip */
-	struct b43_wldev *current_dev;
-	/* Pointer to the ieee80211 hardware data structure */
-	struct ieee80211_hw *hw;
-
-	/* Global driver mutex. Every operation must run with this mutex locked. */
-	struct mutex mutex;
-	/* Hard-IRQ spinlock. This lock protects things used in the hard-IRQ
-	 * handler, only. This basically is just the IRQ mask register. */
-	spinlock_t hardirq_lock;
-
-	/* The number of queues that were registered with the mac80211 subsystem
-	 * initially. This is a backup copy of hw->queues in case hw->queues has
-	 * to be dynamically lowered at runtime (Firmware does not support QoS).
-	 * hw->queues has to be restored to the original value before unregistering
-	 * from the mac80211 subsystem. */
-	u16 mac80211_initially_registered_queues;
-
-	/* We can only have one operating interface (802.11 core)
-	 * at a time. General information about this interface follows.
-	 */
-
-	struct ieee80211_vif *vif;
-	/* The MAC address of the operating interface. */
-	u8 mac_addr[ETH_ALEN];
-	/* Current BSSID */
-	u8 bssid[ETH_ALEN];
-	/* Interface type. (NL80211_IFTYPE_XXX) */
-	int if_type;
-	/* Is the card operating in AP, STA or IBSS mode? */
-	bool operating;
-	/* filter flags */
-	unsigned int filter_flags;
-	/* Stats about the wireless interface */
-	struct ieee80211_low_level_stats ieee_stats;
-
-#ifdef CONFIG_B43_HWRNG
-	struct hwrng rng;
-	bool rng_initialized;
-	char rng_name[30 + 1];
-#endif /* CONFIG_B43_HWRNG */
-
-	/* List of all wireless devices on this chip */
-	struct list_head devlist;
-	u8 nr_devs;
-
-	bool radiotap_enabled;
-	bool radio_enabled;
-
-	/* The beacon we are currently using (AP or IBSS mode). */
-	struct sk_buff *current_beacon;
-	bool beacon0_uploaded;
-	bool beacon1_uploaded;
-	bool beacon_templates_virgin; /* Never wrote the templates? */
-	struct work_struct beacon_update_trigger;
-
-	/* The current QOS parameters for the 4 queues. */
-	struct b43_qos_params qos_params[4];
-
-	/* Work for adjustment of the transmission power.
-	 * This is scheduled when we determine that the actual TX output
-	 * power doesn't match what we want. */
-	struct work_struct txpower_adjust_work;
-
-	/* Packet transmit work */
-	struct work_struct tx_work;
-	/* Queue of packets to be transmitted. */
-	struct sk_buff_head tx_queue;
-
-	/* The device LEDs. */
-	struct b43_leds leds;
-};
+struct b43_wl;
 
 /* The type of the firmware file. */
 enum b43_firmware_file_type {
@@ -824,6 +749,97 @@ struct b43_wldev {
 #endif
 };
 
+/*
+ * Include goes here to avoid a dependency problem.
+ * A better fix would be to integrate xmit.h into b43.h.
+ */
+#include "xmit.h"
+
+/* Data structure for the WLAN parts (802.11 cores) of the b43 chip. */
+struct b43_wl {
+	/* Pointer to the active wireless device on this chip */
+	struct b43_wldev *current_dev;
+	/* Pointer to the ieee80211 hardware data structure */
+	struct ieee80211_hw *hw;
+
+	/* Global driver mutex. Every operation must run with this mutex locked. */
+	struct mutex mutex;
+	/* Hard-IRQ spinlock. This lock protects things used in the hard-IRQ
+	 * handler, only. This basically is just the IRQ mask register. */
+	spinlock_t hardirq_lock;
+
+	/* The number of queues that were registered with the mac80211 subsystem
+	 * initially. This is a backup copy of hw->queues in case hw->queues has
+	 * to be dynamically lowered at runtime (Firmware does not support QoS).
+	 * hw->queues has to be restored to the original value before unregistering
+	 * from the mac80211 subsystem. */
+	u16 mac80211_initially_registered_queues;
+
+	/* We can only have one operating interface (802.11 core)
+	 * at a time. General information about this interface follows.
+	 */
+
+	struct ieee80211_vif *vif;
+	/* The MAC address of the operating interface. */
+	u8 mac_addr[ETH_ALEN];
+	/* Current BSSID */
+	u8 bssid[ETH_ALEN];
+	/* Interface type. (NL80211_IFTYPE_XXX) */
+	int if_type;
+	/* Is the card operating in AP, STA or IBSS mode? */
+	bool operating;
+	/* filter flags */
+	unsigned int filter_flags;
+	/* Stats about the wireless interface */
+	struct ieee80211_low_level_stats ieee_stats;
+
+#ifdef CONFIG_B43_HWRNG
+	struct hwrng rng;
+	bool rng_initialized;
+	char rng_name[30 + 1];
+#endif /* CONFIG_B43_HWRNG */
+
+	/* List of all wireless devices on this chip */
+	struct list_head devlist;
+	u8 nr_devs;
+
+	bool radiotap_enabled;
+	bool radio_enabled;
+
+	/* The beacon we are currently using (AP or IBSS mode). */
+	struct sk_buff *current_beacon;
+	bool beacon0_uploaded;
+	bool beacon1_uploaded;
+	bool beacon_templates_virgin; /* Never wrote the templates? */
+	struct work_struct beacon_update_trigger;
+
+	/* The current QOS parameters for the 4 queues. */
+	struct b43_qos_params qos_params[4];
+
+	/* Work for adjustment of the transmission power.
+	 * This is scheduled when we determine that the actual TX output
+	 * power doesn't match what we want. */
+	struct work_struct txpower_adjust_work;
+
+	/* Packet transmit work */
+	struct work_struct tx_work;
+	/* Queue of packets to be transmitted. */
+	struct sk_buff_head tx_queue;
+
+	/* The device LEDs. */
+	struct b43_leds leds;
+
+#ifdef CONFIG_B43_PIO
+	/*
+	 * RX/TX header/tail buffers used by the frame transmit functions.
+	 */
+	struct b43_rxhdr_fw4 rxhdr;
+	struct b43_txhdr txhdr;
+	u8 rx_tail[4];
+	u8 tx_tail[4];
+#endif /* CONFIG_B43_PIO */
+};
+
 static inline struct b43_wl *hw_to_b43_wl(struct ieee80211_hw *hw)
 {
 	return hw->priv;
diff --git a/drivers/net/wireless/b43/pio.c b/drivers/net/wireless/b43/pio.c
index 9c13979..dbbf0d1 100644
--- a/drivers/net/wireless/b43/pio.c
+++ b/drivers/net/wireless/b43/pio.c
@@ -331,6 +331,7 @@ static u16 tx_write_2byte_queue(struct b43_pio_txqueue *q,
 				unsigned int data_len)
 {
 	struct b43_wldev *dev = q->dev;
+	struct b43_wl *wl = dev->wl;
 	const u8 *data = _data;
 
 	ctl |= B43_PIO_TXCTL_WRITELO | B43_PIO_TXCTL_WRITEHI;
@@ -340,13 +341,12 @@ static u16 tx_write_2byte_queue(struct b43_pio_txqueue *q,
 			q->mmio_base + B43_PIO_TXDATA,
 			sizeof(u16));
 	if (data_len & 1) {
-		u8 tail[2] = { 0, };
-
 		/* Write the last byte. */
 		ctl &= ~B43_PIO_TXCTL_WRITEHI;
 		b43_piotx_write16(q, B43_PIO_TXCTL, ctl);
-		tail[0] = data[data_len - 1];
-		ssb_block_write(dev->dev, tail, 2,
+		wl->tx_tail[0] = data[data_len - 1];
+		wl->tx_tail[1] = 0;
+		ssb_block_write(dev->dev, wl->tx_tail, 2,
 				q->mmio_base + B43_PIO_TXDATA,
 				sizeof(u16));
 	}
@@ -381,6 +381,7 @@ static u32 tx_write_4byte_queue(struct b43_pio_txqueue *q,
 				unsigned int data_len)
 {
 	struct b43_wldev *dev = q->dev;
+	struct b43_wl *wl = dev->wl;
 	const u8 *data = _data;
 
 	ctl |= B43_PIO8_TXCTL_0_7 | B43_PIO8_TXCTL_8_15 |
@@ -391,29 +392,31 @@ static u32 tx_write_4byte_queue(struct b43_pio_txqueue *q,
 			q->mmio_base + B43_PIO8_TXDATA,
 			sizeof(u32));
 	if (data_len & 3) {
-		u8 tail[4] = { 0, };
-
+		wl->tx_tail[3] = 0;
 		/* Write the last few bytes. */
 		ctl &= ~(B43_PIO8_TXCTL_8_15 | B43_PIO8_TXCTL_16_23 |
 			 B43_PIO8_TXCTL_24_31);
 		switch (data_len & 3) {
 		case 3:
 			ctl |= B43_PIO8_TXCTL_16_23 | B43_PIO8_TXCTL_8_15;
-			tail[0] = data[data_len - 3];
-			tail[1] = data[data_len - 2];
-			tail[2] = data[data_len - 1];
+			wl->tx_tail[0] = data[data_len - 3];
+			wl->tx_tail[1] = data[data_len - 2];
+			wl->tx_tail[2] = data[data_len - 1];
 			break;
 		case 2:
 			ctl |= B43_PIO8_TXCTL_8_15;
-			tail[0] = data[data_len - 2];
-			tail[1] = data[data_len - 1];
+			wl->tx_tail[0] = data[data_len - 2];
+			wl->tx_tail[1] = data[data_len - 1];
+			wl->tx_tail[2] = 0;
 			break;
 		case 1:
-			tail[0] = data[data_len - 1];
+			wl->tx_tail[0] = data[data_len - 1];
+			wl->tx_tail[1] = 0;
+			wl->tx_tail[2] = 0;
 			break;
 		}
 		b43_piotx_write32(q, B43_PIO8_TXCTL, ctl);
-		ssb_block_write(dev->dev, tail, 4,
+		ssb_block_write(dev->dev, wl->tx_tail, 4,
 				q->mmio_base + B43_PIO8_TXDATA,
 				sizeof(u32));
 	}
@@ -445,8 +448,9 @@ static void pio_tx_frame_4byte_queue(struct b43_pio_txpacket *pack,
 static int pio_tx_frame(struct b43_pio_txqueue *q,
 			struct sk_buff *skb)
 {
+	struct b43_wldev *dev = q->dev;
+	struct b43_wl *wl = dev->wl;
 	struct b43_pio_txpacket *pack;
-	struct b43_txhdr txhdr;
 	u16 cookie;
 	int err;
 	unsigned int hdrlen;
@@ -457,8 +461,8 @@ static int pio_tx_frame(struct b43_pio_txqueue *q,
 			  struct b43_pio_txpacket, list);
 
 	cookie = generate_cookie(q, pack);
-	hdrlen = b43_txhdr_size(q->dev);
-	err = b43_generate_txhdr(q->dev, (u8 *)&txhdr, skb,
+	hdrlen = b43_txhdr_size(dev);
+	err = b43_generate_txhdr(dev, (u8 *)&wl->txhdr, skb,
 				 info, cookie);
 	if (err)
 		return err;
@@ -466,15 +470,15 @@ static int pio_tx_frame(struct b43_pio_txqueue *q,
 	if (info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) {
 		/* Tell the firmware about the cookie of the last
 		 * mcast frame, so it can clear the more-data bit in it. */
-		b43_shm_write16(q->dev, B43_SHM_SHARED,
+		b43_shm_write16(dev, B43_SHM_SHARED,
 				B43_SHM_SH_MCASTCOOKIE, cookie);
 	}
 
 	pack->skb = skb;
 	if (q->rev >= 8)
-		pio_tx_frame_4byte_queue(pack, (const u8 *)&txhdr, hdrlen);
+		pio_tx_frame_4byte_queue(pack, (const u8 *)&wl->txhdr, hdrlen);
 	else
-		pio_tx_frame_2byte_queue(pack, (const u8 *)&txhdr, hdrlen);
+		pio_tx_frame_2byte_queue(pack, (const u8 *)&wl->txhdr, hdrlen);
 
 	/* Remove it from the list of available packet slots.
 	 * It will be put back when we receive the status report. */
@@ -614,14 +618,14 @@ void b43_pio_get_tx_stats(struct b43_wldev *dev,
 static bool pio_rx_frame(struct b43_pio_rxqueue *q)
 {
 	struct b43_wldev *dev = q->dev;
-	struct b43_rxhdr_fw4 rxhdr;
+	struct b43_wl *wl = dev->wl;
 	u16 len;
 	u32 macstat;
 	unsigned int i, padding;
 	struct sk_buff *skb;
 	const char *err_msg = NULL;
 
-	memset(&rxhdr, 0, sizeof(rxhdr));
+	memset(&wl->rxhdr, 0, sizeof(wl->rxhdr));
 
 	/* Check if we have data and wait for it to get ready. */
 	if (q->rev >= 8) {
@@ -659,16 +663,16 @@ data_ready:
 
 	/* Get the preamble (RX header) */
 	if (q->rev >= 8) {
-		ssb_block_read(dev->dev, &rxhdr, sizeof(rxhdr),
+		ssb_block_read(dev->dev, &wl->rxhdr, sizeof(wl->rxhdr),
 			       q->mmio_base + B43_PIO8_RXDATA,
 			       sizeof(u32));
 	} else {
-		ssb_block_read(dev->dev, &rxhdr, sizeof(rxhdr),
+		ssb_block_read(dev->dev, &wl->rxhdr, sizeof(wl->rxhdr),
 			       q->mmio_base + B43_PIO_RXDATA,
 			       sizeof(u16));
 	}
 	/* Sanity checks. */
-	len = le16_to_cpu(rxhdr.frame_len);
+	len = le16_to_cpu(wl->rxhdr.frame_len);
 	if (unlikely(len > 0x700)) {
 		err_msg = "len > 0x700";
 		goto rx_error;
@@ -678,7 +682,7 @@ data_ready:
 		goto rx_error;
 	}
 
-	macstat = le32_to_cpu(rxhdr.mac_status);
+	macstat = le32_to_cpu(wl->rxhdr.mac_status);
 	if (macstat & B43_RX_MAC_FCSERR) {
 		if (!(q->dev->wl->filter_flags & FIF_FCSFAIL)) {
 			/* Drop frames with failed FCS. */
@@ -703,24 +707,22 @@ data_ready:
 			       q->mmio_base + B43_PIO8_RXDATA,
 			       sizeof(u32));
 		if (len & 3) {
-			u8 tail[4] = { 0, };
-
 			/* Read the last few bytes. */
-			ssb_block_read(dev->dev, tail, 4,
+			ssb_block_read(dev->dev, wl->rx_tail, 4,
 				       q->mmio_base + B43_PIO8_RXDATA,
 				       sizeof(u32));
 			switch (len & 3) {
 			case 3:
-				skb->data[len + padding - 3] = tail[0];
-				skb->data[len + padding - 2] = tail[1];
-				skb->data[len + padding - 1] = tail[2];
+				skb->data[len + padding - 3] = wl->rx_tail[0];
+				skb->data[len + padding - 2] = wl->rx_tail[1];
+				skb->data[len + padding - 1] = wl->rx_tail[2];
 				break;
 			case 2:
-				skb->data[len + padding - 2] = tail[0];
-				skb->data[len + padding - 1] = tail[1];
+				skb->data[len + padding - 2] = wl->rx_tail[0];
+				skb->data[len + padding - 1] = wl->rx_tail[1];
 				break;
 			case 1:
-				skb->data[len + padding - 1] = tail[0];
+				skb->data[len + padding - 1] = wl->rx_tail[0];
 				break;
 			}
 		}
@@ -729,17 +731,15 @@ data_ready:
 			       q->mmio_base + B43_PIO_RXDATA,
 			       sizeof(u16));
 		if (len & 1) {
-			u8 tail[2] = { 0, };
-
 			/* Read the last byte. */
-			ssb_block_read(dev->dev, tail, 2,
+			ssb_block_read(dev->dev, wl->rx_tail, 2,
 				       q->mmio_base + B43_PIO_RXDATA,
 				       sizeof(u16));
-			skb->data[len + padding - 1] = tail[0];
+			skb->data[len + padding - 1] = wl->rx_tail[0];
 		}
 	}
 
-	b43_rx(q->dev, skb, &rxhdr);
+	b43_rx(q->dev, skb, &wl->rxhdr);
 
 	return 1;
 
diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
index ac9f600..892573b 100644
--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -27,7 +27,7 @@
 
 */
 
-#include "xmit.h"
+#include "b43.h"
 #include "phy_common.h"
 #include "dma.h"
 #include "pio.h"
-- 
1.6.0.4

