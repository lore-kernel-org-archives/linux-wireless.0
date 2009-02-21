Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56062 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbZBUFEm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Feb 2009 00:04:42 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v6 04/15] nl80211: disallow user requests prior to regulatory_init()
Date: Sat, 21 Feb 2009 00:04:22 -0500
Message-Id: <1235192673-6314-5-git-send-email-lrodriguez@atheros.com> (sfid-20090221_060446_736076_AA26D6AC)
In-Reply-To: <1235192673-6314-1-git-send-email-lrodriguez@atheros.com>
References: <1235192673-6314-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If cfg80211 is built into the kernel there is perhaps a small
time window betwen nl80211_init() and regulatory_init() where
cfg80211_regdomain hasn't yet been initialized to let the
wireless core do its work. During that rare case and time
frame (if its even possible) we don't allow user regulatory
changes as cfg80211 is working on enabling its first regulatory
domain.

To check for cfg80211_regdomain we now contend the entire operation
using the cfg80211_mutex.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/nl80211.c |   34 ++++++++++++++++++++++++++--------
 1 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8d38609..c99f0be 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1882,24 +1882,42 @@ static int nl80211_req_set_reg(struct sk_buff *skb, struct genl_info *info)
 	int r;
 	char *data = NULL;
 
-	if (!info->attrs[NL80211_ATTR_REG_ALPHA2])
-		return -EINVAL;
+	/*
+	 * You should only get this when cfg80211 hasn't yet initialized
+	 * completely when built-in to the kernel right between the time
+	 * window between nl80211_init() and regulatory_init(), if that is
+	 * even possible.
+	 */
+	mutex_lock(&cfg80211_mutex);
+	if (unlikely(!cfg80211_regdomain)) {
+		r = -EINPROGRESS;
+		goto out;
+	}
+
+	if (!info->attrs[NL80211_ATTR_REG_ALPHA2]) {
+		r = -EINVAL;
+		goto out;
+	}
 
 	data = nla_data(info->attrs[NL80211_ATTR_REG_ALPHA2]);
 
 #ifdef CONFIG_WIRELESS_OLD_REGULATORY
 	/* We ignore world regdom requests with the old regdom setup */
-	if (is_world_regdom(data))
-		return -EINVAL;
+	if (is_world_regdom(data)) {
+		r = -EINVAL;
+		goto out;
+	}
 #endif
-	mutex_lock(&cfg80211_mutex);
 	r = __regulatory_hint(NULL, REGDOM_SET_BY_USER, data, 0, ENVIRON_ANY);
-	mutex_unlock(&cfg80211_mutex);
-	/* This means the regulatory domain was already set, however
+	/*
+	 * This means the regulatory domain was already set, however
 	 * we don't want to confuse userspace with a "successful error"
-	 * message so lets just treat it as a success */
+	 * message so lets just treat it as a success
+	 */
 	if (r == -EALREADY)
 		r = 0;
+out:
+	mutex_unlock(&cfg80211_mutex);
 	return r;
 }
 
-- 
1.6.0.3

