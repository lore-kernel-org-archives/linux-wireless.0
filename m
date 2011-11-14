Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54539 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752247Ab1KNQ6k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 11:58:40 -0500
Subject: [PATCH 2/2] compat: add skb_complete_wifi_ack & feature flag
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1321287289.10264.16.camel@jlt3.sipsolutions.net> (sfid-20111114_175713_926907_64425DAA)
References: <1321287289.10264.16.camel@jlt3.sipsolutions.net>
	 (sfid-20111114_175713_926907_64425DAA)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Nov 2011 17:58:07 +0100
Message-ID: <1321289887.10264.17.camel@jlt3.sipsolutions.net> (sfid-20111114_175843_757432_E109AFD4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This just needs to be empty -- older kernels don't
have the necessary infrastructure for this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---

diff --git a/include/linux/compat-2.6.h b/include/linux/compat-2.6.h
index d933602..c23e94a 100644
--- a/include/linux/compat-2.6.h
+++ b/include/linux/compat-2.6.h
@@ -35,5 +35,6 @@
 #include <linux/compat-3.0.h>
 #include <linux/compat-3.1.h>
 #include <linux/compat-3.2.h>
+#include <linux/compat-3.3.h>
 
 #endif /* LINUX_26_COMPAT_H */
diff --git a/include/linux/compat-3.3.h b/include/linux/compat-3.3.h
new file mode 100644
index 0000000..2e1e6d3
--- /dev/null
+++ b/include/linux/compat-3.3.h
@@ -0,0 +1,20 @@
+#ifndef LINUX_3_3_COMPAT_H
+#define LINUX_3_3_COMPAT_H
+
+#include <linux/version.h>
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(3,3,0))
+
+/* include to override NL80211_FEATURE_SK_TX_STATUS */
+#include <linux/nl80211.h>
+
+
+static inline void skb_complete_wifi_ack(struct sk_buff *skb, bool acked)
+{
+	WARN_ON(1);
+}
+#define NL80211_FEATURE_SK_TX_STATUS 0
+
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,3,0)) */
+
+#endif /* LINUX_3_3_COMPAT_H */


