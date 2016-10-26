Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:28863 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934200AbcJZVoW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 17:44:22 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH v2 4/9] cfg80211: Define IEEE P802.11ai (FILS) information elements
Date: Thu, 27 Oct 2016 00:42:01 +0300
Message-ID: <1477518126-823-5-git-send-email-jouni@qca.qualcomm.com> (sfid-20161026_234429_059558_2F0E1935)
In-Reply-To: <1477518126-823-1-git-send-email-jouni@qca.qualcomm.com>
References: <1477518126-823-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Define the Element IDs and Element ID Extensions from IEEE
P802.11ai/D11.0. In addition, add a new cfg80211_find_ext_ie() wrapper
to make it easier to find information elements that used the Element ID
Extension field.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 include/linux/ieee80211.h | 20 ++++++++++++++++++++
 include/net/cfg80211.h    | 21 +++++++++++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index a80516f..d428adf 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1960,6 +1960,26 @@ enum ieee80211_eid {
 
 	WLAN_EID_VENDOR_SPECIFIC = 221,
 	WLAN_EID_QOS_PARAMETER = 222,
+	WLAN_EID_CAG_NUMBER = 237,
+	WLAN_EID_AP_CSN = 239,
+	WLAN_EID_FILS_INDICATION = 240,
+	WLAN_EID_DILS = 241,
+	WLAN_EID_FRAGMENT = 242,
+	WLAN_EID_EXTENSION = 255
+};
+
+/* Element ID Extensions for Element ID 255 */
+enum ieee80211_eid_ext {
+	WLAN_EID_EXT_ASSOC_DELAY_INFO = 1,
+	WLAN_EID_EXT_FILS_REQ_PARAMS = 2,
+	WLAN_EID_EXT_FILS_KEY_CONFIRM = 3,
+	WLAN_EID_EXT_FILS_SESSION = 4,
+	WLAN_EID_EXT_FILS_HLP_CONTAINER = 5,
+	WLAN_EID_EXT_FILS_IP_ADDR_ASSIGN = 6,
+	WLAN_EID_EXT_KEY_DELIVERY = 7,
+	WLAN_EID_EXT_FILS_WRAPPED_DATA = 8,
+	WLAN_EID_EXT_FILS_PUBLIC_KEY = 12,
+	WLAN_EID_EXT_FILS_NONCE = 13,
 };
 
 /* Action category code */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 843ab8a..e1bc478 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4179,6 +4179,27 @@ static inline const u8 *cfg80211_find_ie(u8 eid, const u8 *ies, int len)
 }
 
 /**
+ * cfg80211_find_ext_ie - find information element with EID Extension in data
+ *
+ * @eid: element ID Extension
+ * @ies: data consisting of IEs
+ * @len: length of data
+ *
+ * Return: %NULL if the extended element ID could not be found or if
+ * the element is invalid (claims to be longer than the given
+ * data), or a pointer to the first byte of the requested
+ * element, that is the byte containing the element ID.
+ *
+ * Note: There are no checks on the element length other than
+ * having to fit into the given data.
+ */
+static inline const u8 *cfg80211_find_ext_ie(u8 ext_eid, const u8 *ies, int len)
+{
+	return cfg80211_find_ie_match(WLAN_EID_EXTENSION, ies, len,
+				      &ext_eid, 1, 2);
+}
+
+/**
  * cfg80211_find_vendor_ie - find vendor specific information element in data
  *
  * @oui: vendor OUI
-- 
1.9.1
