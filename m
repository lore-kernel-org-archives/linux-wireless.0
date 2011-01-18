Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36940 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab1ARMvI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 07:51:08 -0500
Subject: [PATCH] mac80211: track receiver's aggregation reorder buffer size
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Jan 2011 13:51:05 +0100
Message-ID: <1295355065.3563.19.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The aggregation code currently doesn't implement the
buffer size negotiation. It will always request a max
buffer size (which is fine, if a little pointless, as
the mac80211 code doesn't know and might just use 0
instead), but if the peer requests a smaller size it
isn't possible to honour this request.

In order to fix this, look at the buffer size in the
addBA response frame, keep track of it and pass it to
the driver in the ampdu_action callback when called
with the IEEE80211_AMPDU_TX_OPERATIONAL action. That
way the driver can limit the number of subframes in
aggregates appropriately.

Note that this doesn't fix any drivers apart from the
addition of the new argument -- they all need to be
updated separately to use this variable!

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ar9170/main.c        |    3 ++-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    2 +-
 drivers/net/wireless/ath/ath9k/main.c         |    2 +-
 drivers/net/wireless/ath/carl9170/main.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c        |    3 ++-
 drivers/net/wireless/iwlwifi/iwl-agn.h        |    3 ++-
 drivers/net/wireless/mac80211_hwsim.c         |    3 ++-
 drivers/net/wireless/mwl8k.c                  |    3 ++-
 drivers/net/wireless/rt2x00/rt2800lib.c       |    3 ++-
 drivers/net/wireless/rt2x00/rt2800lib.h       |    3 ++-
 drivers/net/wireless/rtlwifi/core.c           |    3 ++-
 include/net/mac80211.h                        |    7 ++++++-
 net/mac80211/agg-rx.c                         |    4 ++--
 net/mac80211/agg-tx.c                         |   20 +++++++++++++++++---
 net/mac80211/driver-ops.h                     |    6 +++---
 net/mac80211/driver-trace.h                   |   11 +++++++----
 net/mac80211/sta_info.h                       |    2 ++
 17 files changed, 56 insertions(+), 24 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2011-01-18 13:46:47.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2011-01-18 13:50:21.000000000 +0100
@@ -1731,6 +1731,10 @@ enum ieee80211_ampdu_mlme_action {
  * 	ieee80211_ampdu_mlme_action. Starting sequence number (@ssn)
  * 	is the first frame we expect to perform the action on. Notice
  * 	that TX/RX_STOP can pass NULL for this parameter.
+ *	The @buf_size parameter is only valid when the action is set to
+ *	%IEEE80211_AMPDU_TX_OPERATIONAL and indicates the peer's reorder
+ *	buffer size (number of subframes) for this session -- aggregates
+ *	containing more subframes than this may not be transmitted to the peer.
  *	Returns a negative error code on failure.
  *	The callback can sleep.
  *
@@ -1833,7 +1837,8 @@ struct ieee80211_ops {
 	int (*ampdu_action)(struct ieee80211_hw *hw,
 			    struct ieee80211_vif *vif,
 			    enum ieee80211_ampdu_mlme_action action,
-			    struct ieee80211_sta *sta, u16 tid, u16 *ssn);
+			    struct ieee80211_sta *sta, u16 tid, u16 *ssn,
+			    u8 buf_size);
 	int (*get_survey)(struct ieee80211_hw *hw, int idx,
 		struct survey_info *survey);
 	void (*rfkill_poll)(struct ieee80211_hw *hw);
--- wireless-testing.orig/net/mac80211/agg-tx.c	2011-01-18 13:44:44.000000000 +0100
+++ wireless-testing/net/mac80211/agg-tx.c	2011-01-18 13:50:21.000000000 +0100
@@ -190,7 +190,7 @@ int ___ieee80211_stop_tx_ba_session(stru
 
 	ret = drv_ampdu_action(local, sta->sdata,
 			       IEEE80211_AMPDU_TX_STOP,
-			       &sta->sta, tid, NULL);
+			       &sta->sta, tid, NULL, 0);
 
 	/* HW shall not deny going back to legacy */
 	if (WARN_ON(ret)) {
@@ -311,7 +311,7 @@ void ieee80211_tx_ba_session_handle_star
 	start_seq_num = sta->tid_seq[tid] >> 4;
 
 	ret = drv_ampdu_action(local, sdata, IEEE80211_AMPDU_TX_START,
-			       &sta->sta, tid, &start_seq_num);
+			       &sta->sta, tid, &start_seq_num, 0);
 	if (ret) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "BA request denied - HW unavailable for"
@@ -487,7 +487,8 @@ static void ieee80211_agg_tx_operational
 
 	drv_ampdu_action(local, sta->sdata,
 			 IEEE80211_AMPDU_TX_OPERATIONAL,
-			 &sta->sta, tid, NULL);
+			 &sta->sta, tid, NULL,
+			 sta->ampdu_mlme.tid_tx[tid]->buf_size);
 
 	/*
 	 * synchronize with TX path, while splicing the TX path
@@ -742,9 +743,11 @@ void ieee80211_process_addba_resp(struct
 {
 	struct tid_ampdu_tx *tid_tx;
 	u16 capab, tid;
+	u8 buf_size;
 
 	capab = le16_to_cpu(mgmt->u.action.u.addba_resp.capab);
 	tid = (capab & IEEE80211_ADDBA_PARAM_TID_MASK) >> 2;
+	buf_size = (capab & IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK) >> 6;
 
 	mutex_lock(&sta->ampdu_mlme.mtx);
 
@@ -767,12 +770,23 @@ void ieee80211_process_addba_resp(struct
 
 	if (le16_to_cpu(mgmt->u.action.u.addba_resp.status)
 			== WLAN_STATUS_SUCCESS) {
+		/*
+		 * IEEE 802.11-2007 7.3.1.14:
+		 * In an ADDBA Response frame, when the Status Code field
+		 * is set to 0, the Buffer Size subfield is set to a value
+		 * of at least 1.
+		 */
+		if (!buf_size)
+			goto out;
+
 		if (test_and_set_bit(HT_AGG_STATE_RESPONSE_RECEIVED,
 				     &tid_tx->state)) {
 			/* ignore duplicate response */
 			goto out;
 		}
 
