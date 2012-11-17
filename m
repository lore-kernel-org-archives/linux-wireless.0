Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:48716 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425Ab2KQGs7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Nov 2012 01:48:59 -0500
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
To: johannes@sipsolutions.net, javier@cozybit.com
Cc: linux-wireless@vger.kernel.org,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Subject: [RFC 14/14] mac80211: mesh PS individually-addressed frame release
Date: Fri, 16 Nov 2012 22:48:06 -0800
Message-Id: <1353134886-13256-15-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20121117_074906_879115_8145D231)
In-Reply-To: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When receiving a neighbor beacon, check if the neighbor indicates
buffered frames in its TIM IE and if it announces an awake window duration.
The routine for frame release towards PS neigbors will then evaluate these
parameters.

In case the neighbor is an established peer, frames may be released in a
Peer Service Period. Peer Service Periods start and end with a PSP trigger
frame. The setting of RSPI and EOSP frame flags determine if a PSP starts
or ends and which STA is the owner of the PSP.
The indication of buffered frames at the peer and the status of the local
buffers determine which type of PSP is started when a beacon from a peer
is received. The buffered frames are transmitted only after the PSP trigger
frame has been acknowledged.
The function ieee80211_sta_ps_deliver_response will automatically try to
set the EOSP for the last flag. In case this is not a QoS data frame, it
will append a QoS Null frame after the last frame.

The number of PSPs in which the local STA is owner or recipient are counted
to be able to disallow doze state during ongoing PSPs.

Currently, in HT channels PSPs behave imperfectly and show large delay spikes
and frame losses.

Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
---
 include/linux/ieee80211.h  |    2 +
 net/mac80211/debugfs_sta.c |    5 +-
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mesh.c        |    1 +
 net/mac80211/mesh.h        |    8 ++
 net/mac80211/mesh_plink.c  |   15 +++
 net/mac80211/mesh_ps.c     |  231 ++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/rx.c          |    3 +
 net/mac80211/sta_info.c    |   13 ++-
 net/mac80211/sta_info.h    |    8 ++
 net/mac80211/status.c      |    5 +
 11 files changed, 288 insertions(+), 4 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 1d8e69a..537a9e1 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -151,6 +151,8 @@
 
 /* mesh power save level subfield mask */
 #define IEEE80211_QOS_CTL_MESH_PS_LEVEL 	0x0200
