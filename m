Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:40212 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318Ab0LIAUw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Dec 2010 19:20:52 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: remove struct ieeetypes_sub_band_set from ieee.h
Date: Wed,  8 Dec 2010 16:20:50 -0800
Message-Id: <1291854050-5939-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

use "struct ieee80211_country_ie_triplet" instead.
Also remove "enum MWIFIEX_802_11_NETWORK_TYPE"
and bss_desc->network_type_use.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c    |   35 ++++++++++++---------------
 drivers/net/wireless/mwifiex/fw.h          |    2 +-
 drivers/net/wireless/mwifiex/ieee.h        |   17 +------------
 drivers/net/wireless/mwifiex/join.c        |    2 -
 drivers/net/wireless/mwifiex/main.h        |    5 ++-
 drivers/net/wireless/mwifiex/scan.c        |    2 -
 drivers/net/wireless/mwifiex/sta_cmd.c     |   17 ++++++-------
 drivers/net/wireless/mwifiex/sta_cmdresp.c |   16 ++++++------
 8 files changed, 38 insertions(+), 58 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 4a42493..7861cb7 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1658,10 +1658,11 @@ mwifiex_11d_set_domain_info(struct mwifiex_private *priv)
  */
 void mwifiex_send_domain_info_cmd_fw(struct wiphy *wiphy)
 {
-	u8   no_of_sub_band = 0;
-	u8   no_of_parsed_chan = 0;
-	u8   first_chan = 0, next_chan = 0, max_pwr = 0;
-	u8   i, flag = 0;
+	u8 no_of_triplet = 0;
+	struct ieee80211_country_ie_triplet *t;
+	u8 no_of_parsed_chan = 0;
+	u8 first_chan = 0, next_chan = 0, max_pwr = 0;
+	u8 i, flag = 0;
 	enum ieee80211_band band;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *ch;
@@ -1704,13 +1705,11 @@ void mwifiex_send_domain_info_cmd_fw(struct wiphy *wiphy)
 			next_chan++;
 			no_of_parsed_chan++;
 		} else {
-			domain_info->sub_band[no_of_sub_band]
-				.first_chan = first_chan;
-			domain_info->sub_band[no_of_sub_band]
-				.no_of_chan = no_of_parsed_chan;
-			domain_info->sub_band[no_of_sub_band]
-				.max_tx_pwr = max_pwr;
-			no_of_sub_band++;
+			t = &domain_info->triplet[no_of_triplet];
+			t->chans.first_channel = first_chan;
+			t->chans.num_channels = no_of_parsed_chan;
+			t->chans.max_power = max_pwr;
+			no_of_triplet++;
 			first_chan = (u32) ch->hw_value;
 			next_chan = first_chan;
 			max_pwr = ch->max_power;
@@ -1719,16 +1718,14 @@ void mwifiex_send_domain_info_cmd_fw(struct wiphy *wiphy)
 	}
 
 	if (flag) {
-		domain_info->sub_band[no_of_sub_band]
-			.first_chan = first_chan;
-		domain_info->sub_band[no_of_sub_band]
-			.no_of_chan = no_of_parsed_chan;
-		domain_info->sub_band[no_of_sub_band]
-			.max_tx_pwr = max_pwr;
-		no_of_sub_band++;
+		t = &domain_info->triplet[no_of_triplet];
+		t->chans.first_channel = first_chan;
+		t->chans.num_channels = no_of_parsed_chan;
+		t->chans.max_power = max_pwr;
+		no_of_triplet++;
 	}
 
