Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:33329 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184AbYGKT4e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jul 2008 15:56:34 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: linux-wireless@vger.kernel.org
Subject: [RFC] Merge tx/rx descriptor flags of rtl818x devices
Date: Fri, 11 Jul 2008 16:56:39 -0300
Cc: Andrea Merello <andreamrl@tiscali.it>,
	Michael Wu <flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200807111656.40342.herton@mandriva.com.br> (sfid-20080711_215644_047676_DC398573)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

In rtl818x code tx/rx descriptor flags are common between all devices as far
as I could check (looking at r8180 specs I found on the web recently and on
vendor rtl8187b driver). Here is a proposal for merging them:
_________

rtl818x: merge tx/rx descriptor flags

Tx/Rx descriptor flags are common between rtl818x devices, only with
additions for newer chips, thus use same flags in the code.

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
---
 drivers/net/wireless/rtl8180.h     |   31 -------------------------------
 drivers/net/wireless/rtl8180_dev.c |   34 +++++++++++++++++-----------------
 drivers/net/wireless/rtl8187.h     |    6 ------
 drivers/net/wireless/rtl8187_dev.c |   10 +++++-----
 drivers/net/wireless/rtl818x.h     |   35 +++++++++++++++++++++++++++++++++++
 5 files changed, 57 insertions(+), 59 deletions(-)

diff --git a/drivers/net/wireless/rtl8180.h b/drivers/net/wireless/rtl8180.h
index 082a11f..8721282 100644
--- a/drivers/net/wireless/rtl8180.h
+++ b/drivers/net/wireless/rtl8180.h
@@ -24,20 +24,6 @@
 #define ANAPARAM_PWR1_SHIFT	20
 #define ANAPARAM_PWR1_MASK	(0x7F << ANAPARAM_PWR1_SHIFT)
 
