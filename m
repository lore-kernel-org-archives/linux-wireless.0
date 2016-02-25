Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:37999 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407AbcBYAJD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 19:09:03 -0500
Received: by mail-wm0-f44.google.com with SMTP id a4so5514458wme.1
        for <linux-wireless@vger.kernel.org>; Wed, 24 Feb 2016 16:09:01 -0800 (PST)
From: Andreas Fenkart <afenkart@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Andreas Fenkart <afenkart@gmail.com>
Subject: [PATCH 2/7] mwifiex: scan: factor out has_ieee_hdr/has_vendor_hdr
Date: Thu, 25 Feb 2016 01:08:47 +0100
Message-Id: <1456358932-23114-3-git-send-email-afenkart@gmail.com> (sfid-20160225_010906_928122_0D340E71)
In-Reply-To: <1456358932-23114-1-git-send-email-afenkart@gmail.com>
References: <1456358932-23114-1-git-send-email-afenkart@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Andreas Fenkart <afenkart@gmail.com>
---
 drivers/net/wireless/marvell/mwifiex/scan.c | 52 +++++++++++++----------------
 1 file changed, 23 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index 43d7a92..276382e 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -76,6 +76,18 @@ static u8 mwifiex_rsn_oui[CIPHER_SUITE_MAX][4] = {
 	{ 0x00, 0x0f, 0xac, 0x04 },	/* AES  */
 };
 
