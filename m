Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:57608 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757034Ab3FGSO0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jun 2013 14:14:26 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, nbd@nbd.name,
	johannes@sipsolutions.net, bvahl@net.t-labs.tu-berlin.de
Subject: [PATCH 2/3] mac80211: move flag IEEE80211_TX_CTL_REQ_TX_STATUS from flag to flags2
Date: Fri,  7 Jun 2013 20:13:22 +0200
Message-Id: <1370628803-28785-3-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20130607_201441_035196_75DBDE7D)
In-Reply-To: <1370628803-28785-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1370628803-28785-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Flag IEEE80211_TX_CTL_REQ_TX_STATUS at bit(0) in mac80211_tx_control_flags
is moved to ieee80211_tx_info->control.flags2 as it is only used in the
tx-path. This frees one bit in ieee80211_tx_info->flags.

Signed-off-by: Benjamin Vahl <bvahl@net.t-labs.tu-berlin.de>
Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
 drivers/net/wireless/ath/carl9170/tx.c |    2 +-
 drivers/net/wireless/mac80211_hwsim.c  |    2 +-
 drivers/net/wireless/ti/wl1251/tx.c    |    4 ++--
 include/net/mac80211.h                 |    9 +++++++--
 net/mac80211/agg-tx.c                  |    4 ++--
 net/mac80211/cfg.c                     |   13 ++++++++-----
 net/mac80211/ht.c                      |    2 +-
 net/mac80211/mesh_ps.c                 |    6 +++---
 net/mac80211/mlme.c                    |    7 ++++---
 net/mac80211/sta_info.c                |    8 ++++----
 net/mac80211/status.c                  |    2 +-
 net/mac80211/tx.c                      |    8 +++++---
 12 files changed, 39 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index c61cafa..6ee8c26 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -297,7 +297,7 @@ static void carl9170_tx_release(struct kref *ref)
 			txinfo->status.ampdu_len = super->s.rix;
 			txinfo->status.ampdu_ack_len = super->s.cnt;
 		} else if ((txinfo->flags & IEEE80211_TX_STAT_ACK) &&
-			   !(txinfo->flags & IEEE80211_TX_CTL_REQ_TX_STATUS)) {
+			   !(txinfo->control.flags2 & IEEE80211_TX_CTL_REQ_TX_STATUS)) {
 			/*
 			 * drop redundant tx_status reports:
 			 *
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index cb34c78..e6afe01 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -642,7 +642,7 @@ static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
 	/* We get the flags for this transmission, and we translate them to
 	   wmediumd flags  */
 
-	if (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS)
+	if (info->control.flags2 & IEEE80211_TX_CTL_REQ_TX_STATUS)
 		hwsim_flags |= HWSIM_TX_CTL_REQ_TX_STATUS;
 
 	if (info->flags & IEEE80211_TX_CTL_NO_ACK)
diff --git a/drivers/net/wireless/ti/wl1251/tx.c b/drivers/net/wireless/ti/wl1251/tx.c
index 28121c5..f7192ee 100644
--- a/drivers/net/wireless/ti/wl1251/tx.c
+++ b/drivers/net/wireless/ti/wl1251/tx.c
@@ -540,7 +540,7 @@ void wl1251_tx_flush(struct wl1251 *wl)
 
 		wl1251_debug(DEBUG_TX, "flushing skb 0x%p", skb);
 
-		if (!(info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS))
+		if (!(info->control.flags2 & IEEE80211_TX_CTL_REQ_TX_STATUS))
 				continue;
 
 		ieee80211_tx_status(wl->hw, skb);
@@ -551,7 +551,7 @@ void wl1251_tx_flush(struct wl1251 *wl)
 			skb = wl->tx_frames[i];
 			info = IEEE80211_SKB_CB(skb);
 
-			if (!(info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS))
+			if (!(info->control.flags2 & IEEE80211_TX_CTL_REQ_TX_STATUS))
 				continue;
 
 			ieee80211_tx_status(wl->hw, skb);
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 2d8e461..6c31a92 100644
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
@@ -467,7 +466,10 @@ struct ieee80211_bss_conf {
  *	 forget to update %IEEE80211_TX_TEMPORARY_FLAGS when necessary.
  */
 enum mac80211_tx_control_flags {
-	IEEE80211_TX_CTL_REQ_TX_STATUS		= BIT(0),
+	/*
+	 * moved to flags2:
+	 * IEEE80211_TX_CTL_REQ_TX_STATUS		= BIT(0),
+	 */
 	IEEE80211_TX_CTL_ASSIGN_SEQ		= BIT(1),
 	IEEE80211_TX_CTL_NO_ACK			= BIT(2),
 	IEEE80211_TX_CTL_CLEAR_PS_FILT		= BIT(3),
@@ -505,8 +507,11 @@ enum mac80211_tx_control_flags {
  *
  * These flags are used with the @flags2 member of &ieee80211_tx_info inside control
  * and are only available within the tx path where tx_info->control is valid.
+ *
+ * @IEEE80211_TX_CTL_REQ_TX_STATUS: require TX status callback for this frame.
  */
 enum mac80211_tx_control_flags2 {
+	IEEE80211_TX_CTL_REQ_TX_STATUS		= BIT(0),
 };
 
 #define IEEE80211_TX_CTL_STBC_SHIFT		23
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 13b7683..890447f 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -135,8 +135,8 @@ void ieee80211_send_bar(struct ieee80211_vif *vif, u8 *ra, u16 tid, u16 ssn)
 	bar->control = cpu_to_le16(bar_control);
 	bar->start_seq_num = cpu_to_le16(ssn);
 
-	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT |
-					IEEE80211_TX_CTL_REQ_TX_STATUS;
+	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
+	IEEE80211_SKB_CB(skb)->control.flags2 |= IEEE80211_TX_CTL_REQ_TX_STATUS;
 	ieee80211_tx_skb_tid(sdata, skb, tid);
 }
 EXPORT_SYMBOL(ieee80211_send_bar);
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 3062210..207e54d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2787,13 +2787,15 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
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
+		flags2 = IEEE80211_TX_CTL_REQ_TX_STATUS;
+	}
 
 	if (no_cck)
 		flags |= IEEE80211_TX_CTL_NO_CCK_RATE;
@@ -2869,6 +2871,7 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	memcpy(skb_put(skb, len), buf, len);
 
 	IEEE80211_SKB_CB(skb)->flags = flags;
+	IEEE80211_SKB_CB(skb)->control.flags2 = flags2;
 
 	skb->dev = sdata->dev;
 
@@ -3361,8 +3364,8 @@ static int ieee80211_probe_client(struct wiphy *wiphy, struct net_device *dev,
 
 	info = IEEE80211_SKB_CB(skb);
 
-	info->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS |
-		       IEEE80211_TX_INTFL_NL80211_FRAME_TX;
+	info->flags |= IEEE80211_TX_INTFL_NL80211_FRAME_TX;
+	info->control.flags2 |= IEEE80211_TX_CTL_REQ_TX_STATUS;
 
 	skb_set_queue_mapping(skb, IEEE80211_AC_VO);
 	skb->priority = 7;
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 75dff33..f34af5e 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -417,7 +417,7 @@ int ieee80211_send_smps_action(struct ieee80211_sub_if_data *sdata,
 	}
 
 	/* we'll do more on status of this frame */
-	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
+	IEEE80211_SKB_CB(skb)->control.flags2 |= IEEE80211_TX_CTL_REQ_TX_STATUS;
 	ieee80211_tx_skb(sdata, skb);
 
 	return 0;
diff --git a/net/mac80211/mesh_ps.c b/net/mac80211/mesh_ps.c
index 3b7bfc0..9cd9e8e 100644
--- a/net/mac80211/mesh_ps.c
+++ b/net/mac80211/mesh_ps.c
@@ -384,8 +384,8 @@ static void mpsp_trigger_send(struct sta_info *sta, bool rspi, bool eosp)
 
 	info = IEEE80211_SKB_CB(skb);
 
-	info->flags |= IEEE80211_TX_CTL_NO_PS_BUFFER |
-		       IEEE80211_TX_CTL_REQ_TX_STATUS;
+	info->flags |= IEEE80211_TX_CTL_NO_PS_BUFFER;
+	info->control.flags2 |= IEEE80211_TX_CTL_REQ_TX_STATUS;
 
 	mps_dbg(sdata, "sending MPSP trigger%s%s to %pM\n",
 		rspi ? " RSPI" : "", eosp ? " EOSP" : "", sta->sta.addr);
@@ -508,7 +508,7 @@ static void mps_frame_deliver(struct sta_info *sta, int n_frames)
 
 			/* MPSP trigger frame ends service period */
 			*qoshdr |= IEEE80211_QOS_CTL_EOSP;
-			info->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
+			info->control.flags2 |= IEEE80211_TX_CTL_REQ_TX_STATUS;
 		}
 	}
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index ad9bb9e..f1ac7eb 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -839,9 +839,10 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 	drv_mgd_prepare_tx(local, sdata);
 
 	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
-	if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
-		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS |
-						IEEE80211_TX_INTFL_MLME_CONN_TX;
+	if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) {
+		IEEE80211_SKB_CB(skb)->control.flags2 |= IEEE80211_TX_CTL_REQ_TX_STATUS;
+		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_MLME_CONN_TX;
+	}
 	ieee80211_tx_skb(sdata, skb);
 }
 
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index b429798..bf841f2 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1133,8 +1133,8 @@ static void ieee80211_send_null_response(struct ieee80211_sub_if_data *sdata,
 	 */
 	info->flags |= IEEE80211_TX_CTL_NO_PS_BUFFER |
 		       IEEE80211_TX_CTL_PS_RESPONSE |
-		       IEEE80211_TX_STATUS_EOSP |
-		       IEEE80211_TX_CTL_REQ_TX_STATUS;
+		       IEEE80211_TX_STATUS_EOSP;
+	info->control.flags2 |= IEEE80211_TX_CTL_REQ_TX_STATUS;
 
 	drv_allow_buffered_frames(local, sta, BIT(tid), 1, reason, false);
 
@@ -1294,8 +1294,8 @@ ieee80211_sta_ps_deliver_response(struct sta_info *sta,
 				    qoshdr)
 					*qoshdr |= IEEE80211_QOS_CTL_EOSP;
 
-				info->flags |= IEEE80211_TX_STATUS_EOSP |
-					       IEEE80211_TX_CTL_REQ_TX_STATUS;
+				info->flags |= IEEE80211_TX_STATUS_EOSP;
+				info->control.flags2 |= IEEE80211_TX_CTL_REQ_TX_STATUS;
 			}
 
 			if (qoshdr)
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 4343920..42bcd77 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -28,7 +28,7 @@ void ieee80211_tx_status_irqsafe(struct ieee80211_hw *hw,
 	int tmp;
 
 	skb->pkt_type = IEEE80211_TX_STATUS_MSG;
-	skb_queue_tail(info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS ?
+	skb_queue_tail(info->control.flags2 & IEEE80211_TX_CTL_REQ_TX_STATUS ?
 		       &local->skb_queue : &local->skb_queue_unreliable, skb);
 	tmp = skb_queue_len(&local->skb_queue) +
 		skb_queue_len(&local->skb_queue_unreliable);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 4105d0c..b1fe9b5 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1609,8 +1609,8 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 
 	memset(info, 0, sizeof(*info));
 
-	info->flags = IEEE80211_TX_CTL_REQ_TX_STATUS |
-		      IEEE80211_TX_CTL_INJECTED;
+	info->flags = IEEE80211_TX_CTL_INJECTED;
+	info->control.flags2 = IEEE80211_TX_CTL_REQ_TX_STATUS;
 
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
+				info_flags2 |= IEEE80211_TX_CTL_REQ_TX_STATUS;
 			} else if (skb_shared(skb)) {
 				kfree_skb(orig_skb);
 			} else {
@@ -2113,6 +2114,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 	dev->trans_start = jiffies;
 
 	info->flags = info_flags;
+	info->control.flags2 = info_flags2;
 	info->ack_frame_id = info_id;
 
 	ieee80211_xmit(sdata, skb, band);
-- 
1.7.9.5

