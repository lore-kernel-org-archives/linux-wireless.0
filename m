Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:40668 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751333AbXFNMhJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2007 08:37:09 -0400
Message-Id: <20070614123704.608297648@warmcat.com>
References: <20070614123316.868155662@warmcat.com>
Date: Thu, 14 Jun 2007 13:33:18 +0100
From: andy@warmcat.com
To: linux-wireless@vger.kernel.org
Cc: John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jiri Benc <jbenc@suse.cz>, Andy Green <andy@warmcat.com>
Subject: [PATCH Try#lucky13 2/3] cfg80211: Radiotap parser
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Generic code to walk through the fields in a radiotap header, accounting
for nasties like extended "field present" bitfields and alignment rules

Try #lucky13
 - Integrated a patch from Michael Wu with  (Thanks again Michael)
    - whitespace errors
    - an endian error
    - a strict endian typing problem
 - Johannes Berg's suggested use of get_unaligned() to protect unaligned
   defreferences of all multibyte radiotap stuff

Try #12  comments from Michael Wu
 - Use 1<<IEEE80211_RADIOTAP_EXT then no need to add mask to radiotap hdr
 - Revert Johannes' enum method
 - break down padding action with temp var

Try #11
 - parser returns enum retcode - Johannes Berg

Try #10  comments from Michael Wu
 - kill some spaces between * and var/arg
 - weed out cut-n-pasted #includes that aren't actually used
 - kill vertical justification
 - kill unneccessary parenthesis in some expressions
 - sizeof() on dereferenced vars not types
 - ulong pointer arithmetic!  Good catch!

Try #9 (of the radiotap patchset) thanks to Johannes Berg's feedback
 - Add docs to nano kernel docs
 - Add docs to Documentation/networking/radiotap-headers.txt
 - Fix typos

Try #2
 - added sanity check to extended present bitmap u32 walking code - disallow
   possibility to walk past the end of the radiotap header length

Try #1
 - Based on Johannes Berg's comments, broke out the radiotap parsing into
   its own file as part of cfg80211
 - From same comments, added mask constant for b31 of arg presence bitfield
   to ieee80211_radiotap.h
 - Fixed subtle but nasty bug with alignment: args in the radiotap area are
   aligned *relative to the start of the header* now.  The header is not
   guaranteed to align to anything (it is randomly in an skb data area).

CC: John Linville <linville@tuxdriver.com>
CC: Johannes Berg <johannes@sipsolutions.net>
CC: Jiri Benc <jbenc@suse.cz>
Signed-off-by: Andy Green <andy@warmcat.com>

===================================================

---
 Documentation/networking/radiotap-headers.txt |   65 ++++++
 include/net/cfg80211.h                        |   38 +++
 net/wireless/Makefile                         |    2 
 net/wireless/radiotap.c                       |  257 ++++++++++++++++++++++++++
 4 files changed, 361 insertions(+), 1 deletion(-)

Index: wireless-dev/include/net/cfg80211.h
===================================================================
--- wireless-dev.orig/include/net/cfg80211.h
+++ wireless-dev/include/net/cfg80211.h
@@ -74,6 +74,44 @@ struct key_params {
 	u32 cipher;
 };
 
+
+/* Radiotap header iteration
+ *   implemented in net/wireless/radiotap.c
+ *   docs in Documentation/networking/radiotap-headers.txt
+ */
+/**
+ * struct ieee80211_radiotap_iterator - tracks walk thru present radiotap args
+ * @rtheader: pointer to the radiotap header we are walking through
+ * @max_length: length of radiotap header in cpu byte ordering
+ * @this_arg_index: IEEE80211_RADIOTAP_... index of current arg
+ * @this_arg: pointer to current radiotap arg
+ * @arg_index: internal next argument index
+ * @arg: internal next argument pointer
+ * @next_bitmap: internal pointer to next present u32
+ * @bitmap_shifter: internal shifter for curr u32 bitmap, b0 set == arg present
+ */
+
+struct ieee80211_radiotap_iterator {
+	struct ieee80211_radiotap_header *rtheader;
+	int max_length;
+	int this_arg_index;
+	u8 *this_arg;
+
+	int arg_index;
+	u8 *arg;
+	__le32 *next_bitmap;
+	u32 bitmap_shifter;
+};
+
+extern int ieee80211_radiotap_iterator_init(
+   struct ieee80211_radiotap_iterator *iterator,
+   struct ieee80211_radiotap_header *radiotap_header,
+   int max_length);
+
+extern int ieee80211_radiotap_iterator_next(
+   struct ieee80211_radiotap_iterator *iterator);
+
+
 /* from net/wireless.h */
 struct wiphy;
 
Index: wireless-dev/net/wireless/Makefile
===================================================================
--- wireless-dev.orig/net/wireless/Makefile
+++ wireless-dev/net/wireless/Makefile
@@ -1,5 +1,5 @@
 obj-$(CONFIG_WIRELESS_EXT) += wext.o
 obj-$(CONFIG_CFG80211) += cfg80211.o
 
-cfg80211-y += core.o sysfs.o
+cfg80211-y += core.o sysfs.o radiotap.o
 cfg80211-$(CONFIG_NL80211) += nl80211.o
Index: wireless-dev/net/wireless/radiotap.c
===================================================================
--- /dev/null
+++ wireless-dev/net/wireless/radiotap.c
@@ -0,0 +1,257 @@
+/*
+ * Radiotap parser
+ *
+ * Copyright 2007		Andy Green <andy@warmcat.com>
+ */
+
+#include <net/cfg80211.h>
+#include <net/ieee80211_radiotap.h>
+#include <asm/unaligned.h>
+
+/* function prototypes and related defs are in include/net/cfg80211.h */
+
+/**
+ * ieee80211_radiotap_iterator_init - radiotap parser iterator initialization
+ * @iterator: radiotap_iterator to initialize
+ * @radiotap_header: radiotap header to parse
+ * @max_length: total length we can parse into (eg, whole packet length)
+ *
+ * Returns: 0 or a negative error code if there is a problem.
+ *
+ * This function initializes an opaque iterator struct which can then
+ * be passed to ieee80211_radiotap_iterator_next() to visit every radiotap
+ * argument which is present in the header.  It knows about extended
+ * present headers and handles them.
+ *
+ * How to use:
+ * call __ieee80211_radiotap_iterator_init() to init a semi-opaque iterator
+ * struct ieee80211_radiotap_iterator (no need to init the struct beforehand)
+ * checking for a good 0 return code.  Then loop calling
+ * __ieee80211_radiotap_iterator_next()... it returns either 0,
+ * -ENOENT if there are no more args to parse, or -EINVAL if there is a problem.
+ * The iterator's @this_arg member points to the start of the argument
+ * associated with the current argument index that is present, which can be
+ * found in the iterator's @this_arg_index member.  This arg index corresponds
+ * to the IEEE80211_RADIOTAP_... defines.
+ *
+ * Radiotap header length:
+ * You can find the CPU-endian total radiotap header length in
+ * iterator->max_length after executing ieee80211_radiotap_iterator_init()
+ * successfully.
+ *
+ * Alignment Gotcha:
+ * You must take care when dereferencing iterator.this_arg
+ * for multibyte types... the pointer is not aligned.  Use
+ * get_unaligned((type *)iterator.this_arg) to dereference
+ * iterator.this_arg for type "type" safely on all arches.
+ *
+ * Example code:
+ * See Documentation/networking/radiotap-headers.txt
+ */
+
+int ieee80211_radiotap_iterator_init(
+    struct ieee80211_radiotap_iterator *iterator,
+    struct ieee80211_radiotap_header *radiotap_header,
+    int max_length)
+{
+	/* Linux only supports version 0 radiotap format */
+	if (radiotap_header->it_version)
+		return -EINVAL;
+
+	/* sanity check for allowed length and radiotap length field */
+	if (max_length < le16_to_cpu(get_unaligned(&radiotap_header->it_len)))
+		return -EINVAL;
+
+	iterator->rtheader = radiotap_header;
+	iterator->max_length = le16_to_cpu(get_unaligned(
+						&radiotap_header->it_len));
+	iterator->arg_index = 0;
+	iterator->bitmap_shifter = le32_to_cpu(get_unaligned(
+						&radiotap_header->it_present));
+	iterator->arg = (u8 *)radiotap_header + sizeof(*radiotap_header);
+	iterator->this_arg = NULL;
+
+	/* find payload start allowing for extended bitmap(s) */
+
+	if (unlikely(iterator->bitmap_shifter & (1<<IEEE80211_RADIOTAP_EXT))) {
+		while (le32_to_cpu(get_unaligned((__le32 *)iterator->arg)) &
+				   (1<<IEEE80211_RADIOTAP_EXT)) {
+			iterator->arg += sizeof(u32);
+
+			/*
+			 * check for insanity where the present bitmaps
+			 * keep claiming to extend up to or even beyond the
+			 * stated radiotap header length
+			 */
+
+			if (((ulong)iterator->arg -
+			     (ulong)iterator->rtheader) > iterator->max_length)
+				return -EINVAL;
+		}
+
+		iterator->arg += sizeof(u32);
+
+		/*
+		 * no need to check again for blowing past stated radiotap
+		 * header length, because ieee80211_radiotap_iterator_next
+		 * checks it before it is dereferenced
+		 */
+	}
+
+	/* we are all initialized happily */
+
+	return 0;
+}
+EXPORT_SYMBOL(ieee80211_radiotap_iterator_init);
+
+
+/**
+ * ieee80211_radiotap_iterator_next - return next radiotap parser iterator arg
+ * @iterator: radiotap_iterator to move to next arg (if any)
+ *
+ * Returns: 0 if there is an argument to handle,
+ * -ENOENT if there are no more args or -EINVAL
+ * if there is something else wrong.
+ *
+ * This function provides the next radiotap arg index (IEEE80211_RADIOTAP_*)
+ * in @this_arg_index and sets @this_arg to point to the
+ * payload for the field.  It takes care of alignment handling and extended
+ * present fields.  @this_arg can be changed by the caller (eg,
+ * incremented to move inside a compound argument like
+ * IEEE80211_RADIOTAP_CHANNEL).  The args pointed to are in
+ * little-endian format whatever the endianess of your CPU.
+ *
+ * Alignment Gotcha:
+ * You must take care when dereferencing iterator.this_arg
+ * for multibyte types... the pointer is not aligned.  Use
+ * get_unaligned((type *)iterator.this_arg) to dereference
+ * iterator.this_arg for type "type" safely on all arches.
+ */
+
+int ieee80211_radiotap_iterator_next(
+    struct ieee80211_radiotap_iterator *iterator)
+{
+
+	/*
+	 * small length lookup table for all radiotap types we heard of
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
+		/*
+		 * add more here as they are defined in
+		 * include/net/ieee80211_radiotap.h
+		 */
+	};
+
+	/*
+	 * for every radiotap entry we can at
+	 * least skip (by knowing the length)...
+	 */
+
+	while (iterator->arg_index < sizeof(rt_sizes)) {
+		int hit = 0;
+		int pad;
+
+		if (!(iterator->bitmap_shifter & 1))
+			goto next_entry; /* arg not present */
+
+		/*
+		 * arg is present, account for alignment padding
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
+		 *
+		 * the above is why get_unaligned() is used to dereference
+		 * multibyte elements from the radiotap area
+		 */
+
+		pad = (((ulong)iterator->arg) -
+			((ulong)iterator->rtheader)) &
+			((rt_sizes[iterator->arg_index] >> 4) - 1);
+
+		if (pad)
+			iterator->arg +=
+				(rt_sizes[iterator->arg_index] >> 4) - pad;
+
+		/*
+		 * this is what we will return to user, but we need to
+		 * move on first so next call has something fresh to test
+		 */
+		iterator->this_arg_index = iterator->arg_index;
+		iterator->this_arg = iterator->arg;
+		hit = 1;
+
+		/* internally move on the size of this arg */
+		iterator->arg += rt_sizes[iterator->arg_index] & 0x0f;
+
+		/*
+		 * check for insanity where we are given a bitmap that
+		 * claims to have more arg content than the length of the
+		 * radiotap section.  We will normally end up equalling this
+		 * max_length on the last arg, never exceeding it.
+		 */
+
+		if (((ulong)iterator->arg - (ulong)iterator->rtheader) >
+		    iterator->max_length)
+			return -EINVAL;
+
+	next_entry:
+		iterator->arg_index++;
+		if (unlikely((iterator->arg_index & 31) == 0)) {
+			/* completed current u32 bitmap */
+			if (iterator->bitmap_shifter & 1) {
+				/* b31 was set, there is more */
+				/* move to next u32 bitmap */
+				iterator->bitmap_shifter = le32_to_cpu(
+					get_unaligned(iterator->next_bitmap));
+				iterator->next_bitmap++;
+			} else
+				/* no more bitmaps: end */
+				iterator->arg_index = sizeof(rt_sizes);
+		} else /* just try the next bit */
+			iterator->bitmap_shifter >>= 1;
+
+		/* if we found a valid arg earlier, return it now */
+		if (hit)
+			return 0;
+	}
+
+	/* we don't know how to handle any more args, we're done */
+	return -ENOENT;
+}
+EXPORT_SYMBOL(ieee80211_radiotap_iterator_next);
Index: wireless-dev/Documentation/networking/radiotap-headers.txt
===================================================================
--- wireless-dev.orig/Documentation/networking/radiotap-headers.txt
+++ wireless-dev/Documentation/networking/radiotap-headers.txt
@@ -84,4 +84,69 @@ Example valid radiotap header
 	0x01 //<-- antenna
 
 
