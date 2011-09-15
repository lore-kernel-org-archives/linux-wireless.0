Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57310 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab1IOIxH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 04:53:07 -0400
Received: by wwf22 with SMTP id 22so3387842wwf.1
        for <linux-wireless@vger.kernel.org>; Thu, 15 Sep 2011 01:53:06 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] cfg80211: add cfg80211_find_vendor_ie() function
Date: Thu, 15 Sep 2011 11:53:01 +0300
Message-Id: <1316076781-12580-1-git-send-email-eliad@wizery.com> (sfid-20110915_105311_823260_91B00974)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add function to find vendor-specific ie (along with
vendor-specific ie struct definition and P2P OUI values)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 include/linux/ieee80211.h |   10 ++++++++++
 include/net/cfg80211.h    |   18 ++++++++++++++++++
 net/wireless/scan.c       |   27 +++++++++++++++++++++++++++
 3 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 37f95f2..3185650 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -775,6 +775,13 @@ struct ieee80211_mmie {
 	u8 mic[8];
 } __attribute__ ((packed));
 
+struct ieee80211_vendor_ie {
+	u8 element_id;
+	u8 len;
+	u8 oui[3];
+	u8 oui_type;
+} __packed;
+
 /* Control frames */
 struct ieee80211_rts {
 	__le16 frame_control;
@@ -1468,6 +1475,9 @@ enum ieee80211_sa_query_action {
 
 #define WLAN_PMKID_LEN			16
 
+#define WLAN_OUI_WFA			0x506f9a
+#define WLAN_OUI_TYPE_WFA_P2P		9
+
 /*
  * WMM/802.11e Tspec Element
  */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index a535b39..540a99e 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2456,6 +2456,24 @@ unsigned int cfg80211_classify8021d(struct sk_buff *skb);
 const u8 *cfg80211_find_ie(u8 eid, const u8 *ies, int len);
 
 /**
+ * cfg80211_find_vendor_ie - find vendor specific information element in data
+ *
+ * @oui: vendor OUI
+ * @oui_type: vendor-specific OUI type
+ * @ies: data consisting of IEs
+ * @len: length of data
+ *
+ * This function will return %NULL if the vendor specific element ID
+ * could not be found or if the element is invalid (claims to be
+ * longer than the given data), or a pointer to the first byte
+ * of the requested element, that is the byte containing the
+ * element ID. There are no checks on the element length
+ * other than having to fit into the given data.
+ */
+const u8 *cfg80211_find_vendor_ie(unsigned int oui, u8 oui_type,
+				  const u8 *ies, int len);
+
+/**
  * DOC: Regulatory enforcement infrastructure
  *
  * TODO
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index b0f0039..0fb1424 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -228,6 +228,33 @@ const u8 *cfg80211_find_ie(u8 eid, const u8 *ies, int len)
 }
 EXPORT_SYMBOL(cfg80211_find_ie);
 
+const u8 *cfg80211_find_vendor_ie(unsigned int oui, u8 oui_type,
+				  const u8 *ies, int len)
+{
+	struct ieee80211_vendor_ie *ie;
+	const u8 *pos = ies, *end = ies + len;
+	int ie_oui;
+
+	while (pos < end) {
+		pos = cfg80211_find_ie(WLAN_EID_VENDOR_SPECIFIC, pos,
+				       end - pos);
+		if (!pos)
+			return NULL;
+
+		if (end - pos < sizeof(*ie))
+			return NULL;
+
+		ie = (struct ieee80211_vendor_ie *)pos;
+		ie_oui = ie->oui[0] << 16 | ie->oui[1] << 8 | ie->oui[2];
+		if (ie_oui == oui && ie->oui_type == oui_type)
+			return pos;
+
+		pos += 2 + ie->len;
+	}
+	return NULL;
+}
+EXPORT_SYMBOL(cfg80211_find_vendor_ie);
+
 static int cmp_ies(u8 num, u8 *ies1, size_t len1, u8 *ies2, size_t len2)
 {
 	const u8 *ie1 = cfg80211_find_ie(num, ies1, len1);
-- 
1.7.6.401.g6a319

