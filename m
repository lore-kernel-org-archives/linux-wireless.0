Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51899 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744AbZDPNBc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 09:01:32 -0400
Subject: [PATCH] cfg80211: do not replace BSS structs
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 16 Apr 2009 15:00:58 +0200
Message-Id: <1239886858.8338.1.camel@johannes.local> (sfid-20090416_150135_486341_B98822D7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead, allocate extra IE memory if necessary. Normally,
this isn't even necessary since there's enough space.

This is a better way of correcting the "held BSS can
disappear" issue, but also a lot more code. It is also
necessary for proper auth/assoc BSS handling in the
future.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
John, you could roll this into one commit with the bandaid I posted
before, and if you think it's appropriate both can go into .30. But the
bandaid is sufficient for .30.

 net/wireless/core.h |    2 +-
 net/wireless/scan.c |   42 +++++++++++++++++++++++++++++++++---------
 2 files changed, 34 insertions(+), 10 deletions(-)

--- wireless-testing.orig/net/wireless/core.h	2009-04-16 14:58:35.000000000 +0200
+++ wireless-testing/net/wireless/core.h	2009-04-16 14:58:37.000000000 +0200
@@ -86,7 +86,7 @@ struct cfg80211_internal_bss {
 	struct rb_node rbn;
 	unsigned long ts;
 	struct kref ref;
-	bool hold;
+	bool hold, ies_allocated;
 
 	/* must be last because of priv member */
 	struct cfg80211_bss pub;
--- wireless-testing.orig/net/wireless/scan.c	2009-04-16 14:58:35.000000000 +0200
+++ wireless-testing/net/wireless/scan.c	2009-04-16 14:58:37.000000000 +0200
@@ -58,6 +58,10 @@ static void bss_release(struct kref *ref
 	bss = container_of(ref, struct cfg80211_internal_bss, ref);
 	if (bss->pub.free_priv)
 		bss->pub.free_priv(&bss->pub);
+
+	if (bss->ies_allocated)
+		kfree(bss->pub.information_elements);
+
 	kfree(bss);
 }
 
@@ -360,21 +364,41 @@ cfg80211_bss_update(struct cfg80211_regi
 
 	found = rb_find_bss(dev, res);
 
-	if (found && overwrite) {
-		list_replace(&found->list, &res->list);
-		rb_replace_node(&found->rbn, &res->rbn,
-				&dev->bss_tree);
-		/* XXX: workaround */
-		res->hold = found->hold;
-		kref_put(&found->ref, bss_release);
-		found = res;
-	} else if (found) {
+	if (found) {
 		kref_get(&found->ref);
 		found->pub.beacon_interval = res->pub.beacon_interval;
 		found->pub.tsf = res->pub.tsf;
 		found->pub.signal = res->pub.signal;
 		found->pub.capability = res->pub.capability;
 		found->ts = res->ts;
+
+		/* overwrite IEs */
+		if (overwrite) {
+			size_t used = dev->wiphy.bss_priv_size + sizeof(*res);
+			size_t ielen = res->pub.len_information_elements;
+
+			if (ksize(found) >= used + ielen) {
+				memcpy(found->pub.information_elements,
+				       res->pub.information_elements, ielen);
+				found->pub.len_information_elements = ielen;
+			} else {
+				u8 *ies = found->pub.information_elements;
+
+				if (found->ies_allocated) {
+					if (ksize(ies) < ielen)
+						ies = krealloc(ies, ielen,
+							       GFP_ATOMIC);
+				} else
+					ies = kmalloc(ielen, GFP_ATOMIC);
+
+				if (ies) {
+					memcpy(ies, res->pub.information_elements, ielen);
+					found->ies_allocated = true;
+					found->pub.information_elements = ies;
+				}
+			}
+		}
+
 		kref_put(&res->ref, bss_release);
 	} else {
 		/* this "consumes" the reference */


