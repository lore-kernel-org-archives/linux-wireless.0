Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:47268 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753621AbYGDDtn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2008 23:49:43 -0400
From: Daniel Drake <dsd@gentoo.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] zd1211rw: ad-hoc connectivity
Message-Id: <20080704033117.4EDD872C001@zog.reactivated.net> (sfid-20080704_055011_400933_219B0478)
Date: Fri,  4 Jul 2008 04:31:17 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis Carlos Cobo recently added beacon config code (to support mesh)
which happens also to be most of the work needed to support ad-hoc.
This patch does the rest.

Signed-off-by: Daniel Drake <dsd@gentoo.org>

Index: linux-2.6.26-rc8/drivers/net/wireless/zd1211rw/zd_chip.c
===================================================================
--- linux-2.6.26-rc8.orig/drivers/net/wireless/zd1211rw/zd_chip.c
+++ linux-2.6.26-rc8/drivers/net/wireless/zd1211rw/zd_chip.c
@@ -809,7 +809,6 @@ static int hw_init_hmac(struct zd_chip *
 		{ CR_AFTER_PNP,			0x1 },
 		{ CR_WEP_PROTECT,		0x114 },
 		{ CR_IFS_VALUE,			IFS_VALUE_DEFAULT },
-		{ CR_CAM_MODE,			MODE_AP_WDS},
 	};
 
 	ZD_ASSERT(mutex_is_locked(&chip->mutex));
Index: linux-2.6.26-rc8/drivers/net/wireless/zd1211rw/zd_mac.c
===================================================================
--- linux-2.6.26-rc8.orig/drivers/net/wireless/zd1211rw/zd_mac.c
+++ linux-2.6.26-rc8/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -761,10 +761,24 @@ int zd_mac_rx(struct ieee80211_hw *hw, c
 	return 0;
 }
 
+static int set_cam_mode(struct zd_mac *mac)
+{
+	/* AP_WDS is used for mesh mode as it causes the device to acknowledge
+	 * 4-address frames. It is also used for managed mode as there are
+	 * no adverse effects. */
+	u32 mode = MODE_AP_WDS;
+
+	if (mac->type == IEEE80211_IF_TYPE_IBSS)
+		mode = MODE_IBSS;
+
+	return zd_iowrite32(&mac->chip, CR_CAM_MODE, mode);
+}
+
 static int zd_op_add_interface(struct ieee80211_hw *hw,
 				struct ieee80211_if_init_conf *conf)
 {
 	struct zd_mac *mac = zd_hw_mac(hw);
+	int r;
 
 	/* using IEEE80211_IF_TYPE_INVALID to indicate no mode selected */
 	if (mac->type != IEEE80211_IF_TYPE_INVALID)
@@ -773,6 +787,7 @@ static int zd_op_add_interface(struct ie
 	switch (conf->type) {
 	case IEEE80211_IF_TYPE_MNTR:
 	case IEEE80211_IF_TYPE_MESH_POINT:
+	case IEEE80211_IF_TYPE_IBSS:
 	case IEEE80211_IF_TYPE_STA:
 		mac->type = conf->type;
 		break;
@@ -780,6 +795,12 @@ static int zd_op_add_interface(struct ie
 		return -EOPNOTSUPP;
 	}
 
+	if (conf->type != IEEE80211_IF_TYPE_MNTR) {
+		r = set_cam_mode(mac);
+		if (r < 0)
+			return r;
+	}
+
 	return zd_write_mac_addr(&mac->chip, conf->mac_addr);
 }
 
@@ -805,7 +826,9 @@ static int zd_op_config_interface(struct
 	int associated;
 	int r;
 
-	if (mac->type == IEEE80211_IF_TYPE_MESH_POINT) {
+	switch (mac->type) {
+	case IEEE80211_IF_TYPE_MESH_POINT:
+	case IEEE80211_IF_TYPE_IBSS:
 		associated = true;
 		if (conf->beacon) {
 			r = zd_mac_config_beacon(hw, conf->beacon);
@@ -817,8 +840,11 @@ static int zd_op_config_interface(struct
 				return r;
 			kfree_skb(conf->beacon);
 		}
-	} else
+		break;
+
+	default:
 		associated = is_valid_ether_addr(conf->bssid);
+	}
 
 	spin_lock_irq(&mac->lock);
 	mac->associated = associated;
@@ -969,6 +995,24 @@ static void zd_op_bss_info_changed(struc
 	}
 }
 
+static int zd_op_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
+	struct ieee80211_tx_control *control)
+{
+	struct zd_mac *mac = zd_hw_mac(hw);
+	int r;
+
+	r = zd_mac_config_beacon(hw, skb);
+	if (r < 0)
+		return r;
+	r = zd_set_beacon_interval(&mac->chip,
+		BCN_MODE_IBSS | hw->conf.beacon_int);
+	if (r < 0)
+		return r;
+
+	kfree_skb(skb);
+	return 0;
+}
+
 static const struct ieee80211_ops zd_ops = {
 	.tx			= zd_op_tx,
 	.start			= zd_op_start,
@@ -979,6 +1023,7 @@ static const struct ieee80211_ops zd_ops
 	.config_interface	= zd_op_config_interface,
 	.configure_filter	= zd_op_configure_filter,
 	.bss_info_changed	= zd_op_bss_info_changed,
+	.beacon_update		= zd_op_beacon_update,
 };
 
 struct ieee80211_hw *zd_mac_alloc_hw(struct usb_interface *intf)
