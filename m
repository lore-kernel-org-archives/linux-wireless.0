Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53003 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115AbYK0WON (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2008 17:14:13 -0500
Subject: [PATCH] wireless: clean up radiotap a bit
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 27 Nov 2008 23:13:38 +0100
Message-Id: <1227824018.7559.6.camel@johannes.berg> (sfid-20081127_231416_267107_4AF846B4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No need to pad the header so no constant needed for that,
no need to carry any version number from netbsd nor CVS
IDs from them.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/ipw2x00/ipw2200.c   |   24 +++---------------------
 drivers/net/wireless/libertas/radiotap.h |    3 ---
 include/net/ieee80211_radiotap.h         |   15 +++------------
 3 files changed, 6 insertions(+), 36 deletions(-)

--- everything.orig/drivers/net/wireless/ipw2x00/ipw2200.c	2008-11-27 23:11:11.000000000 +0100
+++ everything/drivers/net/wireless/ipw2x00/ipw2200.c	2008-11-27 23:11:29.000000000 +0100
@@ -7810,15 +7810,6 @@ static void ipw_handle_data_packet_monit
 	memmove(rxb->skb->data + sizeof(struct ipw_rt_hdr),
 		rxb->skb->data + IPW_RX_FRAME_SIZE, len);
 
-	/* Zero the radiotap static buffer  ...  We only need to zero the bytes NOT
-	 * part of our real header, saves a little time.
-	 *
-	 * No longer necessary since we fill in all our data.  Purge before merging
-	 * patch officially.
-	 * memset(rxb->skb->data + sizeof(struct ipw_rt_hdr), 0,
-	 *        IEEE80211_RADIOTAP_HDRLEN - sizeof(struct ipw_rt_hdr));
-	 */
-
 	ipw_rt = (struct ipw_rt_hdr *)rxb->skb->data;
 
 	ipw_rt->rt_hdr.it_version = PKTHDR_RADIOTAP_VERSION;
@@ -8026,15 +8017,6 @@ static void ipw_handle_promiscuous_rx(st
 
 	memcpy(ipw_rt->payload, hdr, len);
 
-	/* Zero the radiotap static buffer  ...  We only need to zero the bytes
-	 * NOT part of our real header, saves a little time.
-	 *
-	 * No longer necessary since we fill in all our data.  Purge before
-	 * merging patch officially.
-	 * memset(rxb->skb->data + sizeof(struct ipw_rt_hdr), 0,
-	 *        IEEE80211_RADIOTAP_HDRLEN - sizeof(struct ipw_rt_hdr));
-	 */
-
 	ipw_rt->rt_hdr.it_version = PKTHDR_RADIOTAP_VERSION;
 	ipw_rt->rt_hdr.it_pad = 0;	/* always good to zero */
 	ipw_rt->rt_hdr.it_len = cpu_to_le16(sizeof(*ipw_rt));	/* total header+data */
@@ -10435,9 +10417,9 @@ static void ipw_handle_promiscuous_tx(st
 		} else
 			len = src->len;
 
-		dst = alloc_skb(
-			len + IEEE80211_RADIOTAP_HDRLEN, GFP_ATOMIC);
-		if (!dst) continue;
+		dst = alloc_skb(len + sizeof(*rt_hdr), GFP_ATOMIC);
+		if (!dst)
+			continue;
 
 		rt_hdr = (void *)skb_put(dst, sizeof(*rt_hdr));
 
--- everything.orig/drivers/net/wireless/libertas/radiotap.h	2008-11-27 23:11:28.000000000 +0100
+++ everything/drivers/net/wireless/libertas/radiotap.h	2008-11-27 23:11:36.000000000 +0100
@@ -6,9 +6,6 @@ struct tx_radiotap_hdr {
 	u8 txpower;
 	u8 rts_retries;
 	u8 data_retries;
-#if 0
-	u8 pad[IEEE80211_RADIOTAP_HDRLEN - 12];
-#endif
 } __attribute__ ((packed));
 
 #define TX_RADIOTAP_PRESENT (				\
--- everything.orig/include/net/ieee80211_radiotap.h	2008-11-27 23:11:27.000000000 +0100
+++ everything/include/net/ieee80211_radiotap.h	2008-11-27 23:11:36.000000000 +0100
@@ -1,7 +1,4 @@
-/* $FreeBSD: src/sys/net80211/ieee80211_radiotap.h,v 1.5 2005/01/22 20:12:05 sam Exp $ */
-/* $NetBSD: ieee80211_radiotap.h,v 1.11 2005/06/22 06:16:02 dyoung Exp $ */
-
-/*-
+/*
  * Copyright (c) 2003, 2004 David Young.  All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -42,8 +39,6 @@
 #include <linux/kernel.h>
 #include <asm/unaligned.h>
 
-/* Radiotap header version (from official NetBSD feed) */
-#define IEEE80211RADIOTAP_VERSION	"1.5"
 /* Base version of the radiotap packet header data */
 #define PKTHDR_RADIOTAP_VERSION		0
 
@@ -62,12 +57,8 @@
  * readers.
  */
 
-/* XXX tcpdump/libpcap do not tolerate variable-length headers,
- * yet, so we pad every radiotap header to 64 bytes. Ugh.
- */
-#define IEEE80211_RADIOTAP_HDRLEN	64
-
-/* The radio capture header precedes the 802.11 header.
+/*
+ * The radio capture header precedes the 802.11 header.
  * All data in the header is little endian on all platforms.
  */
 struct ieee80211_radiotap_header {


