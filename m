Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.235]:8008 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbYEPT3T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 15:29:19 -0400
Received: by wr-out-0506.google.com with SMTP id c48so541086wra.1
        for <linux-wireless@vger.kernel.org>; Fri, 16 May 2008 12:29:16 -0700 (PDT)
Subject: [RFC-PATCH] mac80211: add helpers for frame control tests
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain
Date: Fri, 16 May 2008 12:29:14 -0700
Message-Id: <1210966154.5915.50.camel@brick> (sfid-20080516_212924_911455_53DADC35)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avoid always byteswapping the hdr->frame_control value and testing
against that.  Move the byteswapping into the constants and test
directly against the __le16 value.

One function in wpa.c moved to use some of the helpers as an example
of what this transition will look like eliminating the local var fc.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
More helpers could (should) be added to this, I just wanted to get some
feedback regarding the approach before going through the drivers and
mac80211 code.

drivers/net/wireless/iwl/iwl-helpers.h has a lot of similar helpers, but
takes the already byteswapped fc value rather than a struct ieee80211_hdr
as they do the byteswapping before testing.  There are lots of places this
could be avoided with a set of helpers like this.

 include/linux/ieee80211.h |   41 +++++++++++++++++++++++++++++++++++++++++
 net/mac80211/wpa.c        |   18 +++++++-----------
 2 files changed, 48 insertions(+), 11 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 0b5e03e..2382cd0 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -81,6 +81,47 @@
 #define IEEE80211_STYPE_QOS_CFPOLL		0x00E0
 #define IEEE80211_STYPE_QOS_CFACKPOLL		0x00F0
 
+static inline int ieee80211_fctl_tods(struct ieee80211_hdr *hdr)
+{
+	return hdr->frame_control & cpu_to_le16(IEEE80211_FCTL_TODS);
+}
+
+static inline int ieee80211_fctl_fromds(struct ieee80211_hdr *hdr)
+{
+	return hdr->frame_control & cpu_to_le16(IEEE80211_FCTL_FROMDS);
+}
+
+static inline int ieee80211_fctl_has_a4(struct ieee80211_hdr *hdr)
+{
+	__le16 tmp = cpu_to_le16(IEEE80211_FCTL_TODS | IEEE80211_FCTL_TODS);
+	return (hdr->frame_control & tmp) == tmp;
+}
+
+static inline int ieee80211_ftype(struct ieee80211_hdr *hdr, u16 ftype)
+{
+	return (hdr->frame_control & cpu_to_le16(IEEE80211_FCTL_FTYPE)) ==
+	       cpu_to_le16(ftype);
+}
+
+static inline int ieee80211_stype(struct ieee80211_hdr *hdr, u16 stype)
+{
+	return (hdr->frame_control & cpu_to_le16(stype)) != 0;
+}
+
+static inline int ieee80211_ftype_mgmt(struct ieee80211_hdr *hdr)
+{
+	return ieee80211_ftype(hdr, IEEE80211_FTYPE_MGMT);
+}
+
+static inline int ieee80211_ftype_ctl(struct ieee80211_hdr *hdr)
+{
+	return ieee80211_ftype(hdr, IEEE80211_FTYPE_CTL);
+}
+
+static inline int ieee80211_ftype_data(struct ieee80211_hdr *hdr)
+{
+	return ieee80211_ftype(hdr, IEEE80211_FTYPE_DATA);
+}
 
 /* miscellaneous IEEE 802.11 constants */
 #define IEEE80211_MAX_FRAG_THRESHOLD	2352
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 45709ad..c37cc76 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -24,23 +24,21 @@ static int ieee80211_get_hdr_info(const struct sk_buff *skb, u8 **sa, u8 **da,
 {
 	struct ieee80211_hdr *hdr;
 	size_t hdrlen;
-	u16 fc;
 	int a4_included;
 	u8 *pos;
 
 	hdr = (struct ieee80211_hdr *) skb->data;
-	fc = le16_to_cpu(hdr->frame_control);
 
 	hdrlen = 24;
-	if ((fc & (IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS)) ==
-	    (IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS)) {
+	if (ieee80211_fctl_has_a4(hdr)) {
 		hdrlen += ETH_ALEN;
+		a4_included = 1;
 		*sa = hdr->addr4;
 		*da = hdr->addr3;
-	} else if (fc & IEEE80211_FCTL_FROMDS) {
+	} else if (ieee80211_fctl_fromds(hdr)) {
 		*sa = hdr->addr3;
 		*da = hdr->addr1;
-	} else if (fc & IEEE80211_FCTL_TODS) {
+	} else if (ieee80211_fctl_tods(hdr)) {
 		*sa = hdr->addr2;
 		*da = hdr->addr3;
 	} else {
@@ -48,16 +46,14 @@ static int ieee80211_get_hdr_info(const struct sk_buff *skb, u8 **sa, u8 **da,
 		*da = hdr->addr1;
 	}
 
-	if (fc & 0x80)
+	if (ieee80211_stype(hdr, IEEE_STYPE_QOS_DATA))
 		hdrlen += 2;
 
 	*data = skb->data + hdrlen;
 	*data_len = skb->len - hdrlen;
 
-	a4_included = (fc & (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) ==
-		(IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS);
-	if ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA &&
-	    fc & IEEE80211_STYPE_QOS_DATA) {
+	if (ieee80211_ftype_data(hdr) &&
+	    ieee80211_stype(hdr, IEEE_STYPE_QOS_DATA)) {
 		pos = (u8 *) &hdr->addr4;
 		if (a4_included)
 			pos += 6;
-- 
1.5.5.1.570.g26b5e



