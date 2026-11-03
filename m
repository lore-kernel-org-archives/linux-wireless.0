Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793719768;
	b=CoZHbC34QUV6ZWW2Wd4czv34FBXa7FyHk5YWWWcOJkwqqbnoYjZdmbyBGiw+33Giz4S2
	 nJA4lYkOn/dtSl1geyevz02E76XHsm6VfRHmKM+zDn0ZnCje7Ve5mf+kgjxRixPDkfAFM
	 wAG1LaW8lmbJ5G6spohoP4pMtFTvS7XaT1nlnkHpnmwXaVEbzLlX29nznreY4VT85oziz
	 nplr7AvQ6wXUmQp51pnSN/r1zzjaxG9pOUTVBww5BHU8aRAytfpbh9gtZuLY/0OSvS3oe
	 +AHLKRrWVnjVWfkd4FVoVa5JvrtQriwONbgBjxCDLLT05PtXXrvUMrUwJVjC/SkMbxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793719768;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=wMfmq9A7y/BHKUIJ5goXyvayy4JYAfHp68djgKzX4CQ=;
	b=rDL9PkvlVHWLXTiYR5TTw+agLVm1Dx7MYs/I5msd94PWRqJDVwfno9EvYjcNQLXEh9Ih
	 r0JyO16I934E+SMWr4x2rg9yncu+5k0qEMyk+1bUY0Saelmxhs3qSZ3AdRynX7jrOM+PY
	 6E4X28LX4cYAQSFk5jvMPO5mWyTM3b5NqYjNDDumyC7C1J+Js9F89Pio0CqxEl9zBuO6X
	 ULovAKQcWcGH4QmujyKKdzRxqEV9K2AEXNsM9MT5WpcGPtA44NNZ7EZUg8WJHQnEh328I
	 286jLDtINJGQ8LsGrpLGOCfHF35dISqr0c3s1YTbN4MU0WGayR+lp8JvTJJb4hoaXSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=nq2IopnW;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E3E606A332
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 15:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=nq2IopnW
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=wMfmq9A7y/BHKUIJ5goXyvayy4JYAfHp68djgKzX4CQ=;
	t=1793719767; x=1794929367; b=nq2IopnWG1MI0xjQKoRS1jkdkrhZCEtUaJuYKV+qA7zqUhG
	n7qHE/mutz+QcOBJ4gC7sK7/QRrFTt/qz7KrSQW10MxD6Kp8Wegepxsh5fwcNzBvGoF3Iqkqjll4n
	S2CJW5x020o3wK0+Xx4rN1+dEefIT42Oek2T89QQyXuld57ikcoeQS4p4ZLZNDnSnsRxVBGLTkQlN
	Jmeav48LXZYo9KrXL+pgtE2BtLGlyYj+DTjI6rs1XRJwlWcVu9oXU1WvnoeKBoU6jneZKHjLVtYzo
	YXpW/pkUooESoyaUR0KTpNVCHogu+z9rUoThi1f6EGswiNUjN1KCSTGz7ynVx//Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xOGRw-00000003eXZ-41jv;
	Tue, 03 Nov 2026 16:29:25 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 2/4] wifi: mac80211: enable context analysis
Date: Tue,  3 Nov 2026 16:29:14 +0100
Message-ID: <20261103162920.65d454049a55.I856a420838f613be7c5ff5a4598b0720fece67d0@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103152920.294873-6-johannes@sipsolutions.net>
References: <20261103152920.294873-6-johannes@sipsolutions.net>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

