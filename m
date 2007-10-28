Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:45002
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbXJ1UK0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Oct 2007 16:10:26 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43legacy: Remove set_key callback
Date: Sun, 28 Oct 2007 21:08:51 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200710282108.52078.mb@bu3sch.de> (sfid-20071028_201029_843953_BB6AB57A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We don't need the set_key callback, as we don't do hw crypto.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: linux-2.6/drivers/net/wireless/b43legacy/main.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/b43legacy/main.c
+++ linux-2.6/drivers/net/wireless/b43legacy/main.c
@@ -2603,32 +2603,6 @@ out_unlock_mutex:
 	return err;
 }
 
-static int b43legacy_dev_set_key(struct ieee80211_hw *hw,
-				 enum set_key_cmd cmd,
-				 const u8 *local_addr, const u8 *addr,
-				 struct ieee80211_key_conf *key)
-{
-	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
-	struct b43legacy_wldev *dev = wl->current_dev;
-	unsigned long flags;
-	int err = -EOPNOTSUPP;
-	DECLARE_MAC_BUF(mac);
-
-	if (!dev)
-		return -ENODEV;
-	mutex_lock(&wl->mutex);
-	spin_lock_irqsave(&wl->irq_lock, flags);
-
-	if (b43legacy_status(dev) < B43legacy_STAT_INITIALIZED) {
-		err = -ENODEV;
-	}
-	spin_unlock_irqrestore(&wl->irq_lock, flags);
-	mutex_unlock(&wl->mutex);
-	b43legacydbg(wl, "Using software based encryption for "
-		     "mac: %s\n", print_mac(mac, addr));
-	return err;
-}
-
 static void b43legacy_configure_filter(struct ieee80211_hw *hw,
 				       unsigned int changed,
 				       unsigned int *fflags,
@@ -3284,7 +3258,6 @@ static const struct ieee80211_ops b43leg
 	.remove_interface = b43legacy_remove_interface,
 	.config = b43legacy_dev_config,
 	.config_interface = b43legacy_config_interface,
-	.set_key = b43legacy_dev_set_key,
 	.configure_filter = b43legacy_configure_filter,
 	.get_stats = b43legacy_get_stats,
 	.get_tx_stats = b43legacy_get_tx_stats,

-- 
Greetings Michael.
