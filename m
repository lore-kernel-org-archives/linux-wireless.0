Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793651942;
	b=ExDUDhs3cSAfYzVFpmFckIMuW36Sz+3wt89ML7JERDv9LIuJhU4S2m8xmtEORtq21b9n
	 xlbwIAyPNnuhpvifhSq5MvJWngOTl+HVr/hHYl9EQuRHcjN2ykiAP08y9Y/u3+vTTcz/q
	 JrRB6OWovCyWFjpUrQYj/bpOGSBsbriqlBPT80WBU7XI9uy7fRDHqsRsFcGm/UtZzaOj/
	 VUtawf0cGNHsi52f69aVVJNRjtDwiDApWHpvXHRMMzlA71ATVS6WU8M9lnEc5vg/hC0Tw
	 u98i4YCgvD71nVL2mHfY8kzH5Z0z78TU8mRHw9ZNAdPqhw/Oawvcltpavvlikd8mBKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793651942;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=/r7rOYVOuud0GvGiT5C7pXTRYb6oQI82VbAyZkaOE1g=;
	b=NP5J9sBoiSmNdmbm+rtToLpSr5TNXdDLbmxGqvTp0YxDOwWr5WVxnmnka1fVLaXYRcLS
	 DZ8cKSU88hSxugRsv61oxTJ6yOKNFssuh2rIquNameWqX/FMIMBXkwIJ8wokJY8mT8Qvu
	 mrymB+GyiCdMnuZoZTDajh61mIkKZpcvYIcpqAbTXjie2EJl3H2SY3mP03rMCZmDT29Ry
	 7cxlEG+Fuhkk/WDJ+6qGjUJAl8LTu/UFXM1+L1oyBmaKQK3jWtY0eepKJ9Y46s3+qsjMa
	 vJBfQGNwFueLAVzB6IC7QpRSVJlpCHoRbsSsedbiAKw8c6Q4md4Uo78vrRJybe6mnPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=UAZCO4mM;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D18F606A330
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 20:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=UAZCO4mM
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=/r7rOYVOuud0GvGiT5C7pXTRYb6oQI82VbAyZkaOE1g=;
	t=1793651940; x=1794861540; b=UAZCO4mMNyKU8MAmIqYZM83QFvWCiHXKMFmbfG9gPR0VyA0
	igXUhnbH77zzk5wwfQ2twg/WfZ7ML+PUrQY/m/3bZpjUzJb/SzXjIaQ8NXKPMLWtTtHjBsmK9G4pK
	HCLJ9Ye41IVAV2D7/2UZECZ+rfKDrHdXmxl/n+RVseBWr/Y/c7uwWOCvE/fInuzYss/7TKSxXquhe
	ZeOA4JrDIXUL3B0qD9RJuG99c8tYKsVY1xohjMkwBIVOSswkruMCMu2oNp2gzNNmTjQskPKHq+aQN
	3ILFFfIxNXkBnoWofCh8mrBxFvaLCjyWi5R5n/E3AfRXfRrANccAUgndWlSWgxbA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNyny-00000001vzr-3Xms;
	Mon, 02 Nov 2026 21:38:59 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 21/30] wifi: mac80211: buffer multicast frames on vif TXQ
Date: Mon,  2 Nov 2026 21:23:11 +0100
Message-ID: <20261102203831.1058362-53-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102203831.1058362-32-johannes@sipsolutions.net>
References: <20261102203831.1058362-32-johannes@sipsolutions.net>
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

For devices with HOST_BROADCAST_PS_BUFFERING, mcast
frames are buffered in aanother bc_buf queue while
any station is sleeping, for after DTIM, so drivers
can retrieve them with ieee80211_get_buffered_bc().

Put them on the interface TXQ instead and block it
until the frames can be released.

Frame processing is now on dequeue, like all other
frames, so IEEE80211_TX_PS_BUFFERED can go away.

