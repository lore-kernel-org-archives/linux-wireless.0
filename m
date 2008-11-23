Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53856 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758195AbYKWOcm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Nov 2008 09:32:42 -0500
Subject: Re: Fwd: p54: testing AP mode: cannot switch to master mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefan Steuerwald <salsasepp@googlemail.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <f76a32050811210037x5958de39g53b174b2d0dfd41b@mail.gmail.com> (sfid-20081121_093709_047280_C86566C8)
References: <f76a32050811190306s6a86f46dwc245200069ff8a82@mail.gmail.com>
	 <200811201537.19047.hs4233@mail.mn-solutions.de>
	 <f76a32050811201121r27ba1d82ma788e5a55bfd422b@mail.gmail.com>
	 <200811210838.25977.hs4233@mail.mn-solutions.de>
	 <f76a32050811210037x5958de39g53b174b2d0dfd41b@mail.gmail.com>
	 (sfid-20081121_093709_047280_C86566C8)
Content-Type: text/plain
Date: Sun, 23 Nov 2008 15:32:38 +0100
Message-Id: <1227450758.3599.48.camel@johannes.berg> (sfid-20081123_153246_551740_CE3A1B13)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Can you trhis this patch?

Also, next time please don't filter the captures so much, it made it
hard to diagnose the problem.

johannes


Subject: mac80211: only transition STAs ps->wake on data frames

When a station goes to PS mode to scan, it will then send
probe requests without the PS bit set. mac80211 will take
that as indication that the station woke up, but it didn't.
This patch changes mac80211 to only consider doze->wake
transitions on data frames to to fix that issue.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/rx.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- everything.orig/net/mac80211/rx.c	2008-11-23 14:58:21.000000000 +0100
+++ everything/net/mac80211/rx.c	2008-11-23 14:59:58.000000000 +0100
@@ -750,9 +750,11 @@ ieee80211_rx_h_sta_process(struct ieee80
 		/* Change STA power saving mode only in the end of a frame
 		 * exchange sequence */
 		if (test_sta_flags(sta, WLAN_STA_PS) &&
-		    !ieee80211_has_pm(hdr->frame_control))
-			rx->sent_ps_buffered += ap_sta_ps_end(sta);
-		else if (!test_sta_flags(sta, WLAN_STA_PS) &&
+		    !ieee80211_has_pm(hdr->frame_control)) {
+			/* ignore PS bit on non-data frames */
+			if (ieee80211_is_data(hdr->frame_control))
+				rx->sent_ps_buffered += ap_sta_ps_end(sta);
+		} else if (!test_sta_flags(sta, WLAN_STA_PS) &&
 			 ieee80211_has_pm(hdr->frame_control))
 			ap_sta_ps_start(sta);
 	}


