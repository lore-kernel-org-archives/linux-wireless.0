Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:8638 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804AbZKJSdj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 13:33:39 -0500
Received: by ey-out-2122.google.com with SMTP id 9so70931eyd.19
        for <linux-wireless@vger.kernel.org>; Tue, 10 Nov 2009 10:33:44 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH] rt2x00: Initialize rf302x RF values properly in rt2800pci.
Date: Tue, 10 Nov 2009 19:33:42 +0100
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
References: <1257804017-5446-1-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1257804017-5446-1-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200911101933.42463.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 09 November 2009, Gertjan van Wingerde wrote:
> Insert RF chipset values for the RF302x chipsets. Mirrored from the rt2800usb driver.
> Also, ensure these RF chipsets are handled properly in rt2800lib for the rt3090 chipset.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
> 
> This one clashes with the patch series sent by Bart. However, I believe that logically this patch
> belongs before his patch series, as it makes the unification cleaner and clearer.
> 
> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |    5 +++--
>  drivers/net/wireless/rt2x00/rt2800pci.c |   31 +++++++++++++++++++++++++++----
>  drivers/net/wireless/rt2x00/rt2800usb.c |    8 ++++----
>  3 files changed, 34 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 446087e..d41b3ca 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -806,8 +806,9 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
>  	unsigned int tx_pin;
>  	u8 bbp;
>  
> -	if (rt2x00_rt(&rt2x00dev->chip, RT3070) &&	
> -           (rt2x00_rf(&rt2x00dev->chip, RF2020) ||
> +	if ((rt2x00_rt(&rt2x00dev->chip, RT3070) ||
> +	     rt2x00_rt(&rt2x00dev->chip, RT3090)) &&
> +            (rt2x00_rf(&rt2x00dev->chip, RF2020) ||
>  	     rt2x00_rf(&rt2x00dev->chip, RF3020) ||
>  	     rt2x00_rf(&rt2x00dev->chip, RF3021) ||
>  	     rt2x00_rf(&rt2x00dev->chip, RF3022)))
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> index ac7ac57..be42558 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -1362,6 +1362,27 @@ static const struct rf_channel rf_vals[] = {
>  	{ 216, 0x15002ccc, 0x15004982, 0x1509be55, 0x150c0a23 },
>  };
>  
> +/*
> + * RF value list for rt302x
> + * Supports: 2.4 GHz
> + */
> +static const struct rf_channel rf_vals_302x[] = {
> +	{1,  241, 2, 2 },
> +	{2,  241, 2, 7 },
> +	{3,  242, 2, 2 },
> +	{4,  242, 2, 7 },
> +	{5,  243, 2, 2 },
> +	{6,  243, 2, 7 },
> +	{7,  244, 2, 2 },
> +	{8,  244, 2, 7 },
> +	{9,  245, 2, 2 },
> +	{10, 245, 2, 7 },
> +	{11, 246, 2, 2 },
> +	{12, 246, 2, 7 },
> +	{13, 247, 2, 2 },
> +	{14, 248, 2, 4 },
> +};
> +
>  static int rt2800pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>  {
>  	struct hw_mode_spec *spec = &rt2x00dev->spec;
> @@ -1396,10 +1417,6 @@ static int rt2800pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>  
>  	if (rt2x00_rf(&rt2x00dev->chip, RF2820) ||
>  	    rt2x00_rf(&rt2x00dev->chip, RF2720) ||
> -	    rt2x00_rf(&rt2x00dev->chip, RF3020) ||
> -	    rt2x00_rf(&rt2x00dev->chip, RF3021) ||
> -	    rt2x00_rf(&rt2x00dev->chip, RF3022) ||
> -	    rt2x00_rf(&rt2x00dev->chip, RF2020) ||
>  	    rt2x00_rf(&rt2x00dev->chip, RF3052)) {
>  		spec->num_channels = 14;
>  		spec->channels = rf_vals;
> @@ -1408,6 +1425,12 @@ static int rt2800pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>  		spec->supported_bands |= SUPPORT_BAND_5GHZ;
>  		spec->num_channels = ARRAY_SIZE(rf_vals);
>  		spec->channels = rf_vals;
> +	} else if (rt2x00_rf(&rt2x00dev->chip, RF3020) ||
> +		   rt2x00_rf(&rt2x00dev->chip, RF3021) ||
> +		   rt2x00_rf(&rt2x00dev->chip, RF3022) ||
> +		   rt2x00_rf(&rt2x00dev->chip, RF2020)) {
> +		spec->num_channels = ARRAY_SIZE(rf_vals_302x);
> +		spec->channels = rf_vals_302x;
>  	}
>  
>  	/*
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index bd2f6e6..9aa2f7a 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -940,10 +940,10 @@ static const struct rf_channel rf_vals[] = {
>  };
>  
>  /*
> - * RF value list for rt3070
> + * RF value list for rf302x
>   * Supports: 2.4 GHz
>   */
> -static const struct rf_channel rf_vals_3070[] = {
> +static const struct rf_channel rf_vals_302x[] = {
>  	{1,  241, 2, 2 },
>  	{2,  241, 2, 7 },
>  	{3,  242, 2, 2 },
> @@ -1036,8 +1036,8 @@ static int rt2800usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>  		   rt2x00_rf(&rt2x00dev->chip, RF2020) ||
>  		   rt2x00_rf(&rt2x00dev->chip, RF3021) ||
>  		   rt2x00_rf(&rt2x00dev->chip, RF3022)) {
> -		spec->num_channels = ARRAY_SIZE(rf_vals_3070);
> -		spec->channels = rf_vals_3070;
> +		spec->num_channels = ARRAY_SIZE(rf_vals_302x);
> +		spec->channels = rf_vals_302x;
>  	}
>  
>  	/*


