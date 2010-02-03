Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60625 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756617Ab0BCJYf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2010 04:24:35 -0500
Subject: [PATCH] wireless: update radiotap parser
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Feb 2010 10:24:30 +0100
Message-ID: <1265189070.29119.87.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Upstream radiotap has adopted the namespace
proposal David Young made and I then took care
of, for which I had adapted the radiotap parser
as a library outside the kernel. This brings
the in-kernel parser up to speed.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h           |   83 ++++++++--
 include/net/ieee80211_radiotap.h |    4 
 net/mac80211/tx.c                |    9 -
 net/wireless/radiotap.c          |  305 +++++++++++++++++++++++++--------------
 4 files changed, 271 insertions(+), 130 deletions(-)

--- wireless-testing.orig/include/net/cfg80211.h	2010-01-26 11:05:19.000000000 +0100
+++ wireless-testing/include/net/cfg80211.h	2010-01-26 11:06:10.000000000 +0100
@@ -1572,37 +1572,82 @@ ieee80211_get_response_rate(struct ieee8
  * Documentation in Documentation/networking/radiotap-headers.txt
  */
 
+struct radiotap_align_size {
+	uint8_t align:4, size:4;
+};
+
+struct ieee80211_radiotap_namespace {
+	const struct radiotap_align_size *align_size;
+	int n_bits;
+	uint32_t oui;
+	uint8_t subns;
+};
+
+struct ieee80211_radiotap_vendor_namespaces {
+	const struct ieee80211_radiotap_namespace *ns;
+	int n_ns;
+};
+
 /**
  * struct ieee80211_radiotap_iterator - tracks walk thru present radiotap args
- * @rtheader: pointer to the radiotap header we are walking through
- * @max_length: length of radiotap header in cpu byte ordering
- * @this_arg_index: IEEE80211_RADIOTAP_... index of current arg
- * @this_arg: pointer to current radiotap arg
- * @arg_index: internal next argument index
- * @arg: internal next argument pointer
- * @next_bitmap: internal pointer to next present u32
- * @bitmap_shifter: internal shifter for curr u32 bitmap, b0 set == arg present
+ * @this_arg_index: index of current arg, valid after each successful call
+ *	to ieee80211_radiotap_iterator_next()
+ * @this_arg: pointer to current radiotap arg; it is valid after each
+ *	call to ieee80211_radiotap_iterator_next() but also after
+ *	ieee80211_radiotap_iterator_init() where it will point to
+ *	the beginning of the actual data portion
+ * @this_arg_size: length of the current arg, for convenience
+ * @current_namespace: pointer to the current namespace definition
+ *	(or internally %NULL if the current namespace is unknown)
+ * @is_radiotap_ns: indicates whether the current namespace is the default
+ *	radiotap namespace or not
+ *
+ * @overrides: override standard radiotap fields
+ * @n_overrides: number of overrides
+ *
+ * @_rtheader: pointer to the radiotap header we are walking through
+ * @_max_length: length of radiotap header in cpu byte ordering
+ * @_arg_index: next argument index
+ * @_arg: next argument pointer
+ * @_next_bitmap: internal pointer to next present u32
+ * @_bitmap_shifter: internal shifter for curr u32 bitmap, b0 set == arg present
+ * @_vns: vendor namespace definitions
+ * @_next_ns_data: beginning of the next namespace's data
+ * @_reset_on_ext: internal; reset the arg index to 0 when going to the
+ *	next bitmap word
+ *
+ * Describes the radiotap parser state. Fields prefixed with an underscore
+ * must not be used by users of the parser, only by the parser internally.
  */
 
 struct ieee80211_radiotap_iterator {
-	struct ieee80211_radiotap_header *rtheader;
-	int max_length;
+	struct ieee80211_radiotap_header *_rtheader;
+	const struct ieee80211_radiotap_vendor_namespaces *_vns;
+	const struct ieee80211_radiotap_namespace *current_namespace;
+
+	unsigned char *_arg, *_next_ns_data;
+	uint32_t *_next_bitmap;
+
+	unsigned char *this_arg;
 	int this_arg_index;
-	u8 *this_arg;
+	int this_arg_size;
 
-	int arg_index;
-	u8 *arg;
-	__le32 *next_bitmap;
-	u32 bitmap_shifter;
+	int is_radiotap_ns;
+
+	int _max_length;
+	int _arg_index;
+	uint32_t _bitmap_shifter;
+	int _reset_on_ext;
 };
 
 extern int ieee80211_radiotap_iterator_init(
-   struct ieee80211_radiotap_iterator *iterator,
-   struct ieee80211_radiotap_header *radiotap_header,
-   int max_length);
+	struct ieee80211_radiotap_iterator *iterator,
+	struct ieee80211_radiotap_header *radiotap_header,
+	int max_length, const struct ieee80211_radiotap_vendor_namespaces *vns);
 
 extern int ieee80211_radiotap_iterator_next(
-   struct ieee80211_radiotap_iterator *iterator);
+	struct ieee80211_radiotap_iterator *iterator);
+
 
 extern const unsigned char rfc1042_header[6];
 extern const unsigned char bridge_tunnel_header[6];
