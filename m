Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:35556 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932663Ab3FMI2i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Jun 2013 04:28:38 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, nbd@nbd.name,
	johannes@sipsolutions.net
Subject: [PATCH v2 1/2] mac80211: move tx_control_flag into flags2 within ieee80211_tx_info
Date: Thu, 13 Jun 2013 10:27:46 +0200
Message-Id: <1371112067-19239-1-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20130613_102847_291219_41B68BB0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All usable  bits in enum mac80211_tx_control_flags are depleted. In
order to allow aditional control flag assigments, we introduce a
new u16 variable ieee8011_tx_info->control.flags2 with its
corresponding enum mac80211_tx_control_flags2.
Flag IEEE80211_TX_CTL_REQ_TX_STATUS at bit(0) in mac80211_tx_control_flags
is moved to ieee80211_tx_info->control.flags2 as it is only used in the
tx-path. This frees one bit in ieee80211_tx_info->flags.

Signed-off-by: Benjamin Vahl <bvahl@net.t-labs.tu-berlin.de>
Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
 drivers/net/wireless/ath/carl9170/tx.c |    2 +-
 drivers/net/wireless/mac80211_hwsim.c  |    2 +-
 drivers/net/wireless/ti/wl1251/tx.c    |    4 ++--
 include/net/mac80211.h                 |   22 ++++++++++++++++++----
 net/mac80211/agg-tx.c                  |    4 ++--
 net/mac80211/cfg.c                     |   13 ++++++++-----
 net/mac80211/ht.c                      |    2 +-
 net/mac80211/ibss.c                    |    4 ++--
 net/mac80211/ieee80211_i.h             |    2 +-
 net/mac80211/mesh_ps.c                 |    6 +++---
 net/mac80211/mlme.c                    |   30 ++++++++++++++++++------------
 net/mac80211/sta_info.c                |    8 ++++----
 net/mac80211/status.c                  |    2 +-
 net/mac80211/tx.c                      |    8 +++++---
 net/mac80211/util.c                    |    3 ++-
 15 files changed, 69 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index d21c81d..10250a7 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -298,7 +298,7 @@ static void carl9170_tx_release(struct kref *ref)
 			txinfo->status.ampdu_len = super->s.rix;
 			txinfo->status.ampdu_ack_len = super->s.cnt;
 		} else if ((txinfo->flags & IEEE80211_TX_STAT_ACK) &&
-			   !(txinfo->flags & IEEE80211_TX_CTL_REQ_TX_STATUS)) {
+			   !(txinfo->control.flags2 & IEEE80211_TX_CTL2_REQ_TX_STATUS)) {
 			/*
 			 * drop redundant tx_status reports:
 			 *
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index cb34c78..8c03f3b 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -642,7 +642,7 @@ static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
 	/* We get the flags for this transmission, and we translate them to
 	   wmediumd flags  */
 
-	if (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS)
+	if (info->control.flags2 & IEEE80211_TX_CTL2_REQ_TX_STATUS)
 		hwsim_flags |= HWSIM_TX_CTL_REQ_TX_STATUS;
 
 	if (info->flags & IEEE80211_TX_CTL_NO_ACK)
diff --git a/drivers/net/wireless/ti/wl1251/tx.c b/drivers/net/wireless/ti/wl1251/tx.c
index 28121c5..78a3fff 100644
--- a/drivers/net/wireless/ti/wl1251/tx.c
+++ b/drivers/net/wireless/ti/wl1251/tx.c
@@ -540,7 +540,7 @@ void wl1251_tx_flush(struct wl1251 *wl)
 
 		wl1251_debug(DEBUG_TX, "flushing skb 0x%p", skb);
 
-		if (!(info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS))
+		if (!(info->control.flags2 & IEEE80211_TX_CTL2_REQ_TX_STATUS))
 				continue;
 
 		ieee80211_tx_status(wl->hw, skb);
@@ -551,7 +551,7 @@ void wl1251_tx_flush(struct wl1251 *wl)
 			skb = wl->tx_frames[i];
 			info = IEEE80211_SKB_CB(skb);
 
-			if (!(info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS))
+			if (!(info->control.flags2 & IEEE80211_TX_CTL2_REQ_TX_STATUS))
 				continue;
 
 			ieee80211_tx_status(wl->hw, skb);
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index a405a7a..447c95a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -374,7 +374,6 @@ struct ieee80211_bss_conf {
  *
  * These flags are used with the @flags member of &ieee80211_tx_info.
  *
- * @IEEE80211_TX_CTL_REQ_TX_STATUS: require TX status callback for this frame.
  * @IEEE80211_TX_CTL_ASSIGN_SEQ: The driver has to assign a sequence
  *	number to this frame, taking care of not overwriting the fragment
  *	number and increasing the sequence number only when the
@@ -467,7 +466,6 @@ struct ieee80211_bss_conf {
  *	 forget to update %IEEE80211_TX_TEMPORARY_FLAGS when necessary.
  */
 enum mac80211_tx_control_flags {
-	IEEE80211_TX_CTL_REQ_TX_STATUS		= BIT(0),
 	IEEE80211_TX_CTL_ASSIGN_SEQ		= BIT(1),
 	IEEE80211_TX_CTL_NO_ACK			= BIT(2),
 	IEEE80211_TX_CTL_CLEAR_PS_FILT		= BIT(3),
@@ -500,6 +498,20 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_PS_RESPONSE		= BIT(31),
 };
 
+/**
+ * enum mac80211_tx_control_flags2 - control related flags to describe transmission information/status
+ *
+ * These flags are used with the @flags2 member of &ieee80211_tx_info inside control
+ * and are only available within the tx path where tx_info->control is valid.
+ *
+ * @IEEE80211_TX_CTL2_REQ_TX_STATUS: require TX status callback for this frame.
+ */
+enum mac80211_tx_control_flags2 {
+	IEEE80211_TX_CTL2_REQ_TX_STATUS		= BIT(0),
+};
+
+
+
 #define IEEE80211_TX_CTL_STBC_SHIFT		23
 
 /*
@@ -675,7 +687,9 @@ struct ieee80211_tx_info {
 			/* NB: vif can be NULL for injected frames */
 			struct ieee80211_vif *vif;
 			struct ieee80211_key_conf *hw_key;
-			/* 8 bytes free */
+
+			u16 flags2;
+			/* 6 bytes free */
 		} control;
 		struct {
 			struct ieee80211_tx_rate rates[IEEE80211_TX_MAX_RATES];
@@ -1973,7 +1987,7 @@ void ieee80211_free_txskb(struct ieee80211_hw *hw, struct sk_buff *skb);
  * on each frame. The last frame in the service period (or the only
  * response to a PS-Poll) also has %IEEE80211_TX_STATUS_EOSP set to
  * indicate that it ends the service period; as this frame must have
- * TX status report it also sets %IEEE80211_TX_CTL_REQ_TX_STATUS.
+ * TX status report it also sets %IEEE80211_TX_CTL2_REQ_TX_STATUS.
  * When TX status is reported for this frame, the service period is
  * marked has having ended and a new one can be started by the peer.
  *
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 13b7683..5b27f64 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -135,8 +135,8 @@ void ieee80211_send_bar(struct ieee80211_vif *vif, u8 *ra, u16 tid, u16 ssn)
 	bar->control = cpu_to_le16(bar_control);
 	bar->start_seq_num = cpu_to_le16(ssn);
 
-	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT |
-					IEEE80211_TX_CTL_REQ_TX_STATUS;
+	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
+	IEEE80211_SKB_CB(skb)->control.flags2 |= IEEE80211_TX_CTL2_REQ_TX_STATUS;
 	ieee80211_tx_skb_tid(sdata, skb, tid);
 }
 EXPORT_SYMBOL(ieee80211_send_bar);
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 64cf294..d15a6cb 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2790,13 +2790,15 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	const struct ieee80211_mgmt *mgmt = (void *)buf;
 	bool need_offchan = false;
 	u32 flags;
+	u16 flags2;
 	int ret;
 
 	if (dont_wait_for_ack)
 		flags = IEEE80211_TX_CTL_NO_ACK;
-	else
-		flags = IEEE80211_TX_INTFL_NL80211_FRAME_TX |
-			IEEE80211_TX_CTL_REQ_TX_STATUS;
+	else {
+		flags = IEEE80211_TX_INTFL_NL80211_FRAME_TX;
+		flags2 = IEEE80211_TX_CTL2_REQ_TX_STATUS;
+	}
 
 	if (no_cck)
 		flags |= IEEE80211_TX_CTL_NO_CCK_RATE;
@@ -2883,6 +2885,7 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	memcpy(skb_put(skb, len), buf, len);
 
 	IEEE80211_SKB_CB(skb)->flags = flags;
+	IEEE80211_SKB_CB(skb)->control.flags2 = flags2;
 
 	skb->dev = sdata->dev;
 
@@ -3375,8 +3378,8 @@ static int ieee80211_probe_client(struct wiphy *wiphy, struct net_device *dev,
 
 	info = IEEE80211_SKB_CB(skb);
 
-	info->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS |
-		       IEEE80211_TX_INTFL_NL80211_FRAME_TX;
+	info->flags |= IEEE80211_TX_INTFL_NL80211_FRAME_TX;
+	info->control.flags2 |= IEEE80211_TX_CTL2_REQ_TX_STATUS;
 
 	skb_set_queue_mapping(skb, IEEE80211_AC_VO);
 	skb->priority = 7;
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 75dff33..192aa0a 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -417,7 +417,7 @@ int ieee80211_send_smps_action(struct ieee80211_sub_if_data *sdata,
 	}
 
 	/* we'll do more on status of this frame */
-	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
+	IEEE80211_SKB_CB(skb)->control.flags2 |= IEEE80211_TX_CTL2_REQ_TX_STATUS;
 	ieee80211_tx_skb(sdata, skb);
 
 	return 0;
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index caa4b4f..eada676 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -326,7 +326,7 @@ static struct sta_info *ieee80211_ibss_finish_sta(struct sta_info *sta,
 			 "TX Auth SA=%pM DA=%pM BSSID=%pM (auth_transaction=1)\n",
 			 sdata->vif.addr, addr, sdata->u.ibss.bssid);
 		ieee80211_send_auth(sdata, 1, WLAN_AUTH_OPEN, 0, NULL, 0,
-				    addr, sdata->u.ibss.bssid, NULL, 0, 0, 0);
+				    addr, sdata->u.ibss.bssid, NULL, 0, 0, 0, 0);
 	}
 	return sta;
 }
