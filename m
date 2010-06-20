Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:2751 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753889Ab0FTS2S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jun 2010 14:28:18 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 11/11] mac80211: Fix compile warning in scan.c.
Date: Sun, 20 Jun 2010 20:28:07 +0200
Message-Id: <1277058487-11803-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix the following compile warning:

CC [M]  net/mac80211/scan.o
net/mac80211/scan.c: In function 'ieee80211_request_internal_scan':
net/mac80211/scan.c:749:23: warning: comparison between 'enum nl80211_band' and 'enum ieee80211_band'

caused by the local variable band not being of the proper 'ieee80211_band' type.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 net/mac80211/scan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 30d4c0d..9aa19ec 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -735,7 +735,7 @@ int ieee80211_request_internal_scan(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_local *local = sdata->local;
 	int ret = -EBUSY;
-	enum nl80211_band band;
+	enum ieee80211_band band;
 
 	mutex_lock(&local->scan_mtx);
 
-- 
1.7.1

