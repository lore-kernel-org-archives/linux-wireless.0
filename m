Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51276 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbYIIKyT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 06:54:19 -0400
Subject: [PATCH 14/8] mac80211: split ieee80211_sta_def_wmm_params
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080908154421.216772000@sipsolutions.net> (sfid-20080908_174606_739824_DD7A31F6)
References: <20080908154421.216772000@sipsolutions.net>
	 (sfid-20080908_174606_739824_DD7A31F6)
Content-Type: text/plain
Date: Tue, 09 Sep 2008 12:54:11 +0200
Message-Id: <1220957651.31304.144.camel@johannes.berg> (sfid-20080909_125422_296740_79F8DEF3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleans up the code a bit and prepares for the next patch
that will use the function elsewhere.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mlme.c |   48 +++++++++++++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 21 deletions(-)

--- everything.orig/net/mac80211/mlme.c	2008-09-09 12:36:16.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-09 12:51:17.000000000 +0200
@@ -539,13 +539,38 @@ static void ieee80211_send_refuse_measur
 }
 
 /* MLME */
+static void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_tx_queue_params qparam;
+	int i;
+
+	if (!local->ops->conf_tx)
+		return;
+
+	memset(&qparam, 0, sizeof(qparam));
+
+	qparam.aifs = 2;
+
+	if (local->hw.conf.channel->band == IEEE80211_BAND_2GHZ &&
+	    !(sdata->flags & IEEE80211_SDATA_OPERATING_GMODE))
+		qparam.cw_min = 31;
+	else
+		qparam.cw_min = 15;
+
+	qparam.cw_max = 1023;
+	qparam.txop = 0;
+
+	for (i = 0; i < local_to_hw(local)->queues; i++)
+		local->ops->conf_tx(local_to_hw(local), i, &qparam);
+}
+
 static void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
 					 struct ieee80211_sta_bss *bss)
 {
 	struct ieee80211_local *local = sdata->local;
 	int i, have_higher_than_11mbit = 0;
 
-
 	/* cf. IEEE 802.11 9.2.12 */
 	for (i = 0; i < bss->supp_rates_len; i++)
 		if ((bss->supp_rates[i] & 0x7f) * 5 > 110)
@@ -557,26 +582,7 @@ static void ieee80211_sta_def_wmm_params
 	else
 		sdata->flags &= ~IEEE80211_SDATA_OPERATING_GMODE;
 
-
-	if (local->ops->conf_tx) {
-		struct ieee80211_tx_queue_params qparam;
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
-		for (i = 0; i < local_to_hw(local)->queues; i++)
-			local->ops->conf_tx(local_to_hw(local), i, &qparam);
-	}
+	ieee80211_set_wmm_default(sdata);
 }
 
 static void ieee80211_sta_wmm_params(struct ieee80211_local *local,


