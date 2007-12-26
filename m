Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:48958 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbXLZRFU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Dec 2007 12:05:20 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Fix template upload locking.
Date: Wed, 26 Dec 2007 18:04:14 +0100
Cc: bcm43xx-dev@lists.berlios.de,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200712261804.14899.mb@bu3sch.de> (sfid-20071226_170528_893033_D7E663C3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes the template upload locking.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, this is 2.6.25 stuff.

Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c	2007-12-26 17:57:08.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/main.c	2007-12-26 18:01:03.000000000 +0100
@@ -1303,26 +1303,21 @@ static void b43_write_probe_resp_templat
 	kfree(probe_resp_data);
 }
 
-/* Asynchronously update the packet templates in template RAM. */
+/* Asynchronously update the packet templates in template RAM.
+ * Locking: Requires wl->irq_lock to be locked. */
 static void b43_update_templates(struct b43_wl *wl, struct sk_buff *beacon)
 {
-	unsigned long flags;
-
 	/* This is the top half of the ansynchronous beacon update.
 	 * The bottom half is the beacon IRQ.
 	 * Beacon update must be asynchronous to avoid sending an
 	 * invalid beacon. This can happen for example, if the firmware
 	 * transmits a beacon while we are updating it. */
 
-	spin_lock_irqsave(&wl->irq_lock, flags);
-
 	if (wl->current_beacon)
 		dev_kfree_skb_any(wl->current_beacon);
 	wl->current_beacon = beacon;
 	wl->beacon0_uploaded = 0;
 	wl->beacon1_uploaded = 0;
-
-	spin_unlock_irqrestore(&wl->irq_lock, flags);
 }
 
 static void b43_set_ssid(struct b43_wldev *dev, const u8 * ssid, u8 ssid_len)
@@ -3587,6 +3582,7 @@ static int b43_op_beacon_set_tim(struct 
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct sk_buff *beacon;
+	unsigned long flags;
 
 	/* We could modify the existing beacon and set the aid bit in
 	 * the TIM field, but that would probably require resizing and
@@ -3595,7 +3591,9 @@ static int b43_op_beacon_set_tim(struct 
 	beacon = ieee80211_beacon_get(hw, wl->vif, NULL);
 	if (unlikely(!beacon))
 		return -ENOMEM;
+	spin_lock_irqsave(&wl->irq_lock, flags);
 	b43_update_templates(wl, beacon);
+	spin_unlock_irqrestore(&wl->irq_lock, flags);
 
 	return 0;
 }
@@ -3605,8 +3603,11 @@ static int b43_op_ibss_beacon_update(str
 				     struct ieee80211_tx_control *ctl)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
+	unsigned long flags;
 
+	spin_lock_irqsave(&wl->irq_lock, flags);
 	b43_update_templates(wl, beacon);
+	spin_unlock_irqrestore(&wl->irq_lock, flags);
 
 	return 0;
 }