Remove the total_ps_buffered debugfs file, we can't
really provide it easily now.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c            |   3 +-
 net/mac80211/debugfs.c        |   3 -
 net/mac80211/debugfs_netdev.c |   9 +-
 net/mac80211/ieee80211_i.h    |  15 +--
 net/mac80211/iface.c          |  24 +---
 net/mac80211/mesh.c           |   4 +-
 net/mac80211/tx.c             | 211 ++++++++++++++++++----------------
 7 files changed, 130 insertions(+), 139 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 6e466f8e1653..b8385789d6e9 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2369,8 +2369,7 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev,
 	drv_stop_ap(sdata->local, sdata, link_conf);
 
 	/* free all potentially still buffered bcast frames */
-	local->total_ps_buffered -= skb_queue_len(&sdata->u.ap.ps.bc_buf);
-	ieee80211_purge_tx_queue(&local->hw, &sdata->u.ap.ps.bc_buf);
+	ieee80211_txq_purge_mcast_ps(local, sdata);
 
 	ieee80211_link_copy_chanctx_to_vlans(link, true);
 	ieee80211_link_release_channel(link);
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 027db8b9f846..e7c1d376b98d 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -64,8 +64,6 @@ DEBUGFS_READONLY_FILE(user_power, "%d",
 		      local->user_power_level);
 DEBUGFS_READONLY_FILE(power, "%d",
 		      local->hw.conf.power_level);
-DEBUGFS_READONLY_FILE(total_ps_buffered, "%d",
-		      local->total_ps_buffered);
 DEBUGFS_READONLY_FILE(wep_iv, "%#08x",
 		      local->wep_iv & 0xffffff);
 DEBUGFS_READONLY_FILE(rate_ctrl_alg, "%s",
@@ -654,7 +652,6 @@ void debugfs_hw_add(struct ieee80211_local *local)
 
 	local->debugfs.keys = debugfs_create_dir("keys", phyd);
 
-	DEBUGFS_ADD(total_ps_buffered);
 	DEBUGFS_ADD(wep_iv);
 	DEBUGFS_ADD(rate_ctrl_alg);
 	DEBUGFS_ADD(queues);
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 81d18ab83543..616546eee2cf 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -608,8 +608,15 @@ IEEE80211_IF_FILE(num_mcast_sta_vlan, u.vlan.num_mcast_sta, ATOMIC);
 static ssize_t ieee80211_if_fmt_num_buffered_multicast(
 	const struct ieee80211_sub_if_data *sdata, char *buf, int buflen)
 {
+	struct txq_info *txqi;
+
+	if (!sdata->vif.txq)
+		return scnprintf(buf, buflen, "0\n");
+
+	txqi = to_txq_info(sdata->vif.txq);
 	return scnprintf(buf, buflen, "%u\n",
-			 skb_queue_len(&sdata->u.ap.ps.bc_buf));
+			 test_bit(IEEE80211_TXQ_MCAST_PS, &txqi->flags) ?
+			 txqi->tin.backlog_packets : 0);
 }
 IEEE80211_IF_FILE_R(num_buffered_multicast);
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 89581935659c..b498765afa20 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -45,11 +45,6 @@ struct ieee80211_mesh_fast_tx;
  * associated stations are using power saving. */
 #define AP_MAX_BC_BUFFER 128
 
-/* Maximum number of multicast frames buffered for all interfaces.
- * Note: increasing this limit increases the potential memory requirement. Each
- * frame can be up to about 2 kB long. */
-#define TOTAL_MAX_TX_BUFFER 512
-
 /* Required encryption head and tailroom */
 #define IEEE80211_ENCRYPT_HEADROOM 8
 #define IEEE80211_ENCRYPT_TAILROOM 26 /* current max: GMAC/CMAC-256 MME */
@@ -188,7 +183,6 @@ typedef unsigned __bitwise ieee80211_tx_result;
 #define TX_QUEUED	((__force ieee80211_tx_result) 2u)
 
 #define IEEE80211_TX_UNICAST		BIT(1)
