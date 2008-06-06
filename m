Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:6888 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbYFFR7o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2008 13:59:44 -0400
Received: by py-out-1112.google.com with SMTP id p76so875712pyb.10
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jun 2008 10:59:41 -0700 (PDT)
Subject: [PATCH 1/7] mac80211: add helpers for frame control testing
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 06 Jun 2008 10:51:11 -0700
Message-Id: <1212774671.6340.75.camel@brick> (sfid-20080606_195948_179851_58022944)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A few general categories:

ieee80211_get_* is meant to take a struct ieee80211_hdr * and returns a
pointer to somewhere in the struct, see get_SA, get_DA, get_qos_ctl.

ieee80211_is_* is meant to test whether the frame control is of a certain
ftype - data, mgmt, or ctl

ieee80211_has_* tests if particular fctl bits are set like the protected
bit, the morefrags bit, fromds, tods.

When testing for a particular stype, applicable only to one ftype, functions
like ieee80211_{ftype}_{has|is}_foo can be added, currently only
ieee80211_data_has_qos() has been added.

The _is variant will suggest an exact stype is being tested for, the _has
variant will suggest testing for particular bits being set.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/linux/ieee80211.h |   83 ++++++++++++++++++++++++++++++++++++---------
 1 files changed, 67 insertions(+), 16 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 9300f37..5773c62 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -98,6 +98,7 @@
 
 #define IEEE80211_MAX_SSID_LEN		32
 #define IEEE80211_MAX_MESH_ID_LEN	32
+#define IEEE80211_QOS_CTL_LEN		2
 
 struct ieee80211_hdr {
 	__le16 frame_control;
@@ -109,6 +110,66 @@ struct ieee80211_hdr {
 	u8 addr4[6];
 } __attribute__ ((packed));
 
+static inline u8 *ieee80211_get_qos_ctl(struct ieee80211_hdr *hdr,
+					unsigned int hdrlen)
+{
+	return (u8 *)hdr + hdrlen - IEEE80211_QOS_CTL_LEN;
+}
+
+static inline int ieee80211_has_protected(__le16 fc)
+{
+	return !!(fc & cpu_to_le16(IEEE80211_FCTL_PROTECTED));
+}
+
+static inline int ieee80211_has_morefrags(__le16 fc)
+{
+	return !!(fc & cpu_to_le16(IEEE80211_FCTL_MOREFRAGS));
+}
+
+static inline int ieee80211_has_tods(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_TODS)) != 0;
+}
+
+static inline int ieee80211_has_fromds(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_FROMDS)) != 0;
+}
+
+static inline int ieee80211_has_a4(__le16 fc)
+{
+	__le16 tmp = cpu_to_le16(IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS);
+	return (fc & tmp) == tmp;
+}
+
+static inline int ieee80211_is_mgmt(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_FTYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_MGMT);
+}
+
+static inline int ieee80211_is_ctl(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_FTYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_CTL);
+}
+
+static inline int ieee80211_is_data(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_FTYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_DATA);
+}
+
+static inline int ieee80211_data_has_qos(__le16 fc)
+{
+	/*
+	 * mask with QOS_DATA rather than IEEE80211_FCTL_STYPE as we just need
+	 * to check the one bit
+	 */
+	return (fc &
+	       cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_STYPE_QOS_DATA)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_STYPE_QOS_DATA);
+}
 
 struct ieee80211s_hdr {
 	u8 flags;
@@ -564,17 +625,11 @@ enum ieee80211_back_parties {
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
+	if (ieee80211_has_a4(hdr->frame_control))
 		return hdr->addr4;
-	default:
-		return hdr->addr2;
-	}
+	if (ieee80211_has_fromds(hdr->frame_control))
+		return hdr->addr3;
+	return hdr->addr2;
 }
 
 /**
@@ -590,10 +645,7 @@ static inline u8 *ieee80211_get_SA(struct ieee80211_hdr *hdr)
  */
 static inline u8 *ieee80211_get_DA(struct ieee80211_hdr *hdr)
 {
-	__le16 fc = hdr->frame_control;
-	fc &= cpu_to_le16(IEEE80211_FCTL_TODS);
-
-	if (fc)
+	if (ieee80211_has_tods(hdr->frame_control))
 		return hdr->addr3;
 	else
 		return hdr->addr1;
@@ -609,8 +661,7 @@ static inline u8 *ieee80211_get_DA(struct ieee80211_hdr *hdr)
  */
 static inline int ieee80211_get_morefrag(struct ieee80211_hdr *hdr)
 {
-	__le16 fc = hdr->frame_control;
-	return !!(fc & cpu_to_le16(IEEE80211_FCTL_MOREFRAGS));
+	return ieee80211_has_morefrags(hdr->frame_control);
 }
 
 #endif /* IEEE80211_H */
-- 
1.5.6.rc1.257.gba91d


