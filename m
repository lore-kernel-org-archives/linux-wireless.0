Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:34523 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbcBJPIV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Feb 2016 10:08:21 -0500
Received: by mail-wm0-f50.google.com with SMTP id 128so30754954wmz.1
        for <linux-wireless@vger.kernel.org>; Wed, 10 Feb 2016 07:08:20 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH] mac80211: fix wiphy supported_band access
Date: Wed, 10 Feb 2016 16:08:17 +0100
Message-Id: <1455116897-24811-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20160210_160826_933626_EB1410E5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix wiphy supported_band access in tx radiotap parsing. In particular,
info->band is always set to 0 (IEEE80211_BAND_2GHZ) since it has not
assigned yet. This cause a kernel crash on 5GHz only devices.
Move ieee80211_parse_tx_radiotap() after info->band assignment

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 net/mac80211/tx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 7bb67fa..b07d037 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1892,10 +1892,6 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 	info->flags = IEEE80211_TX_CTL_REQ_TX_STATUS |
 		      IEEE80211_TX_CTL_INJECTED;
 
-	/* process and remove the injection radiotap header */
-	if (!ieee80211_parse_tx_radiotap(local, skb))
-		goto fail;
-
 	rcu_read_lock();
 
 	/*
@@ -1957,6 +1953,10 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 		goto fail_rcu;
 
 	info->band = chandef->chan->band;
+	/* process and remove the injection radiotap header */
+	if (!ieee80211_parse_tx_radiotap(local, skb))
+		goto fail_rcu;
+
 	ieee80211_xmit(sdata, NULL, skb);
 	rcu_read_unlock();
 
-- 
2.5.0

