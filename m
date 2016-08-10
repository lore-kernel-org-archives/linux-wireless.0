Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:17437 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbcHJSMQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2016 14:12:16 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 1/4] cfg80211: rdev-ops: remove callback check from rdev_set_coalesce()
Date: Wed, 10 Aug 2016 12:33:26 +0200
Message-Id: <1470825209-10054-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20160810_201230_489812_57E3C885)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wrapper rdev_set_coalesce() checks whether the driver provides
the set_coalesce callback and returns -ENOTSUPP if not. However, this
check is already performed in nl80211_set_coalesce() resulting in
-EOPNOTSUPP. This patch removes check from rdev wrapper function.

Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 net/wireless/rdev-ops.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 85ff30b..903b58a 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1063,11 +1063,10 @@ static inline int
 rdev_set_coalesce(struct cfg80211_registered_device *rdev,
 		  struct cfg80211_coalesce *coalesce)
 {
-	int ret = -ENOTSUPP;
+	int ret;
 
 	trace_rdev_set_coalesce(&rdev->wiphy, coalesce);
-	if (rdev->ops->set_coalesce)
-		ret = rdev->ops->set_coalesce(&rdev->wiphy, coalesce);
+	ret = rdev->ops->set_coalesce(&rdev->wiphy, coalesce);
 	trace_rdev_return_int(&rdev->wiphy, ret);
 	return ret;
 }
-- 
1.9.1

