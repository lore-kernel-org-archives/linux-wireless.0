Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46838 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165AbbFQI4U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 04:56:20 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 11/14] mac80211: duplicate station's MAC address for hash table
Date: Wed, 17 Jun 2015 10:41:12 +0200
Message-Id: <1434530475-3553-12-git-send-email-johannes@sipsolutions.net> (sfid-20150617_105624_836084_9C0CCD33)
In-Reply-To: <1434530475-3553-1-git-send-email-johannes@sipsolutions.net>
References: <1434530475-3553-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Currently, the station hash table lookup (or iteration) must
access two cachelines for each station - the one with the hash
table node, and the one with the MAC address.

Duplicate the MAC address next to the hash node to get rid of
this. Since the MAC address is static there's no consistency
problem introduced by this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c | 3 ++-
 net/mac80211/sta_info.h | 5 ++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 666ddac3c87c..d573a499750e 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -68,7 +68,7 @@ static const struct rhashtable_params sta_rht_params = {
 	.nelem_hint = 3, /* start small */
 	.automatic_shrinking = true,
 	.head_offset = offsetof(struct sta_info, hash_node),
-	.key_offset = offsetof(struct sta_info, sta.addr),
+	.key_offset = offsetof(struct sta_info, addr),
 	.key_len = ETH_ALEN,
 	.hashfn = sta_addr_hash,
 	.max_size = CONFIG_MAC80211_STA_HASH_MAX_SIZE,
@@ -320,6 +320,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	sta->nonpeer_pm = NL80211_MESH_POWER_ACTIVE;
 #endif
 
+	memcpy(sta->addr, addr, ETH_ALEN);
 	memcpy(sta->sta.addr, addr, ETH_ALEN);
 	sta->local = local;
 	sta->sdata = sdata;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index db76103b4445..422984986263 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -278,6 +278,8 @@ struct ieee80211_fast_tx {
  * @list: global linked list entry
  * @free_list: list entry for keeping track of stations to free
  * @hash_node: hash node for rhashtable
+ * @addr: station's MAC address - duplicated from public part to
+ *	let the hash table work with just a single cacheline
  * @local: pointer to the global information
  * @sdata: virtual interface this station belongs to
  * @ptk: peer keys negotiated with this station, if any
@@ -377,6 +379,7 @@ struct sta_info {
 	struct list_head list, free_list;
 	struct rcu_head rcu_head;
 	struct rhash_head hash_node;
+	u8 addr[ETH_ALEN];
 	struct ieee80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_key __rcu *gtk[NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS];
@@ -607,7 +610,7 @@ u32 sta_addr_hash(const void *key, u32 length, u32 seed);
 			       _sta_bucket_idx(tbl, _addr),		\
 			       hash_node)				\
 	/* compare address and run code only if it matches */		\
-	if (ether_addr_equal(_sta->sta.addr, (_addr)))
+	if (ether_addr_equal(_sta->addr, (_addr)))
 
 /*
  * Get STA info by index, BROKEN!
-- 
2.1.4

