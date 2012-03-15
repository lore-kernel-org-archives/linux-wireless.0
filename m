Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63502 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab2COAUG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 20:20:06 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH] mac80211: do not send pspoll when powersave is disabled
Date: Thu, 15 Mar 2012 05:50:36 +0530
Message-ID: <1331770836-20312-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120315_012011_825372_A97186FC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There might be latency at AP side to update TIM IE which could cause the
station to send pspoll frame even after the wakeup. If the powersave is
disabled, the nullfunc notification alone is sufficient to receive
frames from the AP. And if the pspoll frame was already sent, no need to
resend the frame till it was acked by AP.

Cc: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 net/mac80211/mlme.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 39c1393..355a5e7 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2472,7 +2472,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 				ieee80211_hw_config(local,
 						    IEEE80211_CONF_CHANGE_PS);
 				ieee80211_send_nullfunc(local, sdata, 0);
-			} else {
+			} else if (!local->pspolling && sdata->u.mgd.powersave) {
 				local->pspolling = true;
 
 				/*
-- 
1.7.9.4

