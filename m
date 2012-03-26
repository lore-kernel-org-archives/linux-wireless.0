Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57913 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303Ab2CZPWn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2012 11:22:43 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 2/2] mac80211: fix oper channel timestamp updation
Date: Mon, 26 Mar 2012 20:53:13 +0530
Message-ID: <1332775393-16820-2-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120326_172246_905523_34ED21E3)
In-Reply-To: <1332775393-16820-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1332775393-16820-1-git-send-email-rmanohar@qca.qualcomm.com>
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

