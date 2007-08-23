Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-03.rdc-kc.rr.com ([24.94.166.129]:51123 "EHLO
	ms-smtp-03.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760304AbXHWXGS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2007 19:06:18 -0400
Date: Thu, 23 Aug 2007 18:05:40 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] b43, b43legacy: Fix inconsistency between branches 'b43'  and 'everything' in wireless-dev
Message-ID: <46ce12c4.2TC1IuG0LDupBuDr%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

One of Johannes's 27 patches changed the definition of the set_key callback.
Because his change got applied to the 'everything' branch, and the changes in the
b43 drivers to the 'b43' branch, the drivers in that branch are out of synch and an
"initialization from incompatible pointer type" warning is generated. When this patch
is applied to branch 'b43', it is internally consistent.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

I'm not sure how to handle this. In it's present state, branch 'b43' cannot be used
to generate a working version of b43 or b43legacy. In addition,  the Kconfig and Makefile
from b43legacy are not included, thus it is not possible to build b43legacy
in that branch.

Larry

  
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 9a0cf2b..19e9cf1 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2861,8 +2861,8 @@ static int b43_dev_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
 }
 
 static int b43_dev_set_key(struct ieee80211_hw *hw,
-			   set_key_cmd cmd, const u8 *local_addr,
-			   const u8 *addr, struct ieee80211_key_conf *key)
+			   set_key_cmd cmd, u8 *addr,
+			   struct ieee80211_key_conf *key, int aid)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev = wl->current_dev;
diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index 980cb81..f9d6938 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -2686,9 +2686,8 @@ out_unlock_mutex:
 }
 
 static int b43legacy_dev_set_key(struct ieee80211_hw *hw,
-				 set_key_cmd cmd,
-				 const u8 *local_addr, const u8 *addr,
-				 struct ieee80211_key_conf *key)
+				 set_key_cmd cmd, u8 *addr,
+				 struct ieee80211_key_conf *key, int aid)
 {
 	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
 	struct b43legacy_wldev *dev = wl->current_dev;

