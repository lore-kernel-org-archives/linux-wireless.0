Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:58514 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbcBDJbL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 04:31:11 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>,
	Chris Park <chris.park@atmel.com>
Subject: [PATCH RESEND 42/70] staging: wilc1000: remove unused log message using the CORECONFIG_DBG tag
Date: Thu, 4 Feb 2016 18:24:03 +0900
Message-ID: <1454577871-667-3-git-send-email-glen.lee@atmel.com> (sfid-20160204_103147_512599_681A75FD)
In-Reply-To: <1454577871-667-1-git-send-email-glen.lee@atmel.com>
References: <1454577871-667-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chris Park <chris.park@atmel.com>

This patch remove unused log messages using the CORECONFIG_DBG tag

Signed-off-by: Chris Park <chris.park@atmel.com>
Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c       |  1 -
 drivers/staging/wilc1000/linux_wlan_common.h      |  2 --
 drivers/staging/wilc1000/wilc_debugfs.c           |  2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 20 +-------------------
 4 files changed, 2 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index a0b80bf..11e3ce0 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -315,7 +315,6 @@ s32 wilc_parse_network_info(u8 *msg_buffer, tstrNetworkInfo **ret_network_info)
 		rx_len = wid_len - 1;
 		network_info->u16CapInfo = get_cap_info(msa);
 		network_info->u32Tsf = get_beacon_timestamp_lo(msa);
-		PRINT_D(CORECONFIG_DBG, "TSF :%x\n", network_info->u32Tsf);
 
 		tsf_lo = get_beacon_timestamp_lo(msa);
 		tsf_hi = get_beacon_timestamp_hi(msa);
diff --git a/drivers/staging/wilc1000/linux_wlan_common.h b/drivers/staging/wilc1000/linux_wlan_common.h
index 5d40f05..5e1d3ad 100644
--- a/drivers/staging/wilc1000/linux_wlan_common.h
+++ b/drivers/staging/wilc1000/linux_wlan_common.h
@@ -6,7 +6,6 @@ enum debug_region {
 	Hostapd_debug,
 	Hostinf_debug,
 	CFG80211_debug,
-	Coreconfig_debug,
 	Interrupt_debug,
 	TX_debug,
 	RX_debug,
@@ -24,7 +23,6 @@ enum debug_region {
 #define GENERIC_DBG             (1 << Generic_debug)
 #define HOSTAPD_DBG             (1 << Hostapd_debug)
 #define HOSTINF_DBG             (1 << Hostinf_debug)
-#define CORECONFIG_DBG          (1 << Coreconfig_debug)
 #define CFG80211_DBG            (1 << CFG80211_debug)
 #define INT_DBG                 (1 << Interrupt_debug)
 #define TX_DBG                  (1 << TX_debug)
diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
index 291e6fa..c7e0775 100644
--- a/drivers/staging/wilc1000/wilc_debugfs.c
+++ b/drivers/staging/wilc1000/wilc_debugfs.c
@@ -24,7 +24,7 @@ static struct dentry *wilc_dir;
  * --------------------------------------------------------------------------------
  */
 
-#define DBG_REGION_ALL	(GENERIC_DBG | HOSTAPD_DBG | HOSTINF_DBG | CORECONFIG_DBG | CFG80211_DBG | INT_DBG | TX_DBG | RX_DBG | LOCK_DBG | INIT_DBG | BUS_DBG | MEM_DBG)
+#define DBG_REGION_ALL	(GENERIC_DBG | HOSTAPD_DBG | HOSTINF_DBG | CFG80211_DBG | INT_DBG | TX_DBG | RX_DBG | LOCK_DBG | INIT_DBG | BUS_DBG | MEM_DBG)
 #define DBG_LEVEL_ALL	(DEBUG | INFO | WRN | ERR)
 atomic_t WILC_REGION = ATOMIC_INIT(INIT_DBG | GENERIC_DBG | CFG80211_DBG | FIRM_DBG | HOSTAPD_DBG);
 EXPORT_SYMBOL_GPL(WILC_REGION);
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index dbbf7bf..809dbb5 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -192,7 +192,6 @@ static void clear_shadow_scan(void)
 
 	if (op_ifcs == 0) {
 		del_timer_sync(&hAgingTimer);
-		PRINT_INFO(CORECONFIG_DBG, "destroy aging timer\n");
 
 		for (i = 0; i < last_scanned_cnt; i++) {
 			if (last_scanned_shadow[last_scanned_cnt].pu8IEs) {
@@ -424,8 +423,6 @@ static void CfgScanResult(enum scan_event scan_event,
 						PRINT_D(CFG80211_DBG, "Network %s found\n", network_info->au8ssid);
 						priv->u32RcvdChCount++;
 
-						if (!join_params)
-							PRINT_INFO(CORECONFIG_DBG, ">> Something really bad happened\n");
 						add_network_to_shadow(network_info, priv, join_params);
 
 						if (!(memcmp("DIRECT-", network_info->au8ssid, 7))) {
@@ -762,24 +759,14 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 
 	PRINT_INFO(CFG80211_DBG, "sme->crypto.n_ciphers_pairwise=%d\n", sme->crypto.n_ciphers_pairwise);
 
-	if (INFO) {
-		for (i = 0; i < sme->crypto.n_ciphers_pairwise; i++)
-			PRINT_D(CORECONFIG_DBG, "sme->crypto.ciphers_pairwise[%d]=%x\n", i, sme->crypto.ciphers_pairwise[i]);
-	}
-
 	if (sme->crypto.cipher_group != NO_ENCRYPT) {
 		pcwpa_version = "Default";
-		PRINT_D(CORECONFIG_DBG, ">> sme->crypto.wpa_versions: %x\n", sme->crypto.wpa_versions);
 		if (sme->crypto.cipher_group == WLAN_CIPHER_SUITE_WEP40) {
 			u8security = ENCRYPT_ENABLED | WEP;
 			pcgroup_encrypt_val = "WEP40";
 			pccipher_group = "WLAN_CIPHER_SUITE_WEP40";
 			PRINT_INFO(CFG80211_DBG, "WEP Default Key Idx = %d\n", sme->key_idx);
 
-			if (INFO) {
-				for (i = 0; i < sme->key_len; i++)
-					PRINT_D(CORECONFIG_DBG, "WEP Key Value[%d] = %d\n", i, sme->key[i]);
-			}
 			priv->WILC_WFI_wep_key_len[sme->key_idx] = sme->key_len;
 			memcpy(priv->WILC_WFI_wep_key[sme->key_idx], sme->key, sme->key_len);
 
@@ -1386,9 +1373,6 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 			wilc_enable_tcp_ack_filter(true);
 		else if (strStatistics.link_speed != DEFAULT_LINK_SPEED)
 			wilc_enable_tcp_ack_filter(false);
-
-		PRINT_D(CORECONFIG_DBG, "*** stats[%d][%d][%d][%d][%d]\n", sinfo->signal, sinfo->rx_packets, sinfo->tx_packets,
-			sinfo->tx_failed, sinfo->txrate.legacy);
 	}
 	return 0;
 }
@@ -2716,10 +2700,8 @@ int wilc_deinit_host_int(struct net_device *net)
 	s32Error = wilc_deinit(vif);
 
 	clear_shadow_scan();
-	if (op_ifcs == 0) {
-		PRINT_D(CORECONFIG_DBG, "destroy during ip\n");
+	if (op_ifcs == 0)
 		del_timer_sync(&wilc_during_ip_timer);
-	}
 
 	if (s32Error)
 		netdev_err(net, "Error while deintializing host interface\n");
-- 
1.9.1

