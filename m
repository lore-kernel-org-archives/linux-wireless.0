Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55886 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbaAVWz3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 17:55:29 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 1/2] mac80211:  Extra debug info for station cleanup case.
Date: Wed, 22 Jan 2014 14:54:55 -0800
Message-Id: <1390431296-20568-1-git-send-email-greearb@candelatech.com> (sfid-20140122_235532_670534_4FD6E588)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 net/mac80211/sta_info.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index decd30c..83238b8 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -877,7 +877,9 @@ static void __sta_info_destroy_part2(struct sta_info *sta)
 	if (sta->uploaded) {
 		ret = drv_sta_state(local, sdata, sta, IEEE80211_STA_NONE,
 				    IEEE80211_STA_NOTEXIST);
-		WARN_ON_ONCE(ret != 0);
+		if (WARN_ON_ONCE(ret != 0))
+			sdata_info(sdata, "sta-info-destroy: drv-sta-state error: %i, sta: %pM\n",
+				   ret, sta->sta.addr);
 	}
 
 	sta_dbg(sdata, "Removed STA %pM\n", sta->sta.addr);
-- 
1.7.11.7

