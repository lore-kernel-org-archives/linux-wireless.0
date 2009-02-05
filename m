Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.242]:57006 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbZBEOqJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2009 09:46:09 -0500
Received: by an-out-0708.google.com with SMTP id c2so106307anc.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Feb 2009 06:46:07 -0800 (PST)
Date: Thu, 5 Feb 2009 20:05:15 +0530
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Fix the wrong WARN_ON message appearing on
	enabling power save.
Message-ID: <20090205143343.GA13965@myhost.users.atheros.com> (sfid-20090205_154614_273628_221B299D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This issue happens only when we are associated with a 11n AP and power save
is enabled. In the function 'ieee80211_master_start_xmit', ps_disable_work
is queued where wake_queues is called. But before this work is executed,
we check if the queues are stopped in _ieee80211_tx and return TX_AGAIN to
ieee8011_tx which leads to the warning message.
This patch fixes this erroneous case.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 net/mac80211/tx.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index f1c726d..bf73f6d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -35,6 +35,7 @@
 #define IEEE80211_TX_OK		0
 #define IEEE80211_TX_AGAIN	1
 #define IEEE80211_TX_FRAG_AGAIN	2
+#define IEEE80211_TX_PENDING	3
 
 /* misc utils */
 
@@ -1085,7 +1086,7 @@ static int __ieee80211_tx(struct ieee80211_local *local, struct sk_buff *skb,
 
 	if (skb) {
 		if (netif_subqueue_stopped(local->mdev, skb))
-			return IEEE80211_TX_AGAIN;
+			return IEEE80211_TX_PENDING;
 
 		ret = local->ops->tx(local_to_hw(local), skb);
 		if (ret)
@@ -1211,8 +1212,9 @@ retry:
 		 * queues, there's no reason for a driver to reject
 		 * a frame there, warn and drop it.
 		 */
-		if (WARN_ON(info->flags & IEEE80211_TX_CTL_AMPDU))
-			goto drop;
+		if (ret != IEEE80211_TX_PENDING)
+			if (WARN_ON(info->flags & IEEE80211_TX_CTL_AMPDU))
+				goto drop;
 
 		store = &local->pending_packet[queue];
 
-- 
1.6.0.1

