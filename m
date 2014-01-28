Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:12033 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054AbaA1IYf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jan 2014 03:24:35 -0500
From: Antonio Quartulli <antonio@meshcoding.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>,
	Antonio Quartulli <antonio@meshcoding.com>
Subject: [PATCH mac80211] cfg80211: use the proper union member when sending a IBSS_JOINED event
Date: Tue, 28 Jan 2014 09:23:03 +0100
Message-Id: <1390897383-3215-1-git-send-email-antonio@meshcoding.com> (sfid-20140128_092453_212848_3A5C3B3B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Antonio Quartulli <antonio@open-mesh.com>

When sending a IBSS_JOINED event the bssid has to be
written into the "ij" member of the event union and not
in "cr".

However this does not really hurt because ij.bssid and
cr.bssid share the same offset in the union.

Signed-off-by: Antonio Quartulli <antonio@meshcoding.com>
---
 net/wireless/ibss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index f911c5f..3fce17e 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -68,7 +68,7 @@ void cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid, gfp_t gfp)
 		return;
 
 	ev->type = EVENT_IBSS_JOINED;
-	memcpy(ev->cr.bssid, bssid, ETH_ALEN);
+	memcpy(ev->ij.bssid, bssid, ETH_ALEN);
 
 	spin_lock_irqsave(&wdev->event_lock, flags);
 	list_add_tail(&ev->list, &wdev->event_list);
-- 
1.8.5.3

