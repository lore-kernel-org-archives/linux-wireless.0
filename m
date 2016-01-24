Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:34428 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098AbcAXWkL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jan 2016 17:40:11 -0500
Received: by mail-io0-f169.google.com with SMTP id 1so135204530ion.1
        for <linux-wireless@vger.kernel.org>; Sun, 24 Jan 2016 14:40:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1453527309-23881-1-git-send-email-mar.kolya@gmail.com>
References: <1453527309-23881-1-git-send-email-mar.kolya@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 25 Jan 2016 09:39:51 +1100
Message-ID: <CAGRGNgUPEaMrxjT5McKSzpxeZke-zDKeqMsoT+76d90KUwzcyA@mail.gmail.com> (sfid-20160124_234019_468492_00C259E7)
Subject: Re: [PATCH] iwldvm: fix chain gain calibration when firmware return
 zero values
To: Nikolay Martynov <mar.kolya@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Nikolay,

A couple of minor points:

On Sat, Jan 23, 2016 at 4:35 PM, Nikolay Martynov <mar.kolya@gmail.com> wrote:
> From: Nikolay Martynov <(none)>

You really need an email address here instead of "(none)" as this will
be used for the author field of the eventual commit. Check the "user"
section of your git configuration. (Try git config --list)

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

To expand on Emmanuel's comment, 3 << 0 is equivalent to 3. If you're
trying to set specific bits then you need to use the BIT() macro,
otherwise just get rid of the "<< 0"s.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
