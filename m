Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:52501 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab3FRA2L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jun 2013 20:28:11 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [RFC 1/2] mac80211:  Stop timer before deleting data structures.
Date: Mon, 17 Jun 2013 17:28:00 -0700
Message-Id: <1371515281-26879-1-git-send-email-greearb@candelatech.com> (sfid-20130618_022817_510140_40562029)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Not sure this matters, but it seems cleaner.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 net/mac80211/mlme.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 732eda0..ebfa416 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4379,11 +4379,11 @@ void ieee80211_mgd_stop(struct ieee80211_sub_if_data *sdata)
 	cancel_work_sync(&ifmgd->chswitch_work);
 
 	mutex_lock(&ifmgd->mtx);
+	del_timer_sync(&ifmgd->timer);
 	if (ifmgd->assoc_data)
 		ieee80211_destroy_assoc_data(sdata, false, true);
 	if (ifmgd->auth_data)
 		ieee80211_destroy_auth_data(sdata, false);
-	del_timer_sync(&ifmgd->timer);
 	mutex_unlock(&ifmgd->mtx);
 }
 
-- 
1.7.3.4

