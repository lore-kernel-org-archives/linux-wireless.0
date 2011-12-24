Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17252 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab1LXNNk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Dec 2011 08:13:40 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: Helmut Schaa <helmut.schaa@googlemail.com>,
	<leela@qca.qualcomm.com>, <linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH v2] mac80211: fix scan state machine
Date: Sat, 24 Dec 2011 18:43:28 +0530
Message-ID: <1324732408-9662-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111224_141356_162049_C6EB4010)
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

Cc: Leela Kella <leela@qca.qualcomm.com>
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

