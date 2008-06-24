Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:32346 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200AbYFXKiI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 06:38:08 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3/4] mac80211: add last beacon time in scan list
Date: Tue, 24 Jun 2008 13:38:00 +0300
Message-Id: <1214303881-31525-4-git-send-email-tomas.winkler@intel.com> (sfid-20080624_123815_768155_77850B66)
In-Reply-To: <1214303881-31525-3-git-send-email-tomas.winkler@intel.com>
References: <1214303881-31525-1-git-send-email-tomas.winkler@intel.com>
 <1214303881-31525-2-git-send-email-tomas.winkler@intel.com>
 <1214303881-31525-3-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch adds the interval between the scan results and the last time a
beacon was received in the result of the scan.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/mlme.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 55659a7..8bfdac7 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4255,6 +4255,13 @@ ieee80211_sta_scan_result(struct net_device *dev,
 			iwe.u.data.length = strlen(buf);
 			current_ev = iwe_stream_add_point(current_ev, end_buf,
 							  &iwe, buf);
+			memset(&iwe, 0, sizeof(iwe));
+			iwe.cmd = IWEVCUSTOM;
+			sprintf(buf, " Last beacon: %dms ago",
+				jiffies_to_msecs(jiffies - bss->last_update));
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

