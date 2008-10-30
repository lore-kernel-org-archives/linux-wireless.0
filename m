Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:46037 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482AbYJ3SAG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 14:00:06 -0400
Date: Thu, 30 Oct 2008 19:59:05 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211_hwsim: Add support for client PS mode
Message-ID: <20081030175905.GE3923@jm.kir.nu> (sfid-20081030_190013_145086_2678A19A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This introduces a debugfs file (ieee80211/phy#/hwsim/ps) that can be
used to force a simulated radio into power save mode. Following values
can be written into this file to change PS mode:
0 = power save disabled (constantly awake)
1 = power save enabled (drop all frames; do not send PS-Poll)
2 = power save enabled (send PS-Poll frames automatically to receive
    buffered unicast frames); not yet fully implemented
3 = manual PS-Poll trigger (send a single PS-Poll frame)

Two different behavior for power save mode processing can be tested:
- move between modes 1 and 0 (i.e., receive all buffered frames at a
  time)
- move to mode 1 and use manual PS-Poll frames (write 3 to the 'ps'
  debugfs file) to fetch power save buffered frames one at a time

Mode 2 (automatic PS-Poll) does not yet parse Beacon frames, but
eventually, it should take a look at TIM IE and send PS-Poll if a
traffic bit is set for our AID.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

Index: wireless-testing/drivers/net/wireless/mac80211_hwsim.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2008-10-30 19:06:39.000000000 +0200
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2008-10-30 19:07:35.000000000 +0200
@@ -21,6 +21,7 @@
 #include <linux/if_arp.h>
 #include <linux/rtnetlink.h>
 #include <linux/etherdevice.h>
+#include <linux/debugfs.h>
 
 MODULE_AUTHOR("Jouni Malinen");
 MODULE_DESCRIPTION("Software simulator of 802.11 radio(s) for mac80211");
@@ -32,6 +33,9 @@
 
 struct hwsim_vif_priv {
 	u32 magic;
+	u8 bssid[ETH_ALEN];
+	bool assoc;
+	u16 aid;
 };
 
 #define HWSIM_VIF_MAGIC	0x69537748
@@ -132,6 +136,12 @@
 	unsigned int rx_filter;
 	int started;
 	struct timer_list beacon_timer;
+	enum ps_mode {
+		PS_DISABLED, PS_ENABLED, PS_AUTO_POLL, PS_MANUAL_POLL
+	} ps;
+	bool ps_poll_pending;
+	struct dentry *debugfs;
+	struct dentry *debugfs_ps;
 };
 
 
@@ -196,6 +206,34 @@
 }
 
 