-#define IEEE80211_TX_PS_BUFFERED	BIT(2)
 
 struct ieee80211_tx_data {
 	struct sk_buff *skb;
@@ -341,7 +335,6 @@ struct ps_data {
 	 * NB: don't touch this bitmap, use sta_info_{set,clear}_tim_bit */
 	u8 tim[sizeof(unsigned long) * BITS_TO_LONGS(IEEE80211_MAX_AID + 1)]
 			__aligned(__alignof__(unsigned long));
-	struct sk_buff_head bc_buf;
 	atomic_t num_sta_ps; /* number of stations in PS mode */
 	int dtim_count;
 	bool dtim_bc_mc;
@@ -979,6 +972,8 @@ enum txq_info_flags {
 	IEEE80211_TXQ_NO_AMSDU,
 	IEEE80211_TXQ_DIRTY,
 	IEEE80211_TXQ_PS_BACKLOG,
+	/* on the interface TXQ: frames held until after the DTIM beacon */
+	IEEE80211_TXQ_MCAST_PS,
 };
 
 /**
@@ -1717,10 +1712,6 @@ struct ieee80211_local {
 #endif /* CONFIG_MAC80211_DEBUG_COUNTERS */
 
 
-	int total_ps_buffered; /* total number of all buffered multicast
-				* packets for power saving stations
-				*/
-
 	bool pspolling;
 	/*
 	 * PS can only be enabled when we have exactly one managed
@@ -2745,6 +2736,8 @@ bool ieee80211_txq_queue_filtered(struct ieee80211_local *local,
 				  struct txq_info *txqi, struct sk_buff *skb);
 void ieee80211_txq_purge(struct ieee80211_local *local,
 			 struct txq_info *txqi);
+void ieee80211_txq_purge_mcast_ps(struct ieee80211_local *local,
+				  const struct ieee80211_sub_if_data *sdata);
 void ieee80211_purge_sta_txqs(struct sta_info *sta);
 void ieee80211_txq_remove_vlan(struct ieee80211_local *local,
 			       struct ieee80211_sub_if_data *sdata);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index a4f29444ba45..b1666ab2d5d0 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -485,7 +485,6 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata, bool going_do
 	struct sk_buff *skb, *tmp;
 	u32 hw_reconf_flags = 0;
 	int i, flushed;
-	struct ps_data *ps;
 	struct cfg80211_chan_def chandef;
 	bool cancel_scan;
 	struct cfg80211_nan_func *func;
@@ -584,28 +583,8 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata, bool going_do
 				   GFP_KERNEL, 0);
 	}
 
-	if (sdata->vif.type == NL80211_IFTYPE_AP) {
+	if (sdata->vif.type == NL80211_IFTYPE_AP)
 		WARN_ON(!list_empty(&sdata->u.ap.vlans));
-	} else if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
-		/* remove all packets in parent bc_buf pointing to this dev */
-		__skb_queue_head_init(&freeq);
-		ps = &sdata->bss->ps;
-
-		spin_lock_irqsave(&ps->bc_buf.lock, flags);
-		skb_queue_walk_safe(&ps->bc_buf, skb, tmp) {
-			if (skb->dev == sdata->dev) {
-				__skb_unlink(skb, &ps->bc_buf);
-				local->total_ps_buffered--;
-				__skb_queue_tail(&freeq, skb);
-			}
-		}
-		spin_unlock_irqrestore(&ps->bc_buf.lock, flags);
-
-		skb_queue_walk_safe(&freeq, skb, tmp) {
-			__skb_unlink(skb, &freeq);
-			ieee80211_free_txskb(&local->hw, skb);
-		}
-	}
 
 	if (going_down)
 		local->open_count--;
@@ -1948,7 +1927,6 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 		sdata->vif.p2p = true;
 		fallthrough;
 	case NL80211_IFTYPE_AP:
-		skb_queue_head_init(&sdata->u.ap.ps.bc_buf);
 		INIT_LIST_HEAD(&sdata->u.ap.vlans);
 		sdata->vif.bss_conf.bssid = sdata->vif.addr;
 		break;
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 5f523e14cf84..99baf8293196 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1243,8 +1243,7 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 	kfree_rcu(bcn, rcu_head);
 
 	/* free all potentially still buffered group-addressed frames */
-	local->total_ps_buffered -= skb_queue_len(&ifmsh->ps.bc_buf);
-	skb_queue_purge(&ifmsh->ps.bc_buf);
+	ieee80211_txq_purge_mcast_ps(local, sdata);
 
 	timer_delete_sync(&sdata->u.mesh.housekeeping_timer);
 	timer_delete_sync(&sdata->u.mesh.mesh_path_root_timer);
@@ -1789,7 +1788,6 @@ void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata)
 	timer_setup(&ifmsh->mesh_path_root_timer,
 		    ieee80211_mesh_path_root_timer, 0);
 	INIT_LIST_HEAD(&ifmsh->preq_queue.list);
