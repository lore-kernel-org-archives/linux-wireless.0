Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:38363 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412AbZDZJaB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Apr 2009 05:30:01 -0400
From: Michael Buesch <mb@bu3sch.de>
To: linville@tuxdriver.com
Subject: [PATCH] cfg80211: Use the correct IE buffer pointer
Date: Sun, 26 Apr 2009 11:27:33 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200904261127.33386.mb@bu3sch.de> (sfid-20090426_113008_607302_B8D06AF5)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the IE buffer was allocated, the pub.information_elements pointer
was also changed to the allocated space. So we must not assume anymore
that the pointer points at the "found" tail.

So if it was allocated previously, take the codebranch that grows the
buffer size (if necessary) and put the data into the allocated buffer.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Acked-by: Johannes Berg <johannes@sipsolutions.net>

---

The original code will probably not overrun the buffer, because the buffer is always
guaranteed to be bigger than ksize(found)-used. But I think it's a bad idea anyway to poke with
a dangling pointer. ;)


 net/wireless/scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/net/wireless/scan.c
+++ wireless-testing/net/wireless/scan.c
@@ -377,7 +377,7 @@ cfg80211_bss_update(struct cfg80211_regi
 			size_t used = dev->wiphy.bss_priv_size + sizeof(*res);
 			size_t ielen = res->pub.len_information_elements;
 
-			if (ksize(found) >= used + ielen) {
+			if (!found->ies_allocated && ksize(found) >= used + ielen) {
 				memcpy(found->pub.information_elements,
 				       res->pub.information_elements, ielen);
 				found->pub.len_information_elements = ielen;


-- 
Greetings, Michael.
