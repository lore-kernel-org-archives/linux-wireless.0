Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:25291 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755650Ab0KJMXz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 07:23:55 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 04:23:42 -0800
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linux-wireless@vger.kernel.org>
Subject: [RFC 1/5] mac80211: Add support for transmit beam forming.
Date: Wed, 10 Nov 2010 17:53:45 +0530
Message-ID: <1289391829-8577-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable beamforming if the driver and the AP are capable of sending 
and receiving beam-formed frames.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 include/linux/ieee80211.h  |   41 ++++++++++++++++++++++++++++++++++++++++-
 include/net/cfg80211.h     |    6 ++++++
 include/net/mac80211.h     |    9 +++++++--
 net/mac80211/cfg.c         |    7 +++++++
 net/mac80211/ht.c          |   18 ++++++++++++++++++
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mlme.c        |   19 +++++++++++++++++++
 net/mac80211/rx.c          |   10 ++++++++++
 net/mac80211/sta_info.c    |    2 ++
 net/mac80211/sta_info.h    |    6 ++++++
 net/mac80211/status.c      |   19 +++++++++++++++++++
 net/mac80211/tx.c          |   27 ++++++++++++++++++++++++---
 net/mac80211/work.c        |    1 +
 13 files changed, 160 insertions(+), 6 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index ed5a03c..ba92b73 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -120,6 +120,8 @@
 #define IEEE80211_QOS_CTL_TID_MASK	0x000F
 #define IEEE80211_QOS_CTL_TAG1D_MASK	0x0007
 
+#define IEEE80211_QOS_HTC_LEN		4
+
 /* U-APSD queue for WMM IEs sent by AP */
 #define IEEE80211_WMM_IE_AP_QOSINFO_UAPSD	(1<<7)
 
@@ -140,6 +142,9 @@
 
 #define IEEE80211_HT_CTL_LEN		4
 