-	domain_info->no_of_sub_band = no_of_sub_band;
+	domain_info->no_of_triplet = no_of_triplet;
 	/* Set domain info */
 	ret = mwifiex_11d_set_domain_info(priv);
 	if (ret)
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 95b3d2f..d8f4011 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -1083,7 +1083,7 @@ struct host_cmd_ds_802_11_bg_scan_query_rsp {
 struct mwifiex_ietypes_domain_param_set {
 	struct mwifiex_ie_types_header header;
 	u8 country_code[COUNTRY_CODE_LEN];
-	struct ieeetypes_sub_band_set sub_band[1];
+	struct ieee80211_country_ie_triplet triplet[1];
 } __attribute__ ((packed));
 
 struct host_cmd_ds_802_11d_domain_info {
diff --git a/drivers/net/wireless/mwifiex/ieee.h b/drivers/net/wireless/mwifiex/ieee.h
index ed9e03d..3245f17 100644
--- a/drivers/net/wireless/mwifiex/ieee.h
+++ b/drivers/net/wireless/mwifiex/ieee.h
@@ -24,12 +24,6 @@
 
 #define MWIFIEX_SUPPORTED_RATES_EXT             32
 
-enum MWIFIEX_802_11_NETWORK_TYPE {
-	MWIFIEX_802_11_FH,
-	MWIFIEX_802_11_DS,
-	MWIFIEX_802_11_NETWORK_TYPE_MAX
-};
-
 #define IEEE_MAX_IE_SIZE			256
 
 struct ieee_types_header {
@@ -222,14 +216,8 @@ struct ieee_types_wmm_parameter {
 	struct ieee_types_wmm_ac_parameters ac_params[IEEE80211_MAX_QUEUES];
 } __attribute__ ((packed));
 
-#define MWIFIEX_MAX_SUBBAND_802_11D              83
-#define COUNTRY_CODE_LEN                        3
-
-struct ieeetypes_sub_band_set {
-	u8 first_chan;
-	u8 no_of_chan;
-	u8 max_tx_pwr;
-} __attribute__ ((packed));
+#define MWIFIEX_MAX_TRIPLET_802_11D		83
+#define COUNTRY_CODE_LEN			3
 
 struct ieee_htcap {
 	__le16 ht_cap_info;
@@ -301,7 +289,6 @@ struct mwifiex_bssdescriptor {
 	u16 beacon_period;
 	u32 atim_window;
 	u8 erp_flags;
-	enum MWIFIEX_802_11_NETWORK_TYPE network_type_use;
 	u32 bss_mode;
 	u8 supported_rates[MWIFIEX_SUPPORTED_RATES];
 	u8 data_rates[MWIFIEX_SUPPORTED_RATES];
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 917f368..2888f54 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -973,8 +973,6 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 	       &adhoc_start->phy_param_set,
 	       sizeof(union ieee_types_phy_param_set));
 
-	bss_desc->network_type_use = MWIFIEX_802_11_DS;
-
 	/* Set IBSS param set */
 /** IBSS parameter IE Id */
 #define IBSS_PARA_IE_ID   6
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 285cbc0..620616a 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -303,8 +303,9 @@ enum state_11d_t {
 
 struct mwifiex_802_11d_domain_reg {
 	u8 country_code[COUNTRY_CODE_LEN];
-	u8 no_of_sub_band;
-	struct ieeetypes_sub_band_set sub_band[MWIFIEX_MAX_SUBBAND_802_11D];
+	u8 no_of_triplet;
+	struct ieee80211_country_ie_triplet
+		triplet[MWIFIEX_MAX_TRIPLET_802_11D];
 };
 
 struct mwifiex_vendor_spec_cfg_ie {
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 8ed3677..d69a6cb 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1497,7 +1497,6 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 		case WLAN_EID_FH_PARAMS:
 			fh_param_set =
 				(struct ieee_types_fh_param_set *) current_ptr;
-			bss_entry->network_type_use = MWIFIEX_802_11_FH;
 			memcpy(&bss_entry->phy_param_set.fh_param_set,
 			       fh_param_set,
 			       sizeof(struct ieee_types_fh_param_set));
@@ -1507,7 +1506,6 @@ mwifiex_interpret_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 			ds_param_set =
 				(struct ieee_types_ds_param_set *) current_ptr;
 
-			bss_entry->network_type_use = MWIFIEX_802_11_DS;
 			bss_entry->channel = ds_param_set->current_chan;
 
 			memcpy(&bss_entry->phy_param_set.ds_param_set,
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 955b960..9a87a2a 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -965,11 +965,11 @@ mwifiex_cmd_802_11d_domain_info(struct mwifiex_private *priv,
 		&cmd->params.domain_info;
 	struct mwifiex_ietypes_domain_param_set *domain =
 		&domain_info->domain;
-	u8 no_of_sub_band = adapter->domain_reg.no_of_sub_band;
+	u8 no_of_triplet = adapter->domain_reg.no_of_triplet;
 
 	ENTER();
 
-	PRINTM(MINFO, "11D: no_of_sub_band=0x%x\n", no_of_sub_band);
+	PRINTM(MINFO, "11D: no_of_triplet=0x%x\n", no_of_triplet);
 
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11D_DOMAIN_INFO);
 	domain_info->action = cpu_to_le16(cmd_action);
@@ -989,15 +989,14 @@ mwifiex_cmd_802_11d_domain_info(struct mwifiex_private *priv,
 			adapter->domain_reg.country_code,
 			sizeof(domain->country_code));
 
-	domain->header.len = cpu_to_le16((no_of_sub_band *
-				sizeof(struct ieeetypes_sub_band_set)) +
+	domain->header.len = cpu_to_le16((no_of_triplet *
+				sizeof(struct ieee80211_country_ie_triplet)) +
 			sizeof(domain->country_code));
 
-	if (no_of_sub_band) {
-		memcpy(domain->sub_band,
-				adapter->domain_reg.sub_band,
-				no_of_sub_band *
-				sizeof(struct ieeetypes_sub_band_set));
+	if (no_of_triplet) {
+		memcpy(domain->triplet, adapter->domain_reg.triplet,
+				no_of_triplet *
+				sizeof(struct ieee80211_country_ie_triplet));
 
 		cmd->size = cpu_to_le16(sizeof(domain_info->action) +
 				le16_to_cpu(domain->header.len) +
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index ed8e1aa..d5b8ef0 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -1074,26 +1074,26 @@ mwifiex_ret_802_11d_domain_info(struct mwifiex_private *priv,
 		&resp->params.domain_info_resp;
 	struct mwifiex_ietypes_domain_param_set *domain = &domain_info->domain;
 	u16 action = le16_to_cpu(domain_info->action);
-	u8 no_of_sub_band = 0;
+	u8 no_of_triplet = 0;
 
 	ENTER();
 
 	/* Dump domain info response data */
 	HEXDUMP("11D: DOMAIN Info Rsp Data", (u8 *) resp, resp->size);
 
-	no_of_sub_band =
+	no_of_triplet =
 		(u8) ((le16_to_cpu(domain->header.len) -
 					3) / sizeof(struct
-					ieeetypes_sub_band_set));
+					ieee80211_country_ie_triplet));
 	/* Country code is 3 bytes */
 
-	PRINTM(MINFO, "11D Domain Info Resp: no_of_sub_band=%d\n",
-					no_of_sub_band);
+	PRINTM(MINFO, "11D Domain Info Resp: no_of_triplet=%d\n",
+					no_of_triplet);
 
-	if (no_of_sub_band > MWIFIEX_MAX_SUBBAND_802_11D) {
-		PRINTM(MWARN, "11D: Invalid number of subbands %d "
+	if (no_of_triplet > MWIFIEX_MAX_TRIPLET_802_11D) {
+		PRINTM(MWARN, "11D: Invalid number of triplets %d "
 				"returned!!\n",
-				no_of_sub_band);
+				no_of_triplet);
 		LEAVE();
 		return MWIFIEX_STATUS_FAILURE;
 	}
-- 
1.7.0.2

