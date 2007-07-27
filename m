Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:44073 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763439AbXG0J3L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2007 05:29:11 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Mohamed Abbas <mabbas@linux.intel.com>
Subject: [PATCH 15/17] iwlwifi: fix scaing watchdog time out
Date: Fri, 27 Jul 2007 17:26:39 +0800
Message-Id: <11855284281570-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11855284263627-git-send-email-yi.zhu@intel.com>
References: <11855284012123-git-send-email-yi.zhu@intel.com>
 <11855284032407-git-send-email-yi.zhu@intel.com>
 <11855284053896-git-send-email-yi.zhu@intel.com>
 <11855284072074-git-send-email-yi.zhu@intel.com>
 <1185528408776-git-send-email-yi.zhu@intel.com>
 <11855284103871-git-send-email-yi.zhu@intel.com>
 <11855284122218-git-send-email-yi.zhu@intel.com>
 <11855284142478-git-send-email-yi.zhu@intel.com>
 <11855284161716-git-send-email-yi.zhu@intel.com>
 <11855284183313-git-send-email-yi.zhu@intel.com>
 <11855284201330-git-send-email-yi.zhu@intel.com>
 <11855284212390-git-send-email-yi.zhu@intel.com>
 <1185528423816-git-send-email-yi.zhu@intel.com>
 <11855284253382-git-send-email-yi.zhu@intel.com>
 <11855284263627-git-send-email-yi.zhu@intel.com>
To: ipwpatch@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix the scan watchdog time out when we associated to non-exist
network. Basically if we issue:

    $ iwconfig wlan0 ap xx:xx:xx:xx:xx:xx

and the mac address is a non-exist AP then we scan. We get scan
watchdog timeout and restart.

Signed-off-by: Mohamed Abbas <mabbas@linux.intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-base.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index c28a56a..8558ea8 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -7018,26 +7018,26 @@ static void iwl_bg_request_scan(struct work_struct *data)
 
 		scan->suspend_time = 0;
 		scan->max_out_time = 600 * 1024;
-		if (interval) {
+		if (!interval)
+			interval = suspend_time;
 #if IWL == 3945
-			/*
-			 * suspend time format:
-			 *  0-19: beacon interval in usec (time before exec.)
-			 * 20-23: 0
-			 * 24-31: number of beacons (suspend between channels)
-			 */
+		/*
+		 * suspend time format:
+		 *  0-19: beacon interval in usec (time before exec.)
+		 * 20-23: 0
+		 * 24-31: number of beacons (suspend between channels)
+		 */
 
-			extra = (suspend_time / interval) << 24;
-			scan->suspend_time = 0xFF0FFFFF &
-			    (extra | ((suspend_time % interval) * 1024));
+		extra = (suspend_time / interval) << 24;
+		scan->suspend_time = 0xFF0FFFFF &
+		    (extra | ((suspend_time % interval) * 1024));
 #else
-			extra = (suspend_time / interval) << 22;
-			scan->suspend_time = (extra |
-			    ((suspend_time % interval) * 1024));
-			IWL_DEBUG_SCAN("suspend_time 0x%X beacon interval %d\n",
-				       scan->suspend_time, interval);
+		extra = (suspend_time / interval) << 22;
+		scan->suspend_time = (extra |
+		    ((suspend_time % interval) * 1024));
+		IWL_DEBUG_SCAN("suspend_time 0x%X beacon interval %d\n",
+			       scan->suspend_time, interval);
 #endif
-		}
 	}
 
 	/* We should add the ability for user to lock to PASSIVE ONLY */
-- 
1.5.2
