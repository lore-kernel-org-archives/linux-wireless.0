Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19333 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544Ab1L0N0U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Dec 2011 08:26:20 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Christian Lamparter <chunkeey@googlemail.com>
CC: <linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Paul Stewart <pstew@google.com>
Subject: [PATCH v2] mac80211: use RCU read locks for sta_info_get
Date: Tue, 27 Dec 2011 18:54:07 +0530
Message-ID: <1324992247-11404-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111227_142624_158331_CB3762B0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

this is being recently introduced by the commit
a85e1d55974646a442d95911e3f7d7a891ea9ac5

Cc: Paul Stewart <pstew@google.com>
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