@@ -448,7 +448,7 @@ static void ieee80211_rx_mgmt_auth_ibss(struct ieee80211_sub_if_data *sdata,
 	 * has actually implemented this.
 	 */
 	ieee80211_send_auth(sdata, 2, WLAN_AUTH_OPEN, 0, NULL, 0,
-			    mgmt->sa, sdata->u.ibss.bssid, NULL, 0, 0, 0);
+			    mgmt->sa, sdata->u.ibss.bssid, NULL, 0, 0, 0, 0);
 }
 
 static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 7a6f1a0..f999bfe 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1561,7 +1561,7 @@ void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 			 u16 transaction, u16 auth_alg, u16 status,
 			 const u8 *extra, size_t extra_len, const u8 *bssid,
 			 const u8 *da, const u8 *key, u8 key_len, u8 key_idx,
-			 u32 tx_flags);
+			 u32 tx_flags, u16 tx_flags2);
 void ieee80211_send_deauth_disassoc(struct ieee80211_sub_if_data *sdata,
 				    const u8 *bssid, u16 stype, u16 reason,
 				    bool send_frame, u8 *frame_buf);
diff --git a/net/mac80211/mesh_ps.c b/net/mac80211/mesh_ps.c
index 3b7bfc0..f2b658f 100644
--- a/net/mac80211/mesh_ps.c
+++ b/net/mac80211/mesh_ps.c
@@ -384,8 +384,8 @@ static void mpsp_trigger_send(struct sta_info *sta, bool rspi, bool eosp)
 
 	info = IEEE80211_SKB_CB(skb);
 
