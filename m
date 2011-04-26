Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36555 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932374Ab1DZV2J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2011 17:28:09 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] wl12xx: do not set queue_mapping directly
Date: Tue, 26 Apr 2011 23:27:44 +0200
Message-Id: <1303853264-2622-1-git-send-email-hauke@hauke-m.de> (sfid-20110426_232820_342849_6F44978C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is preferred to use the setter that to set queue_mapping directly.
This also helps backporting in compat-wireless.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/wl12xx/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index dad81f6..9d1d4d6 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1293,7 +1293,7 @@ static struct sk_buff *wl12xx_alloc_dummy_packet(struct wl1271 *wl)
 	skb->priority = WL1271_TID_MGMT;
 
 	/* Initialize all fields that might be used */
-	skb->queue_mapping = 0;
+	skb_set_queue_mapping(skb, 0);
 	memset(IEEE80211_SKB_CB(skb), 0, sizeof(struct ieee80211_tx_info));
 
 	return skb;
-- 
1.7.1

