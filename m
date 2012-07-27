Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:46542 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab2G0XP3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 19:15:29 -0400
Received: by wibhr14 with SMTP id hr14so100100wib.1
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jul 2012 16:15:27 -0700 (PDT)
Message-Id: <a0f43a30b3b9a0e80694160f8df5ab5735da0126.1343430404.git.chunkeey@googlemail.com> (sfid-20120728_011534_781877_BE95A805)
In-Reply-To: <fbc79a8777dfbbda1aa2bc388a7c7062dcf2b36a.1343430404.git.chunkeey@googlemail.com>
References: <fbc79a8777dfbbda1aa2bc388a7c7062dcf2b36a.1343430404.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 28 Jul 2012 01:04:10 +0200
Subject: [PATCH 2/2] p54: support per packet tpc
To: linux-wireless@vger.kernel.org
Cc: thomas@net.t-labs.tu-berlin.de, linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch add support for the upcoming
transmit power controller algorithm.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/p54/eeprom.c |    3 +++
 drivers/net/wireless/p54/lmac.h   |    2 +-
 drivers/net/wireless/p54/main.c   |    4 +---
 drivers/net/wireless/p54/p54.h    |    1 -
 drivers/net/wireless/p54/txrx.c   |   13 ++++++++-----
 5 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/p54/eeprom.c b/drivers/net/wireless/p54/eeprom.c
