Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50498 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758049Ab1BKU1s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Feb 2011 15:27:48 -0500
Date: Fri, 11 Feb 2011 14:27:46 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: sgruszka@redhat.com, george0505@realtek.com,
	chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: [PATCH 1/5 V2] rtlwifi: Modify core routines
Message-ID: <4d559bc2.Tc8OZp/TEi3Cqg8O%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rtlwifi core needs some changes before inclusion of a driver
for the RTL8192CU USB device.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: <chaoming_li@realsil.com.cn>
Signed-off-by: <george0505@realtek.com>

---

John,

To minimize the changes, I have done this patch for only the changes
needed for rtl8192cu.
V2 - Answer Stanislaw Gruszka's comments

This is 2.6.39 material.

Larry
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/base.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/base.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/base.h
@@ -30,6 +30,7 @@
 #define __RTL_BASE_H__
 
 #define RTL_DUMMY_OFFSET	0
+#define RTL_RX_DESC_SIZE	24
 #define RTL_DUMMY_UNIT		8
 #define RTL_TX_DUMMY_SIZE	(RTL_DUMMY_OFFSET * RTL_DUMMY_UNIT)
 #define RTL_TX_DESC_SIZE	32
Index: wireless-testing/drivers/net/wireless/rtlwifi/debug.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/debug.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/debug.h
@@ -105,6 +105,7 @@
 #define COMP_MAC80211		BIT(26)
 #define COMP_REGD			BIT(27)
 #define COMP_CHAN			BIT(28)
+#define COMP_USB			BIT(29)
 
 /*--------------------------------------------------------------
 		Define the rt_print components
Index: wireless-testing/drivers/net/wireless/rtlwifi/wifi.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/wifi.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/wifi.h
@@ -34,6 +34,7 @@
 #include <linux/firmware.h>
 #include <linux/version.h>
 #include <linux/etherdevice.h>
+#include <linux/usb.h>
 #include <net/mac80211.h>
 #include "debug.h"
 
@@ -118,6 +119,9 @@ enum hardware_type {
 	HARDWARE_TYPE_NUM
 };
 
+#define IS_HARDWARE_TYPE_8192CE(rtlhal)			\
+	(rtlhal->hw_type == HARDWARE_TYPE_RTL8192CE)
+
 enum scan_operation_backup_opt {
 	SCAN_OPT_BACKUP = 0,
 	SCAN_OPT_RESTORE,
@@ -768,6 +772,7 @@ struct rtl_tid_data {
 struct rtl_priv;
 struct rtl_io {
 	struct device *dev;
+	struct mutex bb_mutex;
 
 	/*PCI MEM map */
 	unsigned long pci_mem_end;	/*shared mem end        */
@@ -779,10 +784,14 @@ struct rtl_io {
 	void (*write8_async) (struct rtl_priv *rtlpriv, u32 addr, u8 val);
 	void (*write16_async) (struct rtl_priv *rtlpriv, u32 addr, u16 val);
 	void (*write32_async) (struct rtl_priv *rtlpriv, u32 addr, u32 val);
+	int (*writeN_async) (struct rtl_priv *rtlpriv, u32 addr, u16 len,
+			     u8 *pdata);
 
 	 u8(*read8_sync) (struct rtl_priv *rtlpriv, u32 addr);
 	 u16(*read16_sync) (struct rtl_priv *rtlpriv, u32 addr);
 	 u32(*read32_sync) (struct rtl_priv *rtlpriv, u32 addr);
+	int (*readN_sync) (struct rtl_priv *rtlpriv, u32 addr, u16 len,
+			    u8 *pdata);
 
 };
 
