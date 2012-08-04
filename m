Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na6sys009bog027.obsmtp.com ([74.125.150.94]:49798 "EHLO
	na6sys009bog027.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752979Ab2HDBUD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2012 21:20:03 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 14/16] mwifiex: rename wapi_rxpn to pn
Date: Fri,  3 Aug 2012 18:06:12 -0700
Message-Id: <1344042374-6892-15-git-send-email-bzhao@marvell.com> (sfid-20120804_032007_984488_2791C153)
In-Reply-To: <1344042374-6892-1-git-send-email-bzhao@marvell.com>
References: <1344042374-6892-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ying Luo <luoy@marvell.com>

This array was used for wapi_rxpn only. Now it will be used for
AES_CMAC as well. So make a generic name for it.

Signed-off-by: Ying Luo <luoy@marvell.com>
Signed-off-by: Stone Piao <piaoyun@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/ioctl.h   |    4 ++--
 drivers/net/wireless/mwifiex/sta_cmd.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index 5019153..f2865b5 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -213,7 +213,7 @@ struct mwifiex_debug_info {
 };
 
 #define MWIFIEX_KEY_INDEX_UNICAST	0x40000000
-#define WAPI_RXPN_LEN			16
+#define PN_LEN				16
 
 struct mwifiex_ds_encrypt_key {
 	u32 key_disable;
@@ -222,7 +222,7 @@ struct mwifiex_ds_encrypt_key {
 	u8 key_material[WLAN_MAX_KEY_LEN];
 	u8 mac_addr[ETH_ALEN];
 	u32 is_wapi_key;
-	u8 wapi_rxpn[WAPI_RXPN_LEN];
+	u8 pn[PN_LEN];		/* packet number */
 };
 
 struct mwifiex_power_cfg {
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index df3a33c..a4a4a19 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -610,7 +610,7 @@ mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
 		memcpy(&key_material->key_param_set.key[2],
 		       enc_key->key_material, enc_key->key_len);
 		memcpy(&key_material->key_param_set.key[2 + enc_key->key_len],
-		       enc_key->wapi_rxpn, WAPI_RXPN_LEN);
+		       enc_key->pn, PN_LEN);
 		key_material->key_param_set.length =
 			cpu_to_le16(WAPI_KEY_LEN + KEYPARAMSET_FIXED_LEN);
 
-- 
1.7.0.2

