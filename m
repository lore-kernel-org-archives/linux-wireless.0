Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:50053 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752938AbbFCGBd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 02:01:33 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t5360ZIA014252
	for <linux-wireless@vger.kernel.org>; Tue, 2 Jun 2015 23:01:33 -0700
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0a-0016f401.pphosted.com with ESMTP id 1usq1cgmb4-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 02 Jun 2015 23:01:33 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <huxm@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCHv5 12/17] mwifiex: support downloading IEs from tail
Date: Wed, 3 Jun 2015 16:59:42 +0530
Message-ID: <1433330987-6808-13-git-send-email-patila@marvell.com> (sfid-20150603_080350_455404_4B0AEFA7)
In-Reply-To: <1433330987-6808-1-git-send-email-patila@marvell.com>
References: <1433330987-6808-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Earlier only RSN, WPA and channel switch IEs from tail buffer would
be downloaded to FW.
This patch adds support for downloading more IEs from tail buffer.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/ie.c | 102 ++++++++++++++++++++++----------------
 1 file changed, 60 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/ie.c b/drivers/net/wireless/mwifiex/ie.c
index f3b6ed2..0ba8945 100644
--- a/drivers/net/wireless/mwifiex/ie.c
+++ b/drivers/net/wireless/mwifiex/ie.c
@@ -320,63 +320,81 @@ done:
 /* This function parses  head and tail IEs, from cfg80211_beacon_data and sets
  * these IE to FW.
  */
-static int mwifiex_uap_set_head_tail_ies(struct mwifiex_private *priv,
-					 struct cfg80211_beacon_data *info)
+static int mwifiex_uap_parse_tail_ies(struct mwifiex_private *priv,
+				      struct cfg80211_beacon_data *info)
 {
 	struct mwifiex_ie *gen_ie;
-	struct ieee_types_header *rsn_ie = NULL, *wpa_ie = NULL;
-	struct ieee_types_header *chsw_ie = NULL;
+	struct ieee_types_header *hdr;
+	struct ieee80211_vendor_ie *vendorhdr;
 	u16 gen_idx = MWIFIEX_AUTO_IDX_MASK, ie_len = 0;
-	const u8 *vendor_ie;
+	int left_len, parsed_len = 0;
+
+	if (!info->tail || !info->tail_len)
+		return 0;
 
 	gen_ie = kzalloc(sizeof(*gen_ie), GFP_KERNEL);
 	if (!gen_ie)
 		return -ENOMEM;
-	gen_ie->ie_index = cpu_to_le16(gen_idx);
-	gen_ie->mgmt_subtype_mask = cpu_to_le16(MGMT_MASK_BEACON |
-						MGMT_MASK_PROBE_RESP |
-						MGMT_MASK_ASSOC_RESP);
 
-	if (info->tail && info->tail_len) {
-		rsn_ie = (void *)cfg80211_find_ie(WLAN_EID_RSN,
-						  info->tail, info->tail_len);
-		if (rsn_ie) {
-			memcpy(gen_ie->ie_buffer, rsn_ie, rsn_ie->len + 2);
-			ie_len = rsn_ie->len + 2;
-			gen_ie->ie_length = cpu_to_le16(ie_len);
+	left_len = info->tail_len;
+
+	/* Many IEs are generated in FW by parsing bss configuration.
+	 * Let's not add them here; else we may end up duplicating these IEs
+	 */
+	while (left_len > sizeof(struct ieee_types_header)) {
+		hdr = (void *)(info->tail + parsed_len);
+		switch (hdr->element_id) {
+		case WLAN_EID_SSID:
+		case WLAN_EID_SUPP_RATES:
+		case WLAN_EID_COUNTRY:
+		case WLAN_EID_PWR_CONSTRAINT:
+		case WLAN_EID_EXT_SUPP_RATES:
+		case WLAN_EID_HT_CAPABILITY:
+		case WLAN_EID_HT_OPERATION:
+		case WLAN_EID_VHT_CAPABILITY:
+		case WLAN_EID_VHT_OPERATION:
+		case WLAN_EID_VENDOR_SPECIFIC:
+			break;
+		default:
+			memcpy(gen_ie->ie_buffer + ie_len, hdr,
+			       hdr->len + sizeof(struct ieee_types_header));
+			ie_len += hdr->len + sizeof(struct ieee_types_header);
+			break;
 		}
+		left_len -= hdr->len + sizeof(struct ieee_types_header);
+		parsed_len += hdr->len + sizeof(struct ieee_types_header);
+	}
 
-		vendor_ie = cfg80211_find_vendor_ie(WLAN_OUI_MICROSOFT,
+	/* parse only WPA vendor IE from tail, WMM IE is configured by
+	 * bss_config command
+	 */
+	vendorhdr = (void *)cfg80211_find_vendor_ie(WLAN_OUI_MICROSOFT,
 						    WLAN_OUI_TYPE_MICROSOFT_WPA,
-						    info->tail,
-						    info->tail_len);
-		if (vendor_ie) {
-			wpa_ie = (struct ieee_types_header *)vendor_ie;
-			memcpy(gen_ie->ie_buffer + ie_len,
-			       wpa_ie, wpa_ie->len + 2);
-			ie_len += wpa_ie->len + 2;
-			gen_ie->ie_length = cpu_to_le16(ie_len);
-		}
+						    info->tail, info->tail_len);
+	if (vendorhdr) {
+		memcpy(gen_ie->ie_buffer + ie_len, vendorhdr,
+		       vendorhdr->len + sizeof(struct ieee_types_header));
+		ie_len += vendorhdr->len + sizeof(struct ieee_types_header);
+	}
 
-		chsw_ie = (void *)cfg80211_find_ie(WLAN_EID_CHANNEL_SWITCH,
-						   info->tail, info->tail_len);
-		if (chsw_ie) {
-			memcpy(gen_ie->ie_buffer + ie_len,
-			       chsw_ie, chsw_ie->len + 2);
-			ie_len += chsw_ie->len + 2;
-			gen_ie->ie_length = cpu_to_le16(ie_len);
-		}
+	if (!ie_len) {
+		kfree(gen_ie);
+		return 0;
 	}
 
-	if (rsn_ie || wpa_ie || chsw_ie) {
-		if (mwifiex_update_uap_custom_ie(priv, gen_ie, &gen_idx, NULL,
-						 NULL, NULL, NULL)) {
-			kfree(gen_ie);
-			return -1;
-		}
-		priv->gen_idx = gen_idx;
+	gen_ie->ie_index = cpu_to_le16(gen_idx);
+	gen_ie->mgmt_subtype_mask = cpu_to_le16(MGMT_MASK_BEACON |
+						MGMT_MASK_PROBE_RESP |
+						MGMT_MASK_ASSOC_RESP);
+	gen_ie->ie_length = cpu_to_le16(ie_len);
+
+	if (mwifiex_update_uap_custom_ie(priv, gen_ie, &gen_idx, NULL, NULL,
+					 NULL, NULL)) {
+		kfree(gen_ie);
+		return -1;
 	}
 
+	priv->gen_idx = gen_idx;
 	kfree(gen_ie);
 	return 0;
 }
@@ -390,7 +408,7 @@ int mwifiex_set_mgmt_ies(struct mwifiex_private *priv,
 {
 	int ret;
 
-	ret = mwifiex_uap_set_head_tail_ies(priv, info);
+	ret = mwifiex_uap_parse_tail_ies(priv, info);
 		return ret;
 
 	return mwifiex_set_mgmt_beacon_data_ies(priv, info);
-- 
1.8.1.4

