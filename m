Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39251 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab1I1MNf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Sep 2011 08:13:35 -0400
Message-Id: <20110928121131.723687359@sipsolutions.net> (sfid-20110928_141339_025787_73473D98)
Date: Wed, 28 Sep 2011 14:09:00 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 11/15] mac80211: optimise station flags
References: <20110928120849.882884360@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The flaglock in struct sta_info has long been
something that I wanted to get rid of, this
finally does the conversion to atomic bitops.

The conversion itself is straight-forward in
most places, a few things needed to change a
bit since we can no longer use multiple bits
at the same time.

On x86-64, this is a fairly significant code
size reduction:
   text	   data	    bss	    dec	    hex
 427861	  23648	   1008	 452517	  6e7a5	before
 425383	  23648	    976	 450007	  6ddd7	after

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-rx.c      |    2 
 net/mac80211/agg-tx.c      |    2 
 net/mac80211/cfg.c         |   44 ++++++++++---------
 net/mac80211/debugfs_sta.c |   20 ++++----
 net/mac80211/ht.c          |    2 
 net/mac80211/ibss.c        |    4 -
 net/mac80211/iface.c       |    4 -
 net/mac80211/key.c         |    4 -
 net/mac80211/mesh_plink.c  |    8 ++-
 net/mac80211/mlme.c        |   22 ++++-----
 net/mac80211/pm.c          |    2 
 net/mac80211/rx.c          |   28 ++++++------
 net/mac80211/sta_info.c    |   35 ++++++++-------
 net/mac80211/sta_info.h    |  104 ++++++++++++++-------------------------------
 net/mac80211/status.c      |   12 ++---
 net/mac80211/tx.c          |   68 ++++++++++++++++-------------
 net/mac80211/util.c        |    2 
 net/mac80211/wme.c         |    4 -
 18 files changed, 173 insertions(+), 194 deletions(-)

