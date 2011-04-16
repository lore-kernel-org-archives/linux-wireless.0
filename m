Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:39670 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab1DPDq3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2011 23:46:29 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/3] mwifiex: remove some macro definitions
Date: Fri, 15 Apr 2011 20:50:41 -0700
Message-Id: <1302925842-27718-2-git-send-email-bzhao@marvell.com>
In-Reply-To: <1302925842-27718-1-git-send-email-bzhao@marvell.com>
References: <1302925842-27718-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

use corresponding macros defined in include/linux/ieee80211.h

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c       |    2 +-
 drivers/net/wireless/mwifiex/fw.h        |    2 --
 drivers/net/wireless/mwifiex/ioctl.h     |    3 +--
 drivers/net/wireless/mwifiex/join.c      |    2 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c |    2 +-
 5 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index d64065f..e22d761 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -115,7 +115,7 @@ mwifiex_fill_cap_info(struct mwifiex_private *priv,
 		SETHT_MCS32(ht_cap->ht_cap.mcs.rx_mask);
 
 	/* Clear RD responder bit */
-	RESETHT_EXTCAP_RDG(ht_ext_cap);
+	ht_ext_cap &= ~IEEE80211_HT_EXT_CAP_RD_RESPONDER;
 
 	ht_cap->ht_cap.cap_info = cpu_to_le16(ht_cap_info);
 	ht_cap->ht_cap.extended_ht_cap_info = cpu_to_le16(ht_ext_cap);
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index f8c008f..6d1c454 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -134,7 +134,6 @@ enum MWIFIEX_802_11_WEP_STATUS {
 
 #define MWIFIEX_TX_DATA_BUF_SIZE_4K        4096
 #define MWIFIEX_TX_DATA_BUF_SIZE_8K        8192
-#define NON_GREENFIELD_STAS     0x04
 
 #define ISSUPP_11NENABLED(FwCapInfo) (FwCapInfo & BIT(11))
 
@@ -159,7 +158,6 @@ enum MWIFIEX_802_11_WEP_STATUS {
 #define ISSUPP_GREENFIELD(Dot11nDevCap) (Dot11nDevCap & BIT(29))
 
 #define GET_RXMCSSUPP(DevMCSSupported) (DevMCSSupported & 0x0f)
-#define RESETHT_EXTCAP_RDG(HTExtCap) (HTExtCap &= ~BIT(11))
 #define SETHT_MCS32(x) (x[4] |= 1)
 
 #define SET_SECONDARYCHAN(RadioType, SECCHAN) (RadioType |= (SECCHAN << 4))
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index 703a6d1..5488e11 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -268,14 +268,13 @@ struct mwifiex_debug_info {
 };
 
 #define MWIFIEX_KEY_INDEX_UNICAST	0x40000000
-#define MWIFIEX_MAX_KEY_LENGTH		32
 #define WAPI_RXPN_LEN			16
 
 struct mwifiex_ds_encrypt_key {
 	u32 key_disable;
 	u32 key_index;
 	u32 key_len;
-	u8 key_material[MWIFIEX_MAX_KEY_LENGTH];
+	u8 key_material[WLAN_MAX_KEY_LEN];
 	u8 mac_addr[ETH_ALEN];
 	u32 is_wapi_key;
 	u8 wapi_rxpn[WAPI_RXPN_LEN];
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 8e1cb4b..23d2d0b 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -995,7 +995,7 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 					IEEE80211_HT_PARAM_CHAN_WIDTH_ANY;
 			}
 			ht_info->ht_info.operation_mode =
-				cpu_to_le16(NON_GREENFIELD_STAS);
+			     cpu_to_le16(IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT);
 			ht_info->ht_info.basic_set[0] = 0xff;
 			pos += sizeof(struct mwifiex_ie_types_htinfo);
 			cmd_append_size +=
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 03085a3..e7adaab 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -1147,7 +1147,7 @@ static int mwifiex_sec_ioctl_set_wpa_key(struct mwifiex_private *priv,
 	struct host_cmd_ds_802_11_key_material *ibss_key;
 
 	/* Current driver only supports key length of up to 32 bytes */
-	if (encrypt_key->key_len > MWIFIEX_MAX_KEY_LENGTH) {
+	if (encrypt_key->key_len > WLAN_MAX_KEY_LEN) {
 		dev_err(priv->adapter->dev, "key length too long\n");
 		return -1;
 	}
-- 
1.7.0.2

