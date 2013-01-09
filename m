Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42958 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756210Ab3AIKUM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2013 05:20:12 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] regulatory: fix uevent
Date: Wed,  9 Jan 2013 11:20:34 +0100
Message-Id: <1357726834-14725-1-git-send-email-johannes@sipsolutions.net> (sfid-20130109_112016_564740_C683877F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The uevent callback doesn't protect its access to
last_request, which now causes a warning since
the conversion to get_last_request(). Fix this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 0b35de0..c647869 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2250,14 +2250,21 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 #ifdef CONFIG_HOTPLUG
 int reg_device_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
-	struct regulatory_request *lr = get_last_request();
+	struct regulatory_request *lr;
+	u8 alpha2[2];
+	bool add = false;
 
+	rcu_read_lock();
+	lr = get_last_request();
 	if (lr && !lr->processed) {
-		if (add_uevent_var(env, "COUNTRY=%c%c",
-				   lr->alpha2[0], lr->alpha2[1]))
-			return -ENOMEM;
+		memcpy(alpha2, lr->alpha2, 2);
+		add = true;
 	}
+	rcu_read_unlock();
 
+	if (add)
+		return add_uevent_var(env, "COUNTRY=%c%c",
+				      alpha2[0], alpha2[1]);
 	return 0;
 }
 #else
-- 
1.8.0

