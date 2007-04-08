Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-04.rdc-kc.rr.com ([24.94.166.116]:38497 "EHLO
	ms-smtp-04.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbXDHGH0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Apr 2007 02:07:26 -0400
Date: Sun, 08 Apr 2007 00:04:42 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Report correct wireless statistics
Message-ID: <461877ea.cyxM3SSnr6WhYkjX%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In mac80211 the 'qual' and 'level' values are interchanged. The patch also
places the 'qual' value on a 0 - 100 scale and calculated using the formula
contained in iwlib.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John and Michael,

This fix is meant for the wireless-dev and mb git trees.

Larry

 ieee80211_ioctl.c |   16 +++++++++++-----
 ieee80211_sta.c   |    9 +++++++--
 2 files changed, 18 insertions(+), 7 deletions(-)

Index: wireless-mb/net/mac80211/ieee80211_sta.c
===================================================================
--- wireless-mb.orig/net/mac80211/ieee80211_sta.c
+++ wireless-mb/net/mac80211/ieee80211_sta.c
@@ -2822,8 +2822,10 @@ ieee80211_sta_scan_result(struct net_dev
 
 	memset(&iwe, 0, sizeof(iwe));
 	iwe.cmd = IWEVQUAL;
-	iwe.u.qual.qual = bss->signal;
-	iwe.u.qual.level = bss->rssi;
+	iwe.u.qual.level = bss->signal;
+	if (unlikely(local->hw.max_rssi == 0))
+		local->hw.max_rssi = 100;
+	iwe.u.qual.qual = (100 * bss->rssi) / local->hw.max_rssi;
 	iwe.u.qual.noise = bss->noise;
 	iwe.u.qual.updated = local->wstats_flags;
 	current_ev = iwe_stream_add_event(current_ev, end_buf, &iwe,
Index: wireless-mb/net/mac80211/ieee80211_ioctl.c
===================================================================
--- wireless-mb.orig/net/mac80211/ieee80211_ioctl.c
+++ wireless-mb/net/mac80211/ieee80211_ioctl.c
@@ -1593,12 +1593,12 @@ static int ieee80211_ioctl_giwrange(stru
 	range->min_frag = 256;
 	range->max_frag = 2346;
 
-	range->max_qual.qual = local->hw.max_signal;
-	range->max_qual.level = local->hw.max_rssi;
+	range->max_qual.qual = 100;
+	range->max_qual.level = local->hw.max_signal;
 	range->max_qual.noise = local->hw.max_noise;
 	range->max_qual.updated = local->wstats_flags;
 
-	range->avg_qual.qual = local->hw.max_signal/2;
+	range->avg_qual.qual = 50;
 	range->avg_qual.level = 0;
 	range->avg_qual.noise = 0;
 	range->avg_qual.updated = local->wstats_flags;
@@ -3087,8 +3087,10 @@ static struct iw_statistics *ieee80211_g
 		wstats->qual.noise = 0;
 		wstats->qual.updated = IW_QUAL_ALL_INVALID;
 	} else {
-		wstats->qual.level = sta->last_rssi;
-		wstats->qual.qual = sta->last_signal;
+		if (unlikely(local->hw.max_rssi == 0))
+			local->hw.max_rssi = 100;
+		wstats->qual.qual = (100 * sta->last_rssi) / local->hw.max_rssi;
+		wstats->qual.level = sta->last_signal;
 		wstats->qual.noise = sta->last_noise;
 		wstats->qual.updated = local->wstats_flags;
 		sta_info_put(sta);
