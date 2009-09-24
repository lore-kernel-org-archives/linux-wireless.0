Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:63754 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbZIXJU4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 05:20:56 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] iw: show age of last scan
Date: Thu, 24 Sep 2009 11:20:47 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200909241120.47534.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This shows how old a scan result entry is.

---

Example:

# ./iw eth1 scan trigger freq 2412
# sleep 1
# ./iw eth1 scan dump | grep seen
        last seen: 832 ms ago
        last seen: 852 ms ago
        last seen: 852 ms ago
# sleep 1
# ./iw eth1 scan dump | grep seen
        last seen: 1836 ms ago
        last seen: 1856 ms ago
        last seen: 1856 ms ago

Index: iw/scan.c
===================================================================
--- iw.orig/scan.c	2009-09-21 14:06:47.000000000 +0200
+++ iw/scan.c	2009-09-24 09:57:02.000000000 +0200
@@ -754,6 +754,7 @@ static int print_bss_handler(struct nl_m
 		[NL80211_BSS_SIGNAL_MBM] = { .type = NLA_U32 },
 		[NL80211_BSS_SIGNAL_UNSPEC] = { .type = NLA_U8 },
 		[NL80211_BSS_STATUS] = { .type = NLA_U32 },
+		[NL80211_BSS_AGE_MS] = { .type = NLA_U32 },
 	};
 	struct scan_params *params = arg;
 
@@ -845,6 +846,10 @@ static int print_bss_handler(struct nl_m
 		unsigned char s = nla_get_u8(bss[NL80211_BSS_SIGNAL_UNSPEC]);
 		printf("\tsignal: %d/100\n", s);
 	}
+	if (bss[NL80211_BSS_AGE_MS]) {
+		int age = nla_get_u32(bss[NL80211_BSS_AGE_MS]);
+		printf("\tlast seen: %d ms ago\n", age);
+	}
 	if (bss[NL80211_BSS_INFORMATION_ELEMENTS])
 		print_ies(nla_data(bss[NL80211_BSS_INFORMATION_ELEMENTS]),
 			  nla_len(bss[NL80211_BSS_INFORMATION_ELEMENTS]),
Index: iw/nl80211.h
===================================================================
--- iw.orig/nl80211.h	2009-09-24 09:55:57.000000000 +0200
+++ iw/nl80211.h	2009-09-24 09:56:29.000000000 +0200
@@ -1261,6 +1261,7 @@ enum nl80211_channel_type {
  * @NL80211_BSS_SIGNAL_UNSPEC: signal strength of the probe response/beacon
  *	in unspecified units, scaled to 0..100 (u8)
  * @NL80211_BSS_STATUS: status, if this BSS is "used"
+ * @NL80211_BSS_AGE_MS: age of this BSS entry in ms
  * @__NL80211_BSS_AFTER_LAST: internal
  * @NL80211_BSS_MAX: highest BSS attribute
  */
@@ -1275,6 +1276,7 @@ enum nl80211_bss {
 	NL80211_BSS_SIGNAL_MBM,
 	NL80211_BSS_SIGNAL_UNSPEC,
 	NL80211_BSS_STATUS,
+	NL80211_BSS_AGE_MS,
 
 	/* keep last */
 	__NL80211_BSS_AFTER_LAST,

-- 
http://www.holgerschurig.de
