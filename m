Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51334 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbYIIK4J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 06:56:09 -0400
Subject: [PATCH] mac80211: initialise queue QoS parameters at hw start
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 09 Sep 2008 12:56:01 +0200
Message-Id: <1220957761.31304.147.camel@johannes.berg> (sfid-20080909_125612_958905_E0FE412C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When hardware is started it might be in a confused state with
respect to queue QoS parameters. This patch changes mac80211
to set sane defaults right after the hardware is brought up.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Buesch <mb@bu3sch.de>
---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/main.c        |    9 ++++++++-
 net/mac80211/mlme.c        |   26 --------------------------
 net/mac80211/util.c        |   26 ++++++++++++++++++++++++++
 4 files changed, 35 insertions(+), 27 deletions(-)

--- everything.orig/net/mac80211/ieee80211_i.h	2008-09-09 12:51:17.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-09-09 12:52:01.000000000 +0200
@@ -987,6 +987,7 @@ int ieee80211_frame_duration(struct ieee
 			     int rate, int erp, int short_preamble);
 void mac80211_ev_michael_mic_failure(struct ieee80211_sub_if_data *sdata, int keyidx,
 				     struct ieee80211_hdr *hdr);
+void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata);
 
 #ifdef CONFIG_MAC80211_NOINLINE
 #define debug_noinline noinline
--- everything.orig/net/mac80211/mlme.c	2008-09-09 12:51:17.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-09 12:52:01.000000000 +0200
@@ -539,32 +539,6 @@ static void ieee80211_send_refuse_measur
 }
 
 /* MLME */
-static void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata)
-{
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_tx_queue_params qparam;
-	int i;
-
-	if (!local->ops->conf_tx)
-		return;
-
-	memset(&qparam, 0, sizeof(qparam));
-
-	qparam.aifs = 2;
-
-	if (local->hw.conf.channel->band == IEEE80211_BAND_2GHZ &&
-	    !(sdata->flags & IEEE80211_SDATA_OPERATING_GMODE))
-		qparam.cw_min = 31;
-	else
-		qparam.cw_min = 15;
-
-	qparam.cw_max = 1023;
-	qparam.txop = 0;
-
-	for (i = 0; i < local_to_hw(local)->queues; i++)
-		local->ops->conf_tx(local_to_hw(local), i, &qparam);
-}
-
 static void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
 					 struct ieee80211_sta_bss *bss)
 {
--- everything.orig/net/mac80211/util.c	2008-09-09 12:51:17.000000000 +0200
+++ everything/net/mac80211/util.c	2008-09-09 12:52:01.000000000 +0200
@@ -572,3 +572,29 @@ void ieee802_11_parse_elems(u8 *start, s
 		pos += elen;
 	}
 }
+
+void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata)
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
--- everything.orig/net/mac80211/main.c	2008-09-09 12:51:17.000000000 +0200
+++ everything/net/mac80211/main.c	2008-09-09 12:52:01.000000000 +0200
@@ -399,8 +399,15 @@ static int ieee80211_open(struct net_dev
 		atomic_inc(&local->iff_promiscs);
 
 	local->open_count++;
-	if (need_hw_reconfig)
+	if (need_hw_reconfig) {
 		ieee80211_hw_config(local);
+		/*
+		 * set default queue parameters so drivers don't
+		 * need to initialise the hardware if the hardware
+		 * doesn't start up with sane defaults
+		 */
+		ieee80211_set_wmm_default(sdata);
+	}
 
 	/*
 	 * ieee80211_sta_work is disabled while network interface