index fa8ce51..cb2b496 100644
--- a/drivers/net/wireless/p54/eeprom.c
+++ b/drivers/net/wireless/p54/eeprom.c
@@ -75,6 +75,7 @@ static struct p54_rssi_db_entry p54_rssi_default = {
 struct p54_channel_entry {
 	u16 freq;
 	u16 data;
+	u16 max_power;
 	int index;
 	enum ieee80211_band band;
 };
@@ -192,6 +193,7 @@ static int p54_generate_band(struct ieee80211_hw *dev,
 
 		tmp->channels[j].band = chan->band;
 		tmp->channels[j].center_freq = chan->freq;
+		tmp->channels[j].max_power = chan->max_power;
 		priv->survey[*chan_num].channel = &tmp->channels[j];
 		priv->survey[*chan_num].filled = SURVEY_INFO_NOISE_DBM |
 			SURVEY_INFO_CHANNEL_TIME |
@@ -265,6 +267,7 @@ static void p54_update_channel_param(struct p54_channel_list *list,
 		list->channels[i].band = band;
 		list->channels[i].index = ieee80211_frequency_to_channel(freq);
 		/* TODO: parse output_limit and fill max_power */
+		list->channels[i].max_power = 20;
 	}
 }
 
diff --git a/drivers/net/wireless/p54/lmac.h b/drivers/net/wireless/p54/lmac.h
index de1d46b..b15d533 100644
--- a/drivers/net/wireless/p54/lmac.h
+++ b/drivers/net/wireless/p54/lmac.h
@@ -56,7 +56,7 @@ enum p54_control_frame_types {
 #define P54_HDR_FLAG_DATA_OUT_PROMISC		BIT(0)
 #define P54_HDR_FLAG_DATA_OUT_TIMESTAMP		BIT(1)
 #define P54_HDR_FLAG_DATA_OUT_SEQNR		BIT(2)
-#define P54_HDR_FLAG_DATA_OUT_BIT3		BIT(3)
+#define P54_HDR_FLAG_DATA_OUT_TPC		BIT(3)
 #define P54_HDR_FLAG_DATA_OUT_BURST		BIT(4)
 #define P54_HDR_FLAG_DATA_OUT_NOCANCEL		BIT(5)
 #define P54_HDR_FLAG_DATA_OUT_CLEARTIM		BIT(6)
diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index 5e91ad0..de2a443 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -320,11 +320,8 @@ static int p54_config(struct ieee80211_hw *dev, u32 changed)
 {
 	int ret = 0;
 	struct p54_common *priv = dev->priv;
-	struct ieee80211_conf *conf = &dev->conf;
 
 	mutex_lock(&priv->conf_mutex);
-	if (changed & IEEE80211_CONF_CHANGE_POWER)
-		priv->output_power = conf->power_level << 2;
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
 		struct ieee80211_channel *oldchan;
 		WARN_ON(p54_wait_for_stats(dev));
@@ -737,6 +734,7 @@ struct ieee80211_hw *p54_init_common(size_t priv_data_len)
 		     IEEE80211_HW_SIGNAL_DBM |
 		     IEEE80211_HW_SUPPORTS_PS |
 		     IEEE80211_HW_PS_NULLFUNC_STACK |
+		     IEEE80211_HW_SUPPORTS_TPC_DATA_PACKET |
 		     IEEE80211_HW_REPORTS_TX_ACK_STATUS;
 
 	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
diff --git a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
index 40b401e..73b4061 100644
--- a/drivers/net/wireless/p54/p54.h
+++ b/drivers/net/wireless/p54/p54.h
@@ -198,7 +198,6 @@ struct p54_common {
 	u16 rxhw;
 	u8 rx_diversity_mask;
 	u8 tx_diversity_mask;
-	unsigned int output_power;
 	struct p54_rssi_db_entry *cur_rssi;
 	struct ieee80211_channel *curchan;
 	struct survey_info *survey;
diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index 5861e13..eb5ac80 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -426,7 +426,7 @@ static void p54_rx_frame_sent(struct p54_common *priv, struct sk_buff *skb)
 	       sizeof(struct ieee80211_tx_info) -
 	       offsetof(struct ieee80211_tx_info, status.ack_signal));
 	BUILD_BUG_ON(offsetof(struct ieee80211_tx_info,
-			      status.ack_signal) != 20);
+			      status.ack_signal) != 24);
 
 	if (entry_hdr->flags & cpu_to_le16(P54_HDR_FLAG_DATA_ALIGN))
 		pad = entry_data->align[0];
@@ -777,7 +777,7 @@ void p54_tx_80211(struct ieee80211_hw *dev,
 	struct p54_tx_info *p54info;
 	struct p54_hdr *hdr;
 	struct p54_tx_data *txhdr;
-	unsigned int padding, len, extra_len = 0;
+	unsigned int padding, len, extra_len = 0, output_power;
 	int i, j, ridx;
 	u16 hdr_flags = 0, aid = 0;
 	u8 rate, queue = 0, crypt_offset = 0;
@@ -825,7 +825,7 @@ void p54_tx_80211(struct ieee80211_hw *dev,
 	 * RTS/CTS won't happen on 5 GHz
 	 */
 	cts_rate = info->control.rts_cts_rate_idx;
-
+	output_power = info->control.rates[0].tpc * 4;
 	memset(&txhdr->rateset, 0, sizeof(txhdr->rateset));
 
 	/* see how many rates got used */
@@ -891,6 +891,8 @@ void p54_tx_80211(struct ieee80211_hw *dev,
 	if (burst_allowed)
 		hdr_flags |= P54_HDR_FLAG_DATA_OUT_BURST;
 
+	hdr_flags |= P54_HDR_FLAG_DATA_OUT_TPC;
+
 	/* TODO: enable bursting */
 	hdr->flags = cpu_to_le16(hdr_flags);
 	hdr->tries = ridx;
@@ -920,11 +922,12 @@ void p54_tx_80211(struct ieee80211_hw *dev,
 	txhdr->tx_antenna = 2 & priv->tx_diversity_mask;
 	if (priv->rxhw == 5) {
 		txhdr->longbow.cts_rate = cts_rate;
-		txhdr->longbow.output_power = cpu_to_le16(priv->output_power);
+		txhdr->longbow.output_power = cpu_to_le16(output_power);
 	} else {
-		txhdr->normal.output_power = priv->output_power;
+		txhdr->normal.output_power = output_power;
 		txhdr->normal.cts_rate = cts_rate;
 	}
+
 	if (padding)
 		txhdr->align[0] = padding;
 
-- 
1.7.10.4

