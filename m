Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57145 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbZDTQ1j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 12:27:39 -0400
Subject: [PATCH] ar9170: support HT receive and channel config
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Christian Lamparter <chunkeey@web.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 20 Apr 2009 18:27:04 +0200
Message-Id: <1240244824.4632.1.camel@johannes.local> (sfid-20090420_182742_813852_53D62E77)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support for configuring HT40 channels
and receiving HT40 to ar9170. Receiving aggregation
doesn't seem to work right now, so it's not enabled.
Same goes for TX aggregation, but that probably needs
even more work.

With this, I can receive roughly 33 Mbits/sec.

The HT capabilities are a little odd, I tried following
otus here -- in particular having SGI_40 but not SGI_20
is a little weird but afaict that's what otus does.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/ath/ar9170/ar9170.h |   15 ++++++++
 drivers/net/wireless/ath/ar9170/main.c   |   54 ++++++++++++++++++++++++++-----
 2 files changed, 61 insertions(+), 8 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/ath/ar9170/ar9170.h	2009-04-20 18:18:08.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ar9170/ar9170.h	2009-04-20 18:18:22.000000000 +0200
@@ -60,6 +60,21 @@ enum ar9170_bw {
 	__AR9170_NUM_BW,
 };
 
+static inline enum ar9170_bw nl80211_to_ar9170(enum nl80211_channel_type type)
+{
+	switch (type) {
+	case NL80211_CHAN_NO_HT:
+	case NL80211_CHAN_HT20:
+		return AR9170_BW_20;
+	case NL80211_CHAN_HT40MINUS:
+		return AR9170_BW_40_BELOW;
+	case NL80211_CHAN_HT40PLUS:
+		return AR9170_BW_40_ABOVE;
+	default:
+		BUG();
+	}
+}
+
 enum ar9170_rf_init_mode {
 	AR9170_RFI_NONE,
 	AR9170_RFI_WARM,
--- wireless-testing.orig/drivers/net/wireless/ath/ar9170/main.c	2009-04-20 18:18:08.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath/ar9170/main.c	2009-04-20 18:18:22.000000000 +0200
@@ -142,11 +142,36 @@ static struct ieee80211_channel ar9170_5
 };
 #undef CHAN
 
+#define AR9170_HT_CAP							\
+{									\
+	.ht_supported	= true,						\
+	.cap		= IEEE80211_HT_CAP_MAX_AMSDU |			\
+			  IEEE80211_HT_CAP_SM_PS |			\
+			  IEEE80211_HT_CAP_SUP_WIDTH_20_40 |		\
+			  IEEE80211_HT_CAP_SGI_40 |			\
+			  IEEE80211_HT_CAP_DSSSCCK40 |			\
+			  IEEE80211_HT_CAP_SM_PS,			\
+	.ampdu_factor	= 3, /* ?? */					\
+	.ampdu_density	= 7, /* ?? */					\
+	.mcs		= {						\
+		.rx_mask = { 0xFF, 0xFF, 0, 0, 0, 0, 0, 0, 0, 0, },	\
+	},								\
+}
+
 static struct ieee80211_supported_band ar9170_band_2GHz = {
 	.channels	= ar9170_2ghz_chantable,
 	.n_channels	= ARRAY_SIZE(ar9170_2ghz_chantable),
 	.bitrates	= ar9170_g_ratetable,
 	.n_bitrates	= ar9170_g_ratetable_size,
+	.ht_cap		= AR9170_HT_CAP,
+};
+
+static struct ieee80211_supported_band ar9170_band_5GHz = {
+	.channels	= ar9170_5ghz_chantable,
+	.n_channels	= ARRAY_SIZE(ar9170_5ghz_chantable),
+	.bitrates	= ar9170_a_ratetable,
+	.n_bitrates	= ar9170_a_ratetable_size,
+	.ht_cap		= AR9170_HT_CAP,
 };
 
 #ifdef AR9170_QUEUE_DEBUG
@@ -190,13 +215,6 @@ static void ar9170_dump_station_tx_statu
 }
 #endif /* AR9170_QUEUE_DEBUG */
 
-static struct ieee80211_supported_band ar9170_band_5GHz = {
-	.channels	= ar9170_5ghz_chantable,
-	.n_channels	= ARRAY_SIZE(ar9170_5ghz_chantable),
-	.bitrates	= ar9170_a_ratetable,
-	.n_bitrates	= ar9170_a_ratetable_size,
-};
-
 void ar9170_handle_tx_status(struct ar9170 *ar, struct sk_buff *skb,
 			     bool valid_status, u16 tx_status)
 {
@@ -1327,7 +1345,8 @@ static int ar9170_op_config(struct ieee8
 
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
 		err = ar9170_set_channel(ar, hw->conf.channel,
-					 AR9170_RFI_NONE, AR9170_BW_20);
+				AR9170_RFI_NONE,
+				nl80211_to_ar9170(hw->conf.channel_type));
 		if (err)
 			goto out;
 		/* adjust slot time for 5 GHz */
@@ -1749,6 +1768,24 @@ static int ar9170_conf_tx(struct ieee802
 	return ret;
 }
 
+static int ar9170_ampdu_action(struct ieee80211_hw *hw,
+			       enum ieee80211_ampdu_mlme_action action,
+			       struct ieee80211_sta *sta, u16 tid, u16 *ssn)
+{
+	switch (action) {
+	case IEEE80211_AMPDU_RX_START:
+	case IEEE80211_AMPDU_RX_STOP:
+		/*
+		 * Something goes wrong -- RX locks up
+		 * after a while of receiving aggregated
+		 * frames -- not enabling for now.
+		 */
+		return -EOPNOTSUPP;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static const struct ieee80211_ops ar9170_ops = {
 	.start			= ar9170_op_start,
 	.stop			= ar9170_op_stop,
@@ -1765,6 +1802,7 @@ static const struct ieee80211_ops ar9170
 	.sta_notify		= ar9170_sta_notify,
 	.get_stats		= ar9170_get_stats,
 	.get_tx_stats		= ar9170_get_tx_stats,
+	.ampdu_action		= ar9170_ampdu_action,
 };
 
 void *ar9170_alloc(size_t priv_size)