--- wireless-testing.orig/include/net/ieee80211_radiotap.h	2010-01-26 11:07:16.000000000 +0100
+++ wireless-testing/include/net/ieee80211_radiotap.h	2010-01-26 11:09:17.000000000 +0100
@@ -198,6 +198,10 @@ enum ieee80211_radiotap_type {
 	IEEE80211_RADIOTAP_TX_FLAGS = 15,
 	IEEE80211_RADIOTAP_RTS_RETRIES = 16,
 	IEEE80211_RADIOTAP_DATA_RETRIES = 17,
+
+	/* valid in every it_present bitmap, even vendor namespaces */
+	IEEE80211_RADIOTAP_RADIOTAP_NAMESPACE = 29,
+	IEEE80211_RADIOTAP_VENDOR_NAMESPACE = 30,
 	IEEE80211_RADIOTAP_EXT = 31
 };
 
--- wireless-testing.orig/net/wireless/radiotap.c	2010-01-26 11:01:48.000000000 +0100
+++ wireless-testing/net/wireless/radiotap.c	2010-01-26 11:04:15.000000000 +0100
@@ -2,6 +2,16 @@
  * Radiotap parser
  *
  * Copyright 2007		Andy Green <andy@warmcat.com>
+ * Copyright 2009		Johannes Berg <johannes@sipsolutions.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Alternatively, this software may be distributed under the terms of BSD
+ * license.
+ *
+ * See COPYING for more details.
  */
 
 #include <net/cfg80211.h>
@@ -10,6 +20,35 @@
 
 /* function prototypes and related defs are in include/net/cfg80211.h */
 
