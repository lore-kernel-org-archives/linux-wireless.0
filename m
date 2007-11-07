Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:56626
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758275AbXKGUW2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2007 15:22:28 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43legacy: Fix sparse warning
Date: Wed, 7 Nov 2007 21:21:55 +0100
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200711072121.55828.mb@bu3sch.de> (sfid-20071107_202259_140457_DCAE6644)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix a sparse warning about a nonstatic function.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Note that this patch might collide with Stefano's recently
sent patches. But it should be trivial enough to fix that.

Index: wireless-2.6/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/main.c	2007-11-07 20:31:06.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43legacy/main.c	2007-11-07 20:47:36.000000000 +0100
@@ -3238,7 +3238,7 @@ out_mutex_unlock:
 	return err;
 }
 
-void b43legacy_stop(struct ieee80211_hw *hw)
+static void b43legacy_stop(struct ieee80211_hw *hw)
 {
 	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
 	struct b43legacy_wldev *dev = wl->current_dev;
