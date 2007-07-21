Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:54491 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756885AbXGUU7J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jul 2007 16:59:09 -0400
From: Daniel Drake <dsd@gentoo.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Cc: kune@deine-taler.de
Subject: [PATCH] zd1211rw-mac80211: changed struct ieee80211_hw references to hw
Message-Id: <20070721205908.9321B7B409F@zog.reactivated.net>
Date: Sat, 21 Jul 2007 21:59:08 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ulrich Kunitz <kune@deine-taler.de>

During the change from the softmac to the mac80211 stack, the
former network device pointer has been changed to a struct
ieee80211_hw pointer. However the pointer name dev has not been
changed as well as related function names.

However the code deals also with real devices and uses dev as name
there also. This has caused confusion at least for me. The patch
uses now the name hw for all struct ieee80211_hw pointers in the
zd1211rw-mac80211 driver. Related function names have been also
changed. There is no change in any functionality.

Signed-off-by: Ulrich Kunitz <kune@deine-taler.de>
Signed-off-by: Daniel Drake <dsd@gentoo.org>

Index: wireless-dev/drivers/net/wireless/mac80211/zd1211rw/zd_chip.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/zd1211rw/zd_chip.c
+++ wireless-dev/drivers/net/wireless/mac80211/zd1211rw/zd_chip.c
@@ -31,12 +31,12 @@
 #include "zd_util.h"
 
 void zd_chip_init(struct zd_chip *chip,
-	         struct ieee80211_hw *dev,
+	         struct ieee80211_hw *hw,
 		 struct usb_interface *intf)
 {
 	memset(chip, 0, sizeof(*chip));
 	mutex_init(&chip->mutex);
-	zd_usb_init(&chip->usb, dev, intf);
+	zd_usb_init(&chip->usb, hw, intf);
 	zd_rf_init(&chip->rf);
 }
 
Index: wireless-dev/drivers/net/wireless/mac80211/zd1211rw/zd_chip.h
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/zd1211rw/zd_chip.h
+++ wireless-dev/drivers/net/wireless/mac80211/zd1211rw/zd_chip.h
@@ -722,7 +722,7 @@ static inline struct zd_chip *zd_rf_to_c
 #define zd_chip_dev(chip) (&(chip)->usb.intf->dev)
 
 void zd_chip_init(struct zd_chip *chip,
-	         struct ieee80211_hw *dev,
+	         struct ieee80211_hw *hw,
 	         struct usb_interface *intf);
 void zd_chip_clear(struct zd_chip *chip);
 int zd_chip_read_mac_addr_fw(struct zd_chip *chip, u8 *addr);
Index: wireless-dev/drivers/net/wireless/mac80211/zd1211rw/zd_ieee80211.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/zd1211rw/zd_ieee80211.c
+++ wireless-dev/drivers/net/wireless/mac80211/zd1211rw/zd_ieee80211.c
@@ -60,7 +60,7 @@ const struct channel_range *zd_channel_r
 
 #define CHAN_TO_IDX(chan) ((chan) - 1)
 
