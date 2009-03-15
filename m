Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:10788 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357AbZCOGrT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2009 02:47:19 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 14 Mar 2009 23:47:18 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18876.41851.397740.847705@gargle.gargle.HOWL> (sfid-20090315_074736_394747_814D7102)
Date: Sun, 15 Mar 2009 12:13:07 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>,
	<me@bobcopeland.com>
Subject: [PATCH] mac80211: Tear down aggregation sessions for suspend/resume
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the driver has been notified with a STA_REMOVE, it tears down
the internal ADDBA state. On resume, trying to initiate aggregation would
fail because mac80211 has not cleared the operational state for that <TID,STA>.
This can be fixed by tearing down the existing sessions on a suspend.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 net/mac80211/pm.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index f845601..ab9c989 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -21,6 +21,13 @@ int __ieee80211_suspend(struct ieee80211_hw *hw)
 	list_for_each_entry(sdata, &local->interfaces, list)
 		ieee80211_disable_keys(sdata);
 
+	/* Tear down aggregation sessions */
+	if (hw->flags & IEEE80211_HW_AMPDU_AGGREGATION) {
+		list_for_each_entry(sta, &local->sta_list, list) {
+			ieee80211_sta_tear_down_BA_sessions(sta);
+		}
+	}
+
 	/* remove STAs */
 	if (local->ops->sta_notify) {
 		spin_lock_irqsave(&local->sta_lock, flags);
-- 
1.6.2

