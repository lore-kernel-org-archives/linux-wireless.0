Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:23098 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750920AbaEGFDK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 01:03:10 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/3] mwifiex: configure inactivity timeout for TDLS link
Date: Tue, 6 May 2014 22:02:43 -0700
Message-ID: <1399438965-12221-1-git-send-email-bzhao@marvell.com> (sfid-20140507_070314_871862_E3422557)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch adds configuration timeout for TDLS link. This is
configuered at the time of TDLS link configuration. If TDLS link
is inactive for more than timeout, FW will tear this link.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/fw.h      | 8 ++++++++
 drivers/net/wireless/mwifiex/sta_cmd.c | 7 +++++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index b485dc1..28994ab 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -169,6 +169,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define TLV_TYPE_GWK_CIPHER         (PROPRIETARY_TLV_BASE_ID + 146)
 #define TLV_TYPE_COALESCE_RULE      (PROPRIETARY_TLV_BASE_ID + 154)
 #define TLV_TYPE_KEY_PARAM_V2       (PROPRIETARY_TLV_BASE_ID + 156)
+#define TLV_TYPE_TDLS_IDLE_TIMEOUT  (PROPRIETARY_TLV_BASE_ID + 194)
 #define TLV_TYPE_FW_API_REV         (PROPRIETARY_TLV_BASE_ID + 199)
 
 #define MWIFIEX_TX_DATA_BUF_SIZE_2K        2048
@@ -708,6 +709,13 @@ struct mwifiex_ie_types_vendor_param_set {
 	u8 ie[MWIFIEX_MAX_VSIE_LEN];
 };
 
+#define MWIFIEX_TDLS_IDLE_TIMEOUT	60
+
+struct mwifiex_ie_types_tdls_idle_timeout {
+	struct mwifiex_ie_types_header header;
+	__le16 value;
+} __packed;
+
 struct mwifiex_ie_types_rsn_param_set {
 	struct mwifiex_ie_types_header header;
 	u8 rsn_ie[1];
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index e3cac14..88202ce 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -1546,6 +1546,7 @@ mwifiex_cmd_tdls_oper(struct mwifiex_private *priv,
 	struct mwifiex_ie_types_extcap *extcap;
 	struct mwifiex_ie_types_vhtcap *vht_capab;
 	struct mwifiex_ie_types_aid *aid;
+	struct mwifiex_ie_types_tdls_idle_timeout *timeout;
 	u8 *pos, qos_info;
 	u16 config_len = 0;
 	struct station_parameters *params = priv->sta_params;
@@ -1643,6 +1644,12 @@ mwifiex_cmd_tdls_oper(struct mwifiex_private *priv,
 			config_len += sizeof(struct mwifiex_ie_types_aid);
 		}
 
+		timeout = (void *)(pos + config_len);
+		timeout->header.type = cpu_to_le16(TLV_TYPE_TDLS_IDLE_TIMEOUT);
+		timeout->header.len = cpu_to_le16(sizeof(timeout->value));
+		timeout->value = cpu_to_le16(MWIFIEX_TDLS_IDLE_TIMEOUT);
+		config_len += sizeof(struct mwifiex_ie_types_tdls_idle_timeout);
+
 		break;
 	default:
 		dev_err(priv->adapter->dev, "Unknown TDLS operation\n");
-- 
1.8.2.3