-enum rtl8180_tx_desc_flags {
-	RTL8180_TX_DESC_FLAG_NO_ENC	= (1 << 15),
-	RTL8180_TX_DESC_FLAG_TX_OK	= (1 << 15),
-	RTL8180_TX_DESC_FLAG_SPLCP	= (1 << 16),
-	RTL8180_TX_DESC_FLAG_RX_UNDER	= (1 << 16),
-	RTL8180_TX_DESC_FLAG_MOREFRAG	= (1 << 17),
-	RTL8180_TX_DESC_FLAG_CTS	= (1 << 18),
-	RTL8180_TX_DESC_FLAG_RTS	= (1 << 23),
-	RTL8180_TX_DESC_FLAG_LS		= (1 << 28),
-	RTL8180_TX_DESC_FLAG_FS		= (1 << 29),
-	RTL8180_TX_DESC_FLAG_DMA	= (1 << 30),
-	RTL8180_TX_DESC_FLAG_OWN	= (1 << 31)
-};
-
 struct rtl8180_tx_desc {
 	__le32 flags;
 	__le16 rts_duration;
@@ -52,23 +38,6 @@ struct rtl8180_tx_desc {
 	u32 reserved[2];
 } __attribute__ ((packed));
 
-enum rtl8180_rx_desc_flags {
-	RTL8180_RX_DESC_FLAG_ICV_ERR	= (1 << 12),
-	RTL8180_RX_DESC_FLAG_CRC32_ERR	= (1 << 13),
-	RTL8180_RX_DESC_FLAG_PM		= (1 << 14),
-	RTL8180_RX_DESC_FLAG_RX_ERR	= (1 << 15),
-	RTL8180_RX_DESC_FLAG_BCAST	= (1 << 16),
-	RTL8180_RX_DESC_FLAG_PAM	= (1 << 17),
-	RTL8180_RX_DESC_FLAG_MCAST	= (1 << 18),
-	RTL8180_RX_DESC_FLAG_SPLCP	= (1 << 25),
-	RTL8180_RX_DESC_FLAG_FOF	= (1 << 26),
-	RTL8180_RX_DESC_FLAG_DMA_FAIL	= (1 << 27),
-	RTL8180_RX_DESC_FLAG_LS		= (1 << 28),
-	RTL8180_RX_DESC_FLAG_FS		= (1 << 29),
-	RTL8180_RX_DESC_FLAG_EOR	= (1 << 30),
-	RTL8180_RX_DESC_FLAG_OWN	= (1 << 31)
-};
-
 struct rtl8180_rx_desc {
 	__le32 flags;
 	__le32 flags2;
diff --git a/drivers/net/wireless/rtl8180_dev.c b/drivers/net/wireless/rtl8180_dev.c
index b7172a1..861c76a 100644
--- a/drivers/net/wireless/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl8180_dev.c
@@ -110,12 +110,12 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
 		struct sk_buff *skb = priv->rx_buf[priv->rx_idx];
 		u32 flags = le32_to_cpu(entry->flags);
 
-		if (flags & RTL8180_RX_DESC_FLAG_OWN)
+		if (flags & RTL818X_RX_DESC_FLAG_OWN)
 			return;
 
-		if (unlikely(flags & (RTL8180_RX_DESC_FLAG_DMA_FAIL |
-				      RTL8180_RX_DESC_FLAG_FOF |
-				      RTL8180_RX_DESC_FLAG_RX_ERR)))
+		if (unlikely(flags & (RTL818X_RX_DESC_FLAG_DMA_FAIL |
+				      RTL818X_RX_DESC_FLAG_FOF |
+				      RTL818X_RX_DESC_FLAG_RX_ERR)))
 			goto done;
 		else {
 			u32 flags2 = le32_to_cpu(entry->flags2);
@@ -140,7 +140,7 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
 			rx_status.band = dev->conf.channel->band;
 			rx_status.mactime = le64_to_cpu(entry->tsft);
 			rx_status.flag |= RX_FLAG_TSFT;
-			if (flags & RTL8180_RX_DESC_FLAG_CRC32_ERR)
+			if (flags & RTL818X_RX_DESC_FLAG_CRC32_ERR)
 				rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;
 
 			ieee80211_rx_irqsafe(dev, skb, &rx_status);
@@ -154,10 +154,10 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
 
 	done:
 		entry->rx_buf = cpu_to_le32(*((dma_addr_t *)skb->cb));
-		entry->flags = cpu_to_le32(RTL8180_RX_DESC_FLAG_OWN |
+		entry->flags = cpu_to_le32(RTL818X_RX_DESC_FLAG_OWN |
 					   MAX_RX_SIZE);
 		if (priv->rx_idx == 31)
-			entry->flags |= cpu_to_le32(RTL8180_RX_DESC_FLAG_EOR);
+			entry->flags |= cpu_to_le32(RTL818X_RX_DESC_FLAG_EOR);
 		priv->rx_idx = (priv->rx_idx + 1) % 32;
 	}
 }
@@ -173,7 +173,7 @@ static void rtl8180_handle_tx(struct ieee80211_hw *dev, unsigned int prio)
 		struct ieee80211_tx_info *info;
 		u32 flags = le32_to_cpu(entry->flags);
 
-		if (flags & RTL8180_TX_DESC_FLAG_OWN)
+		if (flags & RTL818X_TX_DESC_FLAG_OWN)
 			return;
 
 		ring->idx = (ring->idx + 1) % ring->entries;
@@ -185,7 +185,7 @@ static void rtl8180_handle_tx(struct ieee80211_hw *dev, unsigned int prio)
 		memset(&info->status, 0, sizeof(info->status));
 
 		if (!(info->flags & IEEE80211_TX_CTL_NO_ACK)) {
-			if (flags & RTL8180_TX_DESC_FLAG_TX_OK)
+			if (flags & RTL818X_TX_DESC_FLAG_TX_OK)
 				info->flags |= IEEE80211_TX_STAT_ACK;
 			else
 				info->status.excessive_retries = 1;
@@ -252,20 +252,20 @@ static int rtl8180_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 	mapping = pci_map_single(priv->pdev, skb->data,
 				 skb->len, PCI_DMA_TODEVICE);
 
-	tx_flags = RTL8180_TX_DESC_FLAG_OWN | RTL8180_TX_DESC_FLAG_FS |
-		   RTL8180_TX_DESC_FLAG_LS |
+	tx_flags = RTL818X_TX_DESC_FLAG_OWN | RTL818X_TX_DESC_FLAG_FS |
+		   RTL818X_TX_DESC_FLAG_LS |
 		   (ieee80211_get_tx_rate(dev, info)->hw_value << 24) |
 		   skb->len;
 
 	if (priv->r8185)
-		tx_flags |= RTL8180_TX_DESC_FLAG_DMA |
-			    RTL8180_TX_DESC_FLAG_NO_ENC;
+		tx_flags |= RTL818X_TX_DESC_FLAG_DMA |
+			    RTL818X_TX_DESC_FLAG_NO_ENC;
 
 	if (info->flags & IEEE80211_TX_CTL_USE_RTS_CTS) {
-		tx_flags |= RTL8180_TX_DESC_FLAG_RTS;
+		tx_flags |= RTL818X_TX_DESC_FLAG_RTS;
 		tx_flags |= ieee80211_get_rts_cts_rate(dev, info)->hw_value << 19;
 	} else if (info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT) {
-		tx_flags |= RTL8180_TX_DESC_FLAG_CTS;
+		tx_flags |= RTL818X_TX_DESC_FLAG_CTS;
 		tx_flags |= ieee80211_get_rts_cts_rate(dev, info)->hw_value << 19;
 	}
 
@@ -446,10 +446,10 @@ static int rtl8180_init_rx_ring(struct ieee80211_hw *dev)
 		*mapping = pci_map_single(priv->pdev, skb_tail_pointer(skb),
 					  MAX_RX_SIZE, PCI_DMA_FROMDEVICE);
 		entry->rx_buf = cpu_to_le32(*mapping);
-		entry->flags = cpu_to_le32(RTL8180_RX_DESC_FLAG_OWN |
+		entry->flags = cpu_to_le32(RTL818X_RX_DESC_FLAG_OWN |
 					   MAX_RX_SIZE);
 	}
-	entry->flags |= cpu_to_le32(RTL8180_RX_DESC_FLAG_EOR);
+	entry->flags |= cpu_to_le32(RTL818X_RX_DESC_FLAG_EOR);
 	return 0;
 }
 
diff --git a/drivers/net/wireless/rtl8187.h b/drivers/net/wireless/rtl8187.h
index 3afb49f..1f01eed 100644
--- a/drivers/net/wireless/rtl8187.h
+++ b/drivers/net/wireless/rtl8187.h
@@ -56,12 +56,6 @@ struct rtl8187b_rx_hdr {
 
 /* {rtl8187,rtl8187b}_tx_info is in skb */
 
-/* Tx flags are common between rtl8187 and rtl8187b */
-#define RTL8187_TX_FLAG_NO_ENCRYPT	(1 << 15)
-#define RTL8187_TX_FLAG_MORE_FRAG	(1 << 17)
-#define RTL8187_TX_FLAG_CTS		(1 << 18)
-#define RTL8187_TX_FLAG_RTS		(1 << 23)
-
 struct rtl8187_tx_hdr {
 	__le32 flags;
 	__le16 rts_duration;
diff --git a/drivers/net/wireless/rtl8187_dev.c b/drivers/net/wireless/rtl8187_dev.c
index 25d9a0e..217098b 100644
--- a/drivers/net/wireless/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl8187_dev.c
@@ -183,18 +183,18 @@ static int rtl8187_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 	}
 
 	flags = skb->len;
-	flags |= RTL8187_TX_FLAG_NO_ENCRYPT;
+	flags |= RTL818X_TX_DESC_FLAG_NO_ENC;
 
 	flags |= ieee80211_get_tx_rate(dev, info)->hw_value << 24;
 	if (ieee80211_has_morefrags(((struct ieee80211_hdr *)skb->data)->frame_control))
-		flags |= RTL8187_TX_FLAG_MORE_FRAG;
+		flags |= RTL818X_TX_DESC_FLAG_MOREFRAG;
 	if (info->flags & IEEE80211_TX_CTL_USE_RTS_CTS) {
-		flags |= RTL8187_TX_FLAG_RTS;
+		flags |= RTL818X_TX_DESC_FLAG_RTS;
 		flags |= ieee80211_get_rts_cts_rate(dev, info)->hw_value << 19;
 		rts_dur = ieee80211_rts_duration(dev, priv->vif,
 						 skb->len, info);
 	} else if (info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT) {
-		flags |= RTL8187_TX_FLAG_CTS;
+		flags |= RTL818X_TX_DESC_FLAG_CTS;
 		flags |= ieee80211_get_rts_cts_rate(dev, info)->hw_value << 19;
 	}
 
@@ -322,7 +322,7 @@ static void rtl8187_rx_cb(struct urb *urb)
 	rx_status.freq = dev->conf.channel->center_freq;
 	rx_status.band = dev->conf.channel->band;
 	rx_status.flag |= RX_FLAG_TSFT;
-	if (flags & (1 << 13))
+	if (flags & RTL818X_RX_DESC_FLAG_CRC32_ERR)
 		rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;
 	ieee80211_rx_irqsafe(dev, skb, &rx_status);
 
diff --git a/drivers/net/wireless/rtl818x.h b/drivers/net/wireless/rtl818x.h
index 00900fe..3538b15 100644
--- a/drivers/net/wireless/rtl818x.h
+++ b/drivers/net/wireless/rtl818x.h
@@ -193,4 +193,39 @@ struct rtl818x_rf_ops {
 	void (*set_chan)(struct ieee80211_hw *, struct ieee80211_conf *);
 };
 
+/* Tx/Rx flags are common between RTL818X chips */
+
+enum rtl818x_tx_desc_flags {
+	RTL818X_TX_DESC_FLAG_NO_ENC	= (1 << 15),
+	RTL818X_TX_DESC_FLAG_TX_OK	= (1 << 15),
+	RTL818X_TX_DESC_FLAG_SPLCP	= (1 << 16),
+	RTL818X_TX_DESC_FLAG_RX_UNDER	= (1 << 16),
+	RTL818X_TX_DESC_FLAG_MOREFRAG	= (1 << 17),
+	RTL818X_TX_DESC_FLAG_CTS	= (1 << 18),
+	RTL818X_TX_DESC_FLAG_RTS	= (1 << 23),
+	RTL818X_TX_DESC_FLAG_LS		= (1 << 28),
+	RTL818X_TX_DESC_FLAG_FS		= (1 << 29),
+	RTL818X_TX_DESC_FLAG_DMA	= (1 << 30),
+	RTL818X_TX_DESC_FLAG_OWN	= (1 << 31)
+};
+
+enum rtl818x_rx_desc_flags {
+	RTL818X_RX_DESC_FLAG_ICV_ERR	= (1 << 12),
+	RTL818X_RX_DESC_FLAG_CRC32_ERR	= (1 << 13),
+	RTL818X_RX_DESC_FLAG_PM		= (1 << 14),
+	RTL818X_RX_DESC_FLAG_RX_ERR	= (1 << 15),
+	RTL818X_RX_DESC_FLAG_BCAST	= (1 << 16),
+	RTL818X_RX_DESC_FLAG_PAM	= (1 << 17),
+	RTL818X_RX_DESC_FLAG_MCAST	= (1 << 18),
+	RTL818X_RX_DESC_FLAG_QOS	= (1 << 19), /* RTL8187(B) only */
+	RTL818X_RX_DESC_FLAG_TRSW	= (1 << 24), /* RTL8187(B) only */
+	RTL818X_RX_DESC_FLAG_SPLCP	= (1 << 25),
+	RTL818X_RX_DESC_FLAG_FOF	= (1 << 26),
+	RTL818X_RX_DESC_FLAG_DMA_FAIL	= (1 << 27),
+	RTL818X_RX_DESC_FLAG_LS		= (1 << 28),
+	RTL818X_RX_DESC_FLAG_FS		= (1 << 29),
+	RTL818X_RX_DESC_FLAG_EOR	= (1 << 30),
+	RTL818X_RX_DESC_FLAG_OWN	= (1 << 31)
+};
+
 #endif /* RTL818X_H */
-- 
1.5.6



-- 
[]'s
Herton
