Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49953 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946623AbXBIQd3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Feb 2007 11:33:29 -0500
Received: from [84.135.215.182] (helo=johannes.berg)
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.63)
	(envelope-from <johannes@sipsolutions.net>)
	id 1HFYdP-0003bu-IX
	for linux-wireless@vger.kernel.org; Fri, 09 Feb 2007 16:30:04 +0000
Message-Id: <20070209162528.027486000@sipsolutions.net>
References: <20070209162414.043158000@sipsolutions.net>
Date: Fri, 09 Feb 2007 17:24:18 +0100
From: johannes@sipsolutions.net
To: linux-wireless@vger.kernel.org
Subject: [PATCH 4/5] zd1211rw-d80211: update for wiphy api
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

update zd1211rw-d80211.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 drivers/net/wireless/d80211/zd1211rw/zd_mac.c |    6 +++---
 drivers/net/wireless/d80211/zd1211rw/zd_usb.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

--- wireless-dev.orig/drivers/net/wireless/d80211/zd1211rw/zd_mac.c	2007-02-09 17:08:20.773840519 +0100
+++ wireless-dev/drivers/net/wireless/d80211/zd1211rw/zd_mac.c	2007-02-09 17:08:56.243840519 +0100
@@ -54,7 +54,7 @@ int zd_mac_init_hw(struct ieee80211_hw *
 		goto disable_int;
 	ZD_ASSERT(!irqs_disabled());
 	spin_lock_irq(&mac->lock);
-	memcpy(dev->perm_addr, addr, ETH_ALEN);
+	SET_IEEE80211_PERM_ADDR(dev, addr);
 	spin_unlock_irq(&mac->lock);
 
 	r = zd_read_regdomain(chip, &default_regdomain);
@@ -589,7 +589,7 @@ struct ieee80211_hw *zd_mac_alloc(struct
 	mac->dev = dev;
 
 	mac->mode = IEEE80211_IF_TYPE_MGMT;
-	mac->hwaddr = dev->perm_addr;
+	mac->hwaddr = dev->wiphy->perm_addr;
 	mac->requested_channel = 1;
 
 	memcpy(mac->channels, zd_channels, sizeof(zd_channels));
@@ -625,7 +625,7 @@ struct ieee80211_hw *zd_mac_alloc(struct
 	housekeeping_init(mac);
 
 	SET_MODULE_OWNER(dev);
-	dev->dev = &intf->dev;
+	SET_IEEE80211_DEV(dev, &intf->dev);
 	return dev;
 }
 
--- wireless-dev.orig/drivers/net/wireless/d80211/zd1211rw/zd_usb.c	2007-02-09 17:08:21.003840519 +0100
+++ wireless-dev/drivers/net/wireless/d80211/zd1211rw/zd_usb.c	2007-02-09 17:08:56.253840519 +0100
@@ -1062,7 +1062,7 @@ static int probe(struct usb_interface *i
 	}
 
 	dev_dbg_f(&intf->dev, "successful\n");
-	dev_info(&intf->dev,"wiphy%d\n", dev->index);
+	dev_info(&intf->dev,"wiphy%d\n", dev->wiphy->wiphy_index);
 	return 0;
 error:
 	usb_reset_device(interface_to_usbdev(intf));

--

