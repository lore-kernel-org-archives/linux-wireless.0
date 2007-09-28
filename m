Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.237]:4022 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbXI1Q7v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2007 12:59:51 -0400
Received: by wx-out-0506.google.com with SMTP id h31so2438637wxd
        for <linux-wireless@vger.kernel.org>; Fri, 28 Sep 2007 09:59:50 -0700 (PDT)
Date: Fri, 28 Sep 2007 13:01:09 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] Adds configure_filter() support for zd1211rw-mac80211
Message-ID: <20070928170109.GC5687@pogo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Resending.. it seems my mail setup isn't quite right yet..

This patch:

* Moves driver to new start() / stop()
* Removes the old zd_op_set_multicast_list()
* Adds the new configure_filter() support
* Fixes compile errors as it depends on the removed DECLARE_MAC_BUF, 
  and print_mac()

This has been tested, and applies to the 'everything' branch of wireless-2.6.

Cc: Daniel Drake <dsd@gentoo.org>
Cc: Ulrich Kunitz <kune@deine-taler.de>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Wu <flamingice@sourmilk.net>

Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>

---

 drivers/net/wireless/zd1211rw-mac80211/zd_chip.c |    9 +++-
 drivers/net/wireless/zd1211rw-mac80211/zd_mac.c  |   53 ++++++++++++++-------
 2 files changed, 42 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw-mac80211/zd_chip.c b/drivers/net/wireless/zd1211rw-mac80211/zd_chip.c
index 0dc75c2..d3a578b 100644
--- a/drivers/net/wireless/zd1211rw-mac80211/zd_chip.c
+++ b/drivers/net/wireless/zd1211rw-mac80211/zd_chip.c
@@ -377,7 +377,9 @@ int zd_write_mac_addr(struct zd_chip *chip, const u8 *mac_addr)
 		[0] = { .addr = CR_MAC_ADDR_P1 },
 		[1] = { .addr = CR_MAC_ADDR_P2 },
 	};
-	DECLARE_MAC_BUF(mac);
+	/* Add back later when this is added */
+	//DECLARE_MAC_BUF(mac);
+	char mac[18];
 
 	reqs[0].value = (mac_addr[3] << 24)
 		      | (mac_addr[2] << 16)
@@ -386,8 +388,11 @@ int zd_write_mac_addr(struct zd_chip *chip, const u8 *mac_addr)
 	reqs[1].value = (mac_addr[5] <<  8)
 		      |  mac_addr[4];
 
+	/* same here, add back when print_mac() is added */
 	dev_dbg_f(zd_chip_dev(chip),
-		"mac addr %s\n", print_mac(mac, mac_addr));
+	//	"mac addr %s\n", print_mac(mac, mac_addr));
+		"mac addr %s\n", MAC_FMT, MAC_ARG(mac));
+
 
 	mutex_lock(&chip->mutex);
 	r = zd_iowrite32a_locked(chip, reqs, ARRAY_SIZE(reqs));
