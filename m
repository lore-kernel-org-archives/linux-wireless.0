Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20333 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758088Ab2CGTG1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 14:06:27 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 01/35] iwlwifi: remove unused arguments from iwlagn_gain_computation
Date: Wed,  7 Mar 2012 09:52:10 -0800
Message-Id: <1331142764-5750-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120307_200731_720819_F8FED719)
In-Reply-To: <1331142764-5750-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331142764-5750-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The function has two arguments it never uses,
remove them.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index 579679e..84cbe7b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -879,10 +879,8 @@ static void iwl_find_disconn_antenna(struct iwl_priv *priv, u32* average_sig,
 }
 
 static void iwlagn_gain_computation(struct iwl_priv *priv,
-		u32 average_noise[NUM_RX_CHAINS],
-		u16 min_average_noise_antenna_i,
-		u32 min_average_noise,
-		u8 default_chain)
+				    u32 average_noise[NUM_RX_CHAINS],
+				    u8 default_chain)
 {
 	int i;
 	s32 delta_g;
@@ -1087,7 +1085,6 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv)
 			min_average_noise, min_average_noise_antenna_i);
 
 	iwlagn_gain_computation(priv, average_noise,
-				min_average_noise_antenna_i, min_average_noise,
 				find_first_chain(hw_params(priv).valid_rx_ant));
 
 	/* Some power changes may have been made during the calibration.
-- 
1.7.0.4