-	info->flags |= IEEE80211_TX_CTL_NO_PS_BUFFER |
-		       IEEE80211_TX_CTL_REQ_TX_STATUS;
+	info->flags |= IEEE80211_TX_CTL_NO_PS_BUFFER;
+	info->control.flags2 |= IEEE80211_TX_CTL2_REQ_TX_STATUS;
 
 	mps_dbg(sdata, "sending MPSP trigger%s%s to %pM\n",
 		rspi ? " RSPI" : "", eosp ? " EOSP" : "", sta->sta.addr);
@@ -508,7 +508,7 @@ static void mps_frame_deliver(struct sta_info *sta, int n_frames)
 
 			/* MPSP trigger frame ends service period */
 			*qoshdr |= IEEE80211_QOS_CTL_EOSP;
-			info->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
+			info->control.flags2 |= IEEE80211_TX_CTL2_REQ_TX_STATUS;
 		}
 	}
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index ad9bb9e..0ab0226 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -839,9 +839,10 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 	drv_mgd_prepare_tx(local, sdata);
 
 	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
-	if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
-		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS |
-						IEEE80211_TX_INTFL_MLME_CONN_TX;
+	if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) {
+		IEEE80211_SKB_CB(skb)->control.flags2 |= IEEE80211_TX_CTL2_REQ_TX_STATUS;
+		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_MLME_CONN_TX;
+	}
 	ieee80211_tx_skb(sdata, skb);
 }
 
