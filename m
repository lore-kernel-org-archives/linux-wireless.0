Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:33191 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbaFMOpa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2014 10:45:30 -0400
Received: by mail-pd0-f170.google.com with SMTP id z10so736359pdj.15
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jun 2014 07:45:29 -0700 (PDT)
Received: from localhost.localdomain ([115.248.87.14])
        by mx.google.com with ESMTPSA id fu12sm22374022pad.42.2014.06.13.07.45.28
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Fri, 13 Jun 2014 07:45:29 -0700 (PDT)
From: Jahnavi Meher <jahnavi.meher@gmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH 5/5] Changes for 40MHz
Date: Fri, 13 Jun 2014 20:15:21 +0530
Message-Id: <1402670721-8972-1-git-send-email-jahnavi.meher@gmail.com> (sfid-20140613_164532_539742_DA29A0AD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added code required for 40MHz.

Signed-off-by: Jahnavi Meher <jahnavi.meher@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c |    2 +-
 drivers/net/wireless/rsi/rsi_91x_pkt.c      |   10 ++++++++++
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 1cb3164..aeaf87b 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -177,7 +177,7 @@ static void rsi_register_rates_channels(struct rsi_hw *adapter, int band)
 	sbands->ht_cap.cap = (IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
 			      IEEE80211_HT_CAP_SGI_20 |
 			      IEEE80211_HT_CAP_SGI_40);
-	sbands->ht_cap.ampdu_factor = IEEE80211_HT_MAX_AMPDU_8K;
+	sbands->ht_cap.ampdu_factor = IEEE80211_HT_MAX_AMPDU_16K;
 	sbands->ht_cap.ampdu_density = IEEE80211_HT_MPDU_DENSITY_NONE;
 	sbands->ht_cap.mcs.rx_mask[0] = 0xff;
 	sbands->ht_cap.mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
diff --git a/drivers/net/wireless/rsi/rsi_91x_pkt.c b/drivers/net/wireless/rsi/rsi_91x_pkt.c
index 2221c23..702593f 100644
--- a/drivers/net/wireless/rsi/rsi_91x_pkt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_pkt.c
@@ -82,6 +82,9 @@ int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
 		frame_desc[3] = cpu_to_le16(RATE_INFO_ENABLE);
 		frame_desc[4] = cpu_to_le16(common->min_rate);
 
+		if (conf_is_ht40(&common->priv->hw->conf))
+			frame_desc[5] = cpu_to_le16(FULL40M_ENABLE);
+
 		if (common->vif_info[0].sgi) {
 			if (common->min_rate & 0x100) /* Only MCS rates */
 				frame_desc[4] |=
@@ -123,6 +126,8 @@ int rsi_send_mgmt_pkt(struct rsi_common *common,
 	struct ieee80211_hdr *wh = NULL;
 	struct ieee80211_tx_info *info;
 	struct ieee80211_bss_conf *bss = NULL;
+	struct ieee80211_hw *hw = adapter->hw;
+	struct ieee80211_conf *conf = &hw->conf;
 	struct skb_info *tx_params;
 	int status = -E2BIG;
 	__le16 *msg = NULL;
@@ -182,6 +187,11 @@ int rsi_send_mgmt_pkt(struct rsi_common *common,
 	else
 		msg[4] = cpu_to_le16((RSI_RATE_6 & 0x0f) | RSI_11G_MODE);
 
+	if (conf_is_ht40(conf)) {
+		msg[4] = cpu_to_le16(0xB | RSI_11G_MODE);
+		msg[5] = cpu_to_le16(0x6);
+	}
+
 	/* Indicate to firmware to give cfm */
 	if ((skb->data[16] == IEEE80211_STYPE_PROBE_REQ) && (!bss->assoc)) {
 		msg[1] |= cpu_to_le16(BIT(10));
-- 
1.7.1

