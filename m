Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57334 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303Ab2CZPXL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2012 11:23:11 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 2/2] mac80211: fix oper channel timestamp updation
Date: Mon, 26 Mar 2012 20:53:38 +0530
Message-ID: <1332775418-16865-2-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120326_172315_011307_9E684AFB)
In-Reply-To: <1332775418-16865-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1332775418-16865-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

At the start of scan, mac80211 stop all vif transmission and inform the
AP that the station is leaving the operating channel. But it is not
updating the leave_oper_channel timestamp. As the result, the scan
decision always set operating channel at the scan start when the listen
interval is reduced.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
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