-	skb_queue_head_init(&ifmsh->ps.bc_buf);
 	spin_lock_init(&ifmsh->mesh_preq_queue_lock);
 	spin_lock_init(&ifmsh->sync_offset_lock);
 	RCU_INIT_POINTER(ifmsh->beacon, NULL);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 0b322bef5a40..0361cdfdbb70 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -279,9 +279,6 @@ ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
 	if (tx->sdata->vif.type == NL80211_IFTYPE_OCB)
 		return TX_CONTINUE;
 
-	if (tx->flags & IEEE80211_TX_PS_BUFFERED)
-		return TX_CONTINUE;
-
 	if (tx->sta)
 		assoc = test_sta_flag(tx->sta, WLAN_STA_ASSOC);
 
@@ -328,14 +325,45 @@ static void fq_skb_free_func(struct fq *fq,
 	ieee80211_free_txskb(&local->hw, skb);
 }
 
+static struct sk_buff *ieee80211_txq_dequeue_oldest(struct fq *fq,
+						    struct fq_tin *tin)
+{
+	struct list_head *lists[] = { &tin->new_flows, &tin->old_flows };
+	struct fq_flow *flow, *oldest = NULL;
+	codel_time_t oldest_time = 0;
+
+	lockdep_assert_held(&fq->lock);
+
+	for (int i = 0; i < ARRAY_SIZE(lists); i++) {
+		list_for_each_entry(flow, lists[i], flowchain) {
+			struct sk_buff *skb = skb_peek(&flow->queue);
+			codel_time_t t;
+
+			if (!skb)
+				continue;
+
+			t = IEEE80211_SKB_CB(skb)->control.enqueue_time;
+			if (!oldest || codel_time_before(t, oldest_time)) {
+				oldest = flow;
+				oldest_time = t;
+			}
+		}
+	}
+
+	if (!oldest)
+		return NULL;
+
+	return fq_flow_dequeue(fq, oldest);
+}
+
 static void ieee80211_txq_enqueue(struct ieee80211_local *local,
 				  struct txq_info *txqi,
 				  struct sk_buff *skb)
 {
+	struct sk_buff *drop = NULL, *drop_oldest = NULL;
 	struct fq *fq = &local->fq;
 	struct fq_tin *tin = &txqi->tin;
 	struct sta_info *sta = NULL;
-	struct sk_buff *drop = NULL;
 	bool was_empty;
 	u32 flow_idx;
 
@@ -368,12 +396,27 @@ static void ieee80211_txq_enqueue(struct ieee80211_local *local,
 			__skb_queue_tail(&txqi->frags, skb);
 		}
 	} else {
+		if (unlikely(!txqi->txq.sta &&
+			     IEEE80211_SKB_CB(skb)->flags &
+			     IEEE80211_TX_CTL_SEND_AFTER_DTIM)) {
+			set_bit(IEEE80211_TXQ_MCAST_PS, &txqi->flags);
+			if (tin->backlog_packets >= AP_MAX_BC_BUFFER)
+				drop_oldest = ieee80211_txq_dequeue_oldest(fq,
+									   tin);
+		}
+
 		flow_idx = fq_flow_idx(fq, skb);
 		fq_tin_enqueue(fq, tin, flow_idx, skb,
 			       fq_skb_free_func);
 	}
 	spin_unlock_bh(&fq->lock);
 