@@ -1101,6 +1110,7 @@ struct rtl_tcb_desc {
 struct rtl_hal_ops {
 	int (*init_sw_vars) (struct ieee80211_hw *hw);
 	void (*deinit_sw_vars) (struct ieee80211_hw *hw);
+	void (*read_chip_version)(struct ieee80211_hw *hw);
 	void (*read_eeprom_info) (struct ieee80211_hw *hw);
 	void (*interrupt_recognized) (struct ieee80211_hw *hw,
 				      u32 *p_inta, u32 *p_intb);
@@ -1129,7 +1139,8 @@ struct rtl_hal_ops {
 	void (*fill_tx_cmddesc) (struct ieee80211_hw *hw, u8 *pdesc,
 				 bool b_firstseg, bool b_lastseg,
 				 struct sk_buff *skb);
-	 bool(*query_rx_desc) (struct ieee80211_hw *hw,
+	bool (*cmd_send_packet)(struct ieee80211_hw *hw, struct sk_buff *skb);
+	bool(*query_rx_desc) (struct ieee80211_hw *hw,
 			       struct rtl_stats *stats,
 			       struct ieee80211_rx_status *rx_status,
 			       u8 *pdesc, struct sk_buff *skb);
@@ -1166,6 +1177,7 @@ struct rtl_intf_ops {
 
 	int (*adapter_tx) (struct ieee80211_hw *hw, struct sk_buff *skb);
 	int (*reset_trx_ring) (struct ieee80211_hw *hw);
+	bool (*waitq_insert) (struct ieee80211_hw *hw, struct sk_buff *skb);
 
 	/*pci */
 	void (*disable_aspm) (struct ieee80211_hw *hw);
@@ -1179,11 +1191,35 @@ struct rtl_mod_params {
 	int sw_crypto;
 };
 
+struct rtl_hal_usbint_cfg {
+	/* data - rx */
+	u32 in_ep_num;
+	u32 rx_urb_num;
+	u32 rx_max_size;
+
+	/* op - rx */
+	void (*usb_rx_hdl)(struct ieee80211_hw *, struct sk_buff *);
+	void (*usb_rx_segregate_hdl)(struct ieee80211_hw *, struct sk_buff *,
+				     struct sk_buff_head *);
+
+	/* tx */
+	void (*usb_tx_cleanup)(struct ieee80211_hw *, struct sk_buff *);
+	int (*usb_tx_post_hdl)(struct ieee80211_hw *, struct urb *,
+			       struct sk_buff *);
+	struct sk_buff *(*usb_tx_aggregate_hdl)(struct ieee80211_hw *,
+						struct sk_buff_head *);
+
+	/* endpoint mapping */
+	int (*usb_endpoint_mapping)(struct ieee80211_hw *hw);
+	u16 (*usb_mq_to_hwq)(u16 fc, u16 mac80211_queue_index);
+};
+
 struct rtl_hal_cfg {
 	char *name;
 	char *fw_name;
 	struct rtl_hal_ops *ops;
 	struct rtl_mod_params *mod_params;
+	struct rtl_hal_usbint_cfg *usb_interface_cfg;
 
 	/*this map used for some registers or vars
 	   defined int HAL but used in MAIN */
@@ -1202,6 +1238,7 @@ struct rtl_locks {
 	spinlock_t rf_ps_lock;
 	spinlock_t rf_lock;
 	spinlock_t lps_lock;
+	spinlock_t tx_urb_lock;
 };
 
 struct rtl_works {
@@ -1437,10 +1474,8 @@ Set subfield of little-endian 4-byte val
 		(_os).octet = (u8 *)(_octet);		\
 		(_os).length = (_len);
 
-#define CP_MACADDR(des, src)	\
-	((des)[0] = (src)[0], (des)[1] = (src)[1],\
-	(des)[2] = (src)[2], (des)[3] = (src)[3],\
-	(des)[4] = (src)[4], (des)[5] = (src)[5])
+#define CP_MACADDR(des, src)		\
+	memcpy((des), (src), ETH_ALEN)
 
 static inline u8 rtl_read_byte(struct rtl_priv *rtlpriv, u32 addr)
 {
Index: wireless-testing/drivers/net/wireless/rtlwifi/pci.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/pci.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/pci.c
@@ -690,75 +690,6 @@ done:
 
 }
 
-void _rtl_pci_tx_interrupt(struct ieee80211_hw *hw)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
-	int prio;
-
-	for (prio = 0; prio < RTL_PCI_MAX_TX_QUEUE_COUNT; prio++) {
-		struct rtl8192_tx_ring *ring = &rtlpci->tx_ring[prio];
-
-		while (skb_queue_len(&ring->queue)) {
-			struct rtl_tx_desc *entry = &ring->desc[ring->idx];
-			struct sk_buff *skb;
-			struct ieee80211_tx_info *info;
-			u8 own;
-
-			/*
-			 *beacon packet will only use the first
-			 *descriptor defautly, and the own may not
-			 *be cleared by the hardware, and
-			 *beacon will free in prepare beacon
-			 */
-			if (prio == BEACON_QUEUE || prio == TXCMD_QUEUE ||
-			    prio == HCCA_QUEUE)
-				break;
-
-			own = (u8)rtlpriv->cfg->ops->get_desc((u8 *)entry,
-							       true,
-							       HW_DESC_OWN);
-
-			if (own)
-				break;
-
-			skb = __skb_dequeue(&ring->queue);
-			pci_unmap_single(rtlpci->pdev,
-					 le32_to_cpu(rtlpriv->cfg->ops->
-						     get_desc((u8 *) entry,
-						     true,
-						     HW_DESC_TXBUFF_ADDR)),
-					 skb->len, PCI_DMA_TODEVICE);
-
-			ring->idx = (ring->idx + 1) % ring->entries;
-
-			info = IEEE80211_SKB_CB(skb);
-			ieee80211_tx_info_clear_status(info);
-
-			info->flags |= IEEE80211_TX_STAT_ACK;
-			/*info->status.rates[0].count = 1; */
-
-			ieee80211_tx_status_irqsafe(hw, skb);
-
-			if ((ring->entries - skb_queue_len(&ring->queue))
-			    == 2 && prio != BEACON_QUEUE) {
-				RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-					 ("more desc left, wake "
-					  "skb_queue@%d,ring->idx = %d,"
-					  "skb_queue_len = 0x%d\n",
-					  prio, ring->idx,
-					  skb_queue_len(&ring->queue)));
-
-				ieee80211_wake_queue(hw,
-						     skb_get_queue_mapping
-						     (skb));
-			}
-
-			skb = NULL;
-		}
-	}
-}
-
 static irqreturn_t _rtl_pci_interrupt(int irq, void *dev_id)
 {
 	struct ieee80211_hw *hw = dev_id;
@@ -1273,7 +1204,7 @@ int rtl_pci_reset_trx_ring(struct ieee80
 	return 0;
 }
 
-unsigned int _rtl_mac_to_hwqueue(u16 fc,
+static unsigned int _rtl_mac_to_hwqueue(u16 fc,
 		unsigned int mac80211_queue_index)
 {
 	unsigned int hw_queue_index;
@@ -1312,7 +1243,7 @@ out:
 	return hw_queue_index;
 }
 
-int rtl_pci_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+static int rtl_pci_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
@@ -1429,7 +1360,7 @@ int rtl_pci_tx(struct ieee80211_hw *hw,
 	return 0;
 }
 
-void rtl_pci_deinit(struct ieee80211_hw *hw)
+static void rtl_pci_deinit(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
@@ -1444,7 +1375,7 @@ void rtl_pci_deinit(struct ieee80211_hw
 
 }
 
-int rtl_pci_init(struct ieee80211_hw *hw, struct pci_dev *pdev)
+static int rtl_pci_init(struct ieee80211_hw *hw, struct pci_dev *pdev)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	int err;
@@ -1461,7 +1392,7 @@ int rtl_pci_init(struct ieee80211_hw *hw
 	return 1;
 }
 
-int rtl_pci_start(struct ieee80211_hw *hw)
+static int rtl_pci_start(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
@@ -1496,7 +1427,7 @@ int rtl_pci_start(struct ieee80211_hw *h
 	return 0;
 }
 
-void rtl_pci_stop(struct ieee80211_hw *hw)
+static void rtl_pci_stop(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
@@ -1838,7 +1769,7 @@ fail3:
 	ieee80211_free_hw(hw);
 
 	if (rtlpriv->io.pci_mem_start != 0)
-		pci_iounmap(pdev, (void *)rtlpriv->io.pci_mem_start);
+		pci_iounmap(pdev, (void __iomem *)rtlpriv->io.pci_mem_start);
 
 fail2:
 	pci_release_regions(pdev);
@@ -1888,7 +1819,7 @@ void rtl_pci_disconnect(struct pci_dev *
 	}
 
 	if (rtlpriv->io.pci_mem_start != 0) {
-		pci_iounmap(pdev, (void *)rtlpriv->io.pci_mem_start);
+		pci_iounmap(pdev, (void __iomem *)rtlpriv->io.pci_mem_start);
 		pci_release_regions(pdev);
 	}
 
Index: wireless-testing/drivers/net/wireless/rtlwifi/pci.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/pci.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/pci.h
@@ -244,34 +244,34 @@ int rtl_pci_resume(struct pci_dev *pdev)
 
 static inline u8 pci_read8_sync(struct rtl_priv *rtlpriv, u32 addr)
 {
-	return 0xff & readb((u8 *) rtlpriv->io.pci_mem_start + addr);
+	return readb((u8 __iomem *) rtlpriv->io.pci_mem_start + addr);
 }
 
 static inline u16 pci_read16_sync(struct rtl_priv *rtlpriv, u32 addr)
 {
-	return readw((u8 *) rtlpriv->io.pci_mem_start + addr);
+	return readw((u8 __iomem *) rtlpriv->io.pci_mem_start + addr);
 }
 
 static inline u32 pci_read32_sync(struct rtl_priv *rtlpriv, u32 addr)
 {
-	return readl((u8 *) rtlpriv->io.pci_mem_start + addr);
+	return readl((u8 __iomem *) rtlpriv->io.pci_mem_start + addr);
 }
 
 static inline void pci_write8_async(struct rtl_priv *rtlpriv, u32 addr, u8 val)
 {
-	writeb(val, (u8 *) rtlpriv->io.pci_mem_start + addr);
+	writeb(val, (u8 __iomem *) rtlpriv->io.pci_mem_start + addr);
 }
 
 static inline void pci_write16_async(struct rtl_priv *rtlpriv,
 				     u32 addr, u16 val)
 {
-	writew(val, (u8 *) rtlpriv->io.pci_mem_start + addr);
+	writew(val, (u8 __iomem *) rtlpriv->io.pci_mem_start + addr);
 }
 
 static inline void pci_write32_async(struct rtl_priv *rtlpriv,
 				     u32 addr, u32 val)
 {
-	writel(val, (u8 *) rtlpriv->io.pci_mem_start + addr);
+	writel(val, (u8 __iomem *) rtlpriv->io.pci_mem_start + addr);
 }
 
 static inline void rtl_pci_raw_write_port_ulong(u32 port, u32 val)
