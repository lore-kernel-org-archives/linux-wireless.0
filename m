Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60329 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933575Ab0EDUAc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 May 2010 16:00:32 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: herton@mandriva.com.br, htl10@users.sourceforge.net,
	Larry.Finger@lwfinger.net,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rtl8187: use SET_IEEE80211_PERM_ADDR
Date: Tue,  4 May 2010 15:53:29 -0400
Message-Id: <1273002809-8595-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/rtl818x/rtl8187_dev.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index 0fb850e..ef66a5e 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -1332,6 +1332,7 @@ static int __devinit rtl8187_probe(struct usb_interface *intf,
 	u16 txpwr, reg;
 	u16 product_id = le16_to_cpu(udev->descriptor.idProduct);
 	int err, i;
+	u8 mac_addr[ETH_ALEN];
 
 	dev = ieee80211_alloc_hw(sizeof(*priv), &rtl8187_ops);
 	if (!dev) {
@@ -1389,12 +1390,13 @@ static int __devinit rtl8187_probe(struct usb_interface *intf,
 	udelay(10);
 
 	eeprom_93cx6_multiread(&eeprom, RTL8187_EEPROM_MAC_ADDR,
-			       (__le16 __force *)dev->wiphy->perm_addr, 3);
-	if (!is_valid_ether_addr(dev->wiphy->perm_addr)) {
+			       (__le16 __force *)mac_addr, 3);
+	if (!is_valid_ether_addr(mac_addr)) {
 		printk(KERN_WARNING "rtl8187: Invalid hwaddr! Using randomly "
 		       "generated MAC address\n");
-		random_ether_addr(dev->wiphy->perm_addr);
+		random_ether_addr(mac_addr);
 	}
+	SET_IEEE80211_PERM_ADDR(dev, mac_addr);
 
 	channel = priv->channels;
 	for (i = 0; i < 3; i++) {
@@ -1525,7 +1527,7 @@ static int __devinit rtl8187_probe(struct usb_interface *intf,
 	skb_queue_head_init(&priv->b_tx_status.queue);
 
 	printk(KERN_INFO "%s: hwaddr %pM, %s V%d + %s, rfkill mask %d\n",
-	       wiphy_name(dev->wiphy), dev->wiphy->perm_addr,
+	       wiphy_name(dev->wiphy), mac_addr,
 	       chip_name, priv->asic_rev, priv->rf->name, priv->rfkill_mask);
 
 #ifdef CONFIG_RTL8187_LEDS
-- 
1.6.6.1

