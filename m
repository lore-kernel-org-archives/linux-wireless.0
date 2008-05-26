Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.dnainternet.fi ([87.94.96.112]:52825 "EHLO
	smtp2.dnainternet.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbYEZVGR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2008 17:06:17 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH] rndis_wlan: Make connections to TKIP PSK networks work
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Scott Ashcroft <scott.ashcroft@talk21.com>
Date: Tue, 27 May 2008 00:06:15 +0300
Message-ID: <20080526210615.18840.58055.stgit@fate.lan> (sfid-20080526_230638_424148_516994A1)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Scott Ashcroft <scott.ashcroft@talk21.com>

This patch allows the rndis_wlan driver to connect to TKIP PSK networks.
It uses the ASSOCIATION_INFORMATION RNDIS call to pull back the IEs and sends them back to userspace using wireless events. Tested on a few wireless networks I have access to. Based on the similar code in ndiswrapper.

Cheers,
Scott

Signed-off-by: Scott Ashcroft <scott.ashcroft@talk21.com>
[edit: cleanups]
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/rndis_wlan.c |   60 ++++++++++++++++++++++++++++++++++++-
 1 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index d0b1fb1..ac56f8d 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -116,6 +116,7 @@ MODULE_PARM_DESC(workaround_interval,
 #define OID_802_11_ENCRYPTION_STATUS		ccpu2(0x0d01011b)
 #define OID_802_11_ADD_KEY			ccpu2(0x0d01011d)
 #define OID_802_11_REMOVE_KEY			ccpu2(0x0d01011e)
+#define OID_802_11_ASSOCIATION_INFORMATION	ccpu2(0x0d01011f)
 #define OID_802_11_PMKID			ccpu2(0x0d010123)
 #define OID_802_11_NETWORK_TYPES_SUPPORTED	ccpu2(0x0d010203)
 #define OID_802_11_NETWORK_TYPE_IN_USE		ccpu2(0x0d010204)
@@ -271,6 +272,26 @@ struct ndis_config_param {
 	__le32 value_length;
 } __attribute__((packed));
 
+struct ndis_80211_assoc_info {
+	__le32 length;
+	__le16 req_ies;
+	struct req_ie {
+		__le16 capa;
+		__le16 listen_interval;
+		u8 cur_ap_address[6];
+	} req_ie;
+	__le32 req_ie_length;
+	__le32 offset_req_ies;
+	__le16 resp_ies;
+	struct resp_ie {
+		__le16 capa;
+		__le16 status_code;
+		__le16 assoc_id;
+	} resp_ie;
+	__le32 resp_ie_length;
+	__le32 offset_resp_ies;
+} __attribute__((packed));
+
 /* these have to match what is in wpa_supplicant */
 enum wpa_alg { WPA_ALG_NONE, WPA_ALG_WEP, WPA_ALG_TKIP, WPA_ALG_CCMP };
 enum wpa_cipher { CIPHER_NONE, CIPHER_WEP40, CIPHER_TKIP, CIPHER_CCMP,
@@ -674,6 +695,12 @@ static int get_bssid(struct usbnet *usbdev, u8 bssid[ETH_ALEN])
 	return ret;
 }
 
+static int get_association_info(struct usbnet *usbdev,
+			struct ndis_80211_assoc_info *info, int len)
+{
+	return rndis_query_oid(usbdev, OID_802_11_ASSOCIATION_INFORMATION,
+				info, &len);
+}
 
 static int is_associated(struct usbnet *usbdev)
 {
@@ -2182,11 +2209,40 @@ static void rndis_wext_worker(struct work_struct *work)
 	struct usbnet *usbdev = priv->usbdev;
 	union iwreq_data evt;
 	unsigned char bssid[ETH_ALEN];
-	int ret;
+	struct ndis_80211_assoc_info *info;
+	int assoc_size = sizeof(*info) + IW_CUSTOM_MAX + 32;
+	int ret, offset;
 
 	if (test_and_clear_bit(WORK_CONNECTION_EVENT, &priv->work_pending)) {
-		ret = get_bssid(usbdev, bssid);
+		info = kzalloc(assoc_size, GFP_KERNEL);
+		if (!info)
+			goto get_bssid;
 
+		/* Get association info IEs from device and send them back to
+		 * userspace. */
+		ret = get_association_info(usbdev, info, assoc_size);
+		if (!ret) {
+			evt.data.length = le32_to_cpu(info->req_ie_length);
+			if (evt.data.length > 0) {
+				offset = le32_to_cpu(info->offset_req_ies);
+				wireless_send_event(usbdev->net,
+					IWEVASSOCREQIE, &evt,
+					(char *)info + offset);
+			}
+
+			evt.data.length = le32_to_cpu(info->resp_ie_length);
+			if (evt.data.length > 0) {
+				offset = le32_to_cpu(info->offset_resp_ies);
+				wireless_send_event(usbdev->net,
+					IWEVASSOCRESPIE, &evt,
+					(char *)info + offset);
+			}
+		}
+
+		kfree(info);
+
+get_bssid:
+		ret = get_bssid(usbdev, bssid);
 		if (!ret) {
 			evt.data.flags = 0;
 			evt.data.length = 0;

