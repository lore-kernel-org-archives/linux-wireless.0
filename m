Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:25510 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752911AbbLNMRc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 07:17:32 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id tBECFMEK012493
	for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2015 04:17:31 -0800
Received: from sc-exch02.marvell.com ([199.233.58.182])
	by mx0a-0016f401.pphosted.com with ESMTP id 1yswkxr04y-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2015 04:17:31 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	chunfan chen <jeffc@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 14/14] mwifiex: fix WPA connection problem
Date: Mon, 14 Dec 2015 04:15:15 -0800
Message-ID: <1450095315-19927-15-git-send-email-akarwar@marvell.com> (sfid-20151214_131739_057313_102311FA)
In-Reply-To: <1450095315-19927-1-git-send-email-akarwar@marvell.com>
References: <1450095315-19927-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: chunfan chen <jeffc@marvell.com>

Device fails to connect to some AP's configured in WPA
security mode. Currently IE buffer parsing logic in driver
expects WPA IE to be present at the beginning of IE buffer.
Otherwise connection is failed with 'incompatible network
setting' error.

This patch fixes the problem by improving IE buffer parsing
logic.

Signed-off-by: chunfan chen <jeffc@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c | 75 +++++++++++++++++-------
 1 file changed, 53 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
index 62b35a3..439e73f 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
@@ -1293,6 +1293,8 @@ mwifiex_set_gen_ie_helper(struct mwifiex_private *priv, u8 *ie_data_ptr,
 	struct ieee_types_vendor_header *pvendor_ie;
 	const u8 wpa_oui[] = { 0x00, 0x50, 0xf2, 0x01 };
 	const u8 wps_oui[] = { 0x00, 0x50, 0xf2, 0x04 };
+	u16 unparsed_len = ie_len;
+	int find_wpa_ie = 0;
 
 	/* If the passed length is zero, reset the buffer */
 	if (!ie_len) {
@@ -1304,40 +1306,69 @@ mwifiex_set_gen_ie_helper(struct mwifiex_private *priv, u8 *ie_data_ptr,
 		return -1;
 	}
 	pvendor_ie = (struct ieee_types_vendor_header *) ie_data_ptr;
-	/* Test to see if it is a WPA IE, if not, then it is a gen IE */
-	if (((pvendor_ie->element_id == WLAN_EID_VENDOR_SPECIFIC) &&
-	     (!memcmp(pvendor_ie->oui, wpa_oui, sizeof(wpa_oui)))) ||
-	    (pvendor_ie->element_id == WLAN_EID_RSN)) {
 
-		/* IE is a WPA/WPA2 IE so call set_wpa function */
-		ret = mwifiex_set_wpa_ie_helper(priv, ie_data_ptr, ie_len);
-		priv->wps.session_enable = false;
+	while (pvendor_ie) {
+		if (pvendor_ie->element_id == WLAN_EID_VENDOR_SPECIFIC) {
+			/* Test to see if it is a WPA IE, if not, then it is a
+			 * gen IE
+			 */
+			if (!memcmp(pvendor_ie->oui, wpa_oui,
+				    sizeof(wpa_oui))) {
+				find_wpa_ie = 1;
+				break;
+			}
 
-		return ret;
-	} else if (pvendor_ie->element_id == WLAN_EID_BSS_AC_ACCESS_DELAY) {
+			/* Test to see if it is a WPS IE, if so, enable
+			 * wps session flag
+			 */
+			if (!memcmp(pvendor_ie->oui, wps_oui,
+				    sizeof(wps_oui))) {
+				priv->wps.session_enable = true;
+				mwifiex_dbg(priv->adapter, MSG,
+					    "info: WPS Session Enabled.\n");
+				ret = mwifiex_set_wps_ie(priv,
+							 (u8 *)pvendor_ie,
+							 unparsed_len);
+			}
+		}
+
+		if (pvendor_ie->element_id == WLAN_EID_RSN) {
+			find_wpa_ie = 1;
+			break;
+		}
+
+		if (pvendor_ie->element_id == WLAN_EID_BSS_AC_ACCESS_DELAY) {
 		/* IE is a WAPI IE so call set_wapi function */
-		ret = mwifiex_set_wapi_ie(priv, ie_data_ptr, ie_len);
+			ret = mwifiex_set_wapi_ie(priv, (u8 *)pvendor_ie,
+						  unparsed_len);
+			return ret;
+		}
+
+		unparsed_len -= (pvendor_ie->len +
+				 sizeof(struct ieee_types_header));
+
+		if (unparsed_len <= sizeof(struct ieee_types_header))
+			pvendor_ie = NULL;
+		else
+			pvendor_ie = (struct ieee_types_vendor_header *)
+				(((u8 *)pvendor_ie) + pvendor_ie->len +
+				 sizeof(struct ieee_types_header));
+	}
 
+	if (find_wpa_ie) {
+		/* IE is a WPA/WPA2 IE so call set_wpa function */
+		ret = mwifiex_set_wpa_ie_helper(priv, (u8 *)pvendor_ie,
+						unparsed_len);
+		priv->wps.session_enable = false;
 		return ret;
 	}
+
 	/*
 	 * Verify that the passed length is not larger than the
 	 * available space remaining in the buffer
 	 */
 	if (ie_len < (sizeof(priv->gen_ie_buf) - priv->gen_ie_buf_len)) {
 
-		/* Test to see if it is a WPS IE, if so, enable
-		 * wps session flag
-		 */
-		pvendor_ie = (struct ieee_types_vendor_header *) ie_data_ptr;
-		if ((pvendor_ie->element_id == WLAN_EID_VENDOR_SPECIFIC) &&
-		    (!memcmp(pvendor_ie->oui, wps_oui, sizeof(wps_oui)))) {
-			priv->wps.session_enable = true;
-			mwifiex_dbg(priv->adapter, INFO,
-				    "info: WPS Session Enabled.\n");
-			ret = mwifiex_set_wps_ie(priv, ie_data_ptr, ie_len);
-		}
-
 		/* Append the passed data to the end of the
 		   genIeBuffer */
 		memcpy(priv->gen_ie_buf + priv->gen_ie_buf_len, ie_data_ptr,
-- 
1.8.1.4

