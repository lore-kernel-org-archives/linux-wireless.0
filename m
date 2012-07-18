Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44269 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530Ab2GRSnX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 14:43:23 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 6/6] mac80211: split TX aggregation stop action
Date: Wed, 18 Jul 2012 20:43:20 +0200
Message-Id: <1342637000-5270-7-git-send-email-johannes@sipsolutions.net> (sfid-20120718_204328_084778_F5E1AFA5)
In-Reply-To: <1342637000-5270-1-git-send-email-johannes@sipsolutions.net>
References: <1342637000-5270-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When TX aggregation is stopped, there are a few
different cases:
 - connection with the peer was dropped
 - session stop was requested locally
 - session stop was requested by the peer
 - connection was dropped while a session is stopping

The behaviour in these cases should be different, if
the connection is dropped then the driver should drop
all frames, otherwise the frames may continue to be
transmitted, aggregated in the case of a locally
requested session stop or unaggregated in the case of
the peer requesting session stop.

Split these different cases so that the driver can
act accordingly; however, treat local and remote stop
the same way and ask the driver to not send frames as
aggregated packets any more.

In the case of connection drop, the stop callback the
driver is otherwise supposed to call is no longer
required.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |    4 ++-
 drivers/net/wireless/ath/ath9k/main.c              |    4 ++-
 drivers/net/wireless/ath/carl9170/main.c           |    4 ++-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    4 ++-
 drivers/net/wireless/iwlegacy/4965-mac.c           |    4 ++-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c        |    4 ++-
 drivers/net/wireless/mac80211_hwsim.c              |    4 ++-
 drivers/net/wireless/mwl8k.c                       |    4 ++-
 drivers/net/wireless/rt2x00/rt2800lib.c            |    4 ++-
 drivers/net/wireless/rtlwifi/core.c                |    4 ++-
 drivers/net/wireless/ti/wlcore/main.c              |    4 ++-
 include/net/mac80211.h                             |   22 +++++++++---
 net/mac80211/agg-tx.c                              |   38 +++++++++++++++++---
 13 files changed, 83 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index fc8cd828..ca73d24 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1619,7 +1619,9 @@ static int ath9k_htc_ampdu_action(struct ieee80211_hw *hw,
 		if (!ret)
 			ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		break;
-	case IEEE80211_AMPDU_TX_STOP:
+	case IEEE80211_AMPDU_TX_STOP_CONT:
+	case IEEE80211_AMPDU_TX_STOP_FLUSH:
+	case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
 		ath9k_htc_tx_aggr_oper(priv, vif, sta, action, tid);
 		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		break;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index e4e73f0..90538e8 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1690,7 +1690,9 @@ static int ath9k_ampdu_action(struct ieee80211_hw *hw,
 			ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		ath9k_ps_restore(sc);
 		break;
-	case IEEE80211_AMPDU_TX_STOP:
+	case IEEE80211_AMPDU_TX_STOP_CONT:
+	case IEEE80211_AMPDU_TX_STOP_FLUSH:
+	case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
 		ath9k_ps_wakeup(sc);
 		ath_tx_aggr_stop(sc, sta, tid);
 		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index 8d2523b..ac27504 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1389,7 +1389,9 @@ static int carl9170_op_ampdu_action(struct ieee80211_hw *hw,
 		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		break;
 
-	case IEEE80211_AMPDU_TX_STOP:
+	case IEEE80211_AMPDU_TX_STOP_CONT:
+	case IEEE80211_AMPDU_TX_STOP_FLUSH:
+	case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
 		rcu_read_lock();
 		tid_info = rcu_dereference(sta_info->agg[tid]);
 		if (tid_info) {
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 2d5a404..f5ae62e 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -651,7 +651,9 @@ brcms_ops_ampdu_action(struct ieee80211_hw *hw,
 		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		break;
 
-	case IEEE80211_AMPDU_TX_STOP:
+	case IEEE80211_AMPDU_TX_STOP_CONT:
+	case IEEE80211_AMPDU_TX_STOP_FLUSH:
+	case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
 		spin_lock_bh(&wl->lock);
 		brcms_c_ampdu_flush(wl->wlc, sta, tid);
 		spin_unlock_bh(&wl->lock);
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index d24eaf8..9790364 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -5964,7 +5964,9 @@ il4965_mac_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		D_HT("start Tx\n");
 		ret = il4965_tx_agg_start(il, vif, sta, tid, ssn);
 		break;
-	case IEEE80211_AMPDU_TX_STOP:
+	case IEEE80211_AMPDU_TX_STOP_CONT:
+	case IEEE80211_AMPDU_TX_STOP_FLUSH:
+	case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
 		D_HT("stop Tx\n");
 		ret = il4965_tx_agg_stop(il, vif, sta, tid);
 		if (test_bit(S_EXIT_PENDING, &il->status))
diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index b83ca35..56f42e8 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -674,7 +674,9 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 		IWL_DEBUG_HT(priv, "start Tx\n");
 		ret = iwlagn_tx_agg_start(priv, vif, sta, tid, ssn);
 		break;
-	case IEEE80211_AMPDU_TX_STOP:
+	case IEEE80211_AMPDU_TX_STOP_CONT:
+	case IEEE80211_AMPDU_TX_STOP_FLUSH:
+	case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
 		IWL_DEBUG_HT(priv, "stop Tx\n");
 		ret = iwlagn_tx_agg_stop(priv, vif, sta, tid);
 		if ((ret == 0) && (priv->agg_tids_count > 0)) {
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index d03ee5b..97f87f0 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1149,7 +1149,9 @@ static int mac80211_hwsim_ampdu_action(struct ieee80211_hw *hw,
 	case IEEE80211_AMPDU_TX_START:
 		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		break;
-	case IEEE80211_AMPDU_TX_STOP:
+	case IEEE80211_AMPDU_TX_STOP_CONT:
+	case IEEE80211_AMPDU_TX_STOP_FLUSH:
+	case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
 		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		break;
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index cf7bdc6..8b10854 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -5146,7 +5146,9 @@ mwl8k_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		}
 		ieee80211_start_tx_ba_cb_irqsafe(vif, addr, tid);
 		break;
-	case IEEE80211_AMPDU_TX_STOP:
+	case IEEE80211_AMPDU_TX_STOP_CONT:
+	case IEEE80211_AMPDU_TX_STOP_FLUSH:
+	case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
 		if (stream) {
 			if (stream->state == AMPDU_STREAM_ACTIVE) {
 				spin_unlock(&priv->stream_lock);
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 068276e..a2f2305 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -5110,7 +5110,9 @@ int rt2800_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	case IEEE80211_AMPDU_TX_START:
 		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		break;
-	case IEEE80211_AMPDU_TX_STOP:
+	case IEEE80211_AMPDU_TX_STOP_CONT:
+	case IEEE80211_AMPDU_TX_STOP_FLUSH:
+	case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
 		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		break;
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
diff --git a/drivers/net/wireless/rtlwifi/core.c b/drivers/net/wireless/rtlwifi/core.c
index 278e9f9..9656c1c 100644
--- a/drivers/net/wireless/rtlwifi/core.c
+++ b/drivers/net/wireless/rtlwifi/core.c
@@ -877,7 +877,9 @@ static int rtl_op_ampdu_action(struct ieee80211_hw *hw,
 			 "IEEE80211_AMPDU_TX_START: TID:%d\n", tid);
 		return rtl_tx_agg_start(hw, sta, tid, ssn);
 		break;
-	case IEEE80211_AMPDU_TX_STOP:
+	case IEEE80211_AMPDU_TX_STOP_CONT:
+	case IEEE80211_AMPDU_TX_STOP_FLUSH:
+	case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
 		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_TRACE,
 			 "IEEE80211_AMPDU_TX_STOP: TID:%d\n", tid);
 		return rtl_tx_agg_stop(hw, sta, tid);
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 0cc9a02..27e1932 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -4534,7 +4534,9 @@ static int wl1271_op_ampdu_action(struct ieee80211_hw *hw,
 	 * Falling break here on purpose for all TX APDU commands.
 	 */
 	case IEEE80211_AMPDU_TX_START:
-	case IEEE80211_AMPDU_TX_STOP:
+	case IEEE80211_AMPDU_TX_STOP_CONT:
+	case IEEE80211_AMPDU_TX_STOP_FLUSH:
+	case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
 		ret = -EINVAL;
 		break;
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index c609b9d..0fe82e3 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1883,17 +1883,29 @@ enum ieee80211_filter_flags {
  * calling ieee80211_start_tx_ba_cb_irqsafe, because the peer
  * might receive the addBA frame and send a delBA right away!
  *
- * @IEEE80211_AMPDU_RX_START: start Rx aggregation
- * @IEEE80211_AMPDU_RX_STOP: stop Rx aggregation
- * @IEEE80211_AMPDU_TX_START: start Tx aggregation
- * @IEEE80211_AMPDU_TX_STOP: stop Tx aggregation
+ * @IEEE80211_AMPDU_RX_START: start RX aggregation
+ * @IEEE80211_AMPDU_RX_STOP: stop RX aggregation
+ * @IEEE80211_AMPDU_TX_START: start TX aggregation
  * @IEEE80211_AMPDU_TX_OPERATIONAL: TX aggregation has become operational
+ * @IEEE80211_AMPDU_TX_STOP_CONT: stop TX aggregation but continue transmitting
+ *	queued packets, now unaggregated. After all packets are transmitted the
+ *	driver has to call ieee80211_stop_tx_ba_cb_irqsafe().
+ * @IEEE80211_AMPDU_TX_STOP_FLUSH: stop TX aggregation and flush all packets,
+ *	called when the station is removed. There's no need or reason to call
+ *	ieee80211_stop_tx_ba_cb_irqsafe() in this case as mac80211 assumes the
+ *	session is gone and removes the station.
+ * @IEEE80211_AMPDU_TX_STOP_FLUSH_CONT: called when TX aggregation is stopped
+ *	but the driver hasn't called ieee80211_stop_tx_ba_cb_irqsafe() yet and
+ *	now the connection is dropped and the station will be removed. Drivers
+ *	should clean up and drop remaining packets when this is called.
  */
 enum ieee80211_ampdu_mlme_action {
 	IEEE80211_AMPDU_RX_START,
 	IEEE80211_AMPDU_RX_STOP,
 	IEEE80211_AMPDU_TX_START,
-	IEEE80211_AMPDU_TX_STOP,
+	IEEE80211_AMPDU_TX_STOP_CONT,
+	IEEE80211_AMPDU_TX_STOP_FLUSH,
+	IEEE80211_AMPDU_TX_STOP_FLUSH_CONT,
 	IEEE80211_AMPDU_TX_OPERATIONAL,
 };
 
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 5359b5c..74ad47d 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -257,10 +257,25 @@ int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 {
 	struct ieee80211_local *local = sta->local;
 	struct tid_ampdu_tx *tid_tx;
+	enum ieee80211_ampdu_mlme_action action;
 	int ret;
 
 	lockdep_assert_held(&sta->ampdu_mlme.mtx);
 
+	switch (reason) {
+	case AGG_STOP_DECLINED:
+	case AGG_STOP_LOCAL_REQUEST:
+	case AGG_STOP_PEER_REQUEST:
+		action = IEEE80211_AMPDU_TX_STOP_CONT;
+		break;
+	case AGG_STOP_DESTROY_STA:
+		action = IEEE80211_AMPDU_TX_STOP_FLUSH;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return -EINVAL;
+	}
+
 	spin_lock_bh(&sta->lock);
 
 	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
@@ -269,10 +284,19 @@ int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 		return -ENOENT;
 	}
 
-	/* if we're already stopping ignore any new requests to stop */
+	/*
+	 * if we're already stopping ignore any new requests to stop
+	 * unless we're destroying it in which case notify the driver
+	 */
 	if (test_bit(HT_AGG_STATE_STOPPING, &tid_tx->state)) {
 		spin_unlock_bh(&sta->lock);
-		return -EALREADY;
+		if (reason != AGG_STOP_DESTROY_STA)
+			return -EALREADY;
+		ret = drv_ampdu_action(local, sta->sdata,
+				       IEEE80211_AMPDU_TX_STOP_FLUSH_CONT,
+				       &sta->sta, tid, NULL, 0);
+		WARN_ON_ONCE(ret);
+		goto remove_tid_tx;
 	}
 
 	if (test_bit(HT_AGG_STATE_WANT_START, &tid_tx->state)) {
@@ -319,8 +343,7 @@ int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 					WLAN_BACK_INITIATOR;
 	tid_tx->tx_stop = reason == AGG_STOP_LOCAL_REQUEST;
 
-	ret = drv_ampdu_action(local, sta->sdata,
-			       IEEE80211_AMPDU_TX_STOP,
+	ret = drv_ampdu_action(local, sta->sdata, action,
 			       &sta->sta, tid, NULL, 0);
 
 	/* HW shall not deny going back to legacy */
@@ -331,7 +354,12 @@ int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 		 */
 	}
 
-	return ret;
+	if (reason == AGG_STOP_DESTROY_STA) {
+ remove_tid_tx:
+		ieee80211_remove_tid_tx(sta, tid);
+ 	}
+
+	return 0;
 }
 
 /*
-- 
1.7.10.4

