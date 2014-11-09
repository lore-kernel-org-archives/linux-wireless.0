Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:48302 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbaKIQu0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Nov 2014 11:50:26 -0500
Received: by mail-wi0-f170.google.com with SMTP id r20so8092113wiv.3
        for <linux-wireless@vger.kernel.org>; Sun, 09 Nov 2014 08:50:25 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Liad Kaufman <liad.kaufman@intel.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 01/16] mac80211: add option for setting skb flags before xmit
Date: Sun,  9 Nov 2014 18:50:07 +0200
Message-Id: <1415551822-20121-1-git-send-email-arik@wizery.com> (sfid-20141109_175036_621901_122A12CA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Allows setting of an skb's flags - if needed - when calling
ieee80211_subif_start_xmit().

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 net/mac80211/ieee80211_i.h |  3 +++
 net/mac80211/tx.c          | 21 +++++++++++++--------
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a51c993..208953d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1625,6 +1625,9 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 					 struct net_device *dev);
 netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 				       struct net_device *dev);
+void __ieee80211_subif_start_xmit(struct sk_buff *skb,
+				  struct net_device *dev,
+				  u32 info_flags);
 void ieee80211_purge_tx_queue(struct ieee80211_hw *hw,
 			      struct sk_buff_head *skbs);
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 3ffd91f..66af35f 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1787,21 +1787,22 @@ static void ieee80211_tx_latency_start_msrmnt(struct ieee80211_local *local,
 }
 
 /**
- * ieee80211_subif_start_xmit - netif start_xmit function for Ethernet-type
+ * __ieee80211_subif_start_xmit - netif start_xmit function for Ethernet-type
  * subinterfaces (wlan#, WDS, and VLAN interfaces)
  * @skb: packet to be sent
  * @dev: incoming interface
+ * @info_flags: skb flags to set
  *
- * Returns: NETDEV_TX_OK both on success and on failure. On failure skb will
- *	be freed.
+ * On failure skb will be freed.
  *
  * This function takes in an Ethernet header and encapsulates it with suitable
  * IEEE 802.11 header based on which interface the packet is coming in. The
  * encapsulated packet will then be passed to master interface, wlan#.11, for
  * transmission (through low-level driver).
  */
-netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
-				    struct net_device *dev)
+void __ieee80211_subif_start_xmit(struct sk_buff *skb,
+				  struct net_device *dev,
+				  u32 info_flags)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
@@ -1819,7 +1820,6 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 	bool wme_sta = false, authorized = false, tdls_auth = false;
 	bool tdls_peer = false, tdls_setup_frame = false;
 	bool multicast;
-	u32 info_flags = 0;
 	u16 info_id = 0;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct ieee80211_sub_if_data *ap_sdata;
@@ -2224,15 +2224,20 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 	ieee80211_xmit(sdata, skb, band);
 	rcu_read_unlock();
 
-	return NETDEV_TX_OK;
+	return;
 
  fail_rcu:
 	rcu_read_unlock();
  fail:
 	dev_kfree_skb(skb);
-	return NETDEV_TX_OK;
 }
 
+netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
+				       struct net_device *dev)
+{
+	__ieee80211_subif_start_xmit(skb, dev, 0);
+	return NETDEV_TX_OK;
+}
 
 /*
  * ieee80211_clear_tx_pending may not be called in a context where
-- 
1.9.1

