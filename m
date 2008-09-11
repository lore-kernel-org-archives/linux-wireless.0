Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51604 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175AbYIKWj6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 18:39:58 -0400
Subject: [PATCH v2] mac80211 hwsim: make radio list dynamic
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <1221172622.5956.10.camel@johannes.berg> (sfid-20080912_003741_082920_D8B45771)
References: <1221172622.5956.10.camel@johannes.berg>
	 (sfid-20080912_003741_082920_D8B45771)
Content-Type: text/plain
Date: Fri, 12 Sep 2008 00:39:22 +0200
Message-Id: <1221172762.5956.13.camel@johannes.berg> (sfid-20080912_004001_947386_64403F69)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This paves the way for dynamic radio additions while the module
is loaded. Also restrict the number of radios to 100 because
creating that many already takes forever.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/mac80211_hwsim.c |   84 +++++++++++++++++-----------------
 1 file changed, 44 insertions(+), 40 deletions(-)

--- everything.orig/drivers/net/wireless/mac80211_hwsim.c	2008-09-12 00:34:26.000000000 +0200
+++ everything/drivers/net/wireless/mac80211_hwsim.c	2008-09-12 00:38:51.000000000 +0200
@@ -14,6 +14,8 @@
  * - RX filtering based on filter configuration (data->rx_filter)
  */
 
+#include <linux/list.h>
+#include <linux/spinlock.h>
 #include <net/mac80211.h>
 #include <net/ieee80211_radiotap.h>
 #include <linux/if_arp.h>
@@ -78,8 +80,6 @@ static inline void hwsim_clear_sta_magic
 
 static struct class *hwsim_class;
 
-static struct ieee80211_hw **hwsim_radios;
-static int hwsim_radio_count;
 static struct net_device *hwsim_mon; /* global monitor netdev */
 
 
@@ -115,7 +115,12 @@ static const struct ieee80211_rate hwsim
 	{ .bitrate = 540 }
 };
 
