Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:48714 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbZDYUTD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Apr 2009 16:19:03 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Luis Rodriguez <mcgrof@gmail.com>
Subject: [PATCH compat] Fix ksize() breakage on older kernels
Date: Sat, 25 Apr 2009 22:16:19 +0200
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200904252216.19842.mb@bu3sch.de> (sfid-20090425_221921_710174_4713A3A7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following patch should fix the ksize() compilation error
for older kernels without exported ksize().

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Index: compat-wireless-2009-04-20/net/wireless/scan.c
===================================================================
--- compat-wireless-2009-04-20.orig/net/wireless/scan.c	2009-04-25 21:58:17.000000000 +0200
+++ compat-wireless-2009-04-20/net/wireless/scan.c	2009-04-25 22:00:01.000000000 +0200
@@ -377,7 +377,11 @@
 			size_t used = dev->wiphy.bss_priv_size + sizeof(*res);
 			size_t ielen = res->pub.len_information_elements;
 
+#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,28)
+			if (0) {
+#else
 			if (ksize(found) >= used + ielen) {
+#endif
 				memcpy(found->pub.information_elements,
 				       res->pub.information_elements, ielen);
 				found->pub.len_information_elements = ielen;
@@ -385,9 +389,8 @@
 				u8 *ies = found->pub.information_elements;
 
 				if (found->ies_allocated) {
-					if (ksize(ies) < ielen)
-						ies = krealloc(ies, ielen,
-							       GFP_ATOMIC);
+					ies = krealloc(ies, ielen,
+						       GFP_ATOMIC);
 				} else
 					ies = kmalloc(ielen, GFP_ATOMIC);
 


-- 
Greetings, Michael.
