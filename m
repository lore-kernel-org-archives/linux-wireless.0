Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:48486 "HELO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757441Ab2FOTcL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jun 2012 15:32:11 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v3 3/5] mwifiex: set HT capability based on cfg80211_ap_settings
Date: Fri, 15 Jun 2012 12:21:53 -0700
Message-Id: <1339788115-20596-4-git-send-email-bzhao@marvell.com> (sfid-20120615_213214_834219_1114B3C7)
In-Reply-To: <1339788115-20596-1-git-send-email-bzhao@marvell.com>
References: <1339788115-20596-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

Parse HT IE from cfg80211 and set HT capabilities accordingly
to FW. If HT IE is missing, 11n would be disabled in FW.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
v3: changed subject (was "[PATCH v3 3/5] mwifiex: add 11n support for AP mode")
v2: fixed sparse warnings

 drivers/net/wireless/mwifiex/cfg80211.c |    2 +
 drivers/net/wireless/mwifiex/fw.h       |    6 ++++
 drivers/net/wireless/mwifiex/ioctl.h    |    1 +
 drivers/net/wireless/mwifiex/main.h     |    3 ++
 drivers/net/wireless/mwifiex/uap_cmd.c  |   47 +++++++++++++++++++++++++++++++
 5 files changed, 59 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 7b4eaf4..5af3f97 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -978,6 +978,8 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 		return -1;
 	}
 
+	mwifiex_set_ht_params(priv, bss_cfg, params);
+
 	if (mwifiex_send_cmd_sync(priv, HostCmd_CMD_UAP_BSS_STOP,
 				  HostCmd_ACT_GEN_SET, 0, NULL)) {
 		wiphy_err(wiphy, "Failed to stop the BSS\n");
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 561452a..9686f6f 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -162,6 +162,12 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 
 #define ISSUPP_11NENABLED(FwCapInfo) (FwCapInfo & BIT(11))
 
+#define MWIFIEX_DEF_HT_CAP	(IEEE80211_HT_CAP_DSSSCCK40 | \
+				 (1 << IEEE80211_HT_CAP_RX_STBC_SHIFT) | \
+				 IEEE80211_HT_CAP_SM_PS)
+
+#define MWIFIEX_DEF_AMPDU	IEEE80211_HT_AMPDU_PARM_FACTOR
+
 /* dev_cap bitmap
  * BIT
  * 0-16		reserved
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index e6be6ee..8c8e47c 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -90,6 +90,7 @@ struct mwifiex_uap_bss_param {
 	u16 key_mgmt;
 	u16 key_mgmt_operation;
 	struct wpa_param wpa_cfg;
+	struct ieee80211_ht_cap ht_cap;
 };
 
 enum {
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 512481e..0b3b5aa 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -840,6 +840,9 @@ void mwifiex_init_priv_params(struct mwifiex_private *priv,
 int mwifiex_set_secure_params(struct mwifiex_private *priv,
 			      struct mwifiex_uap_bss_param *bss_config,
 			      struct cfg80211_ap_settings *params);
+void mwifiex_set_ht_params(struct mwifiex_private *priv,
+			   struct mwifiex_uap_bss_param *bss_cfg,
+			   struct cfg80211_ap_settings *params);
 
 /*
  * This function checks if the queuing is RA based or not.
diff --git a/drivers/net/wireless/mwifiex/uap_cmd.c b/drivers/net/wireless/mwifiex/uap_cmd.c
index 38a49a1..f13982d 100644
--- a/drivers/net/wireless/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -127,6 +127,33 @@ int mwifiex_set_secure_params(struct mwifiex_private *priv,
 	return 0;
 }
 
+/* This function updates 11n related parameters from IE and sets them into
+ * bss_config structure.
+ */
+void
+mwifiex_set_ht_params(struct mwifiex_private *priv,
+		      struct mwifiex_uap_bss_param *bss_cfg,
+		      struct cfg80211_ap_settings *params)
+{
+	const u8 *ht_ie;
+
+	if (!ISSUPP_11NENABLED(priv->adapter->fw_cap_info))
+		return;
+
+	ht_ie = cfg80211_find_ie(WLAN_EID_HT_CAPABILITY, params->beacon.tail,
+				 params->beacon.tail_len);
+	if (ht_ie) {
+		memcpy(&bss_cfg->ht_cap, ht_ie + 2,
+		       sizeof(struct ieee80211_ht_cap));
+	} else {
+		memset(&bss_cfg->ht_cap , 0, sizeof(struct ieee80211_ht_cap));
+		bss_cfg->ht_cap.cap_info = cpu_to_le16(MWIFIEX_DEF_HT_CAP);
+		bss_cfg->ht_cap.ampdu_params_info = MWIFIEX_DEF_AMPDU;
+	}
+
+	return;
+}
+
 /* This function initializes some of mwifiex_uap_bss_param variables.
  * This helps FW in ignoring invalid values. These values may or may not
  * be get updated to valid ones at later stage.
@@ -163,6 +190,7 @@ mwifiex_uap_bss_param_prepare(u8 *tlv, void *cmd_buf, u16 *param_size)
 	struct host_cmd_tlv_auth_type *auth_type;
 	struct host_cmd_tlv_passphrase *passphrase;
 	struct host_cmd_tlv_akmp *tlv_akmp;
+	struct mwifiex_ie_types_htcap *htcap;
 	struct mwifiex_uap_bss_param *bss_cfg = cmd_buf;
 	u16 cmd_size = *param_size;
 
@@ -339,6 +367,25 @@ mwifiex_uap_bss_param_prepare(u8 *tlv, void *cmd_buf, u16 *param_size)
 		tlv += sizeof(struct host_cmd_tlv_encrypt_protocol);
 	}
 
+	if (bss_cfg->ht_cap.cap_info) {
+		htcap = (struct mwifiex_ie_types_htcap *)tlv;
+		htcap->header.type = cpu_to_le16(WLAN_EID_HT_CAPABILITY);
+		htcap->header.len =
+				cpu_to_le16(sizeof(struct ieee80211_ht_cap));
+		htcap->ht_cap.cap_info = bss_cfg->ht_cap.cap_info;
+		htcap->ht_cap.ampdu_params_info =
+					     bss_cfg->ht_cap.ampdu_params_info;
+		memcpy(&htcap->ht_cap.mcs, &bss_cfg->ht_cap.mcs,
+		       sizeof(struct ieee80211_mcs_info));
+		htcap->ht_cap.extended_ht_cap_info =
+					bss_cfg->ht_cap.extended_ht_cap_info;
+		htcap->ht_cap.tx_BF_cap_info = bss_cfg->ht_cap.tx_BF_cap_info;
+		htcap->ht_cap.antenna_selection_info =
+					bss_cfg->ht_cap.antenna_selection_info;
+		cmd_size += sizeof(struct mwifiex_ie_types_htcap);
+		tlv += sizeof(struct mwifiex_ie_types_htcap);
+	}
+
 	*param_size = cmd_size;
 
 	return 0;
-- 
1.7.0.2

