Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:4847 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbYGCPCg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2008 11:02:36 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/1] mac80211: add support for iwconfig wlanX frag auto
Date: Thu,  3 Jul 2008 18:02:27 +0300
Message-Id: <1215097347-7186-1-git-send-email-tomas.winkler@intel.com> (sfid-20080703_170239_151303_B98DCB1F)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch adds support for iwconfig wlanX frag auto.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/wext.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
index 1babb97..736c32e 100644
--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -800,6 +800,8 @@ static int ieee80211_ioctl_siwfrag(struct net_device *dev,
 
 	if (frag->disabled)
 		local->fragmentation_threshold = IEEE80211_MAX_FRAG_THRESHOLD;
+	else if (!frag->fixed)
+		local->fragmentation_threshold = IEEE80211_MAX_FRAG_THRESHOLD;
 	else if (frag->value < 256 ||
 		 frag->value > IEEE80211_MAX_FRAG_THRESHOLD)
 		return -EINVAL;
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

