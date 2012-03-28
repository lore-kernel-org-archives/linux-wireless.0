Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37321 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757731Ab2C1JGP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2012 05:06:15 -0400
Message-Id: <20120328090432.437324860@sipsolutions.net> (sfid-20120328_110630_402971_8122B28B)
Date: Wed, 28 Mar 2012 11:04:24 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/7] cfg80211/nl80211: clarify TX queue API
References: <20120328090422.367469100@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

With the plan to change mac80211's queue API to
not map ACs to queues 1:1, it seems necessary to
clarify some APIs that act on ACs rather than on
queues to spell that out explicitly. Do this.

Also verify that the AC number given is valid.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/nl80211.h     |   22 +++++++++++++++-------
 include/net/cfg80211.h      |    4 ++--
 include/net/mac80211.h      |    2 +-
 net/mac80211/cfg.c          |   10 +++++-----
 net/mac80211/driver-ops.h   |    6 +++---
 net/mac80211/driver-trace.h |   13 ++++++-------
 net/wireless/nl80211.c      |    7 +++++--
 7 files changed, 37 insertions(+), 27 deletions(-)

--- a/include/linux/nl80211.h	2012-03-23 17:11:25.000000000 +0100
+++ b/include/linux/nl80211.h	2012-03-23 17:11:47.000000000 +0100
@@ -2223,7 +2223,7 @@ enum nl80211_mesh_setup_params {
 /**
  * enum nl80211_txq_attr - TX queue parameter attributes
  * @__NL80211_TXQ_ATTR_INVALID: Attribute number 0 is reserved
- * @NL80211_TXQ_ATTR_QUEUE: TX queue identifier (NL80211_TXQ_Q_*)
+ * @NL80211_TXQ_ATTR_AC: AC identifier (NL80211_AC_*)
  * @NL80211_TXQ_ATTR_TXOP: Maximum burst time in units of 32 usecs, 0 meaning
  *	disabled
  * @NL80211_TXQ_ATTR_CWMIN: Minimum contention window [a value of the form
@@ -2236,7 +2236,7 @@ enum nl80211_mesh_setup_params {
  */
 enum nl80211_txq_attr {
 	__NL80211_TXQ_ATTR_INVALID,
-	NL80211_TXQ_ATTR_QUEUE,
+	NL80211_TXQ_ATTR_AC,
 	NL80211_TXQ_ATTR_TXOP,
 	NL80211_TXQ_ATTR_CWMIN,
 	NL80211_TXQ_ATTR_CWMAX,
@@ -2247,13 +2247,21 @@ enum nl80211_txq_attr {
 	NL80211_TXQ_ATTR_MAX = __NL80211_TXQ_ATTR_AFTER_LAST - 1
 };
 
-enum nl80211_txq_q {
-	NL80211_TXQ_Q_VO,
-	NL80211_TXQ_Q_VI,
-	NL80211_TXQ_Q_BE,
-	NL80211_TXQ_Q_BK
+enum nl80211_ac {
+	NL80211_AC_VO,
+	NL80211_AC_VI,
+	NL80211_AC_BE,
+	NL80211_AC_BK,
+	NL80211_NUM_ACS
 };
 
+/* backward compat */
+#define NL80211_TXQ_ATTR_QUEUE	NL80211_TXQ_ATTR_AC
+#define NL80211_TXQ_Q_VO	NL80211_AC_VO
+#define NL80211_TXQ_Q_VI	NL80211_AC_VI
+#define NL80211_TXQ_Q_BE	NL80211_AC_BE
+#define NL80211_TXQ_Q_BK	NL80211_AC_BK
+
 enum nl80211_channel_type {
 	NL80211_CHAN_NO_HT,
 	NL80211_CHAN_HT20,
--- a/include/net/cfg80211.h	2012-03-23 17:11:25.000000000 +0100
+++ b/include/net/cfg80211.h	2012-03-23 17:11:47.000000000 +0100
@@ -842,7 +842,7 @@ struct mesh_setup {
 
 /**
  * struct ieee80211_txq_params - TX queue parameters
- * @queue: TX queue identifier (NL80211_TXQ_Q_*)
+ * @ac: AC identifier
  * @txop: Maximum burst time in units of 32 usecs, 0 meaning disabled
  * @cwmin: Minimum contention window [a value of the form 2^n-1 in the range
  *	1..32767]
@@ -851,7 +851,7 @@ struct mesh_setup {
  * @aifs: Arbitration interframe space [0..255]
  */
 struct ieee80211_txq_params {
-	enum nl80211_txq_q queue;
+	enum nl80211_ac ac;
 	u16 txop;
 	u16 cwmin;
 	u16 cwmax;
--- a/net/wireless/nl80211.c	2012-03-23 17:11:25.000000000 +0100
+++ b/net/wireless/nl80211.c	2012-03-23 17:11:47.000000000 +0100
@@ -1104,17 +1104,20 @@ static const struct nla_policy txq_param
 static int parse_txq_params(struct nlattr *tb[],
 			    struct ieee80211_txq_params *txq_params)
 {
-	if (!tb[NL80211_TXQ_ATTR_QUEUE] || !tb[NL80211_TXQ_ATTR_TXOP] ||
+	if (!tb[NL80211_TXQ_ATTR_AC] || !tb[NL80211_TXQ_ATTR_TXOP] ||
 	    !tb[NL80211_TXQ_ATTR_CWMIN] || !tb[NL80211_TXQ_ATTR_CWMAX] ||
 	    !tb[NL80211_TXQ_ATTR_AIFS])
 		return -EINVAL;
 
-	txq_params->queue = nla_get_u8(tb[NL80211_TXQ_ATTR_QUEUE]);
+	txq_params->ac = nla_get_u8(tb[NL80211_TXQ_ATTR_AC]);
 	txq_params->txop = nla_get_u16(tb[NL80211_TXQ_ATTR_TXOP]);
 	txq_params->cwmin = nla_get_u16(tb[NL80211_TXQ_ATTR_CWMIN]);
 	txq_params->cwmax = nla_get_u16(tb[NL80211_TXQ_ATTR_CWMAX]);
 	txq_params->aifs = nla_get_u8(tb[NL80211_TXQ_ATTR_AIFS]);
 
+	if (txq_params->ac >= NL80211_NUM_ACS)
+		return -EINVAL;
+
 	return 0;
 }
 
--- a/net/mac80211/cfg.c	2012-03-23 17:11:25.000000000 +0100
+++ b/net/mac80211/cfg.c	2012-03-23 17:11:47.000000000 +0100
@@ -1449,14 +1449,14 @@ static int ieee80211_set_txq_params(stru
 	 */
 	p.uapsd = false;
 
-	if (params->queue >= local->hw.queues)
+	if (params->ac >= local->hw.queues)
 		return -EINVAL;
 
-	sdata->tx_conf[params->queue] = p;
-	if (drv_conf_tx(local, sdata, params->queue, &p)) {
+	sdata->tx_conf[params->ac] = p;
+	if (drv_conf_tx(local, sdata, params->ac, &p)) {
 		wiphy_debug(local->hw.wiphy,
-			    "failed to set TX queue parameters for queue %d\n",
-			    params->queue);
+			    "failed to set TX queue parameters for AC %d\n",
+			    params->ac);
 		return -EINVAL;
 	}
 
--- a/net/mac80211/driver-ops.h	2012-03-23 17:11:25.000000000 +0100
+++ b/net/mac80211/driver-ops.h	2012-03-23 17:11:47.000000000 +0100
@@ -492,7 +492,7 @@ static inline void drv_sta_rc_update(str
 }
 
 static inline int drv_conf_tx(struct ieee80211_local *local,
-			      struct ieee80211_sub_if_data *sdata, u16 queue,
+			      struct ieee80211_sub_if_data *sdata, u16 ac,
 			      const struct ieee80211_tx_queue_params *params)
 {
 	int ret = -EOPNOTSUPP;
@@ -501,10 +501,10 @@ static inline int drv_conf_tx(struct iee
 
 	check_sdata_in_driver(sdata);
 
-	trace_drv_conf_tx(local, sdata, queue, params);
+	trace_drv_conf_tx(local, sdata, ac, params);
 	if (local->ops->conf_tx)
 		ret = local->ops->conf_tx(&local->hw, &sdata->vif,
-					  queue, params);
+					  ac, params);
 	trace_drv_return_int(local, ret);
 	return ret;
 }
--- a/net/mac80211/driver-trace.h	2012-03-23 17:11:25.000000000 +0100
+++ b/net/mac80211/driver-trace.h	2012-03-23 17:11:47.000000000 +0100
@@ -705,15 +705,14 @@ TRACE_EVENT(drv_sta_remove,
 TRACE_EVENT(drv_conf_tx,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sub_if_data *sdata,
-		 u16 queue,
-		 const struct ieee80211_tx_queue_params *params),
+		 u16 ac, const struct ieee80211_tx_queue_params *params),
 
-	TP_ARGS(local, sdata, queue, params),
+	TP_ARGS(local, sdata, ac, params),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
 		VIF_ENTRY
-		__field(u16, queue)
+		__field(u16, ac)
 		__field(u16, txop)
 		__field(u16, cw_min)
 		__field(u16, cw_max)
@@ -724,7 +723,7 @@ TRACE_EVENT(drv_conf_tx,
 	TP_fast_assign(
 		LOCAL_ASSIGN;
 		VIF_ASSIGN;
-		__entry->queue = queue;
+		__entry->ac = ac;
 		__entry->txop = params->txop;
 		__entry->cw_max = params->cw_max;
 		__entry->cw_min = params->cw_min;
@@ -733,8 +732,8 @@ TRACE_EVENT(drv_conf_tx,
 	),
 
 	TP_printk(
-		LOCAL_PR_FMT  VIF_PR_FMT  " queue:%d",
-		LOCAL_PR_ARG, VIF_PR_ARG, __entry->queue
+		LOCAL_PR_FMT  VIF_PR_FMT  " AC:%d",
+		LOCAL_PR_ARG, VIF_PR_ARG, __entry->ac
 	)
 );
 
--- a/include/net/mac80211.h	2012-03-23 17:11:47.000000000 +0100
+++ b/include/net/mac80211.h	2012-03-23 17:11:47.000000000 +0100
@@ -2220,7 +2220,7 @@ struct ieee80211_ops {
 			      struct ieee80211_sta *sta,
 			      u32 changed);
 	int (*conf_tx)(struct ieee80211_hw *hw,
-		       struct ieee80211_vif *vif, u16 queue,
+		       struct ieee80211_vif *vif, u16 ac,
 		       const struct ieee80211_tx_queue_params *params);
 	u64 (*get_tsf)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
 	void (*set_tsf)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,


