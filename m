Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:35233 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751004AbdGKAsG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Jul 2017 20:48:06 -0400
Received: by mail-pg0-f54.google.com with SMTP id j186so57547135pge.2
        for <linux-wireless@vger.kernel.org>; Mon, 10 Jul 2017 17:48:05 -0700 (PDT)
From: Ningyuan Wang <nywang@google.com>
To: johannes@sipsolutions.net
Cc: Ningyuan Wang <nywang@google.com>, linux-wireless@vger.kernel.org
Subject: [PATCH] Print NL80211_BSS_LAST_SEEN_BOOTTIME on scan results
Date: Mon, 10 Jul 2017 17:47:46 -0700
Message-Id: <20170711004746.142837-1-nywang@google.com> (sfid-20170711_024811_022066_15223599)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch allows iw to print NL80211_BSS_LAST_SEEN_BOOTTIME
values on scan results.

Change-Id: I4e6a3d9999830a83766d59671b42e824421a3414
---
 nl80211.h |  4 ++++
 scan.c    | 11 +++++++++++
 2 files changed, 15 insertions(+)

diff --git a/nl80211.h b/nl80211.h
index 241220c..5ea103c 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -3360,6 +3360,9 @@ enum nl80211_bss_scan_width {
  *	(not present if no beacon frame has been received yet)
  * @NL80211_BSS_PRESP_DATA: the data in @NL80211_BSS_INFORMATION_ELEMENTS and
  *	@NL80211_BSS_TSF is known to be from a probe response (flag attribute)
+ * @NL80211_BSS_LAST_SEEN_BOOTTIME: CLOCK_BOOTTIME timestamp when this entry
+ *	was last updated by a received frame. The value is expected to be
+ *	accurate to about 10ms. (u64, nanoseconds)
  * @__NL80211_BSS_AFTER_LAST: internal
  * @NL80211_BSS_MAX: highest BSS attribute
  */
@@ -3379,6 +3382,7 @@ enum nl80211_bss {
 	NL80211_BSS_CHAN_WIDTH,
 	NL80211_BSS_BEACON_TSF,
 	NL80211_BSS_PRESP_DATA,
+	NL80211_BSS_LAST_SEEN_BOOTTIME,
 
 	/* keep last */
 	__NL80211_BSS_AFTER_LAST,
diff --git a/scan.c b/scan.c
index bf39f34..279df04 100644
--- a/scan.c
+++ b/scan.c
@@ -1853,6 +1853,7 @@ static int print_bss_handler(struct nl_msg *msg, void *arg)
 	char mac_addr[20], dev[20];
 	static struct nla_policy bss_policy[NL80211_BSS_MAX + 1] = {
 		[NL80211_BSS_TSF] = { .type = NLA_U64 },
+		[NL80211_BSS_LAST_SEEN_BOOTTIME] = { .type = NLA_U64 },
 		[NL80211_BSS_FREQUENCY] = { .type = NLA_U32 },
 		[NL80211_BSS_BSSID] = { },
 		[NL80211_BSS_BEACON_INTERVAL] = { .type = NLA_U16 },
@@ -1918,6 +1919,16 @@ static int print_bss_handler(struct nl_msg *msg, void *arg)
 			tsf, tsf/1000/1000/60/60/24, (tsf/1000/1000/60/60) % 24,
 			(tsf/1000/1000/60) % 60, (tsf/1000/1000) % 60);
 	}
+	if (bss[NL80211_BSS_LAST_SEEN_BOOTTIME]) {
+		unsigned long long last_seen_since_boot;
+		last_seen_since_boot =
+			(unsigned long long)nla_get_u64(bss[NL80211_BSS_LAST_SEEN_BOOTTIME]);
+		printf("\tlast seen since boot time: %llu usec (%llud, %.2lld:%.2llu:%.2llu)\n",
+			last_seen_since_boot, last_seen_since_boot /1000/1000/1000/60/60/24,
+			(last_seen_since_boot /1000/1000/1000/60/60) % 24,
+			(last_seen_since_boot/1000/1000/1000/60) % 60,
+			(last_seen_since_boot/1000/1000/1000) % 60);
+	}
 	if (bss[NL80211_BSS_FREQUENCY]) {
 		int freq = nla_get_u32(bss[NL80211_BSS_FREQUENCY]);
 		printf("\tfreq: %d\n", freq);
-- 
2.13.2.725.g09c95d1e9-goog
