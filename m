Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([198.107.51.143]:2154 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754311AbXDWWDj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2007 18:03:39 -0400
Received: from rtg (unknown [10.0.2.5])
	by mail.tpi.com (Postfix) with ESMTP id CC7F4B2D38
	for <linux-wireless@vger.kernel.org>; Mon, 23 Apr 2007 14:30:30 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Subject: [PATCH 001/001 - Remove duplicate rtnl_unlock(), try #2
Message-Id: <20070423213322.36ECB411F@rtg>
Date: Mon, 23 Apr 2007 15:33:22 -0600 (MDT)
From: "rtg@timg"@tpi.com (Tim Gardner)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Remove nested rtnl_unlock().

modified:   net/mac80211/ieee80211.c

Signed-off-by: Tim Gardner <tim.gardner@ubuntu.com>
---
 net/mac80211/ieee80211.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 3587cd4..64476f9 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -4815,10 +4815,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 
 	rtnl_lock();
 	result = dev_alloc_name(local->mdev, local->mdev->name);
-	if (result < 0) {
-		rtnl_unlock();
+	if (result < 0)
 		goto fail_dev;
-	}
 
 	memcpy(local->mdev->dev_addr, local->hw.wiphy->perm_addr, ETH_ALEN);
 	SET_NETDEV_DEV(local->mdev, wiphy_dev(local->hw.wiphy));
-- 
1.4.4.2

