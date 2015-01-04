Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:46180 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbbADKNb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Jan 2015 05:13:31 -0500
Received: by mail-wg0-f53.google.com with SMTP id x13so8271152wgg.12
        for <linux-wireless@vger.kernel.org>; Sun, 04 Jan 2015 02:13:30 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/3] mac80211: always recalc_radar on chanctx changes
Date: Sun,  4 Jan 2015 12:13:19 +0200
Message-Id: <1420366399-31535-3-git-send-email-eliad@wizery.com> (sfid-20150104_111345_459950_75309A50)
In-Reply-To: <1420366399-31535-1-git-send-email-eliad@wizery.com>
References: <1420366399-31535-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_recalc_radar_chanctx() changes the global
local->radar_detect_enabled in case of a change
from the current chanctx radar_enabled state.

Thus, we need to make sure it will be called
even if the current chanctx is going to be
freed (so local->radar_detect_enabled will
be cleared if needed).

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/chan.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 7f83451..9261cc0 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -629,10 +629,12 @@ out:
 
 	sdata->vif.bss_conf.idle = !conf;
 
+	if (curr_ctx)
+		ieee80211_recalc_radar_chanctx(local, curr_ctx);
+
 	if (curr_ctx && ieee80211_chanctx_num_assigned(local, curr_ctx) > 0) {
 		ieee80211_recalc_chanctx_chantype(local, curr_ctx);
 		ieee80211_recalc_smps_chanctx(local, curr_ctx);
-		ieee80211_recalc_radar_chanctx(local, curr_ctx);
 		ieee80211_recalc_chanctx_min_def(local, curr_ctx);
 	}
 
-- 
1.8.5.2.229.g4448466.dirty

