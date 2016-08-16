Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:38679 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932272AbcHPPS6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2016 11:18:58 -0400
Received: by mail-wm0-f47.google.com with SMTP id o80so175144375wme.1
        for <linux-wireless@vger.kernel.org>; Tue, 16 Aug 2016 08:18:57 -0700 (PDT)
From: Jakub Kicinski <jakub.kicinski@netronome.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
	gregkh@linuxfoundation.org, davem@davemloft.net,
	kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	dinan.gunawardena@netronome.com,
	Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCHv6 2/2] mt7601u: use linux/bitfield.h
Date: Tue, 16 Aug 2016 16:18:24 +0100
Message-Id: <1471360704-10507-3-git-send-email-jakub.kicinski@netronome.com> (sfid-20160816_171935_549985_64268A70)
In-Reply-To: <1471360704-10507-1-git-send-email-jakub.kicinski@netronome.com>
References: <1471360704-10507-1-git-send-email-jakub.kicinski@netronome.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the newly added linux/bitfield.h.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dinan Gunawardena <dinan.gunawardena@netronome.com>
---
 drivers/net/wireless/mediatek/mt7601u/dma.c     |  2 +-
 drivers/net/wireless/mediatek/mt7601u/dma.h     | 10 ++--
 drivers/net/wireless/mediatek/mt7601u/eeprom.c  | 12 ++--
 drivers/net/wireless/mediatek/mt7601u/init.c    |  9 +--
 drivers/net/wireless/mediatek/mt7601u/mac.c     | 38 ++++++------
 drivers/net/wireless/mediatek/mt7601u/mcu.c     | 18 +++---
 drivers/net/wireless/mediatek/mt7601u/mt7601u.h |  4 +-
 drivers/net/wireless/mediatek/mt7601u/phy.c     | 36 ++++++------
 drivers/net/wireless/mediatek/mt7601u/tx.c      | 16 ++---
 drivers/net/wireless/mediatek/mt7601u/util.h    | 77 -------------------------
 10 files changed, 72 insertions(+), 150 deletions(-)
 delete mode 100644 drivers/net/wireless/mediatek/mt7601u/util.h

