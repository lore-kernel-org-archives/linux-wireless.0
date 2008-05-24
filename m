Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from backup.qzxyz.com ([212.85.24.239]:37892 "EHLO
	scott.intra.qzxyz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753655AbYEXTrA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 May 2008 15:47:00 -0400
Date: Sat, 24 May 2008 20:36:09 +0100
From: Scott Ashcroft <scott.ashcroft@talk21.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, jussi.kivilinna@mbnet.fi
Subject: [PATCH] rndis_wlan: Make connections to TKIP PSK networks work
Message-ID: <20080524193608.GB29429@backup.qzxyz.com> (sfid-20080524_214708_406145_13F83470)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch allows the rndis_wlan driver to connect to TKIP PSK networks.
It uses the ASSOCIATION_INFORMATION RNDIS call to pull back the IEs and sends them back to userspace using wireless events.
Tested on a few wireless networks I have access to.
Based on the similar code in ndiswrapper.

Cheers,
Scott

Signed-off-by: scott.ashcroft@talk21.com
---

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index d0b1fb1..8dd9704 100644
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
@@ -674,6 +695,16 @@ static int get_bssid(struct usbnet *usbdev, u8 bssid[ETH_ALEN])
 	return ret;
 }
 
+static int get_association_info(struct usbnet *usbdev,
+			struct ndis_80211_assoc_info *info, int len)
+{
+	int ret;
+
+	ret = rndis_query_oid(usbdev, OID_802_11_ASSOCIATION_INFORMATION,
+				info, &len);
+
+	return ret;
+}
 
 static int is_associated(struct usbnet *usbdev)
 {
@@ -2182,11 +2213,38 @@ static void rndis_wext_worker(struct work_struct *work)
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
+
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
+		kfree(info);
+
+get_bssid:
+		ret = get_bssid(usbdev, bssid);
 		if (!ret) {
 			evt.data.flags = 0;
 			evt.data.length = 0;
