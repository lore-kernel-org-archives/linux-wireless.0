Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:58717 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334Ab1JNUog (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Oct 2011 16:44:36 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/6] iwlagn: update wowlan API
Date: Fri, 14 Oct 2011 12:54:43 -0700
Message-Id: <1318622088-14679-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111014_224440_311355_91FE2141)
In-Reply-To: <1318622088-14679-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1318622088-14679-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The WoWLAN API changed due to netdetect and
we now have a more generic "D3 configuration"
command that enables the sysassert & rfkill
wakeup triggers.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   13 ++++++++++---
 drivers/net/wireless/iwlwifi/iwl-commands.h |   27 +++++++++++++++++++--------
 2 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index ccba69b..47dbcca 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2028,6 +2028,7 @@ static int iwlagn_mac_suspend(struct ieee80211_hw *hw,
 		.tkip = &tkip_cmd,
 		.use_tkip = false,
 	};
+	struct iwlagn_d3_config_cmd d3_cfg_cmd = {};
 	int ret, i;
 	u16 seq;
 
@@ -2085,13 +2086,14 @@ static int iwlagn_mac_suspend(struct ieee80211_hw *hw,
 	if (wowlan->four_way_handshake)
 		wakeup_filter_cmd.enabled |=
 			cpu_to_le32(IWLAGN_WOWLAN_WAKEUP_4WAY_HANDSHAKE);
-	if (wowlan->rfkill_release)
-		wakeup_filter_cmd.enabled |=
-			cpu_to_le32(IWLAGN_WOWLAN_WAKEUP_RFKILL);
 	if (wowlan->n_patterns)
 		wakeup_filter_cmd.enabled |=
 			cpu_to_le32(IWLAGN_WOWLAN_WAKEUP_PATTERN_MATCH);
 
+	if (wowlan->rfkill_release)
+		d3_cfg_cmd.wakeup_flags |=
+			cpu_to_le32(IWLAGN_D3_WAKEUP_RFKILL);
+
 	iwl_scan_cancel_timeout(priv, 200);
 
 	memcpy(&rxon, &ctx->active, sizeof(rxon));
@@ -2179,6 +2181,11 @@ static int iwlagn_mac_suspend(struct ieee80211_hw *hw,
 		}
 	}
 
+	ret = iwl_trans_send_cmd_pdu(trans(priv), REPLY_D3_CONFIG, CMD_SYNC,
+				     sizeof(d3_cfg_cmd), &d3_cfg_cmd);
+	if (ret)
+		goto error;
+
 	ret = iwl_trans_send_cmd_pdu(trans(priv), REPLY_WOWLAN_WAKEUP_FILTER,
 				 CMD_SYNC, sizeof(wakeup_filter_cmd),
 				 &wakeup_filter_cmd);
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 69d5f85..f4eccf5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -198,6 +198,7 @@ enum {
 	REPLY_WOWLAN_TKIP_PARAMS = 0xe3,
 	REPLY_WOWLAN_KEK_KCK_MATERIAL = 0xe4,
 	REPLY_WOWLAN_GET_STATUS = 0xe5,
+	REPLY_D3_CONFIG = 0xd3,
 
 	REPLY_MAX = 0xff
 };
@@ -3801,6 +3802,19 @@ struct iwl_bt_coex_prot_env_cmd {
 } __attribute__((packed));
 
 /*
+ * REPLY_D3_CONFIG
+ */
+enum iwlagn_d3_wakeup_filters {
+	IWLAGN_D3_WAKEUP_RFKILL		= BIT(0),
+	IWLAGN_D3_WAKEUP_SYSASSERT	= BIT(1),
+};
+
+struct iwlagn_d3_config_cmd {
+	__le32 min_sleep_time;
+	__le32 wakeup_flags;
+} __packed;
+
+/*
  * REPLY_WOWLAN_PATTERNS
  */
 #define IWLAGN_WOWLAN_MIN_PATTERN_LEN	16
@@ -3830,19 +3844,16 @@ enum iwlagn_wowlan_wakeup_filters {
 	IWLAGN_WOWLAN_WAKEUP_BEACON_MISS	= BIT(2),
 	IWLAGN_WOWLAN_WAKEUP_LINK_CHANGE	= BIT(3),
 	IWLAGN_WOWLAN_WAKEUP_GTK_REKEY_FAIL	= BIT(4),
-	IWLAGN_WOWLAN_WAKEUP_RFKILL		= BIT(5),
-	IWLAGN_WOWLAN_WAKEUP_UCODE_ERROR	= BIT(6),
-	IWLAGN_WOWLAN_WAKEUP_EAP_IDENT_REQ	= BIT(7),
-	IWLAGN_WOWLAN_WAKEUP_4WAY_HANDSHAKE	= BIT(8),
-	IWLAGN_WOWLAN_WAKEUP_ALWAYS		= BIT(9),
-	IWLAGN_WOWLAN_WAKEUP_ENABLE_NET_DETECT	= BIT(10),
+	IWLAGN_WOWLAN_WAKEUP_EAP_IDENT_REQ	= BIT(5),
+	IWLAGN_WOWLAN_WAKEUP_4WAY_HANDSHAKE	= BIT(6),
+	IWLAGN_WOWLAN_WAKEUP_ALWAYS		= BIT(7),
+	IWLAGN_WOWLAN_WAKEUP_ENABLE_NET_DETECT	= BIT(8),
 };
 
 struct iwlagn_wowlan_wakeup_filter_cmd {
 	__le32 enabled;
 	__le16 non_qos_seq;
-	u8 min_sleep_seconds;
-	u8 reserved;
+	__le16 reserved;
 	__le16 qos_seq[8];
 };
 
-- 
1.7.0.4

