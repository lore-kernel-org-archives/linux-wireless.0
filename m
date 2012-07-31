Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39137 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004Ab2GaLqh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2012 07:46:37 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 10/10] mac80211: clean up ieee80211_subif_start_xmit
Date: Tue, 31 Jul 2012 13:43:58 +0200
Message-Id: <1343735038-16030-11-git-send-email-johannes@sipsolutions.net> (sfid-20120731_134640_616644_17A8918C)
In-Reply-To: <1343735038-16030-1-git-send-email-johannes@sipsolutions.net>
References: <1343735038-16030-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to carry around a return value
that is always NETDEV_TX_OK anyway.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c |   23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 441572f..57bbb8c 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1719,7 +1719,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_tx_info *info;
-	int ret = NETDEV_TX_BUSY, head_need;
+	int head_need;
 	u16 ethertype, hdrlen,  meshhdrlen = 0;
 	__le16 fc;
 	struct ieee80211_hdr hdr;
@@ -1735,10 +1735,8 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 	u32 info_flags = 0;
 	u16 info_id = 0;
 
-	if (unlikely(skb->len < ETH_HLEN)) {
-		ret = NETDEV_TX_OK;
+	if (unlikely(skb->len < ETH_HLEN))
 		goto fail;
-	}
 
 	/* convert Ethernet header to proper 802.11 header (based on
 	 * operation mode) */
@@ -1786,7 +1784,6 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		if (!sdata->u.mesh.mshcfg.dot11MeshTTL) {
 			/* Do not send frames with mesh_ttl == 0 */
 			sdata->u.mesh.mshstats.dropped_frames_ttl++;
-			ret = NETDEV_TX_OK;
 			goto fail;
 		}
 		rcu_read_lock();
@@ -1879,10 +1876,8 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 
 		if (tdls_direct) {
 			/* link during setup - throw out frames to peer */
-			if (!tdls_auth) {
-				ret = NETDEV_TX_OK;
+			if (!tdls_auth)
 				goto fail;
-			}
 
 			/* DA SA BSSID */
 			memcpy(hdr.addr1, skb->data, ETH_ALEN);
@@ -1916,7 +1911,6 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		hdrlen = 24;
 		break;
 	default:
-		ret = NETDEV_TX_OK;
 		goto fail;
 	}
 
@@ -1961,7 +1955,6 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 
 		I802_DEBUG_INC(local->tx_handlers_drop_unauth_port);
 
-		ret = NETDEV_TX_OK;
 		goto fail;
 	}
 
@@ -2016,10 +2009,8 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		skb = skb_clone(skb, GFP_ATOMIC);
 		kfree_skb(tmp_skb);
 
-		if (!skb) {
-			ret = NETDEV_TX_OK;
+		if (!skb)
 			goto fail;
-		}
 	}
 
 	hdr.frame_control = fc;
@@ -2122,10 +2113,8 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 
  fail:
-	if (ret == NETDEV_TX_OK)
-		dev_kfree_skb(skb);
-
-	return ret;
+	dev_kfree_skb(skb);
+	return NETDEV_TX_OK;
 }
 
 
-- 
1.7.10.4

