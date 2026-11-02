Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793651937;
	b=ZYLMKyWS5KtumCqL790r5ICOzjPa21zfl5z4jCwEkiq87NGvEpk5dYEdwqi6sKMUaZGD
	 7BbWCiCpMaKdByhG3x3tZwp2Uv2xFKmEM22lL/loVjhaGdGeQM+eZQ5N/Nx/NDp81+hRU
	 bumpikHVNMA5t9cRE0NbfClqrEmgtoNf5E3GVt5E3y4wmgXGETLaLa2vEi//M0D8bVQdL
	 8fcSLh5QB42nAyqzphAYuaub7C1ov1orTKXrDi+xHzg1j9/FnFkE8RmOK9tCGUzEM+dGM
	 B0AKZQ+u65i+poYDjots9oWKvl7Yc0T3HuZawHQJWkyDzLoXI4kj0zm7XmrnGexYBkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793651937;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=8PC97SsfO5hXeVcohwMAM9FWoZe34Gh2RjWwbpvqF+U=;
	b=wyljumpf6Ty7RuHESIKDQvAgju+JjSaMIjyqJGovvv+vSHAWWm3lFS1zpODcs+GvBDcW
	 J6ZsmG4ixu9p6SUTApxTqXMeOozj6qRPOIYZBboGy94L9Wg2mOFJyGfpu+VtajEoc/nNi
	 Le6dxkAz/tc2a02rz7wepHW645sXla81AoTWNAF6eVHJTBLBWB1EpqYmHdh6+ItNjgpsz
	 QYhStfeANIVvbFaT8kBynny4Sp9YfZ+38xw2lwCglcc3nnMYVhjU1ZBRjc+8x8+mS533K
	 PiAiNaLDBXcBcYcnN7oaxrALWiJ5Ag2XLCF+JbvDlyKmqWU3pysx3yysVeZ/AQZoEcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=eHrQ+ZFB;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18D7606D802
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 20:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=eHrQ+ZFB
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=8PC97SsfO5hXeVcohwMAM9FWoZe34Gh2RjWwbpvqF+U=;
	t=1793651936; x=1794861536; b=eHrQ+ZFBGLJYY754DO+bwgeRsnNCxs/iqafhXNeDzjtcLUv
	p+/nsU2dqViLoSBBkL0BBiH/NFnzbDFGm75YNMD3ssiuSXB0kA/E0nnnUp3tDGcbpkbiiCvNzUIcO
	O66EGYluQeethXrHF0bcirQBu3oDgO5GASuj1hD/X4rlcJ6uu3MV08Y+8BkgXPb0DumxkmH20Mr8W
	Vt6gqwt2IkbK3/vqZTNs+mcONFv4ZHDR+TUtbcwCUb3NPhKZA4TxMjGeL1PRnkhtmdVhOEqoSZTA5
	gDON865ZkVLjjyBkzeBhZhQPTvbksty7byqvywhhUJpd83Bm04jc48z/swpR2Tqw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNynu-00000001vzr-1SfC;
	Mon, 02 Nov 2026 21:38:54 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 16/30] wifi: mac80211: hold frames for sleeping STAs on TXQs
Date: Mon,  2 Nov 2026 21:23:06 +0100
Message-ID: <20261102203831.1058362-48-johannes@sipsolutions.net>
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

We currently use a separate PS buffer for (data) frames,
move to putting the PS buffered frames onto TXQs so they
are released from there by the poll/wakeup handling.
This will let us remove the extra powersave queue step
later.

For now management frames are only there if the driver
opted in to the management TXQ, that changes later.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h     |  8 ++---
 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/rx.c          |  3 ++
 net/mac80211/sta_info.c    | 67 ++++++++++++++++++++++++++++---------
 net/mac80211/sta_info.h    |  1 +
 net/mac80211/tx.c          | 68 +++++++++++++++++++++++++++++++++++++-
 6 files changed, 128 insertions(+), 21 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 1e8f799193dc..6cad76cc7d20 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3764,10 +3764,10 @@ void ieee80211_purge_tx_queue(struct ieee80211_hw *hw,
  * driver is also notified of powersave transitions by calling its
  * @sta_notify callback.
  *
- * While the station is asleep (or blocked, see below), frames that are
- * already on its TXQs remain there: the TXQs aren't scheduled, and
- * ieee80211_tx_dequeue() doesn't return frames from them, except when
- * they're released as described below.
+ * While the station is asleep (or blocked, see below), frames for it are
+ * held on its TXQs: the TXQs aren't scheduled, and ieee80211_tx_dequeue()
+ * doesn't return frames from them, except when they're released as
+ * described below.
  *
  * When the station is asleep, it has three choices: it can wake up,
  * it can PS-Poll, or it can possibly start a uAPSD service period.
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 4a9b68022250..ebfa772a6dd8 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2732,6 +2732,8 @@ struct sk_buff *ieee80211_tx_dequeue_ps_release(struct ieee80211_local *local,
 						struct txq_info *txqi);
 void ieee80211_txq_ps_backlog_start(struct ieee80211_local *local,
 				    struct txq_info *txqi);
+unsigned int ieee80211_txq_expire(struct ieee80211_local *local,
+				  struct txq_info *txqi, unsigned long timeout);
 bool ieee80211_txq_queue_filtered(struct ieee80211_local *local,
 				  struct txq_info *txqi, struct sk_buff *skb);
 void ieee80211_txq_purge(struct ieee80211_local *local,
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index d17e06394142..5f31326a84b1 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1699,6 +1699,9 @@ static void sta_ps_start(struct sta_info *sta)
 	}
 
 	sta_info_recalc_tim(sta);
+
+	/* expire held frames at a regular interval */
+	sta_info_schedule_cleanup(local);
 }
 
 static void sta_ps_end(struct sta_info *sta)
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 25cf1929fbfc..1ec59cdd4fa2 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1218,33 +1218,41 @@ void sta_info_recalc_tim(struct sta_info *sta)
 	__sta_info_recalc_tim(sta, false);
 }
 
