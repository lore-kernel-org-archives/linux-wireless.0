Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4918 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758053AbXJLVI3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2007 17:08:29 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: ignore junk at end of frame when parsing IEs
Date: Fri, 12 Oct 2007 16:44:22 -0400
Message-Id: <11922218622135-git-send-email-linville@tuxdriver.com> (sfid-20071012_220843_801334_77C7EDCF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some APs send management frames with junk padding after the last IE.
We already account for a similar problem with some Apple Airport
devices, but at least one device is known to send more than a single
extra byte.  The device in question is the Draytek Vigor2900:

	http://www.draytek.com.au/products/Vigor2900.php

The junk in question looks like an IE that runs off the end of the
frame.  This cause us to return ParseFailed.  Since the frame in
question is an association response, this causes us to fail to associate
with this AP.

The proposed "fix" is to ignore an IE length that overruns the end of
the frame if the IE type is unknown.  This won't help if the junk type
value matches a known IE type, but at least it won't fail association
otherwise.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
Thoughts?  I'd love a cleaner solution.

For reference:

	https://bugzilla.redhat.com/show_bug.cgi?id=324191

 net/mac80211/ieee80211_sta.c |   31 +++++++++++++++++++------------
 1 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index e804173..3bbc06d 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -122,20 +122,12 @@ static enum ParseRes ieee802_11_parse_elems(u8 *start, size_t len,
 
 	while (left >= 2) {
 		u8 id, elen;
+		bool elem_unknown;
 
 		id = *pos++;
 		elen = *pos++;
 		left -= 2;
-
-		if (elen > left) {
-#if 0
-			if (net_ratelimit())
-				printk(KERN_DEBUG "IEEE 802.11 element parse "
-				       "failed (id=%d elen=%d left=%d)\n",
-				       id, elen, left);
-#endif
-			return ParseFailed;
-		}
+		elem_unknown = false;
 
 		switch (id) {
 		case WLAN_EID_SSID:
@@ -208,11 +200,26 @@ static enum ParseRes ieee802_11_parse_elems(u8 *start, size_t len,
 				      id, elen);
 #endif
 			unknown++;
+			elem_unknown = true;
 			break;
 		}
 
-		left -= elen;
-		pos += elen;
+		if (elen > left)
+			if (elem_unknown)
+				left = 0;
+			else {
+#if 0
+				if (net_ratelimit())
+					printk(KERN_DEBUG "IEEE 802.11 element parse "
+					       "failed (id=%d elen=%d left=%d)\n",
+					       id, elen, left);
+#endif
+				return ParseFailed;
+			}
+		else {
+			left -= elen;
+			pos += elen;
+		}
 	}
 
 	/* Do not trigger error if left == 1 as Apple Airport base stations
-- 
1.5.2.4

