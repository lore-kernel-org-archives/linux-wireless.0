Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55679 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab1LZXbV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Dec 2011 18:31:21 -0500
Received: by iaeh11 with SMTP id h11so19487095iae.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Dec 2011 15:31:21 -0800 (PST)
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	Stanislav Yakovlev <stas.yakovlev@gmail.com>
Subject: [PATCH] ipw2x00: remove reset_port functionality
Date: Mon, 26 Dec 2011 18:31:11 -0500
Message-Id: <1324942271-1286-1-git-send-email-stas.yakovlev@gmail.com> (sfid-20111227_003140_780737_AEDE716D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removes reset_port since it isn't used anywhere as suggested by Johannes Berg.

Signed-off-by: Stanislav Yakovlev <stas.yakovlev@gmail.com>
---
 drivers/net/wireless/ipw2x00/libipw.h    |    4 ----
 drivers/net/wireless/ipw2x00/libipw_wx.c |   25 -------------------------
 2 files changed, 0 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/libipw.h b/drivers/net/wireless/ipw2x00/libipw.h
index 3d5821e..8874588 100644
--- a/drivers/net/wireless/ipw2x00/libipw.h
+++ b/drivers/net/wireless/ipw2x00/libipw.h
@@ -805,9 +805,6 @@ struct libipw_device {
 	/* WEP and other encryption related settings at the device level */
 	int open_wep;		/* Set to 1 to allow unencrypted frames */
 
-	int reset_on_keychange;	/* Set to 1 if the HW needs to be reset on
-				 * WEP key changes */
-
 	/* If the host performs {en,de}cryption, then set to 1 */
 	int host_encrypt;
 	int host_encrypt_msdu;
@@ -860,7 +857,6 @@ struct libipw_device {
 			      struct libipw_security * sec);
 	netdev_tx_t (*hard_start_xmit) (struct libipw_txb * txb,
 					struct net_device * dev, int pri);
-	int (*reset_port) (struct net_device * dev);
 	int (*is_queue_full) (struct net_device * dev, int pri);
 
 	int (*handle_management) (struct net_device * dev,
diff --git a/drivers/net/wireless/ipw2x00/libipw_wx.c b/drivers/net/wireless/ipw2x00/libipw_wx.c
index 6623e50..1571505 100644
--- a/drivers/net/wireless/ipw2x00/libipw_wx.c
+++ b/drivers/net/wireless/ipw2x00/libipw_wx.c
@@ -474,17 +474,6 @@ int libipw_wx_set_encode(struct libipw_device *ieee,
 	if (ieee->set_security)
 		ieee->set_security(dev, &sec);
 
-	/* Do not reset port if card is in Managed mode since resetting will
-	 * generate new IEEE 802.11 authentication which may end up in looping
-	 * with IEEE 802.1X.  If your hardware requires a reset after WEP
-	 * configuration (for example... Prism2), implement the reset_port in
-	 * the callbacks structures used to initialize the 802.11 stack. */
-	if (ieee->reset_on_keychange &&
-	    ieee->iw_mode != IW_MODE_INFRA &&
-	    ieee->reset_port && ieee->reset_port(dev)) {
-		printk(KERN_DEBUG "%s: reset_port failed\n", dev->name);
-		return -EINVAL;
-	}
 	return 0;
 }
 
@@ -688,20 +677,6 @@ int libipw_wx_set_encodeext(struct libipw_device *ieee,
 	if (ieee->set_security)
 		ieee->set_security(ieee->dev, &sec);
 
-	/*
-	 * Do not reset port if card is in Managed mode since resetting will
-	 * generate new IEEE 802.11 authentication which may end up in looping
-	 * with IEEE 802.1X. If your hardware requires a reset after WEP
-	 * configuration (for example... Prism2), implement the reset_port in
-	 * the callbacks structures used to initialize the 802.11 stack.
-	 */
-	if (ieee->reset_on_keychange &&
-	    ieee->iw_mode != IW_MODE_INFRA &&
-	    ieee->reset_port && ieee->reset_port(dev)) {
-		LIBIPW_DEBUG_WX("%s: reset_port failed\n", dev->name);
-		return -EINVAL;
-	}
-
 	return ret;
 }
 
-- 
1.7.2.5

