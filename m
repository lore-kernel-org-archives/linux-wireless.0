Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46321 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbXJ1NsO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Oct 2007 09:48:14 -0400
Subject: [PATCH] mac80211: don't allow registering the same rate control
	twice
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 28 Oct 2007 14:49:33 +0100
Message-Id: <1193579374.5197.5.camel@johannes.berg> (sfid-20071028_134817_915049_0AD6AD97)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previously, mac80211 would allow registering the same rate control
algorithm twice. This is a programming error in the registration
and should not happen; additionally the second version could never
be selected. Disallow this and warn about it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
There could be potential for data corruption here when one
algorithm is registered twice depending on how the algorithm
code is written (it might only expect to be registered once),
so I think this should be applied for 2.6.24.

 net/mac80211/ieee80211_rate.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- linux-2.6.orig/net/mac80211/ieee80211_rate.c	2007-10-28 14:43:47.835043456 +0100
+++ linux-2.6/net/mac80211/ieee80211_rate.c	2007-10-28 14:46:20.907430120 +0100
@@ -28,13 +28,22 @@ int ieee80211_rate_control_register(stru
 	if (!ops->name)
 		return -EINVAL;
 
+	mutex_lock(&rate_ctrl_mutex);
+	list_for_each_entry(alg, &rate_ctrl_algs, list) {
+		if (!strcmp(alg->ops->name, ops->name)) {
+			/* don't register an algorithm twice */
+			WARN_ON(1);
+			return -EALREADY;
+		}
+	}
+
 	alg = kzalloc(sizeof(*alg), GFP_KERNEL);
 	if (alg == NULL) {
+		mutex_unlock(&rate_ctrl_mutex);
 		return -ENOMEM;
 	}
 	alg->ops = ops;
 
-	mutex_lock(&rate_ctrl_mutex);
 	list_add_tail(&alg->list, &rate_ctrl_algs);
 	mutex_unlock(&rate_ctrl_mutex);
 


