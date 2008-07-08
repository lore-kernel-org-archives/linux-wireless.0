Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:38668 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbYGHUrf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 16:47:35 -0400
Received: by wa-out-1112.google.com with SMTP id j37so1676401waf.23
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jul 2008 13:47:35 -0700 (PDT)
Subject: [PATCH 6/6] mac80211: remove ieee80211_get_hdrlen
From: Harvey Harrison <harvey.harrison@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 08 Jul 2008 13:47:24 -0700
Message-Id: <1215550044.476.44.camel@brick> (sfid-20080708_224738_278729_BE0656B6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All users have been moved over to the version taking a le16 frame control
rather than a cpu-endian value.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/net/mac80211.h |   10 ----------
 net/mac80211/util.c    |   39 ---------------------------------------
 2 files changed, 0 insertions(+), 49 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 0a5de3e..6b7c792 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1563,16 +1563,6 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
 unsigned int ieee80211_get_hdrlen_from_skb(const struct sk_buff *skb);
 
 /**
- * ieee80211_get_hdrlen - get header length from frame control
- *
- * This function returns the 802.11 header length in bytes (not including
- * encryption headers.)
- *
- * @fc: the frame control field (in CPU endianness)
- */
-int ieee80211_get_hdrlen(u16 fc);
-
-/**
  * ieee80211_hdrlen - get header length in bytes from frame control
  * @fc: frame control field in little-endian format
  */
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index ce62b16..7614932 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -91,45 +91,6 @@ u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len,
 	return NULL;
 }
 
-int ieee80211_get_hdrlen(u16 fc)
-{
-	int hdrlen = 24;
-
-	switch (fc & IEEE80211_FCTL_FTYPE) {
-	case IEEE80211_FTYPE_DATA:
-		if ((fc & IEEE80211_FCTL_FROMDS) && (fc & IEEE80211_FCTL_TODS))
-			hdrlen = 30; /* Addr4 */
-		/*
-		 * The QoS Control field is two bytes and its presence is
-		 * indicated by the IEEE80211_STYPE_QOS_DATA bit. Add 2 to
-		 * hdrlen if that bit is set.
-		 * This works by masking out the bit and shifting it to
-		 * bit position 1 so the result has the value 0 or 2.
-		 */
-		hdrlen += (fc & IEEE80211_STYPE_QOS_DATA)
-				>> (ilog2(IEEE80211_STYPE_QOS_DATA)-1);
-		break;
-	case IEEE80211_FTYPE_CTL:
-		/*
-		 * ACK and CTS are 10 bytes, all others 16. To see how
-		 * to get this condition consider
-		 *   subtype mask:   0b0000000011110000 (0x00F0)
-		 *   ACK subtype:    0b0000000011010000 (0x00D0)
-		 *   CTS subtype:    0b0000000011000000 (0x00C0)
-		 *   bits that matter:         ^^^      (0x00E0)
-		 *   value of those: 0b0000000011000000 (0x00C0)
-		 */
-		if ((fc & 0xE0) == 0xC0)
-			hdrlen = 10;
-		else
-			hdrlen = 16;
-		break;
-	}
-
-	return hdrlen;
-}
-EXPORT_SYMBOL(ieee80211_get_hdrlen);
-
 unsigned int ieee80211_hdrlen(__le16 fc)
 {
 	unsigned int hdrlen = 24;
-- 
1.5.6.1.322.ge904b