-static void unmask_bg_channels(struct ieee80211_hw *dev,
+static void unmask_bg_channels(struct ieee80211_hw *hw,
 	const struct channel_range *range,
 	struct ieee80211_hw_mode *mode)
 {
@@ -75,9 +75,9 @@ static void unmask_bg_channels(struct ie
 	}
 }
 
-void zd_geo_init(struct ieee80211_hw *dev, u8 regdomain)
+void zd_geo_init(struct ieee80211_hw *hw, u8 regdomain)
 {
-	struct zd_mac *mac = zd_dev_mac(dev);
+	struct zd_mac *mac = zd_hw_mac(hw);
 	const struct channel_range *range;
 
 	dev_dbg(zd_mac_dev(mac), "regdomain %#02x\n", regdomain);
@@ -94,7 +94,7 @@ void zd_geo_init(struct ieee80211_hw *de
 		range = zd_channel_range(ZD_REGDOMAIN_FCC);
 	}
 
-	unmask_bg_channels(dev, range, &mac->modes[0]);
-	unmask_bg_channels(dev, range, &mac->modes[1]);
+	unmask_bg_channels(hw, range, &mac->modes[0]);
+	unmask_bg_channels(hw, range, &mac->modes[1]);
 }
 
Index: wireless-dev/drivers/net/wireless/mac80211/zd1211rw/zd_ieee80211.h
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/zd1211rw/zd_ieee80211.h
+++ wireless-dev/drivers/net/wireless/mac80211/zd1211rw/zd_ieee80211.h
@@ -19,7 +19,7 @@ enum {
 	MAX_CHANNEL24 = 14,
 };
 
-void zd_geo_init(struct ieee80211_hw *dev, u8 regdomain);
+void zd_geo_init(struct ieee80211_hw *hw, u8 regdomain);
 
 #define ZD_PLCP_SERVICE_LENGTH_EXTENSION 0x80
 
Index: wireless-dev/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
+++ wireless-dev/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
@@ -106,28 +106,28 @@ static void housekeeping_init(struct zd_
 static void housekeeping_enable(struct zd_mac *mac);
 static void housekeeping_disable(struct zd_mac *mac);
 
-int zd_mac_preinit_hw(struct ieee80211_hw *dev)
+int zd_mac_preinit_hw(struct ieee80211_hw *hw)
 {
 	int r;
 	u8 addr[ETH_ALEN];
-	struct zd_mac *mac = zd_dev_mac(dev);
+	struct zd_mac *mac = zd_hw_mac(hw);
 
 	r = zd_chip_read_mac_addr_fw(&mac->chip, addr);
 	if (r)
 		return r;
 
 	spin_lock_irq(&mac->lock);
-	SET_IEEE80211_PERM_ADDR(dev, addr);
+	SET_IEEE80211_PERM_ADDR(hw, addr);
 	memcpy(mac->hwaddr, addr, ETH_ALEN);
 	spin_unlock_irq(&mac->lock);
 
 	return 0;
 }
 
-int zd_mac_init_hw(struct ieee80211_hw *dev)
+int zd_mac_init_hw(struct ieee80211_hw *hw)
 {
 	int r;
-	struct zd_mac *mac = zd_dev_mac(dev);
+	struct zd_mac *mac = zd_hw_mac(hw);
 	struct zd_chip *chip = &mac->chip;
 	u8 default_regdomain;
 
@@ -153,7 +153,7 @@ int zd_mac_init_hw(struct ieee80211_hw *
 	if (r)
 		goto disable_int;
 
-	zd_geo_init(dev, mac->regdomain);
+	zd_geo_init(hw, mac->regdomain);
 
 	r = 0;
 disable_int:
@@ -177,9 +177,9 @@ static int reset_mode(struct zd_mac *mac
 	return zd_iowrite32(&mac->chip, CR_RX_FILTER, filter);
 }
 
-static int zd_mac_open(struct ieee80211_hw *dev)
+static int zd_mac_open(struct ieee80211_hw *hw)
 {
-	struct zd_mac *mac = zd_dev_mac(dev);
+	struct zd_mac *mac = zd_hw_mac(hw);
 	struct zd_chip *chip = &mac->chip;
 	struct zd_usb *usb = &chip->usb;
 	int r;
@@ -255,17 +255,16 @@ static void kfree_tx_skb(struct sk_buff 
 	dev_kfree_skb_any(skb);
 }
 
-static int zd_mac_stop(struct ieee80211_hw *dev)
+static int zd_mac_stop(struct ieee80211_hw *hw)
 {
-	struct zd_mac *mac = zd_dev_mac(dev);
+	struct zd_mac *mac = zd_hw_mac(hw);
 	struct zd_chip *chip = &mac->chip;
 	struct sk_buff *skb;
 	struct sk_buff_head *ack_wait_queue = &mac->ack_wait_queue;
 
-	/*
-	 * The order here deliberately is a little different from the open()
+	/* The order here deliberately is a little different from the open()
 	 * method, since we need to make sure there is no opportunity for RX
-	 * frames to be processed by softmac after we have stopped it.
+	 * frames to be processed by mac80211 after we have stopped it.
 	 */
 
 	zd_chip_disable_rxtx(chip);
@@ -291,7 +290,7 @@ static int zd_mac_stop(struct ieee80211_
  * Initializes the control block of the skbuff to be transmitted.
  */
 static int init_tx_skb_control_block(struct sk_buff *skb,
-				     struct ieee80211_hw *dev,
+				     struct ieee80211_hw *hw,
 	                             struct ieee80211_tx_control *control)
 {
 	struct zd_tx_skb_control_block *cb =
@@ -299,7 +298,7 @@ static int init_tx_skb_control_block(str
 
 	ZD_ASSERT(sizeof(*cb) <= sizeof(skb->cb));
 	memset(cb, 0, sizeof(*cb));
-	cb->dev = dev;
+	cb->hw= hw;
 	cb->control = kmalloc(sizeof(*control), GFP_ATOMIC);
 	if (cb->control == NULL)
 		return -ENOMEM;
@@ -310,7 +309,7 @@ static int init_tx_skb_control_block(str
 
 /**
  * tx_status - reports tx status of a packet if required
- * @dev - a &struct ieee80211_hw pointer
+ * @hw - a &struct ieee80211_hw pointer
  * @skb - a sk-buffer
  * @status - the tx status of the packet without control information
  *
@@ -320,7 +319,7 @@ static int init_tx_skb_control_block(str
  *
  * If no status information has been requested, the skb is freed.
  */
-static void tx_status(struct ieee80211_hw *dev, struct sk_buff *skb,
+static void tx_status(struct ieee80211_hw *hw, struct sk_buff *skb,
 	              struct ieee80211_tx_status *status)
 {
 	struct zd_tx_skb_control_block *cb = (struct zd_tx_skb_control_block *)
@@ -330,7 +329,7 @@ static void tx_status(struct ieee80211_h
 	if ((cb->control->flags & IEEE80211_TXCTL_REQ_TX_STATUS)) {
 		memcpy(&status->control, cb->control, sizeof(status->control));
 		clear_tx_skb_control_block(skb);
-		ieee80211_tx_status_irqsafe(dev, skb, status);
+		ieee80211_tx_status_irqsafe(hw, skb, status);
 	} else {
 		kfree_tx_skb(skb);
 	}
@@ -344,16 +343,16 @@ static void tx_status(struct ieee80211_h
  * transferred. The first frame from the tx queue, will be selected and
  * reported as error to the upper layers.
  */
-void zd_mac_tx_failed(struct ieee80211_hw *dev)
+void zd_mac_tx_failed(struct ieee80211_hw *hw)
 {
-	struct sk_buff_head *q = &zd_dev_mac(dev)->ack_wait_queue;
+	struct sk_buff_head *q = &zd_hw_mac(hw)->ack_wait_queue;
 	struct sk_buff *skb;
 	struct ieee80211_tx_status status = {{0}};
 
 	skb = skb_dequeue(q);
 	if (skb == NULL)
 		return;
-	tx_status(dev, skb, &status);
+	tx_status(hw, skb, &status);
 }
 
 /**
@@ -370,7 +369,7 @@ void zd_mac_tx_to_dev(struct sk_buff *sk
 {
 	struct zd_tx_skb_control_block *cb =
 		(struct zd_tx_skb_control_block *)skb->cb;
-	struct ieee80211_hw *dev = cb->dev;
+	struct ieee80211_hw *hw = cb->hw;
 
 	if (likely(cb->control)) {
 		skb_pull(skb, sizeof(struct zd_ctrlset));
@@ -378,14 +377,14 @@ void zd_mac_tx_to_dev(struct sk_buff *sk
 		    (cb->control->flags & IEEE80211_TXCTL_NO_ACK)))
 		{
 			struct ieee80211_tx_status status = {{0}};
-			tx_status(dev, skb, &status);
+			tx_status(hw, skb, &status);
 		} else {
 			struct sk_buff_head *q =
-				&zd_dev_mac(dev)->ack_wait_queue;
+				&zd_hw_mac(hw)->ack_wait_queue;
 
 			skb_queue_tail(q, skb);
 			while (skb_queue_len(q) > ZD_MAC_MAX_ACK_WAITERS)
-				zd_mac_tx_failed(dev);
+				zd_mac_tx_failed(hw);
 		}
 	} else {
 		kfree_tx_skb(skb);
@@ -542,17 +541,17 @@ static int fill_ctrlset(struct zd_mac *m
  * control block of the skbuff will be initialized. If necessary the incoming
  * mac80211 queues will be stopped.
  */
-static int zd_mac_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
+static int zd_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 		     struct ieee80211_tx_control *control)
 {
-	struct zd_mac *mac = zd_dev_mac(dev);
+	struct zd_mac *mac = zd_hw_mac(hw);
 	int r;
 
 	r = fill_ctrlset(mac, skb, control);
 	if (r)
 		return r;
 
-	r = init_tx_skb_control_block(skb, dev, control);
+	r = init_tx_skb_control_block(skb, hw, control);
 	if (r)
 		return r;
 	r = zd_usb_tx(&mac->chip.usb, skb);
@@ -636,7 +635,7 @@ static int fill_rx_stats(struct ieee8021
  * mac80211 queues have been stopped and the number of frames still to be
  * transmitted is low the queues will be opened again.
  */
-static int filter_ack(struct ieee80211_hw *dev, struct ieee80211_hdr *rx_hdr,
+static int filter_ack(struct ieee80211_hw *hw, struct ieee80211_hdr *rx_hdr,
 		      struct ieee80211_rx_status *stats)
 {
 	u16 fc = le16_to_cpu(rx_hdr->frame_control);
@@ -648,7 +647,7 @@ static int filter_ack(struct ieee80211_h
 	    (IEEE80211_FTYPE_CTL | IEEE80211_STYPE_ACK))
 		return 0;
 
-	q = &zd_dev_mac(dev)->ack_wait_queue;
+	q = &zd_hw_mac(hw)->ack_wait_queue;
 	spin_lock_irqsave(&q->lock, flags);
 	for (skb = q->next; skb != (struct sk_buff *)q; skb = skb->next) {
 		struct ieee80211_hdr *tx_hdr;
@@ -660,7 +659,7 @@ static int filter_ack(struct ieee80211_h
 			status.flags = IEEE80211_TX_STATUS_ACK;
 			status.ack_signal = stats->ssi;
 			__skb_unlink(skb, q);
-			tx_status(dev, skb, &status);
+			tx_status(hw, skb, &status);
 			goto out;
 		}
 	}
@@ -669,10 +668,10 @@ out:
 	return 1;
 }
 
-int zd_mac_rx(struct ieee80211_hw *dev, const u8 *buffer, unsigned int length)
+int zd_mac_rx(struct ieee80211_hw *hw, const u8 *buffer, unsigned int length)
 {
 	int r;
-	struct zd_mac *mac = zd_dev_mac(dev);
+	struct zd_mac *mac = zd_hw_mac(hw);
 	struct ieee80211_rx_status stats;
 	const struct rx_status *status;
 	struct sk_buff *skb;
@@ -690,7 +689,7 @@ int zd_mac_rx(struct ieee80211_hw *dev, 
 	buffer += ZD_PLCP_HEADER_SIZE;
 
 	if (length == (10 /* IEEE80211_1ADDR_LEN */ + FCS_LEN) &&
-	    filter_ack(dev, (struct ieee80211_hdr *)buffer, &stats) &&
+	    filter_ack(hw, (struct ieee80211_hdr *)buffer, &stats) &&
 	    mac->mode != IEEE80211_IF_TYPE_MNTR)
 		return 0;
 
@@ -703,14 +702,14 @@ int zd_mac_rx(struct ieee80211_hw *dev, 
 			       &stats, status);*/
 	memcpy(skb_put(skb, length), buffer, length);
 
-	ieee80211_rx_irqsafe(dev, skb, &stats);
+	ieee80211_rx_irqsafe(hw, skb, &stats);
 	return 0;
 }
 
-static int zd_mac_add_interface(struct ieee80211_hw *dev,
+static int zd_mac_add_interface(struct ieee80211_hw *hw,
 				struct ieee80211_if_init_conf *conf)
 {
-	struct zd_mac *mac = zd_dev_mac(dev);
+	struct zd_mac *mac = zd_hw_mac(hw);
 
 	/* NOTE: using IEEE80211_IF_TYPE_MGMT to indicate no mode selected */
 	if (mac->mode != IEEE80211_IF_TYPE_MGMT)
@@ -730,23 +729,23 @@ static int zd_mac_add_interface(struct i
 	return 0;
 }
 
-static void zd_mac_remove_interface(struct ieee80211_hw *dev,
+static void zd_mac_remove_interface(struct ieee80211_hw *hw,
 				    struct ieee80211_if_init_conf *conf)
 {
-	struct zd_mac *mac = zd_dev_mac(dev);
+	struct zd_mac *mac = zd_hw_mac(hw);
 	mac->mode = IEEE80211_IF_TYPE_MGMT;
 }
 
-static int zd_mac_config(struct ieee80211_hw *dev, struct ieee80211_conf *conf)
+static int zd_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
 {
-	struct zd_mac *mac = zd_dev_mac(dev);
+	struct zd_mac *mac = zd_hw_mac(hw);
 	return zd_chip_set_channel(&mac->chip, conf->channel);
 }
 
-static int zd_mac_config_interface(struct ieee80211_hw *dev, int if_id,
+static int zd_mac_config_interface(struct ieee80211_hw *hw, int if_id,
 				   struct ieee80211_if_conf *conf)
 {
-	struct zd_mac *mac = zd_dev_mac(dev);
+	struct zd_mac *mac = zd_hw_mac(hw);
 
 	mac->associated = is_valid_ether_addr(conf->bssid);
 
@@ -767,11 +766,11 @@ static void set_multicast_hash_handler(s
 	zd_chip_set_multicast_hash(&mac->chip, &hash);
 }
 
-static void zd_mac_set_multicast_list(struct ieee80211_hw *dev,
+static void zd_mac_set_multicast_list(struct ieee80211_hw *hw,
 				      unsigned short dev_flags, int mc_count)
 {
 	struct zd_mc_hash hash;
-	struct zd_mac *mac = zd_dev_mac(dev);
+	struct zd_mac *mac = zd_hw_mac(hw);
 	unsigned long flags;
 
 	if (dev_flags & (IFF_PROMISC|IFF_ALLMULTI)) {
@@ -780,7 +779,7 @@ static void zd_mac_set_multicast_list(st
 		struct dev_mc_list *mc = NULL;
 		void *tmp = NULL;
 		zd_mc_clear(&hash);
-		while ((mc = ieee80211_get_mc_list_item(dev, mc, &tmp))) {
+		while ((mc = ieee80211_get_mc_list_item(hw, mc, &tmp))) {
 			dev_dbg_f(zd_mac_dev(mac), "mc addr " MAC_FMT "\n",
 				  MAC_ARG(mc->dmi_addr));
 			zd_mc_add_addr(&hash, mc->dmi_addr);
@@ -804,26 +803,26 @@ static const struct ieee80211_ops zd_ops
 	.set_multicast_list	= zd_mac_set_multicast_list
 };
 
-struct ieee80211_hw *zd_mac_alloc(struct usb_interface *intf)
+struct ieee80211_hw *zd_mac_alloc_hw(struct usb_interface *intf)
 {
 	struct zd_mac *mac;
-	struct ieee80211_hw *dev;
+	struct ieee80211_hw *hw;
 	int i;
 
-	dev = ieee80211_alloc_hw(sizeof(struct zd_mac), &zd_ops);
-	if (!dev) {
+	hw = ieee80211_alloc_hw(sizeof(struct zd_mac), &zd_ops);
+	if (!hw) {
 		dev_dbg_f(&intf->dev, "out of memory\n");
 		return NULL;
 	}
 
-	mac = zd_dev_mac(dev);
+	mac = zd_hw_mac(hw);
 
 	memset(mac, 0, sizeof(*mac));
 	spin_lock_init(&mac->lock);
-	mac->dev = dev;
+	mac->hw = hw;
 
 	mac->mode = IEEE80211_IF_TYPE_MGMT;
-	mac->hwaddr = dev->wiphy->perm_addr;
+	mac->hwaddr = hw->wiphy->perm_addr;
 
 	memcpy(mac->channels, zd_channels, sizeof(zd_channels));
 	memcpy(mac->rates, zd_rates, sizeof(zd_rates));
@@ -838,31 +837,31 @@ struct ieee80211_hw *zd_mac_alloc(struct
 	mac->modes[1].num_channels = ARRAY_SIZE(zd_channels);
 	mac->modes[1].channels = mac->channels;
 
-	dev->flags = IEEE80211_HW_RX_INCLUDES_FCS |
+	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
 		     IEEE80211_HW_WEP_INCLUDE_IV |
 		     IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED;
-	dev->max_rssi = 100;
-	dev->max_signal = 100;
+	hw->max_rssi = 100;
+	hw->max_signal = 100;
 
-	dev->queues = 1;
-	dev->extra_tx_headroom = sizeof(struct zd_ctrlset);
+	hw->queues = 1;
+	hw->extra_tx_headroom = sizeof(struct zd_ctrlset);
 
 	skb_queue_head_init(&mac->ack_wait_queue);
 
 	for (i = 0; i < 2; i++) {
-		if (ieee80211_register_hwmode(dev, &mac->modes[i])) {
+		if (ieee80211_register_hwmode(hw, &mac->modes[i])) {
 			dev_dbg_f(&intf->dev, "cannot register hwmode\n");
-			ieee80211_free_hw(dev);
+			ieee80211_free_hw(hw);
 			return NULL;
 		}
 	}
 
-	zd_chip_init(&mac->chip, dev, intf);
+	zd_chip_init(&mac->chip, hw, intf);
 	housekeeping_init(mac);
 	INIT_WORK(&mac->set_multicast_hash_work, set_multicast_hash_handler);
 
-	SET_IEEE80211_DEV(dev, &intf->dev);
-	return dev;
+	SET_IEEE80211_DEV(hw, &intf->dev);
+	return hw;
 }
 
 #define LINK_LED_WORK_DELAY HZ
Index: wireless-dev/drivers/net/wireless/mac80211/zd1211rw/zd_mac.h
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/zd1211rw/zd_mac.h
+++ wireless-dev/drivers/net/wireless/mac80211/zd1211rw/zd_mac.h
@@ -134,7 +134,7 @@ struct housekeeping {
  */
 struct zd_tx_skb_control_block {
 	struct ieee80211_tx_control *control;
-	struct ieee80211_hw *dev;
+	struct ieee80211_hw *hw;
 	void *context;
 };
 
@@ -145,7 +145,7 @@ struct zd_tx_skb_control_block {
 struct zd_mac {
 	struct zd_chip chip;
 	spinlock_t lock;
-	struct ieee80211_hw *dev;
+	struct ieee80211_hw *hw;
 	struct housekeeping housekeeping;
 	struct work_struct set_multicast_hash_work;
 	struct zd_mc_hash multicast_hash;
@@ -160,9 +160,9 @@ struct zd_mac {
 	struct ieee80211_hw_mode modes[2];
 };
 
-static inline struct zd_mac *zd_dev_mac(struct ieee80211_hw *dev)
+static inline struct zd_mac *zd_hw_mac(struct ieee80211_hw *hw)
 {
-	return dev->priv;
+	return hw->priv;
 }
 
 static inline struct zd_mac *zd_chip_to_mac(struct zd_chip *chip)
@@ -177,14 +177,14 @@ static inline struct zd_mac *zd_usb_to_m
 
 #define zd_mac_dev(mac) (zd_chip_dev(&(mac)->chip))
 
-struct ieee80211_hw *zd_mac_alloc(struct usb_interface *intf);
+struct ieee80211_hw *zd_mac_alloc_hw(struct usb_interface *intf);
 void zd_mac_clear(struct zd_mac *mac);
 
-int zd_mac_preinit_hw(struct ieee80211_hw *dev);
-int zd_mac_init_hw(struct ieee80211_hw *dev);
+int zd_mac_preinit_hw(struct ieee80211_hw *hw);
+int zd_mac_init_hw(struct ieee80211_hw *hw);
 
-int zd_mac_rx(struct ieee80211_hw *dev, const u8 *buffer, unsigned int length);
-void zd_mac_tx_failed(struct ieee80211_hw *dev);
+int zd_mac_rx(struct ieee80211_hw *hw, const u8 *buffer, unsigned int length);
+void zd_mac_tx_failed(struct ieee80211_hw *hw);
 void zd_mac_tx_to_dev(struct sk_buff *skb, int error);
 
 #ifdef DEBUG
Index: wireless-dev/drivers/net/wireless/mac80211/zd1211rw/zd_usb.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/zd1211rw/zd_usb.c
+++ wireless-dev/drivers/net/wireless/mac80211/zd1211rw/zd_usb.c
@@ -383,7 +383,7 @@ static void int_urb_complete(struct urb 
 		handle_regs_int(urb);
 		break;
 	case USB_INT_ID_RETRY_FAILED:
-		zd_mac_tx_failed(zd_usb_to_dev(urb->context));
+		zd_mac_tx_failed(zd_usb_to_hw(urb->context));
 		break;
 	default:
 		dev_dbg_f(urb_dev(urb), "error: urb %p unknown id %x\n", urb,
@@ -540,13 +540,13 @@ static void handle_rx_packet(struct zd_u
 			n = l+k;
 			if (n > length)
 				return;
-			zd_mac_rx(zd_usb_to_dev(usb), buffer+l, k);
+			zd_mac_rx(zd_usb_to_hw(usb), buffer+l, k);
 			if (i >= 2)
 				return;
 			l = (n+3) & ~3;
 		}
 	} else {
-		zd_mac_rx(zd_usb_to_dev(usb), buffer, length);
+		zd_mac_rx(zd_usb_to_hw(usb), buffer, length);
 	}
 }
 
@@ -760,7 +760,7 @@ void zd_usb_enable_tx(struct zd_usb *usb
 	spin_lock_irqsave(&tx->lock, flags);
 	tx->enabled = 1;
 	tx->submitted_urbs = 0;
-	ieee80211_wake_queues(zd_usb_to_dev(usb));
+	ieee80211_wake_queues(zd_usb_to_hw(usb));
 	tx->stopped = 0;
 	spin_unlock_irqrestore(&tx->lock, flags);
 }
@@ -823,7 +823,7 @@ static void tx_dec_submitted_urbs(struct
 	spin_lock_irqsave(&tx->lock, flags);
 	--tx->submitted_urbs;
 	if (tx->stopped && tx->submitted_urbs <= ZD_USB_TX_LOW) {
-		ieee80211_wake_queues(zd_usb_to_dev(usb));
+		ieee80211_wake_queues(zd_usb_to_hw(usb));
 		tx->stopped = 0;
 	}
 	spin_unlock_irqrestore(&tx->lock, flags);
@@ -837,7 +837,7 @@ static void tx_inc_submitted_urbs(struct
 	spin_lock_irqsave(&tx->lock, flags);
 	++tx->submitted_urbs;
 	if (!tx->stopped && tx->submitted_urbs > ZD_USB_TX_HIGH) {
-		ieee80211_stop_queues(zd_usb_to_dev(usb));
+		ieee80211_stop_queues(zd_usb_to_hw(usb));
 		tx->stopped = 1;
 	}
 	spin_unlock_irqrestore(&tx->lock, flags);
@@ -876,7 +876,7 @@ free_urb:
 	skb = (struct sk_buff *)urb->context;
 	zd_mac_tx_to_dev(skb, urb->status);
 	cb = (struct zd_tx_skb_control_block *)skb->cb;
-	usb = &zd_dev_mac(cb->dev)->chip.usb;
+	usb = &zd_hw_mac(cb->hw)->chip.usb;
 	free_tx_urb(usb, urb);
 	tx_dec_submitted_urbs(usb);
 	return;
@@ -958,12 +958,12 @@ static inline void init_usb_tx(struct zd
 	tx->submitted_urbs = 0;
 }
 
-void zd_usb_init(struct zd_usb *usb, struct ieee80211_hw *dev,
+void zd_usb_init(struct zd_usb *usb, struct ieee80211_hw *hw,
 	         struct usb_interface *intf)
 {
 	memset(usb, 0, sizeof(*usb));
 	usb->intf = usb_get_intf(intf);
-	usb_set_intfdata(usb->intf, dev);
+	usb_set_intfdata(usb->intf, hw);
 	init_usb_interrupt(usb);
 	init_usb_tx(usb);
 	init_usb_rx(usb);
@@ -1089,7 +1089,7 @@ int zd_usb_init_hw(struct zd_usb *usb)
 		return r;
 	}
 
-	r = zd_mac_init_hw(mac->dev);
+	r = zd_mac_init_hw(mac->hw);
 	if (r) {
 		dev_dbg_f(zd_usb_dev(usb),
 		         "couldn't initialize mac. Error number %d\n", r);
@@ -1105,7 +1105,7 @@ static int probe(struct usb_interface *i
 	int r;
 	struct usb_device *udev = interface_to_usbdev(intf);
 	struct zd_usb *usb;
-	struct ieee80211_hw *dev = NULL;
+	struct ieee80211_hw *hw = NULL;
 
 	print_id(udev);
 
@@ -1130,23 +1130,23 @@ static int probe(struct usb_interface *i
 		goto error;
 	}
 
-	dev = zd_mac_alloc(intf);
-	if (dev == NULL) {
+	hw = zd_mac_alloc_hw(intf);
+	if (hw == NULL) {
 		r = -ENOMEM;
 		goto error;
 	}
 
-	usb = &zd_dev_mac(dev)->chip.usb;
+	usb = &zd_hw_mac(hw)->chip.usb;
 	usb->is_zd1211b = (id->driver_info == DEVICE_ZD1211B) != 0;
 
-	r = zd_mac_preinit_hw(dev);
+	r = zd_mac_preinit_hw(hw);
 	if (r) {
 		dev_dbg_f(&intf->dev,
 		         "couldn't initialize mac. Error number %d\n", r);
 		goto error;
 	}
 
-	r = ieee80211_register_hw(dev);
+	r = ieee80211_register_hw(hw);
 	if (r) {
 		dev_dbg_f(&intf->dev,
 			 "couldn't register device. Error number %d\n", r);
@@ -1154,34 +1154,34 @@ static int probe(struct usb_interface *i
 	}
 
 	dev_dbg_f(&intf->dev, "successful\n");
-	dev_info(&intf->dev, "%s\n", wiphy_name(dev->wiphy));
+	dev_info(&intf->dev, "%s\n", wiphy_name(hw->wiphy));
 	return 0;
 error:
 	usb_reset_device(interface_to_usbdev(intf));
-	if (dev) {
-		zd_mac_clear(zd_dev_mac(dev));
-		ieee80211_free_hw(dev);
+	if (hw) {
+		zd_mac_clear(zd_hw_mac(hw));
+		ieee80211_free_hw(hw);
 	}
 	return r;
 }
 
 static void disconnect(struct usb_interface *intf)
 {
-	struct ieee80211_hw *dev = zd_intf_to_dev(intf);
+	struct ieee80211_hw *hw = zd_intf_to_hw(intf);
 	struct zd_mac *mac;
 	struct zd_usb *usb;
 
 	/* Either something really bad happened, or we're just dealing with
 	 * a DEVICE_INSTALLER. */
-	if (dev == NULL)
+	if (hw == NULL)
 		return;
 
-	mac = zd_dev_mac(dev);
+	mac = zd_hw_mac(hw);
 	usb = &mac->chip.usb;
 
 	dev_dbg_f(zd_usb_dev(usb), "\n");
 
-	ieee80211_unregister_hw(dev);
+	ieee80211_unregister_hw(hw);
 
 	/* Just in case something has gone wrong! */
 	zd_usb_disable_rx(usb);
@@ -1195,7 +1195,7 @@ static void disconnect(struct usb_interf
 	usb_reset_device(interface_to_usbdev(intf));
 
 	zd_mac_clear(mac);
-	ieee80211_free_hw(dev);
+	ieee80211_free_hw(hw);
 	dev_dbg(&intf->dev, "disconnected\n");
 }
 
Index: wireless-dev/drivers/net/wireless/mac80211/zd1211rw/zd_usb.h
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/zd1211rw/zd_usb.h
+++ wireless-dev/drivers/net/wireless/mac80211/zd1211rw/zd_usb.h
@@ -214,17 +214,17 @@ static inline struct usb_device *zd_usb_
 	return interface_to_usbdev(usb->intf);
 }
 
-static inline struct ieee80211_hw *zd_intf_to_dev(struct usb_interface *intf)
+static inline struct ieee80211_hw *zd_intf_to_hw(struct usb_interface *intf)
 {
 	return usb_get_intfdata(intf);
 }
 
-static inline struct ieee80211_hw *zd_usb_to_dev(struct zd_usb *usb)
+static inline struct ieee80211_hw *zd_usb_to_hw(struct zd_usb *usb)
 {
-	return zd_intf_to_dev(usb->intf);
+	return zd_intf_to_hw(usb->intf);
 }
 
-void zd_usb_init(struct zd_usb *usb, struct ieee80211_hw *dev,
+void zd_usb_init(struct zd_usb *usb, struct ieee80211_hw *hw,
 	         struct usb_interface *intf);
 int zd_usb_init_hw(struct zd_usb *usb);
 void zd_usb_clear(struct zd_usb *usb);
