Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59603 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757558AbZCWQcg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 12:32:36 -0400
Message-Id: <20090323163053.073748867@sipsolutions.net> (sfid-20090323_173238_689679_6195D70E)
References: <20090323162834.154525349@sipsolutions.net>
Date: Mon, 23 Mar 2009 17:28:40 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 6/8] mac80211: add skb length sanity checking
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We just found a bug in zd1211rw where it would reject
packets in the ->tx() method but leave them modified,
which would cause retransmit attempts with completely
bogus skbs, eventually leading to a panic due to not
having enough headroom in those.

This patch adds a sanity check to mac80211 to catch
such driver mistakes; in this case we warn and drop
the skb.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/tx.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/tx.c	2009-03-23 14:03:46.000000000 +0100
+++ wireless-testing/net/mac80211/tx.c	2009-03-23 14:03:47.000000000 +0100
@@ -1089,7 +1089,7 @@ static int __ieee80211_tx(struct ieee802
 {
 	struct sk_buff *skb = *skbp, *next;
 	struct ieee80211_tx_info *info;
-	int ret;
+	int ret, len;
 	bool fragm = false;
 
 	local->mdev->trans_start = jiffies;
@@ -1125,7 +1125,12 @@ static int __ieee80211_tx(struct ieee802
 		}
 
 		next = skb->next;
+		len = skb->len;
 		ret = local->ops->tx(local_to_hw(local), skb);
+		if (WARN_ON(ret != NETDEV_TX_OK && skb->len != len)) {
+			dev_kfree_skb(skb);
+			ret = NETDEV_TX_OK;
+		}
 		if (ret != NETDEV_TX_OK)
 			return IEEE80211_TX_AGAIN;
 		*skbp = skb = next;

-- 

