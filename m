Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:27436 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266AbYFECdW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 22:33:22 -0400
Received: by wf-out-1314.google.com with SMTP id 27so324454wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jun 2008 19:33:22 -0700 (PDT)
Subject: [RFC-PATCH] mac80211: add helpers for common frame_control testing
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 19:33:19 -0700
Message-Id: <1212633200.6340.52.camel@brick> (sfid-20080605_043326_207604_3A2A97D6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Example users added in wpa.c.

The byteshifting is done on the constants at compile-time making
each one of these helpers a mask+test only.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/linux/ieee80211.h |   63 +++++++++++++++++++++++++++++++++++----------
 net/mac80211/wpa.c        |   40 ++++++----------------------
 2 files changed, 58 insertions(+), 45 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 9300f37..5880b9f 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -109,6 +109,50 @@ struct ieee80211_hdr {
 	u8 addr4[6];
 } __attribute__ ((packed));
 
+static inline int ieee80211_has_tods(struct ieee80211_hdr *hdr)
+{
+	return (hdr->frame_control & cpu_to_le16(IEEE80211_FCTL_TODS)) != 0;
+}
+
+static inline int ieee80211_has_fromds(struct ieee80211_hdr *hdr)
+{
+	return (hdr->frame_control & cpu_to_le16(IEEE80211_FCTL_FROMDS)) != 0;
+}
+
+static inline int ieee80211_has_a4(struct ieee80211_hdr *hdr)
+{
+	__le16 tmp = cpu_to_le16(IEEE80211_FCTL_TODS | IEEE80211_FCTL_TODS);
+	return (hdr->frame_control & tmp) == tmp;
+}
+
+static inline int ieee80211_is_mgmt(struct ieee80211_hdr *hdr)
+{
+	return (hdr->frame_control & cpu_to_le16(IEEE80211_FCTL_FTYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_MGMT);
+}
+
+static inline int ieee80211_is_ctl(struct ieee80211_hdr *hdr)
+{
+	return (hdr->frame_control & cpu_to_le16(IEEE80211_FCTL_FTYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_CTL);
+}
+
+static inline int ieee80211_is_data(struct ieee80211_hdr *hdr)
+{
+	return (hdr->frame_control & cpu_to_le16(IEEE80211_FCTL_FTYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_DATA);
+}
+
+static inline int ieee80211_data_has_qos(struct ieee80211_hdr *hdr)
+{
+	/*
+	 * mask with QOS_DATA rather than IEEE80211_FCTL_STYPE as we just need
+	 * to check the one bit
+	 */
+	return (hdr->frame_control &
+	       cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_STYPE_QOS_DATA)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_STYPE_QOS_DATA);
+}
 
 struct ieee80211s_hdr {
 	u8 flags;
@@ -564,17 +608,11 @@ enum ieee80211_back_parties {
  */
 static inline u8 *ieee80211_get_SA(struct ieee80211_hdr *hdr)
 {
-	__le16 fc = hdr->frame_control;
-	fc &= cpu_to_le16(IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS);
-
-	switch (fc) {
-	case __constant_cpu_to_le16(IEEE80211_FCTL_FROMDS):
-		return hdr->addr3;
-	case __constant_cpu_to_le16(IEEE80211_FCTL_TODS|IEEE80211_FCTL_FROMDS):
+	if (ieee80211_has_a4(hdr))
 		return hdr->addr4;
-	default:
-		return hdr->addr2;
-	}
+	if (ieee80211_has_fromds(hdr))
+		return hdr->addr3;
+	return hdr->addr2;
 }
 
 /**
@@ -590,10 +628,7 @@ static inline u8 *ieee80211_get_SA(struct ieee80211_hdr *hdr)
  */
 static inline u8 *ieee80211_get_DA(struct ieee80211_hdr *hdr)
 {
-	__le16 fc = hdr->frame_control;
-	fc &= cpu_to_le16(IEEE80211_FCTL_TODS);
-
-	if (fc)
+	if (ieee80211_has_tods(hdr))
 		return hdr->addr3;
 	else
 		return hdr->addr1;
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 9f6fd20..0c728e0 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -24,48 +24,26 @@ static int ieee80211_get_hdr_info(const struct sk_buff *skb, u8 **sa, u8 **da,
 {
 	struct ieee80211_hdr *hdr;
 	size_t hdrlen;
-	u16 fc;
-	int a4_included;
-	u8 *pos;
 
 	hdr = (struct ieee80211_hdr *) skb->data;
-	fc = le16_to_cpu(hdr->frame_control);
 
 	hdrlen = 24;
-	if ((fc & (IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS)) ==
-	    (IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS)) {
+	if (ieee80211_has_a4(hdr))
 		hdrlen += ETH_ALEN;
-		*sa = hdr->addr4;
-		*da = hdr->addr3;
-	} else if (fc & IEEE80211_FCTL_FROMDS) {
-		*sa = hdr->addr3;
-		*da = hdr->addr1;
-	} else if (fc & IEEE80211_FCTL_TODS) {
-		*sa = hdr->addr2;
-		*da = hdr->addr3;
-	} else {
-		*sa = hdr->addr2;
-		*da = hdr->addr1;
-	}
 
-	if (fc & 0x80)
+	*sa = ieee80211_get_SA(hdr);
+	*da = ieee80211_get_DA(hdr);
+
+	if (ieee80211_data_has_qos(hdr)) {
 		hdrlen += 2;
+		*qos_tid = (*((u8 *)hdr + hdrlen - 2) & 0x0f) | 0x80;
+	} else {
+		*qos_tid = 0;
+	}
 
 	*data = skb->data + hdrlen;
 	*data_len = skb->len - hdrlen;
 
-	a4_included = (fc & (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) ==
-		(IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS);
-	if ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA &&
-	    fc & IEEE80211_STYPE_QOS_DATA) {
-		pos = (u8 *) &hdr->addr4;
-		if (a4_included)
-			pos += 6;
-		*qos_tid = pos[0] & 0x0f;
-		*qos_tid |= 0x80; /* qos_included flag */
-	} else
-		*qos_tid = 0;
-
 	return skb->len < hdrlen ? -1 : 0;
 }
 
-- 
1.5.6.rc1.257.gba91d



