Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57430 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab0JNLky (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 07:40:54 -0400
Subject: [PATCH] radiotap: fix vendor namespace parsing
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Oct 2010 13:41:35 +0200
Message-ID: <1287056495.4641.300.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's a bug with radiotap vendor namespace
parsing if you don't register for the given
namespace extensions. Fix this by passing
only the unknown vendor namespaces and the
registered data to frontends, but not both.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Nothing uses it, so it's not an important fix.

 net/wireless/radiotap.c |   58 ++++++++++++++++++++++++++----------------------
 1 file changed, 32 insertions(+), 26 deletions(-)

--- wireless-testing.orig/net/wireless/radiotap.c	2010-09-15 13:40:22.000000000 +0200
+++ wireless-testing/net/wireless/radiotap.c	2010-10-14 13:10:06.000000000 +0200
@@ -201,7 +201,7 @@ int ieee80211_radiotap_iterator_next(
 {
 	while (1) {
 		int hit = 0;
-		int pad, align, size, subns, vnslen;
+		int pad, align, size, subns;
 		uint32_t oui;
 
 		/* if no more EXT bits, that's it */
@@ -261,6 +261,27 @@ int ieee80211_radiotap_iterator_next(
 		if (pad)
 			iterator->_arg += align - pad;
 
+		if (iterator->_arg_index % 32 == IEEE80211_RADIOTAP_VENDOR_NAMESPACE) {
+			int vnslen;
+
+			if ((unsigned long)iterator->_arg + size -
+			    (unsigned long)iterator->_rtheader >
+			    (unsigned long)iterator->_max_length)
+				return -EINVAL;
+
+			oui = (*iterator->_arg << 16) |
+				(*(iterator->_arg + 1) << 8) |
+				*(iterator->_arg + 2);
+			subns = *(iterator->_arg + 3);
+
+			find_ns(iterator, oui, subns);
+
+			vnslen = get_unaligned_le16(iterator->_arg + 4);
+			iterator->_next_ns_data = iterator->_arg + size + vnslen;
+			if (!iterator->current_namespace)
+				size += vnslen;
+		}
+
 		/*
 		 * this is what we will return to user, but we need to
 		 * move on first so next call has something fresh to test
@@ -287,40 +308,25 @@ int ieee80211_radiotap_iterator_next(
 		/* these special ones are valid in each bitmap word */
 		switch (iterator->_arg_index % 32) {
 		case IEEE80211_RADIOTAP_VENDOR_NAMESPACE:
-			iterator->_bitmap_shifter >>= 1;
-			iterator->_arg_index++;
-
 			iterator->_reset_on_ext = 1;
 
-			vnslen = get_unaligned_le16(iterator->this_arg + 4);
-			iterator->_next_ns_data = iterator->_arg + vnslen;
-			oui = (*iterator->this_arg << 16) |
-				(*(iterator->this_arg + 1) << 8) |
-				*(iterator->this_arg + 2);
-			subns = *(iterator->this_arg + 3);
-
-			find_ns(iterator, oui, subns);
-
 			iterator->is_radiotap_ns = 0;
-			/* allow parsers to show this information */
+			/*
+			 * If parser didn't register this vendor
+			 * namespace with us, allow it to show it
+			 * as 'raw. Do do that, set argument index
+			 * to vendor namespace.
+			 */
 			iterator->this_arg_index =
 				IEEE80211_RADIOTAP_VENDOR_NAMESPACE;
-			iterator->this_arg_size += vnslen;
-			if ((unsigned long)iterator->this_arg +
-			    iterator->this_arg_size -
-			    (unsigned long)iterator->_rtheader >
-			    (unsigned long)(unsigned long)iterator->_max_length)
-				return -EINVAL;
-			hit = 1;
-			break;
+			if (!iterator->current_namespace)
+				hit = 1;
+			goto next_entry;
 		case IEEE80211_RADIOTAP_RADIOTAP_NAMESPACE:
-			iterator->_bitmap_shifter >>= 1;
-			iterator->_arg_index++;
-
 			iterator->_reset_on_ext = 1;
 			iterator->current_namespace = &radiotap_ns;
 			iterator->is_radiotap_ns = 1;
-			break;
+			goto next_entry;
 		case IEEE80211_RADIOTAP_EXT:
 			/*
 			 * bit 31 was set, there is more


