Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59893 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932237Ab3BOOq6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 09:46:58 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: marco@cozybit.com, thomas@cozybit.com,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2] mac80211: clean up mesh code
Date: Fri, 15 Feb 2013 15:46:51 +0100
Message-Id: <1360939611-937-1-git-send-email-johannes@sipsolutions.net> (sfid-20130215_154709_183850_AE901B1B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's various code with strange indentation,
questionable loop and locking constructs, etc.

The bigger change is moving the "sdata" argument
to the first argument of all functions, like all
other mac80211 functions that have one.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c          |  14 +++---
 net/mac80211/main.c         |   3 +-
 net/mac80211/mesh.c         | 115 +++++++++++++++++++++++---------------------
 net/mac80211/mesh.h         | 105 +++++++++++++++++++---------------------
 net/mac80211/mesh_hwmp.c    |  68 +++++++++++++-------------
 net/mac80211/mesh_pathtbl.c |  89 +++++++++++++++++-----------------
 net/mac80211/mesh_plink.c   |  36 ++++++++------
 net/mac80211/mesh_sync.c    |  47 ++++++------------
 net/mac80211/rx.c           |  12 ++---
 net/mac80211/tx.c           |  26 +++++-----
 10 files changed, 252 insertions(+), 263 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 179dcbd..09d96a8 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1500,13 +1500,13 @@ static int ieee80211_add_mpath(struct wiphy *wiphy, struct net_device *dev,
 		return -ENOENT;
 	}
 
-	err = mesh_path_add(dst, sdata);
+	err = mesh_path_add(sdata, dst);
 	if (err) {
 		rcu_read_unlock();
 		return err;
 	}
 
-	mpath = mesh_path_lookup(dst, sdata);
+	mpath = mesh_path_lookup(sdata, dst);
 	if (!mpath) {
 		rcu_read_unlock();
 		return -ENXIO;
@@ -1518,12 +1518,12 @@ static int ieee80211_add_mpath(struct wiphy *wiphy, struct net_device *dev,
 }
 
 static int ieee80211_del_mpath(struct wiphy *wiphy, struct net_device *dev,
-				 u8 *dst)
+			       u8 *dst)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	if (dst)
-		return mesh_path_del(dst, sdata);
+		return mesh_path_del(sdata, dst);
 
 	mesh_path_flush_by_iface(sdata);
 	return 0;
@@ -1547,7 +1547,7 @@ static int ieee80211_change_mpath(struct wiphy *wiphy,
 		return -ENOENT;
 	}
 
-	mpath = mesh_path_lookup(dst, sdata);
+	mpath = mesh_path_lookup(sdata, dst);
 	if (!mpath) {
 		rcu_read_unlock();
 		return -ENOENT;
@@ -1611,7 +1611,7 @@ static int ieee80211_get_mpath(struct wiphy *wiphy, struct net_device *dev,
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	rcu_read_lock();
-	mpath = mesh_path_lookup(dst, sdata);
+	mpath = mesh_path_lookup(sdata, dst);
 	if (!mpath) {
 		rcu_read_unlock();
 		return -ENOENT;
@@ -1632,7 +1632,7 @@ static int ieee80211_dump_mpath(struct wiphy *wiphy, struct net_device *dev,
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	rcu_read_lock();
-	mpath = mesh_path_lookup_by_idx(idx, sdata);
+	mpath = mesh_path_lookup_by_idx(sdata, idx);
 	if (!mpath) {
 		rcu_read_unlock();
 		return -ENOENT;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index f974768..d0dd111 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1173,8 +1173,7 @@ static void __exit ieee80211_exit(void)
 	rc80211_minstrel_ht_exit();
 	rc80211_minstrel_exit();
 
-	if (mesh_allocated)
-		ieee80211s_stop();
+	ieee80211s_stop();
 
 	ieee80211_iface_exit();
 
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index a77d40e..b022332 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -17,7 +17,7 @@
 #define TMR_RUNNING_MP	1
 #define TMR_RUNNING_MPR	2
 
-int mesh_allocated;
+static int mesh_allocated;
 static struct kmem_cache *rm_cache;
 
 bool mesh_action_is_path_sel(struct ieee80211_mgmt *mgmt)
@@ -36,6 +36,8 @@ void ieee80211s_init(void)
 
 void ieee80211s_stop(void)
 {
+	if (!mesh_allocated)
+		return;
 	mesh_pathtbl_unregister();
 	kmem_cache_destroy(rm_cache);
 }
@@ -90,24 +92,22 @@ bool mesh_matches_local(struct ieee80211_sub_if_data *sdata,
 	     (ifmsh->mesh_cc_id == ie->mesh_config->meshconf_congest) &&
 	     (ifmsh->mesh_sp_id == ie->mesh_config->meshconf_synch) &&
 	     (ifmsh->mesh_auth_id == ie->mesh_config->meshconf_auth)))
-		goto mismatch;
+		return false;
 
 	ieee80211_sta_get_rates(local, ie, ieee80211_get_sdata_band(sdata),
 				&basic_rates);
 
 	if (sdata->vif.bss_conf.basic_rates != basic_rates)
-		goto mismatch;
+		return false;
 
 	ieee80211_ht_oper_to_chandef(sdata->vif.bss_conf.chandef.chan,
 				     ie->ht_operation, &sta_chan_def);
 
 	if (!cfg80211_chandef_compatible(&sdata->vif.bss_conf.chandef,
 					 &sta_chan_def))
-		goto mismatch;
+		return false;
 
 	return true;
-mismatch:
-	return false;
 }
 
 /**
@@ -118,7 +118,7 @@ mismatch:
 bool mesh_peer_accepts_plinks(struct ieee802_11_elems *ie)
 {
 	return (ie->mesh_config->meshconf_cap &
-	    IEEE80211_MESHCONF_CAPAB_ACCEPT_PLINKS) != 0;
+			IEEE80211_MESHCONF_CAPAB_ACCEPT_PLINKS) != 0;
 }
 
 /**
@@ -196,11 +196,12 @@ void mesh_rmc_free(struct ieee80211_sub_if_data *sdata)
 	if (!sdata->u.mesh.rmc)
 		return;
 
-	for (i = 0; i < RMC_BUCKETS; i++)
+	for (i = 0; i < RMC_BUCKETS; i++) {
 		list_for_each_entry_safe(p, n, &rmc->bucket[i], list) {
 			list_del(&p->list);
 			kmem_cache_free(rm_cache, p);
 		}
+	}
 
 	kfree(rmc);
 	sdata->u.mesh.rmc = NULL;
@@ -209,6 +210,7 @@ void mesh_rmc_free(struct ieee80211_sub_if_data *sdata)
 /**
  * mesh_rmc_check - Check frame in recent multicast cache and add if absent.
  *
+ * @sdata:	interface
  * @sa:		source address
  * @mesh_hdr:	mesh_header
  *
@@ -218,8 +220,8 @@ void mesh_rmc_free(struct ieee80211_sub_if_data *sdata)
  * received this frame lately. If the frame is not in the cache, it is added to
  * it.
  */
-int mesh_rmc_check(u8 *sa, struct ieee80211s_hdr *mesh_hdr,
-		   struct ieee80211_sub_if_data *sdata)
+int mesh_rmc_check(struct ieee80211_sub_if_data *sdata,
+		   const u8 *sa, struct ieee80211s_hdr *mesh_hdr)
 {
 	struct mesh_rmc *rmc = sdata->u.mesh.rmc;
 	u32 seqnum = 0;
@@ -233,12 +235,11 @@ int mesh_rmc_check(u8 *sa, struct ieee80211s_hdr *mesh_hdr,
 	list_for_each_entry_safe(p, n, &rmc->bucket[idx], list) {
 		++entries;
 		if (time_after(jiffies, p->exp_time) ||
-				(entries == RMC_QUEUE_MAX_LEN)) {
+		    entries == RMC_QUEUE_MAX_LEN) {
 			list_del(&p->list);
 			kmem_cache_free(rm_cache, p);
 			--entries;
-		} else if ((seqnum == p->seqnum) &&
-			   (ether_addr_equal(sa, p->sa)))
+		} else if ((seqnum == p->seqnum) && ether_addr_equal(sa, p->sa))
 			return -1;
 	}
 
@@ -253,8 +254,8 @@ int mesh_rmc_check(u8 *sa, struct ieee80211s_hdr *mesh_hdr,
 	return 0;
 }
 
-int
-mesh_add_meshconf_ie(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
+int mesh_add_meshconf_ie(struct ieee80211_sub_if_data *sdata,
+			 struct sk_buff *skb)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	u8 *pos, neighbors;
@@ -285,19 +286,18 @@ mesh_add_meshconf_ie(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
 	/* Mesh capability */
 	*pos = IEEE80211_MESHCONF_CAPAB_FORWARDING;
 	*pos |= ifmsh->accepting_plinks ?
-	    IEEE80211_MESHCONF_CAPAB_ACCEPT_PLINKS : 0x00;
+			IEEE80211_MESHCONF_CAPAB_ACCEPT_PLINKS : 0x00;
 	/* Mesh PS mode. See IEEE802.11-2012 8.4.2.100.8 */
 	*pos |= ifmsh->ps_peers_deep_sleep ?
-	    IEEE80211_MESHCONF_CAPAB_POWER_SAVE_LEVEL : 0x00;
+			IEEE80211_MESHCONF_CAPAB_POWER_SAVE_LEVEL : 0x00;
 	*pos++ |= ifmsh->adjusting_tbtt ?
-	    IEEE80211_MESHCONF_CAPAB_TBTT_ADJUSTING : 0x00;
+			IEEE80211_MESHCONF_CAPAB_TBTT_ADJUSTING : 0x00;
 	*pos++ = 0x00;
 
 	return 0;
 }
 
-int
-mesh_add_meshid_ie(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
+int mesh_add_meshid_ie(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	u8 *pos;
@@ -314,8 +314,8 @@ mesh_add_meshid_ie(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
 	return 0;
 }
 
-int mesh_add_awake_window_ie(struct sk_buff *skb,
-			     struct ieee80211_sub_if_data *sdata)
+static int mesh_add_awake_window_ie(struct ieee80211_sub_if_data *sdata,
+				    struct sk_buff *skb)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	u8 *pos;
@@ -337,8 +337,8 @@ int mesh_add_awake_window_ie(struct sk_buff *skb,
 	return 0;
 }
 
-int
-mesh_add_vendor_ies(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
+int mesh_add_vendor_ies(struct ieee80211_sub_if_data *sdata,
+			struct sk_buff *skb)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	u8 offset, len;
@@ -361,8 +361,7 @@ mesh_add_vendor_ies(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
 	return 0;
 }
 
-int
-mesh_add_rsn_ie(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
+int mesh_add_rsn_ie(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	u8 len = 0;
@@ -390,8 +389,8 @@ mesh_add_rsn_ie(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
 	return 0;
 }
 
-int mesh_add_ds_params_ie(struct sk_buff *skb,
-			  struct ieee80211_sub_if_data *sdata)
+static int mesh_add_ds_params_ie(struct ieee80211_sub_if_data *sdata,
+				 struct sk_buff *skb)
 {
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct ieee80211_channel *chan;
@@ -417,8 +416,8 @@ int mesh_add_ds_params_ie(struct sk_buff *skb,
 	return 0;
 }
 
-int mesh_add_ht_cap_ie(struct sk_buff *skb,
-		       struct ieee80211_sub_if_data *sdata)
+int mesh_add_ht_cap_ie(struct ieee80211_sub_if_data *sdata,
+		       struct sk_buff *skb)
 {
 	struct ieee80211_local *local = sdata->local;
 	enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
@@ -439,8 +438,8 @@ int mesh_add_ht_cap_ie(struct sk_buff *skb,
 	return 0;
 }
 
-int mesh_add_ht_oper_ie(struct sk_buff *skb,
-			struct ieee80211_sub_if_data *sdata)
+int mesh_add_ht_oper_ie(struct ieee80211_sub_if_data *sdata,
+			struct sk_buff *skb)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_chanctx_conf *chanctx_conf;
@@ -475,6 +474,7 @@ int mesh_add_ht_oper_ie(struct sk_buff *skb,
 
 	return 0;
 }
+
 static void ieee80211_mesh_path_timer(unsigned long data)
 {
 	struct ieee80211_sub_if_data *sdata =
@@ -520,7 +520,7 @@ void ieee80211_mesh_root_setup(struct ieee80211_if_mesh *ifmsh)
 
 /**
  * ieee80211_fill_mesh_addresses - fill addresses of a locally originated mesh frame
- * @hdr:    	802.11 frame header
+ * @hdr:	802.11 frame header
  * @fc:		frame control field
  * @meshda:	destination address in the mesh
  * @meshsa:	source address address in the mesh.  Same as TA, as frame is
@@ -551,8 +551,8 @@ int ieee80211_fill_mesh_addresses(struct ieee80211_hdr *hdr, __le16 *fc,
 
 /**
  * ieee80211_new_mesh_header - create a new mesh header
- * @meshhdr:    uninitialized mesh header
  * @sdata:	mesh interface to be used
+ * @meshhdr:    uninitialized mesh header
  * @addr4or5:   1st address in the ae header, which may correspond to address 4
  *              (if addr6 is NULL) or address 5 (if addr6 is present). It may
  *              be NULL.
@@ -561,32 +561,38 @@ int ieee80211_fill_mesh_addresses(struct ieee80211_hdr *hdr, __le16 *fc,
  *
  * Return the header length.
  */
-int ieee80211_new_mesh_header(struct ieee80211s_hdr *meshhdr,
-		struct ieee80211_sub_if_data *sdata, char *addr4or5,
-		char *addr6)
+int ieee80211_new_mesh_header(struct ieee80211_sub_if_data *sdata,
+			      struct ieee80211s_hdr *meshhdr,
+			      const char *addr4or5, const char *addr6)
 {
-	int aelen = 0;
-	BUG_ON(!addr4or5 && addr6);
+	if (WARN_ON(!addr4or5 && addr6))
+		return 0;
+
 	memset(meshhdr, 0, sizeof(*meshhdr));
+
 	meshhdr->ttl = sdata->u.mesh.mshcfg.dot11MeshTTL;
+
+	/* FIXME: racy -- TX on multiple queues can be concurrent */
 	put_unaligned(cpu_to_le32(sdata->u.mesh.mesh_seqnum), &meshhdr->seqnum);
 	sdata->u.mesh.mesh_seqnum++;
+
 	if (addr4or5 && !addr6) {
 		meshhdr->flags |= MESH_FLAGS_AE_A4;
-		aelen += ETH_ALEN;
 		memcpy(meshhdr->eaddr1, addr4or5, ETH_ALEN);
+		return 2 * ETH_ALEN;
 	} else if (addr4or5 && addr6) {
 		meshhdr->flags |= MESH_FLAGS_AE_A5_A6;
-		aelen += 2 * ETH_ALEN;
 		memcpy(meshhdr->eaddr1, addr4or5, ETH_ALEN);
 		memcpy(meshhdr->eaddr2, addr6, ETH_ALEN);
+		return 3 * ETH_ALEN;
 	}
-	return 6 + aelen;
+
+	return ETH_ALEN;
 }
 
-static void ieee80211_mesh_housekeeping(struct ieee80211_sub_if_data *sdata,
-			   struct ieee80211_if_mesh *ifmsh)
+static void ieee80211_mesh_housekeeping(struct ieee80211_sub_if_data *sdata)
 {
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	u32 changed;
 
 	ieee80211_sta_expire(sdata, IEEE80211_MESH_PEER_INACTIVITY_LIMIT);
@@ -596,7 +602,8 @@ static void ieee80211_mesh_housekeeping(struct ieee80211_sub_if_data *sdata,
 	ieee80211_mbss_info_change_notify(sdata, changed);
 
 	mod_timer(&ifmsh->housekeeping_timer,
-		  round_jiffies(jiffies + IEEE80211_MESH_HOUSEKEEPING_INTERVAL));
+		  round_jiffies(jiffies +
+				IEEE80211_MESH_HOUSEKEEPING_INTERVAL));
 }
 
 static void ieee80211_mesh_rootpath(struct ieee80211_sub_if_data *sdata)
@@ -708,7 +715,7 @@ ieee80211_mesh_build_beacon(struct ieee80211_if_mesh *ifmsh)
 	*pos++ = 0x0;
 
 	if (ieee80211_add_srates_ie(sdata, skb, true, band) ||
-	    mesh_add_ds_params_ie(skb, sdata))
+	    mesh_add_ds_params_ie(sdata, skb))
 		goto out_free;
 
 	bcn->head_len = skb->len;
@@ -719,13 +726,13 @@ ieee80211_mesh_build_beacon(struct ieee80211_if_mesh *ifmsh)
 	bcn->tail = bcn->head + bcn->head_len;
 
 	if (ieee80211_add_ext_srates_ie(sdata, skb, true, band) ||
-	    mesh_add_rsn_ie(skb, sdata) ||
-	    mesh_add_ht_cap_ie(skb, sdata) ||
-	    mesh_add_ht_oper_ie(skb, sdata) ||
-	    mesh_add_meshid_ie(skb, sdata) ||
-	    mesh_add_meshconf_ie(skb, sdata) ||
-	    mesh_add_awake_window_ie(skb, sdata) ||
-	    mesh_add_vendor_ies(skb, sdata))
+	    mesh_add_rsn_ie(sdata, skb) ||
+	    mesh_add_ht_cap_ie(sdata, skb) ||
+	    mesh_add_ht_oper_ie(sdata, skb) ||
+	    mesh_add_meshid_ie(sdata, skb) ||
+	    mesh_add_meshconf_ie(sdata, skb) ||
+	    mesh_add_awake_window_ie(sdata, skb) ||
+	    mesh_add_vendor_ies(sdata, skb))
 		goto out_free;
 
 	bcn->tail_len = skb->len;
@@ -1039,7 +1046,7 @@ void ieee80211_mesh_work(struct ieee80211_sub_if_data *sdata)
 		mesh_mpp_table_grow();
 
 	if (test_and_clear_bit(MESH_WORK_HOUSEKEEPING, &ifmsh->wrkq_flags))
-		ieee80211_mesh_housekeeping(sdata, ifmsh);
+		ieee80211_mesh_housekeeping(sdata);
 
 	if (test_and_clear_bit(MESH_WORK_ROOT, &ifmsh->wrkq_flags))
 		ieee80211_mesh_rootpath(sdata);
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 1a1da87..336c88a 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -26,12 +26,12 @@
  * @MESH_PATH_ACTIVE: the mesh path can be used for forwarding
  * @MESH_PATH_RESOLVING: the discovery process is running for this mesh path
  * @MESH_PATH_SN_VALID: the mesh path contains a valid destination sequence
- * 	number
+ *	number
  * @MESH_PATH_FIXED: the mesh path has been manually set and should not be
- * 	modified
+ *	modified
  * @MESH_PATH_RESOLVED: the mesh path can has been resolved
  * @MESH_PATH_REQ_QUEUED: there is an unsent path request for this destination
- * already queued up, waiting for the discovery process to start.
+ *	already queued up, waiting for the discovery process to start.
  *
  * MESH_PATH_RESOLVED is used by the mesh path timer to
  * decide when to stop or cancel the mesh path discovery.
@@ -73,16 +73,16 @@ enum mesh_deferred_task_flags {
  * @dst: mesh path destination mac address
  * @sdata: mesh subif
  * @next_hop: mesh neighbor to which frames for this destination will be
- * 	forwarded
+ *	forwarded
  * @timer: mesh path discovery timer
  * @frame_queue: pending queue for frames sent to this destination while the
- * 	path is unresolved
+ *	path is unresolved
  * @sn: target sequence number
  * @metric: current metric to this destination
  * @hop_count: hops to destination
  * @exp_time: in jiffies, when the path will expire or when it expired
  * @discovery_timeout: timeout (lapse in jiffies) used for the last discovery
- * 	retry
+ *	retry
  * @discovery_retries: number of discovery retries
  * @flags: mesh path flags, as specified on &enum mesh_path_flags
  * @state_lock: mesh path state lock used to protect changes to the
@@ -206,38 +206,33 @@ struct mesh_rmc {
 /* Various */
 int ieee80211_fill_mesh_addresses(struct ieee80211_hdr *hdr, __le16 *fc,
 				  const u8 *da, const u8 *sa);
-int ieee80211_new_mesh_header(struct ieee80211s_hdr *meshhdr,
-		struct ieee80211_sub_if_data *sdata, char *addr4or5,
-		char *addr6);
-int mesh_rmc_check(u8 *addr, struct ieee80211s_hdr *mesh_hdr,
-		struct ieee80211_sub_if_data *sdata);
+int ieee80211_new_mesh_header(struct ieee80211_sub_if_data *sdata,
+			      struct ieee80211s_hdr *meshhdr,
+			      const char *addr4or5, const char *addr6);
+int mesh_rmc_check(struct ieee80211_sub_if_data *sdata,
+		   const u8 *addr, struct ieee80211s_hdr *mesh_hdr);
 bool mesh_matches_local(struct ieee80211_sub_if_data *sdata,
 			struct ieee802_11_elems *ie);
 void mesh_ids_set_default(struct ieee80211_if_mesh *mesh);
-void mesh_mgmt_ies_add(struct sk_buff *skb,
-		struct ieee80211_sub_if_data *sdata);
-int mesh_add_meshconf_ie(struct sk_buff *skb,
-			 struct ieee80211_sub_if_data *sdata);
-int mesh_add_meshid_ie(struct sk_buff *skb,
-		       struct ieee80211_sub_if_data *sdata);
-int mesh_add_rsn_ie(struct sk_buff *skb,
-		    struct ieee80211_sub_if_data *sdata);
-int mesh_add_awake_window_ie(struct sk_buff *skb,
-			     struct ieee80211_sub_if_data *sdata);
-int mesh_add_vendor_ies(struct sk_buff *skb,
-			struct ieee80211_sub_if_data *sdata);
-int mesh_add_ds_params_ie(struct sk_buff *skb,
-			  struct ieee80211_sub_if_data *sdata);
-int mesh_add_ht_cap_ie(struct sk_buff *skb,
-		       struct ieee80211_sub_if_data *sdata);
-int mesh_add_ht_oper_ie(struct sk_buff *skb,
-			struct ieee80211_sub_if_data *sdata);
+void mesh_mgmt_ies_add(struct ieee80211_sub_if_data *sdata,
+		       struct sk_buff *skb);
+int mesh_add_meshconf_ie(struct ieee80211_sub_if_data *sdata,
+			 struct sk_buff *skb);
+int mesh_add_meshid_ie(struct ieee80211_sub_if_data *sdata,
+		       struct sk_buff *skb);
+int mesh_add_rsn_ie(struct ieee80211_sub_if_data *sdata,
+		    struct sk_buff *skb);
+int mesh_add_vendor_ies(struct ieee80211_sub_if_data *sdata,
+			struct sk_buff *skb);
+int mesh_add_ht_cap_ie(struct ieee80211_sub_if_data *sdata,
+		       struct sk_buff *skb);
+int mesh_add_ht_oper_ie(struct ieee80211_sub_if_data *sdata,
+			struct sk_buff *skb);
 void mesh_rmc_free(struct ieee80211_sub_if_data *sdata);
 int mesh_rmc_init(struct ieee80211_sub_if_data *sdata);
 void ieee80211s_init(void);
 void ieee80211s_update_metric(struct ieee80211_local *local,
-		struct sta_info *sta, struct sk_buff *skb);
-void ieee80211s_stop(void);
+			      struct sta_info *sta, struct sk_buff *skb);
 void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata);
 int ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata);
 void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata);
@@ -263,31 +258,32 @@ void ieee80211_mps_frame_release(struct sta_info *sta,
 				 struct ieee802_11_elems *elems);
 
 /* Mesh paths */
-int mesh_nexthop_lookup(struct sk_buff *skb,
-		struct ieee80211_sub_if_data *sdata);
-int mesh_nexthop_resolve(struct sk_buff *skb,
-			 struct ieee80211_sub_if_data *sdata);
+int mesh_nexthop_lookup(struct ieee80211_sub_if_data *sdata,
+			struct sk_buff *skb);
+int mesh_nexthop_resolve(struct ieee80211_sub_if_data *sdata,
+			 struct sk_buff *skb);
 void mesh_path_start_discovery(struct ieee80211_sub_if_data *sdata);
-struct mesh_path *mesh_path_lookup(const u8 *dst,
-				   struct ieee80211_sub_if_data *sdata);
-struct mesh_path *mpp_path_lookup(u8 *dst,
-				  struct ieee80211_sub_if_data *sdata);
-int mpp_path_add(u8 *dst, u8 *mpp, struct ieee80211_sub_if_data *sdata);
-struct mesh_path *mesh_path_lookup_by_idx(int idx,
-		struct ieee80211_sub_if_data *sdata);
+struct mesh_path *mesh_path_lookup(struct ieee80211_sub_if_data *sdata,
+				   const u8 *dst);
+struct mesh_path *mpp_path_lookup(struct ieee80211_sub_if_data *sdata,
+				  const u8 *dst);
+int mpp_path_add(struct ieee80211_sub_if_data *sdata,
+		 const u8 *dst, const u8 *mpp);
+struct mesh_path *
+mesh_path_lookup_by_idx(struct ieee80211_sub_if_data *sdata, int idx);
 void mesh_path_fix_nexthop(struct mesh_path *mpath, struct sta_info *next_hop);
 void mesh_path_expire(struct ieee80211_sub_if_data *sdata);
 void mesh_rx_path_sel_frame(struct ieee80211_sub_if_data *sdata,
-		struct ieee80211_mgmt *mgmt, size_t len);
-int mesh_path_add(const u8 *dst, struct ieee80211_sub_if_data *sdata);
+			    struct ieee80211_mgmt *mgmt, size_t len);
+int mesh_path_add(struct ieee80211_sub_if_data *sdata, const u8 *dst);
 
 int mesh_path_add_gate(struct mesh_path *mpath);
 int mesh_path_send_to_gates(struct mesh_path *mpath);
 int mesh_gate_num(struct ieee80211_sub_if_data *sdata);
+
 /* Mesh plinks */
 void mesh_neighbour_update(struct ieee80211_sub_if_data *sdata,
-			   u8 *hw_addr,
-			   struct ieee802_11_elems *ie);
+			   u8 *hw_addr, struct ieee802_11_elems *ie);
 bool mesh_peer_accepts_plinks(struct ieee802_11_elems *ie);
 u32 mesh_accept_plinks_update(struct ieee80211_sub_if_data *sdata);
 void mesh_plink_broken(struct sta_info *sta);
@@ -304,19 +300,19 @@ void mesh_sta_cleanup(struct sta_info *sta);
 void mesh_mpath_table_grow(void);
 void mesh_mpp_table_grow(void);
 /* Mesh paths */
-int mesh_path_error_tx(u8 ttl, const u8 *target, __le32 target_sn,
-		       __le16 target_rcode, const u8 *ra,
-		       struct ieee80211_sub_if_data *sdata);
+int mesh_path_error_tx(struct ieee80211_sub_if_data *sdata,
+		       u8 ttl, const u8 *target, __le32 target_sn,
+		       __le16 target_rcode, const u8 *ra);
 void mesh_path_assign_nexthop(struct mesh_path *mpath, struct sta_info *sta);
 void mesh_path_flush_pending(struct mesh_path *mpath);
 void mesh_path_tx_pending(struct mesh_path *mpath);
 int mesh_pathtbl_init(void);
 void mesh_pathtbl_unregister(void);
-int mesh_path_del(u8 *addr, struct ieee80211_sub_if_data *sdata);
+int mesh_path_del(struct ieee80211_sub_if_data *sdata, const u8 *addr);
 void mesh_path_timer(unsigned long data);
 void mesh_path_flush_by_nexthop(struct sta_info *sta);
-void mesh_path_discard_frame(struct sk_buff *skb,
-		struct ieee80211_sub_if_data *sdata);
+void mesh_path_discard_frame(struct ieee80211_sub_if_data *sdata,
+			     struct sk_buff *skb);
 void mesh_path_quiesce(struct ieee80211_sub_if_data *sdata);
 void mesh_path_restart(struct ieee80211_sub_if_data *sdata);
 void mesh_path_tx_root_frame(struct ieee80211_sub_if_data *sdata);
@@ -325,8 +321,6 @@ bool mesh_action_is_path_sel(struct ieee80211_mgmt *mgmt);
 extern int mesh_paths_generation;
 
 #ifdef CONFIG_MAC80211_MESH
-extern int mesh_allocated;
-
 static inline
 u32 mesh_plink_inc_estab_count(struct ieee80211_sub_if_data *sdata)
 {
@@ -371,8 +365,8 @@ void mesh_plink_quiesce(struct sta_info *sta);
 void mesh_plink_restart(struct sta_info *sta);
 void mesh_path_flush_by_iface(struct ieee80211_sub_if_data *sdata);
 void mesh_sync_adjust_tbtt(struct ieee80211_sub_if_data *sdata);
+void ieee80211s_stop(void);
 #else
-#define mesh_allocated	0
 static inline void
 ieee80211_mesh_notify_scan_completed(struct ieee80211_local *local) {}
 static inline void ieee80211_mesh_quiesce(struct ieee80211_sub_if_data *sdata)
@@ -385,6 +379,7 @@ static inline bool mesh_path_sel_is_hwmp(struct ieee80211_sub_if_data *sdata)
 { return false; }
 static inline void mesh_path_flush_by_iface(struct ieee80211_sub_if_data *sdata)
 {}
+static inline void ieee80211s_stop(void) {}
 #endif
 
 #endif /* IEEE80211S_H */
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 585c1e2..bdb8d3b 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -238,9 +238,9 @@ static void prepare_frame_for_deferred_tx(struct ieee80211_sub_if_data *sdata,
  * also acquires in the TX path.  To avoid a deadlock we don't transmit the
  * frame directly but add it to the pending queue instead.
  */
-int mesh_path_error_tx(u8 ttl, const u8 *target, __le32 target_sn,
-		       __le16 target_rcode, const u8 *ra,
-		       struct ieee80211_sub_if_data *sdata)
+int mesh_path_error_tx(struct ieee80211_sub_if_data *sdata,
+		       u8 ttl, const u8 *target, __le32 target_sn,
+		       __le16 target_rcode, const u8 *ra)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
@@ -430,7 +430,7 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 		process = false;
 		fresh_info = false;
 	} else {
-		mpath = mesh_path_lookup(orig_addr, sdata);
+		mpath = mesh_path_lookup(sdata, orig_addr);
 		if (mpath) {
 			spin_lock_bh(&mpath->state_lock);
 			if (mpath->flags & MESH_PATH_FIXED)
@@ -445,8 +445,8 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 				}
 			}
 		} else {
-			mesh_path_add(orig_addr, sdata);
-			mpath = mesh_path_lookup(orig_addr, sdata);
+			mesh_path_add(sdata, orig_addr);
+			mpath = mesh_path_lookup(sdata, orig_addr);
 			if (!mpath) {
 				rcu_read_unlock();
 				return 0;
@@ -478,7 +478,7 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 	else {
 		fresh_info = true;
 
-		mpath = mesh_path_lookup(ta, sdata);
+		mpath = mesh_path_lookup(sdata, ta);
 		if (mpath) {
 			spin_lock_bh(&mpath->state_lock);
 			if ((mpath->flags & MESH_PATH_FIXED) ||
@@ -486,8 +486,8 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 					(last_hop_metric > mpath->metric)))
 				fresh_info = false;
 		} else {
-			mesh_path_add(ta, sdata);
-			mpath = mesh_path_lookup(ta, sdata);
+			mesh_path_add(sdata, ta);
+			mpath = mesh_path_lookup(sdata, ta);
 			if (!mpath) {
 				rcu_read_unlock();
 				return 0;
@@ -553,7 +553,7 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 	} else if (is_broadcast_ether_addr(target_addr) &&
 		   (target_flags & IEEE80211_PREQ_TO_FLAG)) {
 		rcu_read_lock();
-		mpath = mesh_path_lookup(orig_addr, sdata);
+		mpath = mesh_path_lookup(sdata, orig_addr);
 		if (mpath) {
 			if (flags & IEEE80211_PREQ_PROACTIVE_PREP_FLAG) {
 				reply = true;
@@ -568,7 +568,7 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 		rcu_read_unlock();
 	} else {
 		rcu_read_lock();
-		mpath = mesh_path_lookup(target_addr, sdata);
+		mpath = mesh_path_lookup(sdata, target_addr);
 		if (mpath) {
 			if ((!(mpath->flags & MESH_PATH_SN_VALID)) ||
 					SN_LT(mpath->sn, target_sn)) {
@@ -678,7 +678,7 @@ static void hwmp_prep_frame_process(struct ieee80211_sub_if_data *sdata,
 	}
 
 	rcu_read_lock();
-	mpath = mesh_path_lookup(orig_addr, sdata);
+	mpath = mesh_path_lookup(sdata, orig_addr);
 	if (mpath)
 		spin_lock_bh(&mpath->state_lock);
 	else
@@ -736,7 +736,7 @@ static void hwmp_perr_frame_process(struct ieee80211_sub_if_data *sdata,
 	target_rcode = PERR_IE_TARGET_RCODE(perr_elem);
 
 	rcu_read_lock();
-	mpath = mesh_path_lookup(target_addr, sdata);
+	mpath = mesh_path_lookup(sdata, target_addr);
 	if (mpath) {
 		struct sta_info *sta;
 
@@ -751,9 +751,10 @@ static void hwmp_perr_frame_process(struct ieee80211_sub_if_data *sdata,
 			spin_unlock_bh(&mpath->state_lock);
 			if (!ifmsh->mshcfg.dot11MeshForwarding)
 				goto endperr;
-			mesh_path_error_tx(ttl, target_addr, cpu_to_le32(target_sn),
+			mesh_path_error_tx(sdata, ttl, target_addr,
+					   cpu_to_le32(target_sn),
 					   cpu_to_le16(target_rcode),
-					   broadcast_addr, sdata);
+					   broadcast_addr);
 		} else
 			spin_unlock_bh(&mpath->state_lock);
 	}
@@ -801,10 +802,10 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 
 	metric_txsta = airtime_link_metric_get(local, sta);
 
-	mpath = mesh_path_lookup(orig_addr, sdata);
+	mpath = mesh_path_lookup(sdata, orig_addr);
 	if (!mpath) {
-		mesh_path_add(orig_addr, sdata);
-		mpath = mesh_path_lookup(orig_addr, sdata);
+		mesh_path_add(sdata, orig_addr);
+		mpath = mesh_path_lookup(sdata, orig_addr);
 		if (!mpath) {
 			rcu_read_unlock();
 			sdata->u.mesh.mshstats.dropped_frames_no_route++;
@@ -861,8 +862,7 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 
 
 void mesh_rx_path_sel_frame(struct ieee80211_sub_if_data *sdata,
-			    struct ieee80211_mgmt *mgmt,
-			    size_t len)
+			    struct ieee80211_mgmt *mgmt, size_t len)
 {
 	struct ieee802_11_elems elems;
 	size_t baselen;
@@ -1006,7 +1006,7 @@ void mesh_path_start_discovery(struct ieee80211_sub_if_data *sdata)
 	spin_unlock_bh(&ifmsh->mesh_preq_queue_lock);
 
 	rcu_read_lock();
-	mpath = mesh_path_lookup(preq_node->dst, sdata);
+	mpath = mesh_path_lookup(sdata, preq_node->dst);
 	if (!mpath)
 		goto enddiscovery;
 
@@ -1076,8 +1076,8 @@ enddiscovery:
  * Returns: 0 if the next hop was found and -ENOENT if the frame was queued.
  * skb is freeed here if no mpath could be allocated.
  */
-int mesh_nexthop_resolve(struct sk_buff *skb,
-			 struct ieee80211_sub_if_data *sdata)
+int mesh_nexthop_resolve(struct ieee80211_sub_if_data *sdata,
+			 struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -1091,17 +1091,17 @@ int mesh_nexthop_resolve(struct sk_buff *skb,
 		return 0;
 
 	rcu_read_lock();
-	err = mesh_nexthop_lookup(skb, sdata);
+	err = mesh_nexthop_lookup(sdata, skb);
 	if (!err)
 		goto endlookup;
 
 	/* no nexthop found, start resolving */
-	mpath = mesh_path_lookup(target_addr, sdata);
+	mpath = mesh_path_lookup(sdata, target_addr);
 	if (!mpath) {
-		mesh_path_add(target_addr, sdata);
-		mpath = mesh_path_lookup(target_addr, sdata);
+		mesh_path_add(sdata, target_addr);
+		mpath = mesh_path_lookup(sdata, target_addr);
 		if (!mpath) {
-			mesh_path_discard_frame(skb, sdata);
+			mesh_path_discard_frame(sdata, skb);
 			err = -ENOSPC;
 			goto endlookup;
 		}
@@ -1118,12 +1118,13 @@ int mesh_nexthop_resolve(struct sk_buff *skb,
 	skb_queue_tail(&mpath->frame_queue, skb);
 	err = -ENOENT;
 	if (skb_to_free)
-		mesh_path_discard_frame(skb_to_free, sdata);
+		mesh_path_discard_frame(sdata, skb_to_free);
 
 endlookup:
 	rcu_read_unlock();
 	return err;
 }
+
 /**
  * mesh_nexthop_lookup - put the appropriate next hop on a mesh frame. Calling
  * this function is considered "using" the associated mpath, so preempt a path
@@ -1134,8 +1135,8 @@ endlookup:
  *
  * Returns: 0 if the next hop was found. Nonzero otherwise.
  */
-int mesh_nexthop_lookup(struct sk_buff *skb,
-			struct ieee80211_sub_if_data *sdata)
+int mesh_nexthop_lookup(struct ieee80211_sub_if_data *sdata,
+			struct sk_buff *skb)
 {
 	struct mesh_path *mpath;
 	struct sta_info *next_hop;
@@ -1144,7 +1145,7 @@ int mesh_nexthop_lookup(struct sk_buff *skb,
 	int err = -ENOENT;
 
 	rcu_read_lock();
-	mpath = mesh_path_lookup(target_addr, sdata);
+	mpath = mesh_path_lookup(sdata, target_addr);
 
 	if (!mpath || !(mpath->flags & MESH_PATH_ACTIVE))
 		goto endlookup;
@@ -1203,8 +1204,7 @@ void mesh_path_timer(unsigned long data)
 	}
 }
 
-void
-mesh_path_tx_root_frame(struct ieee80211_sub_if_data *sdata)
+void mesh_path_tx_root_frame(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	u32 interval = ifmsh->mshcfg.dot11MeshHWMPRannInterval;
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 2ce4c40..6b3c4e1 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -24,9 +24,12 @@
 /* Keep the mean chain length below this constant */
 #define MEAN_CHAIN_LEN		2
 
-#define MPATH_EXPIRED(mpath) ((mpath->flags & MESH_PATH_ACTIVE) && \
-				time_after(jiffies, mpath->exp_time) && \
-				!(mpath->flags & MESH_PATH_FIXED))
+static inline bool mpath_expired(struct mesh_path *mpath)
+{
+	return (mpath->flags & MESH_PATH_ACTIVE) &&
+	       time_after(jiffies, mpath->exp_time) &&
+	       !(mpath->flags & MESH_PATH_FIXED);
+}
 
 struct mpath_node {
 	struct hlist_node list;
@@ -185,8 +188,8 @@ static u32 mesh_table_hash(const u8 *addr, struct ieee80211_sub_if_data *sdata,
 			   struct mesh_table *tbl)
 {
 	/* Use last four bytes of hw addr and interface index as hash index */
-	return jhash_2words(*(u32 *)(addr+2), sdata->dev->ifindex, tbl->hash_rnd)
-		& tbl->hash_mask;
+	return jhash_2words(*(u32 *)(addr+2), sdata->dev->ifindex,
+			    tbl->hash_rnd) & tbl->hash_mask;
 }
 
 
@@ -339,7 +342,7 @@ static struct mesh_path *mpath_lookup(struct mesh_table *tbl, const u8 *dst,
 		mpath = node->mpath;
 		if (mpath->sdata == sdata &&
 		    ether_addr_equal(dst, mpath->dst)) {
-			if (MPATH_EXPIRED(mpath)) {
+			if (mpath_expired(mpath)) {
 				spin_lock_bh(&mpath->state_lock);
 				mpath->flags &= ~MESH_PATH_ACTIVE;
 				spin_unlock_bh(&mpath->state_lock);
@@ -352,20 +355,21 @@ static struct mesh_path *mpath_lookup(struct mesh_table *tbl, const u8 *dst,
 
 /**
  * mesh_path_lookup - look up a path in the mesh path table
- * @dst: hardware address (ETH_ALEN length) of destination
  * @sdata: local subif
+ * @dst: hardware address (ETH_ALEN length) of destination
  *
  * Returns: pointer to the mesh path structure, or NULL if not found
  *
  * Locking: must be called within a read rcu section.
  */
-struct mesh_path *mesh_path_lookup(const u8 *dst,
-				   struct ieee80211_sub_if_data *sdata)
+struct mesh_path *
+mesh_path_lookup(struct ieee80211_sub_if_data *sdata, const u8 *dst)
 {
 	return mpath_lookup(rcu_dereference(mesh_paths), dst, sdata);
 }
 
-struct mesh_path *mpp_path_lookup(u8 *dst, struct ieee80211_sub_if_data *sdata)
+struct mesh_path *
+mpp_path_lookup(struct ieee80211_sub_if_data *sdata, const u8 *dst)
 {
 	return mpath_lookup(rcu_dereference(mpp_paths), dst, sdata);
 }
@@ -380,7 +384,8 @@ struct mesh_path *mpp_path_lookup(u8 *dst, struct ieee80211_sub_if_data *sdata)
  *
  * Locking: must be called within a read rcu section.
  */
-struct mesh_path *mesh_path_lookup_by_idx(int idx, struct ieee80211_sub_if_data *sdata)
+struct mesh_path *
+mesh_path_lookup_by_idx(struct ieee80211_sub_if_data *sdata, int idx)
 {
 	struct mesh_table *tbl = rcu_dereference(mesh_paths);
 	struct mpath_node *node;
@@ -392,7 +397,7 @@ struct mesh_path *mesh_path_lookup_by_idx(int idx, struct ieee80211_sub_if_data
 		if (sdata && node->mpath->sdata != sdata)
 			continue;
 		if (j++ == idx) {
-			if (MPATH_EXPIRED(node->mpath)) {
+			if (mpath_expired(node->mpath)) {
 				spin_lock_bh(&node->mpath->state_lock);
 				node->mpath->flags &= ~MESH_PATH_ACTIVE;
 				spin_unlock_bh(&node->mpath->state_lock);
@@ -436,11 +441,10 @@ int mesh_path_add_gate(struct mesh_path *mpath)
 	spin_lock_bh(&tbl->gates_lock);
 	hlist_add_head_rcu(&new_gate->list, tbl->known_gates);
 	spin_unlock_bh(&tbl->gates_lock);
-	rcu_read_unlock();
 	mpath_dbg(mpath->sdata,
 		  "Mesh path: Recorded new gate: %pM. %d known gates\n",
 		  mpath->dst, mpath->sdata->u.mesh.num_gates);
-	return 0;
+	err = 0;
 err_rcu:
 	rcu_read_unlock();
 	return err;
@@ -451,30 +455,27 @@ err_rcu:
  * @tbl: table which holds our list of known gates
  * @mpath: gate mpath
  *
- * Returns: 0 on success
- *
  * Locking: must be called inside rcu_read_lock() section
  */
-static int mesh_gate_del(struct mesh_table *tbl, struct mesh_path *mpath)
+static void mesh_gate_del(struct mesh_table *tbl, struct mesh_path *mpath)
 {
 	struct mpath_node *gate;
 	struct hlist_node *p, *q;
 
-	hlist_for_each_entry_safe(gate, p, q, tbl->known_gates, list)
-		if (gate->mpath == mpath) {
-			spin_lock_bh(&tbl->gates_lock);
-			hlist_del_rcu(&gate->list);
-			kfree_rcu(gate, rcu);
-			spin_unlock_bh(&tbl->gates_lock);
-			mpath->sdata->u.mesh.num_gates--;
-			mpath->is_gate = false;
-			mpath_dbg(mpath->sdata,
-				  "Mesh path: Deleted gate: %pM. %d known gates\n",
-				  mpath->dst, mpath->sdata->u.mesh.num_gates);
-			break;
-		}
-
-	return 0;
+	hlist_for_each_entry_safe(gate, p, q, tbl->known_gates, list) {
+		if (gate->mpath != mpath)
+			continue;
+		spin_lock_bh(&tbl->gates_lock);
+		hlist_del_rcu(&gate->list);
+		kfree_rcu(gate, rcu);
+		spin_unlock_bh(&tbl->gates_lock);
+		mpath->sdata->u.mesh.num_gates--;
+		mpath->is_gate = false;
+		mpath_dbg(mpath->sdata,
+			  "Mesh path: Deleted gate: %pM. %d known gates\n",
+			  mpath->dst, mpath->sdata->u.mesh.num_gates);
+		break;
+	}
 }
 
 /**
@@ -488,14 +489,14 @@ int mesh_gate_num(struct ieee80211_sub_if_data *sdata)
 
 /**
  * mesh_path_add - allocate and add a new path to the mesh path table
- * @addr: destination address of the path (ETH_ALEN length)
+ * @dst: destination address of the path (ETH_ALEN length)
  * @sdata: local subif
  *
  * Returns: 0 on success
  *
  * State: the initial state of the new path is set to 0
  */
-int mesh_path_add(const u8 *dst, struct ieee80211_sub_if_data *sdata)
+int mesh_path_add(struct ieee80211_sub_if_data *sdata, const u8 *dst)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee80211_local *local = sdata->local;
@@ -630,7 +631,8 @@ void mesh_mpp_table_grow(void)
 	write_unlock_bh(&pathtbl_resize_lock);
 }
 
-int mpp_path_add(u8 *dst, u8 *mpp, struct ieee80211_sub_if_data *sdata)
+int mpp_path_add(struct ieee80211_sub_if_data *sdata,
+		 const u8 *dst, const u8 *mpp)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee80211_local *local = sdata->local;
@@ -739,9 +741,10 @@ void mesh_plink_broken(struct sta_info *sta)
 			mpath->flags &= ~MESH_PATH_ACTIVE;
 			++mpath->sn;
 			spin_unlock_bh(&mpath->state_lock);
-			mesh_path_error_tx(sdata->u.mesh.mshcfg.element_ttl,
-					mpath->dst, cpu_to_le32(mpath->sn),
-					reason, bcast, sdata);
+			mesh_path_error_tx(sdata,
+					   sdata->u.mesh.mshcfg.element_ttl,
+					   mpath->dst, cpu_to_le32(mpath->sn),
+					   reason, bcast);
 		}
 	}
 	rcu_read_unlock();
@@ -856,7 +859,7 @@ void mesh_path_flush_by_iface(struct ieee80211_sub_if_data *sdata)
  *
  * Returns: 0 if successful
  */
-int mesh_path_del(u8 *addr, struct ieee80211_sub_if_data *sdata)
+int mesh_path_del(struct ieee80211_sub_if_data *sdata, const u8 *addr)
 {
 	struct mesh_table *tbl;
 	struct mesh_path *mpath;
@@ -965,8 +968,8 @@ int mesh_path_send_to_gates(struct mesh_path *mpath)
  *
  * Locking: the function must me called within a rcu_read_lock region
  */
-void mesh_path_discard_frame(struct sk_buff *skb,
-			     struct ieee80211_sub_if_data *sdata)
+void mesh_path_discard_frame(struct ieee80211_sub_if_data *sdata,
+			     struct sk_buff *skb)
 {
 	kfree_skb(skb);
 	sdata->u.mesh.mshstats.dropped_frames_no_route++;
@@ -984,7 +987,7 @@ void mesh_path_flush_pending(struct mesh_path *mpath)
 	struct sk_buff *skb;
 
 	while ((skb = skb_dequeue(&mpath->frame_queue)) != NULL)
-		mesh_path_discard_frame(skb, mpath->sdata);
+		mesh_path_discard_frame(mpath->sdata, skb);
 }
 
 /**
@@ -1105,7 +1108,7 @@ void mesh_path_expire(struct ieee80211_sub_if_data *sdata)
 		if ((!(mpath->flags & MESH_PATH_RESOLVING)) &&
 		    (!(mpath->flags & MESH_PATH_FIXED)) &&
 		     time_after(jiffies, mpath->exp_time + MESH_PATH_EXPIRE))
-			mesh_path_del(mpath->dst, mpath->sdata);
+			mesh_path_del(mpath->sdata, mpath->dst);
 	}
 	rcu_read_unlock();
 }
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index f7526e5..0b58e81 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -38,8 +38,8 @@ enum plink_event {
 };
 
 static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
-		enum ieee80211_self_protected_actioncode action,
-		u8 *da, __le16 llid, __le16 plid, __le16 reason);
+			       enum ieee80211_self_protected_actioncode action,
+			       u8 *da, __le16 llid, __le16 plid, __le16 reason);
 
 /**
  * mesh_plink_fsm_restart - restart a mesh peer link finite state machine
@@ -231,8 +231,9 @@ u32 mesh_plink_deactivate(struct sta_info *sta)
 }
 
 static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
-		enum ieee80211_self_protected_actioncode action,
-		u8 *da, __le16 llid, __le16 plid, __le16 reason) {
+			       enum ieee80211_self_protected_actioncode action,
+			       u8 *da, __le16 llid, __le16 plid, __le16 reason)
+{
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct ieee80211_tx_info *info;
@@ -283,13 +284,13 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 		}
 		if (ieee80211_add_srates_ie(sdata, skb, true, band) ||
 		    ieee80211_add_ext_srates_ie(sdata, skb, true, band) ||
-		    mesh_add_rsn_ie(skb, sdata) ||
-		    mesh_add_meshid_ie(skb, sdata) ||
-		    mesh_add_meshconf_ie(skb, sdata))
+		    mesh_add_rsn_ie(sdata, skb) ||
+		    mesh_add_meshid_ie(sdata, skb) ||
+		    mesh_add_meshconf_ie(sdata, skb))
 			goto free;
 	} else {	/* WLAN_SP_MESH_PEERING_CLOSE */
 		info->flags |= IEEE80211_TX_CTL_NO_ACK;
-		if (mesh_add_meshid_ie(skb, sdata))
+		if (mesh_add_meshid_ie(sdata, skb))
 			goto free;
 	}
 
@@ -333,12 +334,12 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (action != WLAN_SP_MESH_PEERING_CLOSE) {
-		if (mesh_add_ht_cap_ie(skb, sdata) ||
-		    mesh_add_ht_oper_ie(skb, sdata))
+		if (mesh_add_ht_cap_ie(sdata, skb) ||
+		    mesh_add_ht_oper_ie(sdata, skb))
 			goto free;
 	}
 
-	if (mesh_add_vendor_ies(skb, sdata))
+	if (mesh_add_vendor_ies(sdata, skb))
 		goto free;
 
 	ieee80211_tx_skb(sdata, skb);
@@ -666,8 +667,9 @@ u32 mesh_plink_block(struct sta_info *sta)
 }
 
 
-void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_mgmt *mgmt,
-			 size_t len, struct ieee80211_rx_status *rx_status)
+void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
+			 struct ieee80211_mgmt *mgmt, size_t len,
+			 struct ieee80211_rx_status *rx_status)
 {
 	struct mesh_config *mshcfg = &sdata->u.mesh.mshcfg;
 	struct ieee802_11_elems elems;
@@ -680,7 +682,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 	u8 *baseaddr;
 	u32 changed = 0;
 	__le16 plid, llid, reason;
-	static const char *mplstates[] = {
+	static const char * const mplstates[] = {
 		[NL80211_PLINK_LISTEN] = "LISTEN",
 		[NL80211_PLINK_OPN_SNT] = "OPN-SNT",
 		[NL80211_PLINK_OPN_RCVD] = "OPN-RCVD",
@@ -708,13 +710,15 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 		baselen += 4;
 	}
 	ieee802_11_parse_elems(baseaddr, len - baselen, &elems);
+
 	if (!elems.peering) {
 		mpl_dbg(sdata,
 			"Mesh plink: missing necessary peer link ie\n");
 		return;
 	}
+
 	if (elems.rsn_len &&
-			sdata->u.mesh.security == IEEE80211_MESH_SEC_NONE) {
+	    sdata->u.mesh.security == IEEE80211_MESH_SEC_NONE) {
 		mpl_dbg(sdata,
 			"Mesh plink: can't establish link with secure peer\n");
 		return;
@@ -733,7 +737,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 	}
 
 	if (ftype != WLAN_SP_MESH_PEERING_CLOSE &&
-				(!elems.mesh_id || !elems.mesh_config)) {
+	    (!elems.mesh_id || !elems.mesh_config)) {
 		mpl_dbg(sdata, "Mesh plink: missing necessary ie\n");
 		return;
 	}
diff --git a/net/mac80211/mesh_sync.c b/net/mac80211/mesh_sync.c
index aa8d1e4..05a256b 100644
--- a/net/mac80211/mesh_sync.c
+++ b/net/mac80211/mesh_sync.c
@@ -43,7 +43,7 @@ struct sync_method {
 static bool mesh_peer_tbtt_adjusting(struct ieee802_11_elems *ie)
 {
 	return (ie->mesh_config->meshconf_cap &
-	    IEEE80211_MESHCONF_CAPAB_TBTT_ADJUSTING) != 0;
+			IEEE80211_MESHCONF_CAPAB_TBTT_ADJUSTING) != 0;
 }
 
 void mesh_sync_adjust_tbtt(struct ieee80211_sub_if_data *sdata)
@@ -112,7 +112,8 @@ static void mesh_sync_offset_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 
 	if (elems->mesh_config && mesh_peer_tbtt_adjusting(elems)) {
 		clear_sta_flag(sta, WLAN_STA_TOFFSET_KNOWN);
-		msync_dbg(sdata, "STA %pM : is adjusting TBTT\n", sta->sta.addr);
+		msync_dbg(sdata, "STA %pM : is adjusting TBTT\n",
+			  sta->sta.addr);
 		goto no_sync;
 	}
 
@@ -129,18 +130,15 @@ static void mesh_sync_offset_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 	sta->t_offset = t_t - t_r;
 
 	if (test_sta_flag(sta, WLAN_STA_TOFFSET_KNOWN)) {
-		s64 t_clockdrift = sta->t_offset_setpoint
-				   - sta->t_offset;
+		s64 t_clockdrift = sta->t_offset_setpoint - sta->t_offset;
 		msync_dbg(sdata,
 			  "STA %pM : sta->t_offset=%lld, sta->t_offset_setpoint=%lld, t_clockdrift=%lld\n",
-			  sta->sta.addr,
-			  (long long) sta->t_offset,
-			  (long long)
-			  sta->t_offset_setpoint,
+			  sta->sta.addr, (long long) sta->t_offset,
+			  (long long) sta->t_offset_setpoint,
 			  (long long) t_clockdrift);
 
 		if (t_clockdrift > TOFFSET_MAXIMUM_ADJUSTMENT ||
-			t_clockdrift < -TOFFSET_MAXIMUM_ADJUSTMENT) {
+		    t_clockdrift < -TOFFSET_MAXIMUM_ADJUSTMENT) {
 			msync_dbg(sdata,
 				  "STA %pM : t_clockdrift=%lld too large, setpoint reset\n",
 				  sta->sta.addr,
@@ -149,15 +147,10 @@ static void mesh_sync_offset_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 			goto no_sync;
 		}
 
-		rcu_read_unlock();
-
 		spin_lock_bh(&ifmsh->sync_offset_lock);
-		if (t_clockdrift >
-		    ifmsh->sync_offset_clockdrift_max)
-			ifmsh->sync_offset_clockdrift_max
-				= t_clockdrift;
+		if (t_clockdrift > ifmsh->sync_offset_clockdrift_max)
+			ifmsh->sync_offset_clockdrift_max = t_clockdrift;
 		spin_unlock_bh(&ifmsh->sync_offset_lock);
-
 	} else {
 		sta->t_offset_setpoint = sta->t_offset - TOFFSET_SET_MARGIN;
 		set_sta_flag(sta, WLAN_STA_TOFFSET_KNOWN);
@@ -165,9 +158,7 @@ static void mesh_sync_offset_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 			  "STA %pM : offset was invalid, sta->t_offset=%lld\n",
 			  sta->sta.addr,
 			  (long long) sta->t_offset);
-		rcu_read_unlock();
 	}
-	return;
 
 no_sync:
 	rcu_read_unlock();
@@ -177,14 +168,12 @@ static void mesh_sync_offset_adjust_tbtt(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 
-	WARN_ON(ifmsh->mesh_sp_id
-		!= IEEE80211_SYNC_METHOD_NEIGHBOR_OFFSET);
+	WARN_ON(ifmsh->mesh_sp_id != IEEE80211_SYNC_METHOD_NEIGHBOR_OFFSET);
 	BUG_ON(!rcu_read_lock_held());
 
 	spin_lock_bh(&ifmsh->sync_offset_lock);
 
-	if (ifmsh->sync_offset_clockdrift_max >
-		TOFFSET_MINIMUM_ADJUSTMENT) {
+	if (ifmsh->sync_offset_clockdrift_max > TOFFSET_MINIMUM_ADJUSTMENT) {
 		/* Since ajusting the tsf here would
 		 * require a possibly blocking call
 		 * to the driver tsf setter, we punt
@@ -193,8 +182,7 @@ static void mesh_sync_offset_adjust_tbtt(struct ieee80211_sub_if_data *sdata)
 		msync_dbg(sdata,
 			  "TBTT : kicking off TBTT adjustment with clockdrift_max=%lld\n",
 			  ifmsh->sync_offset_clockdrift_max);
-		set_bit(MESH_WORK_DRIFT_ADJUST,
-			&ifmsh->wrkq_flags);
+		set_bit(MESH_WORK_DRIFT_ADJUST, &ifmsh->wrkq_flags);
 
 		ifmsh->adjusting_tbtt = true;
 	} else {
@@ -220,14 +208,11 @@ static const struct sync_method sync_methods[] = {
 
 const struct ieee80211_mesh_sync_ops *ieee80211_mesh_sync_ops_get(u8 method)
 {
-	const struct ieee80211_mesh_sync_ops *ops = NULL;
-	u8 i;
+	int i;
 
 	for (i = 0 ; i < ARRAY_SIZE(sync_methods); ++i) {
-		if (sync_methods[i].method == method) {
-			ops = &sync_methods[i].ops;
-			break;
-		}
+		if (sync_methods[i].method == method)
+			return &sync_methods[i].ops;
 	}
-	return ops;
+	return NULL;
 }
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 3acb70b..bb73ed2d 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2027,7 +2027,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 	/* frame is in RMC, don't forward */
 	if (ieee80211_is_data(hdr->frame_control) &&
 	    is_multicast_ether_addr(hdr->addr1) &&
-	    mesh_rmc_check(hdr->addr3, mesh_hdr, rx->sdata))
+	    mesh_rmc_check(rx->sdata, hdr->addr3, mesh_hdr))
 		return RX_DROP_MONITOR;
 
 	if (!ieee80211_is_data(hdr->frame_control) ||
@@ -2054,9 +2054,9 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 		}
 
 		rcu_read_lock();
-		mppath = mpp_path_lookup(proxied_addr, sdata);
+		mppath = mpp_path_lookup(sdata, proxied_addr);
 		if (!mppath) {
-			mpp_path_add(proxied_addr, mpp_addr, sdata);
+			mpp_path_add(sdata, proxied_addr, mpp_addr);
 		} else {
 			spin_lock_bh(&mppath->state_lock);
 			if (!ether_addr_equal(mppath->mpp, mpp_addr))
@@ -2104,13 +2104,13 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 		memcpy(fwd_hdr->addr2, sdata->vif.addr, ETH_ALEN);
 		/* update power mode indication when forwarding */
 		ieee80211_mps_set_frame_flags(sdata, NULL, fwd_hdr);
-	} else if (!mesh_nexthop_lookup(fwd_skb, sdata)) {
+	} else if (!mesh_nexthop_lookup(sdata, fwd_skb)) {
 		/* mesh power mode flags updated in mesh_nexthop_lookup */
 		IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, fwded_unicast);
 	} else {
 		/* unable to resolve next hop */
-		mesh_path_error_tx(ifmsh->mshcfg.element_ttl, fwd_hdr->addr3,
-				   0, reason, fwd_hdr->addr2, sdata);
+		mesh_path_error_tx(sdata, ifmsh->mshcfg.element_ttl,
+				   fwd_hdr->addr3, 0, reason, fwd_hdr->addr2);
 		IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, dropped_frames_no_route);
 		kfree_skb(fwd_skb);
 		return RX_DROP_MONITOR;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index fe644f9..5b9602b 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1495,7 +1495,7 @@ void ieee80211_xmit(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 		if (ieee80211_is_data(hdr->frame_control) &&
 		    is_unicast_ether_addr(hdr->addr1)) {
-			if (mesh_nexthop_resolve(skb, sdata))
+			if (mesh_nexthop_resolve(sdata, skb))
 				return; /* skb queued: don't free */
 		} else {
 			ieee80211_mps_set_frame_flags(sdata, NULL, hdr);
@@ -1844,9 +1844,9 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		}
 
 		if (!is_multicast_ether_addr(skb->data)) {
-			mpath = mesh_path_lookup(skb->data, sdata);
+			mpath = mesh_path_lookup(sdata, skb->data);
 			if (!mpath)
-				mppath = mpp_path_lookup(skb->data, sdata);
+				mppath = mpp_path_lookup(sdata, skb->data);
 		}
 
 		/*
@@ -1859,8 +1859,8 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		    !(mppath && !ether_addr_equal(mppath->mpp, skb->data))) {
 			hdrlen = ieee80211_fill_mesh_addresses(&hdr, &fc,
 					skb->data, skb->data + ETH_ALEN);
-			meshhdrlen = ieee80211_new_mesh_header(&mesh_hdr,
-					sdata, NULL, NULL);
+			meshhdrlen = ieee80211_new_mesh_header(sdata, &mesh_hdr,
+							       NULL, NULL);
 		} else {
 			/* DS -> MBSS (802.11-2012 13.11.3.3).
 			 * For unicast with unknown forwarding information,
@@ -1879,18 +1879,14 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 					mesh_da, sdata->vif.addr);
 			if (is_multicast_ether_addr(mesh_da))
 				/* DA TA mSA AE:SA */
-				meshhdrlen =
-					ieee80211_new_mesh_header(&mesh_hdr,
-							sdata,
-							skb->data + ETH_ALEN,
-							NULL);
+				meshhdrlen = ieee80211_new_mesh_header(
+						sdata, &mesh_hdr,
+						skb->data + ETH_ALEN, NULL);
 			else
 				/* RA TA mDA mSA AE:DA SA */
-				meshhdrlen =
-					ieee80211_new_mesh_header(&mesh_hdr,
-							sdata,
-							skb->data,
-							skb->data + ETH_ALEN);
+				meshhdrlen = ieee80211_new_mesh_header(
+						sdata, &mesh_hdr, skb->data,
+						skb->data + ETH_ALEN);
 
 		}
 		chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
-- 
1.8.0

