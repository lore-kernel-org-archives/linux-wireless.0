Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:33740 "EHLO
	mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084AbcAYWTm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2016 17:19:42 -0500
Received: by mail-io0-f194.google.com with SMTP id f81so14335315iof.0
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jan 2016 14:19:42 -0800 (PST)
From: Nikolay Martynov <mar.kolya@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Nikolay Martynov <mar.kolya@gmail.com>, johannes.berg@intel.com,
	emmanuel.grumbach@intel.com, julian.calaby@gmail.com,
	ilw@linux.intel.com
Subject: [PATCH v2] iwldvm: fix chain gain calibration when firmware return zero values
Date: Mon, 25 Jan 2016 17:19:01 -0500
Message-Id: <1453760341-30008-1-git-send-email-mar.kolya@gmail.com> (sfid-20160125_231946_413409_76303A30)
In-Reply-To: <1453527309-23881-1-git-send-email-mar.kolya@gmail.com>
References: <1453527309-23881-1-git-send-email-mar.kolya@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
have (6300 and 5300). With three connected antennas statistics in
chain_noise looks like this (6300):

active_chains:			 7
chain_noise_a:			 321
chain_noise_b:			 243
chain_noise_c:			 311
chain_signal_a:			 559
chain_signal_b:			 452
chain_signal_c:			 512
beacon_count:			 16
disconn_array:			 0 0 0
delta_gain_code:		 4 3 0
radio_write:			 1
state:				 3

It also works fine in case one 3-chain hardware has only two antennas
attached (tested in 5300):

active_chains:			 3
chain_noise_a:			 238
chain_noise_b:			 234
chain_noise_c:			 219
chain_signal_a:			 533
chain_signal_b:			 514
chain_signal_c:			 206
beacon_count:			 16
disconn_array:			 0 0 1
delta_gain_code:		 4 0 0
radio_write:			 1
state:				 3

Signed-off-by: Nikolay Martynov <mar.kolya@gmail.com>
---
 drivers/net/wireless/iwlwifi/dvm/calib.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/dvm/calib.c b/drivers/net/wireless/iwlwifi/dvm/calib.c
index 20e6aa9..cdaa88d 100644
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
+	if ((priv->nvm_data->valid_rx_ant & ANT_A && chain_noise_a == 0) ||
+	    (priv->nvm_data->valid_rx_ant & ANT_B && chain_noise_b == 0) ||
+	    (priv->nvm_data->valid_rx_ant & ANT_C && chain_noise_c == 0)) {
+		return;
+	}
+
 	data->beacon_count++;
 
 	data->chain_noise_a = (chain_noise_a + data->chain_noise_a);
-- 
2.7.0

