Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4972 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475AbYFCS23 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2008 14:28:29 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] wireless.h: improve userland include-ability
Date: Tue,  3 Jun 2008 13:51:37 -0400
Message-Id: <1212515497-21578-1-git-send-email-linville@tuxdriver.com> (sfid-20080603_202832_385331_F7C61BC0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kirill A. Shutemov <kirill@shutemov.name>

This patch partially reverts commit 2218228392080f0ca2fc2974604e79f57b12c436
("Make linux/wireless.h be able to compile") while still making it
easier to include wireless.h in userland apps.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 include/linux/wireless.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/wireless.h b/include/linux/wireless.h
index 0a9b5b4..9c0b89c 100644
--- a/include/linux/wireless.h
+++ b/include/linux/wireless.h
@@ -70,8 +70,14 @@
 /***************************** INCLUDES *****************************/
 
 #include <linux/types.h>		/* for __u* and __s* typedefs */
+
+/* This header is used in user-space, therefore need to be sanitised
+ * for that purpose. Those includes are usually not compatible with glibc.
+ * To know which includes to use in user-space, check iwlib.h. */
+#ifdef __KERNEL__
 #include <linux/socket.h>		/* for "struct sockaddr" et al	*/
 #include <linux/if.h>			/* for IFNAMSIZ and co... */
+#endif	/* __KERNEL__ */
 
 /***************************** VERSION *****************************/
 /*
-- 
1.5.5.1

