Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58938 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbcHHGuP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2016 02:50:15 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ben Hutchings <ben@decadent.org.uk>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] Revert "wext: Fix 32 bit iwpriv compatibility issue with 64 bit Kernel"
Date: Mon,  8 Aug 2016 08:50:12 +0200
Message-Id: <1470639012-7658-1-git-send-email-johannes@sipsolutions.net> (sfid-20160808_085018_690947_EAEBEB9A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This reverts commit 3d5fdff46c4b2b9534fa2f9fc78e90a48e0ff724.

Ben Hutchings pointed out that the commit isn't safe since it assumes
that the structure used by the driver is iw_point, when in fact there's
no way to know about that.

Fortunately, the only driver in the tree that ever runs this code path
is the wilc1000 staging driver, so it doesn't really matter.

Clearly I should have investigated this better before applying, sorry.

Reported-by: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org [though I guess it doesn't matter much]
Fixes: 3d5fdff46c4b ("wext: Fix 32 bit iwpriv compatibility issue with 64 bit Kernel")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/wext-core.c | 25 ++-----------------------
 1 file changed, 2 insertions(+), 23 deletions(-)

diff --git a/net/wireless/wext-core.c b/net/wireless/wext-core.c
index dbb2738e356a..6250b1cfcde5 100644
--- a/net/wireless/wext-core.c
+++ b/net/wireless/wext-core.c
@@ -958,29 +958,8 @@ static int wireless_process_ioctl(struct net *net, struct ifreq *ifr,
 			return private(dev, iwr, cmd, info, handler);
 	}
 	/* Old driver API : call driver ioctl handler */
-	if (dev->netdev_ops->ndo_do_ioctl) {
-#ifdef CONFIG_COMPAT
-		if (info->flags & IW_REQUEST_FLAG_COMPAT) {
-			int ret = 0;
-			struct iwreq iwr_lcl;
-			struct compat_iw_point *iwp_compat = (void *) &iwr->u.data;
-
-			memcpy(&iwr_lcl, iwr, sizeof(struct iwreq));
-			iwr_lcl.u.data.pointer = compat_ptr(iwp_compat->pointer);
-			iwr_lcl.u.data.length = iwp_compat->length;
-			iwr_lcl.u.data.flags = iwp_compat->flags;
-
-			ret = dev->netdev_ops->ndo_do_ioctl(dev, (void *) &iwr_lcl, cmd);
-
-			iwp_compat->pointer = ptr_to_compat(iwr_lcl.u.data.pointer);
-			iwp_compat->length = iwr_lcl.u.data.length;
-			iwp_compat->flags = iwr_lcl.u.data.flags;
-
-			return ret;
-		} else
-#endif
-			return dev->netdev_ops->ndo_do_ioctl(dev, ifr, cmd);
-	}
+	if (dev->netdev_ops->ndo_do_ioctl)
+		return dev->netdev_ops->ndo_do_ioctl(dev, ifr, cmd);
 	return -EOPNOTSUPP;
 }
 
-- 
2.8.1

