Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.238]:7112 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbXJaBo4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2007 21:44:56 -0400
Received: by nz-out-0506.google.com with SMTP id s18so1619429nze
        for <linux-wireless@vger.kernel.org>; Tue, 30 Oct 2007 18:44:55 -0700 (PDT)
To: linux-wireless@vger.kernel.org
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Mon, 29 Oct 2007 18:15:54 -0700
Subject: [PATCH 5/7] o80211s: (zd1211rw-mac80211) support for mesh interface
Message-ID: <4727de15.0abd720a.7b07.ffffb1f7@mx.google.com> (sfid-20071031_014458_772448_CA7B7BC6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 drivers/net/wireless/zd1211rw-mac80211/zd_chip.c |    1 +
 drivers/net/wireless/zd1211rw-mac80211/zd_chip.h |    8 +++
 drivers/net/wireless/zd1211rw-mac80211/zd_mac.c  |   72 +++++++++++++++++++++-
 drivers/net/wireless/zd1211rw-mac80211/zd_mac.h  |    3 +
 drivers/net/wireless/zd1211rw-mac80211/zd_usb.c  |   11 +++-
 5 files changed, 92 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw-mac80211/zd_chip.c b/drivers/net/wireless/zd1211rw-mac80211/zd_chip.c
index a220420..fb6d27b 100644
--- a/drivers/net/wireless/zd1211rw-mac80211/zd_chip.c
+++ b/drivers/net/wireless/zd1211rw-mac80211/zd_chip.c
@@ -806,6 +806,7 @@ static int hw_init_hmac(struct zd_chip *chip)
 		{ CR_AFTER_PNP,			0x1 },
 		{ CR_WEP_PROTECT,		0x114 },
 		{ CR_IFS_VALUE,			IFS_VALUE_DEFAULT },
+		{ CR_CAM_MODE,			MODE_AP_WDS},
 	};
 
 	ZD_ASSERT(mutex_is_locked(&chip->mutex));