This is mostly straight-forward, with two exceptions:
 - clang can't cope with the different origins of mpath
   in the mesh code, so I added __acquire/__release,
 - __ieee80211_wake_queue() argument needs to be 'local'
   otherwise clang cannot prove hw/local are the same

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h      | 13 ++++++++-----
 net/mac80211/Makefile       |  2 ++
 net/mac80211/agg-tx.c       |  3 +++
 net/mac80211/ibss.c         |  4 ++--
 net/mac80211/ieee80211_i.h  |  9 ++++++---
 net/mac80211/main.c         |  1 -
 net/mac80211/mesh.c         |  1 +
 net/mac80211/mesh.h         | 21 ++++++++++++++-------
 net/mac80211/mesh_hwmp.c    |  8 ++++++++
 net/mac80211/mesh_pathtbl.c |  5 +++++
 net/mac80211/mesh_plink.c   |  2 +-
 net/mac80211/ocb.c          |  2 +-
 net/mac80211/rx.c           | 18 +++++++++++++++++-
 net/mac80211/sta_info.c     | 11 +++++++++--
 net/mac80211/sta_info.h     | 12 ++++++++----
 net/mac80211/tx.c           |  3 +++
 net/mac80211/util.c         | 19 +++++++++----------
 17 files changed, 97 insertions(+), 37 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 76ff86ff9974..1fdab0065dd8 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -5441,7 +5441,8 @@ void ieee80211_restart_hw(struct ieee80211_hw *hw);
  */
 void ieee80211_rx_list(struct ieee80211_hw *hw,
 		       struct ieee80211_link_sta *link_sta,
-		       struct sk_buff *skb, struct list_head *list);
+		       struct sk_buff *skb, struct list_head *list)
+	__must_hold_shared(RCU);
 
 /**
  * ieee80211_rx_napi - receive frame from NAPI context
@@ -6779,9 +6780,10 @@ struct ieee80211_sta *ieee80211_find_sta(struct ieee80211_vif *vif,
  *
  * DO NOT USE THIS FUNCTION with localaddr NULL if at all possible.
  */
-struct ieee80211_sta *ieee80211_find_sta_by_ifaddr(struct ieee80211_hw *hw,
-					       const u8 *addr,
-					       const u8 *localaddr);
+struct ieee80211_sta *
+ieee80211_find_sta_by_ifaddr(struct ieee80211_hw *hw, const u8 *addr,
+			     const u8 *localaddr)
+	__must_hold_shared(RCU);
 
 /**
  * ieee80211_find_sta_by_link_addrs - find STA by link addresses
@@ -6799,7 +6801,8 @@ struct ieee80211_sta *
 ieee80211_find_sta_by_link_addrs(struct ieee80211_hw *hw,
 				 const u8 *addr,
 				 const u8 *localaddr,
-				 unsigned int *link_id);
+				 unsigned int *link_id)
+	__must_hold_shared(RCU);
 
 /**
  * ieee80211_sta_block_awake - block station from waking up
diff --git a/net/mac80211/Makefile b/net/mac80211/Makefile
index 36f1e3e2222b..9a906ac2dcf7 100644
--- a/net/mac80211/Makefile
+++ b/net/mac80211/Makefile
@@ -1,6 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_MAC80211) += mac80211.o
 
+CONTEXT_ANALYSIS := y
+
 # mac80211 objects
 mac80211-y := \
 	main.o status.o \
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index f3ecdd8601a0..f4d9ac57e74b 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -20,6 +20,9 @@
 #include "driver-ops.h"
 #include "wme.h"
 
+/* used for checking agg queue refcount */
+token_context_lock(agg_queue, __reentrant_ctx_lock);
+
 /**
  * DOC: TX A-MPDU aggregation
  *
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index d74b66426349..1e03d7ded878 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -536,7 +536,7 @@ void ieee80211_ibss_stop(struct ieee80211_sub_if_data *sdata)
 }
 
 static struct sta_info *ieee80211_ibss_finish_sta(struct sta_info *sta)
-	__acquires(RCU)
+	__acquires_shared(RCU)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	u8 addr[ETH_ALEN];
@@ -566,7 +566,7 @@ static struct sta_info *ieee80211_ibss_finish_sta(struct sta_info *sta)
 static struct sta_info *
 ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata, const u8 *bssid,
 		       const u8 *addr, u32 supp_rates)
-	__acquires(RCU)
+	__acquires_shared(RCU)
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct ieee80211_local *local = sdata->local;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 9906a62ee99c..d73d15a5b0be 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2386,7 +2386,8 @@ void ieee80211_stop_tx_ba_cb(struct sta_info *sta, int tid,
 			     struct tid_ampdu_tx *tid_tx);
 void ieee80211_ba_session_work(struct wiphy *wiphy, struct wiphy_work *work);
 void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid);
-void ieee80211_release_reorder_timeout(struct sta_info *sta, int tid);
+void ieee80211_release_reorder_timeout(struct sta_info *sta, int tid)
+	__must_hold_shared(RCU);
 
 u8 ieee80211_mcs_to_chains(const struct ieee80211_mcs_info *mcs);
 enum nl80211_smps_mode
@@ -2513,12 +2514,14 @@ void ieee80211_clear_tpe(struct ieee80211_parsed_tpe *tpe);
 void ieee80211_set_wmm_default(struct ieee80211_link_data *link,
 			       bool bss_notify, bool enable_qos);
 void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
-		    struct sta_info *sta, struct sk_buff *skb);
+		    struct sta_info *sta, struct sk_buff *skb)
+	__must_hold_shared(RCU);
 
 void __ieee80211_tx_skb_tid_band(struct ieee80211_sub_if_data *sdata,
 				 struct sk_buff *skb, struct sta_info *sta,
 				 int tid, int link_id,
-				 enum nl80211_band band);
+				 enum nl80211_band band)
+	__must_hold_shared(RCU);
 
 static inline bool ieee80211_require_encrypted_assoc(__le16 fc,
 						     struct sta_info *sta)
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 6e31076bcc10..4076eed0c80c 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -607,7 +607,6 @@ static int ieee80211_ifa_changed(struct notifier_block *nb,
 	 * by the !wdev->registered check above.
 	 */
 	mutex_lock_nested(&local->hw.wiphy->mtx, 1);
