Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f53.google.com ([209.85.216.53]:63833 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715Ab2BSTyT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Feb 2012 14:54:19 -0500
Received: by qafk1 with SMTP id k1so5304244qaf.19
        for <linux-wireless@vger.kernel.org>; Sun, 19 Feb 2012 11:54:18 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 19 Feb 2012 20:54:18 +0100
Message-ID: <CAFmNhL=zp66TRZvi0e=05zJuFjm=pon1gKHXJYN6_uUs_erm4g@mail.gmail.com> (sfid-20120219_205423_101096_8F611F4A)
Subject: [PATCH] rtl8187: Add Ad-hoc mode
From: Attila Fazekas <turul64@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Herton Ronaldo Krzesinski <herton@canonical.com>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add AD-HOC support to the rtl8187 based on the rtl8180 source

Signed-off-by: Attila Fazekas <turul64@gmail.com>
---
diff --git a/drivers/net/wireless/rtl818x/rtl8187/dev.c
b/drivers/net/wireless/rtl818x/rtl8187/dev.c
index 638fbef..f8f9186 100644
--- a/drivers/net/wireless/rtl818x/rtl8187/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187/dev.c
@@ -232,6 +232,7 @@ static void rtl8187_tx(struct ieee80211_hw *dev,
struct sk_buff *skb)
 {
 	struct rtl8187_priv *priv = dev->priv;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *tx_hdr = 	(struct ieee80211_hdr *)(skb->data);
 	unsigned int ep;
 	void *buf;
 	struct urb *urb;
@@ -249,7 +250,7 @@ static void rtl8187_tx(struct ieee80211_hw *dev,
struct sk_buff *skb)
 	flags |= RTL818X_TX_DESC_FLAG_NO_ENC;

 	flags |= ieee80211_get_tx_rate(dev, info)->hw_value << 24;
-	if (ieee80211_has_morefrags(((struct ieee80211_hdr
*)skb->data)->frame_control))
+	if (ieee80211_has_morefrags(tx_hdr->frame_control))
 		flags |= RTL818X_TX_DESC_FLAG_MOREFRAG;
 	if (info->control.rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS) {
 		flags |= RTL818X_TX_DESC_FLAG_RTS;
@@ -261,6 +262,13 @@ static void rtl8187_tx(struct ieee80211_hw *dev,
struct sk_buff *skb)
 		flags |= ieee80211_get_rts_cts_rate(dev, info)->hw_value << 19;
 	}

+	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
+		if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
+			priv->seqno += 0x10;
+		tx_hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
+		tx_hdr->seq_ctrl |= cpu_to_le16(priv->seqno);
+	}
+
 	if (!priv->is_rtl8187b) {
 		struct rtl8187_tx_hdr *hdr =
 			(struct rtl8187_tx_hdr *)skb_push(skb, sizeof(*hdr));
@@ -274,8 +282,6 @@ static void rtl8187_tx(struct ieee80211_hw *dev,
struct sk_buff *skb)
 	} else {
 		/* fc needs to be calculated before skb_push() */
 		unsigned int epmap[4] = { 6, 7, 5, 4 };
-		struct ieee80211_hdr *tx_hdr =
-			(struct ieee80211_hdr *)(skb->data);
 		u16 fc = le16_to_cpu(tx_hdr->frame_control);

 		struct rtl8187b_tx_hdr *hdr =
@@ -1031,10 +1037,61 @@ static void rtl8187_stop(struct ieee80211_hw *dev)
 		cancel_delayed_work_sync(&priv->work);
 }

+static u64 rtl8187_get_tsf(struct ieee80211_hw *dev, struct ieee80211_vif *vif)
+{
+	struct rtl8187_priv *priv = dev->priv;
+
+	return rtl818x_ioread32(priv, &priv->map->TSFT[0]) |
+	       (u64)(rtl818x_ioread32(priv, &priv->map->TSFT[1])) << 32;
+}
+
+
+static void rtl8187_beacon_work(struct work_struct *work)
+{
+        struct rtl8187_vif *vif_priv =
+                container_of(work, struct rtl8187_vif, beacon_work.work);
+        struct ieee80211_vif *vif =
+                container_of((void *)vif_priv, struct ieee80211_vif, drv_priv);
+        struct ieee80211_hw *dev = vif_priv->dev;
+        struct ieee80211_mgmt *mgmt;
+        struct sk_buff *skb;
+
+        /* don't overflow the tx ring */
+        if (ieee80211_queue_stopped(dev, 0))
+                goto resched;
+
+        /* grab a fresh beacon */
+        skb = ieee80211_beacon_get(dev, vif);
+        if (!skb)
+                goto resched;
+
+        /*
+         * update beacon timestamp w/ TSF value
+         * TODO: make hardware update beacon timestamp
+         */
+        mgmt = (struct ieee80211_mgmt *)skb->data;
+        mgmt->u.beacon.timestamp = cpu_to_le64(rtl8187_get_tsf(dev, vif));
+
+        /* TODO: use actual beacon queue */
+        skb_set_queue_mapping(skb, 0);
+
+        rtl8187_tx(dev, skb);
+
+resched:
+        /*
+         * schedule next beacon
+         * TODO: use hardware support for beacon timing
+         */
+        schedule_delayed_work(&vif_priv->beacon_work,
+                        usecs_to_jiffies(1024 * vif->bss_conf.beacon_int));
+}
+
+
 static int rtl8187_add_interface(struct ieee80211_hw *dev,
 				 struct ieee80211_vif *vif)
 {
 	struct rtl8187_priv *priv = dev->priv;
+	struct rtl8187_vif *vif_priv;
 	int i;
 	int ret = -EOPNOTSUPP;

@@ -1044,6 +1101,7 @@ static int rtl8187_add_interface(struct ieee80211_hw *dev,

 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_ADHOC:
 		break;
 	default:
 		goto exit;
@@ -1052,6 +1110,13 @@ static int rtl8187_add_interface(struct
ieee80211_hw *dev,
 	ret = 0;
 	priv->vif = vif;

+        /* Initialize driver private area */
+        vif_priv = (struct rtl8187_vif *)&vif->drv_priv;
+        vif_priv->dev = dev;
+        INIT_DELAYED_WORK(&vif_priv->beacon_work, rtl8187_beacon_work);
+        vif_priv->enable_beacon = false;
+
+
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
 	for (i = 0; i < ETH_ALEN; i++)
 		rtl818x_iowrite8(priv, &priv->map->MAC[i],
@@ -1175,9 +1240,12 @@ static void rtl8187_bss_info_changed(struct
ieee80211_hw *dev,
 				     u32 changed)
 {
 	struct rtl8187_priv *priv = dev->priv;
+	struct rtl8187_vif *vif_priv;
 	int i;
 	u8 reg;

+	vif_priv = (struct rtl8187_vif *)&vif->drv_priv;
+
 	if (changed & BSS_CHANGED_BSSID) {
 		mutex_lock(&priv->conf_mutex);
 		for (i = 0; i < ETH_ALEN; i++)
@@ -1189,8 +1257,12 @@ static void rtl8187_bss_info_changed(struct
ieee80211_hw *dev,
 		else
 			reg = 0;

-		if (is_valid_ether_addr(info->bssid))
-			reg |= RTL818X_MSR_INFRA;
+		if (is_valid_ether_addr(info->bssid)) {
+                        if (vif->type == NL80211_IFTYPE_ADHOC)
+                                reg |= RTL818X_MSR_ADHOC;
+                        else
+                                reg |= RTL818X_MSR_INFRA;
+		}
 		else
 			reg |= RTL818X_MSR_NO_LINK;

@@ -1202,6 +1274,16 @@ static void rtl8187_bss_info_changed(struct
ieee80211_hw *dev,
 	if (changed & (BSS_CHANGED_ERP_SLOT | BSS_CHANGED_ERP_PREAMBLE))
 		rtl8187_conf_erp(priv, info->use_short_slot,
 				 info->use_short_preamble);
+
+        if (changed & BSS_CHANGED_BEACON_ENABLED)
+                vif_priv->enable_beacon = info->enable_beacon;
+
+        if (changed & (BSS_CHANGED_BEACON_ENABLED | BSS_CHANGED_BEACON)) {
+                cancel_delayed_work_sync(&vif_priv->beacon_work);
+                if (vif_priv->enable_beacon)
+                        schedule_work(&vif_priv->beacon_work.work);
+        }
+	
 }

 static u64 rtl8187_prepare_multicast(struct ieee80211_hw *dev,
@@ -1279,13 +1361,6 @@ static int rtl8187_conf_tx(struct ieee80211_hw *dev,
 	return 0;
 }

-static u64 rtl8187_get_tsf(struct ieee80211_hw *dev, struct ieee80211_vif *vif)
-{
-	struct rtl8187_priv *priv = dev->priv;
-
-	return rtl818x_ioread32(priv, &priv->map->TSFT[0]) |
-	       (u64)(rtl818x_ioread32(priv, &priv->map->TSFT[1])) << 32;
-}

 static const struct ieee80211_ops rtl8187_ops = {
 	.tx			= rtl8187_tx,
@@ -1514,12 +1589,9 @@ static int __devinit rtl8187_probe(struct
usb_interface *intf,
 		if (reg & 0xFF00)
 			priv->rfkill_mask = RFKILL_MASK_8198;
 	}
-
-	/*
-	 * XXX: Once this driver supports anything that requires
-	 *	beacons it must implement IEEE80211_TX_CTL_ASSIGN_SEQ.
-	 */
-	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
+	dev->vif_data_size = sizeof(struct rtl8187_vif);
+	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
+				      BIT(NL80211_IFTYPE_ADHOC) ;

 	if ((id->driver_info == DEVICE_RTL8187) && priv->is_rtl8187b)
 		printk(KERN_INFO "rtl8187: inconsistency between id with OEM"
diff --git a/drivers/net/wireless/rtl818x/rtl8187/rtl8187.h
b/drivers/net/wireless/rtl818x/rtl8187/rtl8187.h
index f1cc907..a63eafe 100644
--- a/drivers/net/wireless/rtl818x/rtl8187/rtl8187.h
+++ b/drivers/net/wireless/rtl818x/rtl8187/rtl8187.h
@@ -89,6 +89,14 @@ enum {
 	DEVICE_RTL8187B
 };

+struct rtl8187_vif {
+        struct ieee80211_hw *dev;
+
+        /* beaconing */
+        struct delayed_work beacon_work;
+        bool enable_beacon;
+};
+
 struct rtl8187_priv {
 	/* common between rtl818x drivers */
 	struct rtl818x_csr *map;
@@ -141,6 +149,7 @@ struct rtl8187_priv {
 		__le32 bits32;
 	} *io_dmabuf;
 	bool rfkill_off;
+	u16 seqno;
 };

 void rtl8187_write_phy(struct ieee80211_hw *dev, u8 addr, u32 data);
