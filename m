Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17679 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753313AbdBHMCK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 07:02:10 -0500
From: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <ath10k@lists.infradead.org>, <johannes@sipsolutions.net>,
        <arnagara@codeaurora.org>,
        Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
Subject: [PATCH v3 2/2] mac80211: store tx power value from user to station
Date: Wed, 8 Feb 2017 17:26:51 +0530
Message-ID: <1486555011-25143-1-git-send-email-arnagara@qti.qualcomm.com> (sfid-20170208_130300_113592_12D3FE2C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch introduce a new driver callback drv_sta_set_txpwr. This API will
copy the transmit power value passed from user space and call the driver
callback to set the tx power for the station.

Signed-off-by: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
---
v3:
	- Store txpwr in mBm units. Push down the converstions at the driver
	  level (Ben Greear)
 include/net/mac80211.h    |  6 ++++++
 net/mac80211/cfg.c        |  8 ++++++++
 net/mac80211/driver-ops.c | 21 +++++++++++++++++++++
 net/mac80211/driver-ops.h |  5 +++++
 net/mac80211/trace.h      | 27 +++++++++++++++++++++++++++
 5 files changed, 67 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 5345d35..49d48f3 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1777,6 +1777,8 @@ struct ieee80211_sta_rates {
  *	This is defined by the spec (IEEE 802.11-2012 section 8.3.2.2 NOTE 2).
  * @support_p2p_ps: indicates whether the STA supports P2P PS mechanism or not.
  * @max_rc_amsdu_len: Maximum A-MSDU size in bytes recommended by rate control.
+ * @txpwr: indicates the tx power, in mBm, to be used when sending data frames
+ *	to the STA. Value of 0 means, automatic (default) tx power.
  * @txq: per-TID data TX queues (if driver uses the TXQ abstraction)
  */
 struct ieee80211_sta {
@@ -1800,6 +1802,7 @@ struct ieee80211_sta {
 	u16 max_amsdu_len;
 	bool support_p2p_ps;
 	u16 max_rc_amsdu_len;
+	u16 txpwr;
 
 	struct ieee80211_txq *txq[IEEE80211_NUM_TIDS];
 
@@ -3545,6 +3548,9 @@ struct ieee80211_ops {
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
index e91e503..0084258 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1346,6 +1346,14 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 	if (params->listen_interval >= 0)
 		sta->listen_interval = params->listen_interval;
 
+	if (params->sta_modify_mask & STATION_PARAM_APPLY_STA_TXPOWER &&
+	    params->txpwr >= 0) {
+		sta->sta.txpwr = params->txpwr;
+		ret = drv_sta_set_txpwr(local, sdata, sta);
+		if (ret)
+			return ret;
+	}
+
 	if (params->supported_rates) {
 		ieee80211_parse_bitrates(&sdata->vif.bss_conf.chandef,
 					 sband, params->supported_rates,
diff --git a/net/mac80211/driver-ops.c b/net/mac80211/driver-ops.c
index bb886e7..839c002 100644
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
index 09f77e4..2b13c39 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -526,6 +526,11 @@ int drv_sta_state(struct ieee80211_local *local,
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
index 92a47af..3c505c1 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -823,6 +823,33 @@
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
+		__field(u16, txpwr)
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
