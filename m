Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58766 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089AbYIROiM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 10:38:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] iw: add kernel version checks for pending upstream kernel features
Date: Thu, 18 Sep 2008 10:35:33 -0400
Message-Id: <1221748533-11000-1-git-send-email-linville@tuxdriver.com> (sfid-20080918_163818_284690_A833D90B)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add checks for kernel version to enable features in the iw tool.  This
allows packagers to get pre-package the tool without requiring precise
timing to stage the tool into their distributions.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 info.c |    4 ++++
 reg.c  |    6 ++++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/info.c b/info.c
index 0dc05c1..4b7d191 100644
--- a/info.c
+++ b/info.c
@@ -1,4 +1,5 @@
 #include <errno.h>
+#include <linux/version.h>
 #include <linux/nl80211.h>
 #include <net/if.h>
 
@@ -105,12 +106,15 @@ static int print_phy_handler(struct nl_msg *msg, void *arg)
 		}
 	}
 
+/* This funcionality first appears "officially" in 2.6.28... */
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28)
 	if (!tb_msg[NL80211_ATTR_SUPPORTED_IFTYPES])
 		return NL_SKIP;
 
 	printf("\tSupported interface modes:\n");
 	nla_for_each_nested(nl_mode, tb_msg[NL80211_ATTR_SUPPORTED_IFTYPES], rem_mode)
 		printf("\t\t * %s\n", iftype_name(nl_mode->nla_type));
+#endif
 
 	return NL_SKIP;
 }
diff --git a/reg.c b/reg.c
index 2892117..ce039ae 100644
--- a/reg.c
+++ b/reg.c
@@ -1,3 +1,4 @@
+#include <linux/version.h>
 #include <linux/nl80211.h>
 #include <net/if.h>
 #include <errno.h>
@@ -11,6 +12,9 @@
 
 #include "iw.h"
 
+/* This funcionality first appears "officially" in 2.6.28... */
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28)
+
 int isalpha_upper(char letter)
 {
 	if (letter >= 65 && letter <= 90)
@@ -67,3 +71,5 @@ static int handle_reg_set(struct nl_cb *cb,
 }
 COMMAND(reg, set, "<ISO/IEC 3166-1 alpha2>",
 	NL80211_CMD_REQ_SET_REG, 0, CIB_NONE, handle_reg_set);
+
+#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28) */
-- 
1.5.4.3

