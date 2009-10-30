Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42592 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757052AbZJ3L4A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2009 07:56:00 -0400
Subject: [PATCH] mac80211: remove sent_ps_buffered
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Oct 2009 12:56:02 +0100
Message-ID: <1256903762.3555.50.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This variable is set once, and tested once.
However, the code path that can set it is
mutually exclusive with the code path that
tests it, so the test is always true. Thus
we also don't need to set it either and can
just remove the variable.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h |    1 -
 net/mac80211/rx.c          |    8 +++-----
 2 files changed, 3 insertions(+), 6 deletions(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-10-30 11:58:19.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-10-30 11:58:23.000000000 +0100
@@ -176,7 +176,6 @@ struct ieee80211_rx_data {
 	struct ieee80211_rate *rate;
 
 	unsigned int flags;
-	int sent_ps_buffered;
 	int queue;
 	u32 tkip_iv32;
 	u16 tkip_iv16;
--- wireless-testing.orig/net/mac80211/rx.c	2009-10-30 11:58:27.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2009-10-30 11:59:39.000000000 +0100
@@ -789,7 +789,7 @@ static void ap_sta_ps_start(struct sta_i
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
 }
 
-static int ap_sta_ps_end(struct sta_info *sta)
+static void ap_sta_ps_end(struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_local *local = sdata->local;
@@ -819,8 +819,6 @@ static int ap_sta_ps_end(struct sta_info
 	       "since STA not sleeping anymore\n", sdata->dev->name,
 	       sta->sta.addr, sta->sta.aid, sent - buffered, buffered);
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
-
-	return sent;
 }
 
 static ieee80211_rx_result debug_noinline
@@ -879,7 +877,7 @@ ieee80211_rx_h_sta_process(struct ieee80
 			 */
 			if (ieee80211_is_data(hdr->frame_control) &&
 			    !ieee80211_has_pm(hdr->frame_control))
-				rx->sent_ps_buffered += ap_sta_ps_end(sta);
+				ap_sta_ps_end(sta);
 		} else {
 			if (ieee80211_has_pm(hdr->frame_control))
 				ap_sta_ps_start(sta);
@@ -1147,7 +1145,7 @@ ieee80211_rx_h_ps_poll(struct ieee80211_
 		if (no_pending_pkts)
 			sta_info_clear_tim_bit(rx->sta);
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
-	} else if (!rx->sent_ps_buffered) {
+	} else {
 		/*
 		 * FIXME: This can be the result of a race condition between
 		 *	  us expiring a frame and the station polling for it.


