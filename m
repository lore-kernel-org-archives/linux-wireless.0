Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:43852 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbaH0H6u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Aug 2014 03:58:50 -0400
Received: by mail-lb0-f182.google.com with SMTP id n15so2599249lbi.41
        for <linux-wireless@vger.kernel.org>; Wed, 27 Aug 2014 00:58:48 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 1/2] iw: print hexdump when vendor event
Date: Wed, 27 Aug 2014 09:58:28 +0200
Message-Id: <1409126309-4052-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140827_095853_439313_6BAA66F4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

print hexdump when vendor event and -f requested

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 event.c |    4 ++++
 iw.h    |    1 +
 util.c  |   13 +++++++++++++
 3 files changed, 18 insertions(+)

diff --git a/event.c b/event.c
index 6775eb2..d903f9e 100644
--- a/event.c
+++ b/event.c
@@ -535,6 +535,10 @@ static int print_event(struct nl_msg *msg, void *arg)
 		printf("vendor event %.6x:%d\n",
 			nla_get_u32(tb[NL80211_ATTR_VENDOR_ID]),
 			nla_get_u32(tb[NL80211_ATTR_VENDOR_SUBCMD]));
+		if (args->frame && tb[NL80211_ATTR_VENDOR_DATA])
+			iw_hexdump("vendor event",
+				   nla_data(tb[NL80211_ATTR_VENDOR_DATA]),
+				   nla_len(tb[NL80211_ATTR_VENDOR_DATA]));
 		break;
 	default:
 		printf("unknown event %d (%s)\n",
diff --git a/iw.h b/iw.h
index 317f0a6..db88a86 100644
--- a/iw.h
+++ b/iw.h
@@ -171,6 +171,7 @@ void print_ies(unsigned char *ie, int ielen, bool unknown,
 	       enum print_ie_type ptype);
 
 void parse_bitrate(struct nlattr *bitrate_attr, char *buf, int buflen);
+void iw_hexdump(const char *prefix, const __u8 *data, size_t len);
 
 DECLARE_SECTION(set);
 DECLARE_SECTION(get);
diff --git a/util.c b/util.c
index 97307ec..ce4b0ac 100644
--- a/util.c
+++ b/util.c
@@ -702,3 +702,16 @@ void print_vht_info(__u32 capa, const __u8 *mcs)
 	tmp = mcs[6] | (mcs[7] << 8);
 	printf("\t\tVHT TX highest supported: %d Mbps\n", tmp & 0x1fff);
 }
+
+void iw_hexdump(const char *prefix, const __u8 *buf, size_t size)
+{
+	int i;
+
+	printf("%s: ", prefix);
+	for (i = 0; i < size; i++) {
+		if (i && i % 16 == 0)
+			printf("\n%s: ", prefix);
+		printf("%02x ", buf[i]);
+	}
+	printf("\n\n");
+}
-- 
1.7.9.5