diff --git a/drivers/net/wireless/zd1211rw-mac80211/zd_mac.c b/drivers/net/wireless/zd1211rw-mac80211/zd_mac.c
index 017c3b7..158507d 100644
--- a/drivers/net/wireless/zd1211rw-mac80211/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw-mac80211/zd_mac.c
@@ -1,5 +1,7 @@
 /* zd_mac.c
  *
+ * Copyright (c) 2007 Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
@@ -206,7 +208,7 @@ static int set_mc_hash(struct zd_mac *mac)
 	return zd_chip_set_multicast_hash(&mac->chip, &hash);
 }
 
-static int zd_op_open(struct ieee80211_hw *hw)
+static int zd_op_start(struct ieee80211_hw *hw)
 {
 	struct zd_mac *mac = zd_hw_mac(hw);
 	struct zd_chip *chip = &mac->chip;
@@ -290,7 +292,7 @@ static void kfree_tx_skb(struct sk_buff *skb)
 	dev_kfree_skb_any(skb);
 }
 
-static int zd_op_stop(struct ieee80211_hw *hw)
+void zd_op_stop(struct ieee80211_hw *hw)
 {
 	struct zd_mac *mac = zd_hw_mac(hw);
 	struct zd_chip *chip = &mac->chip;
@@ -313,8 +315,6 @@ static int zd_op_stop(struct ieee80211_hw *hw)
 
 	while ((skb = skb_dequeue(ack_wait_queue)))
 		kfree_tx_skb(skb);
-
-	return 0;
 }
 
 /**
@@ -765,27 +765,44 @@ static void set_multicast_hash_handler(struct work_struct *work)
 	zd_chip_set_multicast_hash(&mac->chip, &hash);
 }
 
-static void zd_op_set_multicast_list(struct ieee80211_hw *hw,
-				      unsigned short dev_flags, int mc_count)
+#define SUPPORTED_FIF_FLAGS \
+	FIF_PROMISC_IN_BSS | FIF_ALLMULTI
+static void zd_op_configure_filter(struct ieee80211_hw *hw,
+			unsigned int changed_flags,
+			unsigned int *new_flags,
+			int mc_count, struct dev_mc_list *mclist)
 {
 	struct zd_mc_hash hash;
 	struct zd_mac *mac = zd_hw_mac(hw);
 	unsigned long flags;
+	int i;
 
-	if ((dev_flags & (IFF_PROMISC|IFF_ALLMULTI)) ||
-	     has_monitor_interfaces(mac))
-	{
+	/* Only deal with supported flags */
+	changed_flags &= SUPPORTED_FIF_FLAGS;
+	*new_flags &= SUPPORTED_FIF_FLAGS;
+
+	/* changed_flags is always populated but this driver
+	 * doesn't support all FIF flags so its possible we don't
+	 * need to do anything */
+	if (!changed_flags)
+		return;
+		
+	if ((*new_flags & (FIF_PROMISC_IN_BSS | FIF_ALLMULTI)) ||
+	     has_monitor_interfaces(mac)) {
 		zd_mc_add_all(&hash);
 	} else {
-		struct dev_mc_list *mc = NULL;
-		void *tmp = NULL;
-		DECLARE_MAC_BUF(macbuf);
-
+		/* we can add this if added back later, this is 
+		 * char macbuf[18] */
+		//DECLARE_MAC_BUF(macbuf);
 		zd_mc_clear(&hash);
-		while ((mc = ieee80211_get_mc_list_item(hw, mc, &tmp))) {
+		for (i = 0; i < mc_count; i++) {
+			if (!mclist)
+				break;
 			dev_dbg_f(zd_mac_dev(mac), "mc addr %s\n",
-				  print_mac(macbuf, mc->dmi_addr));
-			zd_mc_add_addr(&hash, mc->dmi_addr);
+				  //print_mac(macbuf, mclist->dmi_addr));
+				  MAC_FMT, MAC_ARG(mclist->dmi_addr));
+			zd_mc_add_addr(&hash, mclist->dmi_addr);
+			mclist = mclist->next;
 		}
 	}
 
@@ -836,13 +853,13 @@ static void zd_op_erp_ie_changed(struct ieee80211_hw *hw, u8 changes,
 
 static const struct ieee80211_ops zd_ops = {
 	.tx			= zd_op_tx,
-	.open			= zd_op_open,
+	.start			= zd_op_start,
 	.stop			= zd_op_stop,
 	.add_interface		= zd_op_add_interface,
 	.remove_interface	= zd_op_remove_interface,
 	.config			= zd_op_config,
 	.config_interface	= zd_op_config_interface,
-	.set_multicast_list	= zd_op_set_multicast_list,
+	.configure_filter	= zd_op_configure_filter,
 	.erp_ie_changed		= zd_op_erp_ie_changed,
 };
 
