Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:52792 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbZDYUkW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Apr 2009 16:40:22 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH RFC] cfg80211: Add ies_allocated check before copying ies
Date: Sat, 25 Apr 2009 22:36:34 +0200
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200904252236.34802.mb@bu3sch.de> (sfid-20090425_224027_954886_CB21AE0A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I don't fully understand the code, but let's imagine the following situation:

- cfg80211_bss_update was called and the ie was stored to allocated space.
- The information_elements pointer is changed to the allocated space.
- cfg80211_bss_update is called again, but now the ie fits into the
  space after the "found" structure.
- But the information_elements pointer still points to the allocated space.
  So it may overrun the buffer and crash.

Is this scenario possible?
If yes, please consider the following patch.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---
 net/wireless/scan.c |    5 +++++
 1 file changed, 5 insertions(+)

--- wireless-testing.orig/net/wireless/scan.c
+++ wireless-testing/net/wireless/scan.c
@@ -378,6 +378,11 @@ cfg80211_bss_update(struct cfg80211_regi
 			size_t ielen = res->pub.len_information_elements;
 
 			if (ksize(found) >= used + ielen) {
+				if (found->ies_allocated) {
+					kfree(found->pub.information_elements);
+					found->ies_allocated = false;
+					found->pub.information_elements = (u8 *)found + used;
+				}
 				memcpy(found->pub.information_elements,
 				       res->pub.information_elements, ielen);
 				found->pub.len_information_elements = ielen;

-- 
Greetings, Michael.
