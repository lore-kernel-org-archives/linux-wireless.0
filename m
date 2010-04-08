Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39040 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933443Ab0DHUNr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 16:13:47 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: andy@warmcat.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/2] packetspammer: update with the upstream radiotap header
Date: Thu,  8 Apr 2010 16:13:45 -0400
Message-Id: <1270757626-22095-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1270757626-22095-1-git-send-email-lrodriguez@atheros.com>
References: <1270757626-22095-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Skip the unaligned stuff, I'm too lazy to get that to compile
properly with older systems.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 ieee80211_radiotap.h |   27 +++++++++++----------------
 1 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/ieee80211_radiotap.h b/ieee80211_radiotap.h
index 44024a3..6d36832 100644
--- a/ieee80211_radiotap.h
+++ b/ieee80211_radiotap.h
@@ -1,7 +1,4 @@
-/* $FreeBSD: src/sys/net80211/ieee80211_radiotap.h,v 1.5 2005/01/22 20:12:05 sam Exp $ */
-/* $NetBSD: ieee80211_radiotap.h,v 1.11 2005/06/22 06:16:02 dyoung Exp $ */
-
-/*-
+/*
  * Copyright (c) 2003, 2004 David Young.  All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -41,8 +38,6 @@
 #include <linux/if_ether.h>
 #include <linux/kernel.h>
 
-/* Radiotap header version (from official NetBSD feed) */
-#define IEEE80211RADIOTAP_VERSION	"1.5"
 /* Base version of the radiotap packet header data */
 #define PKTHDR_RADIOTAP_VERSION		0
 
@@ -61,12 +56,8 @@
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
@@ -88,9 +79,7 @@ struct ieee80211_radiotap_header {
 				 * Additional extensions are made
 				 * by setting bit 31.
 				 */
-};
-
-#define IEEE80211_RADIOTAP_PRESENT_EXTEND_MASK 0x80000000
+} __packed;
 
 /* Name                                 Data type    Units
  * ----                                 ---------    -----
@@ -208,6 +197,10 @@ enum ieee80211_radiotap_type {
 	IEEE80211_RADIOTAP_TX_FLAGS = 15,
 	IEEE80211_RADIOTAP_RTS_RETRIES = 16,
 	IEEE80211_RADIOTAP_DATA_RETRIES = 17,
+
+	/* valid in every it_present bitmap, even vendor namespaces */
+	IEEE80211_RADIOTAP_RADIOTAP_NAMESPACE = 29,
+	IEEE80211_RADIOTAP_VENDOR_NAMESPACE = 30,
 	IEEE80211_RADIOTAP_EXT = 31
 };
 
@@ -240,8 +233,10 @@ enum ieee80211_radiotap_type {
 						 * 802.11 header and payload
 						 * (to 32-bit boundary)
 						 */
+#define IEEE80211_RADIOTAP_F_BADFCS	0x40	/* bad FCS */
+
 /* For IEEE80211_RADIOTAP_RX_FLAGS */
-#define IEEE80211_RADIOTAP_F_RX_BADFCS	0x0001	/* frame failed crc check */
+#define IEEE80211_RADIOTAP_F_RX_BADPLCP	0x0002	/* frame has bad PLCP */
 
 /* For IEEE80211_RADIOTAP_TX_FLAGS */
 #define IEEE80211_RADIOTAP_F_TX_FAIL	0x0001	/* failed due to excessive
-- 
1.6.3.3

