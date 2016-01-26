Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:17399 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933448AbcAZIbD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 03:31:03 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Nikolay Martynov <mar.kolya@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "Berg, Johannes" <johannes.berg@intel.com>,
	"julian.calaby@gmail.com" <julian.calaby@gmail.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: Re: [PATCH v2] iwldvm: fix chain gain calibration when firmware
 return zero values
Date: Tue, 26 Jan 2016 08:28:59 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32E9D2EC6@hasmsx109.ger.corp.intel.com> (sfid-20160126_093108_583378_8F915D82)
References: <1453527309-23881-1-git-send-email-mar.kolya@gmail.com>
 <1453760341-30008-1-git-send-email-mar.kolya@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 01/26/2016 12:20 AM, Nikolay Martynov wrote:
> It looks like sometimes firmware returns zero for chain noise and signal
> during calibration period. This seems to be a known problem and current
> implementation accounts for this by ignoring invalid data when all chains
> return zero signal and noise.
>
> The problem is that sometimes firmware returns zero for only one chain for
> some (not all) beacons used for calibration. This leads to perfectly valid
> chains be disabled and may cause invalid gain settings.
> For example this is calibration data taken on laptop with Intel 6300 card
> with all three antennas attached:
>
> active_chains:			 3
> chain_noise_a:			 312
> chain_noise_b:			 297
> chain_noise_c:			 0
> chain_signal_a:			 549
> chain_signal_b:			 513
> chain_signal_c:			 0
> beacon_count:			 16
> disconn_array:			 0 0 1
> delta_gain_code:		 4 0 0
> radio_write:			 1
> state:				 3
>
> This patch changes statistics gathering to make sure that zero noise
> results are ignored for valid rx chains. The rationale being that even if
> anntenna is not connected we should be able to see non zero noise if rx
> chain is present.

But then the firmware will continue to send zero for signal and this
will impact lots
of flows like roaming. If the driver allows the firmware to use that
antenna, the
firmware may use this antenna for scanning and roaming will be broken.
This seems to be a bug in the firmware, but there isn't much I can do
about it.
Sorry, I have to NACK this patch.

> This patch fixes the problem of disabling working chains on hardware I
> have (6300 and 5300). With three connected antennas statistics in
> chain_noise looks like this (6300):
>
> active_chains:			 7
> chain_noise_a:			 321
> chain_noise_b:			 243
> chain_noise_c:			 311
> chain_signal_a:			 559
> chain_signal_b:			 452
> chain_signal_c:			 512
> beacon_count:			 16
> disconn_array:			 0 0 0
> delta_gain_code:		 4 3 0
> radio_write:			 1
> state:				 3
>
> It also works fine in case one 3-chain hardware has only two antennas
> attached (tested in 5300):
>
> active_chains:			 3
> chain_noise_a:			 238
> chain_noise_b:			 234
> chain_noise_c:			 219
> chain_signal_a:			 533
> chain_signal_b:			 514
> chain_signal_c:			 206
> beacon_count:			 16
> disconn_array:			 0 0 1
> delta_gain_code:		 4 0 0
> radio_write:			 1
> state:				 3
>
> Signed-off-by: Nikolay Martynov <mar.kolya@gmail.com>
> ---
>  drivers/net/wireless/iwlwifi/dvm/calib.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/drivers/net/wireless/iwlwifi/dvm/calib.c b/drivers/net/wireless/iwlwifi/dvm/calib.c
> index 20e6aa9..cdaa88d 100644
> --- a/drivers/net/wireless/iwlwifi/dvm/calib.c
> +++ b/drivers/net/wireless/iwlwifi/dvm/calib.c
> @@ -1026,6 +1026,18 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv)
>  
>  	spin_unlock_bh(&priv->statistics.lock);
>  
> +	/* Sometimes firmware returns zero for chain noise and signal
> +	 * even if chain is present and antenna is connected. This
> +	 * often results in perfectly valid chains being disabled.
> +	 * Ignore statistics if it contains zero noise for valid rx
> +	 * chain: even with antenna disconnected we should hear some noise.
> +	 */
> +	if ((priv->nvm_data->valid_rx_ant & ANT_A && chain_noise_a == 0) ||
> +	    (priv->nvm_data->valid_rx_ant & ANT_B && chain_noise_b == 0) ||
> +	    (priv->nvm_data->valid_rx_ant & ANT_C && chain_noise_c == 0)) {
> +		return;
> +	}
> +
>  	data->beacon_count++;
>  
>  	data->chain_noise_a = (chain_noise_a + data->chain_noise_a);

