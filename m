Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:33546 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbcAWFfx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jan 2016 00:35:53 -0500
Received: by mail-io0-f175.google.com with SMTP id q21so108407445iod.0
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jan 2016 21:35:53 -0800 (PST)
From: Nikolay Martynov <mar.kolya@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Nikolay Martynov <mar.kolya@gmail.com>, johannes.berg@intel.com,
	wey-yi.w.guy@intel.com, ilw@linux.intel.com
Subject: [PATCH] iwldvm: fix chain gain calibration when firmware return zero values
Date: Sat, 23 Jan 2016 00:35:09 -0500
Message-Id: <1453527309-23881-1-git-send-email-mar.kolya@gmail.com> (sfid-20160123_063557_927421_F0A57B2F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Nikolay Martynov <(none)>

It looks like sometimes firmware returns zero for chain noise and signal
during calibration period. This seems to be a known problem and current
implementation accounts for this by ignoring invalid data when all chains
return zero signal and noise.

The problem is that sometimes firmware returns zero for only one chain for
some (not all) beacons used for calibration. This leads to perfectly valid
chains be disabled and may cause invalid gain settings.
For example this is calibration data taken on laptop with Intel 6300 card
with all three antennas attached:

active_chains:			 3
chain_noise_a:			 312
chain_noise_b:			 297
chain_noise_c:			 0
chain_signal_a:			 549
chain_signal_b:			 513
chain_signal_c:			 0
beacon_count:			 16
disconn_array:			 0 0 1
delta_gain_code:		 4 0 0
radio_write:			 1
state:				 3

This patch changes statistics gathering to make sure that zero noise
results are ignored for valid rx chains. The rationale being that even if
anntenna is not connected we should be able to see non zero noise if rx
chain is present.

This patch fixes the problem of disabling working chains on hardware I
have (6300 and 5300). It also works fine in case one 3-chain hardware has
only two antennas attached.

Signed-off-by: Nikolay Martynov <mar.kolya@gmail.com>
---
 drivers/net/wireless/iwlwifi/dvm/calib.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/dvm/calib.c b/drivers/net/wireless/iwlwifi/dvm/calib.c
index 20e6aa9..59e73e2 100644
--- a/drivers/net/wireless/iwlwifi/dvm/calib.c
+++ b/drivers/net/wireless/iwlwifi/dvm/calib.c
@@ -1026,6 +1026,18 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv)
 
 	spin_unlock_bh(&priv->statistics.lock);
 
+	/* Sometimes firmware returns zero for chain noise and signal
+	 * even if chain is present and antenna is connected. This
+	 * often results in perfectly valid chains being disabled.
+	 * Ignore statistics if it contains zero noise for valid rx
+	 * chain: even with antenna disconnected we should hear some noise.
+	 */
+	if (((priv->nvm_data->valid_rx_ant & (1 << 0)) && chain_noise_a == 0) ||
+	    ((priv->nvm_data->valid_rx_ant & (2 << 0)) && chain_noise_b == 0) ||
+	    ((priv->nvm_data->valid_rx_ant & (3 << 0)) && chain_noise_c == 0)) {
+		return;
+	}
+
 	data->beacon_count++;
 
 	data->chain_noise_a = (chain_noise_a + data->chain_noise_a);
-- 
2.7.0

