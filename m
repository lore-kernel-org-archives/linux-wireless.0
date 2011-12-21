Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42023 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab1LUOvW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 09:51:22 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [RFC] mac80211: fix scan state machine
Date: Wed, 21 Dec 2011 20:21:12 +0530
Message-ID: <1324479072-8242-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111221_155140_015687_1D303438)
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

