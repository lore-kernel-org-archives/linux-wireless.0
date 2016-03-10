Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:37645 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932846AbcCJIo1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2016 03:44:27 -0500
Received: by mail-wm0-f53.google.com with SMTP id p65so18530525wmp.0
        for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2016 00:44:26 -0800 (PST)
From: Andreas Fenkart <afenkart@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Julian Calaby <julian.calaby@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Andreas Fenkart <afenkart@gmail.com>
Subject: [PATCH v2 4/7] mwifiex: scan: factor out dbg_security_flags
Date: Thu, 10 Mar 2016 09:44:08 +0100
Message-Id: <1457599451-13910-5-git-send-email-afenkart@gmail.com> (sfid-20160310_094430_511265_59C52548)
In-Reply-To: <1457599451-13910-1-git-send-email-afenkart@gmail.com>
References: <1457599451-13910-1-git-send-email-afenkart@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

merge copy/paste code

Signed-off-by: Andreas Fenkart <afenkart@gmail.com>
---
 drivers/net/wireless/marvell/mwifiex/scan.c | 74 ++++++++++-------------------
 1 file changed, 25 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index f623834..c137fd8 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -76,6 +76,27 @@ static u8 mwifiex_rsn_oui[CIPHER_SUITE_MAX][4] = {
 	{ 0x00, 0x0f, 0xac, 0x04 },	/* AES  */
 };
 
+static void
+_dbg_security_flags(int log_level, const char *func, const char *desc,
+		    struct mwifiex_private *priv,
+		    struct mwifiex_bssdescriptor *bss_desc)
+{
+	_mwifiex_dbg(priv->adapter, log_level,
+		     "info: %s: %s:\twpa_ie=%#x wpa2_ie=%#x WEP=%s WPA=%s WPA2=%s\tEncMode=%#x privacy=%#x\n",
+		     func, desc,
+		     bss_desc->bcn_wpa_ie ?
+		     bss_desc->bcn_wpa_ie->vend_hdr.element_id : 0,
+		     bss_desc->bcn_rsn_ie ?
+		     bss_desc->bcn_rsn_ie->ieee_hdr.element_id : 0,
+		     priv->sec_info.wep_enabled ? "e" : "d",
+		     priv->sec_info.wpa_enabled ? "e" : "d",
+		     priv->sec_info.wpa2_enabled ? "e" : "d",
+		     priv->sec_info.encryption_mode,
+		     bss_desc->privacy);
+}
+#define dbg_security_flags(mask, desc, priv, bss_desc) \
+	_dbg_security_flags(MWIFIEX_DBG_##mask, desc, __func__, priv, bss_desc)
+
 static bool
 has_ieee_hdr(struct ieee_types_generic *ie, u8 key)
 {
@@ -243,19 +264,7 @@ mwifiex_is_bss_wpa(struct mwifiex_private *priv,
 	    * LinkSys WRT54G && bss_desc->privacy
 	    */
 	 ) {
-		mwifiex_dbg(priv->adapter, INFO,
-			    "info: %s: WPA:\t"
-			    "wpa_ie=%#x wpa2_ie=%#x WEP=%s WPA=%s WPA2=%s\t"
-			    "EncMode=%#x privacy=%#x\n", __func__,
-			    bss_desc->bcn_wpa_ie ?
-			    bss_desc->bcn_wpa_ie->vend_hdr.element_id : 0,
-			    bss_desc->bcn_rsn_ie ?
-			    bss_desc->bcn_rsn_ie->ieee_hdr.element_id : 0,
-			    (priv->sec_info.wep_enabled) ? "e" : "d",
-			    (priv->sec_info.wpa_enabled) ? "e" : "d",
-			    (priv->sec_info.wpa2_enabled) ? "e" : "d",
-			    priv->sec_info.encryption_mode,
-			    bss_desc->privacy);
+		dbg_security_flags(INFO, "WPA", priv, bss_desc);
 		return true;
 	}
 	return false;
@@ -276,19 +285,7 @@ mwifiex_is_bss_wpa2(struct mwifiex_private *priv,
 		 * Privacy bit may NOT be set in some APs like
 		 * LinkSys WRT54G && bss_desc->privacy
 		 */
-		mwifiex_dbg(priv->adapter, INFO,
-			    "info: %s: WPA2:\t"
-			    "wpa_ie=%#x wpa2_ie=%#x WEP=%s WPA=%s WPA2=%s\t"
-			    "EncMode=%#x privacy=%#x\n", __func__,
-			    bss_desc->bcn_wpa_ie ?
-			    bss_desc->bcn_wpa_ie->vend_hdr.element_id : 0,
-			    bss_desc->bcn_rsn_ie ?
-			    bss_desc->bcn_rsn_ie->ieee_hdr.element_id : 0,
-			    (priv->sec_info.wep_enabled) ? "e" : "d",
-			    (priv->sec_info.wpa_enabled) ? "e" : "d",
-			    (priv->sec_info.wpa2_enabled) ? "e" : "d",
-			    priv->sec_info.encryption_mode,
-			    bss_desc->privacy);
+		dbg_security_flags(INFO, "WAP2", priv, bss_desc);
 		return true;
 	}
 	return false;
@@ -325,17 +322,7 @@ mwifiex_is_bss_dynamic_wep(struct mwifiex_private *priv,
 	    !has_vendor_hdr(bss_desc->bcn_wpa_ie, WLAN_EID_VENDOR_SPECIFIC) &&
 	    !has_ieee_hdr(bss_desc->bcn_rsn_ie, WLAN_EID_RSN) &&
 	    priv->sec_info.encryption_mode && bss_desc->privacy) {
-		mwifiex_dbg(priv->adapter, INFO,
-			    "info: %s: dynamic\t"
-			    "WEP: wpa_ie=%#x wpa2_ie=%#x\t"
-			    "EncMode=%#x privacy=%#x\n",
-			    __func__,
-			    bss_desc->bcn_wpa_ie ?
-			    bss_desc->bcn_wpa_ie->vend_hdr.element_id : 0,
-			    bss_desc->bcn_rsn_ie ?
-			    bss_desc->bcn_rsn_ie->ieee_hdr.element_id : 0,
-			    priv->sec_info.encryption_mode,
-			    bss_desc->privacy);
+		dbg_security_flags(INFO, "dynamic", priv, bss_desc);
 		return true;
 	}
 	return false;
@@ -448,18 +435,7 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv,
 		}
 
 		/* Security doesn't match */
-		mwifiex_dbg(adapter, ERROR,
-			    "info: %s: failed: wpa_ie=%#x wpa2_ie=%#x WEP=%s\t"
-			    "WPA=%s WPA2=%s EncMode=%#x privacy=%#x\n",
-			    __func__,
-			    bss_desc->bcn_wpa_ie ?
-			    bss_desc->bcn_wpa_ie->vend_hdr.element_id : 0,
-			    bss_desc->bcn_rsn_ie ?
-			    bss_desc->bcn_rsn_ie->ieee_hdr.element_id : 0,
-			    (priv->sec_info.wep_enabled) ? "e" : "d",
-			    (priv->sec_info.wpa_enabled) ? "e" : "d",
-			    (priv->sec_info.wpa2_enabled) ? "e" : "d",
-			    priv->sec_info.encryption_mode, bss_desc->privacy);
+		dbg_security_flags(ERROR, "failed", priv, bss_desc);
 		return -1;
 	}
 
-- 
2.7.0