+#define IEEE80211_HTC2_CSI_NONCOMP_BF       0x00800000
+#define IEEE80211_HTC2_CSI_COMP_BF          0x00c00000
+
 struct ieee80211_hdr {
 	__le16 frame_control;
 	__le16 duration_id;
@@ -169,6 +174,17 @@ struct ieee80211_qos_hdr {
 	__le16 qos_ctrl;
 } __attribute__ ((packed));
 
+struct ieee80211_qos_htc_hdr {
+	__le16 frame_control;
+	__le16 duration_id;
+	u8 addr1[6];
+	u8 addr2[6];
+	u8 addr3[6];
+	__le16 seq_ctrl;
+	__le16 qos_ctrl;
+	__le32 htc;
+} __attribute__ ((packed));
+
 /**
  * ieee80211_has_tods - check if IEEE80211_FCTL_TODS is set
  * @fc: frame control bytes in little-endian byteorder
@@ -827,6 +843,29 @@ struct ieee80211_mcs_info {
 	u8 reserved[3];
 } __attribute__((packed));
 
+struct ieee80211_txbf_caps {
+	u32 implicit_rx_capable:1,
+	    rx_staggered_sounding:1,
+	    tx_staggered_sounding:1,
+	    rx_ndp_capable:1,
+	    tx_ndp_capable:1,
+	    implicit_txbf_capable:1,
+	    calibration:2,
+	    explicit_csi_txbf_capable:1,
+	    explicit_noncomp_steering:1,
+	    explicit_comp_steering:1,
+	    explicit_csi_feedback:2,
+	    explicit_noncomp_bf:2,
+	    explicit_comp_bf:2,
+	    minimal_grouping:2,
+	    csi_bfer_antennas:2,
+	    noncomp_bfer_antennas:2,
+	    comp_bfer_antennas:2,
+	    csi_max_rows_bfer:2,
+	    channel_estimation_cap:2,
+	    reserved:3;
+};
+
 /* 802.11n HT capability MSC set */
 #define IEEE80211_HT_MCS_RX_HIGHEST_MASK	0x3ff
 #define IEEE80211_HT_MCS_TX_DEFINED		0x01
@@ -862,7 +901,7 @@ struct ieee80211_ht_cap {
 	struct ieee80211_mcs_info mcs;
 
 	__le16 extended_ht_cap_info;
-	__le32 tx_BF_cap_info;
+	struct ieee80211_txbf_caps tx_BF_cap_info;
 	u8 antenna_selection_info;
 } __attribute__ ((packed));
 
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e5702f5..23b120a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -210,6 +210,12 @@ struct ieee80211_sta_ht_cap {
 	u8 ampdu_factor;
 	u8 ampdu_density;
 	struct ieee80211_mcs_info mcs;
+	struct ieee80211_txbf_caps txbf;
+	bool explicit_compbf;
+	bool explicit_noncompbf;
+	bool implicit_bf;
+	bool staggered_sounding;
+	u8 channel_estimation_cap;
 };
 
 /**
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9fdf982..0818c58 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -321,6 +321,8 @@ struct ieee80211_bss_conf {
  * @IEEE80211_TX_CTL_LDPC: tells the driver to use LDPC for this frame
  * @IEEE80211_TX_CTL_STBC: Enables Space-Time Block Coding (STBC) for this
  *	frame and selects the maximum number of streams that it can use.
+ * @IEEE80211_TX_CTL_TXBF_UPDATE: Channel information needs to be updated
+ *    for beamforming of Tx frames.
  *
  * Note: If you have to add new flags to the enumeration, then don't
  *	 forget to update %IEEE80211_TX_TEMPORARY_FLAGS when necessary.
@@ -349,6 +351,8 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_INTFL_NL80211_FRAME_TX	= BIT(21),
 	IEEE80211_TX_CTL_LDPC			= BIT(22),
 	IEEE80211_TX_CTL_STBC			= BIT(23) | BIT(24),
+	IEEE80211_TX_CTL_TXBF_UPDATE		= BIT(25),
+	IEEE80211_TX_CTL_STAG_SOUND		= BIT(26),
 };
 
 #define IEEE80211_TX_CTL_STBC_SHIFT		23
@@ -364,7 +368,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_STAT_AMPDU | IEEE80211_TX_STAT_AMPDU_NO_BACK |	      \
 	IEEE80211_TX_CTL_RATE_CTRL_PROBE | IEEE80211_TX_CTL_PSPOLL_RESPONSE | \
 	IEEE80211_TX_CTL_MORE_FRAMES | IEEE80211_TX_CTL_LDPC |		      \
-	IEEE80211_TX_CTL_STBC)
+	IEEE80211_TX_CTL_STBC | IEEE80211_TX_CTL_TXBF_UPDATE)
 
 /**
  * enum mac80211_rate_control_flags - per-rate flags set by the
@@ -900,7 +904,8 @@ struct ieee80211_sta {
 	u8 addr[ETH_ALEN];
 	u16 aid;
 	struct ieee80211_sta_ht_cap ht_cap;
-
+	bool txbf;
+	u8 channel_estimation_cap;
 	/* must be last */
 	u8 drv_priv[0] __attribute__((__aligned__(sizeof(void *))));
 };
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 18bd0e5..926cc8d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -698,6 +698,13 @@ static void sta_apply_parameters(struct ieee80211_local *local,
 						  params->ht_capa,
 						  &sta->sta.ht_cap);
 
+	if (sta->sta.ht_cap.explicit_compbf ||
+	    sta->sta.ht_cap.explicit_noncompbf ||
+	    sta->sta.ht_cap.implicit_bf) {
+		sta->sta.txbf = true;
+		sta->bf_update_cv = true;
+	}
+
 	if (ieee80211_vif_is_mesh(&sdata->vif) && params->plink_action) {
 		switch (params->plink_action) {
 		case PLINK_ACTION_OPEN:
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 75d679d..5223ea7 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -24,6 +24,7 @@ void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_supported_band *sband,
 {
 	u8 ampdu_info, tx_mcs_set_cap;
 	int i, max_tx_streams;
+	struct ieee80211_txbf_caps bfee, bfmr;
 
 	BUG_ON(!ht_cap);
 
@@ -99,6 +100,23 @@ void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_supported_band *sband,
 	/* handle MCS rate 32 too */
 	if (sband->ht_cap.mcs.rx_mask[32/8] & ht_cap_ie->mcs.rx_mask[32/8] & 1)
 		ht_cap->mcs.rx_mask[32/8] |= 1;
+
+	bfee = ht_cap_ie->tx_BF_cap_info;
+	bfmr = sband->ht_cap.txbf;
+
+	if (bfmr.explicit_comp_steering && (bfee.explicit_comp_bf != 0))
+		ht_cap->explicit_compbf = true;
+
+	if (bfmr.explicit_noncomp_steering && (bfee.explicit_noncomp_bf != 0))
+		ht_cap->explicit_noncompbf = true;
+
+	if (bfmr.implicit_txbf_capable && bfee.implicit_rx_capable)
+		ht_cap->implicit_bf = true;
+
+	if (bfmr.tx_staggered_sounding && bfee.rx_staggered_sounding)
+		ht_cap->staggered_sounding = true;
+
+	ht_cap->channel_estimation_cap = bfee.channel_estimation_cap;
 }
 
 void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta, bool tx)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index b80c386..e0eecbf 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1202,6 +1202,7 @@ void ieee80211_stop_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u8 tid);
 void ieee80211_ba_session_work(struct work_struct *work);
 void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid);
 void ieee80211_release_reorder_timeout(struct sta_info *sta, int tid);
