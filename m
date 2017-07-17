Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35020 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751245AbdGQDqg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Jul 2017 23:46:36 -0400
Received: by mail-pf0-f194.google.com with SMTP id q85so18052705pfq.2
        for <linux-wireless@vger.kernel.org>; Sun, 16 Jul 2017 20:46:35 -0700 (PDT)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Subject: [PATCH] mwifiex: correct IE parse during association
Date: Mon, 17 Jul 2017 03:46:27 +0000
Message-Id: <1500263187-1167-1-git-send-email-huxinming820@gmail.com> (sfid-20170717_054640_466765_50512A5E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

It is observed that some IEs get missed during association.
This patch correct the old IE parse code. sme->ie will be
store as wpa ie, wps ie, wapi ie and gen ie accordingly.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c | 134 +++++++++++------------
 1 file changed, 64 insertions(+), 70 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
index 42997e0..0e3f36e 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
@@ -811,8 +811,8 @@ int mwifiex_drv_set_power(struct mwifiex_private *priv, u32 *ps_mode)
  * is checked to determine WPA version. If buffer length is zero, the existing
  * WPA IE is reset.
  */
-static int mwifiex_set_wpa_ie_helper(struct mwifiex_private *priv,
-				     u8 *ie_data_ptr, u16 ie_len)
+static int mwifiex_set_wpa_ie(struct mwifiex_private *priv,
+			      u8 *ie_data_ptr, u16 ie_len)
 {
 	if (ie_len) {
 		if (ie_len > sizeof(priv->wpa_ie)) {
@@ -1351,101 +1351,95 @@ static int mwifiex_reg_mem_ioctl_reg_rw(struct mwifiex_private *priv,
 mwifiex_set_gen_ie_helper(struct mwifiex_private *priv, u8 *ie_data_ptr,
 			  u16 ie_len)
 {
-	int ret = 0;
 	struct ieee_types_vendor_header *pvendor_ie;
 	const u8 wpa_oui[] = { 0x00, 0x50, 0xf2, 0x01 };
 	const u8 wps_oui[] = { 0x00, 0x50, 0xf2, 0x04 };
-	u16 unparsed_len = ie_len;
-	int find_wpa_ie = 0;
+	u16 unparsed_len = ie_len, cur_ie_len;
 
 	/* If the passed length is zero, reset the buffer */
 	if (!ie_len) {
 		priv->gen_ie_buf_len = 0;
 		priv->wps.session_enable = false;
-
 		return 0;
-	} else if (!ie_data_ptr) {
+	} else if (!ie_data_ptr ||
+		   ie_len <= sizeof(struct ieee_types_header)) {
 		return -1;
 	}
 	pvendor_ie = (struct ieee_types_vendor_header *) ie_data_ptr;
 
 	while (pvendor_ie) {
-		if (pvendor_ie->element_id == WLAN_EID_VENDOR_SPECIFIC) {
-			/* Test to see if it is a WPA IE, if not, then it is a
-			 * gen IE
-			 */
-			if (!memcmp(pvendor_ie->oui, wpa_oui,
-				    sizeof(wpa_oui))) {
-				find_wpa_ie = 1;
-				break;
-			}
+		cur_ie_len = pvendor_ie->len + sizeof(struct ieee_types_header);
 
-			/* Test to see if it is a WPS IE, if so, enable
-			 * wps session flag
-			 */
-			if (!memcmp(pvendor_ie->oui, wps_oui,
-				    sizeof(wps_oui))) {
-				priv->wps.session_enable = true;
-				mwifiex_dbg(priv->adapter, MSG,
-					    "info: WPS Session Enabled.\n");
-				ret = mwifiex_set_wps_ie(priv,
-							 (u8 *)pvendor_ie,
-							 unparsed_len);
+		if (pvendor_ie->element_id == WLAN_EID_RSN) {
+			/* IE is a WPA/WPA2 IE so call set_wpa function */
+			mwifiex_set_wpa_ie(priv, (u8 *)pvendor_ie, cur_ie_len);
+			priv->wps.session_enable = false;
+		} else if (pvendor_ie->element_id ==
+			   WLAN_EID_BSS_AC_ACCESS_DELAY) {
+			/* IE is a WAPI IE so call set_wapi function */
+			mwifiex_set_wapi_ie(priv, (u8 *)pvendor_ie,
+					    cur_ie_len);
+		} else {
+			if (pvendor_ie->element_id ==
+			    WLAN_EID_VENDOR_SPECIFIC) {
+				/* Test to see if it is a WPA IE,
+				 * if not, then it is a gen IE
+				 */
+				if (!memcmp(pvendor_ie->oui, wpa_oui,
+					    sizeof(wpa_oui))) {
+					/* IE is a WPA/WPA2 IE so call
+					 * set_wpa function
+					 */
+					mwifiex_set_wpa_ie(priv,
+							   (u8 *)pvendor_ie,
+							   cur_ie_len);
+					priv->wps.session_enable = false;
+					goto NEXT_IE;
+				} else if (!memcmp(pvendor_ie->oui, wps_oui,
+					    sizeof(wps_oui))) {
+					/* Test to see if it is a WPS IE,
+					 * if so, enable wps session flag
+					 */
+					priv->wps.session_enable = true;
+					mwifiex_dbg(priv->adapter, MSG,
+						    "WPS Session Enabled.\n");
+					mwifiex_set_wps_ie(priv,
+							   (u8 *)pvendor_ie,
+							   cur_ie_len);
+					goto NEXT_IE;
+				}
 			}
-		}
 
-		if (pvendor_ie->element_id == WLAN_EID_RSN) {
-			find_wpa_ie = 1;
-			break;
-		}
+			/* Saved in gen_ie, such as P2P IE.etc.*/
 
-		if (pvendor_ie->element_id == WLAN_EID_BSS_AC_ACCESS_DELAY) {
-		/* IE is a WAPI IE so call set_wapi function */
-			ret = mwifiex_set_wapi_ie(priv, (u8 *)pvendor_ie,
-						  unparsed_len);
-			return ret;
+			/* Verify that the passed length is not larger than the
+			 * available space remaining in the buffer
+			 */
+			if (cur_ie_len <
+			    (sizeof(priv->gen_ie_buf) - priv->gen_ie_buf_len)) {
+				/* Append the passed data to the end
+				 * of the genIeBuffer
+				 */
+				memcpy(priv->gen_ie_buf + priv->gen_ie_buf_len,
+				       (u8 *)pvendor_ie, cur_ie_len);
+				/* Increment the stored buffer length by the
+				 * size passed
+				 */
+				priv->gen_ie_buf_len += cur_ie_len;
+			}
 		}
 
-		unparsed_len -= (pvendor_ie->len +
-				 sizeof(struct ieee_types_header));
+NEXT_IE:
+		unparsed_len -= cur_ie_len;
 
 		if (unparsed_len <= sizeof(struct ieee_types_header))
 			pvendor_ie = NULL;
 		else
 			pvendor_ie = (struct ieee_types_vendor_header *)
-				(((u8 *)pvendor_ie) + pvendor_ie->len +
-				 sizeof(struct ieee_types_header));
-	}
-
-	if (find_wpa_ie) {
-		/* IE is a WPA/WPA2 IE so call set_wpa function */
-		ret = mwifiex_set_wpa_ie_helper(priv, (u8 *)pvendor_ie,
-						unparsed_len);
-		priv->wps.session_enable = false;
-		return ret;
+				(((u8 *)pvendor_ie) + cur_ie_len);
 	}
 
-	/*
-	 * Verify that the passed length is not larger than the
-	 * available space remaining in the buffer
-	 */
-	if (ie_len < (sizeof(priv->gen_ie_buf) - priv->gen_ie_buf_len)) {
-
-		/* Append the passed data to the end of the
-		   genIeBuffer */
-		memcpy(priv->gen_ie_buf + priv->gen_ie_buf_len, ie_data_ptr,
-		       ie_len);
-		/* Increment the stored buffer length by the
-		   size passed */
-		priv->gen_ie_buf_len += ie_len;
-	} else {
-		/* Passed data does not fit in the remaining
-		   buffer space */
-		ret = -1;
-	}
-
-	/* Return 0, or -1 for error case */
-	return ret;
+	return 0;
 }
 
 /*
-- 
1.9.1
