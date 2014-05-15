Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:34066 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862AbaEORFX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 13:05:23 -0400
Received: by mail-we0-f182.google.com with SMTP id t60so1406776wes.13
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 10:05:22 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 18/24] iwlwifi: mvm: enable RX chain diversity if needed
Date: Thu, 15 May 2014 20:04:35 +0300
Message-Id: <1400173481-9047-18-git-send-email-egrumbach@gmail.com> (sfid-20140515_190607_636067_2B6506F6)
In-Reply-To: <5374F373.6040902@gmail.com>
References: <5374F373.6040902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In some situations (see comment) it makes sense to enable both
chains (if available) to get better throughput by having chain
diversity available.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
index 4902f3b..acb79af 100644
--- a/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
@@ -156,6 +156,19 @@ static void iwl_mvm_phy_ctxt_cmd_data(struct iwl_mvm *mvm,
 	idle_cnt = chains_static;
 	active_cnt = chains_dynamic;
 
+	/* In scenarios where we only ever use a single-stream rates,
+	 * i.e. legacy 11b/g/a associations, single-stream APs or even
+	 * static SMPS, enable both chains to get diversity, improving
+	 * the case where we're far enough from the AP that attenuation
+	 * between the two antennas is sufficiently different to impact
+	 * performance.
+	 */
+	if (active_cnt == 1 && num_of_ant(mvm->fw->valid_rx_ant) > 1 &&
+	    !mvm->cfg->rx_with_siso_diversity) {
+		idle_cnt = 2;
+		active_cnt = 2;
+	}
+
 	cmd->rxchain_info = cpu_to_le32(mvm->fw->valid_rx_ant <<
 					PHY_RX_CHAIN_VALID_POS);
 	cmd->rxchain_info |= cpu_to_le32(idle_cnt << PHY_RX_CHAIN_CNT_POS);
-- 
1.8.3.2