+static const struct radiotap_align_size rtap_namespace_sizes[] = {
+	[IEEE80211_RADIOTAP_TSFT] = { .align = 8, .size = 8, },
+	[IEEE80211_RADIOTAP_FLAGS] = { .align = 1, .size = 1, },
+	[IEEE80211_RADIOTAP_RATE] = { .align = 1, .size = 1, },
+	[IEEE80211_RADIOTAP_CHANNEL] = { .align = 2, .size = 4, },
+	[IEEE80211_RADIOTAP_FHSS] = { .align = 2, .size = 2, },
+	[IEEE80211_RADIOTAP_DBM_ANTSIGNAL] = { .align = 1, .size = 1, },
+	[IEEE80211_RADIOTAP_DBM_ANTNOISE] = { .align = 1, .size = 1, },
+	[IEEE80211_RADIOTAP_LOCK_QUALITY] = { .align = 2, .size = 2, },
+	[IEEE80211_RADIOTAP_TX_ATTENUATION] = { .align = 2, .size = 2, },
+	[IEEE80211_RADIOTAP_DB_TX_ATTENUATION] = { .align = 2, .size = 2, },
+	[IEEE80211_RADIOTAP_DBM_TX_POWER] = { .align = 1, .size = 1, },
+	[IEEE80211_RADIOTAP_ANTENNA] = { .align = 1, .size = 1, },
+	[IEEE80211_RADIOTAP_DB_ANTSIGNAL] = { .align = 1, .size = 1, },
+	[IEEE80211_RADIOTAP_DB_ANTNOISE] = { .align = 1, .size = 1, },
+	[IEEE80211_RADIOTAP_RX_FLAGS] = { .align = 2, .size = 2, },
+	[IEEE80211_RADIOTAP_TX_FLAGS] = { .align = 2, .size = 2, },
+	[IEEE80211_RADIOTAP_RTS_RETRIES] = { .align = 1, .size = 1, },
+	[IEEE80211_RADIOTAP_DATA_RETRIES] = { .align = 1, .size = 1, },
+	/*
+	 * add more here as they are defined in radiotap.h
+	 */
+};
+
+static const struct ieee80211_radiotap_namespace radiotap_ns = {
+	.n_bits = sizeof(rtap_namespace_sizes) / sizeof(rtap_namespace_sizes[0]),
+	.align_size = rtap_namespace_sizes,
+};
+
 /**
  * ieee80211_radiotap_iterator_init - radiotap parser iterator initialization
  * @iterator: radiotap_iterator to initialize
@@ -50,9 +89,9 @@
  */
 
 int ieee80211_radiotap_iterator_init(
-    struct ieee80211_radiotap_iterator *iterator,
-    struct ieee80211_radiotap_header *radiotap_header,
-    int max_length)
+	struct ieee80211_radiotap_iterator *iterator,
+	struct ieee80211_radiotap_header *radiotap_header,
+	int max_length, const struct ieee80211_radiotap_vendor_namespaces *vns)
 {
 	/* Linux only supports version 0 radiotap format */
 	if (radiotap_header->it_version)
@@ -62,19 +101,24 @@ int ieee80211_radiotap_iterator_init(
 	if (max_length < get_unaligned_le16(&radiotap_header->it_len))
 		return -EINVAL;
 
-	iterator->rtheader = radiotap_header;
-	iterator->max_length = get_unaligned_le16(&radiotap_header->it_len);
-	iterator->arg_index = 0;
-	iterator->bitmap_shifter = get_unaligned_le32(&radiotap_header->it_present);
-	iterator->arg = (u8 *)radiotap_header + sizeof(*radiotap_header);
-	iterator->this_arg = NULL;
+	iterator->_rtheader = radiotap_header;
+	iterator->_max_length = get_unaligned_le16(&radiotap_header->it_len);
+	iterator->_arg_index = 0;
+	iterator->_bitmap_shifter = get_unaligned_le32(&radiotap_header->it_present);
+	iterator->_arg = (uint8_t *)radiotap_header + sizeof(*radiotap_header);
+	iterator->_reset_on_ext = 0;
+	iterator->_next_bitmap = &radiotap_header->it_present;
+	iterator->_next_bitmap++;
+	iterator->_vns = vns;
+	iterator->current_namespace = &radiotap_ns;
+	iterator->is_radiotap_ns = 1;
 
 	/* find payload start allowing for extended bitmap(s) */
 
-	if (unlikely(iterator->bitmap_shifter & (1<<IEEE80211_RADIOTAP_EXT))) {
-		while (get_unaligned_le32(iterator->arg) &
-		       (1 << IEEE80211_RADIOTAP_EXT)) {
-			iterator->arg += sizeof(u32);
+	if (iterator->_bitmap_shifter & (1<<IEEE80211_RADIOTAP_EXT)) {
+		while (get_unaligned_le32(iterator->_arg) &
+					(1 << IEEE80211_RADIOTAP_EXT)) {
+			iterator->_arg += sizeof(uint32_t);
 
 			/*
 			 * check for insanity where the present bitmaps
@@ -82,12 +126,13 @@ int ieee80211_radiotap_iterator_init(
 			 * stated radiotap header length
 			 */
 
-			if (((ulong)iterator->arg -
-			     (ulong)iterator->rtheader) > iterator->max_length)
+			if ((unsigned long)iterator->_arg -
+			    (unsigned long)iterator->_rtheader >
+			    (unsigned long)iterator->_max_length)
 				return -EINVAL;
 		}
 
-		iterator->arg += sizeof(u32);
+		iterator->_arg += sizeof(uint32_t);
 
 		/*
 		 * no need to check again for blowing past stated radiotap
@@ -96,12 +141,36 @@ int ieee80211_radiotap_iterator_init(
 		 */
 	}
 
+	iterator->this_arg = iterator->_arg;
+
 	/* we are all initialized happily */
 
 	return 0;
 }
 EXPORT_SYMBOL(ieee80211_radiotap_iterator_init);
 
+static void find_ns(struct ieee80211_radiotap_iterator *iterator,
+		    uint32_t oui, uint8_t subns)
+{
+	int i;
+
+	iterator->current_namespace = NULL;
+
+	if (!iterator->_vns)
+		return;
+
+	for (i = 0; i < iterator->_vns->n_ns; i++) {
+		if (iterator->_vns->ns[i].oui != oui)
+			continue;
+		if (iterator->_vns->ns[i].subns != subns)
+			continue;
+
+		iterator->current_namespace = &iterator->_vns->ns[i];
+		break;
+	}
+}
+
+
 
 /**
  * ieee80211_radiotap_iterator_next - return next radiotap parser iterator arg
@@ -127,99 +196,80 @@ EXPORT_SYMBOL(ieee80211_radiotap_iterato
  */
 
 int ieee80211_radiotap_iterator_next(
-    struct ieee80211_radiotap_iterator *iterator)
+	struct ieee80211_radiotap_iterator *iterator)
 {
-
-	/*
-	 * small length lookup table for all radiotap types we heard of
-	 * starting from b0 in the bitmap, so we can walk the payload
-	 * area of the radiotap header
-	 *
-	 * There is a requirement to pad args, so that args
-	 * of a given length must begin at a boundary of that length
-	 * -- but note that compound args are allowed (eg, 2 x u16
-	 * for IEEE80211_RADIOTAP_CHANNEL) so total arg length is not
-	 * a reliable indicator of alignment requirement.
-	 *
-	 * upper nybble: content alignment for arg
-	 * lower nybble: content length for arg
-	 */
-
-	static const u8 rt_sizes[] = {
-		[IEEE80211_RADIOTAP_TSFT] = 0x88,
-		[IEEE80211_RADIOTAP_FLAGS] = 0x11,
-		[IEEE80211_RADIOTAP_RATE] = 0x11,
-		[IEEE80211_RADIOTAP_CHANNEL] = 0x24,
-		[IEEE80211_RADIOTAP_FHSS] = 0x22,
-		[IEEE80211_RADIOTAP_DBM_ANTSIGNAL] = 0x11,
-		[IEEE80211_RADIOTAP_DBM_ANTNOISE] = 0x11,
-		[IEEE80211_RADIOTAP_LOCK_QUALITY] = 0x22,
-		[IEEE80211_RADIOTAP_TX_ATTENUATION] = 0x22,
-		[IEEE80211_RADIOTAP_DB_TX_ATTENUATION] = 0x22,
-		[IEEE80211_RADIOTAP_DBM_TX_POWER] = 0x11,
-		[IEEE80211_RADIOTAP_ANTENNA] = 0x11,
-		[IEEE80211_RADIOTAP_DB_ANTSIGNAL] = 0x11,
-		[IEEE80211_RADIOTAP_DB_ANTNOISE] = 0x11,
-		[IEEE80211_RADIOTAP_RX_FLAGS] = 0x22,
-		[IEEE80211_RADIOTAP_TX_FLAGS] = 0x22,
-		[IEEE80211_RADIOTAP_RTS_RETRIES] = 0x11,
-		[IEEE80211_RADIOTAP_DATA_RETRIES] = 0x11,
-		/*
-		 * add more here as they are defined in
-		 * include/net/ieee80211_radiotap.h
-		 */
-	};
-
-	/*
-	 * for every radiotap entry we can at
-	 * least skip (by knowing the length)...
-	 */
-
-	while (iterator->arg_index < sizeof(rt_sizes)) {
+	while (1) {
 		int hit = 0;
-		int pad;
+		int pad, align, size, subns, vnslen;
+		uint32_t oui;
 
-		if (!(iterator->bitmap_shifter & 1))
+		/* if no more EXT bits, that's it */
+		if ((iterator->_arg_index % 32) == IEEE80211_RADIOTAP_EXT &&
+		    !(iterator->_bitmap_shifter & 1))
+			return -ENOENT;
+
+		if (!(iterator->_bitmap_shifter & 1))
 			goto next_entry; /* arg not present */
 
+		/* get alignment/size of data */
+		switch (iterator->_arg_index % 32) {
+		case IEEE80211_RADIOTAP_RADIOTAP_NAMESPACE:
+		case IEEE80211_RADIOTAP_EXT:
+			align = 1;
+			size = 0;
+			break;
+		case IEEE80211_RADIOTAP_VENDOR_NAMESPACE:
+			align = 2;
+			size = 6;
+			break;
+		default:
+			if (!iterator->current_namespace ||
+			    iterator->_arg_index >= iterator->current_namespace->n_bits) {
+				if (iterator->current_namespace == &radiotap_ns)
+					return -ENOENT;
+				align = 0;
+			} else {
+				align = iterator->current_namespace->align_size[iterator->_arg_index].align;
+				size = iterator->current_namespace->align_size[iterator->_arg_index].size;
+			}
+			if (!align) {
+				/* skip all subsequent data */
+				iterator->_arg = iterator->_next_ns_data;
+				/* give up on this namespace */
+				iterator->current_namespace = NULL;
+				goto next_entry;
+			}
+			break;
+		}
+
 		/*
 		 * arg is present, account for alignment padding
-		 *  8-bit args can be at any alignment
-		 * 16-bit args must start on 16-bit boundary
-		 * 32-bit args must start on 32-bit boundary
-		 * 64-bit args must start on 64-bit boundary
 		 *
-		 * note that total arg size can differ from alignment of
-		 * elements inside arg, so we use upper nybble of length
-		 * table to base alignment on
-		 *
-		 * also note: these alignments are ** relative to the
-		 * start of the radiotap header **.  There is no guarantee
+		 * Note that these alignments are relative to the start
+		 * of the radiotap header.  There is no guarantee
 		 * that the radiotap header itself is aligned on any
 		 * kind of boundary.
 		 *
-		 * the above is why get_unaligned() is used to dereference
-		 * multibyte elements from the radiotap area
+		 * The above is why get_unaligned() is used to dereference
+		 * multibyte elements from the radiotap area.
 		 */
 
-		pad = (((ulong)iterator->arg) -
-			((ulong)iterator->rtheader)) &
-			((rt_sizes[iterator->arg_index] >> 4) - 1);
+		pad = ((unsigned long)iterator->_arg -
+		       (unsigned long)iterator->_rtheader) & (align - 1);
 
 		if (pad)
-			iterator->arg +=
-				(rt_sizes[iterator->arg_index] >> 4) - pad;
+			iterator->_arg += align - pad;
 
 		/*
 		 * this is what we will return to user, but we need to
 		 * move on first so next call has something fresh to test
 		 */
-		iterator->this_arg_index = iterator->arg_index;
-		iterator->this_arg = iterator->arg;
-		hit = 1;
+		iterator->this_arg_index = iterator->_arg_index;
+		iterator->this_arg = iterator->_arg;
+		iterator->this_arg_size = size;
 
 		/* internally move on the size of this arg */
-		iterator->arg += rt_sizes[iterator->arg_index] & 0x0f;
+		iterator->_arg += size;
 
 		/*
 		 * check for insanity where we are given a bitmap that
@@ -228,32 +278,73 @@ int ieee80211_radiotap_iterator_next(
 		 * max_length on the last arg, never exceeding it.
 		 */
 
-		if (((ulong)iterator->arg - (ulong)iterator->rtheader) >
-		    iterator->max_length)
+		if ((unsigned long)iterator->_arg -
+		    (unsigned long)iterator->_rtheader >
+		    (unsigned long)iterator->_max_length)
 			return -EINVAL;
 
-	next_entry:
-		iterator->arg_index++;
-		if (unlikely((iterator->arg_index & 31) == 0)) {
-			/* completed current u32 bitmap */
-			if (iterator->bitmap_shifter & 1) {
-				/* b31 was set, there is more */
-				/* move to next u32 bitmap */
-				iterator->bitmap_shifter =
-				    get_unaligned_le32(iterator->next_bitmap);
-				iterator->next_bitmap++;
-			} else
-				/* no more bitmaps: end */
-				iterator->arg_index = sizeof(rt_sizes);
-		} else /* just try the next bit */
-			iterator->bitmap_shifter >>= 1;
+		/* these special ones are valid in each bitmap word */
+		switch (iterator->_arg_index % 32) {
+		case IEEE80211_RADIOTAP_VENDOR_NAMESPACE:
+			iterator->_bitmap_shifter >>= 1;
+			iterator->_arg_index++;
+
+			iterator->_reset_on_ext = 1;
+
+			vnslen = get_unaligned_le16(iterator->this_arg + 4);
+			iterator->_next_ns_data = iterator->_arg + vnslen;
+			oui = (*iterator->this_arg << 16) |
+				(*(iterator->this_arg + 1) << 8) |
+				*(iterator->this_arg + 2);
+			subns = *(iterator->this_arg + 3);
+
+			find_ns(iterator, oui, subns);
+
+			iterator->is_radiotap_ns = 0;
+			/* allow parsers to show this information */
+			iterator->this_arg_index =
+				IEEE80211_RADIOTAP_VENDOR_NAMESPACE;
+			iterator->this_arg_size += vnslen;
+			if ((unsigned long)iterator->this_arg +
+			    iterator->this_arg_size -
+			    (unsigned long)iterator->_rtheader >
+			    (unsigned long)(unsigned long)iterator->_max_length)
+				return -EINVAL;
+			hit = 1;
+			break;
+		case IEEE80211_RADIOTAP_RADIOTAP_NAMESPACE:
+			iterator->_bitmap_shifter >>= 1;
+			iterator->_arg_index++;
+
+			iterator->_reset_on_ext = 1;
+			iterator->current_namespace = &radiotap_ns;
+			iterator->is_radiotap_ns = 1;
+			break;
+		case IEEE80211_RADIOTAP_EXT:
+			/*
+			 * bit 31 was set, there is more
+			 * -- move to next u32 bitmap
+			 */
+			iterator->_bitmap_shifter =
+				get_unaligned_le32(iterator->_next_bitmap);
+			iterator->_next_bitmap++;
+			if (iterator->_reset_on_ext)
+				iterator->_arg_index = 0;
+			else
+				iterator->_arg_index++;
+			iterator->_reset_on_ext = 0;
+			break;
+		default:
+			/* we've got a hit! */
+			hit = 1;
+ next_entry:
+			iterator->_bitmap_shifter >>= 1;
+			iterator->_arg_index++;
+		}
 
 		/* if we found a valid arg earlier, return it now */
 		if (hit)
 			return 0;
 	}
-
-	/* we don't know how to handle any more args, we're done */
-	return -ENOENT;
 }
 EXPORT_SYMBOL(ieee80211_radiotap_iterator_next);
--- wireless-testing.orig/net/mac80211/tx.c	2010-01-26 11:11:37.000000000 +0100
+++ wireless-testing/net/mac80211/tx.c	2010-01-26 11:13:01.000000000 +0100
@@ -1010,7 +1010,8 @@ static bool __ieee80211_parse_tx_radiota
 		(struct ieee80211_radiotap_header *) skb->data;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	int ret = ieee80211_radiotap_iterator_init(&iterator, rthdr, skb->len);
+	int ret = ieee80211_radiotap_iterator_init(&iterator, rthdr, skb->len,
+						   NULL);
 
 	sband = tx->local->hw.wiphy->bands[tx->channel->band];
 
@@ -1046,7 +1047,7 @@ static bool __ieee80211_parse_tx_radiota
 				 * because it will be recomputed and added
 				 * on transmission
 				 */
-				if (skb->len < (iterator.max_length + FCS_LEN))
+				if (skb->len < (iterator._max_length + FCS_LEN))
 					return false;
 
 				skb_trim(skb, skb->len - FCS_LEN);
@@ -1073,10 +1074,10 @@ static bool __ieee80211_parse_tx_radiota
 
 	/*
 	 * remove the radiotap header
-	 * iterator->max_length was sanity-checked against
+	 * iterator->_max_length was sanity-checked against
 	 * skb->len by iterator init
 	 */
-	skb_pull(skb, iterator.max_length);
+	skb_pull(skb, iterator._max_length);
 
 	return true;
 }


