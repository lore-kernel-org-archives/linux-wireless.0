Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2345 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449AbXKUQz4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2007 11:55:56 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: remove "bcn_int" and "capab" scan results info
Date: Wed, 21 Nov 2007 11:55:38 -0500
Message-Id: <1195664138-21789-1-git-send-email-linville@tuxdriver.com> (sfid-20071121_165600_205296_3E25D72F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These bits were dead code before "mac80211: Remove local->scan_flags"
(commit 6681dd3fd0e4d36a4547415853e83411baa7b705) and probably should
have been removed as part of that commit.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/ieee80211_sta.c |   25 -------------------------
 1 files changed, 0 insertions(+), 25 deletions(-)

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 2a321f0..936f1cd 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -3001,31 +3001,6 @@ ieee80211_sta_scan_result(struct net_device *dev,
 		}
 	}
 
-	do {
-		char *buf;
-
-		buf = kmalloc(100, GFP_ATOMIC);
-		if (!buf)
-			break;
-
-		memset(&iwe, 0, sizeof(iwe));
-		iwe.cmd = IWEVCUSTOM;
-		sprintf(buf, "bcn_int=%d", bss->beacon_int);
-		iwe.u.data.length = strlen(buf);
-		current_ev = iwe_stream_add_point(current_ev, end_buf, &iwe,
-						  buf);
-
-		memset(&iwe, 0, sizeof(iwe));
-		iwe.cmd = IWEVCUSTOM;
-		sprintf(buf, "capab=0x%04x", bss->capability);
-		iwe.u.data.length = strlen(buf);
-		current_ev = iwe_stream_add_point(current_ev, end_buf, &iwe,
-						  buf);
-
-		kfree(buf);
-		break;
-	} while (0);
-
 	return current_ev;
 }
 
-- 
1.5.3.3

