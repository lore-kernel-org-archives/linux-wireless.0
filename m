Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18989 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab1LVPZ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Dec 2011 10:25:26 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: Helmut Schaa <helmut.schaa@googlemail.com>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH] mac80211: fix scan state machine
Date: Thu, 22 Dec 2011 20:52:30 +0530
Message-ID: <1324567350-8397-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111222_162529_980031_35888CA7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

when we run high bandwidth UDP traffic and we trigger a scan, the scan
state machine seems to be looping in SUSPEND->RESUME->DECISION->SUSPEND
and SET_CHANNEL seems to be never called as 'tx_empty' is never true
while running UDP traffic. fix this by settting SET_CHANNEL state when
we get into RESUME state.

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 net/mac80211/scan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 2c5041c..2908e56 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -625,7 +625,7 @@ static void ieee80211_scan_state_resume(struct ieee80211_local *local,
 	local->leave_oper_channel_time = jiffies;
 
 	/* advance to the next channel to be scanned */
-	local->next_scan_state = SCAN_DECISION;
+	local->next_scan_state = SCAN_SET_CHANNEL;
 }
 
 void ieee80211_scan_work(struct work_struct *work)
-- 
1.7.0.4

