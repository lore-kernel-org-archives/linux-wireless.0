Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:17851 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755491AbZKRSaD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 13:30:03 -0500
Received: by ey-out-2122.google.com with SMTP id d26so234939eyd.5
        for <linux-wireless@vger.kernel.org>; Wed, 18 Nov 2009 10:30:08 -0800 (PST)
From: Rui Paulo <rpaulo@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Rui Paulo <rpaulo@gmail.com>
Subject: [PATCH] mac80211: update cfg80211 scan result code for the updated mesh conf IE
Date: Wed, 18 Nov 2009 18:22:59 +0000
Message-Id: <1258568579-21900-2-git-send-email-rpaulo@gmail.com>
In-Reply-To: <1258568579-21900-1-git-send-email-rpaulo@gmail.com>
References: <1258568579-21900-1-git-send-email-rpaulo@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rui Paulo <rpaulo@gmail.com>
---
 net/wireless/scan.c |   31 ++++++++++++++++++-------------
 1 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index d03447d..227d57b 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -874,35 +874,40 @@ ieee80211_bss(struct wiphy *wiphy, struct iw_request_info *info,
 			cfg = ie + 2;
 			memset(&iwe, 0, sizeof(iwe));
 			iwe.cmd = IWEVCUSTOM;
-			sprintf(buf, "Mesh network (version %d)", cfg[0]);
+			sprintf(buf, "Mesh Network Path Selection Protocol ID: "
+				"0x%02X", cfg[0]);
 			iwe.u.data.length = strlen(buf);
 			current_ev = iwe_stream_add_point(info, current_ev,
 							  end_buf,
 							  &iwe, buf);
-			sprintf(buf, "Path Selection Protocol ID: "
-				"0x%02X%02X%02X%02X", cfg[1], cfg[2], cfg[3],
-							cfg[4]);
+			sprintf(buf, "Path Selection Metric ID: 0x%02X",
+				cfg[1]);
 			iwe.u.data.length = strlen(buf);
 			current_ev = iwe_stream_add_point(info, current_ev,
 							  end_buf,
 							  &iwe, buf);
-			sprintf(buf, "Path Selection Metric ID: "
-				"0x%02X%02X%02X%02X", cfg[5], cfg[6], cfg[7],
-							cfg[8]);
+			sprintf(buf, "Congestion Control Mode ID: 0x%02X",
+				cfg[2]);
 			iwe.u.data.length = strlen(buf);
 			current_ev = iwe_stream_add_point(info, current_ev,
 							  end_buf,
 							  &iwe, buf);
-			sprintf(buf, "Congestion Control Mode ID: "
-				"0x%02X%02X%02X%02X", cfg[9], cfg[10],
-							cfg[11], cfg[12]);
+			sprintf(buf, "Synchronization ID: 0x%02X", cfg[3]);
 			iwe.u.data.length = strlen(buf);
 			current_ev = iwe_stream_add_point(info, current_ev,
 							  end_buf,
 							  &iwe, buf);
-			sprintf(buf, "Channel Precedence: "
-				"0x%02X%02X%02X%02X", cfg[13], cfg[14],
-							cfg[15], cfg[16]);
+			sprintf(buf, "Authentication ID: 0x%02X", cfg[4]);
+			iwe.u.data.length = strlen(buf);
+			current_ev = iwe_stream_add_point(info, current_ev,
+							  end_buf,
+							  &iwe, buf);
+			sprintf(buf, "Formation Info: 0x%02X", cfg[5]);
+			iwe.u.data.length = strlen(buf);
+			current_ev = iwe_stream_add_point(info, current_ev,
+							  end_buf,
+							  &iwe, buf);
+			sprintf(buf, "Capabilities: 0x%02X", cfg[6]);
 			iwe.u.data.length = strlen(buf);
 			current_ev = iwe_stream_add_point(info, current_ev,
 							  end_buf,
-- 
1.5.6.5

