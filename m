Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:41468 "HELO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751652Ab1KHFl6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 00:41:58 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/7] mwifiex: use existing helper function mwifiex_fill_cap_info
Date: Mon,  7 Nov 2011 21:41:07 -0800
Message-Id: <1320730872-25619-3-git-send-email-bzhao@marvell.com> (sfid-20111108_064201_276469_10C21F07)
In-Reply-To: <1320730872-25619-1-git-send-email-bzhao@marvell.com>
References: <1320730872-25619-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

Use existing helper function mwifiex_fill_cap_info to fill
the HT CAP info for ibss beacons.

Also removing extra parenthesis block for better readability.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/join.c |   81 ++++++++++++++--------------------
 1 files changed, 33 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 062716c..b27bd33 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -724,8 +724,8 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 	u32 cmd_append_size = 0;
 	u32 i;
 	u16 tmp_cap;
-	uint16_t ht_cap_info;
 	struct mwifiex_ie_types_chan_list_param_set *chan_tlv;
+	u8 radio_type;
 
 	struct mwifiex_ie_types_htcap *ht_cap;
 	struct mwifiex_ie_types_htinfo *ht_info;
@@ -914,55 +914,40 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 	}
 
 	if (adapter->adhoc_11n_enabled) {
-		{
-			ht_cap = (struct mwifiex_ie_types_htcap *) pos;
-			memset(ht_cap, 0,
-			       sizeof(struct mwifiex_ie_types_htcap));
-			ht_cap->header.type =
-				cpu_to_le16(WLAN_EID_HT_CAPABILITY);
-			ht_cap->header.len =
-			       cpu_to_le16(sizeof(struct ieee80211_ht_cap));
-
-			ht_cap_info = IEEE80211_HT_CAP_SGI_20;
-			if (adapter->chan_offset) {
-				ht_cap_info |= IEEE80211_HT_CAP_SGI_40;
-				ht_cap_info |= IEEE80211_HT_CAP_DSSSCCK40;
-				ht_cap_info |= IEEE80211_HT_CAP_SUP_WIDTH_20_40;
-				SETHT_MCS32(ht_cap->ht_cap.mcs.rx_mask);
-			}
-			ht_cap->ht_cap.cap_info = cpu_to_le16(ht_cap_info);
-
-			ht_cap->ht_cap.ampdu_params_info
-					= IEEE80211_HT_MAX_AMPDU_64K;
-			ht_cap->ht_cap.mcs.rx_mask[0] = 0xff;
-			pos += sizeof(struct mwifiex_ie_types_htcap);
-			cmd_append_size +=
-				sizeof(struct mwifiex_ie_types_htcap);
-		}
-		{
-			ht_info = (struct mwifiex_ie_types_htinfo *) pos;
-			memset(ht_info, 0,
-			       sizeof(struct mwifiex_ie_types_htinfo));
-			ht_info->header.type =
-				cpu_to_le16(WLAN_EID_HT_INFORMATION);
-			ht_info->header.len =
-				cpu_to_le16(sizeof(struct ieee80211_ht_info));
-			ht_info->ht_info.control_chan =
-				(u8) priv->curr_bss_params.bss_descriptor.
-				channel;
-			if (adapter->chan_offset) {
-				ht_info->ht_info.ht_param =
-					adapter->chan_offset;
-				ht_info->ht_info.ht_param |=
+		/* Fill HT CAPABILITY */
+		ht_cap = (struct mwifiex_ie_types_htcap *) pos;
+		memset(ht_cap, 0, sizeof(struct mwifiex_ie_types_htcap));
+		ht_cap->header.type = cpu_to_le16(WLAN_EID_HT_CAPABILITY);
+		ht_cap->header.len =
+		       cpu_to_le16(sizeof(struct ieee80211_ht_cap));
+		radio_type = mwifiex_band_to_radio_type(
+					priv->adapter->config_bands);
+		mwifiex_fill_cap_info(priv, radio_type, ht_cap);
+
+		pos += sizeof(struct mwifiex_ie_types_htcap);
+		cmd_append_size +=
+			sizeof(struct mwifiex_ie_types_htcap);
+
+		/* Fill HT INFORMATION */
+		ht_info = (struct mwifiex_ie_types_htinfo *) pos;
+		memset(ht_info, 0, sizeof(struct mwifiex_ie_types_htinfo));
+		ht_info->header.type = cpu_to_le16(WLAN_EID_HT_INFORMATION);
+		ht_info->header.len =
+			cpu_to_le16(sizeof(struct ieee80211_ht_info));
+
+		ht_info->ht_info.control_chan =
+			(u8) priv->curr_bss_params.bss_descriptor.channel;
+		if (adapter->chan_offset) {
+			ht_info->ht_info.ht_param = adapter->chan_offset;
+			ht_info->ht_info.ht_param |=
 					IEEE80211_HT_PARAM_CHAN_WIDTH_ANY;
-			}
-			ht_info->ht_info.operation_mode =
-			     cpu_to_le16(IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT);
-			ht_info->ht_info.basic_set[0] = 0xff;
-			pos += sizeof(struct mwifiex_ie_types_htinfo);
-			cmd_append_size +=
-				sizeof(struct mwifiex_ie_types_htinfo);
 		}
+		ht_info->ht_info.operation_mode =
+		     cpu_to_le16(IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT);
+		ht_info->ht_info.basic_set[0] = 0xff;
+		pos += sizeof(struct mwifiex_ie_types_htinfo);
+		cmd_append_size +=
+			sizeof(struct mwifiex_ie_types_htinfo);
 	}
 
 	cmd->size = cpu_to_le16((u16)
-- 
1.7.0.2

