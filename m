Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:3375 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751223AbaBHAbF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Feb 2014 19:31:05 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 25/30] mwifiex: pass ieee80211_vht_cap to mwifiex_fill_vht_cap_tlv
Date: Fri, 7 Feb 2014 16:30:38 -0800
Message-ID: <1391819442-21239-6-git-send-email-bzhao@marvell.com> (sfid-20140208_020008_024618_3ACF05C1)
In-Reply-To: <1391819442-21239-1-git-send-email-bzhao@marvell.com>
References: <1391819442-21239-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch changes mwifiex_fill_vht_cap_tlv function to pass
struct ieee80211_vht_cap instead of mwifiex_ie_types_vhtcap
so that it can be used generically.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11ac.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11ac.c b/drivers/net/wireless/mwifiex/11ac.c
index 4738392..5895bc8 100644
--- a/drivers/net/wireless/mwifiex/11ac.c
+++ b/drivers/net/wireless/mwifiex/11ac.c
@@ -96,21 +96,21 @@ mwifiex_convert_mcsmap_to_maxrate(struct mwifiex_private *priv,
 
 static void
 mwifiex_fill_vht_cap_info(struct mwifiex_private *priv,
-			  struct mwifiex_ie_types_vhtcap *vht_cap, u8 bands)
+			  struct ieee80211_vht_cap *vht_cap, u8 bands)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 
 	if (bands & BAND_A)
-		vht_cap->vht_cap.vht_cap_info =
+		vht_cap->vht_cap_info =
 				cpu_to_le32(adapter->usr_dot_11ac_dev_cap_a);
 	else
-		vht_cap->vht_cap.vht_cap_info =
+		vht_cap->vht_cap_info =
 				cpu_to_le32(adapter->usr_dot_11ac_dev_cap_bg);
 }
 
 static void
 mwifiex_fill_vht_cap_tlv(struct mwifiex_private *priv,
-			 struct mwifiex_ie_types_vhtcap *vht_cap, u8 bands)
+			 struct ieee80211_vht_cap *vht_cap, u8 bands)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	u16 mcs_map_user, mcs_map_resp, mcs_map_result;
@@ -121,7 +121,7 @@ mwifiex_fill_vht_cap_tlv(struct mwifiex_private *priv,
 
 	/* rx MCS Set: find the minimum of the user rx mcs and ap rx mcs */
 	mcs_map_user = GET_DEVRXMCSMAP(adapter->usr_dot_11ac_mcs_support);
-	mcs_map_resp = le16_to_cpu(vht_cap->vht_cap.supp_mcs.rx_mcs_map);
+	mcs_map_resp = le16_to_cpu(vht_cap->supp_mcs.rx_mcs_map);
 	mcs_map_result = 0;
 
 	for (nss = 1; nss <= 8; nss++) {
@@ -137,14 +137,14 @@ mwifiex_fill_vht_cap_tlv(struct mwifiex_private *priv,
 				      min(mcs_user, mcs_resp));
 	}
 
-	vht_cap->vht_cap.supp_mcs.rx_mcs_map = cpu_to_le16(mcs_map_result);
+	vht_cap->supp_mcs.rx_mcs_map = cpu_to_le16(mcs_map_result);
 
 	tmp = mwifiex_convert_mcsmap_to_maxrate(priv, bands, mcs_map_result);
-	vht_cap->vht_cap.supp_mcs.rx_highest = cpu_to_le16(tmp);
+	vht_cap->supp_mcs.rx_highest = cpu_to_le16(tmp);
 
 	/* tx MCS Set: find the minimum of the user tx mcs and ap tx mcs */
 	mcs_map_user = GET_DEVTXMCSMAP(adapter->usr_dot_11ac_mcs_support);
-	mcs_map_resp = le16_to_cpu(vht_cap->vht_cap.supp_mcs.tx_mcs_map);
+	mcs_map_resp = le16_to_cpu(vht_cap->supp_mcs.tx_mcs_map);
 	mcs_map_result = 0;
 
 	for (nss = 1; nss <= 8; nss++) {
@@ -159,10 +159,10 @@ mwifiex_fill_vht_cap_tlv(struct mwifiex_private *priv,
 				      min(mcs_user, mcs_resp));
 	}
 
-	vht_cap->vht_cap.supp_mcs.tx_mcs_map = cpu_to_le16(mcs_map_result);
+	vht_cap->supp_mcs.tx_mcs_map = cpu_to_le16(mcs_map_result);
 
 	tmp = mwifiex_convert_mcsmap_to_maxrate(priv, bands, mcs_map_result);
-	vht_cap->vht_cap.supp_mcs.tx_highest = cpu_to_le16(tmp);
+	vht_cap->supp_mcs.tx_highest = cpu_to_le16(tmp);
 
 	return;
 }
@@ -197,7 +197,8 @@ int mwifiex_cmd_append_11ac_tlv(struct mwifiex_private *priv,
 		       sizeof(struct ieee_types_header),
 		       le16_to_cpu(vht_cap->header.len));
 
-		mwifiex_fill_vht_cap_tlv(priv, vht_cap, bss_desc->bss_band);
+		mwifiex_fill_vht_cap_tlv(priv, &vht_cap->vht_cap,
+					 bss_desc->bss_band);
 		*buffer += sizeof(*vht_cap);
 		ret_len += sizeof(*vht_cap);
 	}
-- 
1.8.2.3