@@ -882,7 +883,8 @@ void ieee80211_send_nullfunc(struct ieee80211_local *local,
 					IEEE80211_TX_INTFL_OFFCHAN_TX_OK;
 
 	if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
-		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
+		IEEE80211_SKB_CB(skb)->control.flags2 |=
+			IEEE80211_TX_CTL2_REQ_TX_STATUS;
 
 	if (ifmgd->flags & (IEEE80211_STA_BEACON_POLL |
 			    IEEE80211_STA_CONNECTION_POLL))
@@ -2249,6 +2251,7 @@ static void ieee80211_auth_challenge(struct ieee80211_sub_if_data *sdata,
 	u8 *pos;
 	struct ieee802_11_elems elems;
 	u32 tx_flags = 0;
+	u16 tx_flags2 = 0;
 
 	pos = mgmt->u.auth.variable;
 	ieee802_11_parse_elems(pos, len - (pos - (u8 *) mgmt), false, &elems);
@@ -2256,14 +2259,15 @@ static void ieee80211_auth_challenge(struct ieee80211_sub_if_data *sdata,
 		return;
 	auth_data->expected_transaction = 4;
 	drv_mgd_prepare_tx(sdata->local, sdata);
-	if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
-		tx_flags = IEEE80211_TX_CTL_REQ_TX_STATUS |
-			   IEEE80211_TX_INTFL_MLME_CONN_TX;
+	if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) {
+		tx_flags2 = IEEE80211_TX_CTL2_REQ_TX_STATUS;
+		tx_flags = IEEE80211_TX_INTFL_MLME_CONN_TX;
+	}
 	ieee80211_send_auth(sdata, 3, auth_data->algorithm, 0,
 			    elems.challenge - 2, elems.challenge_len + 2,
 			    auth_data->bss->bssid, auth_data->bss->bssid,
 			    auth_data->key, auth_data->key_len,
-			    auth_data->key_idx, tx_flags);
+			    auth_data->key_idx, tx_flags, tx_flags2);
 }
 
 static void ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
@@ -3237,6 +3241,7 @@ static int ieee80211_probe_auth(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_mgd_auth_data *auth_data = ifmgd->auth_data;
 	u32 tx_flags = 0;
+	u16 tx_flags2 = 0;
 
 	sdata_assert_lock(sdata);
 
@@ -3276,15 +3281,16 @@ static int ieee80211_probe_auth(struct ieee80211_sub_if_data *sdata)
 			auth_data->expected_transaction = trans;
 		}
 
