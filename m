Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:54737 "EHLO silver.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965130AbXBSWj3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 17:39:29 -0500
From: Jiri Benc <jbenc@suse.cz>
To: "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20070219233919.221549000.midnight@suse.cz>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 12/12] d80211: fix incorrect hw.priv setting in ieee80211_alloc_hw()
Message-Id: <20070219223958.4B41A484B3@silver.suse.cz>
Date: Mon, 19 Feb 2007 23:39:58 +0100 (CET)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pavel Roskin <proski@gnu.org>

hw.priv is set twice, and the second time it's set incorrectly to an
area relative to the master device, which wasn't allocated for private
data.

Signed-off-by: Pavel Roskin <proski@gnu.org>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Jiri Benc <jbenc@suse.cz>

---

 net/d80211/ieee80211.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

36d7bfa99c55b8b59fa49d5d6a030a470cecaaa0
diff --git a/net/d80211/ieee80211.c b/net/d80211/ieee80211.c
index a6afe89..93e8090 100644
--- a/net/d80211/ieee80211.c
+++ b/net/d80211/ieee80211.c
@@ -4556,9 +4556,6 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	mdev->ieee80211_ptr = &sdata->wdev;
 	sdata->wdev.wiphy = wiphy;
 
-	local->hw.priv = (char *)mdev->priv +
-			 ((sizeof(struct ieee80211_sub_if_data) +
-			   NETDEV_ALIGN_CONST) & ~NETDEV_ALIGN_CONST);
 	local->hw.queues = 1; /* default */
 
 	local->mdev = mdev;
-- 
1.3.0

