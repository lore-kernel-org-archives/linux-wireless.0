Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58841 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab3FDU2e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 16:28:34 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: make wiphy index start at 0 again
Date: Tue,  4 Jun 2013 22:28:27 +0200
Message-Id: <1370377707-23222-1-git-send-email-johannes@sipsolutions.net> (sfid-20130604_222837_513478_A7349E70)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The change to use atomic_inc_return() for assigning the wiphy
index made the first wiphy index 1 instead of 0. This is fine,
but we all habitually type "phy0" when we're testing, so make
it go back to 0 instead of 1 by subtracting 1 from the index.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 99d86dd..4224e75 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -301,6 +301,9 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
 		return NULL;
 	}
 
+	/* atomic_inc_return makes it start at 1, make it start at 0 */
+	rdev->wiphy_idx--;
+
 	/* give it a proper name */
 	dev_set_name(&rdev->wiphy.dev, PHY_NAME "%d", rdev->wiphy_idx);
 
-- 
1.8.0

