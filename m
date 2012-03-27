Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26871 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357Ab2C0Fan (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2012 01:30:43 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v2] mac80211: fix oper channel timestamp updation
Date: Tue, 27 Mar 2012 11:01:06 +0530
Message-ID: <1332826266-26673-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120327_073047_116048_76174616)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Whenever the station informs the AP that it is about to leave the
operating channel, the timestamp should be recorded. It is handled
in scan resume but not in scan start. Fix that.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
v2: updated commit log
 net/mac80211/scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 33cd169..c70e176 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -370,7 +370,7 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local)
 	 */
 	drv_sw_scan_start(local);
 
-	local->leave_oper_channel_time = 0;
+	local->leave_oper_channel_time = jiffies;
 	local->next_scan_state = SCAN_DECISION;
 	local->scan_channel_idx = 0;
 
-- 
1.7.9.4

