Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:60501 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031349Ab2COAo5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 20:44:57 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH] mac80211: flush to get the tx status of nullfunc frame immediately
Date: Thu, 15 Mar 2012 06:15:26 +0530
Message-ID: <1331772326-22439-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120315_014501_452397_7D720218)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sometimes the probe frame (nullfunc) is stuck at the hw queue. so that
the mac80211 terminates the connection as it wont see the tx status.
Instead of waiting for long period for ack status, lets call flush
to get nullfunc status immediately. It also helps to send the nullfunc
till max tries reached.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 net/mac80211/mlme.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 355a5e7..d838570 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1575,6 +1575,8 @@ static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
 	ifmgd->probe_send_count++;
 	ifmgd->probe_timeout = jiffies + msecs_to_jiffies(probe_wait_ms);
 	run_again(ifmgd, ifmgd->probe_timeout);
+	if (sdata->local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
+		drv_flush(sdata->local, false);
 }
 
 static void ieee80211_mgd_probe_ap(struct ieee80211_sub_if_data *sdata,
-- 
1.7.9.4

