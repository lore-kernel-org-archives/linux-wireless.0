Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web57403.mail.re1.yahoo.com ([66.196.100.54]:37904 "HELO
	web57403.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750843Ab1COPxI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 11:53:08 -0400
Message-ID: <297417.86150.qm@web57403.mail.re1.yahoo.com>
Date: Tue, 15 Mar 2011 08:53:05 -0700 (PDT)
From: Joe Gunn <armadefuego@yahoo.com>
Subject: [PATCH 2.6.38-rc8-wl 1/1] orinoco:  Reduce lock contention by reporting static errors before locking
To: orinoco-devel@lists.sourceforge.net
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check for static error issues before obtaining lock to reduce lock contention
Signed-off-by: Joseph J. Gunn <armadefuego@yahoo.com>
---
diff --git a/drivers/net/wireless/orinoco/wext.c b/drivers/net/wireless/orinoco/wext.c
index e793679..c1fe0b5 100644
--- a/drivers/net/wireless/orinoco/wext.c
+++ b/drivers/net/wireless/orinoco/wext.c
@@ -161,36 +161,17 @@ static int orinoco_ioctl_setwap(struct net_device *dev,
 	static const u8 off_addr[] = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
 	static const u8 any_addr[] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
 
-	if (orinoco_lock(priv, &flags) != 0)
-		return -EBUSY;
-
-	/* Enable automatic roaming - no sanity checks are needed */
-	if (memcmp(&ap_addr->sa_data, off_addr, ETH_ALEN) == 0 ||
-	    memcmp(&ap_addr->sa_data, any_addr, ETH_ALEN) == 0) {
-		priv->bssid_fixed = 0;
-		memset(priv->desired_bssid, 0, ETH_ALEN);
-
-		/* "off" means keep existing connection */
-		if (ap_addr->sa_data[0] == 0) {
-			__orinoco_hw_set_wap(priv);
-			err = 0;
-		}
-		goto out;
-	}
-
 	if (priv->firmware_type == FIRMWARE_TYPE_AGERE) {
 		printk(KERN_WARNING "%s: Lucent/Agere firmware doesn't "
 		       "support manual roaming\n",
 		       dev->name);
-		err = -EOPNOTSUPP;
-		goto out;
+		return(-EOPNOTSUPP);
 	}
 
 	if (priv->iw_mode != NL80211_IFTYPE_STATION) {
 		printk(KERN_WARNING "%s: Manual roaming supported only in "
 		       "managed mode\n", dev->name);
-		err = -EOPNOTSUPP;
-		goto out;
+		return(-EOPNOTSUPP);
 	}
 
 	/* Intersil firmware hangs without Desired ESSID */
@@ -198,10 +179,27 @@ static int orinoco_ioctl_setwap(struct net_device *dev,
 	    strlen(priv->desired_essid) == 0) {
 		printk(KERN_WARNING "%s: Desired ESSID must be set for "
 		       "manual roaming\n", dev->name);
-		err = -EOPNOTSUPP;
+		return(-EOPNOTSUPP);
+	}
+
+	if (orinoco_lock(priv, &flags) != 0)
+		return -EBUSY;
+
+	/* Enable automatic roaming - no sanity checks are needed */
+	if (memcmp(&ap_addr->sa_data, off_addr, ETH_ALEN) == 0 ||
+	    memcmp(&ap_addr->sa_data, any_addr, ETH_ALEN) == 0) {
+		priv->bssid_fixed = 0;
+		memset(priv->desired_bssid, 0, ETH_ALEN);
+
+		/* "off" means keep existing connection */
+		if (ap_addr->sa_data[0] == 0) {
+			__orinoco_hw_set_wap(priv);
+			err = 0;
+		}
 		goto out;
 	}
 
+
 	/* Finally, enable manual roaming */
 	priv->bssid_fixed = 1;
 	memcpy(priv->desired_bssid, &ap_addr->sa_data, ETH_ALEN);



      
