Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:58129 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756Ab1ENENd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 May 2011 00:13:33 -0400
Received: from mail.atheros.com ([10.234.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 21:13:03 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <johannes@sipsolutions.net>, <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH] mac80211: abort scan_work immediately when the device goes down
Date: Sat, 14 May 2011 09:43:28 +0530
Message-ID: <1305346408-3933-1-git-send-email-rmanoharan@atheros.com> (sfid-20110514_061337_534040_0445450F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As long as no delay is required b/w channel change, scan work
is proceeding without scheduling a new work. In such case, we
can not abort scan work when the card was unplugged. This patch
completes the scanning immediately whenever the device goes down.

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 net/mac80211/iface.c |    4 ++--
 net/mac80211/scan.c  |    5 +++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 4054399..9d18c43 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -384,11 +384,11 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	int i;
 	enum nl80211_channel_type orig_ct;
 
+	clear_bit(SDATA_STATE_RUNNING, &sdata->state);
+
 	if (local->scan_sdata == sdata)
 		ieee80211_scan_cancel(local);
 
-	clear_bit(SDATA_STATE_RUNNING, &sdata->state);
-
 	/*
 	 * Stop TX on this interface first.
 	 */
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index ea44a8e..102300c 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -719,6 +719,11 @@ void ieee80211_scan_work(struct work_struct *work)
 	 * without scheduling a new work
 	 */
 	do {
+		if (!ieee80211_sdata_running(sdata)) {
+			aborted = true;
+			goto out_complete;
+		}
+
 		switch (local->next_scan_state) {
 		case SCAN_DECISION:
 			/* if no more bands/channels left, complete scan */
-- 
1.7.5.1

