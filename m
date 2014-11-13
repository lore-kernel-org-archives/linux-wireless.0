Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:14451 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932468AbaKMKzT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2014 05:55:19 -0500
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, <yangyang@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 3/6] mwifiex: wmm support for TDLS link
Date: Thu, 13 Nov 2014 21:54:15 +0530
Message-ID: <1415895858-4007-4-git-send-email-patila@marvell.com> (sfid-20141113_115524_317245_7F3F7F5A)
In-Reply-To: <1415895858-4007-1-git-send-email-patila@marvell.com>
References: <1415895858-4007-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds WMM support for TDLS link. Patch
add WMM info IE for TDLS setup request/response frames
while WMM parameter for TDLS confirm frame.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/tdls.c | 55 +++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/tdls.c b/drivers/net/wireless/mwifiex/tdls.c
index e294907..93a492f 100644
--- a/drivers/net/wireless/mwifiex/tdls.c
+++ b/drivers/net/wireless/mwifiex/tdls.c
@@ -24,6 +24,7 @@
 #define TDLS_REQ_FIX_LEN      6
 #define TDLS_RESP_FIX_LEN     8
 #define TDLS_CONFIRM_FIX_LEN  6
+#define MWIFIEX_TDLS_WMM_INFO_SIZE 7
 
 static void mwifiex_restore_tdls_packets(struct mwifiex_private *priv,
 					 const u8 *mac, u8 status)
@@ -367,6 +368,55 @@ static void mwifiex_tdls_add_qos_capab(struct sk_buff *skb)
 	*pos++ = MWIFIEX_TDLS_DEF_QOS_CAPAB;
 }
 
+static void
+mwifiex_tdls_add_wmm_param_ie(struct mwifiex_private *priv, struct sk_buff *skb)
+{
+	struct ieee80211_wmm_param_ie *wmm;
+	u8 ac_vi[] = {0x42, 0x43, 0x5e, 0x00};
+	u8 ac_vo[] = {0x62, 0x32, 0x2f, 0x00};
+	u8 ac_be[] = {0x03, 0xa4, 0x00, 0x00};
+	u8 ac_bk[] = {0x27, 0xa4, 0x00, 0x00};
+
+	wmm = (void *)skb_put(skb, sizeof(*wmm));
+	memset(wmm, 0, sizeof(*wmm));
+
+	wmm->element_id = WLAN_EID_VENDOR_SPECIFIC;
+	wmm->len = sizeof(*wmm) - 2;
+	wmm->oui[0] = 0x00; /* Microsoft OUI 00:50:F2 */
+	wmm->oui[1] = 0x50;
+	wmm->oui[2] = 0xf2;
+	wmm->oui_type = 2; /* WME */
+	wmm->oui_subtype = 1; /* WME param */
+	wmm->version = 1; /* WME ver */
+	wmm->qos_info = 0; /* U-APSD not in use */
+
+	/* use default WMM AC parameters for TDLS link*/
+	memcpy(&wmm->ac[0], ac_be, sizeof(ac_be));
+	memcpy(&wmm->ac[1], ac_bk, sizeof(ac_bk));
+	memcpy(&wmm->ac[2], ac_vi, sizeof(ac_vi));
+	memcpy(&wmm->ac[3], ac_vo, sizeof(ac_vo));
+}
+
+static void
+mwifiex_add_wmm_info_ie(struct mwifiex_private *priv, struct sk_buff *skb,
+			u8 qosinfo)
+{
+	u8 *buf;
+
+	buf = (void *)skb_put(skb, MWIFIEX_TDLS_WMM_INFO_SIZE +
+			      sizeof(struct ieee_types_header));
+
+	*buf++ = WLAN_EID_VENDOR_SPECIFIC;
+	*buf++ = 7; /* len */
+	*buf++ = 0x00; /* Microsoft OUI 00:50:F2 */
+	*buf++ = 0x50;
+	*buf++ = 0xf2;
+	*buf++ = 2; /* WME */
+	*buf++ = 0; /* WME info */
+	*buf++ = 1; /* WME ver */
+	*buf++ = qosinfo; /* U-APSD no in use */
+}
+
 static int mwifiex_prep_tdls_encap_data(struct mwifiex_private *priv,
 					const u8 *peer, u8 action_code,
 					u8 dialog_token,
@@ -421,6 +471,7 @@ static int mwifiex_prep_tdls_encap_data(struct mwifiex_private *priv,
 
 		mwifiex_tdls_add_ext_capab(priv, skb);
 		mwifiex_tdls_add_qos_capab(skb);
+		mwifiex_add_wmm_info_ie(priv, skb, 0);
 		break;
 
 	case WLAN_TDLS_SETUP_RESPONSE:
@@ -458,6 +509,7 @@ static int mwifiex_prep_tdls_encap_data(struct mwifiex_private *priv,
 
 		mwifiex_tdls_add_ext_capab(priv, skb);
 		mwifiex_tdls_add_qos_capab(skb);
+		mwifiex_add_wmm_info_ie(priv, skb, 0);
 		break;
 
 	case WLAN_TDLS_SETUP_CONFIRM:
@@ -466,6 +518,8 @@ static int mwifiex_prep_tdls_encap_data(struct mwifiex_private *priv,
 		skb_put(skb, sizeof(tf->u.setup_cfm));
 		tf->u.setup_cfm.status_code = cpu_to_le16(status_code);
 		tf->u.setup_cfm.dialog_token = dialog_token;
+
+		mwifiex_tdls_add_wmm_param_ie(priv, skb);
 		if (priv->adapter->is_hw_11ac_capable) {
 			ret = mwifiex_tdls_add_vht_oper(priv, peer, skb);
 			if (ret) {
@@ -544,6 +598,7 @@ int mwifiex_send_tdls_data_frame(struct mwifiex_private *priv, const u8 *peer,
 		  sizeof(struct ieee_types_bss_co_2040) +
 		  sizeof(struct ieee80211_ht_operation) +
 		  sizeof(struct ieee80211_tdls_lnkie) +
+		  sizeof(struct ieee80211_wmm_param_ie) +
 		  extra_ies_len;
 
 	if (priv->adapter->is_hw_11ac_capable)
-- 
1.8.1.4

