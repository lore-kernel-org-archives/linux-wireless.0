Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:52433 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825Ab2KWUTc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2012 15:19:32 -0500
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
To: johannes@sipsolutions.net, javier@cozybit.com, thomas@cozybit.com
Cc: linux-wireless@vger.kernel.org,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Subject: [RFCv2 13/13] mac80211: mesh PS individually-addressed frame release
Date: Fri, 23 Nov 2012 12:18:54 -0800
Message-Id: <1353701934-12752-14-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20121123_214527_058091_0A4F1377)
In-Reply-To: <1353701934-12752-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353701934-12752-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When receiving a neighbor beacon, check if the neighbor indicates buffered
frames in its TIM IE and if it announces an awake window duration. The routine
for frame release towards PS neigbors will then evaluate these parameters.

In case the neighbor is an established peer, frames may be released in a
Peer Service Period. Peer Service Periods start and end with a PSP trigger
frame. The setting of RSPI and EOSP frame flags determine if a PSP starts
or ends and which STA is the owner, recipient or both during the PSP.
The indication of buffered frames at the peer and the status of the local
buffers determine which type of PSP is started when a beacon from a peer
is received. The buffered frames are transmitted only after the PSP trigger
frame has been acknowledged.
The function ieee80211_sta_ps_deliver_response will automatically try to
set the EOSP for the last flag. In case this is not a QoS data frame, it
will append a QoS Null frame after the last frame.

The number of PSPs in which the local STA is owner and/or recipient are
counted to be able to disallow doze state during ongoing PSPs.

Currently, in HT channels PSPs behave imperfectly and show large delay spikes
and frame losses.

Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
---
 include/linux/ieee80211.h  |    2 +
 net/mac80211/debugfs_sta.c |    5 +-
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mesh.c        |    1 +
 net/mac80211/mesh.h        |    4 +
 net/mac80211/mesh_plink.c  |    1 +
 net/mac80211/mesh_ps.c     |  287 ++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/rx.c          |    3 +
 net/mac80211/sta_info.h    |    4 +
 net/mac80211/status.c      |    5 +
 10 files changed, 311 insertions(+), 2 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index a586e47..bfce90a 100644
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
index 3d4c43f..c9f7a1a 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -623,6 +623,7 @@ struct ieee80211_if_mesh {
 	u8 ps_peers_light_sleep;
 	u8 ps_peers_deep_sleep;
 	struct ps_data ps;
+	atomic_t num_psp; /* counts both owner and recipient independently */
 };
 
 #ifdef CONFIG_MAC80211_MESH
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index ad5dca7..7314848 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -689,6 +689,7 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 	mesh_path_flush_by_iface(sdata);
 
 	atomic_set(&ifmsh->ps.num_sta_ps, 0); /* not reset by sta_info_flush */
+	atomic_set(&ifmsh->num_psp, 0);
 
 	del_timer_sync(&sdata->u.mesh.housekeeping_timer);
 	del_timer_sync(&sdata->u.mesh.mesh_path_root_timer);
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index f7bf9e3..940a18b 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -257,6 +257,10 @@ void ieee80211_set_peer_ps_mode(struct sta_info *sta,
 				struct ieee80211_hdr *hdr);
 void ieee80211_set_nonpeer_ps_mode(struct sta_info *sta,
 				   struct ieee80211_hdr *hdr);
+void ieee80211_mesh_ps_rx_bcn(struct sta_info *sta,
+			      struct ieee802_11_elems *elems);
+void ieee80211_psp_trigger_process(struct ieee80211_hdr *hdr,
+				   struct sta_info *sta, bool tx, bool acked);
 
 /* Mesh paths */
 int mesh_nexthop_lookup(struct sk_buff *skb,
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 0572346..207fcff 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -418,6 +418,7 @@ void mesh_neighbour_update(struct ieee80211_sub_if_data *sdata,
 	    rssi_threshold_check(sta, sdata))
 		mesh_plink_open(sta);
 
+	ieee80211_mesh_ps_rx_bcn(sta, elems);
 out:
 	rcu_read_unlock();
 }
