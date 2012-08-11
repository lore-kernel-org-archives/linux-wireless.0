Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:40812 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755162Ab2HKAaY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 20:30:24 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org,
	lf_driver_backport@lists.linux-foundation.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 4/4] compat: move RHEL mask for qdisc_cb_private_validate
Date: Sat, 11 Aug 2012 02:30:07 +0200
Message-Id: <1344645007-26757-5-git-send-email-hauke@hauke-m.de> (sfid-20120811_023028_566565_87B266FB)
In-Reply-To: <1344645007-26757-1-git-send-email-hauke@hauke-m.de>
References: <1344645007-26757-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move the mask for qdisc_cb_private_validate directly in front of the
function to it is only included when this function is really used from
compat.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-3.3.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/compat-3.3.h b/include/linux/compat-3.3.h
index 956d4c0..61d33b0 100644
--- a/include/linux/compat-3.3.h
+++ b/include/linux/compat-3.3.h
@@ -10,15 +10,17 @@
 #include <linux/skbuff.h>
 #include <net/sch_generic.h>
 
-/* mask qdisc_cb_private_validate as RHEL6 backports this */
-#define qdisc_cb_private_validate(a,b) compat_qdisc_cb_private_validate(a,b)
 #if !((LINUX_VERSION_CODE >= KERNEL_VERSION(3,2,9) && LINUX_VERSION_CODE < KERNEL_VERSION(3,3,0)) || (LINUX_VERSION_CODE >= KERNEL_VERSION(3,0,23) && LINUX_VERSION_CODE < KERNEL_VERSION(3,1,0)))
 #if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,37))
+/* mask qdisc_cb_private_validate as RHEL6 backports this */
+#define qdisc_cb_private_validate(a,b) compat_qdisc_cb_private_validate(a,b)
 static inline void qdisc_cb_private_validate(const struct sk_buff *skb, int sz)
 {
 	BUILD_BUG_ON(sizeof(skb->cb) < sizeof(struct qdisc_skb_cb) + sz);
 }
 #else
+/* mask qdisc_cb_private_validate as RHEL6 backports this */
+#define qdisc_cb_private_validate(a,b) compat_qdisc_cb_private_validate(a,b)
 static inline void qdisc_cb_private_validate(const struct sk_buff *skb, int sz)
 {
 	/* XXX ? */
-- 
1.7.9.5

