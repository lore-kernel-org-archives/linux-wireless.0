Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:32934 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937AbYEBFTS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 May 2008 01:19:18 -0400
Received: by wa-out-1112.google.com with SMTP id j37so86541waf.23
        for <linux-wireless@vger.kernel.org>; Thu, 01 May 2008 22:19:17 -0700 (PDT)
Subject: [PATCH 5/6] wireless: use get/put_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 01 May 2008 22:19:33 -0700
Message-Id: <1209705574.22362.41.camel@brick> (sfid-20080502_071912_620346_614B9E4E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/mesh_hwmp.c |    2 +-
 net/wireless/radiotap.c  |   16 +++++++---------
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 3df8092..2368973 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -26,7 +26,7 @@ static inline u32 u32_field_get(u8 *preq_elem, int offset, bool ae)
 {
 	if (ae)
 		offset += 6;
-	return le32_to_cpu(get_unaligned((__le32 *) (preq_elem + offset)));
+	return get_unaligned_le32(preq_elem + offset);
 }
 
 /* HWMP IE processing macros */
diff --git a/net/wireless/radiotap.c b/net/wireless/radiotap.c
index 28fbd0b..f591871 100644
--- a/net/wireless/radiotap.c
+++ b/net/wireless/radiotap.c
@@ -59,23 +59,21 @@ int ieee80211_radiotap_iterator_init(
 		return -EINVAL;
 
 	/* sanity check for allowed length and radiotap length field */
-	if (max_length < le16_to_cpu(get_unaligned(&radiotap_header->it_len)))
+	if (max_length < get_unaligned_le16(&radiotap_header->it_len))
 		return -EINVAL;
 
 	iterator->rtheader = radiotap_header;
-	iterator->max_length = le16_to_cpu(get_unaligned(
-						&radiotap_header->it_len));
+	iterator->max_length = get_unaligned_le16(&radiotap_header->it_len);
 	iterator->arg_index = 0;
-	iterator->bitmap_shifter = le32_to_cpu(get_unaligned(
-						&radiotap_header->it_present));
+	iterator->bitmap_shifter = get_unaligned_le32(&radiotap_header->it_present);
 	iterator->arg = (u8 *)radiotap_header + sizeof(*radiotap_header);
 	iterator->this_arg = NULL;
 
 	/* find payload start allowing for extended bitmap(s) */
 
 	if (unlikely(iterator->bitmap_shifter & (1<<IEEE80211_RADIOTAP_EXT))) {
-		while (le32_to_cpu(get_unaligned((__le32 *)iterator->arg)) &
-				   (1<<IEEE80211_RADIOTAP_EXT)) {
+		while (get_unaligned_le32(iterator->arg) &
+		       (1 << IEEE80211_RADIOTAP_EXT)) {
 			iterator->arg += sizeof(u32);
 
 			/*
@@ -241,8 +239,8 @@ int ieee80211_radiotap_iterator_next(
 			if (iterator->bitmap_shifter & 1) {
 				/* b31 was set, there is more */
 				/* move to next u32 bitmap */
-				iterator->bitmap_shifter = le32_to_cpu(
-					get_unaligned(iterator->next_bitmap));
+				iterator->bitmap_shifter =
+				    get_unaligned_le32(iterator->next_bitmap);
 				iterator->next_bitmap++;
 			} else
 				/* no more bitmaps: end */
-- 
1.5.5.1.350.gbbbf