+static bool hwsim_ps_rx_ok(struct mac80211_hwsim_data *data,
+			   struct sk_buff *skb)
+{
+	switch (data->ps) {
+	case PS_DISABLED:
+		return true;
+	case PS_ENABLED:
+		return false;
+	case PS_AUTO_POLL:
+		/* TODO: accept (some) Beacons by default and other frames only
+		 * if pending PS-Poll has been sent */
+		return true;
+	case PS_MANUAL_POLL:
+		/* Allow unicast frames to own address if there is a pending
+		 * PS-Poll */
+		if (data->ps_poll_pending &&
+		    memcmp(data->hw->wiphy->perm_addr, skb->data + 4,
+			   ETH_ALEN) == 0) {
+			data->ps_poll_pending = false;
+			return true;
+		}
+		return false;
+	}
+
+	return true;
+}
+
+
 static bool mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
 				    struct sk_buff *skb)
 {
@@ -212,6 +250,9 @@
 	rx_status.rate_idx = info->control.rates[0].idx;
 	/* TODO: simulate signal strength (and optional packet drop) */
 
+	if (data->ps != PS_DISABLED)
+		hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
+
 	/* Copy skb to all enabled radios that are on the current frequency */
 	spin_lock(&hwsim_radio_lock);
 	list_for_each_entry(data2, &hwsim_radios, list) {
@@ -221,6 +262,7 @@
 			continue;
 
 		if (!data2->started || !data2->radio_enabled ||
+		    !hwsim_ps_rx_ok(data2, skb) ||
 		    data->channel->center_freq != data2->channel->center_freq)
 			continue;
 
@@ -406,7 +448,16 @@
 					   struct ieee80211_vif *vif,
 					   struct ieee80211_if_conf *conf)
 {
+	struct hwsim_vif_priv *vp = (void *)vif->drv_priv;
+
 	hwsim_check_magic(vif);
+	if (conf->changed & IEEE80211_IFCC_BSSID) {
+		DECLARE_MAC_BUF(mac);
+		printk(KERN_DEBUG "%s:%s: BSSID changed: %s\n",
+		       wiphy_name(hw->wiphy), __func__,
+		       print_mac(mac, conf->bssid));
+		memcpy(vp->bssid, conf->bssid, ETH_ALEN);
+	}
 	return 0;
 }
 
@@ -415,6 +466,8 @@
 					    struct ieee80211_bss_conf *info,
 					    u32 changed)
 {
+	struct hwsim_vif_priv *vp = (void *)vif->drv_priv;
+
 	hwsim_check_magic(vif);
 
 	printk(KERN_DEBUG "%s:%s(changed=0x%x)\n",
@@ -423,6 +476,8 @@
 	if (changed & BSS_CHANGED_ASSOC) {
 		printk(KERN_DEBUG "  %s: ASSOC: assoc=%d aid=%d\n",
 		       wiphy_name(hw->wiphy), info->assoc, info->aid);
+		vp->assoc = info->assoc;
+		vp->aid = info->aid;
 	}
 
 	if (changed & BSS_CHANGED_ERP_CTS_PROT) {
@@ -520,6 +575,8 @@
 	spin_unlock_bh(&hwsim_radio_lock);
 
 	list_for_each_entry(data, &tmplist, list) {
+		debugfs_remove(data->debugfs_ps);
+		debugfs_remove(data->debugfs);
 		ieee80211_unregister_hw(data->hw);
 		device_unregister(data->dev);
 		ieee80211_free_hw(data->hw);
@@ -545,6 +602,127 @@
 }
 
 
+static void hwsim_send_ps_poll(void *dat, u8 *mac, struct ieee80211_vif *vif)
+{
+	struct mac80211_hwsim_data *data = dat;
+	struct hwsim_vif_priv *vp = (void *)vif->drv_priv;
+	DECLARE_MAC_BUF(buf);
+	struct sk_buff *skb;
+	struct ieee80211_pspoll *pspoll;
+
+	if (!vp->assoc)
+		return;
+
+	printk(KERN_DEBUG "%s:%s: send PS-Poll to %s for aid %d\n",
+	       wiphy_name(data->hw->wiphy), __func__,
+	       print_mac(buf, vp->bssid), vp->aid);
+
+	skb = dev_alloc_skb(sizeof(*pspoll));
+	if (!skb)
+		return;
+	pspoll = (void *) skb_put(skb, sizeof(*pspoll));
+	pspoll->frame_control = cpu_to_le16(IEEE80211_FTYPE_CTL |
+					    IEEE80211_STYPE_PSPOLL |
+					    IEEE80211_FCTL_PM);
+	pspoll->aid = cpu_to_le16(0xc000 | vp->aid);
+	memcpy(pspoll->bssid, vp->bssid, ETH_ALEN);
+	memcpy(pspoll->ta, mac, ETH_ALEN);
+	if (data->radio_enabled &&
+	    !mac80211_hwsim_tx_frame(data->hw, skb))
+		printk(KERN_DEBUG "%s: PS-Poll frame not ack'ed\n", __func__);
+	dev_kfree_skb(skb);
+}
+
+
+static void hwsim_send_nullfunc(struct mac80211_hwsim_data *data, u8 *mac,
+				struct ieee80211_vif *vif, int ps)
+{
+	struct hwsim_vif_priv *vp = (void *)vif->drv_priv;
+	DECLARE_MAC_BUF(buf);
+	struct sk_buff *skb;
+	struct ieee80211_hdr *hdr;
+
+	if (!vp->assoc)
+		return;
+
+	printk(KERN_DEBUG "%s:%s: send data::nullfunc to %s ps=%d\n",
+	       wiphy_name(data->hw->wiphy), __func__,
+	       print_mac(buf, vp->bssid), ps);
+
+	skb = dev_alloc_skb(sizeof(*hdr));
+	if (!skb)
+		return;
+	hdr = (void *) skb_put(skb, sizeof(*hdr) - ETH_ALEN);
+	hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_DATA |
+					 IEEE80211_STYPE_NULLFUNC |
+					 (ps ? IEEE80211_FCTL_PM : 0));
+	hdr->duration_id = cpu_to_le16(0);
+	memcpy(hdr->addr1, vp->bssid, ETH_ALEN);
+	memcpy(hdr->addr2, mac, ETH_ALEN);
+	memcpy(hdr->addr3, vp->bssid, ETH_ALEN);
+	if (data->radio_enabled &&
+	    !mac80211_hwsim_tx_frame(data->hw, skb))
+		printk(KERN_DEBUG "%s: nullfunc frame not ack'ed\n", __func__);
+	dev_kfree_skb(skb);
+}
+
+
+static void hwsim_send_nullfunc_ps(void *dat, u8 *mac,
+				   struct ieee80211_vif *vif)
+{
+	struct mac80211_hwsim_data *data = dat;
+	hwsim_send_nullfunc(data, mac, vif, 1);
+}
+
+
+static void hwsim_send_nullfunc_no_ps(void *dat, u8 *mac,
+				      struct ieee80211_vif *vif)
+{
+	struct mac80211_hwsim_data *data = dat;
+	hwsim_send_nullfunc(data, mac, vif, 0);
+}
+
+
+static int hwsim_fops_ps_read(void *dat, u64 *val)
+{
+	struct mac80211_hwsim_data *data = dat;
+	*val = data->ps;
+	return 0;
+}
+
+static int hwsim_fops_ps_write(void *dat, u64 val)
+{
+	struct mac80211_hwsim_data *data = dat;
+	enum ps_mode old_ps;
+
+	if (val != PS_DISABLED && val != PS_ENABLED && val != PS_AUTO_POLL &&
+	    val != PS_MANUAL_POLL)
+		return -EINVAL;
+
+	old_ps = data->ps;
+	data->ps = val;
+
+	if (val == PS_MANUAL_POLL) {
+		ieee80211_iterate_active_interfaces(data->hw,
+						    hwsim_send_ps_poll, data);
+		data->ps_poll_pending = true;
+	} else if (old_ps == PS_DISABLED && val != PS_DISABLED) {
+		ieee80211_iterate_active_interfaces(data->hw,
+						    hwsim_send_nullfunc_ps,
+						    data);
+	} else if (old_ps != PS_DISABLED && val == PS_DISABLED) {
+		ieee80211_iterate_active_interfaces(data->hw,
+						    hwsim_send_nullfunc_no_ps,
+						    data);
+	}
+
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(hwsim_fops_ps, hwsim_fops_ps_read, hwsim_fops_ps_write,
+			"%llu\n");
+
+
 static int __init init_mac80211_hwsim(void)
 {
 	int i, err = 0;
@@ -637,6 +815,12 @@
 		       wiphy_name(hw->wiphy),
 		       print_mac(mac, hw->wiphy->perm_addr));
 
+		data->debugfs = debugfs_create_dir("hwsim",
+						   hw->wiphy->debugfsdir);
+		data->debugfs_ps = debugfs_create_file("ps", 0666,
+						       data->debugfs, data,
+						       &hwsim_fops_ps);
+
 		setup_timer(&data->beacon_timer, mac80211_hwsim_beacon,
 			    (unsigned long) hw);
 
Index: wireless-testing/include/linux/ieee80211.h
===================================================================
--- wireless-testing.orig/include/linux/ieee80211.h	2008-10-30 19:06:39.000000000 +0200
+++ wireless-testing/include/linux/ieee80211.h	2008-10-30 19:06:54.000000000 +0200
@@ -666,6 +666,13 @@
 	u8 ra[6];
 } __attribute__ ((packed));
 
+struct ieee80211_pspoll {
+	__le16 frame_control;
+	__le16 aid;
+	u8 bssid[6];
+	u8 ta[6];
+} __attribute__ ((packed));
+
 /**
  * struct ieee80211_bar - HT Block Ack Request
  *

-- 
Jouni Malinen                                            PGP id EFC895FA
