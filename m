Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:42385 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755254Ab0LPLkA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 06:40:00 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 03:39:44 -0800
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: <linville@tuxdriver.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [RFC] ath9k_htc : Update txrate status to mac80211
Date: Thu, 16 Dec 2010 17:09:48 +0530
Message-ID: <1292499588-11636-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

In ath9k htc txrate status is not updated to mac80211 as rate control is
handled in firmware.This workaround will obtain the txrate which was
supposed to be for debug statistics and updates it to mac80211 using
a rate control look up table.

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |   34 ++++
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   30 +++-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |  210 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/wmi.c          |    8 +-
 4 files changed, 272 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index fdf9d5f..7e2559a 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -196,6 +196,34 @@ struct ath9k_htc_target_rate {
 	struct ath9k_htc_rate rates;
 };
 
+#define HTC_RATE_TABLE_SIZE	72
+
+#define HTC_RATE_INVALID	0x0
+#define HTC_RATE_LEGACY		0x1
+#define HTC_RATE_SS		0x2
+#define HTC_RATE_DS		0x4
+#define HTC_RATE_TS		0x8
+#define HTC_RATE_HT20		0x10
+#define HTC_RATE_HT40		0x20
+
+#define HTC_RATE_HT20_SS	(HTC_RATE_SS | HTC_RATE_HT20)
+#define HTC_RATE_HT20_DS	(HTC_RATE_DS | HTC_RATE_HT20)
+#define HTC_RATE_HT20_TS	(HTC_RATE_TS | HTC_RATE_HT20)
+
+#define HTC_RATE_HT40_SS	(HTC_RATE_SS | HTC_RATE_HT40)
+#define HTC_RATE_HT40_DS	(HTC_RATE_DS | HTC_RATE_HT40)
+#define HTC_RATE_HT40_TS	(HTC_RATE_TS | HTC_RATE_HT40)
+
+
+struct ath9k_htc_rate_table {
+	u8 htc_rate_cnt;
+	struct {
+	u32 htc_ratekbps;
+	s8 htc_rate_table_index;
+	u16 htc_rate_table_flags;
+	} info[HTC_RATE_TABLE_SIZE];
+};
+
 struct ath9k_htc_target_stats {
 	__be32 tx_shortretry;
 	__be32 tx_longretry;
@@ -367,6 +395,9 @@ struct ath9k_htc_priv {
 	u16 nstations;
 	u16 seq_no;
 	u32 bmiss_cnt;
+	u32 txrate;
+	u16 htc_rate_flags;
+	u32 rate_ctrl_flags;
 
 	struct ath9k_hw_cal_data caldata[ATH9K_NUM_CHANNELS];
 
@@ -452,6 +483,9 @@ void ath9k_host_rx_init(struct ath9k_htc_priv *priv);
 void ath9k_rx_tasklet(unsigned long data);
 u32 ath9k_htc_calcrxfilter(struct ath9k_htc_priv *priv);
 
+enum htc_phymode ath9k_htc_get_curmode(struct ath9k_htc_priv *priv,
+		struct ath9k_channel *ichan);
+
 void ath9k_htc_ps_wakeup(struct ath9k_htc_priv *priv);
 void ath9k_htc_ps_restore(struct ath9k_htc_priv *priv);
 void ath9k_ps_work(struct work_struct *work);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index dd17909..1c2eb78 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -36,7 +36,7 @@ static void ath_update_txpow(struct ath9k_htc_priv *priv)
 }
 
 /* HACK Alert: Use 11NG for 2.4, use 11NA for 5 */
-static enum htc_phymode ath9k_htc_get_curmode(struct ath9k_htc_priv *priv,
+enum htc_phymode ath9k_htc_get_curmode(struct ath9k_htc_priv *priv,
 					      struct ath9k_channel *ichan)
 {
 	enum htc_phymode mode;
@@ -353,6 +353,8 @@ static void ath9k_htc_setup_rate(struct ath9k_htc_priv *priv,
 		}
 	}
 	trate->rates.legacy_rates.rs_nrates = j;
+	priv->htc_rate_flags = 0 ;
+	priv->rate_ctrl_flags = 0 ;
 
 	if (sta->ht_cap.ht_supported) {
 		for (i = 0, j = 0; i < 77; i++) {
@@ -362,21 +364,37 @@ static void ath9k_htc_setup_rate(struct ath9k_htc_priv *priv,
 				break;
 		}
 		trate->rates.ht_rates.rs_nrates = j;
+		priv->rate_ctrl_flags |= IEEE80211_TX_RC_MCS;
 
 		caps = WLAN_RC_HT_FLAG;
-		if (sta->ht_cap.mcs.rx_mask[1])
+		if (sta->ht_cap.mcs.rx_mask[1]) {
 			caps |= WLAN_RC_DS_FLAG;
+			priv->htc_rate_flags |= HTC_RATE_DS;
+		} else {
+			priv->htc_rate_flags |= HTC_RATE_SS;
+		}
+
 		if ((sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) &&
-		     (conf_is_ht40(&priv->hw->conf)))
+		     (conf_is_ht40(&priv->hw->conf))) {
 			caps |= WLAN_RC_40_FLAG;
+			priv->htc_rate_flags |= HTC_RATE_HT40;
+			priv->rate_ctrl_flags |= IEEE80211_TX_RC_40_MHZ_WIDTH;
+		} else {
+			priv->htc_rate_flags |= HTC_RATE_HT20;
+		}
 		if (conf_is_ht40(&priv->hw->conf) &&
-		    (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40))
+		    (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40)) {
 			caps |= WLAN_RC_SGI_FLAG;
-		else if (conf_is_ht20(&priv->hw->conf) &&
-			 (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20))
+		}
+		if (conf_is_ht20(&priv->hw->conf) &&
+			 (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20)) {
 			caps |= WLAN_RC_SGI_FLAG;
+		}
 	}
 
+	else
+		priv->htc_rate_flags |= HTC_RATE_LEGACY;
+
 	trate->sta_index = ista->index;
 	trate->isnew = 1;
 	trate->capflags = cpu_to_be32(caps);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 33f3602..1494c92 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -37,6 +37,193 @@ static const int subtype_txq_to_hwq[] = {
 			TXQ_FLAG_TXDESCINT_ENABLE;		\
 	} while (0)
 
+
+struct ath9k_htc_rate_table htc_11na_ratetable = {
+	68,
+	{
+		[0] = { 6000, 0, HTC_RATE_LEGACY }, /* 6 Mb */
+		[1] = { 9000, 1, HTC_RATE_LEGACY }, /* 9 Mb */
+		[2] = { 12000, 2, HTC_RATE_LEGACY },  /* 12 Mb */
+		[3] = { 18000, 3, HTC_RATE_LEGACY },  /* 18 Mb */
+		[4] = { 24000, 4, HTC_RATE_LEGACY },  /* 24 Mb */
+		[5] = { 36000, 5, HTC_RATE_LEGACY },  /* 36 Mb */
+		[6] = { 48000, 6, HTC_RATE_LEGACY },  /* 48 Mb */
+		[7] = { 54000, 7, HTC_RATE_LEGACY },  /* 54 Mb */
+		[8] = { 6500, 0, HTC_RATE_HT20_SS }, /* 6.5 Mb */
+		[9] = { 13000, 1, HTC_RATE_HT20_SS }, /* 13 Mb */
+		[10] = { 19500, 2, HTC_RATE_HT20_SS }, /* 19.5 Mb */
+		[11] = { 26000, 3, HTC_RATE_HT20_SS }, /* 26 Mb */
+		[12] = { 39000, 4, HTC_RATE_HT20_SS }, /* 39 Mb */
+		[13] = { 52000, 5, HTC_RATE_HT20_SS }, /* 52 Mb */
+		[14] = { 58500, 6, HTC_RATE_HT20_SS }, /* 58.5 Mb */
+		[15] = { 65000, 7, HTC_RATE_HT20_SS }, /* 65 Mb */
+		[16] = { 72200, 7, HTC_RATE_HT20_SS }, /* 72.2 Mb */
+		[17] = { 13000, 8, HTC_RATE_INVALID }, /* 13 Mb */
+		[18] = { 26000, 9, HTC_RATE_HT20_DS }, /* 26 Mb */
+		[19] = { 39000, 10, HTC_RATE_HT20_DS }, /* 39 Mb */
+		[20] = { 52000, 11, HTC_RATE_HT20_DS }, /* 52 Mb */
+		[21] = { 78000, 12, HTC_RATE_HT20_DS }, /* 78 Mb */
+		[22] = { 104000, 13, HTC_RATE_HT20_DS }, /* 104 Mb */
+		[23] = { 117000, 14, HTC_RATE_HT20_DS }, /* 117 Mb */
+		[24] = { 130000, 15, HTC_RATE_HT20_DS }, /* 130 Mb */
+		[25] = { 144400, 15, HTC_RATE_HT20_DS }, /* 144.4 Mb */
+		[26] = { 19500, 16, HTC_RATE_INVALID }, /* 19.5 Mb */
+		[27] = { 39000, 17, HTC_RATE_INVALID }, /* 39 Mb */
+		[28] = { 58500, 18, HTC_RATE_INVALID }, /* 58.5 Mb */
+		[29] = { 78000, 19, HTC_RATE_INVALID }, /* 78 Mb */
+		[30] = { 117000, 20, HTC_RATE_INVALID }, /* 117 Mb */
+		[31] = { 130000, 20, HTC_RATE_INVALID }, /* 130 Mb */
+		[32] = { 156000, 21, HTC_RATE_HT20_TS }, /* 156 Mb */
+		[33] = { 173300, 21, HTC_RATE_HT20_TS }, /* 173300 Mb */
+		[34] = { 175500, 22, HTC_RATE_HT20_TS }, /* 175500 Mb */
+		[35] = { 195000, 22, HTC_RATE_HT20_TS }, /* 195000 Mb */
+		[36] = { 195000, 23, HTC_RATE_HT20_TS }, /* 195000 Mb */
+		[37] = { 216700, 23, HTC_RATE_HT20_TS }, /* 216.7 Mb */
+		[38] = { 13500, 0, HTC_RATE_HT40_SS }, /* 13.5 Mb */
+		[39] = { 27500, 1, HTC_RATE_HT40_SS }, /* 27 Mb */
+		[40] = { 40500, 2, HTC_RATE_HT40_SS }, /* 40.5 Mb */
+		[41] = { 54000, 3, HTC_RATE_HT40_SS }, /* 54 Mb */
+		[42] = { 81500, 4, HTC_RATE_HT40_SS }, /* 81 Mb */
+		[43] = { 108000, 5, HTC_RATE_HT40_SS }, /* 108 Mb */
+		[44] = { 121500, 6, HTC_RATE_HT40_SS }, /* 121.5 Mb */
+		[45] = { 135000, 7, HTC_RATE_HT40_SS }, /* 135 Mb */
+		[46] = { 150000, 7, HTC_RATE_HT40_SS }, /* 150 Mb */
+		[47] = { 27000, 8, HTC_RATE_INVALID}, /* 27 Mb */
+		[48] = { 54000, 9, HTC_RATE_HT40_DS}, /* 54 Mb */
+		[49] = { 81000, 10, HTC_RATE_HT40_DS}, /* 81 Mb */
+		[50] = { 108000, 11, HTC_RATE_HT40_DS}, /* 108 Mb */
+		[51] = { 162000, 12, HTC_RATE_HT40_DS}, /* 162 Mb */
+		[52] = { 216000, 13, HTC_RATE_HT40_DS}, /* 216 Mb */
+		[53] = { 243000, 14, HTC_RATE_HT40_DS}, /* 243 Mb */
+		[54] = { 270000, 15, HTC_RATE_HT40_DS}, /* 270 Mb */
+		[55] = { 300000, 15, HTC_RATE_HT40_DS }, /* 300 Mb */
+		[56] = { 40500, 16, HTC_RATE_INVALID}, /* 40.5 Mb */
+		[57] = { 81000, 17, HTC_RATE_INVALID}, /* 81 Mb */
+		[58] = { 121500, 18, HTC_RATE_INVALID}, /* 121.5 Mb */
+		[59] = { 162000, 19, HTC_RATE_INVALID}, /* 162 Mb */
+		[60] = { 243000, 20, HTC_RATE_INVALID}, /* 243 Mb */
+		[61] = { 270000, 20, HTC_RATE_INVALID}, /* 270 Mb */
+		[62] = { 324000, 21, HTC_RATE_HT40_TS}, /* 324 Mb */
+		[63] = { 360000, 21, HTC_RATE_HT40_TS}, /* 360 Mb */
+		[64] = { 364500, 22, HTC_RATE_HT40_TS}, /* 364.5 Mb */
+		[65] = { 405000, 22, HTC_RATE_HT40_TS}, /* 405 Mb */
+		[66] = { 405000, 23, HTC_RATE_HT40_TS}, /* 405 Mb */
+		[67] = { 450000, 23, HTC_RATE_HT40_TS}, /* 450 Mb */
+	}
+};
+
+struct ath9k_htc_rate_table htc_11ng_ratetable = {
+	72,
+	{
+
+		[0] = { 1000, 0, HTC_RATE_LEGACY }, /* 1 Mb */
+		[1] = { 2000, 1, HTC_RATE_LEGACY }, /* 2 Mb */
+		[2] = { 5500, 2, HTC_RATE_LEGACY },  /* 5.5 Mb */
+		[3] = { 11000, 3, HTC_RATE_LEGACY },  /* 11 Mb */
+		[4] = { 6000, 4, HTC_RATE_LEGACY }, /* 6 Mb */
+		[5] = { 9000, 5, HTC_RATE_LEGACY }, /* 9 Mb */
+		[6] = { 12000, 6, HTC_RATE_LEGACY },  /* 12 Mb */
+		[7] = { 18000, 7, HTC_RATE_LEGACY },  /* 18 Mb */
+		[8] = { 24000, 8, HTC_RATE_LEGACY },  /* 24 Mb */
+		[9] = { 36000, 9, HTC_RATE_LEGACY },  /* 36 Mb */
+		[10] = { 48000, 10, HTC_RATE_LEGACY },  /* 48 Mb */
+		[11] = { 54000, 11, HTC_RATE_LEGACY },  /* 54 Mb */
+		[12] = { 6500, 0, HTC_RATE_INVALID }, /* 6.5 Mb */
+		[13] = { 13000, 1, HTC_RATE_HT20_SS }, /* 13 Mb */
+		[14] = { 19500, 2, HTC_RATE_HT20_SS }, /* 19.5 Mb */
+		[15] = { 26000, 3, HTC_RATE_HT20_SS }, /* 26 Mb */
+		[16] = { 39000, 4, HTC_RATE_HT20_SS }, /* 39 Mb */
+		[17] = { 52000, 5, HTC_RATE_HT20_SS }, /* 52 Mb */
+		[18] = { 58500, 6, HTC_RATE_HT20_SS }, /* 58.5 Mb */
+		[19] = { 65000, 7, HTC_RATE_HT20_SS }, /* 65 Mb */
+		[20] = { 39000, 7, HTC_RATE_HT20_SS }, /* 72.2 Mb */
+		[21] = { 13000, 8, HTC_RATE_INVALID }, /* 13 Mb */
+		[22] = { 26000, 9, HTC_RATE_HT20_DS }, /* 26 Mb */
+		[23] = { 39000, 10, HTC_RATE_HT20_DS }, /* 39 Mb */
+		[24] = { 52000, 11, HTC_RATE_HT20_DS }, /* 52 Mb */
+		[25] = { 78000, 12, HTC_RATE_HT20_DS }, /* 78 Mb */
+		[26] = { 104000, 13, HTC_RATE_HT20_DS }, /* 104 Mb */
+		[27] = { 117000, 14, HTC_RATE_HT20_DS }, /* 117 Mb */
+		[28] = { 130000, 15, HTC_RATE_HT20_DS }, /* 130 Mb */
+		[29] = { 144400, 15, HTC_RATE_HT20_DS }, /* 144.4 Mb */
+		[30] = { 19500, 16, HTC_RATE_INVALID }, /* 19.5 Mb */
+		[31] = { 39000, 17, HTC_RATE_INVALID }, /* 39 Mb */
+		[32] = { 58500, 18, HTC_RATE_INVALID }, /* 58.5 Mb */
+		[33] = { 78000, 19, HTC_RATE_INVALID }, /* 78 Mb */
+		[34] = { 117000, 20, HTC_RATE_INVALID }, /* 117 Mb */
+		[35] = { 130000, 20, HTC_RATE_INVALID }, /* 130 Mb */
+		[36] = { 156000, 21, HTC_RATE_HT20_TS }, /* 156 Mb */
+		[37] = { 173300, 21, HTC_RATE_HT20_TS }, /* 173300 Mb */
+		[38] = { 175500, 22, HTC_RATE_HT20_TS }, /* 175500 Mb */
+		[39] = { 195000, 22, HTC_RATE_HT20_TS }, /* 195000 Mb */
+		[40] = { 195000, 23, HTC_RATE_HT20_TS}, /* 195000 Mb */
+		[41] = { 216700, 23, HTC_RATE_HT20_TS}, /* 216.7 Mb */
+		[42] = { 13500, 0, HTC_RATE_HT40_SS}, /* 13.5 Mb */
+		[43] = { 27500, 1, HTC_RATE_HT40_SS}, /* 27 Mb */
+		[44] = { 40500, 2, HTC_RATE_HT40_SS}, /* 40.5 Mb */
+		[45] = { 54000, 3, HTC_RATE_HT40_SS}, /* 54 Mb */
+		[46] = { 81500, 4, HTC_RATE_HT40_SS}, /* 81 Mb */
+		[47] = { 108000, 5, HTC_RATE_HT40_SS}, /* 108 Mb */
+		[48] = { 121500, 6, HTC_RATE_HT40_SS}, /* 121.5 Mb */
+		[49] = { 135000, 7, HTC_RATE_HT40_SS}, /* 135 Mb */
+		[50] = { 150000, 7, HTC_RATE_HT40_SS}, /* 150 Mb */
+		[51] = { 27000, 8, HTC_RATE_INVALID}, /* 27 Mb */
+		[52] = { 54000, 9, HTC_RATE_HT40_DS}, /* 54 Mb */
+		[53] = { 81000, 10, HTC_RATE_HT40_DS}, /* 81 Mb */
+		[54] = { 108000, 11, HTC_RATE_HT40_DS}, /* 108 Mb */
+		[55] = { 162000, 12, HTC_RATE_HT40_DS}, /* 162 Mb */
+		[56] = { 216000, 13, HTC_RATE_HT40_DS}, /* 216 Mb */
+		[57] = { 243000, 14, HTC_RATE_HT40_DS}, /* 243 Mb */
+		[58] = { 270000, 15, HTC_RATE_HT40_DS}, /* 270 Mb */
+		[59] = { 300000, 15, HTC_RATE_HT40_DS}, /* 300 Mb */
+		[60] = { 40500, 16, HTC_RATE_INVALID}, /* 40.5 Mb */
+		[61] = { 81000, 17, HTC_RATE_INVALID}, /* 81 Mb */
+		[62] = { 121500, 18, HTC_RATE_INVALID}, /* 121.5 Mb */
+		[63] = { 162000, 19, HTC_RATE_INVALID}, /* 162 Mb */
+		[64] = { 243000, 20, HTC_RATE_INVALID}, /* 243 Mb */
+		[65] = { 270000, 20, HTC_RATE_INVALID}, /* 270 Mb */
+		[66] = { 324000, 21, HTC_RATE_HT40_TS}, /* 324 Mb */
+		[67] = { 360000, 21, HTC_RATE_HT40_TS}, /* 360 Mb */
+		[68] = { 364500, 22, HTC_RATE_HT40_TS}, /* 364.5 Mb */
+		[69] = { 405000, 22, HTC_RATE_HT40_TS}, /* 405 Mb */
+		[70] = { 405000, 23, HTC_RATE_HT40_TS}, /* 405 Mb */
+		[71] = { 450000, 23, HTC_RATE_HT40_TS}, /* 450 Mb */
+	}
+};
+
+struct ath9k_htc_rate_table *htc_choose_rate_table(enum htc_phymode mode)
+{
+	switch (mode) {
+
+	case HTC_MODE_11NA:
+		return  &htc_11na_ratetable;
+	break;
+	case HTC_MODE_11NG:
+		return &htc_11ng_ratetable;
+	break;
+	default:
+		return NULL;
+
+	}
+}
+static s8 ath9k_htc_get_rate_index(struct ath9k_htc_rate_table *htc_rtb,
+				 struct ath9k_htc_priv *priv)
+{
+	s8 i;
+
+	for (i = 0; i < htc_rtb->htc_rate_cnt; i++) {
+
+		if ((priv->txrate == htc_rtb->info[i].htc_ratekbps) &&
+				(priv->htc_rate_flags ==
+				 htc_rtb->info[i].htc_rate_table_flags))
+			break;
+	}
+
+	return htc_rtb->info[i].htc_rate_table_index;
+
+}
+
+
 int get_hw_qnum(u16 queue, int *hwq_map)
 {
 	switch (queue) {
@@ -215,10 +402,17 @@ static bool ath9k_htc_check_tx_aggr(struct ath9k_htc_priv *priv,
 void ath9k_tx_tasklet(unsigned long data)
 {
 	struct ath9k_htc_priv *priv = (struct ath9k_htc_priv *)data;
+	struct ieee80211_hw *hw = priv->hw;
+	struct ath_hw *ah = priv->ah;
+	struct ath9k_channel *chan;
 	struct ieee80211_sta *sta;
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_tx_info *tx_info;
 	struct sk_buff *skb = NULL;
+	struct ath9k_htc_rate_table *htc_rtb = NULL;
+	enum htc_phymode mode;
+	u32 short_gi_rates[4] = {72200, 144400, 150000, 300000};
+	u8 i;
 	__le16 fc;
 
 	while ((skb = skb_dequeue(&priv->tx_queue)) != NULL) {
@@ -259,6 +453,22 @@ void ath9k_tx_tasklet(unsigned long data)
 			}
 		}
 
+		chan = ath9k_cmn_get_curchannel(hw, ah);
+		mode = ath9k_htc_get_curmode(priv, chan);
+		htc_rtb = htc_choose_rate_table(mode);
+		for (i = 0; i < 4; i++) {
+				if (priv->txrate == short_gi_rates[i])
+					priv->rate_ctrl_flags |=
+						IEEE80211_TX_RC_SHORT_GI;
+		}
+		tx_info->status.rates[0].idx =
+			ath9k_htc_get_rate_index(htc_rtb , priv);
+		tx_info->status.rates[0].flags = priv->rate_ctrl_flags;
+		tx_info->status.rates[0].count = 1;
+		tx_info->status.rates[1].idx = -1 ;
+		tx_info->status.rates[1].count = 0 ;
+
+
 		rcu_read_unlock();
 
 		/* Send status to mac80211 */
diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index 8f42ea7..c037417 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -146,11 +146,10 @@ static void ath9k_wmi_ctrl_rx(void *priv, struct sk_buff *skb,
 {
 	struct wmi *wmi = (struct wmi *) priv;
 	struct wmi_cmd_hdr *hdr;
+	struct ath9k_htc_priv *drv_priv = wmi->drv_priv;
 	u16 cmd_id;
 	void *wmi_event;
-#ifdef CONFIG_ATH9K_HTC_DEBUGFS
 	__be32 txrate;
-#endif
 
 	if (unlikely(wmi->stopped))
 		goto free_skb;
@@ -166,9 +165,10 @@ static void ath9k_wmi_ctrl_rx(void *priv, struct sk_buff *skb,
 			tasklet_schedule(&wmi->drv_priv->wmi_tasklet);
 			break;
 		case WMI_TXRATE_EVENTID:
-#ifdef CONFIG_ATH9K_HTC_DEBUGFS
 			txrate = ((struct wmi_event_txrate *)wmi_event)->txrate;
-			wmi->drv_priv->debug.txrate = be32_to_cpu(txrate);
+			drv_priv->txrate = be32_to_cpu(txrate);
+#ifdef CONFIG_ATH9K_HTC_DEBUGFS
+			wmi->drv_priv->debug.txrate = drv_priv->txrate;
 #endif
 			break;
 		default:
-- 
1.7.0.4

