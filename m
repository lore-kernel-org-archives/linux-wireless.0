Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:55544
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759595AbXJOMzf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 08:55:35 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: Fwd: [-mm Patch] drivers/net/wireless/b43legacy/main.c: initialize the correct return value
Date: Mon, 15 Oct 2007 14:54:45 +0200
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	WANG Cong <xiyou.wangcong@gmail.com>,
	Adrian Bunk <bunk@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200710151454.46047.mb@bu3sch.de> (sfid-20071015_135551_256929_8905D379)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Adrian Bunk <bunk@kernel.org>

Initialize "err" in drivers/net/wireless/b43legacy/main.c::b43legacy_start()
in case of returning an uninitialized value.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Michael Buesch <mb@bu3sch.de>

---
 drivers/net/wireless/b43/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.23-mm1/drivers/net/wireless/b43legacy/main.c
===================================================================
--- linux-2.6.23-mm1.orig/drivers/net/wireless/b43legacy/main.c
+++ linux-2.6.23-mm1/drivers/net/wireless/b43legacy/main.c
@@ -3306,7 +3306,7 @@ static int b43legacy_start(struct ieee80
 	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
 	struct b43legacy_wldev *dev = wl->current_dev;
 	int did_init = 0;
-	int err;
+	int err = 0;
 
 	mutex_lock(&wl->mutex);
 


-------------------------------------------------------

-- 
Greetings Michael.
