Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:34800 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752892Ab0H0TWI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 15:22:08 -0400
Date: Fri, 27 Aug 2010 22:22:00 +0300
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Do not generate CQM events based on first Beacon
 frames
Message-ID: <20100827192200.GB28502@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The signal strength value in a single RX frame is not that reliable,
so it is better to delay start of CQM events until there is a real
average signal strength from more than a single Beacon frame
available.

Signed-off-by: Jouni Malinen <j@w1.fi>

---
 net/mac80211/ieee80211_i.h |    7 +++++++
 net/mac80211/mlme.c        |    9 +++++++++
 2 files changed, 16 insertions(+)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-08-17 11:43:06.000000000 +0300
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-08-27 21:43:44.000000000 +0300
@@ -375,6 +375,13 @@ struct ieee80211_if_managed {
 	int ave_beacon_signal;
 
 	/*
+	 * Number of Beacon frames used in ave_beacon_signal. This can be used
+	 * to avoid generating less reliable cqm events that would be based
+	 * only on couple of received frames.
+	 */
+	unsigned int count_beacon_signal;
+
+	/*
 	 * Last Beacon frame signal strength average (ave_beacon_signal / 16)
 	 * that triggered a cqm event. 0 indicates that no event has been
 	 * generated for the current association.
--- wireless-testing.orig/net/mac80211/mlme.c	2010-08-27 21:43:37.000000000 +0300
+++ wireless-testing/net/mac80211/mlme.c	2010-08-27 21:43:44.000000000 +0300
@@ -54,6 +54,12 @@
  */
 #define IEEE80211_SIGNAL_AVE_WEIGHT	3
 
+/*
+ * How many Beacon frames need to have been used in average signal strength
+ * before starting to indicate signal change events.
+ */
+#define IEEE80211_SIGNAL_AVE_MIN_COUNT	4
+
 #define TMR_RUNNING_TIMER	0
 #define TMR_RUNNING_CHANSW	1
 
@@ -1550,13 +1556,16 @@ static void ieee80211_rx_mgmt_beacon(str
 		ifmgd->flags &= ~IEEE80211_STA_RESET_SIGNAL_AVE;
 		ifmgd->ave_beacon_signal = rx_status->signal * 16;
 		ifmgd->last_cqm_event_signal = 0;
+		ifmgd->count_beacon_signal = 1;
 	} else {
 		ifmgd->ave_beacon_signal =
 			(IEEE80211_SIGNAL_AVE_WEIGHT * rx_status->signal * 16 +
 			 (16 - IEEE80211_SIGNAL_AVE_WEIGHT) *
 			 ifmgd->ave_beacon_signal) / 16;
+		ifmgd->count_beacon_signal++;
 	}
 	if (bss_conf->cqm_rssi_thold &&
+	    ifmgd->count_beacon_signal >= IEEE80211_SIGNAL_AVE_MIN_COUNT &&
 	    !(local->hw.flags & IEEE80211_HW_SUPPORTS_CQM_RSSI)) {
 		int sig = ifmgd->ave_beacon_signal / 16;
 		int last_event = ifmgd->last_cqm_event_signal;

-- 
Jouni Malinen                                            PGP id EFC895FA
