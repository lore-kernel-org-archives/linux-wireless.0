Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:42797 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649AbZKHNxA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 08:53:00 -0500
Received: by ey-out-2122.google.com with SMTP id 25so5149eya.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 05:53:04 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 5/9] rt2800: prepare for rt2800*_probe_hw_mode() unification
Date: Sun, 8 Nov 2009 14:53:03 +0100
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <20091108133854.23584.86842.sendpatchset@localhost.localdomain> <20091108133925.23584.37879.sendpatchset@localhost.localdomain>
In-Reply-To: <20091108133925.23584.37879.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200911081453.03260.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 08 November 2009, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2800: prepare for rt2800*_probe_hw_mode() unification
> 
> Enclose interface specific code in rt2800[pci,usb]_probe_hw_mode()
> with rt2x00_intf_is_[pci,usb]() checks.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800pci.c |   24 ++++++++++++++----------
>  drivers/net/wireless/rt2x00/rt2800usb.c |   19 ++++++++++++-------
>  2 files changed, 26 insertions(+), 17 deletions(-)
> 
> Index: b/drivers/net/wireless/rt2x00/rt2800pci.c
> ===================================================================
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -1175,6 +1175,7 @@ static const struct rf_channel rf_vals[]
>  
>  static int rt2800pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>  {
> +	struct rt2x00_chip *chip = &rt2x00dev->chip;
>  	struct hw_mode_spec *spec = &rt2x00dev->spec;
>  	struct channel_info *info;
>  	char *tx_power1;
> @@ -1190,7 +1191,9 @@ static int rt2800pci_probe_hw_mode(struc
>  	    IEEE80211_HW_SIGNAL_DBM |
>  	    IEEE80211_HW_SUPPORTS_PS |
>  	    IEEE80211_HW_PS_NULLFUNC_STACK;
> -	rt2x00dev->hw->extra_tx_headroom = TXWI_DESC_SIZE;
> +
> +	if (rt2x00_intf_is_pci(rt2x00dev))
> +		rt2x00dev->hw->extra_tx_headroom = TXWI_DESC_SIZE;
>  
>  	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
>  	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
> @@ -1205,17 +1208,18 @@ static int rt2800pci_probe_hw_mode(struc
>  	spec->supported_bands = SUPPORT_BAND_2GHZ;
>  	spec->supported_rates = SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
>  
> -	if (rt2x00_rf(&rt2x00dev->chip, RF2820) ||
> -	    rt2x00_rf(&rt2x00dev->chip, RF2720) ||
> -	    rt2x00_rf(&rt2x00dev->chip, RF3020) ||
> -	    rt2x00_rf(&rt2x00dev->chip, RF3021) ||
> -	    rt2x00_rf(&rt2x00dev->chip, RF3022) ||
> -	    rt2x00_rf(&rt2x00dev->chip, RF2020) ||
> -	    rt2x00_rf(&rt2x00dev->chip, RF3052)) {
> +	if (rt2x00_rf(chip, RF2820) ||
> +	    rt2x00_rf(chip, RF2720) ||
> +	    (rt2x00_intf_is_pci(rt2x00dev) &&
> +	     (rt2x00_rf(chip, RF3020) ||
> +	      rt2x00_rf(chip, RF3021) ||
> +	      rt2x00_rf(chip, RF3022) ||
> +	      rt2x00_rf(chip, RF2020) ||
> +	      rt2x00_rf(chip, RF3052)))) {
>  		spec->num_channels = 14;
>  		spec->channels = rf_vals;
> -	} else if (rt2x00_rf(&rt2x00dev->chip, RF2850) ||
> -		   rt2x00_rf(&rt2x00dev->chip, RF2750)) {
> +	} else if (rt2x00_rf(chip, RF2850) ||
> +		   rt2x00_rf(chip, RF2750)) {
>  		spec->supported_bands |= SUPPORT_BAND_5GHZ;
>  		spec->num_channels = ARRAY_SIZE(rf_vals);
>  		spec->channels = rf_vals;
> Index: b/drivers/net/wireless/rt2x00/rt2800usb.c
> ===================================================================
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -770,6 +770,7 @@ static const struct rf_channel rf_vals_3
>  
>  static int rt2800usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>  {
> +	struct rt2x00_chip *chip = &rt2x00dev->chip;
>  	struct hw_mode_spec *spec = &rt2x00dev->spec;
>  	struct channel_info *info;
>  	char *tx_power1;
> @@ -785,7 +786,10 @@ static int rt2800usb_probe_hw_mode(struc
>  	    IEEE80211_HW_SIGNAL_DBM |
>  	    IEEE80211_HW_SUPPORTS_PS |
>  	    IEEE80211_HW_PS_NULLFUNC_STACK;
> -	rt2x00dev->hw->extra_tx_headroom = TXINFO_DESC_SIZE + TXWI_DESC_SIZE;
> +
> +	if (rt2x00_intf_is_usb(rt2x00dev))
> +		rt2x00dev->hw->extra_tx_headroom =
> +			TXINFO_DESC_SIZE + TXWI_DESC_SIZE;
>  
>  	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
>  	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
> @@ -800,17 +804,18 @@ static int rt2800usb_probe_hw_mode(struc
>  	spec->supported_bands = SUPPORT_BAND_2GHZ;
>  	spec->supported_rates = SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
>  
> -	if (rt2x00_rf(&rt2x00dev->chip, RF2820) ||
> -	    rt2x00_rf(&rt2x00dev->chip, RF2720)) {
> +	if (rt2x00_rf(chip, RF2820) ||
> +	    rt2x00_rf(chip, RF2720)) {
>  		spec->num_channels = 14;
>  		spec->channels = rf_vals;
> -	} else if (rt2x00_rf(&rt2x00dev->chip, RF2850) ||
> -		   rt2x00_rf(&rt2x00dev->chip, RF2750)) {
> +	} else if (rt2x00_rf(chip, RF2850) ||
> +		   rt2x00_rf(chip, RF2750)) {
>  		spec->supported_bands |= SUPPORT_BAND_5GHZ;
>  		spec->num_channels = ARRAY_SIZE(rf_vals);
>  		spec->channels = rf_vals;
> -	} else if (rt2x00_rf(&rt2x00dev->chip, RF3020) ||
> -		   rt2x00_rf(&rt2x00dev->chip, RF2020)) {
> +	} else if (rt2x00_intf_is_usb(rt2x00dev) &&
> +		    (rt2x00_rf(chip, RF3020) ||
> +		     rt2x00_rf(chip, RF2020))) {
>  		spec->num_channels = ARRAY_SIZE(rf_vals_3070);
>  		spec->channels = rf_vals_3070;
>  	}
> 


