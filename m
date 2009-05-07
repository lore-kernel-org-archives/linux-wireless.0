Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53822 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761395AbZEGOQ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 May 2009 10:16:28 -0400
Subject: [PATCH] mac80211: set default QoS values according to spec
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>, Jouni Malinen <j@w1.fi>
Content-Type: text/plain
Date: Thu, 07 May 2009 16:16:24 +0200
Message-Id: <1241705784.27208.28.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We've never really cared about the default QoS (WMM) values, but
we really should if the AP doesn't send any. This patch makes
mac80211 use the default values according to 802.11-2007, and
additionally syncs the default values when we disassociate so
whatever the last AP said gets "unconfigured".

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mlme.c |    4 +++
 net/mac80211/util.c |   58 ++++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 51 insertions(+), 11 deletions(-)

--- wireless-testing.orig/net/mac80211/util.c	2009-05-07 16:09:04.000000000 +0200
+++ wireless-testing/net/mac80211/util.c	2009-05-07 16:09:04.000000000 +0200
@@ -708,26 +708,62 @@ void ieee80211_set_wmm_default(struct ie
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_tx_queue_params qparam;
-	int i;
+	int queue;
+	bool use_11b;
+	int aCWmin, aCWmax;
 
 	if (!local->ops->conf_tx)
 		return;
 
 	memset(&qparam, 0, sizeof(qparam));
 
-	qparam.aifs = 2;
+	use_11b = (local->hw.conf.channel->band == IEEE80211_BAND_2GHZ) &&
+		 !(sdata->flags & IEEE80211_SDATA_OPERATING_GMODE);
 
-	if (local->hw.conf.channel->band == IEEE80211_BAND_2GHZ &&
-	    !(sdata->flags & IEEE80211_SDATA_OPERATING_GMODE))
-		qparam.cw_min = 31;
-	else
-		qparam.cw_min = 15;
+	for (queue = 0; queue < local_to_hw(local)->queues; queue++) {
+		/* Set defaults according to 802.11-2007 Table 7-37 */
+		aCWmax = 1023;
+		if (use_11b)
+			aCWmin = 31;
+		else
+			aCWmin = 15;
 
-	qparam.cw_max = 1023;
-	qparam.txop = 0;
+		switch (queue) {
+		case 3: /* AC_BK */
+			qparam.cw_max = aCWmin;
+			qparam.cw_min = aCWmax;
+			qparam.txop = 0;
+			qparam.aifs = 7;
+			break;
+		default: /* never happens but let's not leave undefined */
+		case 2: /* AC_BE */
+			qparam.cw_max = aCWmin;
+			qparam.cw_min = aCWmax;
+			qparam.txop = 0;
+			qparam.aifs = 3;
+			break;
+		case 1: /* AC_VI */
+			qparam.cw_max = aCWmin;
+			qparam.cw_min = (aCWmin + 1) / 2 - 1;
+			if (use_11b)
+				qparam.txop = 6016/32;
+			else
+				qparam.txop = 3008/32;
+			qparam.aifs = 2;
+			break;
+		case 0: /* AC_VO */
+			qparam.cw_max = (aCWmin + 1) / 2 - 1;
+			qparam.cw_min = (aCWmin + 1) / 4 - 1;
+			if (use_11b)
+				qparam.txop = 3264/32;
+			else
+				qparam.txop = 1504/32;
+			qparam.aifs = 2;
+			break;
+		}
 
-	for (i = 0; i < local_to_hw(local)->queues; i++)
-		drv_conf_tx(local, i, &qparam);
+		drv_conf_tx(local, queue, &qparam);
+	}
 }
 
 void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
--- wireless-testing.orig/net/mac80211/mlme.c	2009-05-07 16:09:03.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-05-07 16:14:02.000000000 +0200
@@ -1043,6 +1043,8 @@ static void ieee80211_set_disassoc(struc
 
 	rcu_read_unlock();
 
+	ieee80211_set_wmm_default(sdata);
+
 	ieee80211_recalc_idle(local);
 
 	/* channel(_type) changes are handled by ieee80211_hw_config */
@@ -1658,6 +1660,8 @@ static void ieee80211_rx_mgmt_assoc_resp
 	if (elems.wmm_param)
 		ieee80211_sta_wmm_params(local, ifmgd, elems.wmm_param,
 					 elems.wmm_param_len);
+	else
+		ieee80211_set_wmm_default(sdata);
 
 	if (elems.ht_info_elem && elems.wmm_param &&
 	    (ifmgd->flags & IEEE80211_STA_WMM_ENABLED) &&


