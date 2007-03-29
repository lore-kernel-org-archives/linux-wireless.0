Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:43487 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753500AbXC2Nkp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2007 09:40:45 -0400
Received: from armbox7.home.warmcat.com (cpc1-nthc5-0-0-cust289.nrth.cable.ntl.com [82.29.29.34])
	by mailserver.mog.warmcat.com (Postfix) with ESMTP id AA3908D0F2
	for <linux-wireless@vger.kernel.org>; Thu, 29 Mar 2007 15:40:39 +0200 (CEST)
Received: from meerkat.home.warmcat.com (flatcat [192.168.0.77])
	by armbox7.home.warmcat.com (Postfix) with ESMTP id 1DA931010F
	for <linux-wireless@vger.kernel.org>; Thu, 29 Mar 2007 13:41:03 +0000 (UTC)
Message-Id: <20070329134041.298327997@warmcat.com>
References: <20070329133814.841581235@warmcat.com>
Date: Thu, 29 Mar 2007 14:38:18 +0100
From: andy@warmcat.com
To: linux-wireless@vger.kernel.org
Subject: [PATCH 4/5] cfg80211:Radiotap parser
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andy Green <andy@warmcat.com>

Try #1
 - Based on Johannes Berg's comments, broke out the radiotap parsing into
   its own file as part of cfg80211
 - From same comments, added mask constant for b31 of arg presence bitfield
   to ieee80211_radiotap.h
 - Fixed subtle but nasty bug with alignment: args in the radiotap area are
   aligned *relative to the start of the header* now.  The header is not
   guaranteed to align to anything (it is randomly in an skb data area).

===================================================

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 47e4544..098d4b6 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -74,6 +74,41 @@ struct key_params {
 	u32 cipher;
 };
 
+
+/* Radiotap header iteration
+ *   implemented in net/wireless/radiotap.c
+ *
+ * call __ieee80211_radiotap_iterator_init() to init the opaque iterator
+ * (no need to init anything in there beforehand)
+ * then loop calling __ieee80211_radiotap_iterator_next()... it returns -1
+ * if there are no more args in the header, or the next argument type index
+ * that is present.  The iterator's this_arg member points to the start of the
+ * argument associated with the current argument type that is present,
+ * which can be found in the iterator's this_arg_index member.
+ */
+
+struct ieee80211_radiotap_iterator {
+	struct ieee80211_radiotap_header *rtheader;
+	int max_length; /* copy of max length we can scan over */
+	int this_arg_index; /* IEEE80211_RADIOTAP_* index for caller */
+	u8 * this_arg; /* current arg start position, caller can change */
+
+	int arg_index; /* internal: arg index b0 of bitmap_shifter represents */
+	u8 * arg; /* internal: points to the next arg start position */
+	__le32 *next_bitmap; /* internal */
+	u32 bitmap_shifter; /* internal */
+};
+
+extern int ieee80211_radiotap_iterator_init(
+   struct ieee80211_radiotap_iterator * iterator,
+   struct ieee80211_radiotap_header * radiotap_header,
+   int max_length
+);
+
+extern int ieee80211_radiotap_iterator_next(
+   struct ieee80211_radiotap_iterator * iterator);
+
+
 /* from net/wireless.h */
 struct wiphy;
 
diff --git a/include/net/ieee80211_radiotap.h b/include/net/ieee80211_radiotap.h
index 7dbf9fb..b73c665 100644
--- a/include/net/ieee80211_radiotap.h
+++ b/include/net/ieee80211_radiotap.h
@@ -59,6 +59,9 @@
  * use sufficiently weaselly language ("is a monotonically nondecreasing
  * function of...") that I cannot set false expectations for lawyerly
  * readers.
+ *
+ * All arguments and fields in the struct at the start are
+ * Little-endian
  */
 
 /* XXX tcpdump/libpcap do not tolerate variable-length headers,
@@ -90,6 +93,8 @@ struct ieee80211_radiotap_header {
 				 */
 };
 
+#define IEEE80211_RADIOTAP_PRESENT_EXTEND_MASK 0x80000000
+
 /* Name                                 Data type       Units
  * ----                                 ---------       -----
  *
@@ -230,4 +235,7 @@ enum ieee80211_radiotap_type {
 	(((x) == 14) ? 2484 : ((x) * 5) + 2407) : \
 	((x) + 1000) * 5)
 
-#endif				/* IEEE80211_RADIOTAP_H */
+#endif
+
+
+/* IEEE80211_RADIOTAP_H */
diff --git a/net/wireless/Makefile b/net/wireless/Makefile
index 507a028..26f815a 100644
--- a/net/wireless/Makefile
+++ b/net/wireless/Makefile
@@ -1,6 +1,6 @@
 obj-$(CONFIG_CFG80211) += cfg80211.o
 
