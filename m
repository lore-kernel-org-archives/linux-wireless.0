Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298D9471431
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 19:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662933; cv=none; b=GN4qGWQ8Azn0SjwqnGb0JwxMzjCC0uJct8zojOXFx2NaUQ2q2PRxr07gNHaowG8Ik/qQrKY6lEPVEXpMnZgbwRIF+hUARKalq9CsMCR5ostLxH4mFiKOwIyAWayxtUy3X8FsQwbGmMriUhscxWqeXJ38sLACA2++Vn8Z7elHkfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662933; c=relaxed/simple;
	bh=G4uWn0qYP2chT14hG5I5mWxA+c/FzwkduNi9l39+IvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mGa2HdBqnZGICxjVVZ7rQhWD2fBHugWktWzJO2L+Ls49qQdV4Y9QIsCTcsFnfXbrKJbA3bTYjvsQ+BxbgCq1Lc3xm6FOO//HvbUI8vS6wyCxshuX+GWRjg1GoYGgiF8NyJec/H3vAxqV3AjE34Hf17/P0EZffqyn3TRTMrs9168=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=MQedl7mU; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="MQedl7mU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=HkZmvFsHeEnUh2+Z6XUZTp+9sQ/JlU55KUqNW3gPw1U=; b=MQedl7mUpclRU1Q14x69MvNb+r
	tkpF8N9Fhg23TYZUT55/4KLuFvIjlz+sdyC8txz4DpY85IJAotNPLv1t4dSR1j3zmluaXoP2AHAoq
	lSTSJ0u5AdINdpB0e7PVYGHlQuQX0SVKmJTtZe+dD/kthoSPh4ZkwdAHr8nroovaYrn0=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wmGLx-004wLC-1Y;
	Tue, 21 Jul 2026 21:42:09 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH wireless-next v4 3/4] wifi: mac80211: add AQL support for multicast packets