+static bool
+has_ieee_hdr(struct ieee_types_generic *ie, u8 key)
+{
+	return (ie && (ie->ieee_hdr.element_id == key));
+}
+
+static bool
+has_vendor_hdr(struct ieee_types_vendor_specific *ie, u8 key)
+{
+	return (ie && (ie->vend_hdr.element_id == key));
+}
+
 /*
  * This function parses a given IE for a given OUI.
  *
@@ -121,8 +133,7 @@ mwifiex_is_rsn_oui_present(struct mwifiex_bssdescriptor *bss_desc, u32 cipher)
 	struct ie_body *iebody;
 	u8 ret = MWIFIEX_OUI_NOT_PRESENT;
 
-	if (bss_desc->bcn_rsn_ie &&
-	    (bss_desc->bcn_rsn_ie->ieee_hdr.element_id == WLAN_EID_RSN)) {
+	if (has_ieee_hdr(bss_desc->bcn_rsn_ie, WLAN_EID_RSN)) {
 		iebody = (struct ie_body *)
 			 (((u8 *) bss_desc->bcn_rsn_ie->data) +
 			  RSN_GTK_OUI_OFFSET);
@@ -148,9 +159,7 @@ mwifiex_is_wpa_oui_present(struct mwifiex_bssdescriptor *bss_desc, u32 cipher)
 	struct ie_body *iebody;
 	u8 ret = MWIFIEX_OUI_NOT_PRESENT;
 
-	if (bss_desc->bcn_wpa_ie &&
-	    (bss_desc->bcn_wpa_ie->vend_hdr.element_id ==
-	     WLAN_EID_VENDOR_SPECIFIC)) {
+	if (has_vendor_hdr(bss_desc->bcn_wpa_ie, WLAN_EID_VENDOR_SPECIFIC)) {
 		iebody = (struct ie_body *) bss_desc->bcn_wpa_ie->data;
 		oui = &mwifiex_wpa_oui[cipher][0];
 		ret = mwifiex_search_oui_in_ie(iebody, oui);
@@ -180,11 +189,8 @@ mwifiex_is_bss_wapi(struct mwifiex_private *priv,
 		    struct mwifiex_bssdescriptor *bss_desc)
 {
 	if (priv->sec_info.wapi_enabled &&
-	    (bss_desc->bcn_wapi_ie &&
-	     (bss_desc->bcn_wapi_ie->ieee_hdr.element_id ==
-	      WLAN_EID_BSS_AC_ACCESS_DELAY))) {
+	    has_ieee_hdr(bss_desc->bcn_wapi_ie, WLAN_EID_BSS_AC_ACCESS_DELAY))
 		return true;
-	}
 	return false;
 }
 
@@ -198,11 +204,8 @@ mwifiex_is_bss_no_sec(struct mwifiex_private *priv,
 {
 	if (!priv->sec_info.wep_enabled && !priv->sec_info.wpa_enabled &&
 	    !priv->sec_info.wpa2_enabled &&
-	    (!bss_desc->bcn_wpa_ie ||
-		(bss_desc->bcn_wpa_ie->vend_hdr.element_id !=
-		 WLAN_EID_VENDOR_SPECIFIC)) &&
-	    (!bss_desc->bcn_rsn_ie ||
-		(bss_desc->bcn_rsn_ie->ieee_hdr.element_id != WLAN_EID_RSN)) &&
+	    !has_vendor_hdr(bss_desc->bcn_wpa_ie, WLAN_EID_VENDOR_SPECIFIC) &&
+	    !has_ieee_hdr(bss_desc->bcn_rsn_ie, WLAN_EID_RSN) &&
 	    !priv->sec_info.encryption_mode && !bss_desc->privacy) {
 		return true;
 	}
@@ -234,9 +237,7 @@ mwifiex_is_bss_wpa(struct mwifiex_private *priv,
 {
 	if (!priv->sec_info.wep_enabled && priv->sec_info.wpa_enabled &&
 	    !priv->sec_info.wpa2_enabled &&
-	    (bss_desc->bcn_wpa_ie &&
-	     (bss_desc->bcn_wpa_ie->vend_hdr.element_id ==
-	      WLAN_EID_VENDOR_SPECIFIC))
+	    has_vendor_hdr(bss_desc->bcn_wpa_ie, WLAN_EID_VENDOR_SPECIFIC)
 	   /*
 	    * Privacy bit may NOT be set in some APs like
 	    * LinkSys WRT54G && bss_desc->privacy
@@ -270,8 +271,7 @@ mwifiex_is_bss_wpa2(struct mwifiex_private *priv,
 {
 	if (!priv->sec_info.wep_enabled && !priv->sec_info.wpa_enabled &&
 	    priv->sec_info.wpa2_enabled &&
-	    (bss_desc->bcn_rsn_ie &&
-	     (bss_desc->bcn_rsn_ie->ieee_hdr.element_id == WLAN_EID_RSN))) {
+	    has_ieee_hdr(bss_desc->bcn_rsn_ie, WLAN_EID_RSN)) {
 		/*
 		 * Privacy bit may NOT be set in some APs like
 		 * LinkSys WRT54G && bss_desc->privacy
@@ -304,11 +304,8 @@ mwifiex_is_bss_adhoc_aes(struct mwifiex_private *priv,
 {
 	if (!priv->sec_info.wep_enabled && !priv->sec_info.wpa_enabled &&
 	    !priv->sec_info.wpa2_enabled &&
-	    (!bss_desc->bcn_wpa_ie ||
-	     (bss_desc->bcn_wpa_ie->vend_hdr.element_id !=
-	      WLAN_EID_VENDOR_SPECIFIC)) &&
-	    (!bss_desc->bcn_rsn_ie ||
-	     (bss_desc->bcn_rsn_ie->ieee_hdr.element_id != WLAN_EID_RSN)) &&
+	    !has_vendor_hdr(bss_desc->bcn_wpa_ie, WLAN_EID_VENDOR_SPECIFIC) &&
+	    !has_ieee_hdr(bss_desc->bcn_rsn_ie, WLAN_EID_RSN) &&
 	    !priv->sec_info.encryption_mode && bss_desc->privacy) {
 		return true;
 	}
@@ -325,11 +322,8 @@ mwifiex_is_bss_dynamic_wep(struct mwifiex_private *priv,
 {
 	if (!priv->sec_info.wep_enabled && !priv->sec_info.wpa_enabled &&
 	    !priv->sec_info.wpa2_enabled &&
-	    (!bss_desc->bcn_wpa_ie ||
-	     (bss_desc->bcn_wpa_ie->vend_hdr.element_id !=
-	      WLAN_EID_VENDOR_SPECIFIC)) &&
-	    (!bss_desc->bcn_rsn_ie ||
-	     (bss_desc->bcn_rsn_ie->ieee_hdr.element_id != WLAN_EID_RSN)) &&
+	    !has_vendor_hdr(bss_desc->bcn_wpa_ie, WLAN_EID_VENDOR_SPECIFIC) &&
+	    !has_ieee_hdr(bss_desc->bcn_rsn_ie, WLAN_EID_RSN) &&
 	    priv->sec_info.encryption_mode && bss_desc->privacy) {
 		mwifiex_dbg(priv->adapter, INFO,
 			    "info: %s: dynamic\t"
-- 
2.7.0

