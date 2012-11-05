Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37285 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932437Ab2KEOkK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 09:40:10 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] wireless: add utility function to get P2P attribute
Date: Mon,  5 Nov 2012 15:40:44 +0100
Message-Id: <1352126445-25088-2-git-send-email-johannes@sipsolutions.net> (sfid-20121105_154023_337411_E2CE4A41)
In-Reply-To: <1352126445-25088-1-git-send-email-johannes@sipsolutions.net>
References: <1352126445-25088-1-git-send-email-johannes@sipsolutions.net>
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
 include/net/cfg80211.h | 19 ++++++++++
 net/wireless/util.c    | 99 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 118 insertions(+)

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
index cf11239..2964223 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -980,6 +980,105 @@ u32 cfg80211_calculate_bitrate(struct rate_info *rate)
 }
 EXPORT_SYMBOL(cfg80211_calculate_bitrate);
 
+unsigned int cfg80211_get_p2p_attr(const u8 *ies, unsigned int len,
+				   u8 attr, u8 *buf, unsigned int bufsize)
+{
+	u8 *out = buf;
+	u16 attr_remaining = 0;
+	bool desired_attr = false;
+	u16 desired_len = 0;
+
+	while (len > 0) {
+		unsigned int iedatalen;
+		unsigned int copy;
+		const u8 *iedata;
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
+		/* check attribute continuation into this IE */
+		copy = min_t(unsigned int, attr_remaining, iedatalen);
+		if (copy && desired_attr) {
+			desired_len += copy;
+			if (out) {
+				memcpy(out, iedata, min(bufsize, copy));
+				out += min(bufsize, copy);
+				bufsize -= min(bufsize, copy);
+			}
+
+
+			if (copy == attr_remaining)
+				return desired_len;
+		}
+
+		attr_remaining -= copy;
+		if (attr_remaining)
+			goto cont;
+
+		iedatalen -= copy;
+		iedata += copy;
+
+		while (iedatalen > 0) {
+			u16 attr_len;
+
+			/* P2P attribute ID & size must fit */
+			if (iedatalen < 3)
+				return -EILSEQ;
+			desired_attr = iedata[0] == attr;
+			attr_len = get_unaligned_le16(iedata + 1);
+			iedatalen -= 3;
+			iedata += 3;
+
+			copy = min_t(unsigned int, attr_len, iedatalen);
+
+			if (desired_attr) {
+				desired_len += copy;
+				if (out) {
+					memcpy(out, iedata, min(bufsize, copy));
+					out += min(bufsize, copy);
+					bufsize -= min(bufsize, copy);
+				}
+
+				if (copy == attr_len)
+					return desired_len;
+			}
+
+			iedata += copy;
+			iedatalen -= copy;
+			attr_remaining = attr_len - copy;
+		}
+
+ cont:
+		len -= ies[1] + 2;
+		ies += ies[1] + 2;
+	}
+
+	if (attr_remaining && desired_attr)
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
1.8.0

