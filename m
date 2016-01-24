Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:36260 "EHLO
	mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbcAXUHc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jan 2016 15:07:32 -0500
Received: by mail-lf0-f43.google.com with SMTP id h129so74100361lfh.3
        for <linux-wireless@vger.kernel.org>; Sun, 24 Jan 2016 12:07:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1453527309-23881-1-git-send-email-mar.kolya@gmail.com>
References: <1453527309-23881-1-git-send-email-mar.kolya@gmail.com>
Date: Sun, 24 Jan 2016 22:07:30 +0200
Message-ID: <CANUX_P3FyFOu5gfyOq8aGk9AkUN=PVx8jbgcf3_0tegBWszEjQ@mail.gmail.com> (sfid-20160124_210735_982641_B8EB6328)
Subject: Re: [PATCH] iwldvm: fix chain gain calibration when firmware return
 zero values
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Nikolay Martynov <mar.kolya@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Berg, Johannes" <johannes.berg@intel.com>,
	linuxwifi <linuxwifi@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Note that Wey-Yi has stepped down from maintaining iwlwifi for a while now.

On Sat, Jan 23, 2016 at 7:35 AM, Nikolay Martynov <mar.kolya@gmail.com> wrote:
> From: Nikolay Martynov <(none)>
>
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
> active_chains:                   3
> chain_noise_a:                   312
> chain_noise_b:                   297
> chain_noise_c:                   0
> chain_signal_a:                  549
> chain_signal_b:                  513
> chain_signal_c:                  0
> beacon_count:                    16
> disconn_array:                   0 0 1
> delta_gain_code:                 4 0 0
> radio_write:                     1
> state:                           3
>
> This patch changes statistics gathering to make sure that zero noise
> results are ignored for valid rx chains. The rationale being that even if
> anntenna is not connected we should be able to see non zero noise if rx
> chain is present.
>
> This patch fixes the problem of disabling working chains on hardware I
> have (6300 and 5300). It also works fine in case one 3-chain hardware has
> only two antennas attached.

So how will that work if an antenna is disconnected? You always seem
to ignore the sampling that returned 0.

>
> Signed-off-by: Nikolay Martynov <mar.kolya@gmail.com>
> ---
>  drivers/net/wireless/iwlwifi/dvm/calib.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/drivers/net/wireless/iwlwifi/dvm/calib.c b/drivers/net/wireless/iwlwifi/dvm/calib.c
> index 20e6aa9..59e73e2 100644
> --- a/drivers/net/wireless/iwlwifi/dvm/calib.c
> +++ b/drivers/net/wireless/iwlwifi/dvm/calib.c
> @@ -1026,6 +1026,18 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv)
>
>         spin_unlock_bh(&priv->statistics.lock);
>
> +       /* Sometimes firmware returns zero for chain noise and signal
> +        * even if chain is present and antenna is connected. This
> +        * often results in perfectly valid chains being disabled.
> +        * Ignore statistics if it contains zero noise for valid rx
> +        * chain: even with antenna disconnected we should hear some noise.
> +        */
> +       if (((priv->nvm_data->valid_rx_ant & (1 << 0)) && chain_noise_a == 0) ||
> +           ((priv->nvm_data->valid_rx_ant & (2 << 0)) && chain_noise_b == 0) ||
> +           ((priv->nvm_data->valid_rx_ant & (3 << 0)) && chain_noise_c == 0)) {
> +               return;
> +       }

I guess this is a typo, you wanted BIT(1), BIT(2) and BIT(3), right?

> +
>         data->beacon_count++;
>
>         data->chain_noise_a = (chain_noise_a + data->chain_noise_a);
> --
> 2.7.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
