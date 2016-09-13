Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36854 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751473AbcIMOpW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Sep 2016 10:45:22 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4/6] cfg80211: wext: only allow WEP keys to be configured before connected
Date: Tue, 13 Sep 2016 16:44:26 +0200
Message-Id: <1473777868-32429-4-git-send-email-johannes@sipsolutions.net> (sfid-20160913_164726_425162_AF328ACC)
In-Reply-To: <1473777868-32429-1-git-send-email-johannes@sipsolutions.net>
References: <1473777868-32429-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When not connected, anything but WEP keys shouldn't be allowed to be
configured for later - only static WEP keys make sense at this point.
Change wext to reject anything else just like nl80211 does.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/wext-compat.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 9f27221c8913..e45a76449b43 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -487,6 +487,9 @@ static int __cfg80211_set_encryption(struct cfg80211_registered_device *rdev,
 	err = 0;
 	if (wdev->current_bss)
 		err = rdev_add_key(rdev, dev, idx, pairwise, addr, params);
+	else if (params->cipher != WLAN_CIPHER_SUITE_WEP40 &&
+		 params->cipher != WLAN_CIPHER_SUITE_WEP104)
+		return -EINVAL;
 	if (err)
 		return err;
 
-- 
2.8.1
