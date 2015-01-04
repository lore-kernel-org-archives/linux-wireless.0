Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:51439 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbbADKNa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Jan 2015 05:13:30 -0500
Received: by mail-wg0-f49.google.com with SMTP id n12so25905816wgh.22
        for <linux-wireless@vger.kernel.org>; Sun, 04 Jan 2015 02:13:29 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/3] mac80211: don't defer scans in case of radar detection
Date: Sun,  4 Jan 2015 12:13:18 +0200
Message-Id: <1420366399-31535-2-git-send-email-eliad@wizery.com> (sfid-20150104_111344_824089_5D605F41)
In-Reply-To: <1420366399-31535-1-git-send-email-eliad@wizery.com>
References: <1420366399-31535-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Radar detection can last indefinite time. There is no
point in deferring a scan request in this case - simply
return -EBUSY.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index ae84267..4525623 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -505,7 +505,7 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 
 	lockdep_assert_held(&local->mtx);
 
-	if (local->scan_req)
+	if (local->scan_req || local->radar_detect_enabled)
 		return -EBUSY;
 
 	if (!ieee80211_can_scan(local, sdata)) {
-- 
1.8.5.2.229.g4448466.dirty

