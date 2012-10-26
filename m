Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:54839 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933294Ab2JZOma (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2012 10:42:30 -0400
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <ordex@autistici.org>
Subject: [PATCH 1/2] iw: show AP scan capability
Date: Fri, 26 Oct 2012 16:41:47 +0200
Message-Id: <1351262508-23386-1-git-send-email-ordex@autistici.org> (sfid-20121026_164250_303262_BB1171E2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the wireless driver supports the AP scan capability (this can be
seen by checking NL80211_FEATURE_AP_SCAN) iw has to show it.

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
---
 info.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/info.c b/info.c
index 799f6d3..5dab1e8 100644
--- a/info.c
+++ b/info.c
@@ -448,6 +448,8 @@ broken_combination:
 			printf("\tDevice supports low priority scan.\n");
 		if (features & NL80211_FEATURE_SCAN_FLUSH)
 			printf("\tDevice supports scan flush.\n");
+		if (features & NL80211_FEATURE_AP_SCAN)
+			printf("\tDevice supports AP scan.\n");
 	}
 
 	return NL_SKIP;
-- 
1.7.12.4

