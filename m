Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:53094 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751549Ab2EJFrG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 01:47:06 -0400
From: Soumik DAS <soumik.das@stericsson.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Date: Thu, 10 May 2012 07:46:40 +0200
Subject: [PATCH] mac80211: Increment probe_send_count earlier
Message-ID: <2E48302EED53D048A7BA72B0A307FB511FB9009098@EXDCVYMBSTM005.EQ1STM.local> (sfid-20120510_074711_365138_BBE0A483)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

At times, null frame gets transmitted and acked before mac80211
gets to increment probe_send_count. This leads to a situation
where mac80211 waits for ack to null frame, but no ack comes
causing unnecessary disconnection.

Signed-off-by: Soumik Das <soumik.das@stericsson.com>
---
 net/mac80211/mlme.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index dbd4bd9..a1213e4 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1522,6 +1522,7 @@ static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
 	 * anymore. The timeout will be reset if the frame is ACKed by
 	 * the AP.
 	 */
+	ifmgd->probe_send_count++;
 	if (sdata->local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) {
 		ifmgd->nullfunc_failed = false;
 		ieee80211_send_nullfunc(sdata->local, sdata, 0);
@@ -1538,7 +1539,6 @@ static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
 					 0, (u32) -1, true, false);
 	}
 
-	ifmgd->probe_send_count++;
 	ifmgd->probe_timeout = jiffies + msecs_to_jiffies(probe_wait_ms);
 	run_again(ifmgd, ifmgd->probe_timeout);
 	if (sdata->local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
-- 
1.7.5.4
