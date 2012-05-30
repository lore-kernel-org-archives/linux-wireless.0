Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932264Ab2E3I47 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 04:56:59 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH] mac80211: configure 11b/g channel access rules for legacy APs
Date: Wed, 30 May 2012 10:56:46 +0200
Message-Id: <1338368206-30411-1-git-send-email-sgruszka@redhat.com> (sfid-20120530_105702_995433_9D29EDFC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For each EDCA TX queue change default settings (in STA mode) to conform
old 802.11b/g channel access rules. This is needed for drivers that do
not have QoS enable/disable "switch" (like rt2x00) to make them work
properly with legacy APs.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/util.c |   80 +++++++++++++++++++++++++++++---------------------
 1 files changed, 46 insertions(+), 34 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index a44c680..bf1c49a 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -804,7 +804,7 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_tx_queue_params qparam;
 	int ac;
-	bool use_11b;
+	bool use_11b, enable_qos;
 	int aCWmin, aCWmax;
 
 	if (!local->ops->conf_tx)
@@ -818,6 +818,13 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
 	use_11b = (local->hw.conf.channel->band == IEEE80211_BAND_2GHZ) &&
 		 !(sdata->flags & IEEE80211_SDATA_OPERATING_GMODE);
 
+	/*
+	 * By default disable QoS in STA mode for old access points, which do
+	 * not support 802.11e. New APs will provide proper queue parameters,
+	 * that we will configure later.
+	 */
+	enable_qos = (sdata->vif.type != NL80211_IFTYPE_STATION);
+
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
 		/* Set defaults according to 802.11-2007 Table 7-37 */
 		aCWmax = 1023;
@@ -826,38 +833,47 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
 		else
 			aCWmin = 15;
 
-		switch (ac) {
-		case IEEE80211_AC_BK:
-			qparam.cw_max = aCWmax;
-			qparam.cw_min = aCWmin;
-			qparam.txop = 0;
-			qparam.aifs = 7;
-			break;
-		default: /* never happens but let's not leave undefined */
-		case IEEE80211_AC_BE:
+		if (enable_qos) {
+			switch (ac) {
+			case IEEE80211_AC_BK:
+				qparam.cw_max = aCWmax;
+				qparam.cw_min = aCWmin;
+				qparam.txop = 0;
+				qparam.aifs = 7;
+				break;
+			/* never happens but let's not leave undefined */
+			default:
+			case IEEE80211_AC_BE:
+				qparam.cw_max = aCWmax;
+				qparam.cw_min = aCWmin;
+				qparam.txop = 0;
+				qparam.aifs = 3;
+				break;
+			case IEEE80211_AC_VI:
+				qparam.cw_max = aCWmin;
+				qparam.cw_min = (aCWmin + 1) / 2 - 1;
+				if (use_11b)
+					qparam.txop = 6016/32;
+				else
+					qparam.txop = 3008/32;
+				qparam.aifs = 2;
+				break;
+			case IEEE80211_AC_VO:
+				qparam.cw_max = (aCWmin + 1) / 2 - 1;
+				qparam.cw_min = (aCWmin + 1) / 4 - 1;
+				if (use_11b)
+					qparam.txop = 3264/32;
+				else
+					qparam.txop = 1504/32;
+				qparam.aifs = 2;
+				break;
+			}
+		} else {
+			/* Confiure old 802.11b/g medium access rules. */
 			qparam.cw_max = aCWmax;
 			qparam.cw_min = aCWmin;
 			qparam.txop = 0;
-			qparam.aifs = 3;
-			break;
-		case IEEE80211_AC_VI:
-			qparam.cw_max = aCWmin;
-			qparam.cw_min = (aCWmin + 1) / 2 - 1;
-			if (use_11b)
-				qparam.txop = 6016/32;
-			else
-				qparam.txop = 3008/32;
-			qparam.aifs = 2;
-			break;
-		case IEEE80211_AC_VO:
-			qparam.cw_max = (aCWmin + 1) / 2 - 1;
-			qparam.cw_min = (aCWmin + 1) / 4 - 1;
-			if (use_11b)
-				qparam.txop = 3264/32;
-			else
-				qparam.txop = 1504/32;
 			qparam.aifs = 2;
-			break;
 		}
 
 		qparam.uapsd = false;
@@ -866,12 +882,8 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
 		drv_conf_tx(local, sdata, ac, &qparam);
 	}
 
-	/* after reinitialize QoS TX queues setting to default,
-	 * disable QoS at all */
-
 	if (sdata->vif.type != NL80211_IFTYPE_MONITOR) {
-		sdata->vif.bss_conf.qos =
-			sdata->vif.type != NL80211_IFTYPE_STATION;
+		sdata->vif.bss_conf.qos = enable_qos;
 		if (bss_notify)
 			ieee80211_bss_info_change_notify(sdata,
 							 BSS_CHANGED_QOS);
-- 
1.7.1

