Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:61216 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758513Ab0AOVnM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jan 2010 16:43:12 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>, stable@kernel.org
Subject: [PATCH 1/2] iwlwifi: Fix throughput stall issue in HT mode for 5000
Date: Fri, 15 Jan 2010 13:42:58 -0800
Message-Id: <1263591779-14785-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1263591779-14785-1-git-send-email-reinette.chatre@intel.com>
References: <1263591779-14785-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Similar to 6000 and 1000 series, RTS/CTS is the recommended protection
mechanism for 5000 series in HT mode based on the HW design.

Using RTS/CTS will better protect the inner exchange from interference,
especially in highly-congested environment, it also prevent uCode encounter
TX FIFO underrun and other HT mode related performance issues.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
CC: stable@kernel.org
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 33a5866..de45f30 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1598,6 +1598,7 @@ struct iwl_cfg iwl5300_agn_cfg = {
 	.use_bsm = false,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
+	.use_rts_for_ht = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.sm_ps_mode = WLAN_HT_CAP_SM_PS_DISABLED,
 };
@@ -1622,6 +1623,7 @@ struct iwl_cfg iwl5100_bgn_cfg = {
 	.use_bsm = false,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
+	.use_rts_for_ht = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 };
 
@@ -1667,6 +1669,7 @@ struct iwl_cfg iwl5100_agn_cfg = {
 	.use_bsm = false,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
+	.use_rts_for_ht = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.sm_ps_mode = WLAN_HT_CAP_SM_PS_DISABLED,
 };
@@ -1691,6 +1694,7 @@ struct iwl_cfg iwl5350_agn_cfg = {
 	.use_bsm = false,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
+	.use_rts_for_ht = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.sm_ps_mode = WLAN_HT_CAP_SM_PS_DISABLED,
 };
@@ -1715,6 +1719,7 @@ struct iwl_cfg iwl5150_agn_cfg = {
 	.use_bsm = false,
 	.ht_greenfield_support = true,
 	.led_compensation = 51,
+	.use_rts_for_ht = true, /* use rts/cts protection */
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.sm_ps_mode = WLAN_HT_CAP_SM_PS_DISABLED,
 };
-- 
1.6.3.3