-	__acquire(&local->hw.wiphy->mtx);
 
 	/* Copy the addresses to the vif config list */
 	ifa = rtnl_dereference(idev->ifa_list);
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 5f523e14cf84..e93303dce6fc 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -733,6 +733,7 @@ ieee80211_mesh_update_bss_params(struct ieee80211_sub_if_data *sdata,
 
 bool ieee80211_mesh_xmit_fast(struct ieee80211_sub_if_data *sdata,
 			      struct sk_buff *skb, u32 ctrl_flags)
+	__must_hold_shared(RCU)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee80211_mesh_fast_tx_key key = {
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 3f9664e4e00c..6b8de9e9b307 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -301,14 +301,18 @@ void ieee80211_mps_frame_release(struct sta_info *sta,
 
 /* Mesh paths */
 int mesh_nexthop_lookup(struct ieee80211_sub_if_data *sdata,
-			struct sk_buff *skb);
+			struct sk_buff *skb)
+	__must_hold_shared(RCU);
 int mesh_nexthop_resolve(struct ieee80211_sub_if_data *sdata,
-			 struct sk_buff *skb);
+			 struct sk_buff *skb)
+	__must_hold_shared(RCU);
 void mesh_path_start_discovery(struct ieee80211_sub_if_data *sdata);
 struct mesh_path *mesh_path_lookup(struct ieee80211_sub_if_data *sdata,
-				   const u8 *dst);
+				   const u8 *dst)
+	__must_hold_shared(RCU);
 struct mesh_path *mpp_path_lookup(struct ieee80211_sub_if_data *sdata,
-				  const u8 *dst);
+				  const u8 *dst)
+	__must_hold_shared(RCU);
 int mpp_path_add(struct ieee80211_sub_if_data *sdata,
 		 const u8 *dst, const u8 *mpp);
 struct mesh_path *
