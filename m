Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:32346 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321AbYFXKiI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 06:38:08 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/4] mac80211: don't return -EINVAL upon iwconfig wlan0 rts auto
Date: Tue, 24 Jun 2008 13:37:58 +0300
Message-Id: <1214303881-31525-2-git-send-email-tomas.winkler@intel.com> (sfid-20080624_123813_056947_86EDC083)
In-Reply-To: <1214303881-31525-1-git-send-email-tomas.winkler@intel.com>
References: <1214303881-31525-1-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch avoids returning -EINVAL upon iwconfig wlan0 rts auto. If
rts->fixed is 0, then we should choose a default value instead of failing.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/wext.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
index 5af3862..53f8767 100644
--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -721,6 +721,9 @@ static int ieee80211_ioctl_siwrts(struct net_device *dev,
 
 	if (rts->disabled)
 		local->rts_threshold = IEEE80211_MAX_RTS_THRESHOLD;
+	else if (!rts->fixed)
+		/* if the rts value is not fixed, then take default */
+		local->rts_threshold = IEEE80211_MAX_RTS_THRESHOLD;
 	else if (rts->value < 0 || rts->value > IEEE80211_MAX_RTS_THRESHOLD)
 		return -EINVAL;
 	else
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