-static bool sta_info_buffer_expired(struct sta_info *sta, struct sk_buff *skb)
+static int sta_info_buffer_timeout(struct sta_info *sta)
 {
-	struct ieee80211_tx_info *info;
 	int timeout;
 
-	if (!skb)
-		return false;
-
-	info = IEEE80211_SKB_CB(skb);
-
 	/* Timeout: (2 * listen_interval * beacon_int * 1024 / 1000000) sec */
 	timeout = (sta->listen_interval *
 		   sta->sdata->vif.bss_conf.beacon_int *
 		   32 / 15625) * HZ;
 	if (timeout < STA_TX_BUFFER_EXPIRE)
 		timeout = STA_TX_BUFFER_EXPIRE;
-	return time_after(jiffies, info->control.jiffies + timeout);
+	return timeout;
 }
 
+static bool sta_info_buffer_expired(struct sta_info *sta, struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info;
 
-static bool sta_info_cleanup_expire_filtered_txqs(struct ieee80211_local *local,
-						  struct sta_info *sta, int ac)
+	if (!skb)
+		return false;
+
+	info = IEEE80211_SKB_CB(skb);
+
+	return time_after(jiffies,
+			  info->control.jiffies + sta_info_buffer_timeout(sta));
+}
+
+/* returns whether frames are left on the TXQs that we want to expire */
+static bool sta_info_cleanup_expire_txqs(struct ieee80211_local *local,
+					 struct sta_info *sta, int ac)
 {
 	unsigned long tids = ieee80211_tids_for_ac(ac);
 	struct sk_buff_head expired;
 	struct fq *fq = &local->fq;
-	bool have_filtered = false;
+	bool have_buffered = false;
+	unsigned int n_expired = 0;
 	int tid;
 
 	__skb_queue_head_init(&expired);
@@ -1263,7 +1271,7 @@ static bool sta_info_cleanup_expire_filtered_txqs(struct ieee80211_local *local,
 				break;
 
 			if (!sta_info_buffer_expired(sta, skb)) {
-				have_filtered = true;
+				have_buffered = true;
 				break;
 			}
 
@@ -1279,7 +1287,27 @@ static bool sta_info_cleanup_expire_filtered_txqs(struct ieee80211_local *local,
 
 	ieee80211_purge_tx_queue(&local->hw, &expired);
 
-	return have_filtered;
+	if (!test_sta_flag(sta, WLAN_STA_PS_STA) &&
+	    !test_sta_flag(sta, WLAN_STA_PS_DRIVER))
+		return have_buffered;
+
+	for_each_set_bit(tid, &tids, IEEE80211_NUM_TIDS + 1) {
+		struct txq_info *txqi = sta_txqi(sta, tid);
+
+		if (!txqi)
+			continue;
+
+		n_expired += ieee80211_txq_expire(local, txqi,
+						  sta_info_buffer_timeout(sta));
+		if (txq_has_queue(&txqi->txq))
+			have_buffered = true;
+	}
+
+	if (n_expired)
+		ps_dbg(sta->sdata, "%u buffered frames expired (STA %pM)\n",
+		       n_expired, sta->sta.addr);
+
+	return have_buffered;
 }
 
 static bool sta_info_cleanup_expire_buffered_ac(struct ieee80211_local *local,
@@ -1287,9 +1315,9 @@ static bool sta_info_cleanup_expire_buffered_ac(struct ieee80211_local *local,
 {
 	unsigned long flags;
 	struct sk_buff *skb;
-	bool have_filtered;
+	bool have_buffered;
 
-	have_filtered = sta_info_cleanup_expire_filtered_txqs(local, sta, ac);
+	have_buffered = sta_info_cleanup_expire_txqs(local, sta, ac);
 
 	/*
 	 * First check for frames that should expire on the filtered
@@ -1359,7 +1387,7 @@ static bool sta_info_cleanup_expire_buffered_ac(struct ieee80211_local *local,
 	 * used to check whether the cleanup timer still needs to run,
 	 * if there are no frames we don't need to rearm the timer.
 	 */
-	return have_filtered ||
+	return have_buffered ||
 	       !(skb_queue_empty(&sta->ps_tx_buf[ac]) &&
 		 skb_queue_empty(&sta->tx_filtered[ac]));
 }
@@ -1737,6 +1765,13 @@ int sta_info_destroy_addr_bss(struct ieee80211_sub_if_data *sdata,
 	return __sta_info_destroy(sta);
 }
 
+void sta_info_schedule_cleanup(struct ieee80211_local *local)
+{
+	if (!timer_pending(&local->sta_cleanup))
+		mod_timer(&local->sta_cleanup,
+			  round_jiffies(jiffies + STA_INFO_CLEANUP_INTERVAL));
+}
+
 static void sta_info_cleanup(struct timer_list *t)
 {
 	struct ieee80211_local *local = timer_container_of(local, t,
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index ea7ead4b30b5..307c8b76b80f 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -1008,6 +1008,7 @@ void ieee80211_sta_free_link(struct sta_info *sta, unsigned int link_id);
 int ieee80211_sta_activate_link(struct sta_info *sta, unsigned int link_id);
 void ieee80211_sta_remove_link(struct sta_info *sta, unsigned int link_id);
 
+void sta_info_schedule_cleanup(struct ieee80211_local *local);
 void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta);
 unsigned long ieee80211_tids_for_ac(int ac);
 unsigned long ieee80211_sta_txq_buffered_tids(struct sta_info *sta);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 6bace6ede373..c29dec9d049d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -462,6 +462,12 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 			return TX_CONTINUE;
 		}
 
+		/* continue and put the frame on the TXQ */
+		if (sta->uploaded &&
+		    (ieee80211_is_data_present(hdr->frame_control) ||
+		     sta->sta.txq[IEEE80211_NUM_TIDS]))
+			return TX_CONTINUE;
+
 		ps_dbg(sta->sdata, "STA %pM aid %d: PS buffer for AC %d\n",
 		       sta->sta.addr, sta->sta.aid, ac);
 		if (tx->local->total_ps_buffered >= TOTAL_MAX_TX_BUFFER)
@@ -1513,8 +1519,10 @@ static void ieee80211_txq_enqueue(struct ieee80211_local *local,
 	}
 	spin_unlock_bh(&fq->lock);
 
-	if (sta)
+	if (sta) {
 		sta_info_recalc_tim(sta);
+		sta_info_schedule_cleanup(local);
+	}
 }
 
 bool ieee80211_txq_queue_filtered(struct ieee80211_local *local,
@@ -1544,6 +1552,64 @@ bool ieee80211_txq_queue_filtered(struct ieee80211_local *local,
 	return ret;
 }
 
+struct ieee80211_txq_expire_data {
+	codel_time_t now, timeout;
+};
+
+static bool ieee80211_txq_frame_expired(struct sk_buff *skb,
+					struct ieee80211_txq_expire_data *exp)
+{
+	codel_time_t enqueue_time = IEEE80211_SKB_CB(skb)->control.enqueue_time;
+
+	return codel_time_after(exp->now, enqueue_time + exp->timeout);
+}
+
+static bool fq_expire_filter_func(struct fq *fq, struct fq_tin *tin,
+				  struct fq_flow *flow, struct sk_buff *skb,
+				  void *data)
+{
+	return ieee80211_txq_frame_expired(skb, data);
+}
+
+unsigned int ieee80211_txq_expire(struct ieee80211_local *local,
+				  struct txq_info *txqi, unsigned long timeout)
+{
+	struct ieee80211_txq_expire_data exp = {
+		.now = codel_get_time(),
+		/* station controls listen interval, avoid too long timeout */
+		.timeout = min_t(u64, jiffies_to_nsecs(timeout) >> CODEL_SHIFT,
+				 S32_MAX / 2),
+	};
+	struct sk_buff_head expired;
+	struct fq *fq = &local->fq;
+	struct sk_buff *skb, *tmp;
+	unsigned int n_expired;
+
+	__skb_queue_head_init(&expired);
+
+	spin_lock_bh(&fq->lock);
+	n_expired = txqi->tin.backlog_packets;
+	fq_tin_filter(fq, &txqi->tin, fq_expire_filter_func, &exp,
+		      fq_skb_free_func);
+	n_expired -= txqi->tin.backlog_packets;
+
+	skb_queue_walk_safe(&txqi->frags, skb, tmp) {
+		if (!(IEEE80211_SKB_CB(skb)->control.flags &
+		      IEEE80211_TX_INTCFL_NEED_TXPROCESSING) ||
+		    !ieee80211_txq_frame_expired(skb, &exp))
+			continue;
+
+		__skb_unlink(skb, &txqi->frags);
+		__skb_queue_tail(&expired, skb);
+	}
+	spin_unlock_bh(&fq->lock);
+
+	n_expired += skb_queue_len(&expired);
+	ieee80211_purge_tx_queue(&local->hw, &expired);
+
+	return n_expired;
+}
+
 static bool fq_vlan_filter_func(struct fq *fq, struct fq_tin *tin,
 				struct fq_flow *flow, struct sk_buff *skb,
 				void *data)
-- 
2.56.0