+	if (unlikely(drop_oldest)) {
+		ps_dbg(vif_to_sdata(txqi->txq.vif),
+		       "BC TX buffer full - dropping the oldest frame\n");
+		ieee80211_free_txskb(&local->hw, drop_oldest);
+	}
+
 	if (unlikely(drop)) {
 		ps_dbg(sta->sdata,
 		       "STA %pM management TXQ full - dropping frame\n",
@@ -388,43 +431,12 @@ static void ieee80211_txq_enqueue(struct ieee80211_local *local,
 	}
 }
 
-/* This function is called whenever the AP is about to exceed the maximum limit
- * of buffered multicast frames for power saving STAs. This situation should not
- * really happen often during normal operation, so dropping the oldest buffered
- * packet from each queue should be OK to make some room for new frames. */
-static void purge_old_ps_buffers(struct ieee80211_local *local)
-{
-	int total = 0, purged = 0;
-	struct sk_buff *skb;
-	struct ieee80211_sub_if_data *sdata;
-
-	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-		struct ps_data *ps;
-
-		if (sdata->vif.type == NL80211_IFTYPE_AP)
-			ps = &sdata->u.ap.ps;
-		else if (ieee80211_vif_is_mesh(&sdata->vif))
-			ps = &sdata->u.mesh.ps;
-		else
-			continue;
-
-		skb = skb_dequeue(&ps->bc_buf);
-		if (skb) {
-			purged++;
-			ieee80211_free_txskb(&local->hw, skb);
-		}
-		total += skb_queue_len(&ps->bc_buf);
-	}
-
-	local->total_ps_buffered = total;
-	ps_dbg_hw(&local->hw, "PS buffers full - purged %d frames\n", purged);
-}
-
 static ieee80211_tx_result
 ieee80211_tx_h_multicast_ps_buf(struct ieee80211_tx_data *tx)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
+	struct ieee80211_sub_if_data *sdata = tx->sdata;
 	struct ps_data *ps;
 
 	/*
@@ -432,7 +444,7 @@ ieee80211_tx_h_multicast_ps_buf(struct ieee80211_tx_data *tx)
 	 *
 	 * If any of the associated/peer stations is in power save mode,
 	 * the frame is buffered to be sent after DTIM beacon frame.
-	 * This is done either by the hardware or us.
+	 * This is done either by the hardware or us (on the interface TXQ).
 	 */
 
 	/* powersaving STAs currently only in AP/VLAN/mesh mode */
@@ -442,6 +454,8 @@ ieee80211_tx_h_multicast_ps_buf(struct ieee80211_tx_data *tx)
 			return TX_CONTINUE;
 
 		ps = &tx->sdata->bss->ps;