--- a/net/mac80211/mlme.c	2011-09-28 13:18:07.000000000 +0200
+++ b/net/mac80211/mlme.c	2011-09-28 13:53:57.000000000 +0200
@@ -627,7 +627,7 @@ static bool ieee80211_powersave_allowed(
 {
 	struct ieee80211_if_managed *mgd = &sdata->u.mgd;
 	struct sta_info *sta = NULL;
-	u32 sta_flags = 0;
+	bool authorized = false;
 
 	if (!mgd->powersave)
 		return false;
@@ -645,13 +645,10 @@ static bool ieee80211_powersave_allowed(
 	rcu_read_lock();
 	sta = sta_info_get(sdata, mgd->bssid);
 	if (sta)
-		sta_flags = get_sta_flags(sta);
+		authorized = test_sta_flag(sta, WLAN_STA_AUTHORIZED);
 	rcu_read_unlock();
 
-	if (!(sta_flags & WLAN_STA_AUTHORIZED))
-		return false;
-
-	return true;
+	return authorized;
 }
 
 /* need to hold RTNL or interface lock */
@@ -1095,7 +1092,7 @@ static void ieee80211_set_disassoc(struc
 	mutex_lock(&local->sta_mtx);
 	sta = sta_info_get(sdata, bssid);
 	if (sta) {
-		set_sta_flags(sta, WLAN_STA_BLOCK_BA);
+		set_sta_flag(sta, WLAN_STA_BLOCK_BA);
 		ieee80211_sta_tear_down_BA_sessions(sta, tx);
 	}
 	mutex_unlock(&local->sta_mtx);
@@ -1513,10 +1510,11 @@ static bool ieee80211_assoc_success(stru
 		return false;
 	}
 
-	set_sta_flags(sta, WLAN_STA_AUTH | WLAN_STA_ASSOC |
-			   WLAN_STA_ASSOC_AP);
+	set_sta_flag(sta, WLAN_STA_AUTH);
+	set_sta_flag(sta, WLAN_STA_ASSOC);
+	set_sta_flag(sta, WLAN_STA_ASSOC_AP);
 	if (!(ifmgd->flags & IEEE80211_STA_CONTROL_PORT))
-		set_sta_flags(sta, WLAN_STA_AUTHORIZED);
+		set_sta_flag(sta, WLAN_STA_AUTHORIZED);
 
 	rates = 0;
 	basic_rates = 0;
@@ -1575,10 +1573,10 @@ static bool ieee80211_assoc_success(stru
 	rate_control_rate_init(sta);
 
 	if (ifmgd->flags & IEEE80211_STA_MFP_ENABLED)
-		set_sta_flags(sta, WLAN_STA_MFP);
+		set_sta_flag(sta, WLAN_STA_MFP);
 
 	if (elems.wmm_param)
-		set_sta_flags(sta, WLAN_STA_WME);
+		set_sta_flag(sta, WLAN_STA_WME);
 
 	/* sta_info_reinsert will also unlock the mutex lock */
 	err = sta_info_reinsert(sta);
--- a/net/mac80211/sta_info.c	2011-09-28 13:38:11.000000000 +0200
+++ b/net/mac80211/sta_info.c	2011-09-28 13:53:57.000000000 +0200
@@ -244,22 +244,22 @@ static void sta_unblock(struct work_stru
 	if (sta->dead)
 		return;
 
-	if (!test_sta_flags(sta, WLAN_STA_PS_STA))
+	if (!test_sta_flag(sta, WLAN_STA_PS_STA))
 		ieee80211_sta_ps_deliver_wakeup(sta);
-	else if (test_and_clear_sta_flags(sta, WLAN_STA_PSPOLL)) {
-		clear_sta_flags(sta, WLAN_STA_PS_DRIVER);
+	else if (test_and_clear_sta_flag(sta, WLAN_STA_PSPOLL)) {
+		clear_sta_flag(sta, WLAN_STA_PS_DRIVER);
 
 		local_bh_disable();
 		ieee80211_sta_ps_deliver_poll_response(sta);
 		local_bh_enable();
-	} else if (test_and_clear_sta_flags(sta, WLAN_STA_UAPSD)) {
-		clear_sta_flags(sta, WLAN_STA_PS_DRIVER);
+	} else if (test_and_clear_sta_flag(sta, WLAN_STA_UAPSD)) {
+		clear_sta_flag(sta, WLAN_STA_PS_DRIVER);
 
 		local_bh_disable();
 		ieee80211_sta_ps_deliver_uapsd(sta);
 		local_bh_enable();
 	} else
-		clear_sta_flags(sta, WLAN_STA_PS_DRIVER);
+		clear_sta_flag(sta, WLAN_STA_PS_DRIVER);
 }
 
 static int sta_prepare_rate_control(struct ieee80211_local *local,
@@ -292,7 +292,6 @@ struct sta_info *sta_info_alloc(struct i
 		return NULL;
 
 	spin_lock_init(&sta->lock);
-	spin_lock_init(&sta->flaglock);
 	INIT_WORK(&sta->drv_unblock_wk, sta_unblock);
 	INIT_WORK(&sta->ampdu_mlme.work, ieee80211_ba_session_work);
 	mutex_init(&sta->ampdu_mlme.mtx);
@@ -861,7 +860,7 @@ static int __must_check __sta_info_destr
 	 * sessions -- block that to make sure the tear-down
 	 * will be sufficient.
 	 */
-	set_sta_flags(sta, WLAN_STA_BLOCK_BA);
+	set_sta_flag(sta, WLAN_STA_BLOCK_BA);
 	ieee80211_sta_tear_down_BA_sessions(sta, true);
 
 	spin_lock_irqsave(&local->sta_lock, flags);
@@ -888,10 +887,13 @@ static int __must_check __sta_info_destr
 		__skb_queue_purge(&sta->tx_filtered[ac]);
 	}
 
-	if (test_and_clear_sta_flags(sta,
-				WLAN_STA_PS_STA | WLAN_STA_PS_DRIVER)) {
+	if (test_sta_flag(sta, WLAN_STA_PS_STA) ||
+	    test_sta_flag(sta, WLAN_STA_PS_DRIVER)) {
 		BUG_ON(!sdata->bss);
 
+		clear_sta_flag(sta, WLAN_STA_PS_STA);
+		clear_sta_flag(sta, WLAN_STA_PS_DRIVER);
+
 		atomic_dec(&sdata->bss->num_sta_ps);
 		sta_info_recalc_tim(sta);
 	}
@@ -1106,7 +1108,8 @@ static void clear_sta_ps_flags(void *_st
 {
 	struct sta_info *sta = _sta;
 
-	clear_sta_flags(sta, WLAN_STA_PS_DRIVER | WLAN_STA_PS_STA);
+	clear_sta_flag(sta, WLAN_STA_PS_DRIVER);
+	clear_sta_flag(sta, WLAN_STA_PS_STA);
 }
 
 /* powersave support code */
@@ -1117,7 +1120,7 @@ void ieee80211_sta_ps_deliver_wakeup(str
 	struct sk_buff_head pending;
 	int filtered = 0, buffered = 0, ac;
 
-	clear_sta_flags(sta, WLAN_STA_SP);
+	clear_sta_flag(sta, WLAN_STA_SP);
 
 	BUILD_BUG_ON(BITS_TO_LONGS(STA_TID_NUM) > 1);
 	sta->driver_buffered_tids = 0;
@@ -1163,7 +1166,7 @@ static void ieee80211_send_null_response
 	struct sk_buff *skb;
 	int size = sizeof(*nullfunc);
 	__le16 fc;
-	bool qos = test_sta_flags(sta, WLAN_STA_WME);
+	bool qos = test_sta_flag(sta, WLAN_STA_WME);
 	struct ieee80211_tx_info *info;
 
 	if (qos) {
@@ -1231,7 +1234,7 @@ ieee80211_sta_ps_deliver_response(struct
 	struct sk_buff_head frames;
 
 	/* Service or PS-Poll period starts */
-	set_sta_flags(sta, WLAN_STA_SP);
+	set_sta_flag(sta, WLAN_STA_SP);
 
 	__skb_queue_head_init(&frames);
 
@@ -1443,8 +1446,8 @@ void ieee80211_sta_block_awake(struct ie
 	trace_api_sta_block_awake(sta->local, pubsta, block);
 
 	if (block)
-		set_sta_flags(sta, WLAN_STA_PS_DRIVER);
-	else if (test_sta_flags(sta, WLAN_STA_PS_DRIVER))
+		set_sta_flag(sta, WLAN_STA_PS_DRIVER);
+	else if (test_sta_flag(sta, WLAN_STA_PS_DRIVER))
 		ieee80211_queue_work(hw, &sta->drv_unblock_wk);
 }
 EXPORT_SYMBOL(ieee80211_sta_block_awake);
--- a/net/mac80211/sta_info.h	2011-09-28 13:38:11.000000000 +0200
+++ b/net/mac80211/sta_info.h	2011-09-28 13:54:50.000000000 +0200
@@ -19,7 +19,8 @@
 /**
  * enum ieee80211_sta_info_flags - Stations flags
  *
- * These flags are used with &struct sta_info's @flags member.
+ * These flags are used with &struct sta_info's @flags member, but
+ * only indirectly with set_sta_flag() and friends.
  *
  * @WLAN_STA_AUTH: Station is authenticated.
  * @WLAN_STA_ASSOC: Station is associated.
@@ -53,23 +54,23 @@
  *	reply to other uAPSD trigger frames or PS-Poll.
  */
 enum ieee80211_sta_info_flags {
-	WLAN_STA_AUTH		= 1<<0,
-	WLAN_STA_ASSOC		= 1<<1,
-	WLAN_STA_PS_STA		= 1<<2,
-	WLAN_STA_AUTHORIZED	= 1<<3,
-	WLAN_STA_SHORT_PREAMBLE	= 1<<4,
-	WLAN_STA_ASSOC_AP	= 1<<5,
-	WLAN_STA_WME		= 1<<6,
-	WLAN_STA_WDS		= 1<<7,
-	WLAN_STA_CLEAR_PS_FILT	= 1<<9,
-	WLAN_STA_MFP		= 1<<10,
-	WLAN_STA_BLOCK_BA	= 1<<11,
-	WLAN_STA_PS_DRIVER	= 1<<12,
-	WLAN_STA_PSPOLL		= 1<<13,
-	WLAN_STA_TDLS_PEER	= 1<<15,
-	WLAN_STA_TDLS_PEER_AUTH	= 1<<16,
-	WLAN_STA_UAPSD		= 1<<17,
-	WLAN_STA_SP		= 1<<18,
+	WLAN_STA_AUTH,
+	WLAN_STA_ASSOC,
+	WLAN_STA_PS_STA,
+	WLAN_STA_AUTHORIZED,
+	WLAN_STA_SHORT_PREAMBLE,
+	WLAN_STA_ASSOC_AP,
+	WLAN_STA_WME,
+	WLAN_STA_WDS,
+	WLAN_STA_CLEAR_PS_FILT,
+	WLAN_STA_MFP,
+	WLAN_STA_BLOCK_BA,
+	WLAN_STA_PS_DRIVER,
+	WLAN_STA_PSPOLL,
+	WLAN_STA_TDLS_PEER,
+	WLAN_STA_TDLS_PEER_AUTH,
+	WLAN_STA_UAPSD,
+	WLAN_STA_SP,
 };
 
 #define STA_TID_NUM 16
@@ -212,10 +213,9 @@ struct sta_ampdu_mlme {
  * @last_rx_rate_flag: rx status flag of the last data packet
  * @lock: used for locking all fields that require locking, see comments
  *	in the header file.
- * @flaglock: spinlock for flags accesses
  * @drv_unblock_wk: used for driver PS unblocking
  * @listen_interval: listen interval of this station, when we're acting as AP
- * @flags: STA flags, see &enum ieee80211_sta_info_flags
+ * @_flags: STA flags, see &enum ieee80211_sta_info_flags, do not use directly
  * @ps_tx_buf: buffers (per AC) of frames to transmit to this station
  *	when it leaves power saving state or polls
  * @tx_filtered: buffers (per AC) of frames we already tried to
@@ -272,7 +272,6 @@ struct sta_info {
 	struct rate_control_ref *rate_ctrl;
 	void *rate_ctrl_priv;
 	spinlock_t lock;
-	spinlock_t flaglock;
 
 	struct work_struct drv_unblock_wk;
 
@@ -282,11 +281,8 @@ struct sta_info {
 
 	bool uploaded;
 
-	/*
-	 * frequently updated, locked with own spinlock (flaglock),
-	 * use the accessors defined below
-	 */
-	u32 flags;
+	/* use the accessors defined below */
+	unsigned long _flags;
 
 	/*
 	 * STA powersave frame queues, no more than the internal
@@ -370,60 +366,28 @@ static inline enum nl80211_plink_state s
 	return NL80211_PLINK_LISTEN;
 }
 
-static inline void set_sta_flags(struct sta_info *sta, const u32 flags)
+static inline void set_sta_flag(struct sta_info *sta,
+				enum ieee80211_sta_info_flags flag)
 {
-	unsigned long irqfl;
-
-	spin_lock_irqsave(&sta->flaglock, irqfl);
-	sta->flags |= flags;
-	spin_unlock_irqrestore(&sta->flaglock, irqfl);
+	set_bit(flag, &sta->_flags);
 }
 
-static inline void clear_sta_flags(struct sta_info *sta, const u32 flags)
+static inline void clear_sta_flag(struct sta_info *sta,
+				  enum ieee80211_sta_info_flags flag)
 {
-	unsigned long irqfl;
-
-	spin_lock_irqsave(&sta->flaglock, irqfl);
-	sta->flags &= ~flags;
-	spin_unlock_irqrestore(&sta->flaglock, irqfl);
+	clear_bit(flag, &sta->_flags);
 }
 
-static inline u32 test_sta_flags(struct sta_info *sta, const u32 flags)
+static inline int test_sta_flag(struct sta_info *sta,
+				enum ieee80211_sta_info_flags flag)
 {
-	u32 ret;
-	unsigned long irqfl;
-
-	spin_lock_irqsave(&sta->flaglock, irqfl);
-	ret = sta->flags & flags;
-	spin_unlock_irqrestore(&sta->flaglock, irqfl);
-
-	return ret;
+	return test_bit(flag, &sta->_flags);
 }
 
-static inline u32 test_and_clear_sta_flags(struct sta_info *sta,
-					   const u32 flags)
+static inline int test_and_clear_sta_flag(struct sta_info *sta,
+					  enum ieee80211_sta_info_flags flag)
 {
-	u32 ret;
-	unsigned long irqfl;
-
-	spin_lock_irqsave(&sta->flaglock, irqfl);
-	ret = sta->flags & flags;
-	sta->flags &= ~flags;
-	spin_unlock_irqrestore(&sta->flaglock, irqfl);
-
-	return ret;
-}
-
-static inline u32 get_sta_flags(struct sta_info *sta)
-{
-	u32 ret;
-	unsigned long irqfl;
-
-	spin_lock_irqsave(&sta->flaglock, irqfl);
-	ret = sta->flags;
-	spin_unlock_irqrestore(&sta->flaglock, irqfl);
-
-	return ret;
+	return test_and_clear_bit(flag, &sta->_flags);
 }
 
 void ieee80211_assign_tid_tx(struct sta_info *sta, int tid,
--- a/net/mac80211/agg-rx.c	2011-09-28 11:39:12.000000000 +0200
+++ b/net/mac80211/agg-rx.c	2011-09-28 13:53:57.000000000 +0200
@@ -223,7 +223,7 @@ void ieee80211_process_addba_request(str
 
 	status = WLAN_STATUS_REQUEST_DECLINED;
 
-	if (test_sta_flags(sta, WLAN_STA_BLOCK_BA)) {
+	if (test_sta_flag(sta, WLAN_STA_BLOCK_BA)) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "Suspend in progress. "
 		       "Denying ADDBA request\n");
--- a/net/mac80211/agg-tx.c	2011-09-28 11:39:11.000000000 +0200
+++ b/net/mac80211/agg-tx.c	2011-09-28 13:53:57.000000000 +0200
@@ -382,7 +382,7 @@ int ieee80211_start_tx_ba_session(struct
 	    sdata->vif.type != NL80211_IFTYPE_AP)
 		return -EINVAL;
 
-	if (test_sta_flags(sta, WLAN_STA_BLOCK_BA)) {
+	if (test_sta_flag(sta, WLAN_STA_BLOCK_BA)) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "BA sessions blocked. "
 		       "Denying BA session request\n");
--- a/net/mac80211/ht.c	2011-09-28 11:39:12.000000000 +0200
+++ b/net/mac80211/ht.c	2011-09-28 13:53:57.000000000 +0200
@@ -130,7 +130,7 @@ void ieee80211_ba_session_work(struct wo
 	 * down by the code that set the flag, so this
 	 * need not run.
 	 */
-	if (test_sta_flags(sta, WLAN_STA_BLOCK_BA))
+	if (test_sta_flag(sta, WLAN_STA_BLOCK_BA))
 		return;
 
 	mutex_lock(&sta->ampdu_mlme.mtx);
--- a/net/mac80211/ibss.c	2011-09-28 11:44:04.000000000 +0200
+++ b/net/mac80211/ibss.c	2011-09-28 13:53:57.000000000 +0200
@@ -314,7 +314,7 @@ static void ieee80211_rx_bss_info(struct
 		}
 
 		if (sta && elems->wmm_info)
-			set_sta_flags(sta, WLAN_STA_WME);
+			set_sta_flag(sta, WLAN_STA_WME);
 
 		rcu_read_unlock();
 	}
@@ -452,7 +452,7 @@ struct sta_info *ieee80211_ibss_add_sta(
 		return NULL;
 
 	sta->last_rx = jiffies;
-	set_sta_flags(sta, WLAN_STA_AUTHORIZED);
+	set_sta_flag(sta, WLAN_STA_AUTHORIZED);
 
 	/* make sure mandatory rates are always added */
 	sta->sta.supp_rates[band] = supp_rates |
--- a/net/mac80211/key.c	2011-09-28 11:39:12.000000000 +0200
+++ b/net/mac80211/key.c	2011-09-28 13:53:57.000000000 +0200
@@ -464,7 +464,7 @@ int ieee80211_key_link(struct ieee80211_
 		 * some hardware cannot handle TKIP with QoS, so
 		 * we indicate whether QoS could be in use.
 		 */
-		if (test_sta_flags(sta, WLAN_STA_WME))
+		if (test_sta_flag(sta, WLAN_STA_WME))
 			key->conf.flags |= IEEE80211_KEY_FLAG_WMM_STA;
 	} else {
 		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
@@ -478,7 +478,7 @@ int ieee80211_key_link(struct ieee80211_
 			/* same here, the AP could be using QoS */
 			ap = sta_info_get(key->sdata, key->sdata->u.mgd.bssid);
 			if (ap) {
-				if (test_sta_flags(ap, WLAN_STA_WME))
+				if (test_sta_flag(ap, WLAN_STA_WME))
 					key->conf.flags |=
 						IEEE80211_KEY_FLAG_WMM_STA;
 			}
--- a/net/mac80211/mesh_plink.c	2011-09-28 13:18:05.000000000 +0200
+++ b/net/mac80211/mesh_plink.c	2011-09-28 13:53:57.000000000 +0200
@@ -92,7 +92,9 @@ static struct sta_info *mesh_plink_alloc
 	if (!sta)
 		return NULL;
 
-	sta->flags = WLAN_STA_AUTHORIZED | WLAN_STA_AUTH | WLAN_STA_WME;
+	set_sta_flag(sta, WLAN_STA_AUTH);
+	set_sta_flag(sta, WLAN_STA_AUTHORIZED);
+	set_sta_flag(sta, WLAN_STA_WME);
 	sta->sta.supp_rates[local->hw.conf.channel->band] = rates;
 	rate_control_rate_init(sta);
 
@@ -383,7 +385,7 @@ int mesh_plink_open(struct sta_info *sta
 	__le16 llid;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 
-	if (!test_sta_flags(sta, WLAN_STA_AUTH))
+	if (!test_sta_flag(sta, WLAN_STA_AUTH))
 		return -EPERM;
 
 	spin_lock_bh(&sta->lock);
@@ -503,7 +505,7 @@ void mesh_rx_plink_frame(struct ieee8021
 		return;
 	}
 
-	if (sta && !test_sta_flags(sta, WLAN_STA_AUTH)) {
+	if (sta && !test_sta_flag(sta, WLAN_STA_AUTH)) {
 		mpl_dbg("Mesh plink: Action frame from non-authed peer\n");
 		rcu_read_unlock();
 		return;
--- a/net/mac80211/pm.c	2011-09-28 11:39:12.000000000 +0200
+++ b/net/mac80211/pm.c	2011-09-28 13:53:57.000000000 +0200
@@ -42,7 +42,7 @@ int __ieee80211_suspend(struct ieee80211
 	if (hw->flags & IEEE80211_HW_AMPDU_AGGREGATION) {
 		mutex_lock(&local->sta_mtx);
 		list_for_each_entry(sta, &local->sta_list, list) {
-			set_sta_flags(sta, WLAN_STA_BLOCK_BA);
+			set_sta_flag(sta, WLAN_STA_BLOCK_BA);
 			ieee80211_sta_tear_down_BA_sessions(sta, true);
 		}
 		mutex_unlock(&local->sta_mtx);
--- a/net/mac80211/rx.c	2011-09-28 13:38:11.000000000 +0200
+++ b/net/mac80211/rx.c	2011-09-28 13:53:57.000000000 +0200
@@ -841,7 +841,7 @@ ieee80211_rx_h_check(struct ieee80211_rx
 		      ieee80211_is_pspoll(hdr->frame_control)) &&
 		     rx->sdata->vif.type != NL80211_IFTYPE_ADHOC &&
 		     rx->sdata->vif.type != NL80211_IFTYPE_WDS &&
-		     (!rx->sta || !test_sta_flags(rx->sta, WLAN_STA_ASSOC)))) {
+		     (!rx->sta || !test_sta_flag(rx->sta, WLAN_STA_ASSOC)))) {
 		if (rx->sta && rx->sta->dummy &&
 		    ieee80211_is_data_present(hdr->frame_control)) {
 			u16 ethertype;
@@ -1110,7 +1110,7 @@ static void ap_sta_ps_start(struct sta_i
 	struct ieee80211_local *local = sdata->local;
 
 	atomic_inc(&sdata->bss->num_sta_ps);
-	set_sta_flags(sta, WLAN_STA_PS_STA);
+	set_sta_flag(sta, WLAN_STA_PS_STA);
 	if (!(local->hw.flags & IEEE80211_HW_AP_LINK_PS))
 		drv_sta_notify(local, sdata, STA_NOTIFY_SLEEP, &sta->sta);
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
@@ -1130,7 +1130,7 @@ static void ap_sta_ps_end(struct sta_inf
 	       sdata->name, sta->sta.addr, sta->sta.aid);
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
 
-	if (test_sta_flags(sta, WLAN_STA_PS_DRIVER)) {
+	if (test_sta_flag(sta, WLAN_STA_PS_DRIVER)) {
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 		printk(KERN_DEBUG "%s: STA %pM aid %d driver-ps-blocked\n",
 		       sdata->name, sta->sta.addr, sta->sta.aid);
@@ -1149,7 +1149,7 @@ int ieee80211_sta_ps_transition(struct i
 	WARN_ON(!(sta_inf->local->hw.flags & IEEE80211_HW_AP_LINK_PS));
 
 	/* Don't let the same PS state be set twice */
-	in_ps = test_sta_flags(sta_inf, WLAN_STA_PS_STA);
+	in_ps = test_sta_flag(sta_inf, WLAN_STA_PS_STA);
 	if ((start && in_ps) || (!start && !in_ps))
 		return -EINVAL;
 
@@ -1190,15 +1190,15 @@ ieee80211_rx_h_uapsd_and_pspoll(struct i
 	 * the uAPSD case, the station will probably be marked asleep,
 	 * in the PS-Poll case the station must be confused ...
 	 */
-	if (!test_sta_flags(rx->sta, WLAN_STA_PS_STA))
+	if (!test_sta_flag(rx->sta, WLAN_STA_PS_STA))
 		return RX_CONTINUE;
 
 	if (unlikely(ieee80211_is_pspoll(hdr->frame_control))) {
-		if (!test_sta_flags(rx->sta, WLAN_STA_SP)) {
-			if (!test_sta_flags(rx->sta, WLAN_STA_PS_DRIVER))
+		if (!test_sta_flag(rx->sta, WLAN_STA_SP)) {
+			if (!test_sta_flag(rx->sta, WLAN_STA_PS_DRIVER))
 				ieee80211_sta_ps_deliver_poll_response(rx->sta);
 			else
-				set_sta_flags(rx->sta, WLAN_STA_PSPOLL);
+				set_sta_flag(rx->sta, WLAN_STA_PSPOLL);
 		}
 
 		/* Free PS Poll skb here instead of returning RX_DROP that would
@@ -1225,13 +1225,13 @@ ieee80211_rx_h_uapsd_and_pspoll(struct i
 			return RX_CONTINUE;
 
 		/* if we are in a service period, do nothing */
-		if (test_sta_flags(rx->sta, WLAN_STA_SP))
+		if (test_sta_flag(rx->sta, WLAN_STA_SP))
 			return RX_CONTINUE;
 
-		if (!test_sta_flags(rx->sta, WLAN_STA_PS_DRIVER))
+		if (!test_sta_flag(rx->sta, WLAN_STA_PS_DRIVER))
 			ieee80211_sta_ps_deliver_uapsd(rx->sta);
 		else
-			set_sta_flags(rx->sta, WLAN_STA_UAPSD);
+			set_sta_flag(rx->sta, WLAN_STA_UAPSD);
 	}
 
 	return RX_CONTINUE;
@@ -1295,7 +1295,7 @@ ieee80211_rx_h_sta_process(struct ieee80
 	    !(status->rx_flags & IEEE80211_RX_DEFERRED_RELEASE) &&
 	    (rx->sdata->vif.type == NL80211_IFTYPE_AP ||
 	     rx->sdata->vif.type == NL80211_IFTYPE_AP_VLAN)) {
-		if (test_sta_flags(sta, WLAN_STA_PS_STA)) {
+		if (test_sta_flag(sta, WLAN_STA_PS_STA)) {
 			/*
 			 * Ignore doze->wake transitions that are
 			 * indicated by non-data frames, the standard
@@ -1570,7 +1570,7 @@ static int
 ieee80211_802_1x_port_control(struct ieee80211_rx_data *rx)
 {
 	if (unlikely(!rx->sta ||
-	    !test_sta_flags(rx->sta, WLAN_STA_AUTHORIZED)))
+	    !test_sta_flag(rx->sta, WLAN_STA_AUTHORIZED)))
 		return -EACCES;
 
 	return 0;
@@ -1613,7 +1613,7 @@ ieee80211_drop_unencrypted_mgmt(struct i
 	if (status->flag & RX_FLAG_DECRYPTED)
 		return 0;
 
-	if (rx->sta && test_sta_flags(rx->sta, WLAN_STA_MFP)) {
+	if (rx->sta && test_sta_flag(rx->sta, WLAN_STA_MFP)) {
 		if (unlikely(!ieee80211_has_protected(fc) &&
 			     ieee80211_is_unicast_robust_mgmt_frame(rx->skb) &&
 			     rx->key)) {
--- a/net/mac80211/status.c	2011-09-28 13:34:03.000000000 +0200
+++ b/net/mac80211/status.c	2011-09-28 13:53:57.000000000 +0200
@@ -96,7 +96,7 @@ static void ieee80211_handle_filtered_fr
 	 * packet. If the STA went to power save mode, this will happen
 	 * when it wakes up for the next time.
 	 */
-	set_sta_flags(sta, WLAN_STA_CLEAR_PS_FILT);
+	set_sta_flag(sta, WLAN_STA_CLEAR_PS_FILT);
 
 	/*
 	 * This code races in the following way:
@@ -132,7 +132,7 @@ static void ieee80211_handle_filtered_fr
 	 *      changes before calling TX status events if ordering can be
 	 *	unknown.
 	 */
-	if (test_sta_flags(sta, WLAN_STA_PS_STA) &&
+	if (test_sta_flag(sta, WLAN_STA_PS_STA) &&
 	    skb_queue_len(&sta->tx_filtered[ac]) < STA_MAX_TX_BUFFER) {
 		skb_queue_tail(&sta->tx_filtered[ac], skb);
 		sta_info_recalc_tim(sta);
@@ -144,7 +144,7 @@ static void ieee80211_handle_filtered_fr
 		return;
 	}
 
-	if (!test_sta_flags(sta, WLAN_STA_PS_STA) &&
+	if (!test_sta_flag(sta, WLAN_STA_PS_STA) &&
 	    !(info->flags & IEEE80211_TX_INTFL_RETRIED)) {
 		/* Software retry the packet once */
 		info->flags |= IEEE80211_TX_INTFL_RETRIED;
@@ -157,7 +157,7 @@ static void ieee80211_handle_filtered_fr
 		wiphy_debug(local->hw.wiphy,
 			    "dropped TX filtered frame, queue_len=%d PS=%d @%lu\n",
 			    skb_queue_len(&sta->tx_filtered[ac]),
-			    !!test_sta_flags(sta, WLAN_STA_PS_STA), jiffies);
+			    !!test_sta_flag(sta, WLAN_STA_PS_STA), jiffies);
 #endif
 	dev_kfree_skb(skb);
 }
@@ -285,10 +285,10 @@ void ieee80211_tx_status(struct ieee8021
 			continue;
 
 		if (info->flags & IEEE80211_TX_STATUS_EOSP)
-			clear_sta_flags(sta, WLAN_STA_SP);
+			clear_sta_flag(sta, WLAN_STA_SP);
 
 		acked = !!(info->flags & IEEE80211_TX_STAT_ACK);
-		if (!acked && test_sta_flags(sta, WLAN_STA_PS_STA)) {
+		if (!acked && test_sta_flag(sta, WLAN_STA_PS_STA)) {
 			/*
 			 * The STA is in power save mode, so assume
 			 * that this TX packet failed because of that.
--- a/net/mac80211/tx.c	2011-09-28 13:35:51.000000000 +0200
+++ b/net/mac80211/tx.c	2011-09-28 14:03:07.000000000 +0200
@@ -253,7 +253,7 @@ ieee80211_tx_h_check_assoc(struct ieee80
 
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
-	u32 sta_flags;
+	bool assoc = false;
 
 	if (unlikely(info->flags & IEEE80211_TX_CTL_INJECTED))
 		return TX_CONTINUE;
@@ -284,10 +284,11 @@ ieee80211_tx_h_check_assoc(struct ieee80
 	if (tx->flags & IEEE80211_TX_PS_BUFFERED)
 		return TX_CONTINUE;
 
-	sta_flags = tx->sta ? get_sta_flags(tx->sta) : 0;
+	if (tx->sta)
+		assoc = test_sta_flag(tx->sta, WLAN_STA_ASSOC);
 
 	if (likely(tx->flags & IEEE80211_TX_UNICAST)) {
-		if (unlikely(!(sta_flags & WLAN_STA_ASSOC) &&
+		if (unlikely(!assoc &&
 			     tx->sdata->vif.type != NL80211_IFTYPE_ADHOC &&
 			     ieee80211_is_data(hdr->frame_control))) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
@@ -427,7 +428,7 @@ static int ieee80211_use_mfp(__le16 fc,
 	if (!ieee80211_is_mgmt(fc))
 		return 0;
 
-	if (sta == NULL || !test_sta_flags(sta, WLAN_STA_MFP))
+	if (sta == NULL || !test_sta_flag(sta, WLAN_STA_MFP))
 		return 0;
 
 	if (!ieee80211_is_robust_mgmt_frame((struct ieee80211_hdr *)
@@ -444,7 +445,6 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
 	struct ieee80211_local *local = tx->local;
-	u32 staflags;
 
 	if (unlikely(!sta ||
 		     ieee80211_is_probe_resp(hdr->frame_control) ||
@@ -453,9 +453,8 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 		     ieee80211_is_reassoc_resp(hdr->frame_control)))
 		return TX_CONTINUE;
 
-	staflags = get_sta_flags(sta);
-
-	if (unlikely((staflags & (WLAN_STA_PS_STA | WLAN_STA_PS_DRIVER)) &&
+	if (unlikely((test_sta_flag(sta, WLAN_STA_PS_STA) ||
+		      test_sta_flag(sta, WLAN_STA_PS_DRIVER)) &&
 		     !(info->flags & IEEE80211_TX_CTL_POLL_RESPONSE))) {
 		int ac = skb_get_queue_mapping(tx->skb);
 
@@ -496,7 +495,7 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 		return TX_QUEUED;
 	}
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
-	else if (unlikely(staflags & WLAN_STA_PS_STA)) {
+	else if (unlikely(test_sta_flag(sta, WLAN_STA_PS_STA))) {
 		printk(KERN_DEBUG
 		       "%s: STA %pM in PS mode, but polling/in SP -> send frame\n",
 		       tx->sdata->name, sta->sta.addr);
@@ -557,7 +556,7 @@ ieee80211_tx_h_select_key(struct ieee802
 		 !(info->flags & IEEE80211_TX_CTL_INJECTED) &&
 		 (!ieee80211_is_robust_mgmt_frame(hdr) ||
 		  (ieee80211_is_action(hdr->frame_control) &&
-		   tx->sta && test_sta_flags(tx->sta, WLAN_STA_MFP)))) {
+		   tx->sta && test_sta_flag(tx->sta, WLAN_STA_MFP)))) {
 		I802_DEBUG_INC(tx->local->tx_handlers_drop_unencrypted);
 		return TX_DROP;
 	} else
@@ -616,7 +615,7 @@ ieee80211_tx_h_rate_ctrl(struct ieee8021
 	u32 len;
 	bool inval = false, rts = false, short_preamble = false;
 	struct ieee80211_tx_rate_control txrc;
-	u32 sta_flags;
+	bool assoc = false;
 
 	memset(&txrc, 0, sizeof(txrc));
 
@@ -652,17 +651,17 @@ ieee80211_tx_h_rate_ctrl(struct ieee8021
 	 */
 	if (tx->sdata->vif.bss_conf.use_short_preamble &&
 	    (ieee80211_is_data(hdr->frame_control) ||
-	     (tx->sta && test_sta_flags(tx->sta, WLAN_STA_SHORT_PREAMBLE))))
+	     (tx->sta && test_sta_flag(tx->sta, WLAN_STA_SHORT_PREAMBLE))))
 		txrc.short_preamble = short_preamble = true;
 
-	sta_flags = tx->sta ? get_sta_flags(tx->sta) : 0;
+	if (tx->sta)
+		assoc = test_sta_flag(tx->sta, WLAN_STA_ASSOC);
 
 	/*
 	 * Lets not bother rate control if we're associated and cannot
 	 * talk to the sta. This should not happen.
 	 */
-	if (WARN(test_bit(SCAN_SW_SCANNING, &tx->local->scanning) &&
-		 (sta_flags & WLAN_STA_ASSOC) &&
+	if (WARN(test_bit(SCAN_SW_SCANNING, &tx->local->scanning) && assoc &&
 		 !rate_usable_index_exists(sband, &tx->sta->sta),
 		 "%s: Dropped data frame as no usable bitrate found while "
 		 "scanning and associated. Target station: "
@@ -1278,7 +1277,7 @@ ieee80211_tx_prepare(struct ieee80211_su
 
 	if (!tx->sta)
 		info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
-	else if (test_and_clear_sta_flags(tx->sta, WLAN_STA_CLEAR_PS_FILT))
+	else if (test_and_clear_sta_flag(tx->sta, WLAN_STA_CLEAR_PS_FILT))
 		info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
 
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
@@ -1728,7 +1727,7 @@ netdev_tx_t ieee80211_subif_start_xmit(s
 	int encaps_len, skip_header_bytes;
 	int nh_pos, h_pos;
 	struct sta_info *sta = NULL;
-	u32 sta_flags = 0;
+	bool wme_sta = false, authorized = false, tdls_auth = false;
 	struct sk_buff *tmp_skb;
 	bool tdls_direct = false;
 
@@ -1754,7 +1753,8 @@ netdev_tx_t ieee80211_subif_start_xmit(s
 			memcpy(hdr.addr3, skb->data, ETH_ALEN);
 			memcpy(hdr.addr4, skb->data + ETH_ALEN, ETH_ALEN);
 			hdrlen = 30;
-			sta_flags = get_sta_flags(sta);
+			authorized = test_sta_flag(sta, WLAN_STA_AUTHORIZED);
+			wme_sta = test_sta_flag(sta, WLAN_STA_WME);
 		}
 		rcu_read_unlock();
 		if (sta)
@@ -1843,10 +1843,19 @@ netdev_tx_t ieee80211_subif_start_xmit(s
 #endif
 	case NL80211_IFTYPE_STATION:
 		if (sdata->wdev.wiphy->flags & WIPHY_FLAG_SUPPORTS_TDLS) {
+			bool tdls_peer = false;
+
 			rcu_read_lock();
 			sta = sta_info_get(sdata, skb->data);
-			if (sta)
-				sta_flags = get_sta_flags(sta);
+			if (sta) {
+				authorized = test_sta_flag(sta,
+							WLAN_STA_AUTHORIZED);
+				wme_sta = test_sta_flag(sta, WLAN_STA_WME);
+				tdls_peer = test_sta_flag(sta,
+							 WLAN_STA_TDLS_PEER);
+				tdls_auth = test_sta_flag(sta,
+						WLAN_STA_TDLS_PEER_AUTH);
+			}
 			rcu_read_unlock();
 
 			/*
@@ -1854,16 +1863,14 @@ netdev_tx_t ieee80211_subif_start_xmit(s
 			 * directly. Otherwise, allow TDLS setup frames
 			 * to be transmitted indirectly.
 			 */
-			tdls_direct =
-				(sta_flags & WLAN_STA_TDLS_PEER) &&
-				((sta_flags & WLAN_STA_TDLS_PEER_AUTH) ||
+			tdls_direct = tdls_peer && (tdls_auth ||
 				 !(ethertype == ETH_P_TDLS && skb->len > 14 &&
 				   skb->data[14] == WLAN_TDLS_SNAP_RFTYPE));
 		}
 
 		if (tdls_direct) {
 			/* link during setup - throw out frames to peer */
-			if (!(sta_flags & WLAN_STA_TDLS_PEER_AUTH)) {
+			if (!tdls_auth) {
 				ret = NETDEV_TX_OK;
 				goto fail;
 			}
@@ -1912,17 +1919,19 @@ netdev_tx_t ieee80211_subif_start_xmit(s
 	if (!is_multicast_ether_addr(hdr.addr1)) {
 		rcu_read_lock();
 		sta = sta_info_get(sdata, hdr.addr1);
-		if (sta)
-			sta_flags = get_sta_flags(sta);
+		if (sta) {
+			authorized = test_sta_flag(sta, WLAN_STA_AUTHORIZED);
+			wme_sta = test_sta_flag(sta, WLAN_STA_WME);
+		}
 		rcu_read_unlock();
 	}
 
 	/* For mesh, the use of the QoS header is mandatory */
 	if (ieee80211_vif_is_mesh(&sdata->vif))
-		sta_flags |= WLAN_STA_WME;
+		wme_sta = true;
 
 	/* receiver and we are QoS enabled, use a QoS type frame */
-	if ((sta_flags & WLAN_STA_WME) && local->hw.queues >= 4) {
+	if (wme_sta && local->hw.queues >= 4) {
 		fc |= cpu_to_le16(IEEE80211_STYPE_QOS_DATA);
 		hdrlen += 2;
 	}
@@ -1932,8 +1941,7 @@ netdev_tx_t ieee80211_subif_start_xmit(s
 	 * EAPOL frames from the local station.
 	 */
 	if (!ieee80211_vif_is_mesh(&sdata->vif) &&
-		unlikely(!is_multicast_ether_addr(hdr.addr1) &&
-		      !(sta_flags & WLAN_STA_AUTHORIZED) &&
+		unlikely(!is_multicast_ether_addr(hdr.addr1) && !authorized &&
 		      !(cpu_to_be16(ethertype) == sdata->control_port_protocol &&
 		       compare_ether_addr(sdata->vif.addr,
 					  skb->data + ETH_ALEN) == 0))) {
--- a/net/mac80211/util.c	2011-09-28 13:22:26.000000000 +0200
+++ b/net/mac80211/util.c	2011-09-28 13:53:57.000000000 +0200
@@ -1122,7 +1122,7 @@ int ieee80211_reconfig(struct ieee80211_
 
 		list_for_each_entry(sta, &local->sta_list, list) {
 			ieee80211_sta_tear_down_BA_sessions(sta, true);
-			clear_sta_flags(sta, WLAN_STA_BLOCK_BA);
+			clear_sta_flag(sta, WLAN_STA_BLOCK_BA);
 		}
 
 		mutex_unlock(&local->sta_mtx);
--- a/net/mac80211/cfg.c	2011-09-28 13:18:23.000000000 +0200
+++ b/net/mac80211/cfg.c	2011-09-28 13:58:41.000000000 +0200
@@ -668,7 +668,6 @@ static void sta_apply_parameters(struct
 				 struct sta_info *sta,
 				 struct station_parameters *params)
 {
-	unsigned long flags;
 	u32 rates;
 	int i, j;
 	struct ieee80211_supported_band *sband;
@@ -677,49 +676,53 @@ static void sta_apply_parameters(struct
 
 	sband = local->hw.wiphy->bands[local->oper_channel->band];
 
-	spin_lock_irqsave(&sta->flaglock, flags);
 	mask = params->sta_flags_mask;
 	set = params->sta_flags_set;
 
 	if (mask & BIT(NL80211_STA_FLAG_AUTHORIZED)) {
-		sta->flags &= ~WLAN_STA_AUTHORIZED;
 		if (set & BIT(NL80211_STA_FLAG_AUTHORIZED))
-			sta->flags |= WLAN_STA_AUTHORIZED;
+			set_sta_flag(sta, WLAN_STA_AUTHORIZED);
+		else
+			clear_sta_flag(sta, WLAN_STA_AUTHORIZED);
 	}
 
 	if (mask & BIT(NL80211_STA_FLAG_SHORT_PREAMBLE)) {
-		sta->flags &= ~WLAN_STA_SHORT_PREAMBLE;
 		if (set & BIT(NL80211_STA_FLAG_SHORT_PREAMBLE))
-			sta->flags |= WLAN_STA_SHORT_PREAMBLE;
+			set_sta_flag(sta, WLAN_STA_SHORT_PREAMBLE);
+		else
+			clear_sta_flag(sta, WLAN_STA_SHORT_PREAMBLE);
 	}
 
 	if (mask & BIT(NL80211_STA_FLAG_WME)) {
-		sta->flags &= ~WLAN_STA_WME;
-		sta->sta.wme = false;
 		if (set & BIT(NL80211_STA_FLAG_WME)) {
-			sta->flags |= WLAN_STA_WME;
+			set_sta_flag(sta, WLAN_STA_WME);
 			sta->sta.wme = true;
+		} else {
+			clear_sta_flag(sta, WLAN_STA_WME);
+			sta->sta.wme = false;
 		}
 	}
 
 	if (mask & BIT(NL80211_STA_FLAG_MFP)) {
-		sta->flags &= ~WLAN_STA_MFP;
 		if (set & BIT(NL80211_STA_FLAG_MFP))
-			sta->flags |= WLAN_STA_MFP;
+			set_sta_flag(sta, WLAN_STA_MFP);
+		else
+			clear_sta_flag(sta, WLAN_STA_MFP);
 	}
 
 	if (mask & BIT(NL80211_STA_FLAG_AUTHENTICATED)) {
-		sta->flags &= ~WLAN_STA_AUTH;
 		if (set & BIT(NL80211_STA_FLAG_AUTHENTICATED))
-			sta->flags |= WLAN_STA_AUTH;
+			set_sta_flag(sta, WLAN_STA_AUTH);
+		else
+			clear_sta_flag(sta, WLAN_STA_AUTH);
 	}
 
 	if (mask & BIT(NL80211_STA_FLAG_TDLS_PEER)) {
-		sta->flags &= ~WLAN_STA_TDLS_PEER;
 		if (set & BIT(NL80211_STA_FLAG_TDLS_PEER))
-			sta->flags |= WLAN_STA_TDLS_PEER;
+			set_sta_flag(sta, WLAN_STA_TDLS_PEER);
+		else
+			clear_sta_flag(sta, WLAN_STA_TDLS_PEER);
 	}
-	spin_unlock_irqrestore(&sta->flaglock, flags);
 
 	if (params->sta_modify_mask & STATION_PARAM_APPLY_UAPSD) {
 		sta->sta.uapsd_queues = params->uapsd_queues;
@@ -815,12 +818,13 @@ static int ieee80211_add_station(struct
 	if (!sta)
 		return -ENOMEM;
 
-	sta->flags = WLAN_STA_AUTH | WLAN_STA_ASSOC;
+	set_sta_flag(sta, WLAN_STA_AUTH);
+	set_sta_flag(sta, WLAN_STA_ASSOC);
 
 	sta_apply_parameters(local, sta, params);
 
 	/* Only TDLS-supporting stations can add TDLS peers */
-	if ((sta->flags & WLAN_STA_TDLS_PEER) &&
+	if (test_sta_flag(sta, WLAN_STA_TDLS_PEER) &&
 	    !((wiphy->flags & WIPHY_FLAG_SUPPORTS_TDLS) &&
 	      sdata->vif.type == NL80211_IFTYPE_STATION))
 		return -ENOTSUPP;
@@ -880,7 +884,7 @@ static int ieee80211_change_station(stru
 	/* The TDLS bit cannot be toggled after the STA was added */
 	if ((params->sta_flags_mask & BIT(NL80211_STA_FLAG_TDLS_PEER)) &&
 	    !!(params->sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER)) !=
-	    !!test_sta_flags(sta, WLAN_STA_TDLS_PEER)) {
+	    !!test_sta_flag(sta, WLAN_STA_TDLS_PEER)) {
 		rcu_read_unlock();
 		return -EINVAL;
 	}
@@ -2449,7 +2453,7 @@ static int ieee80211_tdls_oper(struct wi
 			return -ENOLINK;
 		}
 
-		set_sta_flags(sta, WLAN_STA_TDLS_PEER_AUTH);
+		set_sta_flag(sta, WLAN_STA_TDLS_PEER_AUTH);
 		rcu_read_unlock();
 		break;
 	case NL80211_TDLS_DISABLE_LINK:
--- a/net/mac80211/wme.c	2011-09-28 11:39:12.000000000 +0200
+++ b/net/mac80211/wme.c	2011-09-28 13:53:57.000000000 +0200
@@ -72,7 +72,7 @@ u16 ieee80211_select_queue(struct ieee80
 	case NL80211_IFTYPE_AP_VLAN:
 		sta = rcu_dereference(sdata->u.vlan.sta);
 		if (sta) {
-			qos = get_sta_flags(sta) & WLAN_STA_WME;
+			qos = test_sta_flag(sta, WLAN_STA_WME);
 			break;
 		}
 	case NL80211_IFTYPE_AP:
@@ -99,7 +99,7 @@ u16 ieee80211_select_queue(struct ieee80
 	if (!sta && ra && !is_multicast_ether_addr(ra)) {
 		sta = sta_info_get(sdata, ra);
 		if (sta)
-			qos = get_sta_flags(sta) & WLAN_STA_WME;
+			qos = test_sta_flag(sta, WLAN_STA_WME);
 	}
 	rcu_read_unlock();
 
--- a/net/mac80211/debugfs_sta.c	2011-09-28 13:22:04.000000000 +0200
+++ b/net/mac80211/debugfs_sta.c	2011-09-28 13:53:57.000000000 +0200
@@ -58,17 +58,17 @@ static ssize_t sta_flags_read(struct fil
 {
 	char buf[100];
 	struct sta_info *sta = file->private_data;
-	u32 staflags = get_sta_flags(sta);
+
 	int res = scnprintf(buf, sizeof(buf), "%s%s%s%s%s%s%s%s%s",
-		staflags & WLAN_STA_AUTH ? "AUTH\n" : "",
-		staflags & WLAN_STA_ASSOC ? "ASSOC\n" : "",
-		staflags & WLAN_STA_PS_STA ? "PS (sta)\n" : "",
-		staflags & WLAN_STA_PS_DRIVER ? "PS (driver)\n" : "",
-		staflags & WLAN_STA_AUTHORIZED ? "AUTHORIZED\n" : "",
-		staflags & WLAN_STA_SHORT_PREAMBLE ? "SHORT PREAMBLE\n" : "",
-		staflags & WLAN_STA_WME ? "WME\n" : "",
-		staflags & WLAN_STA_WDS ? "WDS\n" : "",
-		staflags & WLAN_STA_MFP ? "MFP\n" : "");
+		test_sta_flag(sta, WLAN_STA_AUTH) ? "AUTH\n" : "",
+		test_sta_flag(sta, WLAN_STA_ASSOC) ? "ASSOC\n" : "",
+		test_sta_flag(sta, WLAN_STA_PS_STA) ? "PS (sta)\n" : "",
+		test_sta_flag(sta, WLAN_STA_PS_DRIVER) ? "PS (driver)\n" : "",
+		test_sta_flag(sta, WLAN_STA_AUTHORIZED) ? "AUTHORIZED\n" : "",
+		test_sta_flag(sta, WLAN_STA_SHORT_PREAMBLE) ? "SHORT PREAMBLE\n" : "",
+		test_sta_flag(sta, WLAN_STA_WME) ? "WME\n" : "",
+		test_sta_flag(sta, WLAN_STA_WDS) ? "WDS\n" : "",
+		test_sta_flag(sta, WLAN_STA_MFP) ? "MFP\n" : "");
 	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
 }
 STA_OPS(flags);
--- a/net/mac80211/iface.c	2011-09-28 11:39:11.000000000 +0200
+++ b/net/mac80211/iface.c	2011-09-28 13:53:57.000000000 +0200
@@ -299,8 +299,8 @@ static int ieee80211_do_open(struct net_
 			goto err_del_interface;
 		}
 
-		/* no locking required since STA is not live yet */
-		sta->flags |= WLAN_STA_AUTHORIZED;
+		/* no atomic bitop required since STA is not live yet */
+		set_sta_flag(sta, WLAN_STA_AUTHORIZED);
 
 		res = sta_info_insert(sta);
 		if (res) {


