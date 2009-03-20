Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:32781 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756220AbZCTP5t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2009 11:57:49 -0400
Date: Fri, 20 Mar 2009 17:57:36 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] nl80211: Check that function pointer != NULL before using
	it
Message-ID: <20090320155736.GA28965@jm.kir.nu> (sfid-20090320_165804_582508_4C1266B7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

NL80211_CMD_GET_MESH_PARAMS and NL80211_CMD_SET_MESH_PARAMS handlers
did not verify whether a function pointer is NULL (not supported by
the driver) before trying to call the function. The former nl80211
command is available for unprivileged users, too, so this can
potentially allow normal users to kill networking (or worse..) if
mac80211 is built without CONFIG_MAC80211_MESH=y.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 net/wireless/nl80211.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

The bug was introduced by 93da9cc17c5ae8a751886fd4732db89ad5e9bdb9 and
the fix should be applied to 2.6.29, too. The patch seems to apply
with some fuzz into linux-2.6.git even though the locking rework in
wireless-testing is not there. The end result looks correct, but I
have only tested this with wireless-testing. If I checked correctly,
this commit was not included in 2.6.28.


--- uml.orig/net/wireless/nl80211.c	2009-03-20 17:37:56.000000000 +0200
+++ uml/net/wireless/nl80211.c	2009-03-20 17:38:58.000000000 +0200
@@ -2039,6 +2039,11 @@ static int nl80211_get_mesh_params(struc
 	if (err)
 		goto out_rtnl;
 
+	if (!drv->ops->get_mesh_params) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
 	/* Get the mesh params */
 	err = drv->ops->get_mesh_params(&drv->wiphy, dev, &cur_params);
 	if (err)
@@ -2151,6 +2156,11 @@ static int nl80211_set_mesh_params(struc
 	if (err)
 		goto out_rtnl;
 
+	if (!drv->ops->set_mesh_params) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
 	/* This makes sure that there aren't more than 32 mesh config
 	 * parameters (otherwise our bitfield scheme would not work.) */
 	BUILD_BUG_ON(NL80211_MESHCONF_ATTR_MAX > 32);
@@ -2193,6 +2203,7 @@ static int nl80211_set_mesh_params(struc
 	/* Apply changes */
 	err = drv->ops->set_mesh_params(&drv->wiphy, dev, &cfg, mask);
 
+ out:
 	/* cleanup */
 	cfg80211_put_dev(drv);
 	dev_put(dev);

-- 
Jouni Malinen                                            PGP id EFC895FA
