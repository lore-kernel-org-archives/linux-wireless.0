Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:13312 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbYFIT22 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2008 15:28:28 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2230439wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jun 2008 12:28:27 -0700 (PDT)
Subject: [PATCHv2 1/8] mac80211: add helpers for frame control testing
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 09 Jun 2008 12:28:20 -0700
Message-Id: <1213039700.5974.66.camel@brick> (sfid-20080609_212832_758812_31D9F259)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A few general categories:

ieee80211_get_* is meant to take a struct ieee80211_hdr * and returns a
pointer to somewhere in the struct, see get_SA, get_DA, get_qos_ctl.

ieee80211_is_* is meant to test whether the frame control is of a certain
ftype - data, mgmt, ctl, data_qos

ieee80211_has_* tests if particular fctl bits are set like the protected
bit, the morefrags bit, fromds, tods.

When testing for a particular stype applicable only to one ftype, functions
like ieee80211_is_ack have been added.  Note that the ftype is also being
checked in these helpers.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
[v2] Updated the naming and added kernel-doc for each new helper
Turns out iwlwifi has stomped all over this namespace already :-( so it
breaks compilation of that driver currently, for the most part they can
all use the new helpers, I just haven't converted it yet.

 include/linux/ieee80211.h |  215 +++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 197 insertions(+), 18 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 9300f37..04212c6 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -98,6 +98,7 @@
 
 #define IEEE80211_MAX_SSID_LEN		32
 #define IEEE80211_MAX_MESH_ID_LEN	32
+#define IEEE80211_QOS_CTL_LEN		2
 
 struct ieee80211_hdr {
 	__le16 frame_control;
@@ -109,6 +110,178 @@ struct ieee80211_hdr {
 	u8 addr4[6];
 } __attribute__ ((packed));
 
+/**
+ * ieee80211_has_protected - check if IEEE80211_FCTL_PROTECTED is set
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_has_protected(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_PROTECTED)) != 0;
+}
+
+/**
+ * ieee80211_has_morefrags - check if IEEE80211_FCTL_MOREFRAGS is set
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_has_morefrags(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_MOREFRAGS)) != 0;
+}
+
+/**
+ * ieee80211_has_tods - check if IEEE80211_FCTL_TODS is set
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_has_tods(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_TODS)) != 0;
+}
+
+/**
+ * ieee80211_has_fromds - check if IEEE80211_FCTL_FROMDS is set
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_has_fromds(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_FROMDS)) != 0;
+}
+
+/**
+ * ieee80211_has_a4 - check if IEEE80211_FCTL_TODS and IEEE80211_FCTL_FROMDS are set
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_has_a4(__le16 fc)
+{
+	__le16 tmp = cpu_to_le16(IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS);
+	return (fc & tmp) == tmp;
+}
+
+/**
+ * ieee80211_is_mgmt - check if type is IEEE80211_FTYPE_MGMT
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_mgmt(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_FTYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_MGMT);
+}
+
+/**
+ * ieee80211_is_ctl - check if type is IEEE80211_FTYPE_CTL
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_ctl(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_FTYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_CTL);
+}
+
+/**
+ * ieee80211_is_data - check if type is IEEE80211_FTYPE_DATA
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_data(__le16 fc)
+{
+	return (fc & cpu_to_le16(IEEE80211_FCTL_FTYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_DATA);
+}
+
+/**
+ * ieee80211_is_data_qos - check if type is IEEE80211_FTYPE_DATA and IEEE80211_STYPE_QOS_DATA is set
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_data_qos(__le16 fc)
+{
+	/*
+	 * mask with QOS_DATA rather than IEEE80211_FCTL_STYPE as we just need
+	 * to check the one bit
+	 */
+	return (fc &
+	       cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_STYPE_QOS_DATA)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_STYPE_QOS_DATA);
+}
+
+/**
+ * ieee80211_is_nullfunc - check if FTYPE=IEEE80211_FTYPE_DATA and STYPE=IEEE80211_STYPE_NULLFUNC
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_nullfunc(__le16 fc)
+{
+	return (fc &
+	       cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_STYPE_NULLFUNC);
+}
+
+/**
+ * ieee80211_is_ack - check if FTYPE=IEEE80211_FTYPE_CTL and STYPE=IEEE80211_STYPE_ACK
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_ack(__le16 fc)
+{
+	return (fc &
+	       cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_ACK);
+}
+
+/**
+ * ieee80211_is_pspoll - check if FTYPE=IEEE80211_FTYPE_CTL and STYPE=IEEE80211_STYPE_PSPOLL
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_pspoll(__le16 fc)
+{
+	return (fc &
+	       cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_PSPOLL);
+}
+
+/**
+ * ieee80211_is_back_req - check if FTYPE=IEEE80211_FTYPE_CTL and STYPE=IEEE80211_STYPE_BACK_REQ
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_back_req(__le16 fc)
+{
+	return (fc &
+	       cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_BACK_REQ);
+}
+
+/**
+ * ieee80211_is_beacon - check if FTYPE=IEEE80211_FTYPE_MGMT and STYPE=IEEE80211_STYPE_BEACON
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_beacon(__le16 fc)
+{
+	return (fc &
+	       cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE)) ==
+	       cpu_to_le16(IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_BEACON);
+}
+
+/**
+ * ieee80211_set_protected - set the IEEE80211_FCTL_PROTECTED bit
+ * @hdr: the frame
+ */
+static inline void ieee80211_set_protected(struct ieee80211_hdr *hdr)
+{
+	hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PROTECTED);
+}
+
+/**
+ * ieee80211_set_moredata - set the IEEE80211_FCTL_MOREDATA bit
+ * @hdr: the frame
+ */
+static inline void ieee80211_set_moredata(struct ieee80211_hdr *hdr)
+{
+	hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_MOREDATA);
+}
+
+/**
+ * ieee80211_clear_moredata - clear the IEEE80211_FCTL_MOREDATA bit
+ * @hdr: the frame
+ */
+static inline void ieee80211_clear_moredata(struct ieee80211_hdr *hdr)
+{
+	hdr->frame_control &= ~cpu_to_le16(IEEE80211_FCTL_MOREDATA);
+}
 
 struct ieee80211s_hdr {
 	u8 flags;
@@ -552,48 +725,54 @@ enum ieee80211_back_parties {
 #define WLAN_MAX_KEY_LEN		32
 
 /**
+ * ieee80211_get_qos_ctl - get pointer to qos control bytes
+ * @hdr: the frame
+ *
+ * The qos ctrl bytes come after the frame_control, duration, seq_num
+ * and 3 or 4 addresses of length ETH_ALEN.
+ * 3 addr: 2 + 2 + 2 + 3*6 = 24
+ * 4 addr: 2 + 2 + 2 + 4*6 = 30
+ */
+static inline u8 *ieee80211_get_qos_ctl(struct ieee80211_hdr *hdr)
+{
+	if (ieee80211_has_a4(hdr->frame_control))
+		return (u8 *)hdr + 30;
+	else
+		return (u8 *)hdr + 24;
+}
+
+/**
  * ieee80211_get_SA - get pointer to SA
+ * @hdr: the frame
  *
  * Given an 802.11 frame, this function returns the offset
  * to the source address (SA). It does not verify that the
  * header is long enough to contain the address, and the
  * header must be long enough to contain the frame control
  * field.
- *
- * @hdr: the frame
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
  * ieee80211_get_DA - get pointer to DA
+ * @hdr: the frame
  *
  * Given an 802.11 frame, this function returns the offset
  * to the destination address (DA). It does not verify that
  * the header is long enough to contain the address, and the
  * header must be long enough to contain the frame control
  * field.
- *
- * @hdr: the frame
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
-- 
1.5.6.rc2.261.ga8fbe