+/* RSPI */
+#define IEEE80211_QOS_CTL_RSPI			0x0400
 
 /* U-APSD queue for WMM IEs sent by AP */
 #define IEEE80211_WMM_IE_AP_QOSINFO_UAPSD	(1<<7)
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 5ccec2c..40f58ce 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -63,7 +63,7 @@ static ssize_t sta_flags_read(struct file *file, char __user *userbuf,
 	test_sta_flag(sta, WLAN_STA_##flg) ? #flg "\n" : ""
 
 	int res = scnprintf(buf, sizeof(buf),
-			    "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
+			    "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
 			    TEST(AUTH), TEST(ASSOC), TEST(PS_STA),
 			    TEST(PS_DRIVER), TEST(AUTHORIZED),
 			    TEST(SHORT_PREAMBLE),
@@ -72,7 +72,8 @@ static ssize_t sta_flags_read(struct file *file, char __user *userbuf,
 			    TEST(UAPSD), TEST(SP), TEST(TDLS_PEER),
 			    TEST(TDLS_PEER_AUTH), TEST(4ADDR_EVENT),
 			    TEST(INSERTED), TEST(RATE_CONTROL),
-			    TEST(TOFFSET_KNOWN));
+			    TEST(TOFFSET_KNOWN), TEST(PSP_OWNER),
+			    TEST(PSP_RECIPIENT));
 #undef TEST
 	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
 }
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 3d4c43f..be80196 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -623,6 +623,7 @@ struct ieee80211_if_mesh {
 	u8 ps_peers_light_sleep;
 	u8 ps_peers_deep_sleep;
 	struct ps_data ps;
+	atomic_t num_psp; /* number of PSPs local STA is owner/recipient */
 };
 
 #ifdef CONFIG_MAC80211_MESH
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index fff017e..3054bd0 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -664,6 +664,7 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 	ieee80211_local_ps_update(sdata);
 	/* reset in case we have been in a mesh with PS peers before */
 	atomic_set(&sdata->u.mesh.ps.num_sta_ps, 0);
+	atomic_set(&sdata->u.mesh.num_psp, 0);
 	skb_queue_head_init(&ifmsh->ps.bc_buf);
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON |
 						BSS_CHANGED_BEACON_ENABLED |
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 19c682e..f0cd72d 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -271,6 +271,14 @@ void ieee80211_set_peer_ps_mode(struct sta_info *sta,
 				struct ieee80211_hdr *hdr);
 void ieee80211_set_nonpeer_ps_mode(struct sta_info *sta,
 				   struct ieee80211_hdr *hdr);
+void ieee80211_send_psp_trigger(struct sta_info *sta,
+				bool rspi, bool eosp);
+void ieee80211_qos_null_append(struct sta_info *sta,
+			       struct sk_buff_head *frames);
+void ieee80211_mesh_ps_deliver(struct sta_info *sta, u16 awake_window,
+			       bool buffer_peer);
+void ieee80211_psp_trigger_process(struct ieee80211_hdr *hdr,
+				   struct sta_info *sta, bool tx, bool acked);
 
 /* Mesh paths */
 int mesh_nexthop_lookup(struct sk_buff *skb,
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 74d4da5..6b0912d 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -412,6 +412,8 @@ void mesh_neighbour_update(struct ieee80211_sub_if_data *sdata,
 			   struct ieee802_11_elems *elems)
 {
 	struct sta_info *sta;
+	bool has_buffered = false;
+	u16 awake_window = 0;
 
 	rcu_read_lock();
 	sta = mesh_peer_init(sdata, hw_addr, elems);
@@ -425,6 +427,19 @@ void mesh_neighbour_update(struct ieee80211_sub_if_data *sdata,
 	    rssi_threshold_check(sta, sdata))
 		mesh_plink_open(sta);
 
+	/* TIM map only for AID <= IEEE80211_MAX_AID */
+	if (elems->tim && sta->plink_state == NL80211_PLINK_ESTAB)
+		has_buffered = ieee80211_check_tim(elems->tim, elems->tim_len,
+				le16_to_cpu(sta->llid) % IEEE80211_MAX_AID);
+
+	if (has_buffered)
+		mps_dbg(sdata, "%pM indicates buffered frames (LLID %d)\n",
+			hw_addr, le16_to_cpu(sta->llid));
+
+	if (elems->awake_window)
+		awake_window = get_unaligned_le16(elems->awake_window);
+
+	ieee80211_mesh_ps_deliver(sta, awake_window, has_buffered);
 out:
 	rcu_read_unlock();
 }
diff --git a/net/mac80211/mesh_ps.c b/net/mac80211/mesh_ps.c
index e98d80c..e972680 100644
--- a/net/mac80211/mesh_ps.c
+++ b/net/mac80211/mesh_ps.c
@@ -8,6 +8,28 @@
  */
 
 #include "mesh.h"
+#include "wme.h"
+#include "driver-ops.h"
+
+static inline bool test_and_set_psp_flag(struct sta_info *sta,
+					 enum ieee80211_sta_info_flags flag)
+{
+	if (!test_and_set_sta_flag(sta, flag)) {
+		atomic_inc(&sta->sdata->u.mesh.num_psp);
+		return false;
+	}
+	return true;
+}
+
+static inline bool test_and_clear_psp_flag(struct sta_info *sta,
+					   enum ieee80211_sta_info_flags flag)
+{
+	if (test_and_clear_sta_flag(sta, flag)) {
+		atomic_dec(&sta->sdata->u.mesh.num_psp);
+		return true;
+	}
+	return false;
+}
 
 /**
  * ieee80211_mesh_null_get - create pre-addressed QoS Null frame
@@ -60,6 +82,14 @@ static void ieee80211_send_mesh_null(struct sta_info *sta)
 	mps_dbg(sta->sdata, "announcing peer-specific power mode to %pM\n",
 		sta->sta.addr);
 
+	/* don't unintentionally start a PSP */
+	if (!test_sta_flag(sta, WLAN_STA_PS_STA)) {
+		__le16 *qc = (__le16 *) ieee80211_get_qos_ctl(
+				(struct ieee80211_hdr *) skb->data);
+
+		*qc |= cpu_to_le16(IEEE80211_QOS_CTL_EOSP);
+	}
+
 	ieee80211_tx_skb(sta->sdata, skb);
 }
 
@@ -261,6 +291,14 @@ void ieee80211_sta_ps_update(struct sta_info *sta)
 
 	/* enable frame buffering for powersave STA */
 	ieee80211_sta_ps_transition_ni(&sta->sta, do_buffer);
+
+	/* clear the PSP flags for non-peers or active STA */
+	if (sta->plink_state != NL80211_PLINK_ESTAB) {
+		test_and_clear_psp_flag(sta, WLAN_STA_PSP_OWNER);
+		test_and_clear_psp_flag(sta, WLAN_STA_PSP_RECIPIENT);
+	} else if (!do_buffer) {
+		test_and_clear_psp_flag(sta, WLAN_STA_PSP_OWNER);
+	}
 }
 
 /**
@@ -345,3 +383,196 @@ void ieee80211_set_nonpeer_ps_mode(struct sta_info *sta,
 
 	ieee80211_sta_ps_update(sta);
 }
+
+/**
+ * ieee80211_send_psp_trigger - send PSP trigger (QoS Null) to init/end PSP
+ *
+ * @sta: peer mesh STA
+ * @rspi: set RSPI flag
+ * @eosp: set EOSP flag
+ */
+void ieee80211_send_psp_trigger(struct sta_info *sta,
+				bool rspi, bool eosp)
+{
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct sk_buff *skb;
+	struct ieee80211_hdr *nullfunc;
+	struct ieee80211_tx_info *info;
+	__le16 *qc;
+
+	skb = ieee80211_mesh_null_get(sta);
+	if (!skb)
+		return;
+
+	nullfunc = (struct ieee80211_hdr *) skb->data;
+	if (!eosp)
+		nullfunc->frame_control |=
+				cpu_to_le16(IEEE80211_FCTL_MOREDATA);
+	/*
+	 * | RSPI | EOSP |   PSP triggering   |
+	 * +------+------+--------------------+
+	 * |  0   |  0   | local STA is owner |
+	 * |  0   |  1   |  no PSP (PSP end)  |
+	 * |  1   |  0   | both STA are owner |
+	 * |  1   |  1   | peer STA is owner  | see IEEE802.11-2012 13.14.9.2
+	 */
+	qc = (__le16 *) ieee80211_get_qos_ctl(nullfunc);
+	if (rspi)
+		*qc |= cpu_to_le16(IEEE80211_QOS_CTL_RSPI);
+	if (eosp)
+		*qc |= cpu_to_le16(IEEE80211_QOS_CTL_EOSP);
+
+	info = IEEE80211_SKB_CB(skb);
+
+	info->flags |= IEEE80211_TX_CTL_NO_PS_BUFFER |
+		       IEEE80211_TX_CTL_REQ_TX_STATUS;
+	if (eosp)
+		info->flags |= IEEE80211_TX_STATUS_EOSP;
+
+	mps_dbg(sdata, "sending PSP trigger%s%s to %pM\n",
+		rspi ? " RSPI" : "", eosp ? " EOSP" : "", sta->sta.addr);
+
+	/* Send all internal mgmt frames on VO. Accordingly set TID to 7. */
+	drv_allow_buffered_frames(sdata->local, sta, BIT(7), 1,
+				  IEEE80211_FRAME_RELEASE_UAPSD, !eosp);
+
+	ieee80211_tx_skb(sdata, skb);
+}
+
+/**
+ * ieee80211_qos_null_append - append QoS Null as PSP trigger (if necessary)
+ *
+ * @sta: peer mesh STA we are sending frames to
+ * @frames: skb queue to append to
+ */
+void ieee80211_qos_null_append(struct sta_info *sta,
+			       struct sk_buff_head *frames)
+{
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct sk_buff *new_skb, *skb = skb_peek_tail(frames);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct ieee80211_tx_info *info;
+
+	if (ieee80211_is_data_qos(hdr->frame_control))
+		return;
+
+	new_skb = ieee80211_mesh_null_get(sta);
+	if (!new_skb)
+		return;
+
+	mps_dbg(sdata, "appending QoS Null in PSP towards %pM\n",
+		sta->sta.addr);
+
+	/* must be frame transmitted last -> lowest priority */
+	new_skb->priority = 1;
+	skb_set_queue_mapping(new_skb, IEEE80211_AC_BK);
+	ieee80211_set_qos_hdr(sdata, new_skb);
+
+	info = IEEE80211_SKB_CB(new_skb);
+	info->control.vif = &sdata->vif;
+	info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
+
+	__skb_queue_tail(frames, new_skb);
+}
+
+/**
+ * ieee80211_mesh_ps_deliver - transmit frames during mesh power save
+ *
+ * @sta: STA info to transmit to
+ * @awake_window: peer's awake window duration
+ * @buffer_peer: the neighbor has data buffered for the local STA
+ *
+ * If we have individually-addressed frames buffered or a peer indicates
+ * buffered frames, send a corresponding peer service period trigger frame.
+ * Since currently we do not evaluate the awake window duration,
+ * QoS Nulls are used as PSP trigger frames.
+ * If the STA is not a peer, only single frames may be sent.
+ */
+void ieee80211_mesh_ps_deliver(struct sta_info *sta, u16 awake_window,
+			       bool buffer_peer)
+{
+	int ac, buffer_local = 0;
+
+	/* only towards PS STA with announced awake window */
+	if (test_sta_flag(sta, WLAN_STA_PS_STA) && !awake_window)
+		return;
+
+	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
+		buffer_local += skb_queue_len(&sta->ps_tx_buf[ac]) +
+				skb_queue_len(&sta->tx_filtered[ac]);
+
+	if (!buffer_peer && !buffer_local)
+		return;
+
+	if (sta->plink_state == NL80211_PLINK_ESTAB) {
+		ieee80211_send_psp_trigger(sta, buffer_peer, !buffer_local);
+	} else {
+		mps_dbg(sta->sdata, "sending single frame (of %d) to %pM\n",
+			buffer_local, sta->sta.addr);
+
+		ieee80211_sta_ps_deliver_response(sta, 1, 0,
+				IEEE80211_FRAME_RELEASE_UAPSD);
+	}
+}
+
+/**
+ * ieee80211_mesh_ps_deliver_psp - transmit frames during a PSP
+ *
+ * @sta: STA info to transmit to
+ */
+static void ieee80211_mesh_ps_deliver_psp(struct sta_info *sta)
+{
+	int ac, buffer_local = 0;
+
+	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
+		buffer_local += skb_queue_len(&sta->ps_tx_buf[ac]) +
+				skb_queue_len(&sta->tx_filtered[ac]);
+
+	if (buffer_local) {
+		mps_dbg(sta->sdata, "in PSP with %pM -> sending %d frames\n",
+			sta->sta.addr, buffer_local);
+
+		ieee80211_sta_ps_deliver_response(sta, buffer_local,
+				0, IEEE80211_FRAME_RELEASE_UAPSD);
+	} else {
+		ieee80211_send_psp_trigger(sta, false, true);
+	}
+}
+
+/**
+ * ieee80211_psp_trigger_process - track the status of Peer Service Periods
+ *
+ * @hdr: IEEE 802.11 QoS Header
+ * @sta: peer to start a PSP with
+ * @tx: frame was transmitted by the local STA
+ * @acked: frame has been transmitted successfully
+ *
+ * NOTE: active mode STA may only serve as PSP owner
+ */
+void ieee80211_psp_trigger_process(struct ieee80211_hdr *hdr,
+				   struct sta_info *sta, bool tx, bool acked)
+{
+	__le16 *qc = (__le16 *) ieee80211_get_qos_ctl(hdr);
+	__le16 rspi = *qc & cpu_to_le16(IEEE80211_QOS_CTL_RSPI);
+	__le16 eosp = *qc & cpu_to_le16(IEEE80211_QOS_CTL_EOSP);
+
+	if (tx) {
+		if (rspi && acked)
+			test_and_set_psp_flag(sta, WLAN_STA_PSP_RECIPIENT);
+
+		if (eosp)
+			test_and_clear_psp_flag(sta, WLAN_STA_PSP_OWNER);
+		else if (acked &&
+			 test_sta_flag(sta, WLAN_STA_PS_STA) &&
+			 !test_and_set_psp_flag(sta, WLAN_STA_PSP_OWNER))
+			ieee80211_mesh_ps_deliver_psp(sta);
+	} else {
+		if (eosp)
+			test_and_clear_psp_flag(sta, WLAN_STA_PSP_RECIPIENT);
+		else if (sta->local_ps_mode != NL80211_MESH_POWER_ACTIVE)
+			test_and_set_psp_flag(sta, WLAN_STA_PSP_RECIPIENT);
+
+		if (rspi && !test_and_set_psp_flag(sta, WLAN_STA_PSP_OWNER))
+			ieee80211_mesh_ps_deliver_psp(sta);
+	}
+}
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index d56889f..e8a5e45 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1369,6 +1369,9 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 			 * peer's link-specific PS mode towards the local STA
 			 */
 			ieee80211_set_peer_ps_mode(sta, hdr);
