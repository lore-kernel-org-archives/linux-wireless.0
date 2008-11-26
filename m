Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45762 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbYKZODa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 09:03:30 -0500
Subject: [PATCH] mac80211: only transition STAs ps->wake on data frames
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
Content-Type: text/plain
Date: Wed, 26 Nov 2008 15:02:58 +0100
Message-Id: <1227708178.4613.110.camel@johannes.berg> (sfid-20081126_150334_469360_B65359AA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a station goes to PS mode to scan, it will then send
probe requests without the PS bit set. mac80211 will take
that as indication that the station woke up, but it didn't.
This patch changes mac80211 to only consider doze->wake
transitions on data frames to to fix that issue.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <j@w1.fi>
---
 net/mac80211/rx.c |   28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

--- everything.orig/net/mac80211/rx.c	2008-11-23 14:58:21.000000000 +0100
+++ everything/net/mac80211/rx.c	2008-11-23 15:04:47.000000000 +0100
@@ -744,17 +744,29 @@ ieee80211_rx_h_sta_process(struct ieee80
 	sta->last_qual = rx->status->qual;
 	sta->last_noise = rx->status->noise;
 
+	/*
+	 * Change STA power saving mode only at the end of a frame
+	 * exchange sequence.
+	 */
 	if (!ieee80211_has_morefrags(hdr->frame_control) &&
 	    (rx->sdata->vif.type == NL80211_IFTYPE_AP ||
 	     rx->sdata->vif.type == NL80211_IFTYPE_AP_VLAN)) {
-		/* Change STA power saving mode only in the end of a frame
-		 * exchange sequence */
-		if (test_sta_flags(sta, WLAN_STA_PS) &&
-		    !ieee80211_has_pm(hdr->frame_control))
-			rx->sent_ps_buffered += ap_sta_ps_end(sta);
-		else if (!test_sta_flags(sta, WLAN_STA_PS) &&
-			 ieee80211_has_pm(hdr->frame_control))
-			ap_sta_ps_start(sta);
+		if (test_sta_flags(sta, WLAN_STA_PS)) {
+			/*
+			 * Ignore doze->wake transitions that are
+			 * indicated by non-data frames, the standard
+			 * is unclear here, but for example going to
+			 * PS mode and then scanning would cause a
+			 * doze->wake transition for the probe request,
+			 * and that is clearly undesirable.
+			 */
+			if (ieee80211_is_data(hdr->frame_control) &&
+			    !ieee80211_has_pm(hdr->frame_control))
+				rx->sent_ps_buffered += ap_sta_ps_end(sta);
+		} else {
+			if (ieee80211_has_pm(hdr->frame_control))
+				ap_sta_ps_start(sta);
+		}
 	}
 
 	/* Drop data::nullfunc frames silently, since they are used only to


