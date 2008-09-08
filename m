Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54490 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbYIHPpk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 11:45:40 -0400
Message-Id: <20080908154441.770355000@sipsolutions.net> (sfid-20080908_174544_422002_F2C9BE27)
References: <20080908154421.216772000@sipsolutions.net>
Date: Mon, 08 Sep 2008 17:44:24 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/8] mac80211: remove useless non-NULL tests from scan
	results code
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm surprised nobody complained about these before. What a waste.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mlme.c |   40 ++++++++++++++++++----------------------
 1 file changed, 18 insertions(+), 22 deletions(-)

--- everything.orig/net/mac80211/mlme.c	2008-09-08 15:42:38.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-08 15:42:40.000000000 +0200
@@ -3823,6 +3823,7 @@ ieee80211_sta_scan_result(struct ieee802
 			  char *current_ev, char *end_buf)
 {
 	struct iw_event iwe;
+	char *buf;
 
 	if (time_after(jiffies,
 		       bss->last_update + IEEE80211_SCAN_RESULT_EXPIRE))
@@ -3897,7 +3898,7 @@ ieee80211_sta_scan_result(struct ieee802
 
 	ieee80211_sta_add_scan_ies(info, bss, &current_ev, end_buf);
 
-	if (bss && bss->supp_rates_len > 0) {
+	if (bss->supp_rates_len > 0) {
 		/* display all supported rates in readable format */
 		char *p = current_ev + iwe_stream_lcp_len(info);
 		int i;
@@ -3916,30 +3917,25 @@ ieee80211_sta_scan_result(struct ieee802
 		current_ev = p;
 	}
 
-	if (bss) {
-		char *buf;
-		buf = kmalloc(30, GFP_ATOMIC);
-		if (buf) {
-			memset(&iwe, 0, sizeof(iwe));
-			iwe.cmd = IWEVCUSTOM;
-			sprintf(buf, "tsf=%016llx", (unsigned long long)(bss->timestamp));
-			iwe.u.data.length = strlen(buf);
-			current_ev = iwe_stream_add_point(info, current_ev,
-							  end_buf,
-							  &iwe, buf);
-			memset(&iwe, 0, sizeof(iwe));
-			iwe.cmd = IWEVCUSTOM;
-			sprintf(buf, " Last beacon: %dms ago",
-				jiffies_to_msecs(jiffies - bss->last_update));
-			iwe.u.data.length = strlen(buf);
-			current_ev = iwe_stream_add_point(info, current_ev,
-							  end_buf, &iwe, buf);
-			kfree(buf);
-		}
+	buf = kmalloc(30, GFP_ATOMIC);
+	if (buf) {
+		memset(&iwe, 0, sizeof(iwe));
+		iwe.cmd = IWEVCUSTOM;
+		sprintf(buf, "tsf=%016llx", (unsigned long long)(bss->timestamp));
+		iwe.u.data.length = strlen(buf);
+		current_ev = iwe_stream_add_point(info, current_ev, end_buf,
+						  &iwe, buf);
+		memset(&iwe, 0, sizeof(iwe));
+		iwe.cmd = IWEVCUSTOM;
+		sprintf(buf, " Last beacon: %dms ago",
+			jiffies_to_msecs(jiffies - bss->last_update));
+		iwe.u.data.length = strlen(buf);
+		current_ev = iwe_stream_add_point(info, current_ev,
+						  end_buf, &iwe, buf);
+		kfree(buf);
 	}
 
 	if (bss_mesh_cfg(bss)) {
-		char *buf;
 		u8 *cfg = bss_mesh_cfg(bss);
 		buf = kmalloc(50, GFP_ATOMIC);
 		if (buf) {

-- 

