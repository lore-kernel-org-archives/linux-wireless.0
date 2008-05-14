Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756069AbYENX1V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2008 19:27:21 -0400
Message-Id: <200805142326.m4ENQMFS027111@imap1.linux-foundation.org> (sfid-20080515_012724_314975_1AE679BB)
Subject: [patch 11/12] wireless: use get/put_unaligned_* helpers
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, akpm@linux-foundation.org,
	harvey.harrison@gmail.com
From: akpm@linux-foundation.org
Date: Wed, 14 May 2008 16:26:22 -0700
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/mesh_hwmp.c |    2 +-
 net/wireless/radiotap.c  |   16 +++++++---------
 2 files changed, 8 insertions(+), 10 deletions(-)

diff -puN net/mac80211/mesh_hwmp.c~wireless-use-get-put_unaligned_-helpers net/mac80211/mesh_hwmp.c
--- a/net/mac80211/mesh_hwmp.c~wireless-use-get-put_unaligned_-helpers
+++ a/net/mac80211/mesh_hwmp.c
@@ -26,7 +26,7 @@ static inline u32 u32_field_get(u8 *preq
 {
 	if (ae)
 		offset += 6;
-	return le32_to_cpu(get_unaligned((__le32 *) (preq_elem + offset)));
+	return get_unaligned_le32(preq_elem + offset);
 }
 
 /* HWMP IE processing macros */
diff -puN net/wireless/radiotap.c~wireless-use-get-put_unaligned_-helpers net/wireless/radiotap.c
--- a/net/wireless/radiotap.c~wireless-use-get-put_unaligned_-helpers
+++ a/net/wireless/radiotap.c
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
_
