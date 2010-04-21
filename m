Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60967 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab0DUIZl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Apr 2010 04:25:41 -0400
Subject: [PATCH] radiotap parser: fix endian annotation
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Apr 2010 10:25:36 +0200
Message-ID: <1271838336.3627.18.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When I updated this from the corresponding
userspace library, an annotation error crept
in -- this variable needs to be annotated as
little endian. No effect on code generation.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
It's a fix for a .34 patch but I don't care if it makes it in there
since it only fixes a sparse warning.

 include/net/cfg80211.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/include/net/cfg80211.h	2010-04-21 10:23:42.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2010-04-21 10:23:54.000000000 +0200
@@ -1643,7 +1643,7 @@ struct ieee80211_radiotap_iterator {
 	const struct ieee80211_radiotap_namespace *current_namespace;
 
 	unsigned char *_arg, *_next_ns_data;
-	uint32_t *_next_bitmap;
+	__le32 *_next_bitmap;
 
 	unsigned char *this_arg;
 	int this_arg_index;


