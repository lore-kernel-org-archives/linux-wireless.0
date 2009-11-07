Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:36229 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579AbZKGRhh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 12:37:37 -0500
Message-ID: <4AF5B061.60701@openwrt.org>
Date: Sat, 07 Nov 2009 18:37:37 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Buesch <mb@bu3sch.de>
Subject: [PATCH] b43: work around a locking issue in ->set_tim()
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ops->set_tim() must be atomic, so b43 trying to acquire a mutex leads
to a kernel crash. This patch trades an easy to trigger crash in AP
mode for an unlikely race condition. According to Michael, the real
fix would be to allow set_tim() to sleep, since b43 is not the only
driver that needs to sleep in all callbacks.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---

--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4534,9 +4534,8 @@ static int b43_op_beacon_set_tim(struct
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);

-	mutex_lock(&wl->mutex);
+	/* FIXME: add locking */
 	b43_update_templates(wl);
-	mutex_unlock(&wl->mutex);

 	return 0;
 }
