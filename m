Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25167 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935086AbcLOGAy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Dec 2016 01:00:54 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [RFC 1/3] mac80211: Add provision for 802.11 encap/decap offload
Date: Thu, 15 Dec 2016 11:30:06 +0530
Message-ID: <1481781608-5181-2-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20161215_070125_699176_B32A39BF)
In-Reply-To: <1481781608-5181-1-git-send-email-vthiagar@qti.qualcomm.com>
References: <1481781608-5181-1-git-send-email-vthiagar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drivers can have the capability to offload 802.11 encap/decap
to firmware or hardware for data frames. This patch adds a new
hw_flag for driver to advertise the offload support. Drivers
advertising the support have also to implement new ieee80211_ops
callback, get_vif_80211_hdr_offload(), to notify if the 802.11 encap/decap
offload is supported for a particular vif type. Transmit and receive
path offloading 802.11 header (including cipher headers) encap/decap
for data frames will be implemented in separate patches.

Drivers advertising this capability should also implement other
functionalities which deal with 802.11 frame format like below

	- Hardware encryption/Decryption
	- ADDBA/DELBA offload
	- Aggregation and deaggregation of A-MSDU offload
	- Fragmentation and defragmentation offload
	- Rx reordering of A-MPDU subframe offload
	- PN/TSC check offload
	- Rx duplication check offload
	- Hardware rate control
	- Powersave offload

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
---
 include/net/mac80211.h    | 16 ++++++++++++++++
 net/mac80211/debugfs.c    |  1 +
 net/mac80211/driver-ops.h | 21 +++++++++++++++++++++
 net/mac80211/main.c       |  4 ++++
 net/mac80211/trace.h      | 33 +++++++++++++++++++++++++++++++++
 5 files changed, 75 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index b4faadb..1e3c8b5 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2014,6 +2014,11 @@ struct ieee80211_txq {
  * @IEEE80211_HW_TX_FRAG_LIST: Hardware (or driver) supports sending frag_list
  *	skbs, needed for zero-copy software A-MSDU.
  *
+ * @IEEE80211_HW_SUPPORTS_80211_ENCAP_DECAP: Hardware/driver supports 802.11
+ *	encap/decap for data frames. Supporting driver have to implement
+ *	get_vif_80211_encap_decap_offload() to pass if 802.11 encap/decap
+ *	offload	is supported for the vif.
+ *
  * @NUM_IEEE80211_HW_FLAGS: number of hardware flags, used for sizing arrays
  */
 enum ieee80211_hw_flags {
@@ -2054,6 +2059,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_USES_RSS,
 	IEEE80211_HW_TX_AMSDU,
 	IEEE80211_HW_TX_FRAG_LIST,
+	IEEE80211_HW_SUPPORTS_80211_ENCAP_DECAP,
 
 	/* keep last, obviously */
 	NUM_IEEE80211_HW_FLAGS
@@ -3401,6 +3407,12 @@ enum ieee80211_reconfig_type {
  *	synchronization which is needed in case driver has in its RSS queues
  *	pending frames that were received prior to the control path action
  *	currently taken (e.g. disassociation) but are not processed yet.
+ *
+ * @get_vif_80211_hdr_offload: Called to check if driver or hardware
+ *	supports 802.11 encap/decap offload for data frames for the vif.
+ *	Drivers implementing this callback should advertise the support
+ *	through hw_flags (%IEEE80211_HW_SUPPORTS_80211_ENCAP_DECAP).
+ *	This callback can sleep.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -3639,6 +3651,10 @@ struct ieee80211_ops {
 	void (*wake_tx_queue)(struct ieee80211_hw *hw,
 			      struct ieee80211_txq *txq);
 	void (*sync_rx_queues)(struct ieee80211_hw *hw);
+
+	int (*get_vif_80211_hdr_offload)(struct ieee80211_hw *hw,
+					 struct ieee80211_vif *vif,
+					 bool is_4addr, bool *supported);
 };
 
 /**
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 2906c10..f49fea5 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -302,6 +302,7 @@ static const char *hw_flag_names[] = {
 	FLAG(USES_RSS),
 	FLAG(TX_AMSDU),
 	FLAG(TX_FRAG_LIST),
+	FLAG(SUPPORTS_80211_ENCAP_DECAP),
 #undef FLAG
 };
 
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 184473c..22847d2 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1179,4 +1179,25 @@ static inline void drv_wake_tx_queue(struct ieee80211_local *local,
 	local->ops->wake_tx_queue(&local->hw, &txq->txq);
 }
 
+static inline int
+drv_get_vif_80211_hdr_offload(struct ieee80211_local *local,
+			      struct ieee80211_sub_if_data *sdata,
+			      bool use_4addr, bool *supported)
+{
+	int ret = -EOPNOTSUPP;
+
+	might_sleep();
+
+	if (local->ops->get_vif_80211_hdr_offload)
+		ret = local->ops->get_vif_80211_hdr_offload(&local->hw,
+							    &sdata->vif,
+							    use_4addr,
+							    supported);
+
+	trace_drv_get_vif_80211_hdr_offload(local, sdata, use_4addr,
+					    *supported, ret);
+
+	return ret;
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index d00ea9b..2095d7c 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -818,6 +818,10 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	     !local->ops->tdls_recv_channel_switch))
 		return -EOPNOTSUPP;
 
+	if (ieee80211_hw_check(hw, SUPPORTS_80211_ENCAP_DECAP) &&
+	    !local->ops->get_vif_80211_hdr_offload)
+		return -EINVAL;
+
 #ifdef CONFIG_PM
 	if (hw->wiphy->wowlan && (!local->ops->suspend || !local->ops->resume))
 		return -EINVAL;
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 77e4c53..aa4a2cd 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -2415,6 +2415,39 @@ TRACE_EVENT(drv_wake_tx_queue,
 	)
 );
 
+TRACE_EVENT(drv_get_vif_80211_hdr_offload,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 bool use_4addr,
+		 bool supported,
+		 int ret),
+
+	TP_ARGS(local, sdata, use_4addr, supported, ret),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		__field(bool, use_4addr)
+		__field(bool, supported)
+		__field(int, ret)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		__entry->use_4addr = use_4addr;
+		__entry->supported = supported;
+		__entry->ret = ret;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT  VIF_PR_FMT " use_4addr:%d"
+		" 802.11 header offload supported%d ret:%d", LOCAL_PR_ARG,
+		VIF_PR_ARG, __entry->use_4addr, __entry->supported,
+		__entry->ret
+	)
+);
+
 #endif /* !__MAC80211_DRIVER_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
-- 
1.9.1