+Using the Radiotap Parser
+-------------------------
+
+If you are having to parse a radiotap struct, you can radically simplify the
+job by using the radiotap parser that lives in net/wireless/radiotap.c and has
+its prototypes available in include/net/cfg80211.h.  You use it like this:
+
+#include <net/cfg80211.h>
+
+/* buf points to the start of the radiotap header part */
+
+int MyFunction(u8 * buf, int buflen)
+{
+	int pkt_rate_100kHz = 0, antenna = 0, pwr = 0;
+	struct ieee80211_radiotap_iterator iterator;
+	int ret = ieee80211_radiotap_iterator_init(&iterator, buf, buflen);
+
+	while (!ret) {
+
+		ret = ieee80211_radiotap_iterator_next(&iterator);
+
+		if (ret)
+			continue;
+
+		/* see if this argument is something we can use */
+
+		switch (iterator.this_arg_index) {
+		/*
+		 * You must take care when dereferencing iterator.this_arg
+		 * for multibyte types... the pointer is not aligned.  Use
+		 * get_unaligned((type *)iterator.this_arg) to dereference
+		 * iterator.this_arg for type "type" safely on all arches.
+		 */
+		case IEEE80211_RADIOTAP_RATE:
+			/* radiotap "rate" u8 is in
+			 * 500kbps units, eg, 0x02=1Mbps
+			 */
+			pkt_rate_100kHz = (*iterator.this_arg) * 5;
+			break;
+
+		case IEEE80211_RADIOTAP_ANTENNA:
+			/* radiotap uses 0 for 1st ant */
+			antenna = *iterator.this_arg);
+			break;
+
+		case IEEE80211_RADIOTAP_DBM_TX_POWER:
+			pwr = *iterator.this_arg;
+			break;
+
+		default:
+			break;
+		}
+	}  /* while more rt headers */
+
+	if (ret != -ENOENT)
+		return TXRX_DROP;
+
+	/* discard the radiotap header part */
+	buf += iterator.max_length;
+	buflen -= iterator.max_length;
+
+	...
+
+}
+
 Andy Green <andy@warmcat.com>

-- 