+void ieee80211_txbf_cv_work(struct work_struct *work);
 
 /* Spectrum management */
 void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index a3a9421..0ee85f9 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -63,6 +63,8 @@
 #define TMR_RUNNING_TIMER	0
 #define TMR_RUNNING_CHANSW	1
 
+#define TXBF_CV_TIMER		1000
+
 /*
  * All cfg80211 functions have to be called outside a locked
  * section so that they can acquire a lock themselves... This
@@ -1237,6 +1239,17 @@ ieee80211_rx_mgmt_disassoc(struct ieee80211_sub_if_data *sdata,
 }
 
 
+void ieee80211_txbf_cv_work(struct work_struct *work)
+{
+	struct sta_info *sta =
+		container_of(work, struct sta_info, txbf_cv_work.work);
+	struct ieee80211_local *local = sta->local;
+
+	sta->bf_update_cv = true;
+	ieee80211_queue_delayed_work(&local->hw,
+				     &sta->txbf_cv_work, TXBF_CV_TIMER);
+}
+
 static bool ieee80211_assoc_success(struct ieee80211_work *wk,
 				    struct ieee80211_mgmt *mgmt, size_t len)
 {
@@ -1343,6 +1356,12 @@ static bool ieee80211_assoc_success(struct ieee80211_work *wk,
 
 	ap_ht_cap_flags = sta->sta.ht_cap.cap;
 
+	if (sta->sta.ht_cap.explicit_compbf ||
+	    sta->sta.ht_cap.explicit_noncompbf ||
+	    sta->sta.ht_cap.implicit_bf) {
+		sta->sta.txbf = true;
+		sta->bf_update_cv = true;
+	}
 	rate_control_rate_init(sta);
 
 	if (ifmgd->flags & IEEE80211_STA_MFP_ENABLED)
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 902b03e..a012fb6 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1455,6 +1455,16 @@ ieee80211_rx_h_remove_qos_control(struct ieee80211_rx_data *rx)
 	if (!ieee80211_is_data_qos(hdr->frame_control))
 		return RX_CONTINUE;
 
+	/* Qos frame with Order bit set indicates an HTC frame */
+	if (ieee80211_has_order(hdr->frame_control)) {
+		memmove(data + IEEE80211_QOS_HTC_LEN, data,
+			       ieee80211_hdrlen(hdr->frame_control) -
+			       IEEE80211_QOS_HTC_LEN);
+		hdr = (struct ieee80211_hdr *)skb_pull(rx->skb,
+						       IEEE80211_QOS_HTC_LEN);
+		hdr->frame_control &= ~cpu_to_le16(IEEE80211_FCTL_ORDER);
+	}
+
 	/* remove the qos control field, update frame type and meta-data */
 	memmove(data + IEEE80211_QOS_CTL_LEN, data,
 		ieee80211_hdrlen(hdr->frame_control) - IEEE80211_QOS_CTL_LEN);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 6d8f897..829398e 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -235,6 +235,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	spin_lock_init(&sta->flaglock);
 	INIT_WORK(&sta->drv_unblock_wk, sta_unblock);
 	INIT_WORK(&sta->ampdu_mlme.work, ieee80211_ba_session_work);
+	INIT_DELAYED_WORK(&sta->txbf_cv_work, ieee80211_txbf_cv_work);
 	mutex_init(&sta->ampdu_mlme.mtx);
 
 	memcpy(sta->sta.addr, addr, ETH_ALEN);
