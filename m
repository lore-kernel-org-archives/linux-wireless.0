Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:13312 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625AbYFIT2a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2008 15:28:30 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2230439wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jun 2008 12:28:30 -0700 (PDT)
Subject: [PATCHv2 3/8] mac80211: add utility function to get header length
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 09 Jun 2008 12:28:21 -0700
Message-Id: <1213039701.5974.68.camel@brick> (sfid-20080609_212835_247787_12DA9D75)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Take a __le16 directly rather than a host-endian value.

ieee80211_hdrlen is meant to eventually replace ieee80211_get_hdrlen
which takes a host-endian frame control.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/net/mac80211.h |    6 ++++++
 net/mac80211/util.c    |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 1196de8..53c3b5e 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1548,6 +1548,12 @@ int ieee80211_get_hdrlen_from_skb(const struct sk_buff *skb);
 int ieee80211_get_hdrlen(u16 fc);
 
 /**
+ * ieee80211_hdrlen - get header length in bytes from frame control
+ * @fc: frame control field in little-endian format
+ */
+unsigned int ieee80211_hdrlen(__le16 fc);
+
+/**
  * ieee80211_get_tkip_key - get a TKIP rc4 for skb
  *
  * This function computes a TKIP rc4 key for an skb. It computes
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 6513bc2..722a4eb 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -133,6 +133,38 @@ int ieee80211_get_hdrlen(u16 fc)
 }
 EXPORT_SYMBOL(ieee80211_get_hdrlen);
 
+unsigned int ieee80211_hdrlen(__le16 fc)
+{
+	unsigned int hdrlen = 24;
+
+	if (ieee80211_is_data(fc)) {
+		if (ieee80211_has_a4(fc))
+			hdrlen = 30;
+		if (ieee80211_is_data_qos(fc))
+			hdrlen += IEEE80211_QOS_CTL_LEN;
+		goto out;
+	}
+
+	if (ieee80211_is_ctl(fc)) {
+		/*
+		 * ACK and CTS are 10 bytes, all others 16. To see how
+		 * to get this condition consider
+		 *   subtype mask:   0b0000000011110000 (0x00F0)
+		 *   ACK subtype:    0b0000000011010000 (0x00D0)
+		 *   CTS subtype:    0b0000000011000000 (0x00C0)
+		 *   bits that matter:         ^^^      (0x00E0)
+		 *   value of those: 0b0000000011000000 (0x00C0)
+		 */
+		if ((fc & cpu_to_le16(0x00E0)) == cpu_to_le16(0x00C0))
+			hdrlen = 10;
+		else
+			hdrlen = 16;
+	}
+out:
+	return hdrlen;
+}
+EXPORT_SYMBOL(ieee80211_hdrlen);
+
 int ieee80211_get_hdrlen_from_skb(const struct sk_buff *skb)
 {
 	const struct ieee80211_hdr *hdr = (const struct ieee80211_hdr *) skb->data;
-- 
1.5.6.rc2.261.ga8fbe