-		if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
-			tx_flags = IEEE80211_TX_CTL_REQ_TX_STATUS |
-				   IEEE80211_TX_INTFL_MLME_CONN_TX;
+		if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS){
+			tx_flags = IEEE80211_TX_INTFL_MLME_CONN_TX;
+			tx_flags2 = IEEE80211_TX_CTL2_REQ_TX_STATUS;
+		}
 
 		ieee80211_send_auth(sdata, trans, auth_data->algorithm, status,
 				    auth_data->data, auth_data->data_len,
 				    auth_data->bss->bssid,
 				    auth_data->bss->bssid, NULL, 0, 0,
-				    tx_flags);
+				    tx_flags, tx_flags2);
 	} else {
 		const u8 *ssidie;
 
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index b429798..9160b8c 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1133,8 +1133,8 @@ static void ieee80211_send_null_response(struct ieee80211_sub_if_data *sdata,
 	 */
 	info->flags |= IEEE80211_TX_CTL_NO_PS_BUFFER |
 		       IEEE80211_TX_CTL_PS_RESPONSE |
-		       IEEE80211_TX_STATUS_EOSP |
-		       IEEE80211_TX_CTL_REQ_TX_STATUS;
+		       IEEE80211_TX_STATUS_EOSP;
+	info->control.flags2 |= IEEE80211_TX_CTL2_REQ_TX_STATUS;
 
 	drv_allow_buffered_frames(local, sta, BIT(tid), 1, reason, false);
 
@@ -1294,8 +1294,8 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 				    qoshdr)
 					*qoshdr |= IEEE80211_QOS_CTL_EOSP;
 
-				info->flags |= IEEE80211_TX_STATUS_EOSP |
-					       IEEE80211_TX_CTL_REQ_TX_STATUS;
+				info->flags |= IEEE80211_TX_STATUS_EOSP;
+				info->control.flags2 |= IEEE80211_TX_CTL2_REQ_TX_STATUS;
 			}
 
 			if (qoshdr)
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 4343920..8298a7c 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -28,7 +28,7 @@ void ieee80211_tx_status_irqsafe(struct ieee80211_hw *hw,
 	int tmp;
 
 	skb->pkt_type = IEEE80211_TX_STATUS_MSG;
-	skb_queue_tail(info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS ?
+	skb_queue_tail(info->control.flags2 & IEEE80211_TX_CTL2_REQ_TX_STATUS ?
 		       &local->skb_queue : &local->skb_queue_unreliable, skb);
 	tmp = skb_queue_len(&local->skb_queue) +
 		skb_queue_len(&local->skb_queue_unreliable);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 4105d0c..63e96ba 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1609,8 +1609,8 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 
 	memset(info, 0, sizeof(*info));
 
-	info->flags = IEEE80211_TX_CTL_REQ_TX_STATUS |
-		      IEEE80211_TX_CTL_INJECTED;
+	info->flags = IEEE80211_TX_CTL_INJECTED;
+	info->control.flags2 = IEEE80211_TX_CTL2_REQ_TX_STATUS;
 
 	/* process and remove the injection radiotap header */
 	if (!ieee80211_parse_tx_radiotap(skb))
@@ -1723,6 +1723,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 	bool tdls_direct = false;
 	bool multicast;
 	u32 info_flags = 0;
+	u16 info_flags2 = 0;
 	u16 info_id = 0;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct ieee80211_sub_if_data *ap_sdata;
@@ -1988,7 +1989,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 
 			if (id >= 0) {
 				info_id = id;
-				info_flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
+				info_flags2 |= IEEE80211_TX_CTL2_REQ_TX_STATUS;
 			} else if (skb_shared(skb)) {
 				kfree_skb(orig_skb);
 			} else {
@@ -2113,6 +2114,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 	dev->trans_start = jiffies;
 
 	info->flags = info_flags;
+	info->control.flags2 = info_flags2;
 	info->ack_frame_id = info_id;
 
 	ieee80211_xmit(sdata, skb, band);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 5a6c135..06721b5 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1082,7 +1082,7 @@ void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 			 u16 transaction, u16 auth_alg, u16 status,
 			 const u8 *extra, size_t extra_len, const u8 *da,
 			 const u8 *bssid, const u8 *key, u8 key_len, u8 key_idx,
-			 u32 tx_flags)
+			 u32 tx_flags, u16 tx_flags2)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
@@ -1117,6 +1117,7 @@ void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 
 	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT |
 					tx_flags;
+	IEEE80211_SKB_CB(skb)->control.flags2 |= tx_flags2;
 	ieee80211_tx_skb(sdata, skb);
 }
 
-- 
1.7.9.5