+
+			/* check for peer service period trigger frames */
+			ieee80211_psp_trigger_process(hdr, sta, false, false);
 		} else {
 			/*
 			 * can only determine non-peer PS mode
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 4c312ed..913a8ea 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1107,7 +1107,7 @@ static void ieee80211_send_null_response(struct ieee80211_sub_if_data *sdata,
 	rcu_read_unlock();
 }
 
-static void
+void
 ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 				  int n_frames, u8 ignored_acs,
 				  enum ieee80211_frame_release_type reason)
@@ -1201,7 +1201,11 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 		/* This will evaluate to 1, 3, 5 or 7. */
 		tid = 7 - ((ffs(~ignored_acs) - 1) << 1);
 
-		ieee80211_send_null_response(sdata, sta, tid, reason);
+		if (ieee80211_vif_is_mesh(&sdata->vif))
+			ieee80211_send_psp_trigger(sta, false, true);
+		else
+			ieee80211_send_null_response(sdata, sta, tid, reason);
+
 		return;
 	}
 
@@ -1213,6 +1217,11 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 
 		skb_queue_head_init(&pending);
 
+		/* in a PSP make sure the last skb is a QoS Data frame */
+		if (ieee80211_vif_is_mesh(&sta->sdata->vif) &&
+		    !skb_queue_empty(&frames))
+			ieee80211_qos_null_append(sta, &frames);
+
 		while ((skb = __skb_dequeue(&frames))) {
 			struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 			struct ieee80211_hdr *hdr = (void *) skb->data;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index dbb3a10..bc48a82 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -56,6 +56,8 @@
  * @WLAN_STA_INSERTED: This station is inserted into the hash table.
  * @WLAN_STA_RATE_CONTROL: rate control was initialized for this station.
  * @WLAN_STA_TOFFSET_KNOWN: toffset calculated for this station is valid.
+ * @WLAN_STA_PSP_OWNER: local STA is owner of a Peer Service Period.
+ * @WLAN_STA_PSP_RECIPIENT: local STA is recipient of a Peer Service Period.
  */
 enum ieee80211_sta_info_flags {
 	WLAN_STA_AUTH,
@@ -78,6 +80,8 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_INSERTED,
 	WLAN_STA_RATE_CONTROL,
 	WLAN_STA_TOFFSET_KNOWN,
+	WLAN_STA_PSP_OWNER,
+	WLAN_STA_PSP_RECIPIENT,
 };
 
 #define STA_TID_NUM 16
@@ -567,5 +571,9 @@ void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
 void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta);
 void ieee80211_sta_ps_deliver_poll_response(struct sta_info *sta);
 void ieee80211_sta_ps_deliver_uapsd(struct sta_info *sta);
+void
+ieee80211_sta_ps_deliver_response(struct sta_info *sta,
+				  int n_frames, u8 ignored_acs,
+				  enum ieee80211_frame_release_type reason);
 
 #endif /* STA_INFO_H */
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 2482478..978508b 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -399,6 +399,11 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 			return;
 		}
 
+		/* mesh peer service period support */
+		if (ieee80211_vif_is_mesh(&sta->sdata->vif) &&
+		    ieee80211_is_data_qos(hdr->frame_control))
+			ieee80211_psp_trigger_process(hdr, sta, true, acked);
+
 		if ((local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL) &&
 		    (rates_idx != -1))
 			sta->last_tx_rate = info->status.rates[rates_idx];
-- 
1.7.9.5

