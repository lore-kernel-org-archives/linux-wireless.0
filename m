Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59637 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbbB0Ocw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2015 09:32:52 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: j@w1.fi, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] nl80211: add notes about userspace API/ABI modifications
Date: Fri, 27 Feb 2015 15:32:43 +0100
Message-Id: <1425047563-9988-1-git-send-email-johannes@sipsolutions.net> (sfid-20150227_153256_111711_F4D3D94E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add notes about userspace ABI/API modifications, including the
fact that we decided that API submissions should come with a
driver implementation.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/uapi/linux/nl80211.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 2dcf9bba317c..74492e85b04f 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -25,6 +25,19 @@
  *
  */
 
+/*
+ * This header file defines the userspace API to the wireless stack. Please
+ * be careful not to break things - i.e. don't move anything around or so
+ * unless you can demonstrate that it breaks neither API nor ABI.
+ *
+ * Additions to the API should be accompanied by actual implementations in
+ * an upstream driver, so that example implementations exist in case there
+ * are ever concerns about the precise semantics of the API or changes are
+ * needed, and to ensure that code for dead (no longer implemented) API
+ * can actually be identified and removed.
+ * Nonetheless, semantics should also be documented carefully in this file.
+ */
+
 #include <linux/types.h>
 
 #define NL80211_GENL_NAME "nl80211"
-- 
2.1.4

