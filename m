Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:61911 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbZKJSn0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 13:43:26 -0500
Received: by ewy3 with SMTP id 3so339083ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 10 Nov 2009 10:43:31 -0800 (PST)
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH] rt2x00: Initialize rf302x RF values properly in rt2800pci.
Date: Tue, 10 Nov 2009 19:41:33 +0100
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Ivo van Doorn <IvDoorn@gmail.com>
References: <1257804017-5446-1-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1257804017-5446-1-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Message-Id: <200911101941.33825.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi Gertjan,

On Monday 09 November 2009 23:00:17 Gertjan van Wingerde wrote:
> Insert RF chipset values for the RF302x chipsets. Mirrored from the rt2800usb driver.
> Also, ensure these RF chipsets are handled properly in rt2800lib for the rt3090 chipset.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> ---
> 
> This one clashes with the patch series sent by Bart. However, I believe that logically this patch
> belongs before his patch series, as it makes the unification cleaner and clearer.

The change itself is correct and much welcomed but please take a look
at the diffstat below:

> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |    5 +++--
>  drivers/net/wireless/rt2x00/rt2800pci.c |   31 +++++++++++++++++++++++++++----
>  drivers/net/wireless/rt2x00/rt2800usb.c |    8 ++++----
>  3 files changed, 34 insertions(+), 10 deletions(-)

I worry that applying this patch before unification will not make anything
cleaner, especially since it duplicates code that unification patch will now
have to also remove:

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

Some previous patches also cleaned up the code below (by using 'chip'
variable) so this patch could have been smaller and easier to review
by simply basing it on the previous work.

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

Please also note that previous patches were tested, reviewed and many
agreed on already (i.e. unification patch has Ivo's ACK) so unfortunate
side effect of not doing changes in the incremental fashion is that
people will be needlessly required to invest time on testing & reviewing
modified patches..

Please reconsider re-basing your work on top of changes from:

	git://git.kernel.org/pub/scm/linux/kernel/git/bart/misc.git rt2800

Thanks.
-- 
Bartlomiej Zolnierkiewicz
