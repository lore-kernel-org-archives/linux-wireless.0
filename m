Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:42794 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933109Ab3BLSMn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 13:12:43 -0500
From: Luciano Coelho <coelho@ti.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <j@w1.fi>
Subject: [PATCH] cfg80211: check vendor IE length to avoid overrun
Date: Tue, 12 Feb 2013 20:11:38 +0200
Message-ID: <1360692698-24208-1-git-send-email-coelho@ti.com> (sfid-20130212_191253_085734_86828FE2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cfg80211_find_vendor_ie() was checking only that the vendor IE would
fit in the remaining IEs buffer.  If a corrupt includes a vendor IE
that is too small, we could potentially overrun the IEs buffer.

Fix this by checking that the vendor IE fits in the reported IE length
field and skip it otherwise.

Reported-by: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 net/wireless/scan.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 45f1618..4582801 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -277,14 +277,18 @@ const u8 *cfg80211_find_vendor_ie(unsigned int oui, u8 oui_type,
 		if (!pos)
 			return NULL;
 
-		if (end - pos < sizeof(*ie))
-			return NULL;
-
 		ie = (struct ieee80211_vendor_ie *)pos;
+
+		/* make sure we can access ie->len */
+		BUILD_BUG_ON(offsetof(struct ieee80211_vendor_ie, len) >= 2);
+
+		if (ie->len < sizeof(*ie))
+			goto cont;
+
 		ie_oui = ie->oui[0] << 16 | ie->oui[1] << 8 | ie->oui[2];
 		if (ie_oui == oui && ie->oui_type == oui_type)
 			return pos;
-
+cont:
 		pos += 2 + ie->len;
 	}
 	return NULL;
-- 
1.7.10.4

