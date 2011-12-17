Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25831 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352Ab1LQPIo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Dec 2011 10:08:44 -0500
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [RFC 1/2] mac80211: reset beacon monitor at tx ack notify
Date: Sat, 17 Dec 2011 20:35:27 +0530
Message-ID: <1324134328-27503-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20111217_160847_560561_CD9278BE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch moves the beacon loss timer to future on receiving tx
ack status from the associated AP. So that we can avoid unnecessary
AP probing.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 net/mac80211/mlme.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index a984f1f..65f1262 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1209,8 +1209,10 @@ void ieee80211_sta_tx_notify(struct ieee80211_sub_if_data *sdata,
 	if (!ieee80211_is_data(hdr->frame_control))
 	    return;
 
-	if (ack)
+	if (ack) {
 		ieee80211_sta_reset_conn_monitor(sdata);
+		ieee80211_sta_reset_beacon_monitor(sdata);
+	}
 
 	if (ieee80211_is_nullfunc(hdr->frame_control) &&
 	    sdata->u.mgd.probe_send_count > 0) {
-- 
1.7.8