+static spinlock_t hwsim_radio_lock;
+static struct list_head hwsim_radios;
+
 struct mac80211_hwsim_data {
+	struct list_head list;
+	struct ieee80211_hw *hw;
 	struct device *dev;
 	struct ieee80211_supported_band band;
 	struct ieee80211_channel channels[ARRAY_SIZE(hwsim_channels)];
@@ -191,11 +196,11 @@ static void mac80211_hwsim_monitor_rx(st
 }
 
 
-static int mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
-				   struct sk_buff *skb)
+static bool mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
+				    struct sk_buff *skb)
 {
-	struct mac80211_hwsim_data *data = hw->priv;
-	int i, ack = 0;
+	struct mac80211_hwsim_data *data = hw->priv, *data2;
+	bool ack = false;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_rx_status rx_status;
@@ -208,13 +213,13 @@ static int mac80211_hwsim_tx_frame(struc
 	/* TODO: simulate signal strength (and optional packet drop) */
 
 	/* Copy skb to all enabled radios that are on the current frequency */
-	for (i = 0; i < hwsim_radio_count; i++) {
-		struct mac80211_hwsim_data *data2;
+	spin_lock(&hwsim_radio_lock);
+	list_for_each_entry(data2, &hwsim_radios, list) {
 		struct sk_buff *nskb;
 
-		if (hwsim_radios[i] == NULL || hwsim_radios[i] == hw)
+		if (data == data2)
 			continue;
-		data2 = hwsim_radios[i]->priv;
+
 		if (!data2->started || !data2->radio_enabled ||
 		    data->channel->center_freq != data2->channel->center_freq)
 			continue;
@@ -223,11 +228,12 @@ static int mac80211_hwsim_tx_frame(struc
 		if (nskb == NULL)
 			continue;
 
-		if (memcmp(hdr->addr1, hwsim_radios[i]->wiphy->perm_addr,
+		if (memcmp(hdr->addr1, data2->hw->wiphy->perm_addr,
 			   ETH_ALEN) == 0)
-			ack = 1;
-		ieee80211_rx_irqsafe(hwsim_radios[i], nskb, &rx_status);
+			ack = true;
+		ieee80211_rx_irqsafe(data2->hw, nskb, &rx_status);
 	}
+	spin_unlock(&hwsim_radio_lock);
 
 	return ack;
 }
@@ -236,7 +242,7 @@ static int mac80211_hwsim_tx_frame(struc
 static int mac80211_hwsim_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct mac80211_hwsim_data *data = hw->priv;
-	int ack;
+	bool ack;
 	struct ieee80211_tx_info *txi;
 
 	mac80211_hwsim_monitor_rx(hw, skb);
@@ -457,18 +463,21 @@ static const struct ieee80211_ops mac802
 
 static void mac80211_hwsim_free(void)
 {
-	int i;
+	struct list_head tmplist, *i, *tmp;
+	struct mac80211_hwsim_data *data;
 
-	for (i = 0; i < hwsim_radio_count; i++) {
-		if (hwsim_radios[i]) {
-			struct mac80211_hwsim_data *data;
-			data = hwsim_radios[i]->priv;
-			ieee80211_unregister_hw(hwsim_radios[i]);
-			device_unregister(data->dev);
-			ieee80211_free_hw(hwsim_radios[i]);
-		}
+	INIT_LIST_HEAD(&tmplist);
+
+	spin_lock_bh(&hwsim_radio_lock);
+	list_for_each_safe(i, tmp, &hwsim_radios)
+		list_move(i, &tmplist);
+	spin_unlock_bh(&hwsim_radio_lock);
+
+	list_for_each_entry(data, &tmplist, list) {
+		ieee80211_unregister_hw(data->hw);
+		device_unregister(data->dev);
+		ieee80211_free_hw(data->hw);
 	}
-	kfree(hwsim_radios);
 	class_destroy(hwsim_class);
 }
 
@@ -498,37 +507,32 @@ static int __init init_mac80211_hwsim(vo
 	struct ieee80211_hw *hw;
 	DECLARE_MAC_BUF(mac);
 
-	if (radios < 1 || radios > 65535)
+	if (radios < 1 || radios > 100)
 		return -EINVAL;
 
-	hwsim_radio_count = radios;
-	hwsim_radios = kcalloc(hwsim_radio_count,
-			       sizeof(struct ieee80211_hw *), GFP_KERNEL);
-	if (hwsim_radios == NULL)
-		return -ENOMEM;
+	spin_lock_init(&hwsim_radio_lock);
+	INIT_LIST_HEAD(&hwsim_radios);
 
 	hwsim_class = class_create(THIS_MODULE, "mac80211_hwsim");
-	if (IS_ERR(hwsim_class)) {
-		kfree(hwsim_radios);
+	if (IS_ERR(hwsim_class))
 		return PTR_ERR(hwsim_class);
-	}
 
 	memset(addr, 0, ETH_ALEN);
 	addr[0] = 0x02;
 
-	for (i = 0; i < hwsim_radio_count; i++) {
+	for (i = 0; i < radios; i++) {
 		printk(KERN_DEBUG "mac80211_hwsim: Initializing radio %d\n",
 		       i);
 		hw = ieee80211_alloc_hw(sizeof(*data), &mac80211_hwsim_ops);
-		if (hw == NULL) {
+		if (!hw) {
 			printk(KERN_DEBUG "mac80211_hwsim: ieee80211_alloc_hw "
 			       "failed\n");
 			err = -ENOMEM;
 			goto failed;
 		}
-		hwsim_radios[i] = hw;
-
 		data = hw->priv;
+		data->hw = hw;
+
 		data->dev = device_create_drvdata(hwsim_class, NULL, 0, hw,
 						"hwsim%d", i);
 		if (IS_ERR(data->dev)) {
@@ -590,6 +594,8 @@ static int __init init_mac80211_hwsim(vo
 
 		setup_timer(&data->beacon_timer, mac80211_hwsim_beacon,
 			    (unsigned long) hw);
+
+		list_add_tail(&data->list, &hwsim_radios);
 	}
 
 	hwsim_mon = alloc_netdev(0, "hwsim%d", hwsim_mon_setup);
@@ -621,7 +627,6 @@ failed_hw:
 	device_unregister(data->dev);
 failed_drvdata:
 	ieee80211_free_hw(hw);
-	hwsim_radios[i] = NULL;
 failed:
 	mac80211_hwsim_free();
 	return err;
@@ -630,8 +635,7 @@ failed:
 
 static void __exit exit_mac80211_hwsim(void)
 {
-	printk(KERN_DEBUG "mac80211_hwsim: unregister %d radios\n",
-	       hwsim_radio_count);
+	printk(KERN_DEBUG "mac80211_hwsim: unregister radios\n");
 
 	unregister_netdev(hwsim_mon);
 	mac80211_hwsim_free();


