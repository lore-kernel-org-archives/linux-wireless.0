Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:54634 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbZBELQn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2009 06:16:43 -0500
Received: by wf-out-1314.google.com with SMTP id 28so241262wfa.4
        for <linux-wireless@vger.kernel.org>; Thu, 05 Feb 2009 03:16:42 -0800 (PST)
Date: Thu, 5 Feb 2009 16:36:31 +0530
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Fix the wrong WARN_ON message appearing on
	enabling power save.
Message-ID: <20090205110631.GA13746@myhost.users.atheros.com> (sfid-20090205_121647_697221_4D18A79B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The warning message intended to be hit on driver's rejection of a Tx frame
is also hit while the netif_subqueue is stopped. This patch fixes this error
case.

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

