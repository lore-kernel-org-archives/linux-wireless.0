Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:47692 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472Ab0EONqX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 May 2010 09:46:23 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH] cfg80211: fix crash in cfg80211_set_freq()
Date: Sat, 15 May 2010 15:46:17 +0200
Message-Id: <1273931177-26887-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since wdev can be NULL, check it before dereferencing it

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/wireless/chan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index d92d088..b01a6f6 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -50,7 +50,7 @@ int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
 	struct ieee80211_channel *chan;
 	int result;
 
-	if (wdev->iftype == NL80211_IFTYPE_MONITOR)
+	if (wdev && wdev->iftype == NL80211_IFTYPE_MONITOR)
 		wdev = NULL;
 
 	if (wdev) {
-- 
1.6.4.2

