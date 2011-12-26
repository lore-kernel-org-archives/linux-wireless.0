Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54689 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab1LZG7r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Dec 2011 01:59:47 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Paul Stewart <pstew@google.com>,
	Christian Lamparter <chunkeey@googlemail.com>
Subject: [PATCH] mac80211: use RCU read locks for sta_info_get
Date: Mon, 26 Dec 2011 12:29:38 +0530
Message-ID: <1324882778-3079-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111226_075951_809337_16E46358)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Cc: Paul Stewart <pstew@google.com>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 net/mac80211/mlme.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 57989a0..ecb4c84 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1385,9 +1385,11 @@ void ieee80211_beacon_connection_loss_work(struct work_struct *work)
 	struct sta_info *sta;
 
 	if (ifmgd->associated) {
+		rcu_read_lock();
 		sta = sta_info_get(sdata, ifmgd->bssid);
 		if (sta)
 			sta->beacon_loss_count++;
+		rcu_read_unlock();
 	}
 
 	if (sdata->local->hw.flags & IEEE80211_HW_CONNECTION_MONITOR)
-- 
1.7.0.4

