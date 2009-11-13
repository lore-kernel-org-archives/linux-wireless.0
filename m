Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31482 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932198AbZKMT4j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2009 14:56:39 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 03/16] iwlwifi: remove unused parameter from iwl_channel_info
Date: Fri, 13 Nov 2009 11:56:25 -0800
Message-Id: <1258142198-3223-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1258142198-3223-1-git-send-email-reinette.chatre@intel.com>
References: <1258142198-3223-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Number of HT40 power parameters are not used; remove those from
iwl_channel_info data structure

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h    |    3 ---
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |    7 -------
 2 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 9dea8fa..d0f0915 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -295,9 +295,6 @@ struct iwl_channel_info {
 
 	/* HT40 channel info */
 	s8 ht40_max_power_avg;	/* (dBm) regul. eeprom, normal Tx, any rate */
-	s8 ht40_curr_txpow;	/* (dBm) regulatory/spectrum/user (not h/w) */
-	s8 ht40_min_power;	/* always 0 */
-	s8 ht40_scan_power;	/* (dBm) eeprom, direct scans, any rate */
 	u8 ht40_flags;		/* flags copied from EEPROM */
 	u8 ht40_extension_channel; /* HT_IE_EXT_CHANNEL_* */
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 143728c..e42eb64 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -751,9 +751,6 @@ static int iwl_mod_ht40_chan_info(struct iwl_priv *priv,
 
 	ch_info->ht40_eeprom = *eeprom_ch;
 	ch_info->ht40_max_power_avg = eeprom_ch->max_power_avg;
-	ch_info->ht40_curr_txpow = eeprom_ch->max_power_avg;
-	ch_info->ht40_min_power = 0;
-	ch_info->ht40_scan_power = eeprom_ch->max_power_avg;
 	ch_info->ht40_flags = eeprom_ch->flags;
 	ch_info->ht40_extension_channel &= ~clear_ht40_extension_channel;
 
@@ -840,8 +837,6 @@ static s8 iwl_update_common_txpower(struct iwl_priv *priv,
 		    (ch_info->ht40_max_power_avg < max_txpower_avg)) {
 			/* Update regulatory-based run-time data */
 			ch_info->ht40_max_power_avg = max_txpower_avg;
-			ch_info->ht40_curr_txpow = max_txpower_avg;
-			ch_info->ht40_scan_power = max_txpower_avg;
 		}
 		ch_info++;
 	}
@@ -881,8 +876,6 @@ static s8 iwl_update_channel_txpower(struct iwl_priv *priv,
 			    (ch_info->ht40_max_power_avg < max_txpower_avg)) {
 				/* Update regulatory-based run-time data */
 				ch_info->ht40_max_power_avg = max_txpower_avg;
-				ch_info->ht40_curr_txpow = max_txpower_avg;
-				ch_info->ht40_scan_power = max_txpower_avg;
 			}
 			break;
 		}
-- 
1.5.6.3

