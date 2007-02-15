Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43666 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965739AbXBOPAA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 10:00:00 -0500
Message-Id: <20070215144300.025457000@sipsolutions.net>
References: <20070215144241.847938000@sipsolutions.net>
Date: Thu, 15 Feb 2007 15:42:49 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: John Linville <linville@tuxdriver.com>, Jiri Benc <jbenc@suse.cz>
Subject: [PATCH 08/10] zd1211rw-d80211: update for wiphy api
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

update zd1211rw-d80211.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 drivers/net/wireless/d80211/zd1211rw/zd_mac.c |    6 +++---
 drivers/net/wireless/d80211/zd1211rw/zd_usb.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

--- wireless-dev.orig/drivers/net/wireless/d80211/zd1211rw/zd_mac.c	2007-02-15 13:25:17.567940064 +0100
+++ wireless-dev/drivers/net/wireless/d80211/zd1211rw/zd_mac.c	2007-02-15 13:25:36.357940064 +0100
@@ -53,7 +53,7 @@ int zd_mac_init_hw(struct ieee80211_hw *
 		goto disable_int;
 	ZD_ASSERT(!irqs_disabled());
 	spin_lock_irq(&mac->lock);
-	memcpy(dev->perm_addr, addr, ETH_ALEN);
+	SET_IEEE80211_PERM_ADDR(dev, addr);
 	spin_unlock_irq(&mac->lock);
 
 	r = zd_read_regdomain(chip, &default_regdomain);
@@ -628,7 +628,7 @@ struct ieee80211_hw *zd_mac_alloc(struct
 	mac->dev = dev;
 
 	mac->mode = IEEE80211_IF_TYPE_MGMT;
-	mac->hwaddr = dev->perm_addr;
+	mac->hwaddr = dev->wiphy->perm_addr;
 	mac->requested_channel = 1;
 
 	memcpy(mac->channels, zd_channels, sizeof(zd_channels));
@@ -664,7 +664,7 @@ struct ieee80211_hw *zd_mac_alloc(struct
 	housekeeping_init(mac);
 	INIT_WORK(&mac->set_multicast_hash_work, set_multicast_hash_handler);
 
-	dev->dev = &intf->dev;
+	SET_IEEE80211_DEV(dev, &intf->dev);
 	return dev;
 }
 
--- wireless-dev.orig/drivers/net/wireless/d80211/zd1211rw/zd_usb.c	2007-02-15 13:25:17.657940064 +0100
+++ wireless-dev/drivers/net/wireless/d80211/zd1211rw/zd_usb.c	2007-02-15 13:25:53.167940064 +0100
@@ -955,7 +955,7 @@ static int probe(struct usb_interface *i
 	}
 
 	dev_dbg_f(&intf->dev, "successful\n");
-	dev_info(&intf->dev,"wiphy%d\n", dev->index);
+	dev_info(&intf->dev, "%s\n", wiphy_name(dev->wiphy));
 	return 0;
 error:
 	usb_reset_device(interface_to_usbdev(intf));

--