Date: Tue, 21 Jul 2026 19:42:06 +0000
Message-ID: <20260721194207.2431113-3-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260721194207.2431113-1-nbd@nbd.name>
References: <20260721194207.2431113-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Excessive multicast traffic with little competing unicast traffic can easily
flood hardware queues, leading to throughput issues. Additionally, filling
the hardware queues with too many packets breaks FQ for multicast data.
Fix this by enabling AQL for multicast packets.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
v2: fix broadcast/multicast inconsistency

 include/net/cfg80211.h     |  1 +
 include/net/mac80211.h     |  2 +-
 net/mac80211/debugfs.c     | 13 ++++++++--
 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/main.c        |  1 +
 net/mac80211/sta_info.c    | 17 ++++++++++++-
 net/mac80211/sta_info.h    |  3 ++-
 net/mac80211/status.c      |  5 ++--
 net/mac80211/tx.c          | 52 ++++++++++++++++++++------------------
 9 files changed, 65 insertions(+), 31 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index b8e9fbb89e69..9ca027ff77fb 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3742,6 +3742,7 @@ enum wiphy_params_flags {
 /* The per TXQ device queue limit in airtime */
 #define IEEE80211_DEFAULT_AQL_TXQ_LIMIT_L	5000
 #define IEEE80211_DEFAULT_AQL_TXQ_LIMIT_H	12000
+#define IEEE80211_DEFAULT_AQL_TXQ_LIMIT_MC	50000
 
 /* The per interface airtime threshold to switch to lower queue limit */
 #define IEEE80211_AQL_THRESHOLD			24000
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 1f806fc3d9be..17cc970c02dc 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1354,8 +1354,8 @@ struct ieee80211_tx_info {
 	    status_data_idr:1,
 	    status_data:13,
 	    hw_queue:4,
+	    tx_time_mc:1,
 	    tx_time_est:10;
-	/* 1 free bit */
 
 	union {
 		struct {
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index a4d5461f6480..8ebf5bcf3c0e 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -210,11 +210,13 @@ static ssize_t aql_pending_read(struct file *file,
 			"VI     %u us\n"
 			"BE     %u us\n"
 			"BK     %u us\n"
+			"MC     %u us\n"
 			"total  %u us\n",
 			atomic_read(&local->aql_ac_pending_airtime[IEEE80211_AC_VO]),
 			atomic_read(&local->aql_ac_pending_airtime[IEEE80211_AC_VI]),
 			atomic_read(&local->aql_ac_pending_airtime[IEEE80211_AC_BE]),
 			atomic_read(&local->aql_ac_pending_airtime[IEEE80211_AC_BK]),
+			atomic_read(&local->aql_mc_pending_airtime),
 			atomic_read(&local->aql_total_pending_airtime));
 	return simple_read_from_buffer(user_buf, count, ppos,
 				       buf, len);
@@ -239,7 +241,8 @@ static ssize_t aql_txq_limit_read(struct file *file,
 			"VO	%u		%u\n"
 			"VI	%u		%u\n"
 			"BE	%u		%u\n"
-			"BK	%u		%u\n",
+			"BK	%u		%u\n"
+			"MC	%u\n",
 			local->aql_txq_limit_low[IEEE80211_AC_VO],
 			local->aql_txq_limit_high[IEEE80211_AC_VO],
 			local->aql_txq_limit_low[IEEE80211_AC_VI],
@@ -247,7 +250,8 @@ static ssize_t aql_txq_limit_read(struct file *file,
 			local->aql_txq_limit_low[IEEE80211_AC_BE],
 			local->aql_txq_limit_high[IEEE80211_AC_BE],
 			local->aql_txq_limit_low[IEEE80211_AC_BK],
-			local->aql_txq_limit_high[IEEE80211_AC_BK]);
+			local->aql_txq_limit_high[IEEE80211_AC_BK],
+			local->aql_txq_limit_mc);
 	return simple_read_from_buffer(user_buf, count, ppos,
 				       buf, len);
 }
@@ -273,6 +277,11 @@ static ssize_t aql_txq_limit_write(struct file *file,
 	else
 		buf[count] = '\0';
 
+	if (sscanf(buf, "mcast %u", &q_limit_low) == 1) {
+		local->aql_txq_limit_mc = q_limit_low;
+		return count;
+	}
+
 	if (sscanf(buf, "%u %u %u", &ac, &q_limit_low, &q_limit_high) != 3)
 		return -EINVAL;
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 2e9de2edd314..457255daa315 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1464,10 +1464,12 @@ struct ieee80211_local {
 	spinlock_t handle_wake_tx_queue_lock;
 
 	u16 airtime_flags;
+	u32 aql_txq_limit_mc;
 	u32 aql_txq_limit_low[IEEE80211_NUM_ACS];
 	u32 aql_txq_limit_high[IEEE80211_NUM_ACS];
 	u32 aql_threshold;
 	atomic_t aql_total_pending_airtime;
+	atomic_t aql_mc_pending_airtime;
 	atomic_t aql_ac_pending_airtime[IEEE80211_NUM_ACS];
 
 	const struct ieee80211_ops *ops;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 90d295cc364f..3adb941f407f 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -988,6 +988,7 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 	spin_lock_init(&local->rx_path_lock);
 	spin_lock_init(&local->queue_stop_reason_lock);
 
+	local->aql_txq_limit_mc = IEEE80211_DEFAULT_AQL_TXQ_LIMIT_MC;
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
 		INIT_LIST_HEAD(&local->active_txqs[i]);
 		spin_lock_init(&local->active_txq_lock[i]);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 877117929f5b..0a8ca32fe38c 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2489,13 +2489,28 @@ EXPORT_SYMBOL(ieee80211_sta_recalc_aggregates);
 
 void ieee80211_sta_update_pending_airtime(struct ieee80211_local *local,
 					  struct sta_info *sta, u8 ac,
-					  u16 tx_airtime, bool tx_completed)
+					  u16 tx_airtime, bool tx_completed,
+					  bool mcast)
 {
 	int tx_pending;
 
 	if (!wiphy_ext_feature_isset(local->hw.wiphy, NL80211_EXT_FEATURE_AQL))
 		return;
 
+	if (mcast) {
+		if (!tx_completed) {
+			atomic_add(tx_airtime, &local->aql_mc_pending_airtime);
+			return;
+		}
+
+		tx_pending = atomic_sub_return(tx_airtime,
+					       &local->aql_mc_pending_airtime);
+		if (tx_pending < 0)
+			atomic_cmpxchg(&local->aql_mc_pending_airtime,
+				       tx_pending, 0);
+		return;
+	}
+
 	if (!tx_completed) {
 		if (sta)
 			atomic_add(tx_airtime,
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 5da3142d8516..ee0d32877c5b 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -147,7 +147,8 @@ struct airtime_info {
 
 void ieee80211_sta_update_pending_airtime(struct ieee80211_local *local,
 					  struct sta_info *sta, u8 ac,
-					  u16 tx_airtime, bool tx_completed);
+					  u16 tx_airtime, bool tx_completed,
+					  bool mcast);
 
 struct sta_info;
 
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index c3d29aed93fe..8270d15ac60c 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -774,7 +774,7 @@ static void ieee80211_report_used_skb(struct ieee80211_local *local,
 		ieee80211_sta_update_pending_airtime(local, sta,
 						     skb_get_queue_mapping(skb),
 						     tx_time_est,
-						     true);
+						     true, info->tx_time_mc);
 		rcu_read_unlock();
 	}
 
@@ -1186,10 +1186,11 @@ void ieee80211_tx_status_ext(struct ieee80211_hw *hw,
 		/* Do this here to avoid the expensive lookup of the sta
 		 * in ieee80211_report_used_skb().
 		 */
+		bool mcast = IEEE80211_SKB_CB(skb)->tx_time_mc;
 		ieee80211_sta_update_pending_airtime(local, sta,
 						     skb_get_queue_mapping(skb),
 						     tx_time_est,
-						     true);
+						     true, mcast);
 		ieee80211_info_set_tx_time_est(IEEE80211_SKB_CB(skb), 0);
 	}
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 42cfd76850b8..1bba49d0b6bf 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4046,20 +4046,20 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 encap_out:
 	info->control.vif = vif;
 
-	if (tx.sta &&
-	    wiphy_ext_feature_isset(local->hw.wiphy, NL80211_EXT_FEATURE_AQL)) {
-		bool ampdu = txq->ac != IEEE80211_AC_VO;
+	if (wiphy_ext_feature_isset(local->hw.wiphy, NL80211_EXT_FEATURE_AQL)) {
+		bool ampdu = txq->sta && txq->ac != IEEE80211_AC_VO;
 		u32 airtime;
 
 		airtime = ieee80211_calc_expected_tx_airtime(hw, vif, txq->sta,
 							     skb->len, ampdu);
-		if (airtime) {
-			airtime = ieee80211_info_set_tx_time_est(info, airtime);
-			ieee80211_sta_update_pending_airtime(local, tx.sta,
-							     txq->ac,
-							     airtime,
-							     false);
-		}
+		if (!airtime)
+			return skb;
+
+		airtime = ieee80211_info_set_tx_time_est(info, airtime);
+		info->tx_time_mc = !tx.sta;
+		ieee80211_sta_update_pending_airtime(local, tx.sta, txq->ac,
+						     airtime, false,
+						     info->tx_time_mc);
 	}
 
 	return skb;
@@ -4111,6 +4111,7 @@ struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, u8 ac)
 	struct ieee80211_txq *ret = NULL;
 	struct txq_info *txqi = NULL, *head = NULL;
 	bool found_eligible_txq = false;
+	bool aql_check;
 
 	spin_lock_bh(&local->active_txq_lock[ac]);
 
@@ -4134,26 +4135,28 @@ struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, u8 ac)
 	if (!head)
 		head = txqi;
 
+	aql_check = ieee80211_txq_airtime_check(hw, &txqi->txq);
+	if (aql_check)
+		found_eligible_txq = true;
+
 	if (txqi->txq.sta) {
 		struct sta_info *sta = container_of(txqi->txq.sta,
 						    struct sta_info, sta);
-		bool aql_check = ieee80211_txq_airtime_check(hw, &txqi->txq);
-		s32 deficit = ieee80211_sta_deficit(sta, txqi->txq.ac);
 
-		if (aql_check)
-			found_eligible_txq = true;
-
-		if (deficit < 0)
+		if (ieee80211_sta_deficit(sta, txqi->txq.ac) < 0) {
 			sta->airtime[txqi->txq.ac].deficit +=
 				sta->airtime_weight;
 
-		if (deficit < 0 || !aql_check) {
-			list_move_tail(&txqi->schedule_order,
-				       &local->active_txqs[txqi->txq.ac]);
-			goto begin;
+			aql_check = false;
 		}
 	}
 
+	if (!aql_check) {
+		list_move_tail(&txqi->schedule_order,
+				   &local->active_txqs[txqi->txq.ac]);
+		goto begin;
+	}
+
 	if (txqi->schedule_round == local->schedule_round[ac])
 		goto out;
 
@@ -4220,7 +4223,8 @@ bool ieee80211_txq_airtime_check(struct ieee80211_hw *hw,
 		return true;
 
 	if (!txq->sta)
-		return true;
+		return atomic_read(&local->aql_mc_pending_airtime) <
+		       local->aql_txq_limit_mc;
 
 	if (unlikely(txq->tid == IEEE80211_NUM_TIDS))
 		return true;
@@ -4269,15 +4273,15 @@ bool ieee80211_txq_may_transmit(struct ieee80211_hw *hw,
 
 	spin_lock_bh(&local->active_txq_lock[ac]);
 
-	if (!txqi->txq.sta)
-		goto out;
-
 	if (list_empty(&txqi->schedule_order))
 		goto out;
 
 	if (!ieee80211_txq_schedule_airtime_check(local, ac))
 		goto out;
 
+	if (!txqi->txq.sta)
+		goto out;
+
 	list_for_each_entry_safe(iter, tmp, &local->active_txqs[ac],
 				 schedule_order) {
 		if (iter == txqi)
-- 
2.53.0

