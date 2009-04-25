Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:51140 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232AbZDYUb3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Apr 2009 16:31:29 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] cfg80211: Remove unnecessary ksize() call
Date: Sat, 25 Apr 2009 22:28:55 +0200
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200904252228.55381.mb@bu3sch.de> (sfid-20090425_223151_379012_A6B9A323)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This removes an unnecessary ksize() call. krealloc() will do this
test internally and won't perform any allocation if the space is
already sufficient to hold the data.
So remove the redundant check.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---
 net/wireless/scan.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- wireless-testing.orig/net/wireless/scan.c
+++ wireless-testing/net/wireless/scan.c
@@ -384,11 +384,9 @@ cfg80211_bss_update(struct cfg80211_regi
 			} else {
 				u8 *ies = found->pub.information_elements;
 
-				if (found->ies_allocated) {
-					if (ksize(ies) < ielen)
-						ies = krealloc(ies, ielen,
-							       GFP_ATOMIC);
-				} else
+				if (found->ies_allocated)
+					ies = krealloc(ies, ielen, GFP_ATOMIC);
+				else
 					ies = kmalloc(ielen, GFP_ATOMIC);
 
 				if (ies) {

-- 
Greetings, Michael.
