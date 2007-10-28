Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:38127
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbXJ1PB6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Oct 2007 11:01:58 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Dereference of wl->current_dev must be protected by wl->mutex
Date: Sun, 28 Oct 2007 15:59:58 +0100
Cc: bcm43xx-dev@lists.berlios.de,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200710281559.59012.mb@bu3sch.de> (sfid-20071028_150201_890418_5B9A14A4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Put all access to wl->current_dev under protection of the mutex.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <larry.finger@lwfinger.net>

Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c	2007-10-28 15:46:24.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/main.c	2007-10-28 15:54:55.000000000 +0100
@@ -2813,18 +2813,25 @@ static int b43_dev_set_key(struct ieee80
 			   struct ieee80211_key_conf *key)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
-	struct b43_wldev *dev = wl->current_dev;
+	struct b43_wldev *dev;
 	unsigned long flags;
 	u8 algorithm;
 	u8 index;
-	int err = -EINVAL;
+	int err;
 	DECLARE_MAC_BUF(mac);
 
 	if (modparam_nohwcrypt)
 		return -ENOSPC; /* User disabled HW-crypto */
 
-	if (!dev)
-		return -ENODEV;
+	mutex_lock(&wl->mutex);
+	spin_lock_irqsave(&wl->irq_lock, flags);
+
+	dev = wl->current_dev;
+	err = -ENODEV;
+	if (!dev || b43_status(dev) < B43_STAT_INITIALIZED)
+		goto out_unlock;
+
+	err = -EINVAL;
 	switch (key->alg) {
 	case ALG_WEP:
 		if (key->keylen == 5)
@@ -2840,20 +2847,11 @@ static int b43_dev_set_key(struct ieee80
 		break;
 	default:
 		B43_WARN_ON(1);
-		goto out;
+		goto out_unlock;
 	}
-
 	index = (u8) (key->keyidx);
 	if (index > 3)
-		goto out;
-
-	mutex_lock(&wl->mutex);
-	spin_lock_irqsave(&wl->irq_lock, flags);
-
-	if (b43_status(dev) < B43_STAT_INITIALIZED) {
-		err = -ENODEV;
 		goto out_unlock;
-	}
 
 	switch (cmd) {
 	case SET_KEY:
