Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1610 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232AbZDECLI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Apr 2009 22:11:08 -0400
From: Bob Copeland <me@bobcopeland.com>
To: kalle.valo@nokia.com
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 4/6] wl12xx: update tx API usage
Date: Sat,  4 Apr 2009 22:10:26 -0400
Message-Id: <1238897428-19639-5-git-send-email-me@bobcopeland.com> (sfid-20090405_041129_754934_E67A9E6A)
In-Reply-To: <1238897428-19639-1-git-send-email-me@bobcopeland.com>
References: <1238897428-19639-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update wl12xx to use the new fields in ieee80211_tx_info.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/wl12xx/tx.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 3ce5562..99151b3 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -361,14 +361,11 @@ static void wl12xx_tx_packet_cb(struct wl12xx *wl,
 
 	info = IEEE80211_SKB_CB(skb);
 
-	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK)) {
-		if (result->status == TX_SUCCESS)
-			info->flags |= IEEE80211_TX_STAT_ACK;
-		if (result->status & TX_RETRY_EXCEEDED)
-			info->status.excessive_retries = 1;
-	}
+	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK) &&
+	    (result->status == TX_SUCCESS))
+		info->flags |= IEEE80211_TX_STAT_ACK;
 
-	info->status.retry_count = result->ack_failures;
+	info->status.rates[0].count = result->ack_failures + 1;
 
 	/*
 	 * We have to remove our private TX header before pushing
-- 
1.6.0.6