diff --git a/net/mac80211/mesh_ps.c b/net/mac80211/mesh_ps.c
index ee72f3e..6bde6e0 100644
--- a/net/mac80211/mesh_ps.c
+++ b/net/mac80211/mesh_ps.c
@@ -8,6 +8,27 @@
  */
 
 #include "mesh.h"
+#include "wme.h"
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
@@ -60,6 +81,14 @@ static void ieee80211_send_mesh_null(struct sta_info *sta)
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
 
@@ -270,6 +299,14 @@ void ieee80211_mesh_sta_ps_update(struct sta_info *sta)
 	} else {
 		ieee80211_sta_ps_deliver_wakeup(sta);
 	}
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
@@ -343,3 +380,253 @@ void ieee80211_set_nonpeer_ps_mode(struct sta_info *sta,
 
 	ieee80211_mesh_sta_ps_update(sta);
 }
+
+static void ieee80211_send_psp_trigger(struct sta_info *sta,
+				       bool rspi, bool eosp)
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
+
+	mps_dbg(sdata, "sending PSP trigger%s%s to %pM\n",
+		rspi ? " RSPI" : "", eosp ? " EOSP" : "", sta->sta.addr);
+
+	ieee80211_tx_skb(sdata, skb);
+}
+
+/**
+ * ieee80211_qos_null_append - append QoS Null frame to skb queue if needed
+ *
+ * @sta: peer mesh STA we are sending frames to
+ * @frames: skb queue to append to
+ *
+ * To properly end a mesh PSP the last transmitted frame has to set the EOSP
+ * flag in the QoS Control field. In case the current tailing frame is not a
+ * QoS Data frame, append a QoS Null to carry the flag.
+ */
+static void ieee80211_qos_null_append(struct sta_info *sta,
+				      struct sk_buff_head *frames)
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
+	/* should be transmitted last -> lowest priority */
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
+ * ieee80211_mesh_ps_deliver_psp - transmit frames during a PSP
+ *
+ * @sta: STA info to transmit to
+ * @n_frames: number of frames to transmit. -1 for all
+ */
+static void ieee80211_mesh_ps_deliver(struct sta_info *sta, int n_frames)
+{
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct ieee80211_local *local = sdata->local;
+	int ac;
+	struct sk_buff_head frames;
+	struct sk_buff *skb;
+
+	skb_queue_head_init(&frames);
+
+	/* collect frame(s) from buffers */
+	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
+		struct sk_buff *skb;
+
+		while (n_frames != 0) {
+			skb = skb_dequeue(&sta->tx_filtered[ac]);
+			if (!skb) {
+				skb = skb_dequeue(
+					&sta->ps_tx_buf[ac]);
+				if (skb)
+					local->total_ps_buffered--;
+			}
+			if (!skb)
+				break;
+			n_frames--;
+			skb_queue_tail(&frames, skb);
+		}
+	}
+
+	/* nothing to send? -> EOSP */
+	if (skb_queue_empty(&frames)) {
+		ieee80211_send_psp_trigger(sta, false, true);
+		return;
+	}
+
+	/* in a PSP make sure the last skb is a QoS Data frame */
+	if (test_sta_flag(sta, WLAN_STA_PSP_OWNER))
+		ieee80211_qos_null_append(sta, &frames);
+
+	mps_dbg(sta->sdata, "sending %d frames to PS STA %pM\n",
+		skb_queue_len(&frames),sta->sta.addr);
+
+	/* prepare collected frames for transmission */
+	skb_queue_walk(&frames, skb) {
+		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+		struct ieee80211_hdr *hdr = (void *) skb->data;
+
+		/*
+		 * Tell TX path to send this frame even though the
+		 * STA may still remain is PS mode after this frame
+		 * exchange.
+		 */
+		info->flags |= IEEE80211_TX_CTL_NO_PS_BUFFER;
+
+		if (!skb_queue_is_last(&frames, skb)) {
+			hdr->frame_control |=
+				cpu_to_le16(IEEE80211_FCTL_MOREDATA);
+		} else {
+			hdr->frame_control &=
+				cpu_to_le16(~IEEE80211_FCTL_MOREDATA);
+
+			if (ieee80211_is_data_qos(hdr->frame_control)) {
+				u8 *qoshdr = ieee80211_get_qos_ctl(hdr);
+
+				/* PSP trigger frame ends service period */
+				*qoshdr |= IEEE80211_QOS_CTL_EOSP;
+				info->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
+			}
+		}
+	}
+
+	ieee80211_add_pending_skbs(local, &frames);
+	sta_info_recalc_tim(sta);
+}
+
+/**
+ * ieee80211_mesh_ps_rx_bcn - react to neighbour beacon with either node in PS
+ *
+ * @sta: neighbour STA that sent the beacon
+ * @awake_window: awake window duration the neighbour announced
+ * @buffer_peer: neighbour has data buffered for the local STA
+ *
+ * If we have individually-addressed frames buffered or a peer indicates
+ * buffered frames, send a corresponding peer service period trigger frame.
+ * Since currently we do not evaluate the awake window duration,
+ * QoS Nulls are used as PSP trigger frames.
+ * Currently, if the neighbour STA is not a peer, only send single frames.
+ */
+void ieee80211_mesh_ps_rx_bcn(struct sta_info *sta,
+			      struct ieee802_11_elems *elems)
+{
+	int ac, buffer_local = 0;
+	bool has_buffered = false;
+	u16 awake_window = 0;
+
+	/* TIM map only for LLID <= IEEE80211_MAX_AID */
+	if (sta->plink_state == NL80211_PLINK_ESTAB)
+		has_buffered = ieee80211_check_tim(elems->tim, elems->tim_len,
+				le16_to_cpu(sta->llid) % IEEE80211_MAX_AID);
+
+	if (has_buffered)
+		mps_dbg(sta->sdata, "%pM indicates buffered frames\n",
+			sta->sta.addr);
+
+	if (elems->awake_window)
+		awake_window = get_unaligned_le16(elems->awake_window);
+
+	/* only transmit towards PS STA with announced awake window */
+	if (test_sta_flag(sta, WLAN_STA_PS_STA) && !awake_window)
+		return;
+
+	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
+		buffer_local += skb_queue_len(&sta->ps_tx_buf[ac]) +
+				skb_queue_len(&sta->tx_filtered[ac]);
+
+	if (!has_buffered && !buffer_local)
+		return;
+
+	if (sta->plink_state == NL80211_PLINK_ESTAB)
+		ieee80211_send_psp_trigger(sta, has_buffered, !buffer_local);
+	else
+		ieee80211_mesh_ps_deliver(sta, 1);
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
+			ieee80211_mesh_ps_deliver(sta, -1);
+	} else {
+		if (eosp)
+			test_and_clear_psp_flag(sta, WLAN_STA_PSP_RECIPIENT);
+		else if (sta->local_ps_mode != NL80211_MESH_POWER_ACTIVE)
+			test_and_set_psp_flag(sta, WLAN_STA_PSP_RECIPIENT);
+
+		if (rspi && !test_and_set_psp_flag(sta, WLAN_STA_PSP_OWNER))
+			ieee80211_mesh_ps_deliver(sta, -1);
+	}
+}
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 90f2ce5..c9abe59 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1365,6 +1365,9 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 			 * peer's link-specific PS mode towards the local STA
 			 */
 			ieee80211_set_peer_ps_mode(sta, hdr);
+
+			/* check for peer service period trigger frames */
+			ieee80211_psp_trigger_process(hdr, sta, false, false);
 		} else {
 			/*
 			 * can only determine non-peer PS mode
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index dbb3a10..81b528b 100644
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

