Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62295 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbcFNRpO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2016 13:45:14 -0400
From: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <ath10k@lists.infradead.org>, <johannes@sipsolutions.net>,
	<arnagara@codeaurora.org>,
	Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
Subject: [PATCH 2/2] mac80211: store tx power value from user to station
Date: Tue, 14 Jun 2016 23:14:37 +0530
Message-ID: <1465926277-6509-1-git-send-email-arnagara@qti.qualcomm.com> (sfid-20160614_194520_389429_820BEEF5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch introduce a new driver callback drv_sta_set_txpwr. This API will
copy the transmit power value passed from user space and call the driver
callback to set the tx power for the station.

Signed-off-by: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
---
 include/net/mac80211.h    |  6 ++++++
 net/mac80211/cfg.c        |  7 +++++++
 net/mac80211/driver-ops.c | 21 +++++++++++++++++++++
 net/mac80211/driver-ops.h |  5 +++++
 net/mac80211/trace.h      | 27 +++++++++++++++++++++++++++
 5 files changed, 66 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index be30b05..70c02d7 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1755,6 +1755,8 @@ struct ieee80211_sta_rates {
  *	This is defined by the spec (IEEE 802.11-2012 section 8.3.2.2 NOTE 2).
  * @support_p2p_ps: indicates whether the STA supports P2P PS mechanism or not.
  * @max_rc_amsdu_len: Maximum A-MSDU size in bytes recommended by rate control.
+ * @txpwr: indicates the tx power, in dBm, to be used when sending data frames
+ *	to the STA. Value of 0 means, automatic (default) tx power.
  * @txq: per-TID data TX queues (if driver uses the TXQ abstraction)
  */
 struct ieee80211_sta {
@@ -1777,6 +1779,7 @@ struct ieee80211_sta {
 	u16 max_amsdu_len;
 	bool support_p2p_ps;
 	u16 max_rc_amsdu_len;
+	u8 txpwr;
 
 	struct ieee80211_txq *txq[IEEE80211_NUM_TIDS];
 
@@ -3484,6 +3487,9 @@ struct ieee80211_ops {
 #endif
 	void (*sta_notify)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			enum sta_notify_cmd, struct ieee80211_sta *sta);
+	int (*sta_set_txpwr)(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif,
+			     struct ieee80211_sta *sta);
 	int (*sta_state)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			 struct ieee80211_sta *sta,
 			 enum ieee80211_sta_state old_state,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 0c12e40..d439854 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1181,6 +1181,13 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 	if (params->listen_interval >= 0)
 		sta->listen_interval = params->listen_interval;
 
+	if (params->txpwr >= 0) {
+		sta->sta.txpwr = MBM_TO_DBM(params->txpwr);
+		ret = drv_sta_set_txpwr(local, sdata, sta);
+		if (ret)
+			return ret;
+	}
+
 	if (params->supported_rates) {
 		ieee80211_parse_bitrates(&sdata->vif.bss_conf.chandef,
 					 sband, params->supported_rates,
diff --git a/net/mac80211/driver-ops.c b/net/mac80211/driver-ops.c
index c258f10..638480c 100644
--- a/net/mac80211/driver-ops.c
+++ b/net/mac80211/driver-ops.c
@@ -138,6 +138,27 @@ int drv_sta_state(struct ieee80211_local *local,
 	return ret;
 }
 
+__must_check
+int drv_sta_set_txpwr(struct ieee80211_local *local,
+		      struct ieee80211_sub_if_data *sdata,
+		      struct sta_info *sta)
+{
+	int ret = -EOPNOTSUPP;
+
+	might_sleep();
+
+	sdata = get_bss_sdata(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return -EIO;
+
+	trace_drv_sta_set_txpwr(local, sdata, &sta->sta);
+	if (local->ops->sta_set_txpwr)
+		ret = local->ops->sta_set_txpwr(&local->hw, &sdata->vif,
+						&sta->sta);
+	trace_drv_return_int(local, ret);
+	return ret;
+}
+
 void drv_sta_rc_update(struct ieee80211_local *local,
 		       struct ieee80211_sub_if_data *sdata,
 		       struct ieee80211_sta *sta, u32 changed)
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 184473c..59b2f28 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -539,6 +539,11 @@ int drv_sta_state(struct ieee80211_local *local,
 		  enum ieee80211_sta_state old_state,
 		  enum ieee80211_sta_state new_state);
 
+__must_check
+int drv_sta_set_txpwr(struct ieee80211_local *local,
+		      struct ieee80211_sub_if_data *sdata,
+		      struct sta_info *sta);
+
 void drv_sta_rc_update(struct ieee80211_local *local,
 		       struct ieee80211_sub_if_data *sdata,
 		       struct ieee80211_sta *sta, u32 changed);
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 77e4c53..78c37e9 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -823,6 +823,33 @@ TRACE_EVENT(drv_sta_state,
 	)
 );
 
+TRACE_EVENT(drv_sta_set_txpwr,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_sta *sta),
+
+	TP_ARGS(local, sdata, sta),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		STA_ENTRY
+		__field(u8, txpwr)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		STA_ASSIGN;
+		__entry->txpwr = sta->txpwr;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT  VIF_PR_FMT  STA_PR_FMT " txpwr: %d",
+		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG, __entry->txpwr
+	)
+);
+
 TRACE_EVENT(drv_sta_rc_update,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sub_if_data *sdata,
-- 
1.9.1

