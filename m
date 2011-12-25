Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:58608 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab1LYPJU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Dec 2011 10:09:20 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: <pstew@chromium.org>, <linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [RFC] mac80211: use rcu_read_lock before sta_info_get
Date: Sun, 25 Dec 2011 20:39:12 +0530
Message-ID: <1324825752-8186-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111225_160923_191019_71E010A2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 net/mac80211/mlme.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 57989a0..c8a1acc 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1385,7 +1385,9 @@ void ieee80211_beacon_connection_loss_work(struct work_struct *work)
 	struct sta_info *sta;
 
 	if (ifmgd->associated) {
+		rcu_read_lock();
 		sta = sta_info_get(sdata, ifmgd->bssid);
+		rcu_read_unlock();
 		if (sta)
 			sta->beacon_loss_count++;
 	}
-- 
1.7.0.4

