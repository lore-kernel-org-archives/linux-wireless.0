Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33918 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753042AbdHKNqd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Aug 2017 09:46:33 -0400
Received: by mail-pf0-f194.google.com with SMTP id t86so3540054pfe.1
        for <linux-wireless@vger.kernel.org>; Fri, 11 Aug 2017 06:46:32 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 09/11] rsi: update tx auto rate command frame for AP mode
Date: Fri, 11 Aug 2017 19:11:27 +0530
Message-Id: <1502458889-9690-10-git-send-email-amitkarwar@gmail.com> (sfid-20170811_154649_429044_293FA33E)
In-Reply-To: <1502458889-9690-1-git-send-email-amitkarwar@gmail.com>
References: <1502458889-9690-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

Auto rate frame is sent to firmware when a new station is
connected. Station id and station's ht capabilities are updated
in auto rate command frame.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c | 44 +++++++++++++++++++++++++--------
 1 file changed, 34 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index c5d48cd..8762d13 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -1152,8 +1152,11 @@ static bool rsi_map_rates(u16 rate, int *offset)
  *
  * Return: 0 on success, corresponding error code on failure.
  */
-static int rsi_send_auto_rate_request(struct rsi_common *common)
+static int rsi_send_auto_rate_request(struct rsi_common *common,
+				      struct ieee80211_sta *sta,
+				      u16 sta_id)
 {
+	struct ieee80211_vif *vif = common->priv->vifs[0];
 	struct sk_buff *skb;
 	struct rsi_auto_rate *auto_rate;
 	int ii = 0, jj = 0, kk = 0;
@@ -1161,11 +1164,14 @@ static int rsi_send_auto_rate_request(struct rsi_common *common)
 	u8 band = hw->conf.chandef.chan->band;
 	u8 num_supported_rates = 0;
 	u8 rate_table_offset, rate_offset = 0;
-	u32 rate_bitmap = common->bitrate_mask[band];
-
+	u32 rate_bitmap;
 	u16 *selected_rates, min_rate;
+	bool is_ht = false, is_sgi = false;
 	u16 frame_len = sizeof(struct rsi_auto_rate);
 
+	rsi_dbg(MGMT_TX_ZONE,
+		"%s: Sending auto rate request frame\n", __func__);
+
 	skb = dev_alloc_skb(frame_len);
 	if (!skb) {
 		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
@@ -1193,12 +1199,31 @@ static int rsi_send_auto_rate_request(struct rsi_common *common)
 
 	if (common->channel_width == BW_40MHZ)
 		auto_rate->desc.desc_dword3.qid_tid = BW_40MHZ;
+	auto_rate->desc.desc_dword3.sta_id = sta_id;
+
+	if (vif->type == NL80211_IFTYPE_STATION) {
+		rate_bitmap = common->bitrate_mask[band];
+		is_ht = common->vif_info[0].is_ht;
+		is_sgi = common->vif_info[0].sgi;
+	} else {
+		rate_bitmap = sta->supp_rates[band];
+		is_ht = sta->ht_cap.ht_supported;
+		if ((sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20) ||
+		    (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40))
+			is_sgi = true;
+	}
 
 	if (band == NL80211_BAND_2GHZ) {
-		min_rate = RSI_RATE_1;
+		if ((rate_bitmap == 0) && (is_ht))
+			min_rate = RSI_RATE_MCS0;
+		else
+			min_rate = RSI_RATE_1;
 		rate_table_offset = 0;
 	} else {
-		min_rate = RSI_RATE_6;
+		if ((rate_bitmap == 0) && (is_ht))
+			min_rate = RSI_RATE_MCS0;
+		else
+			min_rate = RSI_RATE_6;
 		rate_table_offset = 4;
 	}
 
@@ -1212,7 +1237,7 @@ static int rsi_send_auto_rate_request(struct rsi_common *common)
 	}
 	num_supported_rates = jj;
 
-	if (common->vif_info[0].is_ht) {
+	if (is_ht) {
 		for (ii = 0; ii < ARRAY_SIZE(mcs); ii++)
 			selected_rates[jj++] = mcs[ii];
 		num_supported_rates += ARRAY_SIZE(mcs);
@@ -1233,11 +1258,10 @@ static int rsi_send_auto_rate_request(struct rsi_common *common)
 	}
 
 	/* loading HT rates in the bottom half of the auto rate table */
-	if (common->vif_info[0].is_ht) {
+	if (is_ht) {
 		for (ii = rate_offset, kk = ARRAY_SIZE(rsi_mcsrates) - 1;
 		     ii < rate_offset + 2 * ARRAY_SIZE(rsi_mcsrates); ii++) {
-			if (common->vif_info[0].sgi ||
-			    conf_is_ht40(&common->priv->hw->conf))
+			if (is_sgi || conf_is_ht40(&common->priv->hw->conf))
 				auto_rate->supported_rates[ii++] =
 					cpu_to_le16(rsi_mcsrates[kk] | BIT(9));
 			else
@@ -1300,7 +1324,7 @@ void rsi_inform_bss_status(struct rsi_common *common,
 					      qos_enable,
 					      aid, sta_id);
 		if (common->min_rate == 0xffff)
-			rsi_send_auto_rate_request(common);
+			rsi_send_auto_rate_request(common, sta, sta_id);
 		if (opmode == STA_OPMODE) {
 			if (!rsi_send_block_unblock_frame(common, false))
 				common->hw_data_qs_blocked = false;
-- 
2.7.4
