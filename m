Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41736 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779Ab2J3Lxf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2012 07:53:35 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v2] wireless: add utility function to get P2P attribute
Date: Tue, 30 Oct 2012 12:54:07 +0100
Message-Id: <1351598047-20957-1-git-send-email-johannes@sipsolutions.net> (sfid-20121030_125338_711307_23F87F9A)
In-Reply-To: <1351536651-3176-1-git-send-email-johannes@sipsolutions.net>
References: <1351536651-3176-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Parsing the P2P attributes can be tricky as their
contents can be split across multiple (vendor) IEs.
Thus, it's not possible to parse them like IEs (by
returning a pointer to the data.) Instead, provide
a function that copies the attribute data into a
caller-provided buffer and returns the size needed
(useful in case the buffer was too small.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h |   19 ++++++++++
 net/wireless/util.c    |   95 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 114 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 83a2c82..ae6d5e5 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3623,6 +3623,25 @@ u32 cfg80211_calculate_bitrate(struct rate_info *rate);
  */
 void cfg80211_unregister_wdev(struct wireless_dev *wdev);
 
+/**
+ * cfg80211_get_p2p_attr - find and copy a P2P attribute from IE buffer
+ * @ies: the input IE buffer
+ * @len: the input length
+ * @attr: the attribute ID to find
+ * @buf: output buffer, can be %NULL if the data isn't needed, e.g.
+ *	if the function is only called to get the needed buffer size
+ * @bufsize: size of the output buffer
+ *
+ * The function finds a given P2P attribute in the (vendor) IEs and
+ * copies its contents to the given buffer.
+ *
+ * The return value is a negative error code (-%EILSEQ or -%ENOENT) if
+ * the data is malformed or the attribute can't be found (respectively),
+ * or the length of the found attribute (which can be zero).
+ */
+unsigned int cfg80211_get_p2p_attr(const u8 *ies, unsigned int len,
+				   u8 attr, u8 *buf, unsigned int bufsize);
+
 /* Logging, debugging and troubleshooting/diagnostic helpers. */
 
 /* wiphy_printk helpers, similar to dev_printk */
diff --git a/net/wireless/util.c b/net/wireless/util.c
index cf11239..12a8d3d 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -980,6 +980,101 @@ u32 cfg80211_calculate_bitrate(struct rate_info *rate)
 }
 EXPORT_SYMBOL(cfg80211_calculate_bitrate);
 
+unsigned int cfg80211_get_p2p_attr(const u8 *ies, unsigned int len,
+				   u8 attr, u8 *buf, unsigned int bufsize)
+{
+	u8 *out = buf;
+	u16 attr_remaining = 0, attr_hdr_remaining = 0;
+	bool desired_attr = false;
+	u16 desired_len = 0;
+
+	while (len > 0) {
+		unsigned int iedatalen;
+		unsigned int copy;
+		const u8 *iedata;
+		u8 attr_hdr[3];
+
+		if (len < 2)
+			return -EILSEQ;
+		iedatalen = ies[1];
+		if (iedatalen + 2 > len)
+			return -EILSEQ;
+
+		if (ies[0] != WLAN_EID_VENDOR_SPECIFIC)
+			goto cont;
+
+		if (iedatalen < 4)
+			goto cont;
+
+		iedata = ies + 2;
+
+		/* check WFA OUI, P2P subtype */
+		if (iedata[0] != 0x50 || iedata[1] != 0x6f ||
+		    iedata[2] != 0x9a || iedata[3] != 0x09)
+			goto cont;
+
+		iedatalen -= 4;
+		iedata += 4;
+
+		while (iedatalen > 0) {
+			if (attr_hdr_remaining) {
+				copy = min_t(unsigned int, iedatalen,
+							   attr_hdr_remaining);
+
+				memcpy(attr_hdr + 3 - attr_hdr_remaining,
+				       iedata, copy);
+				attr_hdr_remaining -= copy;
+				iedata += copy;
+				iedatalen -= copy;
+				if (attr_hdr_remaining)
+					break;
+				desired_attr = attr_hdr[0] == attr;
+				attr_remaining =
+					get_unaligned_le16(attr_hdr + 1);
+			} else if (attr_remaining == 0) {
+				/* next attribute starts */
+				if (iedatalen < 3) {
+					memcpy(attr_hdr, iedata, iedatalen);
+					attr_hdr_remaining = 3 - iedatalen;
+					break;
+				}
+				desired_attr = iedata[0] == attr;
+				attr_remaining = get_unaligned_le16(iedata + 1);
+				iedatalen -= 3;
+				iedata += 3;
+			}
+
+			copy = min_t(unsigned int, attr_remaining, iedatalen);
+
+			if (desired_attr) {
+				desired_len += copy;
+				if (out && copy && bufsize) {
+					memcpy(out, iedata, min(bufsize, copy));
+					out += min(bufsize, copy);
+					bufsize -= min(bufsize, copy);
+				}
+
+				if (copy == attr_remaining)
+					return desired_len;
+			}
+
+			iedata += copy;
+			iedatalen -= copy;
+			attr_remaining -= copy;
+		}
+
+ cont:
+		len -= ies[1] + 2;
+		ies += ies[1] + 2;
+	}
+
+	if (attr_remaining || attr_hdr_remaining)
+		return -EILSEQ;
+
+	return -ENOENT;
+}
+EXPORT_SYMBOL(cfg80211_get_p2p_attr);
+
 bool ieee80211_operating_class_to_band(u8 operating_class,
 				       enum ieee80211_band *band)
 {
-- 
1.7.10.4

