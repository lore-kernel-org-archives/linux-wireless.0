Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:16641 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab0DGGAs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Apr 2010 02:00:48 -0400
From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Subject: [PATCH v2] mac80211: check whether scan is in progress before queueing scan_work
Date: Wed,  7 Apr 2010 08:56:07 +0300
Message-Id: <1270619767-2459-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As scan_work is queued from work_work it needs to be checked if scan
has been started during execution of work_work. Otherwise, when hw
scan is used, the stack gets error about hw being busy with ongoing
scan. This causes the stack to abort scan without notifying the driver
about it. This leads to a situation where the hw is scanning and the stack
thinks it's not. Then when the scan finishes, the stack will complain by
warnings.

Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
---
 net/mac80211/work.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index 1e1ea30..5df48a9 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -919,12 +919,17 @@ static void ieee80211_work_work(struct work_struct *work)
 		run_again(local, jiffies + HZ/2);
 	}
 
-	if (list_empty(&local->work_list) && local->scan_req)
+	mutex_unlock(&local->work_mtx);
+
+	mutex_lock(&local->scan_mtx);
+
+	if (list_empty(&local->work_list) && local->scan_req &&
+	    !local->scanning)
 		ieee80211_queue_delayed_work(&local->hw,
 					     &local->scan_work,
 					     round_jiffies_relative(0));
 
-	mutex_unlock(&local->work_mtx);
+	mutex_unlock(&local->scan_mtx);
 
 	ieee80211_recalc_idle(local);
 
-- 
1.5.6.3

