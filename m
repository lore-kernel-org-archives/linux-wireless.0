Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:57492 "HELO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751977Ab2EQEd0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2012 00:33:26 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/3] mwifiex: support NL80211_HIDDEN_SSID_ZERO_LEN for uAP
Date: Wed, 16 May 2012 21:24:55 -0700
Message-Id: <1337228696-22312-2-git-send-email-bzhao@marvell.com> (sfid-20120517_063328_657197_4E8EFCAC)
In-Reply-To: <1337228696-22312-1-git-send-email-bzhao@marvell.com>
References: <1337228696-22312-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

mwifiex uAP supports NL80211_HIDDEN_SSID_ZERO_LEN type of hidden
SSID only. NL80211_HIDDEN_SSID_ZERO_CONTENTS is not supported.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |   13 +++++++++++++
 drivers/net/wireless/mwifiex/fw.h       |    6 ++++++
 drivers/net/wireless/mwifiex/uap_cmd.c  |    9 +++++++++
 3 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 8767144..015fec3 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -948,6 +948,19 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 		bss_cfg->ssid.ssid_len = params->ssid_len;
 	}
 
+	switch (params->hidden_ssid) {
+	case NL80211_HIDDEN_SSID_NOT_IN_USE:
+		bss_cfg->bcast_ssid_ctl = 1;
+		break;
+	case NL80211_HIDDEN_SSID_ZERO_LEN:
+		bss_cfg->bcast_ssid_ctl = 0;
+		break;
+	case NL80211_HIDDEN_SSID_ZERO_CONTENTS:
+		/* firmware doesn't support this type of hidden SSID */
+	default:
+		return -EINVAL;
+	}
+
 	if (mwifiex_set_secure_params(priv, bss_cfg, params)) {
 		kfree(bss_cfg);
 		wiphy_err(wiphy, "Failed to parse secuirty parameters!\n");
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 9f674bb..561452a 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -122,6 +122,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define TLV_TYPE_CHANNELBANDLIST    (PROPRIETARY_TLV_BASE_ID + 42)
 #define TLV_TYPE_UAP_BEACON_PERIOD  (PROPRIETARY_TLV_BASE_ID + 44)
 #define TLV_TYPE_UAP_DTIM_PERIOD    (PROPRIETARY_TLV_BASE_ID + 45)
+#define TLV_TYPE_UAP_BCAST_SSID     (PROPRIETARY_TLV_BASE_ID + 48)
 #define TLV_TYPE_UAP_RTS_THRESHOLD  (PROPRIETARY_TLV_BASE_ID + 51)
 #define TLV_TYPE_UAP_WPA_PASSPHRASE (PROPRIETARY_TLV_BASE_ID + 60)
 #define TLV_TYPE_UAP_ENCRY_PROTOCOL (PROPRIETARY_TLV_BASE_ID + 64)
@@ -1209,6 +1210,11 @@ struct host_cmd_tlv_ssid {
 	u8 ssid[0];
 } __packed;
 
+struct host_cmd_tlv_bcast_ssid {
+	struct host_cmd_tlv tlv;
+	u8 bcast_ctl;
+} __packed;
+
 struct host_cmd_tlv_beacon_period {
 	struct host_cmd_tlv tlv;
 	__le16 period;
diff --git a/drivers/net/wireless/mwifiex/uap_cmd.c b/drivers/net/wireless/mwifiex/uap_cmd.c
index e9482c9..8173ab6 100644
--- a/drivers/net/wireless/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -132,6 +132,7 @@ mwifiex_uap_bss_param_prepare(u8 *tlv, void *cmd_buf, u16 *param_size)
 	struct host_cmd_tlv_dtim_period *dtim_period;
 	struct host_cmd_tlv_beacon_period *beacon_period;
 	struct host_cmd_tlv_ssid *ssid;
+	struct host_cmd_tlv_bcast_ssid *bcast_ssid;
 	struct host_cmd_tlv_channel_band *chan_band;
 	struct host_cmd_tlv_frag_threshold *frag_threshold;
 	struct host_cmd_tlv_rts_threshold *rts_threshold;
@@ -153,6 +154,14 @@ mwifiex_uap_bss_param_prepare(u8 *tlv, void *cmd_buf, u16 *param_size)
 		cmd_size += sizeof(struct host_cmd_tlv) +
 			    bss_cfg->ssid.ssid_len;
 		tlv += sizeof(struct host_cmd_tlv) + bss_cfg->ssid.ssid_len;
+
+		bcast_ssid = (struct host_cmd_tlv_bcast_ssid *)tlv;
+		bcast_ssid->tlv.type = cpu_to_le16(TLV_TYPE_UAP_BCAST_SSID);
+		bcast_ssid->tlv.len =
+				cpu_to_le16(sizeof(bcast_ssid->bcast_ctl));
+		bcast_ssid->bcast_ctl = bss_cfg->bcast_ssid_ctl;
+		cmd_size += sizeof(struct host_cmd_tlv_bcast_ssid);
+		tlv += sizeof(struct host_cmd_tlv_bcast_ssid);
 	}
 	if (bss_cfg->channel && bss_cfg->channel <= MAX_CHANNEL_BAND_BG) {
 		chan_band = (struct host_cmd_tlv_channel_band *)tlv;
-- 
1.7.0.2

