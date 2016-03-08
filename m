Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15786 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbcCHR1o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2016 12:27:44 -0500
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@codeaurora.org>,
	"Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>
Subject: [PATCH] ath10k: handle channel change htt event
Date: Tue, 8 Mar 2016 22:57:23 +0530
Message-ID: <1457458043-9593-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20160308_182750_169031_0D247E78)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Whenever firmware is configuring operating channel during scan or
home channel, channel change event will be indicated to host. In some
cases (device probe/ last vdev down), target will be configured to
default channel whereas host is unaware of target's operating channel.
This leads to packet drop due to unknown channel and kernel log will be
filled up with "no channel configured; ignoring frame(s)!". Fix that
by handling HTT_T2H_MSG_TYPE_CHAN_CHANGE event.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.h   |  3 +++
 drivers/net/wireless/ath/ath10k/htt.h    |  9 +++++++
 drivers/net/wireless/ath/ath10k/htt_rx.c | 41 +++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi.c    | 28 ----------------------
 4 files changed, 52 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 23ba03f..bb5f7e2 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -766,6 +766,9 @@ struct ath10k {
 	/* current operating channel definition */
 	struct cfg80211_chan_def chandef;
 
+	/* currently configured operating channel in firmware */
+	struct ieee80211_channel *tgt_oper_chan;
+
 	unsigned long long free_vdev_map;
 	struct ath10k_vif *monitor_arvif;
 	bool monitor;
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 751f6be..d196bcc 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1461,6 +1461,14 @@ struct htt_tx_mode_switch_ind {
 	struct htt_tx_mode_switch_record records[0];
 } __packed;
 
+struct htt_channel_change {
+	u8 pad[3];
+	__le32 freq;
+	__le32 center_freq1;
+	__le32 center_freq2;
+	__le32 phymode;
+} __packed;
+
 union htt_rx_pn_t {
 	/* WEP: 24-bit PN */
 	u32 pn24;
@@ -1511,6 +1519,7 @@ struct htt_resp {
 		struct htt_tx_fetch_ind tx_fetch_ind;
 		struct htt_tx_fetch_confirm tx_fetch_confirm;
 		struct htt_tx_mode_switch_ind tx_mode_switch_ind;
+		struct htt_channel_change chan_change;
 	};
 } __packed;
 
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index a573343..0ecd5a6 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -862,6 +862,8 @@ static bool ath10k_htt_rx_h_channel(struct ath10k *ar,
 		ch = ath10k_htt_rx_h_vdev_channel(ar, vdev_id);
 	if (!ch)
 		ch = ath10k_htt_rx_h_any_channel(ar);
+	if (!ch)
+		ch = ar->tgt_oper_chan;
 	spin_unlock_bh(&ar->data_lock);
 
 	if (!ch)
@@ -2259,6 +2261,34 @@ static void ath10k_htt_rx_tx_mode_switch_ind(struct ath10k *ar,
 	ath10k_mac_tx_push_pending(ar);
 }
 
+static inline enum ieee80211_band phy_mode_to_band(u32 phy_mode)
+{
+	enum ieee80211_band band;
+
+	switch (phy_mode) {
+	case MODE_11A:
+	case MODE_11NA_HT20:
+	case MODE_11NA_HT40:
+	case MODE_11AC_VHT20:
+	case MODE_11AC_VHT40:
+	case MODE_11AC_VHT80:
+		band = IEEE80211_BAND_5GHZ;
+		break;
+	case MODE_11G:
+	case MODE_11B:
+	case MODE_11GONLY:
+	case MODE_11NG_HT20:
+	case MODE_11NG_HT40:
+	case MODE_11AC_VHT20_2G:
+	case MODE_11AC_VHT40_2G:
+	case MODE_11AC_VHT80_2G:
+	default:
+		band = IEEE80211_BAND_2GHZ;
+	}
+
+	return band;
+}
+
 void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct ath10k_htt *htt = &ar->htt;
@@ -2398,8 +2428,17 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 	}
 	case HTT_T2H_MSG_TYPE_TX_CREDIT_UPDATE_IND:
 		break;
-	case HTT_T2H_MSG_TYPE_CHAN_CHANGE:
+	case HTT_T2H_MSG_TYPE_CHAN_CHANGE: {
+		u32 phymode = __le32_to_cpu(resp->chan_change.phymode);
+		u32 freq = __le32_to_cpu(resp->chan_change.freq);
+
+		ar->tgt_oper_chan =
+			__ieee80211_get_channel(ar->hw->wiphy, freq);
+		ath10k_dbg(ar, ATH10K_DBG_HTT,
+			   "htt chan change freq %u phymode %s\n",
+			   freq, ath10k_wmi_phymode_str(phymode));
 		break;
+	}
 	case HTT_T2H_MSG_TYPE_AGGR_CONF:
 		break;
 	case HTT_T2H_MSG_TYPE_TX_FETCH_IND:
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index c31b487..8d67ab5 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2099,34 +2099,6 @@ int ath10k_wmi_event_scan(struct ath10k *ar, struct sk_buff *skb)
 	return 0;
 }
 
-static inline enum ieee80211_band phy_mode_to_band(u32 phy_mode)
-{
-	enum ieee80211_band band;
-
-	switch (phy_mode) {
-	case MODE_11A:
-	case MODE_11NA_HT20:
-	case MODE_11NA_HT40:
-	case MODE_11AC_VHT20:
-	case MODE_11AC_VHT40:
-	case MODE_11AC_VHT80:
-		band = IEEE80211_BAND_5GHZ;
-		break;
-	case MODE_11G:
-	case MODE_11B:
-	case MODE_11GONLY:
-	case MODE_11NG_HT20:
-	case MODE_11NG_HT40:
-	case MODE_11AC_VHT20_2G:
-	case MODE_11AC_VHT40_2G:
-	case MODE_11AC_VHT80_2G:
-	default:
-		band = IEEE80211_BAND_2GHZ;
-	}
-
-	return band;
-}
-
 /* If keys are configured, HW decrypts all frames
  * with protected bit set. Mark such frames as decrypted.
  */
-- 
2.7.2

