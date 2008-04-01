Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35271 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbYDBJFc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 05:05:32 -0400
Subject: [PATCH/RFC v3] mac80211: proper STA info locking
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Luis Carlos Cobo <luisca@cozybit.com>
In-Reply-To: <1207056452.5143.95.camel@johannes.berg> (sfid-20080401_142746_785699_29242688)
References: <1206569781.22530.18.camel@johannes.berg>
	 (sfid-20080327_125027_868420_4C276109)  <1207056452.5143.95.camel@johannes.berg>
	 (sfid-20080401_142746_785699_29242688)
Content-Type: text/plain; charset=UTF-8
Date: Tue, 01 Apr 2008 18:23:46 +0200
Message-Id: <1207067026.5143.120.camel@johannes.berg> (sfid-20080402_100543_479722_BE0B648C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As discussed earlier, we can unify locking in struct sta_info
and use just a single spinlock protecting all members of the
structure that need protection. Many don't, but one of the
especially bad ones is the 'flags' member that can currently
be clobbered when RX and TX is being processed on different
CPUs at the same time.

Because having four spinlocks for different, mostly exclusive
parts of a single structure is overkill, this patch also kills
the ampdu and mesh plink spinlocks and uses just a single one
for everything. Because none of the spinlocks are nested, this
is safe.

It remains to be seen whether or not we should make the sta
flags use atomic bit operations instead, for now though this
is a safe thing and using atomic operations instead will be
very simple using the new static inline functions this patch
introduces for accessing sta->flags.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Tomas Winkler <tomasw@gmail.com>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: Luis Carlos Cobo <luisca@cozybit.com>
---
=EF=BB=BFv3: with updates to iwlwifi

 drivers/net/wireless/iwlwifi/iwl-4965-rs.c |    4 -
 net/mac80211/cfg.c                         |    2=20
 net/mac80211/debugfs_sta.c                 |   15 ++--
 net/mac80211/ieee80211.c                   |   31 +++++-----
 net/mac80211/ieee80211_sta.c               |   38 ++++++------
 net/mac80211/key.c                         |    4 -
 net/mac80211/mesh_plink.c                  |   88 ++++++++++++++------=
---------
 net/mac80211/rx.c                          |   17 ++---
 net/mac80211/sta_info.c                    |   14 +---
 net/mac80211/sta_info.h                    |   72 ++++++++++++++++++++=
---
 net/mac80211/tx.c                          |   21 +++---
 11 files changed, 181 insertions(+), 125 deletions(-)

--- everything.orig/net/mac80211/sta_info.h	2008-04-01 15:21:03.0000000=
00 +0200
+++ everything/net/mac80211/sta_info.h	2008-04-01 15:23:57.000000000 +0=
200
@@ -129,23 +129,19 @@ enum plink_state {
  *
  * @tid_state_rx: TID's state in Rx session state machine.
  * @tid_rx: aggregation info for Rx per TID
- * @ampdu_rx: for locking sections in aggregation Rx flow
  * @tid_state_tx: TID's state in Tx session state machine.
  * @tid_tx: aggregation info for Tx per TID
  * @addba_req_num: number of times addBA request has been sent.
- * @ampdu_tx: for locking sectionsi in aggregation Tx flow
  * @dialog_token_allocator: dialog token enumerator for each new sessi=
on;
  */
 struct sta_ampdu_mlme {
 	/* rx */
 	u8 tid_state_rx[STA_TID_NUM];
 	struct tid_ampdu_rx *tid_rx[STA_TID_NUM];
-	spinlock_t ampdu_rx;
 	/* tx */
 	u8 tid_state_tx[STA_TID_NUM];
 	struct tid_ampdu_tx *tid_tx[STA_TID_NUM];
 	u8 addba_req_num[STA_TID_NUM];
-	spinlock_t ampdu_tx;
 	u8 dialog_token_allocator;
 };
=20
@@ -177,6 +173,8 @@ struct sta_ampdu_mlme {
  * @rx_bytes: Number of bytes received from this STA
  * @supp_rates: Bitmap of supported rates (per band)
  * @ht_info: HT capabilities of this STA
+ * @lock: used for locking all fields that require locking, see commen=
ts
+ *	in the header file.
  */
 struct sta_info {
 	/* General information, mostly static */
@@ -187,6 +185,7 @@ struct sta_info {
 	struct ieee80211_key *key;
 	struct rate_control_ref *rate_ctrl;
 	void *rate_ctrl_priv;
+	spinlock_t lock;
 	struct ieee80211_ht_info ht_info;
 	u64 supp_rates[IEEE80211_NUM_BANDS];
 	u8 addr[ETH_ALEN];
@@ -199,7 +198,7 @@ struct sta_info {
 	 */
 	u8 pin_status;
=20
-	/* frequently updated information, needs locking? */
+	/* frequently updated information, locked with lock spinlock */
 	u32 flags;
=20
 	/*
@@ -251,7 +250,7 @@ struct sta_info {
 	int channel_use_raw;
=20
 	/*
-	 * Aggregation information, comes with own locking.
+	 * Aggregation information, locked with lock.
 	 */
 	struct sta_ampdu_mlme ampdu_mlme;
 	u8 timer_to_tid[STA_TID_NUM];	/* identity mapping to ID timers */
@@ -270,9 +269,6 @@ struct sta_info {
 	enum plink_state plink_state;
 	u32 plink_timeout;
 	struct timer_list plink_timer;
-	spinlock_t plink_lock;	/* For peer_state reads / updates and other
-				   updates in the structure. Ensures robust
-				   transitions for the peerlink FSM */
 #endif
=20
 #ifdef CONFIG_MAC80211_DEBUGFS
@@ -299,6 +295,64 @@ static inline enum plink_state sta_plink
 	return PLINK_LISTEN;
 }
=20
+static inline void set_sta_flags(struct sta_info *sta, const u32 flags=
)
+{
+	spin_lock_bh(&sta->lock);
+	sta->flags |=3D flags;
+	spin_unlock_bh(&sta->lock);
+}
+
+static inline void clear_sta_flags(struct sta_info *sta, const u32 fla=
gs)
+{
+	spin_lock_bh(&sta->lock);
+	sta->flags &=3D ~flags;
+	spin_unlock_bh(&sta->lock);
+}
+
+static inline void set_and_clear_sta_flags(struct sta_info *sta,
+					   const u32 set, const u32 clear)
+{
+	spin_lock_bh(&sta->lock);
+	sta->flags |=3D set;
+	sta->flags &=3D ~clear;
+	spin_unlock_bh(&sta->lock);
+}
+
+static inline u32 test_sta_flags(struct sta_info *sta, const u32 flags=
)
+{
+	u32 ret;
+
+	spin_lock_bh(&sta->lock);
+	ret =3D sta->flags & flags;
+	spin_unlock_bh(&sta->lock);
+
+	return ret;
+}
+
+static inline u32 test_and_clear_sta_flags(struct sta_info *sta,
+					   const u32 flags)
+{
+	u32 ret;
+
+	spin_lock_bh(&sta->lock);
+	ret =3D sta->flags & flags;
+	sta->flags &=3D ~flags;
+	spin_unlock_bh(&sta->lock);
+
+	return ret;
+}
+
+static inline u32 get_sta_flags(struct sta_info *sta)
+{
+	u32 ret;
+
+	spin_lock_bh(&sta->lock);
+	ret =3D sta->flags;
+	spin_unlock_bh(&sta->lock);
+
+	return ret;
+}
+
=20
 /* Maximum number of concurrently registered stations */
 #define MAX_STA_COUNT 2007
--- everything.orig/net/mac80211/ieee80211.c	2008-04-01 15:19:23.000000=
000 +0200
+++ everything/net/mac80211/ieee80211.c	2008-04-01 15:24:41.000000000 +=
0200
@@ -264,6 +264,7 @@ static int ieee80211_open(struct net_dev
 		if (!sta)
 			return -ENOMEM;
=20
+		/* no locking requires since STA is not live yet */
 		sta->flags |=3D WLAN_STA_AUTHORIZED;
=20
 		res =3D sta_info_insert(sta);
@@ -566,7 +567,7 @@ int ieee80211_start_tx_ba_session(struct
 		return -ENOENT;
 	}
=20
-	spin_lock_bh(&sta->ampdu_mlme.ampdu_tx);
+	spin_lock_bh(&sta->lock);
=20
 	/* we have tried too many times, receiver does not want A-MPDU */
 	if (sta->ampdu_mlme.addba_req_num[tid] > HT_AGG_MAX_RETRIES) {
@@ -669,7 +670,7 @@ start_ba_err:
 	spin_unlock_bh(&local->mdev->queue_lock);
 	ret =3D -EBUSY;
 start_ba_exit:
-	spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
+	spin_unlock_bh(&sta->lock);
 	rcu_read_unlock();
 	return ret;
 }
@@ -702,7 +703,7 @@ int ieee80211_stop_tx_ba_session(struct=20
=20
 	/* check if the TID is in aggregation */
 	state =3D &sta->ampdu_mlme.tid_state_tx[tid];
-	spin_lock_bh(&sta->ampdu_mlme.ampdu_tx);
+	spin_lock_bh(&sta->lock);
=20
 	if (*state !=3D HT_AGG_STATE_OPERATIONAL) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
@@ -731,7 +732,7 @@ int ieee80211_stop_tx_ba_session(struct=20
 	}
=20
 stop_BA_exit:
-	spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
+	spin_unlock_bh(&sta->lock);
 	rcu_read_unlock();
 	return ret;
 }
@@ -760,12 +761,12 @@ void ieee80211_start_tx_ba_cb(struct iee
 	}
=20
 	state =3D &sta->ampdu_mlme.tid_state_tx[tid];
-	spin_lock_bh(&sta->ampdu_mlme.ampdu_tx);
+	spin_lock_bh(&sta->lock);
=20
 	if (!(*state & HT_ADDBA_REQUESTED_MSK)) {
 		printk(KERN_DEBUG "addBA was not requested yet, state is %d\n",
 				*state);
-		spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
+		spin_unlock_bh(&sta->lock);
 		rcu_read_unlock();
 		return;
 	}
@@ -778,7 +779,7 @@ void ieee80211_start_tx_ba_cb(struct iee
 		printk(KERN_DEBUG "Aggregation is on for tid %d \n", tid);
 		ieee80211_wake_queue(hw, sta->tid_to_tx_q[tid]);
 	}
-	spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
+	spin_unlock_bh(&sta->lock);
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL(ieee80211_start_tx_ba_cb);
@@ -810,10 +811,10 @@ void ieee80211_stop_tx_ba_cb(struct ieee
 	}
 	state =3D &sta->ampdu_mlme.tid_state_tx[tid];
=20
-	spin_lock_bh(&sta->ampdu_mlme.ampdu_tx);
+	spin_lock_bh(&sta->lock);
 	if ((*state & HT_AGG_STATE_REQ_STOP_BA_MSK) =3D=3D 0) {
 		printk(KERN_DEBUG "unexpected callback to A-MPDU stop\n");
-		spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
+		spin_unlock_bh(&sta->lock);
 		rcu_read_unlock();
 		return;
 	}
@@ -840,7 +841,7 @@ void ieee80211_stop_tx_ba_cb(struct ieee
 	sta->ampdu_mlme.addba_req_num[tid] =3D 0;
 	kfree(sta->ampdu_mlme.tid_tx[tid]);
 	sta->ampdu_mlme.tid_tx[tid] =3D NULL;
-	spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
+	spin_unlock_bh(&sta->lock);
=20
 	rcu_read_unlock();
 }
@@ -1279,7 +1280,7 @@ static void ieee80211_handle_filtered_fr
 	 * packet. If the STA went to power save mode, this will happen
 	 * happen when it wakes up for the next time.
 	 */
-	sta->flags |=3D WLAN_STA_CLEAR_PS_FILT;
+	set_sta_flags(sta, WLAN_STA_CLEAR_PS_FILT);
=20
 	/*
 	 * This code races in the following way:
@@ -1311,7 +1312,7 @@ static void ieee80211_handle_filtered_fr
 	 *      can be unknown, for example with different interrupt status
 	 *	bits.
 	 */
-	if (sta->flags & WLAN_STA_PS &&
+	if (test_sta_flags(sta, WLAN_STA_PS) &&
 	    skb_queue_len(&sta->tx_filtered) < STA_MAX_TX_BUFFER) {
 		ieee80211_remove_tx_extra(local, sta->key, skb,
 					  &status->control);
@@ -1319,7 +1320,7 @@ static void ieee80211_handle_filtered_fr
 		return;
 	}
=20
-	if (!(sta->flags & WLAN_STA_PS) &&
+	if (!test_sta_flags(sta, WLAN_STA_PS) &&
 	    !(status->control.flags & IEEE80211_TXCTL_REQUEUE)) {
 		/* Software retry the packet once */
 		status->control.flags |=3D IEEE80211_TXCTL_REQUEUE;
@@ -1334,7 +1335,7 @@ static void ieee80211_handle_filtered_fr
 		       "queue_len=3D%d PS=3D%d @%lu\n",
 		       wiphy_name(local->hw.wiphy),
 		       skb_queue_len(&sta->tx_filtered),
-		       !!(sta->flags & WLAN_STA_PS), jiffies);
+		       !!test_sta_flags(sta, WLAN_STA_PS), jiffies);
 	dev_kfree_skb(skb);
 }
=20
@@ -1363,7 +1364,7 @@ void ieee80211_tx_status(struct ieee8021
 		struct sta_info *sta;
 		sta =3D sta_info_get(local, hdr->addr1);
 		if (sta) {
-			if (sta->flags & WLAN_STA_PS) {
+			if (test_sta_flags(sta, WLAN_STA_PS)) {
 				/*
 				 * The STA is in power save mode, so assume
 				 * that this TX packet failed because of that.
--- everything.orig/net/mac80211/ieee80211_sta.c	2008-04-01 15:21:07.00=
0000000 +0200
+++ everything/net/mac80211/ieee80211_sta.c	2008-04-01 18:02:06.0000000=
00 +0200
@@ -1216,7 +1216,7 @@ static void ieee80211_sta_process_addba_
=20
=20
 	/* examine state machine */
-	spin_lock_bh(&sta->ampdu_mlme.ampdu_rx);
+	spin_lock_bh(&sta->lock);
=20
 	if (sta->ampdu_mlme.tid_state_rx[tid] !=3D HT_AGG_STATE_IDLE) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
@@ -1283,7 +1283,7 @@ static void ieee80211_sta_process_addba_
 	tid_agg_rx->stored_mpdu_num =3D 0;
 	status =3D WLAN_STATUS_SUCCESS;
 end:
-	spin_unlock_bh(&sta->ampdu_mlme.ampdu_rx);
+	spin_unlock_bh(&sta->lock);
=20
 end_no_lock:
 	ieee80211_send_addba_resp(sta->sdata->dev, sta->addr, tid,
@@ -1315,10 +1315,10 @@ static void ieee80211_sta_process_addba_
=20
 	state =3D &sta->ampdu_mlme.tid_state_tx[tid];
=20
-	spin_lock_bh(&sta->ampdu_mlme.ampdu_tx);
+	spin_lock_bh(&sta->lock);
=20
 	if (!(*state & HT_ADDBA_REQUESTED_MSK)) {
-		spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
+		spin_unlock_bh(&sta->lock);
 		printk(KERN_DEBUG "state not HT_ADDBA_REQUESTED_MSK:"
 			"%d\n", *state);
 		goto addba_resp_exit;
@@ -1326,7 +1326,7 @@ static void ieee80211_sta_process_addba_
=20
 	if (mgmt->u.action.u.addba_resp.dialog_token !=3D
 		sta->ampdu_mlme.tid_tx[tid]->dialog_token) {
-		spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
+		spin_unlock_bh(&sta->lock);
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "wrong addBA response token, tid %d\n", tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
@@ -1350,7 +1350,7 @@ static void ieee80211_sta_process_addba_
 			ieee80211_wake_queue(hw, sta->tid_to_tx_q[tid]);
 		}
=20
-		spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
+		spin_unlock_bh(&sta->lock);
 		printk(KERN_DEBUG "recipient accepted agg: tid %d \n", tid);
 	} else {
 		printk(KERN_DEBUG "recipient rejected agg: tid %d \n", tid);
@@ -1358,7 +1358,7 @@ static void ieee80211_sta_process_addba_
 		sta->ampdu_mlme.addba_req_num[tid]++;
 		/* this will allow the state check in stop_BA_session */
 		*state =3D HT_AGG_STATE_OPERATIONAL;
-		spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
+		spin_unlock_bh(&sta->lock);
 		ieee80211_stop_tx_ba_session(hw, sta->addr, tid,
 					     WLAN_BACK_INITIATOR);
 	}
@@ -1428,17 +1428,17 @@ void ieee80211_sta_stop_rx_ba_session(st
 	}
=20
 	/* check if TID is in operational state */
-	spin_lock_bh(&sta->ampdu_mlme.ampdu_rx);
+	spin_lock_bh(&sta->lock);
 	if (sta->ampdu_mlme.tid_state_rx[tid]
 				!=3D HT_AGG_STATE_OPERATIONAL) {
-		spin_unlock_bh(&sta->ampdu_mlme.ampdu_rx);
+		spin_unlock_bh(&sta->lock);
 		rcu_read_unlock();
 		return;
 	}
 	sta->ampdu_mlme.tid_state_rx[tid] =3D
 		HT_AGG_STATE_REQ_STOP_BA_MSK |
 		(initiator << HT_AGG_STATE_INITIATOR_SHIFT);
-		spin_unlock_bh(&sta->ampdu_mlme.ampdu_rx);
+		spin_unlock_bh(&sta->lock);
=20
 	/* stop HW Rx aggregation. ampdu_action existence
 	 * already verified in session init so we add the BUG_ON */
@@ -1510,10 +1510,10 @@ static void ieee80211_sta_process_delba(
 		ieee80211_sta_stop_rx_ba_session(dev, sta->addr, tid,
 						 WLAN_BACK_INITIATOR, 0);
 	else { /* WLAN_BACK_RECIPIENT */
-		spin_lock_bh(&sta->ampdu_mlme.ampdu_tx);
+		spin_lock_bh(&sta->lock);
 		sta->ampdu_mlme.tid_state_tx[tid] =3D
 				HT_AGG_STATE_OPERATIONAL;
-		spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
+		spin_unlock_bh(&sta->lock);
 		ieee80211_stop_tx_ba_session(&local->hw, sta->addr, tid,
 					     WLAN_BACK_RECIPIENT);
 	}
@@ -1550,9 +1550,9 @@ void sta_addba_resp_timer_expired(unsign
=20
 	state =3D &sta->ampdu_mlme.tid_state_tx[tid];
 	/* check if the TID waits for addBA response */
-	spin_lock_bh(&sta->ampdu_mlme.ampdu_tx);
+	spin_lock_bh(&sta->lock);
 	if (!(*state & HT_ADDBA_REQUESTED_MSK)) {
-		spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
+		spin_unlock_bh(&sta->lock);
 		*state =3D HT_AGG_STATE_IDLE;
 		printk(KERN_DEBUG "timer expired on tid %d but we are not "
 				"expecting addBA response there", tid);
@@ -1563,7 +1563,7 @@ void sta_addba_resp_timer_expired(unsign
=20
 	/* go through the state check in stop_BA_session */
 	*state =3D HT_AGG_STATE_OPERATIONAL;
-	spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
+	spin_unlock_bh(&sta->lock);
 	ieee80211_stop_tx_ba_session(hw, temp_sta->addr, tid,
 				     WLAN_BACK_INITIATOR);
=20
@@ -1955,8 +1955,8 @@ static void ieee80211_rx_mgmt_assoc_resp
 	 *	  to between the sta_info_alloc() and sta_info_insert() above.
 	 */
=20
-	sta->flags |=3D WLAN_STA_AUTH | WLAN_STA_ASSOC | WLAN_STA_ASSOC_AP |
-		      WLAN_STA_AUTHORIZED;
+	set_sta_flags(sta, WLAN_STA_AUTH | WLAN_STA_ASSOC | WLAN_STA_ASSOC_AP=
 |
+			   WLAN_STA_AUTHORIZED);
=20
 	rates =3D 0;
 	basic_rates =3D 0;
@@ -2016,7 +2016,7 @@ static void ieee80211_rx_mgmt_assoc_resp
 	rate_control_rate_init(sta, local);
=20
 	if (elems.wmm_param && (ifsta->flags & IEEE80211_STA_WMM_ENABLED)) {
-		sta->flags |=3D WLAN_STA_WME;
+		set_sta_flags(sta, WLAN_STA_WME);
 		rcu_read_unlock();
 		ieee80211_sta_wmm_params(dev, ifsta, elems.wmm_param,
 					 elems.wmm_param_len);
@@ -4162,7 +4162,7 @@ struct sta_info * ieee80211_ibss_add_sta
 	if (!sta)
 		return NULL;
=20
-	sta->flags |=3D WLAN_STA_AUTHORIZED;
+	set_sta_flags(sta, WLAN_STA_AUTHORIZED);
=20
 	sta->supp_rates[local->hw.conf.channel->band] =3D
 		sdata->u.sta.supp_rates_bits[local->hw.conf.channel->band];
--- everything.orig/net/mac80211/sta_info.c	2008-04-01 15:21:03.0000000=
00 +0200
+++ everything/net/mac80211/sta_info.c	2008-04-01 18:02:06.000000000 +0=
200
@@ -211,14 +211,12 @@ void sta_info_destroy(struct sta_info *s
 		dev_kfree_skb_any(skb);
=20
 	for (i =3D 0; i <  STA_TID_NUM; i++) {
-		spin_lock_bh(&sta->ampdu_mlme.ampdu_rx);
+		spin_lock_bh(&sta->lock);
 		if (sta->ampdu_mlme.tid_rx[i])
 		  del_timer_sync(&sta->ampdu_mlme.tid_rx[i]->session_timer);
-		spin_unlock_bh(&sta->ampdu_mlme.ampdu_rx);
-		spin_lock_bh(&sta->ampdu_mlme.ampdu_tx);
 		if (sta->ampdu_mlme.tid_tx[i])
 		  del_timer_sync(&sta->ampdu_mlme.tid_tx[i]->addba_resp_timer);
-		spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
+		spin_unlock_bh(&sta->lock);
 	}
=20
 	__sta_info_free(local, sta);
@@ -245,6 +243,8 @@ struct sta_info *sta_info_alloc(struct i
 	if (!sta)
 		return NULL;
=20
+	spin_lock_init(&sta->lock);
+
 	memcpy(sta->addr, addr, ETH_ALEN);
 	sta->local =3D local;
 	sta->sdata =3D sdata;
@@ -258,8 +258,6 @@ struct sta_info *sta_info_alloc(struct i
 		return NULL;
 	}
=20
-	spin_lock_init(&sta->ampdu_mlme.ampdu_rx);
-	spin_lock_init(&sta->ampdu_mlme.ampdu_tx);
 	for (i =3D 0; i < STA_TID_NUM; i++) {
 		/* timer_to_tid must be initialized with identity mapping to
 		 * enable session_timer's data differentiation. refer to
@@ -285,7 +283,6 @@ struct sta_info *sta_info_alloc(struct i
=20
 #ifdef CONFIG_MAC80211_MESH
 	sta->plink_state =3D PLINK_LISTEN;
-	spin_lock_init(&sta->plink_lock);
 	init_timer(&sta->plink_timer);
 #endif
=20
@@ -498,8 +495,7 @@ static void __sta_info_unlink(struct sta
=20
 	list_del(&(*sta)->list);
=20
-	if ((*sta)->flags & WLAN_STA_PS) {
-		(*sta)->flags &=3D ~WLAN_STA_PS;
+	if (test_and_clear_sta_flags(*sta, WLAN_STA_PS)) {
 		if (sdata->bss)
 			atomic_dec(&sdata->bss->num_sta_ps);
 		__sta_info_clear_tim_bit(sdata->bss, *sta);
--- everything.orig/net/mac80211/cfg.c	2008-04-01 15:21:07.000000000 +0=
200
+++ everything/net/mac80211/cfg.c	2008-04-01 18:02:06.000000000 +0200
@@ -582,6 +582,7 @@ static void sta_apply_parameters(struct=20
 	 */
=20
 	if (params->station_flags & STATION_FLAG_CHANGED) {
+		spin_lock_bh(&sta->lock);
 		sta->flags &=3D ~WLAN_STA_AUTHORIZED;
 		if (params->station_flags & STATION_FLAG_AUTHORIZED)
 			sta->flags |=3D WLAN_STA_AUTHORIZED;
@@ -593,6 +594,7 @@ static void sta_apply_parameters(struct=20
 		sta->flags &=3D ~WLAN_STA_WME;
 		if (params->station_flags & STATION_FLAG_WME)
 			sta->flags |=3D WLAN_STA_WME;
+		spin_unlock_bh(&sta->lock);
 	}
=20
 	/*
--- everything.orig/net/mac80211/rx.c	2008-04-01 15:17:34.000000000 +02=
00
+++ everything/net/mac80211/rx.c	2008-04-01 15:23:57.000000000 +0200
@@ -484,7 +484,7 @@ ieee80211_rx_h_check(struct ieee80211_rx
 		      ((rx->fc & IEEE80211_FCTL_FTYPE) =3D=3D IEEE80211_FTYPE_CTL &&
 		       (rx->fc & IEEE80211_FCTL_STYPE) =3D=3D IEEE80211_STYPE_PSPOLL=
)) &&
 		     rx->sdata->vif.type !=3D IEEE80211_IF_TYPE_IBSS &&
-		     (!rx->sta || !(rx->sta->flags & WLAN_STA_ASSOC)))) {
+		     (!rx->sta || !test_sta_flags(rx->sta, WLAN_STA_ASSOC)))) {
 		if ((!(rx->fc & IEEE80211_FCTL_FROMDS) &&
 		     !(rx->fc & IEEE80211_FCTL_TODS) &&
 		     (rx->fc & IEEE80211_FCTL_FTYPE) =3D=3D IEEE80211_FTYPE_DATA)
@@ -635,8 +635,7 @@ static void ap_sta_ps_start(struct net_d
=20
 	if (sdata->bss)
 		atomic_inc(&sdata->bss->num_sta_ps);
-	sta->flags |=3D WLAN_STA_PS;
-	sta->flags &=3D ~WLAN_STA_PSPOLL;
+	set_and_clear_sta_flags(sta, WLAN_STA_PS, WLAN_STA_PSPOLL);
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 	printk(KERN_DEBUG "%s: STA %s aid %d enters power save mode\n",
 	       dev->name, print_mac(mac, sta->addr), sta->aid);
@@ -657,7 +656,7 @@ static int ap_sta_ps_end(struct net_devi
 	if (sdata->bss)
 		atomic_dec(&sdata->bss->num_sta_ps);
=20
-	sta->flags &=3D ~(WLAN_STA_PS | WLAN_STA_PSPOLL);
+	clear_sta_flags(sta, WLAN_STA_PS | WLAN_STA_PSPOLL);
=20
 	if (!skb_queue_empty(&sta->ps_tx_buf))
 		sta_info_clear_tim_bit(sta);
@@ -732,9 +731,10 @@ ieee80211_rx_h_sta_process(struct ieee80
 	if (!(rx->fc & IEEE80211_FCTL_MOREFRAGS)) {
 		/* Change STA power saving mode only in the end of a frame
 		 * exchange sequence */
-		if ((sta->flags & WLAN_STA_PS) && !(rx->fc & IEEE80211_FCTL_PM))
+		if (test_sta_flags(sta, WLAN_STA_PS) &&
+		    !(rx->fc & IEEE80211_FCTL_PM))
 			rx->sent_ps_buffered +=3D ap_sta_ps_end(dev, sta);
-		else if (!(sta->flags & WLAN_STA_PS) &&
+		else if (!test_sta_flags(sta, WLAN_STA_PS) &&
 			 (rx->fc & IEEE80211_FCTL_PM))
 			ap_sta_ps_start(dev, sta);
 	}
@@ -988,7 +988,7 @@ ieee80211_rx_h_ps_poll(struct ieee80211_
 		 * Tell TX path to send one frame even though the STA may
 		 * still remain is PS mode after this frame exchange.
 		 */
-		rx->sta->flags |=3D WLAN_STA_PSPOLL;
+		set_sta_flags(rx->sta, WLAN_STA_PSPOLL);
=20
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 		printk(KERN_DEBUG "STA %s aid %d: PS Poll (entries after %d)\n",
@@ -1051,7 +1051,8 @@ ieee80211_rx_h_remove_qos_control(struct
 static int
 ieee80211_802_1x_port_control(struct ieee80211_rx_data *rx)
 {
-	if (unlikely(!rx->sta || !(rx->sta->flags & WLAN_STA_AUTHORIZED))) {
+	if (unlikely(!rx->sta ||
+	    !test_sta_flags(rx->sta, WLAN_STA_AUTHORIZED))) {
 #ifdef CONFIG_MAC80211_DEBUG
 		if (net_ratelimit())
 			printk(KERN_DEBUG "%s: dropped frame "
--- everything.orig/net/mac80211/tx.c	2008-04-01 15:17:12.000000000 +02=
00
+++ everything/net/mac80211/tx.c	2008-04-01 17:19:11.000000000 +0200
@@ -256,7 +256,7 @@ ieee80211_tx_h_check_assoc(struct ieee80
 	if (tx->flags & IEEE80211_TX_PS_BUFFERED)
 		return TX_CONTINUE;
=20
-	sta_flags =3D tx->sta ? tx->sta->flags : 0;
+	sta_flags =3D tx->sta ? get_sta_flags(tx->sta) : 0;
=20
 	if (likely(tx->flags & IEEE80211_TX_UNICAST)) {
 		if (unlikely(!(sta_flags & WLAN_STA_ASSOC) &&
@@ -391,6 +391,7 @@ static ieee80211_tx_result
 ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 {
 	struct sta_info *sta =3D tx->sta;
+	u32 staflags;
 	DECLARE_MAC_BUF(mac);
=20
 	if (unlikely(!sta ||
@@ -398,8 +399,10 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 		      (tx->fc & IEEE80211_FCTL_STYPE) =3D=3D IEEE80211_STYPE_PROBE_R=
ESP)))
 		return TX_CONTINUE;
=20
-	if (unlikely((sta->flags & WLAN_STA_PS) &&
-		     !(sta->flags & WLAN_STA_PSPOLL))) {
+	staflags =3D get_sta_flags(sta);
+
+	if (unlikely((staflags & WLAN_STA_PS) &&
+		     !(staflags & WLAN_STA_PSPOLL))) {
 		struct ieee80211_tx_packet_data *pkt_data;
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 		printk(KERN_DEBUG "STA %s aid %d: PS buffer (entries "
@@ -430,13 +433,13 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 		return TX_QUEUED;
 	}
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
-	else if (unlikely(sta->flags & WLAN_STA_PS)) {
+	else if (unlikely(test_sta_flags(sta, WLAN_STA_PS))) {
 		printk(KERN_DEBUG "%s: STA %s in PS mode, but pspoll "
 		       "set -> send frame\n", tx->dev->name,
 		       print_mac(mac, sta->addr));
 	}
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
-	sta->flags &=3D ~WLAN_STA_PSPOLL;
+	clear_sta_flags(sta, WLAN_STA_PSPOLL);
=20
 	return TX_CONTINUE;
 }
@@ -697,7 +700,7 @@ ieee80211_tx_h_misc(struct ieee80211_tx_
 	if (((fc & IEEE80211_FCTL_FTYPE) =3D=3D IEEE80211_FTYPE_DATA) &&
 	    (tx->rate->flags & IEEE80211_RATE_SHORT_PREAMBLE) &&
 	    tx->sdata->bss_conf.use_short_preamble &&
-	    (!tx->sta || (tx->sta->flags & WLAN_STA_SHORT_PREAMBLE))) {
+	    (!tx->sta || test_sta_flags(tx->sta, WLAN_STA_SHORT_PREAMBLE))) {
 		tx->control->flags |=3D IEEE80211_TXCTL_SHORT_PREAMBLE;
 	}
=20
@@ -1024,10 +1027,8 @@ __ieee80211_tx_prepare(struct ieee80211_
=20
 	if (!tx->sta)
 		control->flags |=3D IEEE80211_TXCTL_CLEAR_PS_FILT;
-	else if (tx->sta->flags & WLAN_STA_CLEAR_PS_FILT) {
+	else if (test_and_clear_sta_flags(tx->sta, WLAN_STA_CLEAR_PS_FILT))
 		control->flags |=3D IEEE80211_TXCTL_CLEAR_PS_FILT;
-		tx->sta->flags &=3D ~WLAN_STA_CLEAR_PS_FILT;
-	}
=20
 	hdrlen =3D ieee80211_get_hdrlen(tx->fc);
 	if (skb->len > hdrlen + sizeof(rfc1042_header) + 2) {
@@ -1485,7 +1486,7 @@ int ieee80211_subif_start_xmit(struct sk
 		rcu_read_lock();
 		sta =3D sta_info_get(local, hdr.addr1);
 		if (sta)
-			sta_flags =3D sta->flags;
+			sta_flags =3D get_sta_flags(sta);
 		rcu_read_unlock();
 	}
=20
--- everything.orig/net/mac80211/key.c	2008-04-01 15:21:03.000000000 +0=
200
+++ everything/net/mac80211/key.c	2008-04-01 15:23:57.000000000 +0200
@@ -243,7 +243,7 @@ void ieee80211_key_link(struct ieee80211
 		 * some hardware cannot handle TKIP with QoS, so
 		 * we indicate whether QoS could be in use.
 		 */
-		if (sta->flags & WLAN_STA_WME)
+		if (test_sta_flags(sta, WLAN_STA_WME))
 			key->conf.flags |=3D IEEE80211_KEY_FLAG_WMM_STA;
 	} else {
 		if (sdata->vif.type =3D=3D IEEE80211_IF_TYPE_STA) {
@@ -254,7 +254,7 @@ void ieee80211_key_link(struct ieee80211
 			/* same here, the AP could be using QoS */
 			ap =3D sta_info_get(key->local, key->sdata->u.sta.bssid);
 			if (ap) {
-				if (ap->flags & WLAN_STA_WME)
+				if (test_sta_flags(ap, WLAN_STA_WME))
 					key->conf.flags |=3D
 						IEEE80211_KEY_FLAG_WMM_STA;
 			}
--- everything.orig/net/mac80211/debugfs_sta.c	2008-04-01 15:17:34.0000=
00000 +0200
+++ everything/net/mac80211/debugfs_sta.c	2008-04-01 15:23:57.000000000=
 +0200
@@ -74,14 +74,15 @@ static ssize_t sta_flags_read(struct fil
 {
 	char buf[100];
 	struct sta_info *sta =3D file->private_data;
+	u32 staflags =3D get_sta_flags(sta);
 	int res =3D scnprintf(buf, sizeof(buf), "%s%s%s%s%s%s%s",
-		sta->flags & WLAN_STA_AUTH ? "AUTH\n" : "",
-		sta->flags & WLAN_STA_ASSOC ? "ASSOC\n" : "",
-		sta->flags & WLAN_STA_PS ? "PS\n" : "",
-		sta->flags & WLAN_STA_AUTHORIZED ? "AUTHORIZED\n" : "",
-		sta->flags & WLAN_STA_SHORT_PREAMBLE ? "SHORT PREAMBLE\n" : "",
-		sta->flags & WLAN_STA_WME ? "WME\n" : "",
-		sta->flags & WLAN_STA_WDS ? "WDS\n" : "");
+		staflags & WLAN_STA_AUTH ? "AUTH\n" : "",
+		staflags & WLAN_STA_ASSOC ? "ASSOC\n" : "",
+		staflags & WLAN_STA_PS ? "PS\n" : "",
+		staflags & WLAN_STA_AUTHORIZED ? "AUTHORIZED\n" : "",
+		staflags & WLAN_STA_SHORT_PREAMBLE ? "SHORT PREAMBLE\n" : "",
+		staflags & WLAN_STA_WME ? "WME\n" : "",
+		staflags & WLAN_STA_WDS ? "WDS\n" : "");
 	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
 }
 STA_OPS(flags);
--- everything.orig/net/mac80211/mesh_plink.c	2008-04-01 15:19:23.00000=
0000 +0200
+++ everything/net/mac80211/mesh_plink.c	2008-04-01 15:23:57.000000000 =
+0200
@@ -80,7 +80,7 @@ void mesh_plink_dec_estab_count(struct i
  *
  * @sta: mes peer link to restart
  *
- * Locking: this function must be called holding sta->plink_lock
+ * Locking: this function must be called holding sta->lock
  */
 static inline void mesh_plink_fsm_restart(struct sta_info *sta)
 {
@@ -106,7 +106,7 @@ static struct sta_info *mesh_plink_alloc
 	if (!sta)
 		return NULL;
=20
-	sta->flags |=3D WLAN_STA_AUTHORIZED;
+	sta->flags =3D WLAN_STA_AUTHORIZED;
 	sta->supp_rates[local->hw.conf.channel->band] =3D rates;
=20
 	return sta;
@@ -119,7 +119,7 @@ static struct sta_info *mesh_plink_alloc
  *
  * All mesh paths with this peer as next hop will be flushed
  *
- * Locking: the caller must hold sta->plink_lock
+ * Locking: the caller must hold sta->lock
  */
 static void __mesh_plink_deactivate(struct sta_info *sta)
 {
@@ -140,9 +140,9 @@ static void __mesh_plink_deactivate(stru
  */
 void mesh_plink_deactivate(struct sta_info *sta)
 {
-	spin_lock_bh(&sta->plink_lock);
+	spin_lock_bh(&sta->lock);
 	__mesh_plink_deactivate(sta);
-	spin_unlock_bh(&sta->plink_lock);
+	spin_unlock_bh(&sta->lock);
 }
=20
 static int mesh_plink_frame_tx(struct net_device *dev,
@@ -271,10 +271,10 @@ static void mesh_plink_timer(unsigned lo
 	 */
 	sta =3D (struct sta_info *) data;
=20
-	spin_lock_bh(&sta->plink_lock);
+	spin_lock_bh(&sta->lock);
 	if (sta->ignore_plink_timer) {
 		sta->ignore_plink_timer =3D false;
-		spin_unlock_bh(&sta->plink_lock);
+		spin_unlock_bh(&sta->lock);
 		return;
 	}
 	mpl_dbg("Mesh plink timer for %s fired on state %d\n",
@@ -299,7 +299,7 @@ static void mesh_plink_timer(unsigned lo
 					     rand % sta->plink_timeout;
 			++sta->plink_retries;
 			mod_plink_timer(sta, sta->plink_timeout);
-			spin_unlock_bh(&sta->plink_lock);
+			spin_unlock_bh(&sta->lock);
 			mesh_plink_frame_tx(dev, PLINK_OPEN, sta->addr, llid,
 					    0, 0);
 			break;
@@ -312,7 +312,7 @@ static void mesh_plink_timer(unsigned lo
 			reason =3D cpu_to_le16(MESH_CONFIRM_TIMEOUT);
 		sta->plink_state =3D PLINK_HOLDING;
 		mod_plink_timer(sta, dot11MeshHoldingTimeout(sdata));
-		spin_unlock_bh(&sta->plink_lock);
+		spin_unlock_bh(&sta->lock);
 		mesh_plink_frame_tx(dev, PLINK_CLOSE, sta->addr, llid, plid,
 				    reason);
 		break;
@@ -320,10 +320,10 @@ static void mesh_plink_timer(unsigned lo
 		/* holding timer */
 		del_timer(&sta->plink_timer);
 		mesh_plink_fsm_restart(sta);
-		spin_unlock_bh(&sta->plink_lock);
+		spin_unlock_bh(&sta->lock);
 		break;
 	default:
-		spin_unlock_bh(&sta->plink_lock);
+		spin_unlock_bh(&sta->lock);
 		break;
 	}
 }
@@ -345,16 +345,16 @@ int mesh_plink_open(struct sta_info *sta
 	DECLARE_MAC_BUF(mac);
 #endif
=20
-	spin_lock_bh(&sta->plink_lock);
+	spin_lock_bh(&sta->lock);
 	get_random_bytes(&llid, 2);
 	sta->llid =3D llid;
 	if (sta->plink_state !=3D PLINK_LISTEN) {
-		spin_unlock_bh(&sta->plink_lock);
+		spin_unlock_bh(&sta->lock);
 		return -EBUSY;
 	}
 	sta->plink_state =3D PLINK_OPN_SNT;
 	mesh_plink_timer_set(sta, dot11MeshRetryTimeout(sdata));
-	spin_unlock_bh(&sta->plink_lock);
+	spin_unlock_bh(&sta->lock);
 	mpl_dbg("Mesh plink: starting establishment with %s\n",
 		print_mac(mac, sta->addr));
=20
@@ -368,10 +368,10 @@ void mesh_plink_block(struct sta_info *s
 	DECLARE_MAC_BUF(mac);
 #endif
=20
-	spin_lock_bh(&sta->plink_lock);
+	spin_lock_bh(&sta->lock);
 	__mesh_plink_deactivate(sta);
 	sta->plink_state =3D PLINK_BLOCKED;
-	spin_unlock_bh(&sta->plink_lock);
+	spin_unlock_bh(&sta->lock);
 }
=20
 int mesh_plink_close(struct sta_info *sta)
@@ -384,14 +384,14 @@ int mesh_plink_close(struct sta_info *st
=20
 	mpl_dbg("Mesh plink: closing link with %s\n",
 			print_mac(mac, sta->addr));
-	spin_lock_bh(&sta->plink_lock);
+	spin_lock_bh(&sta->lock);
 	sta->reason =3D cpu_to_le16(MESH_LINK_CANCELLED);
 	reason =3D sta->reason;
=20
 	if (sta->plink_state =3D=3D PLINK_LISTEN ||
 	    sta->plink_state =3D=3D PLINK_BLOCKED) {
 		mesh_plink_fsm_restart(sta);
-		spin_unlock_bh(&sta->plink_lock);
+		spin_unlock_bh(&sta->lock);
 		return 0;
 	} else if (sta->plink_state =3D=3D PLINK_ESTAB) {
 		__mesh_plink_deactivate(sta);
@@ -403,7 +403,7 @@ int mesh_plink_close(struct sta_info *st
 	sta->plink_state =3D PLINK_HOLDING;
 	llid =3D sta->llid;
 	plid =3D sta->plid;
-	spin_unlock_bh(&sta->plink_lock);
+	spin_unlock_bh(&sta->lock);
 	mesh_plink_frame_tx(sta->sdata->dev, PLINK_CLOSE, sta->addr, llid,
 			    plid, reason);
 	return 0;
@@ -491,7 +491,7 @@ void mesh_rx_plink_frame(struct net_devi
 			/* avoid warning */
 			break;
 		}
-		spin_lock_bh(&sta->plink_lock);
+		spin_lock_bh(&sta->lock);
 	} else if (!sta) {
 		/* ftype =3D=3D PLINK_OPEN */
 		u64 rates;
@@ -513,9 +513,9 @@ void mesh_rx_plink_frame(struct net_devi
 			return;
 		}
 		event =3D OPN_ACPT;
-		spin_lock_bh(&sta->plink_lock);
+		spin_lock_bh(&sta->lock);
 	} else {
-		spin_lock_bh(&sta->plink_lock);
+		spin_lock_bh(&sta->lock);
 		switch (ftype) {
 		case PLINK_OPEN:
 			if (!mesh_plink_free_count(sdata) ||
@@ -552,7 +552,7 @@ void mesh_rx_plink_frame(struct net_devi
 			break;
 		default:
 			mpl_dbg("Mesh plink: unknown frame subtype\n");
-			spin_unlock_bh(&sta->plink_lock);
+			spin_unlock_bh(&sta->lock);
 			rcu_read_unlock();
 			return;
 		}
@@ -569,7 +569,7 @@ void mesh_rx_plink_frame(struct net_devi
 		switch (event) {
 		case CLS_ACPT:
 			mesh_plink_fsm_restart(sta);
-			spin_unlock_bh(&sta->plink_lock);
+			spin_unlock_bh(&sta->lock);
 			break;
 		case OPN_ACPT:
 			sta->plink_state =3D PLINK_OPN_RCVD;
@@ -577,14 +577,14 @@ void mesh_rx_plink_frame(struct net_devi
 			get_random_bytes(&llid, 2);
 			sta->llid =3D llid;
 			mesh_plink_timer_set(sta, dot11MeshRetryTimeout(sdata));
-			spin_unlock_bh(&sta->plink_lock);
+			spin_unlock_bh(&sta->lock);
 			mesh_plink_frame_tx(dev, PLINK_OPEN, sta->addr, llid,
 					    0, 0);
 			mesh_plink_frame_tx(dev, PLINK_CONFIRM, sta->addr,
 					    llid, plid, 0);
 			break;
 		default:
-			spin_unlock_bh(&sta->plink_lock);
+			spin_unlock_bh(&sta->lock);
 			break;
 		}
 		break;
@@ -604,7 +604,7 @@ void mesh_rx_plink_frame(struct net_devi
 				sta->ignore_plink_timer =3D true;
=20
 			llid =3D sta->llid;
-			spin_unlock_bh(&sta->plink_lock);
+			spin_unlock_bh(&sta->lock);
 			mesh_plink_frame_tx(dev, PLINK_CLOSE, sta->addr, llid,
 					    plid, reason);
 			break;
@@ -613,7 +613,7 @@ void mesh_rx_plink_frame(struct net_devi
 			sta->plink_state =3D PLINK_OPN_RCVD;
 			sta->plid =3D plid;
 			llid =3D sta->llid;
-			spin_unlock_bh(&sta->plink_lock);
+			spin_unlock_bh(&sta->lock);
 			mesh_plink_frame_tx(dev, PLINK_CONFIRM, sta->addr, llid,
 					    plid, 0);
 			break;
@@ -623,10 +623,10 @@ void mesh_rx_plink_frame(struct net_devi
 					     dot11MeshConfirmTimeout(sdata)))
 				sta->ignore_plink_timer =3D true;
=20
-			spin_unlock_bh(&sta->plink_lock);
+			spin_unlock_bh(&sta->lock);
 			break;
 		default:
-			spin_unlock_bh(&sta->plink_lock);
+			spin_unlock_bh(&sta->lock);
 			break;
 		}
 		break;
@@ -646,13 +646,13 @@ void mesh_rx_plink_frame(struct net_devi
 				sta->ignore_plink_timer =3D true;
=20
 			llid =3D sta->llid;
-			spin_unlock_bh(&sta->plink_lock);
+			spin_unlock_bh(&sta->lock);
 			mesh_plink_frame_tx(dev, PLINK_CLOSE, sta->addr, llid,
 					    plid, reason);
 			break;
 		case OPN_ACPT:
 			llid =3D sta->llid;
-			spin_unlock_bh(&sta->plink_lock);
+			spin_unlock_bh(&sta->lock);
 			mesh_plink_frame_tx(dev, PLINK_CONFIRM, sta->addr, llid,
 					    plid, 0);
 			break;
@@ -660,12 +660,12 @@ void mesh_rx_plink_frame(struct net_devi
 			del_timer(&sta->plink_timer);
 			sta->plink_state =3D PLINK_ESTAB;
 			mesh_plink_inc_estab_count(sdata);
-			spin_unlock_bh(&sta->plink_lock);
+			spin_unlock_bh(&sta->lock);
 			mpl_dbg("Mesh plink with %s ESTABLISHED\n",
 					print_mac(mac, sta->addr));
 			break;
 		default:
-			spin_unlock_bh(&sta->plink_lock);
+			spin_unlock_bh(&sta->lock);
 			break;
 		}
 		break;
@@ -685,7 +685,7 @@ void mesh_rx_plink_frame(struct net_devi
 				sta->ignore_plink_timer =3D true;
=20
 			llid =3D sta->llid;
-			spin_unlock_bh(&sta->plink_lock);
+			spin_unlock_bh(&sta->lock);
 			mesh_plink_frame_tx(dev, PLINK_CLOSE, sta->addr, llid,
 					    plid, reason);
 			break;
@@ -693,14 +693,14 @@ void mesh_rx_plink_frame(struct net_devi
 			del_timer(&sta->plink_timer);
 			sta->plink_state =3D PLINK_ESTAB;
 			mesh_plink_inc_estab_count(sdata);
-			spin_unlock_bh(&sta->plink_lock);
+			spin_unlock_bh(&sta->lock);
 			mpl_dbg("Mesh plink with %s ESTABLISHED\n",
 					print_mac(mac, sta->addr));
 			mesh_plink_frame_tx(dev, PLINK_CONFIRM, sta->addr, llid,
 					    plid, 0);
 			break;
 		default:
-			spin_unlock_bh(&sta->plink_lock);
+			spin_unlock_bh(&sta->lock);
 			break;
 		}
 		break;
@@ -714,18 +714,18 @@ void mesh_rx_plink_frame(struct net_devi
 			sta->plink_state =3D PLINK_HOLDING;
 			llid =3D sta->llid;
 			mod_plink_timer(sta, dot11MeshHoldingTimeout(sdata));
-			spin_unlock_bh(&sta->plink_lock);
+			spin_unlock_bh(&sta->lock);
 			mesh_plink_frame_tx(dev, PLINK_CLOSE, sta->addr, llid,
 					    plid, reason);
 			break;
 		case OPN_ACPT:
 			llid =3D sta->llid;
-			spin_unlock_bh(&sta->plink_lock);
+			spin_unlock_bh(&sta->lock);
 			mesh_plink_frame_tx(dev, PLINK_CONFIRM, sta->addr, llid,
 					    plid, 0);
 			break;
 		default:
-			spin_unlock_bh(&sta->plink_lock);
+			spin_unlock_bh(&sta->lock);
 			break;
 		}
 		break;
@@ -735,7 +735,7 @@ void mesh_rx_plink_frame(struct net_devi
 			if (del_timer(&sta->plink_timer))
 				sta->ignore_plink_timer =3D 1;
 			mesh_plink_fsm_restart(sta);
-			spin_unlock_bh(&sta->plink_lock);
+			spin_unlock_bh(&sta->lock);
 			break;
 		case OPN_ACPT:
 		case CNF_ACPT:
@@ -743,19 +743,19 @@ void mesh_rx_plink_frame(struct net_devi
 		case CNF_RJCT:
 			llid =3D sta->llid;
 			reason =3D sta->reason;
-			spin_unlock_bh(&sta->plink_lock);
+			spin_unlock_bh(&sta->lock);
 			mesh_plink_frame_tx(dev, PLINK_CLOSE, sta->addr, llid,
 					    plid, reason);
 			break;
 		default:
-			spin_unlock_bh(&sta->plink_lock);
+			spin_unlock_bh(&sta->lock);
 		}
 		break;
 	default:
 		/* should not get here, PLINK_BLOCKED is dealt with at the
 		 * beggining of the function
 		 */
-		spin_unlock_bh(&sta->plink_lock);
+		spin_unlock_bh(&sta->lock);
 		break;
 	}
=20
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-4965-rs.c	2008-04-=
01 17:23:27.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-4965-rs.c	2008-04-01 17=
:23:35.000000000 +0200
@@ -396,9 +396,9 @@ static void rs_tl_turn_on_agg_for_tid(st
 	unsigned long state;
 	DECLARE_MAC_BUF(mac);
=20
-	spin_lock_bh(&sta->ampdu_mlme.ampdu_tx);
+	spin_lock_bh(&sta->lock);
 	state =3D sta->ampdu_mlme.tid_state_tx[tid];
-	spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
+	spin_unlock_bh(&sta->lock);
=20
 	if (state =3D=3D HT_AGG_STATE_IDLE &&
 	    rs_tl_get_load(lq_data, tid) > IWL_AGG_LOAD_THRESHOLD) {


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
