Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:61201 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757505Ab0DIKMi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Apr 2010 06:12:38 -0400
From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Paasikivi Teemu.3 (EXT-Ixonos/Tampere)"
	<ext-teemu.3.paasikivi@nokia.com>
Subject: [PATCH] mac80211: check whether scan is in progress before queueing scan_work
Date: Fri,  9 Apr 2010 13:07:55 +0300
Message-Id: <1270807675-8597-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Paasikivi Teemu.3 (EXT-Ixonos/Tampere) <ext-teemu.3.paasikivi@nokia.com>

As scan_work is queued from work_work it needs to be checked if scan
has been started during execution of work_work. Otherwise, when hw
scan is used, the stack gets error about hw being busy with ongoing
scan. This causes the stack to abort scan without notifying the driver
about it. This leads to a situation where the hw is scanning and the stack
thinks it's not. Then when the scan finishes, the stack will complain by
warnings.

Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/work.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index 1e1ea30..7bd8670 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -919,11 +919,16 @@ static void ieee80211_work_work(struct work_struct *work)
 		run_again(local, jiffies + HZ/2);
 	}
 
-	if (list_empty(&local->work_list) && local->scan_req)
+	mutex_lock(&local->scan_mtx);
+
+	if (list_empty(&local->work_list) && local->scan_req &&
+	    !local->scanning)
 		ieee80211_queue_delayed_work(&local->hw,
 					     &local->scan_work,
 					     round_jiffies_relative(0));
 
+	mutex_unlock(&local->scan_mtx);
+
 	mutex_unlock(&local->work_mtx);
 
 	ieee80211_recalc_idle(local);
-- 
1.5.6.3

