Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from element.ksp.sk ([158.195.16.154]:46783 "EHLO element.ksp.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345AbYCRMsX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2008 08:48:23 -0400
Message-ID: <47DFBA13.3060508@work.ksp.sk> (sfid-20080318_124826_506678_26981C08)
Date: Tue, 18 Mar 2008 13:48:19 +0100
From: Vladimir Koutny <vlado@work.ksp.sk>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jiri Benc <jbenc@suse.cz>
Subject: [PATCH] mac80211: configure default wmm params correctly
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Default WMM params have to be set according to beacon/probe response
information prior to authentication (or IBSS start/join). This does
not affect the use of 'real' WMM params as reported by AP.

Signed-off-by: Vladimir Koutny <vlado@ksp.sk>
---
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 8b991eb..a55b422 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -220,6 +220,58 @@ static int ecw2cw(int ecw)
 	return (1 << ecw) - 1;
 }

+
+static void ieee80211_sta_def_wmm_params(struct net_device *dev,
+				     struct ieee80211_sta_bss *bss)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+	int i, have_higher_than_11mbit = 0;
+
+
+	/* cf. IEEE 802.11 9.2.12 */
+	for (i = 0; i < bss->supp_rates_len; i++)
+		if ((bss->supp_rates[i] & 0x7f) * 5 > 110)
+			have_higher_than_11mbit = 1;
+		
+	if (local->hw.conf.channel->band == IEEE80211_BAND_2GHZ &&
+    	have_higher_than_11mbit)
+		sdata->flags |= IEEE80211_SDATA_OPERATING_GMODE;
+	else
+		sdata->flags &= ~IEEE80211_SDATA_OPERATING_GMODE;
+
+
+	if (local->ops->conf_tx) {
+		struct ieee80211_tx_queue_params qparam;
+		int i;
+
+		memset(&qparam, 0, sizeof(qparam));
+
+		qparam.aifs = 2;
+
+		if (local->hw.conf.channel->band == IEEE80211_BAND_2GHZ &&
+		    !(sdata->flags & IEEE80211_SDATA_OPERATING_GMODE))
+			qparam.cw_min = 31;
+		else
+			qparam.cw_min = 15;
+
+		qparam.cw_max = 1023;
+		qparam.txop = 0;
+
+		for (i = IEEE80211_TX_QUEUE_DATA0; i < NUM_TX_DATA_QUEUES; i++)
+			local->ops->conf_tx(local_to_hw(local),
+					   i + IEEE80211_TX_QUEUE_DATA0,
+					   &qparam);
+
+		/* IBSS uses different parameters for Beacon sending */
+		qparam.cw_min++;
+		qparam.cw_min *= 2;
+		qparam.cw_min--;
+		local->ops->conf_tx(local_to_hw(local),
+				   IEEE80211_TX_QUEUE_BEACON, &qparam);
+	}
+}
+
 static void ieee80211_sta_wmm_params(struct net_device *dev,
 				     struct ieee80211_if_sta *ifsta,
 				     u8 *wmm_param, size_t wmm_param_len)
@@ -2289,6 +2341,8 @@ static int ieee80211_sta_join_ibss(struct net_device *dev,
 					rates |= BIT(j);
 		}
 		ifsta->supp_rates_bits[local->hw.conf.channel->band] = rates;
+
+		ieee80211_sta_def_wmm_params(dev, bss);
 	} while (0);

 	if (skb) {
@@ -3274,6 +3328,7 @@ static int ieee80211_sta_config_auth(struct net_device *dev,
 			ieee80211_sta_set_ssid(dev, selected->ssid,
 					       selected->ssid_len);
 		ieee80211_sta_set_bssid(dev, selected->bssid);
+		ieee80211_sta_def_wmm_params(dev, selected);
 		ieee80211_rx_bss_put(dev, selected);
 		ifsta->state = IEEE80211_AUTHENTICATE;
 		ieee80211_sta_reset_auth(dev, ifsta);
@@ -3453,38 +3508,6 @@ int ieee80211_sta_set_ssid(struct net_device *dev, char *ssid, size_t len)
 	if (len > IEEE80211_MAX_SSID_LEN)
 		return -EINVAL;

-	/* TODO: This should always be done for IBSS, even if IEEE80211_QOS is
-	 * not defined. */
-	if (local->ops->conf_tx) {
-		struct ieee80211_tx_queue_params qparam;
-		int i;
-
-		memset(&qparam, 0, sizeof(qparam));
-
-		qparam.aifs = 2;
-
-		if (local->hw.conf.channel->band == IEEE80211_BAND_2GHZ &&
-		    !(sdata->flags & IEEE80211_SDATA_OPERATING_GMODE))
-			qparam.cw_min = 31;
-		else
-			qparam.cw_min = 15;
-
-		qparam.cw_max = 1023;
-		qparam.txop = 0;
-
-		for (i = IEEE80211_TX_QUEUE_DATA0; i < NUM_TX_DATA_QUEUES; i++)
-			local->ops->conf_tx(local_to_hw(local),
-					   i + IEEE80211_TX_QUEUE_DATA0,
-					   &qparam);
-
-		/* IBSS uses different parameters for Beacon sending */
-		qparam.cw_min++;
-		qparam.cw_min *= 2;
-		qparam.cw_min--;
-		local->ops->conf_tx(local_to_hw(local),
-				   IEEE80211_TX_QUEUE_BEACON, &qparam);
-	}
-
 	ifsta = &sdata->u.sta;

 	if (ifsta->ssid_len != len || memcmp(ifsta->ssid, ssid, len) != 0)
