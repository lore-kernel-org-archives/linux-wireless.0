Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:23981 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758905AbYCCUUf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2008 15:20:35 -0500
Received: by wa-out-1112.google.com with SMTP id v27so277416wah.23
        for <linux-wireless@vger.kernel.org>; Mon, 03 Mar 2008 12:20:35 -0800 (PST)
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Fri, 29 Feb 2008 12:32:46 -0800
Subject: [PATCH 04/10] mac80211: breakdown mesh network attributes in different extra fields for wext
Message-ID: <47cc5d92.26d7720a.13e8.ffffad1b@mx.google.com> (sfid-20080303_202058_137732_FFE21D73)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 net/mac80211/ieee80211_sta.c |   35 ++++++++++++++++++++++++++---------
 1 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index c9d0018..75ced9a 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -3976,18 +3976,35 @@ ieee80211_sta_scan_result(struct net_device *dev,
 	if (bss_mesh_cfg(bss)) {
 		char *buf;
 		u8 *cfg = bss_mesh_cfg(bss);
-		buf = kmalloc(200, GFP_ATOMIC);
+		buf = kmalloc(50, GFP_ATOMIC);
 		if (buf) {
 			memset(&iwe, 0, sizeof(iwe));
 			iwe.cmd = IWEVCUSTOM;
-			sprintf(buf, "Mesh network (version %d)\n"
-			"\t\t\tPath Selection Protocol ID: 0x%02X%02X%02X%02X\n"
-			"\t\t\tPath Selection Metric ID: 0x%02X%02X%02X%02X\n"
-			"\t\t\tCongestion Control Mode ID: 0x%02X%02X%02X%02X\n"
-			"\t\t\tChannel Precedence: 0x%02X%02X%02X%02X",
-			cfg[0], cfg[1], cfg[2], cfg[3], cfg[4], cfg[5], cfg[6],
-			cfg[7], cfg[8], cfg[9], cfg[10], cfg[11], cfg[12],
-			cfg[13], cfg[14], cfg[15], cfg[16]);
+			sprintf(buf, "Mesh network (version %d)", cfg[0]);
+			iwe.u.data.length = strlen(buf);
+			current_ev = iwe_stream_add_point(current_ev, end_buf,
+							  &iwe, buf);
+			sprintf(buf, "Path Selection Protocol ID: "
+				"0x%02X%02X%02X%02X", cfg[1], cfg[2], cfg[3],
+							cfg[4]);
+			iwe.u.data.length = strlen(buf);
+			current_ev = iwe_stream_add_point(current_ev, end_buf,
+							  &iwe, buf);
+			sprintf(buf, "Path Selection Metric ID: "
+				"0x%02X%02X%02X%02X", cfg[5], cfg[6], cfg[7],
+							cfg[8]);
+			iwe.u.data.length = strlen(buf);
+			current_ev = iwe_stream_add_point(current_ev, end_buf,
+							  &iwe, buf);
+			sprintf(buf, "Congestion Control Mode ID: "
+				"0x%02X%02X%02X%02X", cfg[9], cfg[10],
+							cfg[11], cfg[12]);
+			iwe.u.data.length = strlen(buf);
+			current_ev = iwe_stream_add_point(current_ev, end_buf,
+							  &iwe, buf);
+			sprintf(buf, "Channel Precedence: "
+				"0x%02X%02X%02X%02X", cfg[13], cfg[14],
+							cfg[15], cfg[16]);
 			iwe.u.data.length = strlen(buf);
 			current_ev = iwe_stream_add_point(current_ev, end_buf,
 							  &iwe, buf);
-- 
1.5.2.5



