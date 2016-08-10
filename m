Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:7080 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099AbcHJSOo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2016 14:14:44 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 2/4] cfg80211: rdev-ops: remove callback check from rdev_set_mcast_rate()
Date: Wed, 10 Aug 2016 12:33:27 +0200
Message-Id: <1470825209-10054-2-git-send-email-arend.vanspriel@broadcom.com> (sfid-20160810_201458_148427_0B25FEBF)
In-Reply-To: <1470825209-10054-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1470825209-10054-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wrapper rdev_set_mcast_rate() checks whether the driver provides
the set_mcast_rate callback and returns -ENOTSUPP if not. However, this
check is already performed in nl80211_set_mcast_rate() resulting in
-EOPNOTSUPP. This patch removes check from rdev wrapper function.

Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 net/wireless/rdev-ops.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 903b58a..d002415 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1050,11 +1050,10 @@ rdev_set_mcast_rate(struct cfg80211_registered_device *rdev,
 		    struct net_device *dev,
 		    int mcast_rate[NUM_NL80211_BANDS])
 {
-	int ret = -ENOTSUPP;
+	int ret;
 
 	trace_rdev_set_mcast_rate(&rdev->wiphy, dev, mcast_rate);
-	if (rdev->ops->set_mcast_rate)
-		ret = rdev->ops->set_mcast_rate(&rdev->wiphy, dev, mcast_rate);
+	ret = rdev->ops->set_mcast_rate(&rdev->wiphy, dev, mcast_rate);
 	trace_rdev_return_int(&rdev->wiphy, ret);
 	return ret;
 }
-- 
1.9.1