diff --git a/drivers/net/wireless/zd1211rw-mac80211/zd_chip.h b/drivers/net/wireless/zd1211rw-mac80211/zd_chip.h
index a88a569..46900be 100644
--- a/drivers/net/wireless/zd1211rw-mac80211/zd_chip.h
+++ b/drivers/net/wireless/zd1211rw-mac80211/zd_chip.h
@@ -486,6 +486,7 @@ enum {
 
 #define CR_RX_OFFSET			CTL_REG(0x065c)
 
+#define CR_BCN_LENGTH			CTL_REG(0x0664)
 #define CR_PHY_DELAY			CTL_REG(0x066C)
 #define CR_BCN_FIFO			CTL_REG(0x0670)
 #define CR_SNIFFER_ON			CTL_REG(0x0674)
@@ -542,6 +543,8 @@ enum {
 #define RX_FILTER_CTRL (RX_FILTER_RTS | RX_FILTER_CTS | \
 	RX_FILTER_CFEND | RX_FILTER_CFACK)
 
+#define BCN_MODE_IBSS			0x2000000
+
 /* Monitor mode sets filter to 0xfffff */
 
 #define CR_ACK_TIMEOUT_EXT		CTL_REG(0x0690)
@@ -575,6 +578,11 @@ enum {
 
 /* CAM: Continuous Access Mode (power management) */
 #define CR_CAM_MODE			CTL_REG(0x0700)
+#define MODE_IBSS			0x0
+#define MODE_AP				0x1
+#define MODE_STA			0x2
+#define MODE_AP_WDS			0x3
+
 #define CR_CAM_ROLL_TB_LOW		CTL_REG(0x0704)
 #define CR_CAM_ROLL_TB_HIGH		CTL_REG(0x0708)
 #define CR_CAM_ADDRESS			CTL_REG(0x070C)
diff --git a/drivers/net/wireless/zd1211rw-mac80211/zd_mac.c b/drivers/net/wireless/zd1211rw-mac80211/zd_mac.c
index ad6a8d5..b668abd 100644
--- a/drivers/net/wireless/zd1211rw-mac80211/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw-mac80211/zd_mac.c
@@ -493,6 +493,45 @@ static void cs_set_control(struct zd_mac *mac, struct zd_ctrlset *cs,
 	/* FIXME: Management frame? */
 }
 
+void zd_mac_config_beacon(struct ieee80211_hw *hw, struct sk_buff *beacon)
+{
+	struct zd_mac *mac = zd_hw_mac(hw);
+	u32 tmp, j = 0;
+	/* 4 more bytes for tail CRC */
+	u32 full_len = beacon->len + 4;
+	zd_iowrite32(&mac->chip, CR_BCN_FIFO_SEMAPHORE, 0);
+	zd_ioread32(&mac->chip, CR_BCN_FIFO_SEMAPHORE, &tmp);
+	/* 0x2 (BIT_1) in vendor driver, maybe they meant 0x1? */
+	while (tmp & 0x2) {
+		zd_ioread32(&mac->chip, CR_BCN_FIFO_SEMAPHORE, &tmp);
+		if ((++j % 100) == 0)
+			printk(KERN_ERR "CR_BCN_FIFO_SEMAPHORE not ready\n");
+		msleep(1);
+	}
+
+	zd_iowrite32(&mac->chip, CR_BCN_FIFO, full_len - 1 );
+	if (zd_chip_is_zd1211b(&mac->chip)) {
+		zd_iowrite32(&mac->chip, CR_BCN_LENGTH, full_len - 1);
+	}
+
+	for (j=0 ; j < beacon->len; j++) {
+		zd_iowrite32(&mac->chip, CR_BCN_FIFO,s
+				* ((u8 *)(beacon->data + j)));
+	}
+
+	for (j=0; j< 4; j++) {
+		zd_iowrite32(&mac->chip, CR_BCN_FIFO, 0x0);
+	}
+
+	zd_iowrite32(&mac->chip, CR_BCN_FIFO_SEMAPHORE, 1);
+	/* 802.11b/g 2.4G CCK 1Mb
+	 * 802.11a, not yet implemented, uses different values (see GPL vendor
+	 * driver)
+	 */
+	zd_iowrite32(&mac->chip, CR_BCN_PLCP_CFG, 0x00000400 |
+			(full_len << 19));
+}
+
 static int fill_ctrlset(struct zd_mac *mac,
 			struct sk_buff *skb,
 			struct ieee80211_tx_control *control)
@@ -701,6 +740,7 @@ static int zd_op_add_interface(struct ieee80211_hw *hw,
 
 	switch (conf->type) {
 	case IEEE80211_IF_TYPE_MNTR:
+	case IEEE80211_IF_TYPE_MESH:
 	case IEEE80211_IF_TYPE_STA:
 		mac->type = conf->type;
 		break;
@@ -729,15 +769,44 @@ static int zd_op_config_interface(struct ieee80211_hw *hw, int if_id,
 				   struct ieee80211_if_conf *conf)
 {
 	struct zd_mac *mac = zd_hw_mac(hw);
+	int associated;
+
+	if (mac->type == IEEE80211_IF_TYPE_MESH) {
+		associated = true ;
+		if (hw->flags & IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE) {
+			zd_mac_config_beacon(hw, conf->beacon);
+			kfree_skb(conf->beacon);
+			zd_set_beacon_interval(&mac->chip, BCN_MODE_IBSS | 100);
+		}
+	}
+	else
+		associated = is_valid_ether_addr(conf->bssid);
 
 	spin_lock_irq(&mac->lock);
-	mac->associated = is_valid_ether_addr(conf->bssid);
+	mac->associated = associated;
 	spin_unlock_irq(&mac->lock);
 
 	/* TODO: do hardware bssid filtering */
 	return 0;
 }
 
+void zd_process_intr(struct work_struct *work)
+{
+	u16 int_status;
+	struct zd_mac *mac = container_of(work, struct zd_mac, process_intr);
+
+	int_status = le16_to_cpu(*(u16*)(mac->intr_buffer+4));
+	if (int_status & INT_CFG_NEXT_BCN) {
+		dev_dbg_f(zd_mac_dev(mac), "INT_CFG_NEXT_BCN\n");
+	}
+	else {
+		dev_dbg_f(zd_mac_dev(mac), "Unsupported interrupt\n");
+	}
+
+	zd_chip_enable_hwint(&mac->chip);
+}
+
+
 static void set_multicast_hash_handler(struct work_struct *work)
 {
 	struct zd_mac *mac =
@@ -929,6 +998,7 @@ struct ieee80211_hw *zd_mac_alloc_hw(struct usb_interface *intf)
 	INIT_WORK(&mac->set_multicast_hash_work, set_multicast_hash_handler);
 	INIT_WORK(&mac->set_rts_cts_work, set_rts_cts_work);
 	INIT_WORK(&mac->set_rx_filter_work, set_rx_filter_handler);
+	INIT_WORK(&mac->process_intr, zd_process_intr);
 
 	SET_IEEE80211_DEV(hw, &intf->dev);
 	return hw;
diff --git a/drivers/net/wireless/zd1211rw-mac80211/zd_mac.h b/drivers/net/wireless/zd1211rw-mac80211/zd_mac.h
index ed5417c..fbfc2e8 100644
--- a/drivers/net/wireless/zd1211rw-mac80211/zd_mac.h
+++ b/drivers/net/wireless/zd1211rw-mac80211/zd_mac.h
@@ -169,12 +169,15 @@ struct zd_tx_skb_control_block {
 struct zd_mac {
 	struct zd_chip chip;
 	spinlock_t lock;
+	spinlock_t intr_lock;
 	struct ieee80211_hw *hw;
 	struct housekeeping housekeeping;
 	struct work_struct set_multicast_hash_work;
 	struct work_struct set_rts_cts_work;
 	struct work_struct set_rx_filter_work;
+	struct work_struct process_intr;
 	struct zd_mc_hash multicast_hash;
+	u8 intr_buffer[USB_MAX_EP_INT_BUFFER];
 	u8 regdomain;
 	u8 default_regdomain;
 	int type;
diff --git a/drivers/net/wireless/zd1211rw-mac80211/zd_usb.c b/drivers/net/wireless/zd1211rw-mac80211/zd_usb.c
index 15ea70e..972a370 100644
--- a/drivers/net/wireless/zd1211rw-mac80211/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw-mac80211/zd_usb.c
@@ -92,6 +92,7 @@ MODULE_DEVICE_TABLE(usb, usb_ids);
 #define FW_ZD1211B_PREFIX	"zd1211/zd1211b_"
 
 /* USB device initialization */
+static void int_urb_complete(struct urb *urb);
 
 static int request_fw_file(
 	const struct firmware **fw, const char *name, struct device *device)
@@ -331,11 +332,18 @@ static inline void handle_regs_int(struct urb *urb)
 	struct zd_usb *usb = urb->context;
 	struct zd_usb_interrupt *intr = &usb->intr;
 	int len;
+	u16 int_num;
 
 	ZD_ASSERT(in_interrupt());
 	spin_lock(&intr->lock);
 
-	if (intr->read_regs_enabled) {
+	int_num = le16_to_cpu(*(u16*)(urb->transfer_buffer+2));
+	if( int_num == CR_INTERRUPT ){
+		struct zd_mac *mac = zd_hw_mac(zd_usb_to_hw(urb->context));
+		memcpy(&mac->intr_buffer, urb->transfer_buffer,
+				USB_MAX_EP_INT_BUFFER);
+		schedule_work(&mac->process_intr);
+	} else if (intr->read_regs_enabled) {
 		intr->read_regs.length = len = urb->actual_length;
 
 		if (len > sizeof(intr->read_regs.buffer))
@@ -346,7 +354,6 @@ static inline void handle_regs_int(struct urb *urb)
 		goto out;
 	}
 
-	dev_dbg_f(urb_dev(urb), "regs interrupt ignored\n");
 out:
 	spin_unlock(&intr->lock);
 }
-- 
1.5.2.5