-cfg80211-y += core.o sysfs.o
+cfg80211-y += core.o sysfs.o radiotap.o
 cfg80211-$(CONFIG_NL80211) += nl80211.o
 cfg80211-$(CONFIG_CFG80211_WEXT_COMPAT) += wext-compat.o
 
diff --git a/net/wireless/radiotap.c b/net/wireless/radiotap.c
new file mode 100644
index 0000000..2275e8e
--- /dev/null
+++ b/net/wireless/radiotap.c
@@ -0,0 +1,213 @@
+/*
+ * Radiotap parser
+ *
+ * Copyright 2007		Andy Green <andy@warmcat.com>
+ */
+
+#include <linux/if.h>
+#include <linux/err.h>
+#include <linux/mutex.h>
+#include <linux/device.h>
+#include <net/genetlink.h>
+#include <net/cfg80211.h>
+#include <net/wireless.h>
+#include "nl80211.h"
+#include "core.h"
+#include <net/ieee80211_radiotap.h>
+
+
+/**
+ * ieee80211_radiotap_iterator_init - radiotap parser iterator initialization
+ * @iterator: radiotap_iterator to initialize
+ * @radiotap_header: radiotap header to parse
+ * @max_length: total length we can parse into (eg, whole packet length)
+ *
+ * Returns: 0 on success or negative if sanity check fails
+ *
+ * This function initializes an opaque iterator struct which can then
+ * be passed to ieee80211_radiotap_iterator_next() to visit every radiotap
+ * argument which is present in the header.  It knows about extended
+ * present headers and handles them.
+ */
+
+int ieee80211_radiotap_iterator_init(
+   struct ieee80211_radiotap_iterator * iterator,
+   struct ieee80211_radiotap_header * radiotap_header,
+   int max_length)
+{
+
+	/* Linux only supports version 0 radiotap format */
+
+	if (radiotap_header->it_version)
+		return -EINVAL;
+
+	/* sanity check for allowed length and radiotap length field */
+
+	if (max_length < (le16_to_cpu(radiotap_header->it_len)))
+		return -EINVAL;
+
+	iterator->rtheader = radiotap_header;
+	iterator->max_length = le16_to_cpu(radiotap_header->it_len);
+	iterator->arg_index = 0;
+	iterator->bitmap_shifter = le32_to_cpu(radiotap_header->it_present);
+	iterator->arg = ((u8 *)radiotap_header) +
+			sizeof(struct ieee80211_radiotap_header);
+	iterator->this_arg = 0;
+
+	/* find payload start allowing for extended bitmap(s) */
+
+	if (iterator->bitmap_shifter & IEEE80211_RADIOTAP_PRESENT_EXTEND_MASK) {
+		while (le32_to_cpu(*((u32 *)iterator->arg)) &
+		       IEEE80211_RADIOTAP_PRESENT_EXTEND_MASK)
+			iterator->arg += sizeof(u32);
+		iterator->arg += sizeof(u32);
+	}
+
+	/* we are all initialized happily */
+
+	return 0;
+}
+
+EXPORT_SYMBOL(ieee80211_radiotap_iterator_init);
+
+
+/**
+ * ieee80211_radiotap_iterator_next - return next radiotap parser iterator arg
+ * @iterator: radiotap_iterator to move to next arg (if any)
+ *
+ * Returns: next present arg index on success or negative if no more or error
+ *
+ * This function returns the next radiotap arg index (IEEE80211_RADIOTAP_*)
+ * and sets iterator->this_arg to point to the payload for the arg.  It takes
+ * care of alignment handling and extended present fields.  interator->this_arg
+ * can be changed by the caller.  The args pointed to are in little-endian
+ * format.
+ */
+
+int ieee80211_radiotap_iterator_next(
+   struct ieee80211_radiotap_iterator * iterator)
+{
+
+	/* small length lookup table for all radiotap types we heard of
+	 * starting from b0 in the bitmap, so we can walk the payload
+	 * area of the radiotap header
+	 *
+	 * There is a requirement to pad args, so that args
+	 * of a given length must begin at a boundary of that length
+	 * -- but note that compound args are allowed (eg, 2 x u16
+	 * for IEEE80211_RADIOTAP_CHANNEL) so total arg length is not
+	 * a reliable indicator of alignment requirement.
+	 *
+	 * upper nybble: content alignment for arg
+	 * lower nybble: content length for arg
+	 */
+
+	static const u8 rt_sizes[] = {
+		[IEEE80211_RADIOTAP_TSFT] = 0x88,
+		[IEEE80211_RADIOTAP_FLAGS] = 0x11,
+		[IEEE80211_RADIOTAP_RATE] = 0x11,
+		[IEEE80211_RADIOTAP_CHANNEL] = 0x24,
+		[IEEE80211_RADIOTAP_FHSS] = 0x22,
+		[IEEE80211_RADIOTAP_DBM_ANTSIGNAL] = 0x11,
+		[IEEE80211_RADIOTAP_DBM_ANTNOISE] = 0x11,
+		[IEEE80211_RADIOTAP_LOCK_QUALITY] = 0x22,
+		[IEEE80211_RADIOTAP_TX_ATTENUATION] = 0x22,
+		[IEEE80211_RADIOTAP_DB_TX_ATTENUATION] = 0x22,
+		[IEEE80211_RADIOTAP_DBM_TX_POWER] = 0x11,
+		[IEEE80211_RADIOTAP_ANTENNA] = 0x11,
+		[IEEE80211_RADIOTAP_DB_ANTSIGNAL] = 0x11,
+		[IEEE80211_RADIOTAP_DB_ANTNOISE] = 0x11
+		/* add more here as they are defined in
+		 * include/net/ieee80211_radiotap.h
+		 */
+	};
+
+	/* for every radiotap entry we can at
+	 * least skip (by knowing the length)...
+	 */
+
+	while (iterator->arg_index < sizeof(rt_sizes)) {
+		int hit=0;
+
+		if (!(iterator->bitmap_shifter & 1))
+			goto next_entry; /* arg not present */
+
+		/* arg is present, account for alignment padding
+		 *  8-bit args can be at any alignment
+		 * 16-bit args must start on 16-bit boundary
+		 * 32-bit args must start on 32-bit boundary
+		 * 64-bit args must start on 64-bit boundary
+		 *
+		 * note that total arg size can differ from alignment of
+		 * elements inside arg, so we use upper nybble of length
+		 * table to base alignment on
+		 *
+		 * also note: these alignments are ** relative to the
+		 * start of the radiotap header **.  There is no guarantee
+		 * that the radiotap header itself is aligned on any
+		 * kind of boundary.
+		 */
+
+		if ((((int)iterator->arg)-((int)iterator->rtheader)) &
+		    ((rt_sizes[iterator->arg_index] >> 4) - 1))
+			iterator->arg_index +=
+				(rt_sizes[iterator->arg_index] >> 4) -
+				((((int)iterator->arg) -
+				 ((int)iterator->rtheader)) &
+				 ((rt_sizes[iterator->arg_index] >> 4) - 1));
+
+		/* this is what we will return to user, but we need to
+		 * move on first so next call has something fresh to test
+		 */
+
+		iterator->this_arg_index = iterator->arg_index;
+		iterator->this_arg = iterator->arg;
+		hit = 1;
+
+		/* internally move on the size of this arg */
+
+		iterator->arg += rt_sizes[iterator->arg_index] & 0x0f;
+
+		/* check for insanity where we are given a bitmap that
+		 * claims to have more arg content than the length of the
+		 * radiotap section.  We will normally end up equalling this
+		 * max_length on the last arg, never exceeding it.
+		 */
+
+		if((((int)iterator->arg) - ((int)iterator->rtheader)) >
+		    iterator->max_length)
+			return -EINVAL;
+
+	next_entry:
+
+		iterator->arg_index++;
+		if (unlikely((iterator->arg_index & 31) == 0)) {
+			/* completed current u32 bitmap */
+			if (iterator->bitmap_shifter & 1) {
+				/* b31 was set, there is more */
+				/* move to next u32 bitmap */
+				iterator->bitmap_shifter = le32_to_cpu(
+					*iterator->next_bitmap);
+				iterator->next_bitmap++;
+			} else {
+				/* no more bitmaps: end */
+				iterator->arg_index = sizeof(rt_sizes);
+			}
+		} else { /* just try the next bit */
+			iterator->bitmap_shifter >>= 1;
+		}
+
+		/* if we found a valid arg earlier, return it now */
+
+		if (hit)
+			return iterator->this_arg_index;
+
+	}
+
+	/* we don't know how to handle any more args, we're done */
+
+	return -1;
+}
+
+EXPORT_SYMBOL(ieee80211_radiotap_iterator_next);
+

-- 