@@ -691,6 +692,7 @@ static int __must_check __sta_info_destroy(struct sta_info *sta)
 	wiphy_debug(local->hw.wiphy, "Removed STA %pM\n", sta->sta.addr);
 #endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
 	cancel_work_sync(&sta->drv_unblock_wk);
+	cancel_delayed_work_sync(&sta->txbf_cv_work);
 
 	rate_control_remove_sta_debugfs(sta);
 	ieee80211_sta_debugfs_remove(sta);
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 9265aca..61631e3 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -312,6 +312,12 @@ struct sta_info {
 	struct sta_ampdu_mlme ampdu_mlme;
 	u8 timer_to_tid[STA_TID_NUM];
 
+	bool txbf;
+	bool bf_update_cv;
+	bool bf_sound_pending;
+	bool allow_cv_update;
+	struct delayed_work txbf_cv_work;
+
 #ifdef CONFIG_MAC80211_MESH
 	/*
 	 * Mesh peer link attributes
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 3153c19..b0447ca 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -209,6 +209,25 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 			return;
 		}
 
+		if (ieee80211_has_order(fc)) {
+			if ((info->flags & IEEE80211_TX_STAT_ACK) &&
+			    (sta->bf_sound_pending)) {
+				sta->bf_sound_pending = false;
+				ieee80211_queue_delayed_work(&local->hw,
+						&sta->txbf_cv_work, 1000);
+			} else
+				sta->bf_update_cv = true;
+		}
+
+
+		if ((info->flags & IEEE80211_TX_CTL_TXBF_UPDATE) &&
+		    !(sta->bf_sound_pending)) {
+			if (sta->sta.ht_cap.explicit_compbf ||
+			    sta->sta.ht_cap.explicit_noncompbf ||
+			    sta->sta.ht_cap.implicit_bf)
+				sta->bf_update_cv = true;
+		}
+
 		if ((local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL) &&
 		    (rates_idx != -1))
 			sta->last_tx_rate = info->status.rates[rates_idx];
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 96c5943..5900cf2 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1888,6 +1888,8 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 	if ((sta_flags & WLAN_STA_WME) && local->hw.queues >= 4) {
 		fc |= cpu_to_le16(IEEE80211_STYPE_QOS_DATA);
 		hdrlen += 2;
+	if (sta->bf_update_cv)
+		hdrlen += 4;
 	}
 
 	/*
@@ -1973,9 +1975,28 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 
 	if (ieee80211_is_data_qos(fc)) {
 		__le16 *qos_control;
-
-		qos_control = (__le16*) skb_push(skb, 2);
-		memcpy(skb_push(skb, hdrlen - 2), &hdr, hdrlen - 2);
+		__le32 *htc;
+
+		if (sta->bf_update_cv) {
+			hdr.frame_control |= cpu_to_le16(IEEE80211_FCTL_ORDER);
+			htc = (__le32 *) skb_push(skb, 4);
+			sta->bf_sound_pending = true;
+			*htc = 0;
+			sta->bf_update_cv = false;
+
+			if (sta->sta.ht_cap.explicit_compbf)
+				*htc |= IEEE80211_HTC2_CSI_COMP_BF;
+			else if (sta->sta.ht_cap.explicit_noncompbf)
+				*htc |= IEEE80211_HTC2_CSI_NONCOMP_BF;
+
+			ieee80211_queue_delayed_work(&local->hw,
+					&sta->txbf_cv_work, 1000);
+			qos_control = (__le16 *) skb_push(skb, 2);
+			memcpy(skb_push(skb, hdrlen - 6), &hdr, hdrlen - 6);
+		} else {
+			qos_control = (__le16 *) skb_push(skb, 2);
+			memcpy(skb_push(skb, hdrlen - 2), &hdr, hdrlen - 2);
+		};
 		/*
 		 * Maybe we could actually set some fields here, for now just
 		 * initialise to zero to indicate no special operation.
diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index ae344d1..7676567 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -190,6 +190,7 @@ static void ieee80211_add_ht_ie(struct sk_buff *skb, const u8 *ht_info_ie,
 
 	/* extended capabilities */
 	pos += sizeof(__le16);
+	memcpy(pos, &sband->ht_cap.txbf, sizeof(sband->ht_cap.txbf));
 
 	/* BF capabilities */
 	pos += sizeof(__le32);
-- 
1.6.3.3

