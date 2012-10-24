Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47171 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935005Ab2JXPKz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 11:10:55 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: use non-atomic bitmap operation for local variable
Date: Wed, 24 Oct 2012 17:11:27 +0200
Message-Id: <1351091487-17115-1-git-send-email-johannes@sipsolutions.net> (sfid-20121024_171059_502573_93C73B2D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For a local variable there's no need to use the atomic
set_bit() operation, use __set_bit() instead.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 51a4a25..ea8a674 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -821,7 +821,7 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 		if (elem_parse_failed)
 			elems->parse_error = true;
 		else
-			set_bit(id, seen_elems);
+			__set_bit(id, seen_elems);
 
 		left -= elen;
 		pos += elen;
-- 
1.7.10.4

