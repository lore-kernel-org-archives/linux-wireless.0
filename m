Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:46853 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754335AbYFYMRP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 08:17:15 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3/4 V2] mac80211: add last beacon time in scan list
Date: Wed, 25 Jun 2008 15:17:09 +0300
Message-Id: <1214396229-18782-1-git-send-email-tomas.winkler@intel.com> (sfid-20080625_141723_204702_2C42C3E5)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch adds the interval between the scan results and the last time a
beacon was received in the result of the scan.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/mlme.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7b930d1..e76e62a 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4658,12 +4658,26 @@ ieee80211_sta_scan_result(struct net_device *dev,
 		char *buf;
 		buf = kmalloc(30, GFP_ATOMIC);
 		if (buf) {
+			unsigned long mid_range = (-1) / 2 + 1;
+			unsigned long time_diff;
+
 			memset(&iwe, 0, sizeof(iwe));
 			iwe.cmd = IWEVCUSTOM;
 			sprintf(buf, "tsf=%016llx", (unsigned long long)(bss->timestamp));
 			iwe.u.data.length = strlen(buf);
 			current_ev = iwe_stream_add_point(current_ev, end_buf,
 							  &iwe, buf);
+			memset(&iwe, 0, sizeof(iwe));
+
+			iwe.cmd = IWEVCUSTOM;
+			time_diff = jiffies - bss->last_update > mid_range ?
+				jiffies - bss->last_update :
+				bss->last_update - jiffies;
+			sprintf(buf, "Last beacon:%dms ago",
+				jiffies_to_msecs(time_diff));
+			iwe.u.data.length = strlen(buf);
+			current_ev = iwe_stream_add_point(current_ev, end_buf,
+							  &iwe, buf);
 			kfree(buf);
 		}
 	}
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

