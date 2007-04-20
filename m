Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([198.107.51.143]:3020 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754315AbXDTC3y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2007 22:29:54 -0400
Message-ID: <4628259E.7060105@canonical.com>
Date: Thu, 19 Apr 2007 20:29:50 -0600
From: Tim Gardner <tim.gardner@canonical.com>
MIME-Version: 1.0
To: linville@tuxdriver.com
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: PATCH [001/001] - Remove duplicate rtnl_unlock()
Content-Type: multipart/mixed;
 boundary="------------080607000204020607040402"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080607000204020607040402
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


Remove a duplicate rtnl_unlock().

Signed-off-by: tim.gardner@ubuntu.com

---

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index b5a62b7..cf3d020 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -4816,7 +4816,6 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	rtnl_lock();
 	result = dev_alloc_name(local->mdev, local->mdev->name);
 	if (result < 0) {
-		rtnl_unlock();
 		goto fail_dev;
 	}

-- 
Tim Gardner tim.gardner@ubuntu.com

--------------080607000204020607040402
Content-Type: text/plain;
 name="duplicate_unlock.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="duplicate_unlock.txt"


Remove a duplicate rtnl_unlock().

Signed-off-by: tim.gardner@ubuntu.com

---

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index b5a62b7..cf3d020 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -4816,7 +4816,6 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	rtnl_lock();
 	result = dev_alloc_name(local->mdev, local->mdev->name);
 	if (result < 0) {
-		rtnl_unlock();
 		goto fail_dev;
 	}
 

--------------080607000204020607040402--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