@@ -364,11 +368,14 @@ void mesh_path_tx_root_frame(struct ieee80211_sub_if_data *sdata);
 bool mesh_action_is_path_sel(struct ieee80211_mgmt *mgmt);
 struct ieee80211_mesh_fast_tx *
 mesh_fast_tx_get(struct ieee80211_sub_if_data *sdata,
-		 struct ieee80211_mesh_fast_tx_key *key);
+		 struct ieee80211_mesh_fast_tx_key *key)
+	__must_hold_shared(RCU);
 bool ieee80211_mesh_xmit_fast(struct ieee80211_sub_if_data *sdata,
-			      struct sk_buff *skb, u32 ctrl_flags);
+			      struct sk_buff *skb, u32 ctrl_flags)
+	__must_hold_shared(RCU);
 void mesh_fast_tx_cache(struct ieee80211_sub_if_data *sdata,
-			struct sk_buff *skb, struct mesh_path *mpath);
+			struct sk_buff *skb, struct mesh_path *mpath)
+	__must_hold_shared(RCU);
 void mesh_fast_tx_gc(struct ieee80211_sub_if_data *sdata);
 void mesh_fast_tx_flush_addr(struct ieee80211_sub_if_data *sdata,
 			     const u8 *addr);
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 7f962b003579..0c9f0f476eb4 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -453,6 +453,7 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 					fresh_info = false;
 				}
 			}
+			__release(&mpath->state_lock);
 		} else {
 			mpath = mesh_path_add(sdata, orig_addr);
 			if (IS_ERR(mpath)) {
@@ -460,7 +461,9 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 				return 0;
 			}
 			spin_lock_bh(&mpath->state_lock);
+			__release(&mpath->state_lock);
 		}
+		__acquire(&mpath->state_lock);
 
 		if (fresh_info) {
 			if (rcu_access_pointer(mpath->next_hop) != sta) {
@@ -505,6 +508,7 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 				      !is_metric_better(last_hop_metric, mpath->metric) :
 				       last_hop_metric > mpath->metric))))
 				fresh_info = false;
+			__release(&mpath->state_lock);
 		} else {
 			mpath = mesh_path_add(sdata, ta);
 			if (IS_ERR(mpath)) {
@@ -512,7 +516,9 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 				return 0;
 			}
 			spin_lock_bh(&mpath->state_lock);
+			__release(&mpath->state_lock);
 		}