diff --git a/drivers/net/wireless/mediatek/mt7601u/dma.c b/drivers/net/wireless/mediatek/mt7601u/dma.c
index 57a80cfa39b1..a8bc064bc14f 100644
--- a/drivers/net/wireless/mediatek/mt7601u/dma.c
+++ b/drivers/net/wireless/mediatek/mt7601u/dma.c
@@ -103,7 +103,7 @@ static void mt7601u_rx_process_seg(struct mt7601u_dev *dev, u8 *data,
 
 	if (unlikely(rxwi->zero[0] || rxwi->zero[1] || rxwi->zero[2]))
 		dev_err_once(dev->dev, "Error: RXWI zero fields are set\n");
-	if (unlikely(MT76_GET(MT_RXD_INFO_TYPE, fce_info)))
+	if (unlikely(FIELD_GET(MT_RXD_INFO_TYPE, fce_info)))
 		dev_err_once(dev->dev, "Error: RX path seen a non-pkt urb\n");
 
 	trace_mt_rx(dev, rxwi, fce_info);
diff --git a/drivers/net/wireless/mediatek/mt7601u/dma.h b/drivers/net/wireless/mediatek/mt7601u/dma.h
index 978e8a90b87f..46c6a7860c38 100644
--- a/drivers/net/wireless/mediatek/mt7601u/dma.h
+++ b/drivers/net/wireless/mediatek/mt7601u/dma.h
@@ -18,8 +18,6 @@
 #include <asm/unaligned.h>
 #include <linux/skbuff.h>
 
-#include "util.h"
-
 #define MT_DMA_HDR_LEN			4
 #define MT_RX_INFO_LEN			4
 #define MT_FCE_INFO_LEN			4
@@ -79,9 +77,9 @@ static inline int mt7601u_dma_skb_wrap(struct sk_buff *skb,
 	 */
 
 	info = flags |
-		MT76_SET(MT_TXD_INFO_LEN, round_up(skb->len, 4)) |
-		MT76_SET(MT_TXD_INFO_D_PORT, d_port) |
-		MT76_SET(MT_TXD_INFO_TYPE, type);
+		FIELD_PUT(MT_TXD_INFO_LEN, round_up(skb->len, 4)) |
+		FIELD_PUT(MT_TXD_INFO_D_PORT, d_port) |
+		FIELD_PUT(MT_TXD_INFO_TYPE, type);
 
 	put_unaligned_le32(info, skb_push(skb, sizeof(info)));
 	return skb_put_padto(skb, round_up(skb->len, 4) + 4);
@@ -90,7 +88,7 @@ static inline int mt7601u_dma_skb_wrap(struct sk_buff *skb,
 static inline int
 mt7601u_dma_skb_wrap_pkt(struct sk_buff *skb, enum mt76_qsel qsel, u32 flags)
 {
-	flags |= MT76_SET(MT_TXD_PKT_INFO_QSEL, qsel);
+	flags |= FIELD_PUT(MT_TXD_PKT_INFO_QSEL, qsel);
 	return mt7601u_dma_skb_wrap(skb, WLAN_PORT, DMA_PACKET, flags);
 }
 
diff --git a/drivers/net/wireless/mediatek/mt7601u/eeprom.c b/drivers/net/wireless/mediatek/mt7601u/eeprom.c
index 8d8ee0344f7b..14ac2c0f8838 100644
--- a/drivers/net/wireless/mediatek/mt7601u/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt7601u/eeprom.c
@@ -45,8 +45,8 @@ mt7601u_efuse_read(struct mt7601u_dev *dev, u16 addr, u8 *data,
 	val = mt76_rr(dev, MT_EFUSE_CTRL);
 	val &= ~(MT_EFUSE_CTRL_AIN |
 		 MT_EFUSE_CTRL_MODE);
-	val |= MT76_SET(MT_EFUSE_CTRL_AIN, addr & ~0xf) |
-	       MT76_SET(MT_EFUSE_CTRL_MODE, mode) |
+	val |= FIELD_PUT(MT_EFUSE_CTRL_AIN, addr & ~0xf) |
+	       FIELD_PUT(MT_EFUSE_CTRL_MODE, mode) |
 	       MT_EFUSE_CTRL_KICK;
 	mt76_wr(dev, MT_EFUSE_CTRL, val);
 
@@ -128,8 +128,8 @@ mt7601u_set_chip_cap(struct mt7601u_dev *dev, u8 *eeprom)
 	if (!field_valid(nic_conf0 >> 8))
 		return;
 
-	if (MT76_GET(MT_EE_NIC_CONF_0_RX_PATH, nic_conf0) > 1 ||
-	    MT76_GET(MT_EE_NIC_CONF_0_TX_PATH, nic_conf0) > 1)
+	if (FIELD_GET(MT_EE_NIC_CONF_0_RX_PATH, nic_conf0) > 1 ||
+	    FIELD_GET(MT_EE_NIC_CONF_0_TX_PATH, nic_conf0) > 1)
 		dev_err(dev->dev,
 			"Error: device has more than 1 RX/TX stream!\n");
 }
@@ -150,7 +150,7 @@ mt7601u_set_macaddr(struct mt7601u_dev *dev, const u8 *eeprom)
 
 	mt76_wr(dev, MT_MAC_ADDR_DW0, get_unaligned_le32(dev->macaddr));
 	mt76_wr(dev, MT_MAC_ADDR_DW1, get_unaligned_le16(dev->macaddr + 4) |
-		MT76_SET(MT_MAC_ADDR_DW1_U2ME_MASK, 0xff));
+		FIELD_PUT(MT_MAC_ADDR_DW1_U2ME_MASK, 0xff));
 
 	return 0;
 }
@@ -176,7 +176,7 @@ mt7601u_set_channel_power(struct mt7601u_dev *dev, u8 *eeprom)
 	u8 max_pwr;
 
 	val = mt7601u_rr(dev, MT_TX_ALC_CFG_0);
-	max_pwr = MT76_GET(MT_TX_ALC_CFG_0_LIMIT_0, val);
+	max_pwr = FIELD_GET(MT_TX_ALC_CFG_0_LIMIT_0, val);
 
 	if (mt7601u_has_tssi(dev, eeprom)) {
 		mt7601u_set_channel_target_power(dev, eeprom, max_pwr);
diff --git a/drivers/net/wireless/mediatek/mt7601u/init.c b/drivers/net/wireless/mediatek/mt7601u/init.c
index 8fa78d7156be..f424f51a55a3 100644
--- a/drivers/net/wireless/mediatek/mt7601u/init.c
+++ b/drivers/net/wireless/mediatek/mt7601u/init.c
@@ -108,8 +108,9 @@ static void mt7601u_init_usb_dma(struct mt7601u_dev *dev)
 {
 	u32 val;
 
-	val = MT76_SET(MT_USB_DMA_CFG_RX_BULK_AGG_TOUT, MT_USB_AGGR_TIMEOUT) |
-	      MT76_SET(MT_USB_DMA_CFG_RX_BULK_AGG_LMT, MT_USB_AGGR_SIZE_LIMIT) |
+	val = FIELD_PUT(MT_USB_DMA_CFG_RX_BULK_AGG_TOUT, MT_USB_AGGR_TIMEOUT) |
+	      FIELD_PUT(MT_USB_DMA_CFG_RX_BULK_AGG_LMT,
+			MT_USB_AGGR_SIZE_LIMIT) |
 	      MT_USB_DMA_CFG_RX_BULK_EN |
 	      MT_USB_DMA_CFG_TX_BULK_EN;
 	if (dev->in_max_packet == 512)
@@ -396,8 +397,8 @@ int mt7601u_init_hardware(struct mt7601u_dev *dev)
 
 	mt7601u_rmw(dev, MT_US_CYC_CFG, MT_US_CYC_CNT, 0x1e);
 
-	mt7601u_wr(dev, MT_TXOP_CTRL_CFG, MT76_SET(MT_TXOP_TRUN_EN, 0x3f) |
-					  MT76_SET(MT_TXOP_EXT_CCA_DLY, 0x58));
+	mt7601u_wr(dev, MT_TXOP_CTRL_CFG, FIELD_PUT(MT_TXOP_TRUN_EN, 0x3f) |
+					  FIELD_PUT(MT_TXOP_EXT_CCA_DLY, 0x58));
 
 	ret = mt7601u_eeprom_init(dev);
 	if (ret)
diff --git a/drivers/net/wireless/mediatek/mt7601u/mac.c b/drivers/net/wireless/mediatek/mt7601u/mac.c
index e21c53ed09fb..7f3221ad0bd2 100644
--- a/drivers/net/wireless/mediatek/mt7601u/mac.c
+++ b/drivers/net/wireless/mediatek/mt7601u/mac.c
@@ -19,13 +19,13 @@
 static void
 mt76_mac_process_tx_rate(struct ieee80211_tx_rate *txrate, u16 rate)
 {
-	u8 idx = MT76_GET(MT_TXWI_RATE_MCS, rate);
+	u8 idx = FIELD_GET(MT_TXWI_RATE_MCS, rate);
 
 	txrate->idx = 0;
 	txrate->flags = 0;
 	txrate->count = 1;
 
-	switch (MT76_GET(MT_TXWI_RATE_PHY_MODE, rate)) {
+	switch (FIELD_GET(MT_TXWI_RATE_PHY_MODE, rate)) {
 	case MT_PHY_TYPE_OFDM:
 		txrate->idx = idx + 4;
 		return;
@@ -47,7 +47,7 @@ mt76_mac_process_tx_rate(struct ieee80211_tx_rate *txrate, u16 rate)
 		return;
 	}
 
-	if (MT76_GET(MT_TXWI_RATE_BW, rate) == MT_PHY_BW_40)
+	if (FIELD_GET(MT_TXWI_RATE_BW, rate) == MT_PHY_BW_40)
 		txrate->flags |= IEEE80211_TX_RC_40_MHZ_WIDTH;
 
 	if (rate & MT_TXWI_RATE_SGI)
@@ -125,9 +125,9 @@ u16 mt76_mac_tx_rate_val(struct mt7601u_dev *dev,
 		bw = 0;
 	}
 
-	rateval = MT76_SET(MT_RXWI_RATE_MCS, rate_idx);
-	rateval |= MT76_SET(MT_RXWI_RATE_PHY, phy);
-	rateval |= MT76_SET(MT_RXWI_RATE_BW, bw);
+	rateval = FIELD_PUT(MT_RXWI_RATE_MCS, rate_idx);
+	rateval |= FIELD_PUT(MT_RXWI_RATE_PHY, phy);
+	rateval |= FIELD_PUT(MT_RXWI_RATE_BW, bw);
 	if (rate->flags & IEEE80211_TX_RC_SHORT_GI)
 		rateval |= MT_RXWI_RATE_SGI;
 
@@ -156,9 +156,9 @@ struct mt76_tx_status mt7601u_mac_fetch_tx_status(struct mt7601u_dev *dev)
 	stat.success = !!(val & MT_TX_STAT_FIFO_SUCCESS);
 	stat.aggr = !!(val & MT_TX_STAT_FIFO_AGGR);
 	stat.ack_req = !!(val & MT_TX_STAT_FIFO_ACKREQ);
-	stat.pktid = MT76_GET(MT_TX_STAT_FIFO_PID_TYPE, val);
-	stat.wcid = MT76_GET(MT_TX_STAT_FIFO_WCID, val);
-	stat.rate = MT76_GET(MT_TX_STAT_FIFO_RATE, val);
+	stat.pktid = FIELD_GET(MT_TX_STAT_FIFO_PID_TYPE, val);
+	stat.wcid = FIELD_GET(MT_TX_STAT_FIFO_WCID, val);
+	stat.rate = FIELD_GET(MT_TX_STAT_FIFO_RATE, val);
 
 	return stat;
 }
@@ -270,7 +270,7 @@ void mt7601u_mac_config_tsf(struct mt7601u_dev *dev, bool enable, int interval)
 	}
 
 	val &= ~MT_BEACON_TIME_CFG_INTVAL;
-	val |= MT76_SET(MT_BEACON_TIME_CFG_INTVAL, interval << 4) |
+	val |= FIELD_PUT(MT_BEACON_TIME_CFG_INTVAL, interval << 4) |
 		MT_BEACON_TIME_CFG_TIMER_EN |
 		MT_BEACON_TIME_CFG_SYNC_MODE |
 		MT_BEACON_TIME_CFG_TBTT_EN;
@@ -349,8 +349,8 @@ mt7601u_mac_wcid_setup(struct mt7601u_dev *dev, u8 idx, u8 vif_idx, u8 *mac)
 	u8 zmac[ETH_ALEN] = {};
 	u32 attr;
 
-	attr = MT76_SET(MT_WCID_ATTR_BSS_IDX, vif_idx & 7) |
-	       MT76_SET(MT_WCID_ATTR_BSS_IDX_EXT, !!(vif_idx & 8));
+	attr = FIELD_PUT(MT_WCID_ATTR_BSS_IDX, vif_idx & 7) |
+	       FIELD_PUT(MT_WCID_ATTR_BSS_IDX_EXT, !!(vif_idx & 8));
 
 	mt76_wr(dev, MT_WCID_ATTR(idx), attr);
 
@@ -382,15 +382,15 @@ void mt7601u_mac_set_ampdu_factor(struct mt7601u_dev *dev)
 	rcu_read_unlock();
 
 	mt7601u_wr(dev, MT_MAX_LEN_CFG, 0xa0fff |
-		   MT76_SET(MT_MAX_LEN_CFG_AMPDU, min_factor));
+		   FIELD_PUT(MT_MAX_LEN_CFG_AMPDU, min_factor));
 }
 
 static void
 mt76_mac_process_rate(struct ieee80211_rx_status *status, u16 rate)
 {
-	u8 idx = MT76_GET(MT_RXWI_RATE_MCS, rate);
+	u8 idx = FIELD_GET(MT_RXWI_RATE_MCS, rate);
 
-	switch (MT76_GET(MT_RXWI_RATE_PHY, rate)) {
+	switch (FIELD_GET(MT_RXWI_RATE_PHY, rate)) {
 	case MT_PHY_TYPE_OFDM:
 		if (WARN_ON(idx >= 8))
 			idx = 0;
@@ -436,7 +436,7 @@ mt7601u_rx_monitor_beacon(struct mt7601u_dev *dev, struct mt7601u_rxwi *rxwi,
 			  u16 rate, int rssi)
 {
 	dev->bcn_freq_off = rxwi->freq_off;
-	dev->bcn_phy_mode = MT76_GET(MT_RXWI_RATE_PHY, rate);
+	dev->bcn_phy_mode = FIELD_GET(MT_RXWI_RATE_PHY, rate);
 	dev->avg_rssi = (dev->avg_rssi * 15) / 16 + (rssi << 8);
 }
 
@@ -458,7 +458,7 @@ u32 mt76_mac_process_rx(struct mt7601u_dev *dev, struct sk_buff *skb,
 	u16 rate = le16_to_cpu(rxwi->rate);
 	int rssi;
 
-	len = MT76_GET(MT_RXWI_CTL_MPDU_LEN, ctl);
+	len = FIELD_GET(MT_RXWI_CTL_MPDU_LEN, ctl);
 	if (len < 10)
 		return 0;
 
@@ -542,8 +542,8 @@ int mt76_mac_wcid_set_key(struct mt7601u_dev *dev, u8 idx,
 
 	val = mt7601u_rr(dev, MT_WCID_ATTR(idx));
 	val &= ~MT_WCID_ATTR_PKEY_MODE & ~MT_WCID_ATTR_PKEY_MODE_EXT;
-	val |= MT76_SET(MT_WCID_ATTR_PKEY_MODE, cipher & 7) |
-	       MT76_SET(MT_WCID_ATTR_PKEY_MODE_EXT, cipher >> 3);
+	val |= FIELD_PUT(MT_WCID_ATTR_PKEY_MODE, cipher & 7) |
+	       FIELD_PUT(MT_WCID_ATTR_PKEY_MODE_EXT, cipher >> 3);
 	val &= ~MT_WCID_ATTR_PAIRWISE;
 	val |= MT_WCID_ATTR_PAIRWISE *
 		!!(key && key->flags & IEEE80211_KEY_FLAG_PAIRWISE);
diff --git a/drivers/net/wireless/mediatek/mt7601u/mcu.c b/drivers/net/wireless/mediatek/mt7601u/mcu.c
index 91c4b3427965..57699012e776 100644
--- a/drivers/net/wireless/mediatek/mt7601u/mcu.c
+++ b/drivers/net/wireless/mediatek/mt7601u/mcu.c
@@ -43,8 +43,8 @@ static inline void mt7601u_dma_skb_wrap_cmd(struct sk_buff *skb,
 					    u8 seq, enum mcu_cmd cmd)
 {
 	WARN_ON(mt7601u_dma_skb_wrap(skb, CPU_TX_PORT, DMA_COMMAND,
-				     MT76_SET(MT_TXD_CMD_INFO_SEQ, seq) |
-				     MT76_SET(MT_TXD_CMD_INFO_TYPE, cmd)));
+				     FIELD_PUT(MT_TXD_CMD_INFO_SEQ, seq) |
+				     FIELD_PUT(MT_TXD_CMD_INFO_TYPE, cmd)));
 }
 
 static inline void trace_mt_mcu_msg_send_cs(struct mt7601u_dev *dev,
@@ -100,13 +100,13 @@ static int mt7601u_mcu_wait_resp(struct mt7601u_dev *dev, u8 seq)
 			dev_err(dev->dev, "Error: MCU resp urb failed:%d\n",
 				urb_status);
 
-		if (MT76_GET(MT_RXD_CMD_INFO_CMD_SEQ, rxfce) == seq &&
-		    MT76_GET(MT_RXD_CMD_INFO_EVT_TYPE, rxfce) == CMD_DONE)
+		if (FIELD_GET(MT_RXD_CMD_INFO_CMD_SEQ, rxfce) == seq &&
+		    FIELD_GET(MT_RXD_CMD_INFO_EVT_TYPE, rxfce) == CMD_DONE)
 			return 0;
 
 		dev_err(dev->dev, "Error: MCU resp evt:%hhx seq:%hhx-%hhx!\n",
-			MT76_GET(MT_RXD_CMD_INFO_EVT_TYPE, rxfce),
-			seq, MT76_GET(MT_RXD_CMD_INFO_CMD_SEQ, rxfce));
+			FIELD_GET(MT_RXD_CMD_INFO_EVT_TYPE, rxfce),
+			seq, FIELD_GET(MT_RXD_CMD_INFO_CMD_SEQ, rxfce));
 	}
 
 	dev_err(dev->dev, "Error: %s timed out\n", __func__);
@@ -291,9 +291,9 @@ static int __mt7601u_dma_fw(struct mt7601u_dev *dev,
 	u32 val;
 	int ret;
 
-	reg = cpu_to_le32(MT76_SET(MT_TXD_INFO_TYPE, DMA_PACKET) |
-			  MT76_SET(MT_TXD_INFO_D_PORT, CPU_TX_PORT) |
-			  MT76_SET(MT_TXD_INFO_LEN, len));
+	reg = cpu_to_le32(FIELD_PUT(MT_TXD_INFO_TYPE, DMA_PACKET) |
+			  FIELD_PUT(MT_TXD_INFO_D_PORT, CPU_TX_PORT) |
+			  FIELD_PUT(MT_TXD_INFO_LEN, len));
 	memcpy(buf.buf, &reg, sizeof(reg));
 	memcpy(buf.buf + sizeof(reg), data, len);
 	memset(buf.buf + sizeof(reg) + len, 0, 8);
diff --git a/drivers/net/wireless/mediatek/mt7601u/mt7601u.h b/drivers/net/wireless/mediatek/mt7601u/mt7601u.h
index 428bd2f10b7b..aa2b15fb7289 100644
--- a/drivers/net/wireless/mediatek/mt7601u/mt7601u.h
+++ b/drivers/net/wireless/mediatek/mt7601u/mt7601u.h
@@ -15,6 +15,7 @@
 #ifndef MT7601U_H
 #define MT7601U_H
 
+#include <linux/bitfield.h>
 #include <linux/kernel.h>
 #include <linux/device.h>
 #include <linux/mutex.h>
@@ -24,7 +25,6 @@
 #include <linux/debugfs.h>
 
 #include "regs.h"
-#include "util.h"
 
 #define MT_CALIBRATE_INTERVAL		(4 * HZ)
 
@@ -299,7 +299,7 @@ bool mt76_poll_msec(struct mt7601u_dev *dev, u32 offset, u32 mask, u32 val,
 
 /* Compatibility with mt76 */
 #define mt76_rmw_field(_dev, _reg, _field, _val)	\
-	mt76_rmw(_dev, _reg, _field, MT76_SET(_field, _val))
+	mt76_rmw(_dev, _reg, _field, FIELD_PUT(_field, _val))
 
 static inline u32 mt76_rr(struct mt7601u_dev *dev, u32 offset)
 {
diff --git a/drivers/net/wireless/mediatek/mt7601u/phy.c b/drivers/net/wireless/mediatek/mt7601u/phy.c
index 1908af6add87..a1339c6e01e7 100644
--- a/drivers/net/wireless/mediatek/mt7601u/phy.c
+++ b/drivers/net/wireless/mediatek/mt7601u/phy.c
@@ -41,9 +41,9 @@ mt7601u_rf_wr(struct mt7601u_dev *dev, u8 bank, u8 offset, u8 value)
 		goto out;
 	}
 
-	mt7601u_wr(dev, MT_RF_CSR_CFG, MT76_SET(MT_RF_CSR_CFG_DATA, value) |
-				       MT76_SET(MT_RF_CSR_CFG_REG_BANK, bank) |
-				       MT76_SET(MT_RF_CSR_CFG_REG_ID, offset) |
+	mt7601u_wr(dev, MT_RF_CSR_CFG, FIELD_PUT(MT_RF_CSR_CFG_DATA, value) |
+				       FIELD_PUT(MT_RF_CSR_CFG_REG_BANK, bank) |
+				       FIELD_PUT(MT_RF_CSR_CFG_REG_ID, offset) |
 				       MT_RF_CSR_CFG_WR |
 				       MT_RF_CSR_CFG_KICK);
 	trace_rf_write(dev, bank, offset, value);
@@ -74,17 +74,17 @@ mt7601u_rf_rr(struct mt7601u_dev *dev, u8 bank, u8 offset)
 	if (!mt76_poll(dev, MT_RF_CSR_CFG, MT_RF_CSR_CFG_KICK, 0, 100))
 		goto out;
 
-	mt7601u_wr(dev, MT_RF_CSR_CFG, MT76_SET(MT_RF_CSR_CFG_REG_BANK, bank) |
-				       MT76_SET(MT_RF_CSR_CFG_REG_ID, offset) |
+	mt7601u_wr(dev, MT_RF_CSR_CFG, FIELD_PUT(MT_RF_CSR_CFG_REG_BANK, bank) |
+				       FIELD_PUT(MT_RF_CSR_CFG_REG_ID, offset) |
 				       MT_RF_CSR_CFG_KICK);
 
 	if (!mt76_poll(dev, MT_RF_CSR_CFG, MT_RF_CSR_CFG_KICK, 0, 100))
 		goto out;
 
 	val = mt7601u_rr(dev, MT_RF_CSR_CFG);
-	if (MT76_GET(MT_RF_CSR_CFG_REG_ID, val) == offset &&
-	    MT76_GET(MT_RF_CSR_CFG_REG_BANK, val) == bank) {
-		ret = MT76_GET(MT_RF_CSR_CFG_DATA, val);
+	if (FIELD_GET(MT_RF_CSR_CFG_REG_ID, val) == offset &&
+	    FIELD_GET(MT_RF_CSR_CFG_REG_BANK, val) == bank) {
+		ret = FIELD_GET(MT_RF_CSR_CFG_DATA, val);
 		trace_rf_read(dev, bank, offset, ret);
 	}
 out:
@@ -139,8 +139,8 @@ static void mt7601u_bbp_wr(struct mt7601u_dev *dev, u8 offset, u8 val)
 	}
 
 	mt7601u_wr(dev, MT_BBP_CSR_CFG,
-		   MT76_SET(MT_BBP_CSR_CFG_VAL, val) |
-		   MT76_SET(MT_BBP_CSR_CFG_REG_NUM, offset) |
+		   FIELD_PUT(MT_BBP_CSR_CFG_VAL, val) |
+		   FIELD_PUT(MT_BBP_CSR_CFG_REG_NUM, offset) |
 		   MT_BBP_CSR_CFG_RW_MODE | MT_BBP_CSR_CFG_BUSY);
 	trace_bbp_write(dev, offset, val);
 out:
@@ -163,7 +163,7 @@ static int mt7601u_bbp_rr(struct mt7601u_dev *dev, u8 offset)
 		goto out;
 
 	mt7601u_wr(dev, MT_BBP_CSR_CFG,
-		   MT76_SET(MT_BBP_CSR_CFG_REG_NUM, offset) |
+		   FIELD_PUT(MT_BBP_CSR_CFG_REG_NUM, offset) |
 		   MT_BBP_CSR_CFG_RW_MODE | MT_BBP_CSR_CFG_BUSY |
 		   MT_BBP_CSR_CFG_READ);
 
@@ -171,8 +171,8 @@ static int mt7601u_bbp_rr(struct mt7601u_dev *dev, u8 offset)
 		goto out;
 
 	val = mt7601u_rr(dev, MT_BBP_CSR_CFG);
-	if (MT76_GET(MT_BBP_CSR_CFG_REG_NUM, val) == offset) {
-		ret = MT76_GET(MT_BBP_CSR_CFG_VAL, val);
+	if (FIELD_GET(MT_BBP_CSR_CFG_REG_NUM, val) == offset) {
+		ret = FIELD_GET(MT_BBP_CSR_CFG_VAL, val);
 		trace_bbp_read(dev, offset, ret);
 	}
 out:
@@ -249,9 +249,9 @@ int mt7601u_phy_get_rssi(struct mt7601u_dev *dev,
 			/* bw40 */ { -2, 16, 34 }
 		}
 	};
-	int bw = MT76_GET(MT_RXWI_RATE_BW, rate);
-	int aux_lna = MT76_GET(MT_RXWI_ANT_AUX_LNA, rxwi->ant);
-	int lna_id = MT76_GET(MT_RXWI_GAIN_RSSI_LNA_ID, rxwi->gain);
+	int bw = FIELD_GET(MT_RXWI_RATE_BW, rate);
+	int aux_lna = FIELD_GET(MT_RXWI_ANT_AUX_LNA, rxwi->ant);
+	int lna_id = FIELD_GET(MT_RXWI_GAIN_RSSI_LNA_ID, rxwi->gain);
 	int val;
 
 	if (lna_id) /* LNA id can be 0, 2, 3. */
@@ -259,7 +259,7 @@ int mt7601u_phy_get_rssi(struct mt7601u_dev *dev,
 
 	val = 8;
 	val -= lna[aux_lna][bw][lna_id];
-	val -= MT76_GET(MT_RXWI_GAIN_RSSI_VAL, rxwi->gain);
+	val -= FIELD_GET(MT_RXWI_GAIN_RSSI_VAL, rxwi->gain);
 	val -= dev->ee->lna_gain;
 	val -= dev->ee->rssi_offset[0];
 
@@ -939,7 +939,7 @@ static int mt7601u_tssi_cal(struct mt7601u_dev *dev)
 	dev_dbg(dev->dev, "final diff: %08x\n", diff_pwr);
 
 	val = mt7601u_rr(dev, MT_TX_ALC_CFG_1);
-	curr_pwr = s6_to_int(MT76_GET(MT_TX_ALC_CFG_1_TEMP_COMP, val));
+	curr_pwr = s6_to_int(FIELD_GET(MT_TX_ALC_CFG_1_TEMP_COMP, val));
 	diff_pwr += curr_pwr;
 	val = (val & ~MT_TX_ALC_CFG_1_TEMP_COMP) | int_to_s6(diff_pwr);
 	mt7601u_wr(dev, MT_TX_ALC_CFG_1, val);
diff --git a/drivers/net/wireless/mediatek/mt7601u/tx.c b/drivers/net/wireless/mediatek/mt7601u/tx.c
index a0a33dc8f6bc..cd6966fe4e4e 100644
--- a/drivers/net/wireless/mediatek/mt7601u/tx.c
+++ b/drivers/net/wireless/mediatek/mt7601u/tx.c
@@ -175,11 +175,11 @@ mt7601u_push_txwi(struct mt7601u_dev *dev, struct sk_buff *skb,
 		ba_size = min_t(int, 63, ba_size);
 		if (info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE)
 			ba_size = 0;
-		txwi->ack_ctl |= MT76_SET(MT_TXWI_ACK_CTL_BA_WINDOW, ba_size);
+		txwi->ack_ctl |= FIELD_PUT(MT_TXWI_ACK_CTL_BA_WINDOW, ba_size);
 
 		txwi->flags = cpu_to_le16(MT_TXWI_FLAGS_AMPDU |
-					  MT76_SET(MT_TXWI_FLAGS_MPDU_DENSITY,
-						   sta->ht_cap.ampdu_density));
+					  FIELD_PUT(MT_TXWI_FLAGS_MPDU_DENSITY,
+						    sta->ht_cap.ampdu_density));
 		if (info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE)
 			txwi->flags = 0;
 	}
@@ -188,7 +188,7 @@ mt7601u_push_txwi(struct mt7601u_dev *dev, struct sk_buff *skb,
 
 	is_probe = !!(info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE);
 	pkt_id = mt7601u_tx_pktid_enc(dev, rate_ctl & 0x7, is_probe);
-	pkt_len |= MT76_SET(MT_TXWI_LEN_PKTID, pkt_id);
+	pkt_len |= FIELD_PUT(MT_TXWI_LEN_PKTID, pkt_id);
 	txwi->len_ctl = cpu_to_le16(pkt_len);
 
 	return txwi;
@@ -285,9 +285,9 @@ int mt7601u_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	WARN_ON(cw_min > 0xf);
 	WARN_ON(cw_max > 0xf);
 
-	val = MT76_SET(MT_EDCA_CFG_AIFSN, params->aifs) |
-	      MT76_SET(MT_EDCA_CFG_CWMIN, cw_min) |
-	      MT76_SET(MT_EDCA_CFG_CWMAX, cw_max);
+	val = FIELD_PUT(MT_EDCA_CFG_AIFSN, params->aifs) |
+	      FIELD_PUT(MT_EDCA_CFG_CWMIN, cw_min) |
+	      FIELD_PUT(MT_EDCA_CFG_CWMAX, cw_max);
 	/* TODO: based on user-controlled EnableTxBurst var vendor drv sets
 	 *	 a really long txop on AC0 (see connect.c:2009) but only on
 	 *	 connect? When not connected should be 0.
@@ -295,7 +295,7 @@ int mt7601u_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	if (!hw_q)
 		val |= 0x60;
 	else
-		val |= MT76_SET(MT_EDCA_CFG_TXOP, params->txop);
+		val |= FIELD_PUT(MT_EDCA_CFG_TXOP, params->txop);
 	mt76_wr(dev, MT_EDCA_CFG_AC(hw_q), val);
 
 	val = mt76_rr(dev, MT_WMM_TXOP(hw_q));
diff --git a/drivers/net/wireless/mediatek/mt7601u/util.h b/drivers/net/wireless/mediatek/mt7601u/util.h
deleted file mode 100644
index b89140bf1210..000000000000
--- a/drivers/net/wireless/mediatek/mt7601u/util.h
+++ /dev/null
@@ -1,77 +0,0 @@
-/*
- * Copyright (C) 2014 Felix Fietkau <nbd@openwrt.org>
- * Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2
- * as published by the Free Software Foundation
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#ifndef __MT76_UTIL_H
-#define __MT76_UTIL_H
-
-/*
- * Power of two check, this will check
- * if the mask that has been given contains and contiguous set of bits.
- * Note that we cannot use the is_power_of_2() function since this
- * check must be done at compile-time.
- */
-#define is_power_of_two(x)	( !((x) & ((x)-1)) )
-#define low_bit_mask(x)		( ((x)-1) & ~(x) )
-#define is_valid_mask(x)	is_power_of_two(1LU + (x) + low_bit_mask(x))
-
-/*
- * Macros to find first set bit in a variable.
- * These macros behave the same as the __ffs() functions but
- * the most important difference that this is done during
- * compile-time rather then run-time.
- */
-#define compile_ffs2(__x) \
-	__builtin_choose_expr(((__x) & 0x1), 0, 1)
-
-#define compile_ffs4(__x) \
-	__builtin_choose_expr(((__x) & 0x3), \
-			      (compile_ffs2((__x))), \
-			      (compile_ffs2((__x) >> 2) + 2))
-
-#define compile_ffs8(__x) \
-	__builtin_choose_expr(((__x) & 0xf), \
-			      (compile_ffs4((__x))), \
-			      (compile_ffs4((__x) >> 4) + 4))
-
-#define compile_ffs16(__x) \
-	__builtin_choose_expr(((__x) & 0xff), \
-			      (compile_ffs8((__x))), \
-			      (compile_ffs8((__x) >> 8) + 8))
-
-#define compile_ffs32(__x) \
-	__builtin_choose_expr(((__x) & 0xffff), \
-			      (compile_ffs16((__x))), \
-			      (compile_ffs16((__x) >> 16) + 16))
-
-/*
- * This macro will check the requirements for the FIELD{8,16,32} macros
- * The mask should be a constant non-zero contiguous set of bits which
- * does not exceed the given typelimit.
- */
-#define FIELD_CHECK(__mask) \
-	BUILD_BUG_ON(!(__mask) || !is_valid_mask(__mask))
-
-#define MT76_SET(_mask, _val)						\
-	({								\
-		FIELD_CHECK(_mask);					\
-		(((u32) (_val)) << compile_ffs32(_mask)) & _mask;	\
-	})
-
-#define MT76_GET(_mask, _val)						\
-	({								\
-		FIELD_CHECK(_mask);					\
-		(u32) (((_val) & _mask) >> compile_ffs32(_mask));	\
-	})
-
-#endif
-- 
1.9.1
