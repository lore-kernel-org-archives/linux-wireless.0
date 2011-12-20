Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm23.bullet.mail.ukl.yahoo.com ([217.146.177.232]:30977 "HELO
	nm23.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751414Ab1LTPY5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 10:24:57 -0500
From: Marek Lindner <lindner_marek@yahoo.de>
To: linux-wireless@vger.kernel.org
Cc: Marek Lindner <lindner_marek@yahoo.de>
Subject: [PATCH] mac80211: ibss should not purge clients it is not responsible for
Date: Tue, 20 Dec 2011 23:16:52 +0800
Message-Id: <1324394212-8754-1-git-send-email-lindner_marek@yahoo.de> (sfid-20111220_162501_132521_6EACFB45)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The IBSS merge code calls ieee80211_sta_expire() with a relatively
short expire timeout that purges other clients prematurely. The
expire function has to check that only the clients belonging to
the vif in question are purged.

Signed-off-by: Marek Lindner <lindner_marek@yahoo.de>
---
 net/mac80211/sta_info.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 2db01e9..5dfcee2 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -941,6 +941,9 @@ void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
 
 	mutex_lock(&local->sta_mtx);
 	list_for_each_entry_safe(sta, tmp, &local->sta_list, list)
+		if (sdata != sta->sdata)
+			continue;
+
 		if (time_after(jiffies, sta->last_rx + exp_time)) {
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 			printk(KERN_DEBUG "%s: expiring inactive STA %pM\n",
-- 
1.7.5.4