+		sdata = container_of(tx->sdata->bss,
+				     struct ieee80211_sub_if_data, u.ap);
 	} else if (ieee80211_vif_is_mesh(&tx->sdata->vif)) {
 		ps = &tx->sdata->u.mesh.ps;
 	} else {
@@ -460,29 +474,15 @@ ieee80211_tx_h_multicast_ps_buf(struct ieee80211_tx_data *tx)
 		info->hw_queue = tx->sdata->vif.cab_queue;
 
 	/* no stations in PS mode and no buffered packets */
-	if (!atomic_read(&ps->num_sta_ps) && skb_queue_empty(&ps->bc_buf))
+	if (!atomic_read(&ps->num_sta_ps) &&
+	    !(sdata->vif.txq &&
+	      test_bit(IEEE80211_TXQ_MCAST_PS,
+		       &to_txq_info(sdata->vif.txq)->flags)))
 		return TX_CONTINUE;
 
 	info->flags |= IEEE80211_TX_CTL_SEND_AFTER_DTIM;
 
-	/* device releases frame after DTIM beacon */
-	if (!ieee80211_hw_check(&tx->local->hw, HOST_BROADCAST_PS_BUFFERING))
-		return TX_CONTINUE;
-
-	/* buffered in mac80211 */
-	if (tx->local->total_ps_buffered >= TOTAL_MAX_TX_BUFFER)
-		purge_old_ps_buffers(tx->local);
-
-	if (skb_queue_len(&ps->bc_buf) >= AP_MAX_BC_BUFFER) {
-		ps_dbg(tx->sdata,
-		       "BC TX buffer full - dropping the oldest frame\n");
-		ieee80211_free_txskb(&tx->local->hw, skb_dequeue(&ps->bc_buf));
-	} else
-		tx->local->total_ps_buffered++;
-
-	skb_queue_tail(&ps->bc_buf, tx->skb);
-
-	return TX_QUEUED;
+	return TX_CONTINUE;
 }
 
 static int ieee80211_use_mfp(__le16 fc, struct sta_info *sta,
@@ -565,9 +565,6 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_ps_buf(struct ieee80211_tx_data *tx)
 {
-	if (unlikely(tx->flags & IEEE80211_TX_PS_BUFFERED))
-		return TX_CONTINUE;
-
 	if (tx->flags & IEEE80211_TX_UNICAST)
 		return ieee80211_tx_h_unicast_ps_buf(tx);
 	else
@@ -1323,11 +1320,18 @@ static struct txq_info *ieee80211_get_txq(struct ieee80211_local *local,
 	struct ieee80211_txq *txq = NULL;
 
 	/* TXQs buffer frames, send unbuffered ones directly */
-	if (info->flags & (IEEE80211_TX_CTL_SEND_AFTER_DTIM |
-			   IEEE80211_TX_CTL_NO_PS_BUFFER) ||
+	if ((info->flags & IEEE80211_TX_CTL_NO_PS_BUFFER) ||
 	    (info->control.flags & IEEE80211_TX_CTRL_PS_RESPONSE))
 		return NULL;
 
+	if (info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) {
+		if (!ieee80211_hw_check(&local->hw,
+					HOST_BROADCAST_PS_BUFFERING) ||
+		    !vif->txq)
+			return NULL;
+		return to_txq_info(vif->txq);
+	}
+
 	/*
 	 * While (re)association request/response frames are not considered
 	 * bufferable MMPDUs, use the TXQ abstraction for the transmission of
@@ -1417,7 +1421,7 @@ static void codel_drop_func(struct sk_buff *skb,
 	ieee80211_free_txskb(hw, skb);
 }
 
-/* bypass codel since PS can last a long time */
+/* bypass codel since PS or DTIM buffering can last a long time */
 static bool ieee80211_txq_codel_bypass(struct txq_info *txqi,
 				       const struct fq_flow *flow)
 {
@@ -1425,7 +1429,7 @@ static bool ieee80211_txq_codel_bypass(struct txq_info *txqi,
 	struct sk_buff *skb;
 
 	if (!txqi->txq.sta)
-		return false;
+		return test_bit(IEEE80211_TXQ_MCAST_PS, &txqi->flags);
 
 	sta = container_of(txqi->txq.sta, struct sta_info, sta);
 	if (test_sta_flag(sta, WLAN_STA_PS_STA) ||
@@ -1677,6 +1681,7 @@ void ieee80211_txq_purge(struct ieee80211_local *local,
 	spin_lock_bh(&fq->lock);
 	fq_tin_reset(fq, tin, fq_skb_free_func);
 	ieee80211_purge_tx_queue(&local->hw, &txqi->frags);
+	clear_bit(IEEE80211_TXQ_MCAST_PS, &txqi->flags);
 	spin_unlock_bh(&fq->lock);
 
 	spin_lock_bh(&local->active_txq_lock[txqi->txq.ac]);
@@ -1684,6 +1689,19 @@ void ieee80211_txq_purge(struct ieee80211_local *local,
 	spin_unlock_bh(&local->active_txq_lock[txqi->txq.ac]);
 }
 
+void ieee80211_txq_purge_mcast_ps(struct ieee80211_local *local,
+				  const struct ieee80211_sub_if_data *sdata)
+{
+	struct txq_info *txqi;
+
+	if (!sdata->vif.txq)
+		return;
+
+	txqi = to_txq_info(sdata->vif.txq);
+	if (test_bit(IEEE80211_TXQ_MCAST_PS, &txqi->flags))
+		ieee80211_txq_purge(local, txqi);
+}
+
 void ieee80211_txq_set_params(struct ieee80211_local *local, int radio_idx)
 {
 	if (local->hw.wiphy->txq_limit)
@@ -4032,7 +4050,7 @@ static bool ieee80211_txq_ps_tx_ok(const struct txq_info *txqi)
 	struct sta_info *sta;
 
 	if (!txqi->txq.sta)
-		return true;
+		return !test_bit(IEEE80211_TXQ_MCAST_PS, &txqi->flags);
 
 	sta = container_of(txqi->txq.sta, struct sta_info, sta);
 
@@ -5415,8 +5433,13 @@ static void __ieee80211_beacon_add_tim(struct ieee80211_sub_if_data *sdata,
 	skb_put_u8(skb, ps->dtim_count);
 	skb_put_u8(skb, link_conf->dtim_period);
 
-	if (ps->dtim_count == 0 && !skb_queue_empty(&ps->bc_buf))
-		mcast_traffic = true;
+	if (ps->dtim_count == 0 && sdata->vif.txq) {
+		struct txq_info *txqi = to_txq_info(sdata->vif.txq);
+
+		mcast_traffic = test_bit(IEEE80211_TXQ_MCAST_PS,
+					 &txqi->flags) &&
+				txq_has_queue(&txqi->txq);
+	}
 
 	ps->dtim_bc_mc = mcast_traffic;
 
@@ -6505,14 +6528,17 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 			  struct ieee80211_vif *vif)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
-	struct sk_buff *skb = NULL;
-	struct ieee80211_tx_data tx;
-	struct ieee80211_sub_if_data *sdata;
-	struct ps_data *ps;
-	struct ieee80211_tx_info *info;
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
 	struct ieee80211_chanctx_conf *chanctx_conf;
+	struct ieee80211_tx_info *info;
+	struct sk_buff *skb = NULL;
+	struct txq_info *txqi;
+	struct ps_data *ps;
 
-	sdata = vif_to_sdata(vif);
+	if (!vif->txq)
+		return NULL;
+
+	txqi = to_txq_info(vif->txq);
 
 	rcu_read_lock();
 	chanctx_conf = rcu_dereference(sdata->vif.bss_conf.chanctx_conf);
@@ -6537,36 +6563,29 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 	if (ps->dtim_count != 0 || !ps->dtim_bc_mc)
 		goto out; /* send buffered bc/mc only after DTIM beacon */
 
-	while (1) {
-		skb = skb_dequeue(&ps->bc_buf);
-		if (!skb)
-			goto out;
-		local->total_ps_buffered--;
+	local_bh_disable();
+	skb = __ieee80211_tx_dequeue(hw, vif->txq, true);
 
-		if (!skb_queue_empty(&ps->bc_buf) && skb->len >= 2) {
-			struct ieee80211_hdr *hdr =
-				(struct ieee80211_hdr *) skb->data;
-			/* more buffered multicast/broadcast frames ==> set
-			 * MoreData flag in IEEE 802.11 header to inform PS
-			 * STAs */
-			hdr->frame_control |=
-				cpu_to_le16(IEEE80211_FCTL_MOREDATA);
-		}
+	spin_lock(&local->fq.lock);
+	if (!txq_has_queue(vif->txq)) {
+		clear_bit(IEEE80211_TXQ_MCAST_PS, &txqi->flags);
+	} else if (skb &&
+		   !(IEEE80211_SKB_CB(skb)->flags &
+		     IEEE80211_TX_CTL_HW_80211_ENCAP)) {
+		struct ieee80211_hdr *hdr = (void *)skb->data;
 
-		if (sdata->vif.type == NL80211_IFTYPE_AP)
-			sdata = IEEE80211_DEV_TO_SUB_IF(skb->dev);
-		if (!ieee80211_tx_prepare(sdata, &tx, NULL, skb))
-			break;
-		ieee80211_free_txskb(hw, skb);
+		/* inform PS stations about more buffered frames */
+		hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_MOREDATA);
 	}
+	spin_unlock(&local->fq.lock);
+	local_bh_enable();
+
+	if (!skb)
+		goto out;
 
 	info = IEEE80211_SKB_CB(skb);
-
-	tx.flags |= IEEE80211_TX_PS_BUFFERED;
+	info->flags |= IEEE80211_TX_CTL_SEND_AFTER_DTIM;
 	info->band = chanctx_conf->def.chan->band;
-
-	if (invoke_tx_handlers(&tx))
-		skb = NULL;
  out:
 	rcu_read_unlock();
 
-- 
2.56.0