+		tid_tx->buf_size = buf_size;
+
 		if (test_bit(HT_AGG_STATE_DRV_READY, &tid_tx->state))
 			ieee80211_agg_tx_operational(local, sta, tid);
 
--- wireless-testing.orig/net/mac80211/sta_info.h	2011-01-18 13:44:44.000000000 +0100
+++ wireless-testing/net/mac80211/sta_info.h	2011-01-18 13:48:49.000000000 +0100
@@ -82,6 +82,7 @@ enum ieee80211_sta_info_flags {
  * @state: session state (see above)
  * @stop_initiator: initiator of a session stop
  * @tx_stop: TX DelBA frame when stopping
+ * @buf_size: reorder buffer size at receiver
  *
  * This structure's lifetime is managed by RCU, assignments to
  * the array holding it must hold the aggregation mutex.
@@ -101,6 +102,7 @@ struct tid_ampdu_tx {
 	u8 dialog_token;
 	u8 stop_initiator;
 	bool tx_stop;
+	u8 buf_size;
 };
 
 /**
--- wireless-testing.orig/net/mac80211/agg-rx.c	2011-01-18 13:46:47.000000000 +0100
+++ wireless-testing/net/mac80211/agg-rx.c	2011-01-18 13:48:49.000000000 +0100
@@ -76,7 +76,7 @@ void ___ieee80211_stop_rx_ba_session(str
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 
 	if (drv_ampdu_action(local, sta->sdata, IEEE80211_AMPDU_RX_STOP,
-			     &sta->sta, tid, NULL))
+			     &sta->sta, tid, NULL, 0))
 		printk(KERN_DEBUG "HW problem - can not stop rx "
 				"aggregation for tid %d\n", tid);
 
@@ -290,7 +290,7 @@ void ieee80211_process_addba_request(str
 	}
 
 	ret = drv_ampdu_action(local, sta->sdata, IEEE80211_AMPDU_RX_START,
-			       &sta->sta, tid, &start_seq_num);
+			       &sta->sta, tid, &start_seq_num, 0);
 #ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "Rx A-MPDU request on tid %d result %d\n", tid, ret);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
--- wireless-testing.orig/net/mac80211/driver-ops.h	2011-01-18 13:44:44.000000000 +0100
+++ wireless-testing/net/mac80211/driver-ops.h	2011-01-18 13:48:49.000000000 +0100
@@ -382,17 +382,17 @@ static inline int drv_ampdu_action(struc
 				   struct ieee80211_sub_if_data *sdata,
 				   enum ieee80211_ampdu_mlme_action action,
 				   struct ieee80211_sta *sta, u16 tid,
-				   u16 *ssn)
+				   u16 *ssn, u8 buf_size)
 {
 	int ret = -EOPNOTSUPP;
 
 	might_sleep();
 
-	trace_drv_ampdu_action(local, sdata, action, sta, tid, ssn);
+	trace_drv_ampdu_action(local, sdata, action, sta, tid, ssn, buf_size);
 
 	if (local->ops->ampdu_action)
 		ret = local->ops->ampdu_action(&local->hw, &sdata->vif, action,
-					       sta, tid, ssn);
+					       sta, tid, ssn, buf_size);
 
 	trace_drv_return_int(local, ret);
 
--- wireless-testing.orig/net/mac80211/driver-trace.h	2011-01-18 13:44:44.000000000 +0100
+++ wireless-testing/net/mac80211/driver-trace.h	2011-01-18 13:48:49.000000000 +0100
@@ -784,9 +784,9 @@ TRACE_EVENT(drv_ampdu_action,
 		 struct ieee80211_sub_if_data *sdata,
 		 enum ieee80211_ampdu_mlme_action action,
 		 struct ieee80211_sta *sta, u16 tid,
-		 u16 *ssn),
+		 u16 *ssn, u8 buf_size),
 
-	TP_ARGS(local, sdata, action, sta, tid, ssn),
+	TP_ARGS(local, sdata, action, sta, tid, ssn, buf_size),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
@@ -794,6 +794,7 @@ TRACE_EVENT(drv_ampdu_action,
 		__field(u32, action)
 		__field(u16, tid)
 		__field(u16, ssn)
+		__field(u8, buf_size)
 		VIF_ENTRY
 	),
 
@@ -804,11 +805,13 @@ TRACE_EVENT(drv_ampdu_action,
 		__entry->action = action;
 		__entry->tid = tid;
 		__entry->ssn = ssn ? *ssn : 0;
+		__entry->buf_size = buf_size;
 	),
 
 	TP_printk(
-		LOCAL_PR_FMT VIF_PR_FMT STA_PR_FMT " action:%d tid:%d",
-		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG, __entry->action, __entry->tid
+		LOCAL_PR_FMT VIF_PR_FMT STA_PR_FMT " action:%d tid:%d buf:%d",
+		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG, __entry->action,
+		__entry->tid, __entry->buf_size
 	)
 );
 
--- wireless-testing.orig/drivers/net/wireless/ath/ar9170/main.c	2011-01-18 13:44:45.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath/ar9170/main.c	2011-01-18 13:48:49.000000000 +0100
@@ -1945,7 +1945,8 @@ static int ar9170_conf_tx(struct ieee802
 static int ar9170_ampdu_action(struct ieee80211_hw *hw,
 			       struct ieee80211_vif *vif,
 			       enum ieee80211_ampdu_mlme_action action,
-			       struct ieee80211_sta *sta, u16 tid, u16 *ssn)
+			       struct ieee80211_sta *sta, u16 tid, u16 *ssn,
+			       u8 buf_size)
 {
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/htc_drv_main.c	2011-01-18 13:44:45.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath/ath9k/htc_drv_main.c	2011-01-18 13:48:49.000000000 +0100
@@ -1548,7 +1548,7 @@ static int ath9k_htc_ampdu_action(struct
 				  struct ieee80211_vif *vif,
 				  enum ieee80211_ampdu_mlme_action action,
 				  struct ieee80211_sta *sta,
-				  u16 tid, u16 *ssn)
+				  u16 tid, u16 *ssn, u8 buf_size)
 {
 	struct ath9k_htc_priv *priv = hw->priv;
 	struct ath9k_htc_sta *ista;
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/main.c	2011-01-18 13:44:45.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath/ath9k/main.c	2011-01-18 13:48:49.000000000 +0100
@@ -2029,7 +2029,7 @@ static int ath9k_ampdu_action(struct iee
 			      struct ieee80211_vif *vif,
 			      enum ieee80211_ampdu_mlme_action action,
 			      struct ieee80211_sta *sta,
-			      u16 tid, u16 *ssn)
+			      u16 tid, u16 *ssn, u8 buf_size)
 {
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
--- wireless-testing.orig/drivers/net/wireless/ath/carl9170/main.c	2011-01-18 13:44:45.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath/carl9170/main.c	2011-01-18 13:48:49.000000000 +0100
@@ -1279,7 +1279,7 @@ static int carl9170_op_ampdu_action(stru
 				    struct ieee80211_vif *vif,
 				    enum ieee80211_ampdu_mlme_action action,
 				    struct ieee80211_sta *sta,
-				    u16 tid, u16 *ssn)
+				    u16 tid, u16 *ssn, u8 buf_size)
 {
 	struct ar9170 *ar = hw->priv;
 	struct carl9170_sta_info *sta_info = (void *) sta->drv_priv;
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-agn.c	2011-01-18 13:46:37.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-agn.c	2011-01-18 13:50:22.000000000 +0100
@@ -3425,7 +3425,8 @@ int iwlagn_mac_set_key(struct ieee80211_
 int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 			    struct ieee80211_vif *vif,
 			    enum ieee80211_ampdu_mlme_action action,
-			    struct ieee80211_sta *sta, u16 tid, u16 *ssn)
+			    struct ieee80211_sta *sta, u16 tid, u16 *ssn,
+			    u8 buf_size)
 {
 	struct iwl_priv *priv = hw->priv;
 	int ret = -EINVAL;
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-agn.h	2011-01-18 13:44:45.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-agn.h	2011-01-18 13:48:49.000000000 +0100
@@ -374,7 +374,8 @@ void iwlagn_mac_update_tkip_key(struct i
 int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 			    struct ieee80211_vif *vif,
 			    enum ieee80211_ampdu_mlme_action action,
-			    struct ieee80211_sta *sta, u16 tid, u16 *ssn);
+			    struct ieee80211_sta *sta, u16 tid, u16 *ssn,
+			    u8 buf_size);
 int iwlagn_mac_sta_add(struct ieee80211_hw *hw,
 		       struct ieee80211_vif *vif,
 		       struct ieee80211_sta *sta);
--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2011-01-18 13:44:45.000000000 +0100
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2011-01-18 13:48:49.000000000 +0100
@@ -943,7 +943,8 @@ static int mac80211_hwsim_testmode_cmd(s
 static int mac80211_hwsim_ampdu_action(struct ieee80211_hw *hw,
 				       struct ieee80211_vif *vif,
 				       enum ieee80211_ampdu_mlme_action action,
-				       struct ieee80211_sta *sta, u16 tid, u16 *ssn)
+				       struct ieee80211_sta *sta, u16 tid, u16 *ssn,
+				       u8 buf_size)
 {
 	switch (action) {
 	case IEEE80211_AMPDU_TX_START:
--- wireless-testing.orig/drivers/net/wireless/mwl8k.c	2011-01-18 13:44:45.000000000 +0100
+++ wireless-testing/drivers/net/wireless/mwl8k.c	2011-01-18 13:48:49.000000000 +0100
@@ -4356,7 +4356,8 @@ static int mwl8k_get_survey(struct ieee8
 static int
 mwl8k_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		   enum ieee80211_ampdu_mlme_action action,
-		   struct ieee80211_sta *sta, u16 tid, u16 *ssn)
+		   struct ieee80211_sta *sta, u16 tid, u16 *ssn,
+		   u8 buf_size)
 {
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
--- wireless-testing.orig/drivers/net/wireless/rt2x00/rt2800lib.c	2011-01-18 13:44:45.000000000 +0100
+++ wireless-testing/drivers/net/wireless/rt2x00/rt2800lib.c	2011-01-18 13:48:49.000000000 +0100
@@ -3533,7 +3533,8 @@ EXPORT_SYMBOL_GPL(rt2800_get_tsf);
 
 int rt2800_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			enum ieee80211_ampdu_mlme_action action,
-			struct ieee80211_sta *sta, u16 tid, u16 *ssn)
+			struct ieee80211_sta *sta, u16 tid, u16 *ssn,
+			u8 buf_size)
 {
 	int ret = 0;
 
--- wireless-testing.orig/drivers/net/wireless/rt2x00/rt2800lib.h	2011-01-18 13:44:45.000000000 +0100
+++ wireless-testing/drivers/net/wireless/rt2x00/rt2800lib.h	2011-01-18 13:48:49.000000000 +0100
@@ -198,7 +198,8 @@ int rt2800_conf_tx(struct ieee80211_hw *
 u64 rt2800_get_tsf(struct ieee80211_hw *hw);
 int rt2800_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			enum ieee80211_ampdu_mlme_action action,
-			struct ieee80211_sta *sta, u16 tid, u16 *ssn);
+			struct ieee80211_sta *sta, u16 tid, u16 *ssn,
+			u8 buf_size);
 int rt2800_get_survey(struct ieee80211_hw *hw, int idx,
 		      struct survey_info *survey);
 
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/core.c	2011-01-18 13:44:45.000000000 +0100
+++ wireless-testing/drivers/net/wireless/rtlwifi/core.c	2011-01-18 13:48:49.000000000 +0100
@@ -748,7 +748,8 @@ static void rtl_op_sta_notify(struct iee
 static int rtl_op_ampdu_action(struct ieee80211_hw *hw,
 			       struct ieee80211_vif *vif,
 			       enum ieee80211_ampdu_mlme_action action,
-			       struct ieee80211_sta *sta, u16 tid, u16 * ssn)
+			       struct ieee80211_sta *sta, u16 tid, u16 *ssn,
+			       u8 buf_size)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 