+		__acquire(&mpath->state_lock);
 
 		if (fresh_info) {
 			if (rcu_access_pointer(mpath->next_hop) != sta) {
@@ -1153,6 +1159,7 @@ void mesh_path_start_discovery(struct ieee80211_sub_if_data *sdata)
  */
 int mesh_nexthop_resolve(struct ieee80211_sub_if_data *sdata,
 			 struct sk_buff *skb)
+	__must_hold_shared(RCU)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -1257,6 +1264,7 @@ void mesh_path_refresh(struct ieee80211_sub_if_data *sdata,
  */
 int mesh_nexthop_lookup(struct ieee80211_sub_if_data *sdata,
 			struct sk_buff *skb)
+	__must_hold_shared(RCU)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct mesh_path *mpath;
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index dcb0a58e0fa9..3b8ce601589a 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -242,6 +242,7 @@ static void mesh_path_move_to_queue(struct mesh_path *gate_mpath,
 
 static struct mesh_path *mpath_lookup(struct mesh_table *tbl, const u8 *dst,
 				      struct ieee80211_sub_if_data *sdata)
+	__must_hold_shared(RCU)
 {
 	struct mesh_path *mpath;
 
@@ -267,12 +268,14 @@ static struct mesh_path *mpath_lookup(struct mesh_table *tbl, const u8 *dst,
  */
 struct mesh_path *
 mesh_path_lookup(struct ieee80211_sub_if_data *sdata, const u8 *dst)
+	__must_hold_shared(RCU)
 {
 	return mpath_lookup(&sdata->u.mesh.mesh_paths, dst, sdata);
 }
 
 struct mesh_path *
 mpp_path_lookup(struct ieee80211_sub_if_data *sdata, const u8 *dst)
+	__must_hold_shared(RCU)
 {
 	return mpath_lookup(&sdata->u.mesh.mpp_paths, dst, sdata);
 }
@@ -434,6 +437,7 @@ static void mesh_fast_tx_entry_free(struct mesh_tx_cache *cache,
 struct ieee80211_mesh_fast_tx *
 mesh_fast_tx_get(struct ieee80211_sub_if_data *sdata,
 		 struct ieee80211_mesh_fast_tx_key *key)
+	__must_hold_shared(RCU)
 {
 	struct ieee80211_mesh_fast_tx *entry;
 	struct mesh_tx_cache *cache;
@@ -463,6 +467,7 @@ mesh_fast_tx_get(struct ieee80211_sub_if_data *sdata,
 
 void mesh_fast_tx_cache(struct ieee80211_sub_if_data *sdata,
 			struct sk_buff *skb, struct mesh_path *mpath)
+	__must_hold_shared(RCU)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 6ce3ae3fb39b..98951fbecf87 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -591,7 +591,7 @@ mesh_sta_info_alloc(struct ieee80211_sub_if_data *sdata, u8 *addr,
 static struct sta_info *
 mesh_sta_info_get(struct ieee80211_sub_if_data *sdata,
 		  u8 *addr, struct ieee802_11_elems *elems,
-		  struct ieee80211_rx_status *rx_status) __acquires(RCU)
+		  struct ieee80211_rx_status *rx_status) __acquires_shared(RCU)
 {
 	struct sta_info *sta = NULL;
 
diff --git a/net/mac80211/ocb.c b/net/mac80211/ocb.c
index e9bf4ba3e60b..3fde7f9aa7db 100644
--- a/net/mac80211/ocb.c
+++ b/net/mac80211/ocb.c
@@ -85,7 +85,7 @@ void ieee80211_ocb_rx_no_sta(struct ieee80211_sub_if_data *sdata,
 }
 
 static struct sta_info *ieee80211_ocb_finish_sta(struct sta_info *sta)
-	__acquires(RCU)
+	__acquires_shared(RCU)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	u8 addr[ETH_ALEN];
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index ee1f33178d26..b3df0f010b0d 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2849,6 +2849,7 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 static bool
 ieee80211_rx_mesh_fast_forward(struct ieee80211_sub_if_data *sdata,
 			       struct sk_buff *skb, int hdrlen)
+	__must_hold_shared(RCU)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee80211_mesh_fast_tx_key key = {
@@ -2914,6 +2915,7 @@ ieee80211_rx_mesh_fast_forward(struct ieee80211_sub_if_data *sdata,
 static ieee80211_rx_result
 ieee80211_rx_mesh_data(struct ieee80211_sub_if_data *sdata, struct sta_info *sta,
 		       struct sk_buff *skb)
+	__must_hold_shared(RCU)
 {
 #ifdef CONFIG_MAC80211_MESH
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
@@ -3097,6 +3099,7 @@ ieee80211_rx_mesh_data(struct ieee80211_sub_if_data *sdata, struct sta_info *sta
 
 static ieee80211_rx_result debug_noinline
 __ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx, u8 data_offset)
+	__must_hold_shared(RCU)
 {
 	struct net_device *dev = rx->sdata->dev;
 	struct sk_buff *skb = rx->skb;
@@ -3183,6 +3186,7 @@ __ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx, u8 data_offset)
 
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx)
+	__must_hold_shared(RCU)
 {
 	struct sk_buff *skb = rx->skb;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
@@ -3240,6 +3244,7 @@ ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx)
 
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
+	__must_hold_shared(RCU)
 {
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
 	struct ieee80211_local *local = rx->local;
@@ -4029,6 +4034,7 @@ ieee80211_rx_h_action_post_userspace(struct ieee80211_rx_data *rx)
 
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_action_return(struct ieee80211_rx_data *rx)
+	__must_hold_shared(RCU)
 {
 	struct ieee80211_local *local = rx->local;
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *) rx->skb->data;
@@ -4183,6 +4189,7 @@ static void ieee80211_rx_handlers_result(struct ieee80211_rx_data *rx,
 
 static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx,
 				  struct sk_buff_head *frames)
+	__must_hold_shared(RCU)
 {
 	ieee80211_rx_result res;
 	struct sk_buff *skb;
@@ -4264,6 +4271,7 @@ static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx,
 }
 
 static void ieee80211_invoke_rx_handlers(struct ieee80211_rx_data *rx)
+	__must_hold_shared(RCU)
 {
 	struct sk_buff_head reorder_release;
 	ieee80211_rx_result res;
@@ -4380,6 +4388,7 @@ static bool ieee80211_rx_data_set_sta(struct ieee80211_rx_data *rx,
  * it has to be invoked under RCU read lock.
  */
 void ieee80211_release_reorder_timeout(struct sta_info *sta, int tid)
+	__must_hold_shared(RCU)
 {
 	struct sk_buff_head frames;
 	struct ieee80211_rx_data rx = {
@@ -4726,6 +4735,9 @@ static bool ieee80211_accept_frame(struct ieee80211_rx_data *rx)
 	return false;
 }
 
+/* only used within the function, see comment below */
+token_context_lock(check_fast_rx);
+
 void ieee80211_check_fast_rx(struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
@@ -4741,7 +4753,7 @@ void ieee80211_check_fast_rx(struct sta_info *sta)
 	bool assign = false;
 	bool offload;
 
-	/* use sparse to check that we don't return without updating */
+	/* use context analysis to check that we don't return without updating */
 	__acquire(check_fast_rx);
 
 	BUILD_BUG_ON(sizeof(fastrx.rfc1042_hdr) != sizeof(rfc1042_header));
@@ -5016,6 +5028,7 @@ static void ieee80211_rx_8023(struct ieee80211_rx_data *rx,
 
 static bool ieee80211_invoke_fast_rx(struct ieee80211_rx_data *rx,
 				     struct ieee80211_fast_rx *fast_rx)
+	__must_hold_shared(RCU)
 {
 	struct sk_buff *skb = rx->skb;
 	struct ieee80211_hdr *hdr = (void *)skb->data;
@@ -5177,6 +5190,7 @@ static bool ieee80211_invoke_fast_rx(struct ieee80211_rx_data *rx,
  */
 static bool ieee80211_prepare_and_rx_handle(struct ieee80211_rx_data *rx,
 					    struct sk_buff *skb, bool consume)
+	__must_hold_shared(RCU)
 {
 	struct ieee80211_local *local = rx->local;
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
@@ -5331,6 +5345,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 					 struct ieee80211_link_sta *link_pubsta,
 					 struct sk_buff *skb,
 					 struct list_head *list)
+	__must_hold_shared(RCU)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
@@ -5581,6 +5596,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 void ieee80211_rx_list(struct ieee80211_hw *hw,
 		       struct ieee80211_link_sta *link_pubsta,
 		       struct sk_buff *skb, struct list_head *list)
+	__must_hold_shared(RCU)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_rate *rate = NULL;
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 23166fc39729..471adfcc64d5 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -195,6 +195,7 @@ static void cleanup_single_sta(struct sta_info *sta)
 
 struct rhlist_head *sta_info_hash_lookup(struct ieee80211_local *local,
 					 const u8 *addr)
+	__must_hold_shared(RCU)
 {
 	return rhltable_lookup(&local->sta_hash, addr, sta_rht_params);
 }
@@ -249,6 +250,7 @@ struct sta_info *sta_info_get_bss(struct ieee80211_sub_if_data *sdata,
 
 struct rhlist_head *link_sta_info_hash_lookup(struct ieee80211_local *local,
 					      const u8 *addr)
+	__must_hold_shared(RCU)
 {
 	return rhltable_lookup(&local->link_sta_hash, addr,
 			       link_sta_rht_params);
@@ -283,6 +285,7 @@ ieee80211_find_sta_by_link_addrs(struct ieee80211_hw *hw,
 				 const u8 *addr,
 				 const u8 *localaddr,
 				 unsigned int *link_id)
+	__must_hold_shared(RCU)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct link_sta_info *link_sta;
@@ -317,6 +320,7 @@ EXPORT_SYMBOL_GPL(ieee80211_find_sta_by_link_addrs);
 
 struct sta_info *sta_info_get_by_addrs(struct ieee80211_local *local,
 				       const u8 *sta_addr, const u8 *vif_addr)
+	__must_hold_shared(RCU)
 {
 	struct rhlist_head *tmp;
 	struct sta_info *sta;
@@ -917,7 +921,8 @@ ieee80211_recalc_p2p_go_ps_allowed(struct ieee80211_sub_if_data *sdata)
 	}
 }
 
-static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
+static int sta_info_insert_finish(struct sta_info *sta)
+	__acquires_shared(RCU)
 {
 	struct ieee80211_local *local = sta->local;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
@@ -1032,7 +1037,8 @@ static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
 	return err;
 }
 
-int sta_info_insert_rcu(struct sta_info *sta) __acquires(RCU)
+int sta_info_insert_rcu(struct sta_info *sta)
+	__acquires_shared(RCU)
 {
 	struct ieee80211_local *local = sta->local;
 	int err;
@@ -1794,6 +1800,7 @@ void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
 struct ieee80211_sta *ieee80211_find_sta_by_ifaddr(struct ieee80211_hw *hw,
 						   const u8 *addr,
 						   const u8 *localaddr)
+	__must_hold_shared(RCU)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct rhlist_head *tmp;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 8c6a9fee6b29..0fe81e9e6241 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -884,7 +884,8 @@ void ieee80211_assign_tid_tx(struct sta_info *sta, int tid,
 #define STA_INFO_CLEANUP_INTERVAL (10 * HZ)
 
 struct rhlist_head *sta_info_hash_lookup(struct ieee80211_local *local,
-					 const u8 *addr);
+					 const u8 *addr)
+	__must_hold_shared(RCU);
 
 /*
  * Get a STA info, must be under RCU read lock.
@@ -897,14 +898,16 @@ struct sta_info *sta_info_get_bss(struct ieee80211_sub_if_data *sdata,
 
 /* user must hold wiphy mutex or be in RCU critical section */
 struct sta_info *sta_info_get_by_addrs(struct ieee80211_local *local,
-				       const u8 *sta_addr, const u8 *vif_addr);
+				       const u8 *sta_addr, const u8 *vif_addr)
+	__must_hold_shared(RCU);
 
 #define for_each_sta_info(local, _addr, _sta, _tmp)			\
 	rhl_for_each_entry_rcu(_sta, _tmp,				\
 			       sta_info_hash_lookup(local, _addr), hash_node)
 
 struct rhlist_head *link_sta_info_hash_lookup(struct ieee80211_local *local,
-					      const u8 *addr);
+					      const u8 *addr)
+	__must_hold_shared(RCU);
 
 #define for_each_link_sta_info(local, _addr, _sta, _tmp)		\
 	rhl_for_each_entry_rcu(_sta, _tmp,				\
@@ -942,7 +945,8 @@ void sta_info_free(struct ieee80211_local *local, struct sta_info *sta);
  * without it held.
  */
 int sta_info_insert(struct sta_info *sta);
-int sta_info_insert_rcu(struct sta_info *sta) __acquires(RCU);
+int sta_info_insert_rcu(struct sta_info *sta)
+	__acquires_shared(RCU);
 
 int __must_check __sta_info_destroy(struct sta_info *sta);
 int sta_info_destroy_addr(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e9b6a0415d6a..1df38c03d6de 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2089,6 +2089,7 @@ static int ieee80211_skb_resize(struct ieee80211_sub_if_data *sdata,
 
 void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
 		    struct sta_info *sta, struct sk_buff *skb)
+	__must_hold_shared(RCU)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -2773,6 +2774,7 @@ static int ieee80211_ap_tx_addr_get(struct ieee80211_sub_if_data *sdata,
 static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 					   struct sk_buff *skb,
 					   struct sta_info *sta)
+	__must_hold_shared(RCU)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_local *local = sdata->local;
@@ -6539,6 +6541,7 @@ void __ieee80211_tx_skb_tid_band(struct ieee80211_sub_if_data *sdata,
 				 struct sk_buff *skb, struct sta_info *sta,
 				 int tid, int link_id,
 				 enum nl80211_band band)
+	__must_hold_shared(RCU)
 {
 	const struct ieee80211_hdr *hdr = (void *)skb->data;
 	int ac = ieee80211_ac_from_tid(tid);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 44feb80274c6..23fc45ec9196 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -398,9 +398,9 @@ static void __ieee80211_wake_txqs(struct ieee80211_sub_if_data *sdata, int ac)
 }
 
 static void
-__releases(&local->queue_stop_reason_lock)
-__acquires(&local->queue_stop_reason_lock)
 _ieee80211_wake_txqs(struct ieee80211_local *local, unsigned long *flags)
+	__releases(&local->queue_stop_reason_lock)
+	__acquires(&local->queue_stop_reason_lock)
 {
 	struct ieee80211_sub_if_data *sdata;
 	int n_acs = IEEE80211_NUM_ACS;
@@ -444,14 +444,13 @@ void ieee80211_wake_txqs(struct tasklet_struct *t)
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 }
 
-static void __ieee80211_wake_queue(struct ieee80211_hw *hw, int queue,
+static void __ieee80211_wake_queue(struct ieee80211_local *local, int queue,
 				   enum queue_stop_reason reason,
 				   bool refcounted,
 				   unsigned long *flags)
+	__must_hold(&local->queue_stop_reason_lock)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
-
-	if (WARN_ON(queue >= hw->queues))
+	if (WARN_ON(queue >= local->hw.queues))
 		return;
 
 	if (!test_bit(reason, &local->queue_stop_reasons[queue]))
@@ -499,7 +498,7 @@ void ieee80211_wake_queue_by_reason(struct ieee80211_hw *hw, int queue,
 	unsigned long flags;
 
 	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
-	__ieee80211_wake_queue(hw, queue, reason, refcounted, &flags);
+	__ieee80211_wake_queue(local, queue, reason, refcounted, &flags);
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 }
 
@@ -568,7 +567,7 @@ void ieee80211_add_pending_skb(struct ieee80211_local *local,
 	__ieee80211_stop_queue(hw, queue, IEEE80211_QUEUE_STOP_REASON_SKB_ADD,
 			       false);
 	__skb_queue_tail(&local->pending[queue], skb);
-	__ieee80211_wake_queue(hw, queue, IEEE80211_QUEUE_STOP_REASON_SKB_ADD,
+	__ieee80211_wake_queue(local, queue, IEEE80211_QUEUE_STOP_REASON_SKB_ADD,
 			       false, &flags);
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 }
@@ -600,7 +599,7 @@ void ieee80211_add_pending_skbs(struct ieee80211_local *local,
 	}
 
 	for (i = 0; i < hw->queues; i++)
-		__ieee80211_wake_queue(hw, i,
+		__ieee80211_wake_queue(local, i,
 			IEEE80211_QUEUE_STOP_REASON_SKB_ADD,
 			false, &flags);
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
@@ -660,7 +659,7 @@ void ieee80211_wake_queues_by_reason(struct ieee80211_hw *hw,
 	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
 
 	for_each_set_bit(i, &queues, hw->queues)
-		__ieee80211_wake_queue(hw, i, reason, refcounted, &flags);
+		__ieee80211_wake_queue(local, i, reason, refcounted, &flags);
 
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 }
-- 
2.56.0

