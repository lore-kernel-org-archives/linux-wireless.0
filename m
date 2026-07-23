Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04ADA3E172F
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 07:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784793204; cv=none; b=ayfnE/1t4U/yZ/JmXZrTFCUtrHvaJFgioMeDYyeqxAfX4tQEVFUbLBu0/P58elluH9Tot7BTSyWGO8dC6CG/TxogBX9QKm2IWp8F1x0ORPk0fXtUDTxH781rmjdjsR34z/j7QZhvO+dyD8gNmqrW0GJMeOcM8s/DDPqP6vlFfPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784793204; c=relaxed/simple;
	bh=jsvQxcVkE3kEwcqA8ufFNY9qAMSTQtsa/1YAFFF/zhc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RrxsEMHZr9Qsth4S5ZORwVWTGLuQmryxkdFl/mGMSkFXY6FA5V7z9yv+cQ7/YSu2b8DV7atfu1hKWN5Su9zWvuRdFjhXsX4V5KYmnaYfWOvYiDm0qViG4npTNd2VvhJBMfmu0aVJSl4r1cgw8TEkCxmVszQgDb6vgBcYQpTUf/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=S8ALkWTJ; arc=none smtp.client-ip=212.77.101.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="S8ALkWTJ"
Received: (wp-smtpd smtp.wp.pl 13439 invoked from network); 23 Jul 2026 09:53:05 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1784793185; bh=y3sJjViviEwZPAHlhWhqdNAkYjPtBaVgg7gcc16alHk=;
          h=From:To:Cc:Subject;
          b=S8ALkWTJBEkELL0AP9CPoaom6JUCdqp67fo54VCHQpNjw71QMgSV4DvcQtuZa7Iqc
           HWYIryzTuAXP7tiIWEXwNZAeYjkiIK42O3yFsFs/+daw5s1CiGLr0fGwmyQ4gsMjTg
           YVFUyq0SUUowlhF1mwggWIsay8s7E9md9fsAo93g2l35vr9iRCMHwKHpipNa03Yyuz
           if5ymwr347BNN/lvHRNzNUWhMYehxXmuhfbxFDgc6oNriHz96EKXlUW+UIxnCWIkHf
           dlYRI7SjbMz3VAX49OK+fFRE8ZqEhK5AU1qRPAOUbuKIJVwY4i67b+10efCOaQlRjs
           cnZF1m+L01KYw==
Received: from 77-236-11-167.static.play.pl (HELO localhost) (stf_xl@wp.pl@[77.236.11.167])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <rosenp@gmail.com>; 23 Jul 2026 09:53:05 +0200
Date: Thu, 23 Jul 2026 09:53:04 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-wireless@vger.kernel.org, Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:KERNEL HARDENING (not covered by other areas):Keyword:b__counted_by(_le|_be|_ptr)?b" <linux-hardening@vger.kernel.org>
Subject: Re: [PATCH wireless-next] wifi: rt2x00: Use flexible array for
 hw_mode_spec channels
Message-ID: <20260723075304.GA4577@wp.pl>
References: <20260629033156.2363850-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629033156.2363850-1-rosenp@gmail.com>
X-WP-MailID: ac667467ca1182e3283c530c0f1b57aa
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000003 [kaAR]                               

Hi,

On Sun, Jun 28, 2026 at 08:31:56PM -0700, Rosen Penev wrote:
> struct hw_mode_spec stores channel information that is allocated by the
> individual rt2x00 drivers during hardware probing.  The channel info
> array has the same lifetime as the hardware mode specification, but it
> is currently allocated separately and then freed through a separate
> pointer.
>
> Make struct rt2x00_dev hold a pointer to the hardware mode
> specification, store the channel info as a flexible array member, and
> allocate both pieces together with kzalloc_flex().
> 
> Assisted-by: Codex:GPT-5.5
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  .../net/wireless/ralink/rt2x00/rt2400pci.c    | 24 +++---
>  .../net/wireless/ralink/rt2x00/rt2500pci.c    | 55 ++++++++------
>  .../net/wireless/ralink/rt2x00/rt2500usb.c    | 55 ++++++++------
>  .../net/wireless/ralink/rt2x00/rt2800lib.c    | 74 ++++++++++---------
>  drivers/net/wireless/ralink/rt2x00/rt2x00.h   |  4 +-
>  .../net/wireless/ralink/rt2x00/rt2x00config.c | 12 +--
>  .../net/wireless/ralink/rt2x00/rt2x00dev.c    |  4 +-
>  drivers/net/wireless/ralink/rt2x00/rt61pci.c  | 42 ++++++-----
>  drivers/net/wireless/ralink/rt2x00/rt73usb.c  | 50 +++++++------
>  9 files changed, 177 insertions(+), 143 deletions(-)

This result in extra code. I do not see benefit of avoiding 
kzalloc calls at cost of adding more lines of code.

Regards
Stanislaw

> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2400pci.c b/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
> index cac191304bf5..3fb74dcbee63 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
> @@ -1559,7 +1559,7 @@ static const struct rf_channel rf_vals_b[] = {
>  
>  static int rt2400pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>  {
> -	struct hw_mode_spec *spec = &rt2x00dev->spec;
> +	struct hw_mode_spec *spec;
>  	struct channel_info *info;
>  	u8 *tx_power;
>  	unsigned int i;
> @@ -1580,27 +1580,25 @@ static int rt2400pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>  	/*
>  	 * Initialize hw_mode information.
>  	 */
> -	spec->supported_bands = SUPPORT_BAND_2GHZ;
> -	spec->supported_rates = SUPPORT_RATE_CCK;
> +	spec = kzalloc_flex(*spec, channels_info, ARRAY_SIZE(rf_vals_b));
> +	if (!spec)
> +		return -ENOMEM;
>  
>  	spec->num_channels = ARRAY_SIZE(rf_vals_b);
>  	spec->channels = rf_vals_b;
>  
> -	/*
> -	 * Create channel information array
> -	 */
> -	info = kzalloc_objs(*info, spec->num_channels);
> -	if (!info)
> -		return -ENOMEM;
> -
> -	spec->channels_info = info;
> +	spec->supported_bands = SUPPORT_BAND_2GHZ;
> +	spec->supported_rates = SUPPORT_RATE_CCK;
>  
>  	tx_power = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_START);
>  	for (i = 0; i < 14; i++) {
> -		info[i].max_power = TXPOWER_FROM_DEV(MAX_TXPOWER);
> -		info[i].default_power1 = TXPOWER_FROM_DEV(tx_power[i]);
> +		info = &spec->channels_info[i];
> +		info->max_power = TXPOWER_FROM_DEV(MAX_TXPOWER);
> +		info->default_power1 = TXPOWER_FROM_DEV(tx_power[i]);
>  	}
>  
> +	rt2x00dev->spec = spec;
> +
>  	return 0;
>  }
>  
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2500pci.c b/drivers/net/wireless/ralink/rt2x00/rt2500pci.c
> index fc35b60e422c..4c85f401c091 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2500pci.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2500pci.c
> @@ -1854,7 +1854,10 @@ static const struct rf_channel rf_vals_5222[] = {
>  
>  static int rt2500pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>  {
> -	struct hw_mode_spec *spec = &rt2x00dev->spec;
> +	const struct rf_channel *channels;
> +	unsigned int num_channels = 0;
> +	unsigned int supported_bands;
> +	struct hw_mode_spec *spec;
>  	struct channel_info *info;
>  	u8 *tx_power;
>  	unsigned int i;
> @@ -1880,52 +1883,58 @@ static int rt2500pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>  	/*
>  	 * Initialize hw_mode information.
>  	 */
> -	spec->supported_bands = SUPPORT_BAND_2GHZ;
> -	spec->supported_rates = SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
> +	supported_bands = SUPPORT_BAND_2GHZ;
>  
>  	if (rt2x00_rf(rt2x00dev, RF2522)) {
> -		spec->num_channels = ARRAY_SIZE(rf_vals_bg_2522);
> -		spec->channels = rf_vals_bg_2522;
> +		num_channels = ARRAY_SIZE(rf_vals_bg_2522);
> +		channels = rf_vals_bg_2522;
>  	} else if (rt2x00_rf(rt2x00dev, RF2523)) {
> -		spec->num_channels = ARRAY_SIZE(rf_vals_bg_2523);
> -		spec->channels = rf_vals_bg_2523;
> +		num_channels = ARRAY_SIZE(rf_vals_bg_2523);
> +		channels = rf_vals_bg_2523;
>  	} else if (rt2x00_rf(rt2x00dev, RF2524)) {
> -		spec->num_channels = ARRAY_SIZE(rf_vals_bg_2524);
> -		spec->channels = rf_vals_bg_2524;
> +		num_channels = ARRAY_SIZE(rf_vals_bg_2524);
> +		channels = rf_vals_bg_2524;
>  	} else if (rt2x00_rf(rt2x00dev, RF2525)) {
> -		spec->num_channels = ARRAY_SIZE(rf_vals_bg_2525);
> -		spec->channels = rf_vals_bg_2525;
> +		num_channels = ARRAY_SIZE(rf_vals_bg_2525);
> +		channels = rf_vals_bg_2525;
>  	} else if (rt2x00_rf(rt2x00dev, RF2525E)) {
> -		spec->num_channels = ARRAY_SIZE(rf_vals_bg_2525e);
> -		spec->channels = rf_vals_bg_2525e;
> +		num_channels = ARRAY_SIZE(rf_vals_bg_2525e);
> +		channels = rf_vals_bg_2525e;
>  	} else if (rt2x00_rf(rt2x00dev, RF5222)) {
> -		spec->supported_bands |= SUPPORT_BAND_5GHZ;
> -		spec->num_channels = ARRAY_SIZE(rf_vals_5222);
> -		spec->channels = rf_vals_5222;
> +		supported_bands |= SUPPORT_BAND_5GHZ;
> +		num_channels = ARRAY_SIZE(rf_vals_5222);
> +		channels = rf_vals_5222;
>  	}
>  
>  	/*
>  	 * Create channel information array
>  	 */
> -	info = kzalloc_objs(*info, spec->num_channels);
> -	if (!info)
> +	spec = kzalloc_flex(*spec, channels_info, num_channels);
> +	if (!spec)
>  		return -ENOMEM;
>  
> -	spec->channels_info = info;
> +	spec->num_channels = num_channels;
> +	spec->channels = channels;
> +	spec->supported_bands = supported_bands;
> +	spec->supported_rates = SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
>  
>  	tx_power = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_START);
>  	for (i = 0; i < 14; i++) {
> -		info[i].max_power = MAX_TXPOWER;
> -		info[i].default_power1 = TXPOWER_FROM_DEV(tx_power[i]);
> +		info = &spec->channels_info[i];
> +		info->max_power = MAX_TXPOWER;
> +		info->default_power1 = TXPOWER_FROM_DEV(tx_power[i]);
>  	}
>  
>  	if (spec->num_channels > 14) {
>  		for (i = 14; i < spec->num_channels; i++) {
> -			info[i].max_power = MAX_TXPOWER;
> -			info[i].default_power1 = DEFAULT_TXPOWER;
> +			info = &spec->channels_info[i];
> +			info->max_power = MAX_TXPOWER;
> +			info->default_power1 = DEFAULT_TXPOWER;
>  		}
>  	}
>  
> +	rt2x00dev->spec = spec;
> +
>  	return 0;
>  }
>  
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2500usb.c b/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
> index 58728df6666c..cbc1c1399cc6 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
> @@ -1661,7 +1661,10 @@ static const struct rf_channel rf_vals_5222[] = {
>  
>  static int rt2500usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>  {
> -	struct hw_mode_spec *spec = &rt2x00dev->spec;
> +	const struct rf_channel *channels;
> +	unsigned int num_channels = 0;
> +	unsigned int supported_bands;
> +	struct hw_mode_spec *spec;
>  	struct channel_info *info;
>  	u8 *tx_power;
>  	unsigned int i;
> @@ -1693,52 +1696,58 @@ static int rt2500usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>  	/*
>  	 * Initialize hw_mode information.
>  	 */
> -	spec->supported_bands = SUPPORT_BAND_2GHZ;
> -	spec->supported_rates = SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
> +	supported_bands = SUPPORT_BAND_2GHZ;
>  
>  	if (rt2x00_rf(rt2x00dev, RF2522)) {
> -		spec->num_channels = ARRAY_SIZE(rf_vals_bg_2522);
> -		spec->channels = rf_vals_bg_2522;
> +		num_channels = ARRAY_SIZE(rf_vals_bg_2522);
> +		channels = rf_vals_bg_2522;
>  	} else if (rt2x00_rf(rt2x00dev, RF2523)) {
> -		spec->num_channels = ARRAY_SIZE(rf_vals_bg_2523);
> -		spec->channels = rf_vals_bg_2523;
> +		num_channels = ARRAY_SIZE(rf_vals_bg_2523);
> +		channels = rf_vals_bg_2523;
>  	} else if (rt2x00_rf(rt2x00dev, RF2524)) {
> -		spec->num_channels = ARRAY_SIZE(rf_vals_bg_2524);
> -		spec->channels = rf_vals_bg_2524;
> +		num_channels = ARRAY_SIZE(rf_vals_bg_2524);
> +		channels = rf_vals_bg_2524;
>  	} else if (rt2x00_rf(rt2x00dev, RF2525)) {
> -		spec->num_channels = ARRAY_SIZE(rf_vals_bg_2525);
> -		spec->channels = rf_vals_bg_2525;
> +		num_channels = ARRAY_SIZE(rf_vals_bg_2525);
> +		channels = rf_vals_bg_2525;
>  	} else if (rt2x00_rf(rt2x00dev, RF2525E)) {
> -		spec->num_channels = ARRAY_SIZE(rf_vals_bg_2525e);
> -		spec->channels = rf_vals_bg_2525e;
> +		num_channels = ARRAY_SIZE(rf_vals_bg_2525e);
> +		channels = rf_vals_bg_2525e;
>  	} else if (rt2x00_rf(rt2x00dev, RF5222)) {
> -		spec->supported_bands |= SUPPORT_BAND_5GHZ;
> -		spec->num_channels = ARRAY_SIZE(rf_vals_5222);
> -		spec->channels = rf_vals_5222;
> +		supported_bands |= SUPPORT_BAND_5GHZ;
> +		num_channels = ARRAY_SIZE(rf_vals_5222);
> +		channels = rf_vals_5222;
>  	}
>  
>  	/*
>  	 * Create channel information array
>  	 */
> -	info = kzalloc_objs(*info, spec->num_channels);
> -	if (!info)
> +	spec = kzalloc_flex(*spec, channels_info, num_channels);
> +	if (!spec)
>  		return -ENOMEM;
>  
> -	spec->channels_info = info;
> +	spec->num_channels = num_channels;
> +	spec->channels = channels;
> +	spec->supported_bands = supported_bands;
> +	spec->supported_rates = SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
>  
>  	tx_power = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_START);
>  	for (i = 0; i < 14; i++) {
> -		info[i].max_power = MAX_TXPOWER;
> -		info[i].default_power1 = TXPOWER_FROM_DEV(tx_power[i]);
> +		info = &spec->channels_info[i];
> +		info->max_power = MAX_TXPOWER;
> +		info->default_power1 = TXPOWER_FROM_DEV(tx_power[i]);
>  	}
>  
>  	if (spec->num_channels > 14) {
>  		for (i = 14; i < spec->num_channels; i++) {
> -			info[i].max_power = MAX_TXPOWER;
> -			info[i].default_power1 = DEFAULT_TXPOWER;
> +			info = &spec->channels_info[i];
> +			info->max_power = MAX_TXPOWER;
> +			info->default_power1 = DEFAULT_TXPOWER;
>  		}
>  	}
>  
> +	rt2x00dev->spec = spec;
> +
>  	return 0;
>  }
>  
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> index 97290899674e..7b7f6dcc9247 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> @@ -11778,7 +11778,9 @@ static const struct rf_channel rf_vals_7620[] = {
>  
>  static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>  {
> -	struct hw_mode_spec *spec = &rt2x00dev->spec;
> +	const struct rf_channel *channels;
> +	unsigned int num_channels = 0;
> +	struct hw_mode_spec *spec;
>  	struct channel_info *info;
>  	s8 *default_power1;
>  	s8 *default_power2;
> @@ -11840,19 +11842,17 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>  	/*
>  	 * Initialize hw_mode information.
>  	 */
> -	spec->supported_rates = SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
> -
>  	switch (rt2x00dev->chip.rf) {
>  	case RF2720:
>  	case RF2820:
> -		spec->num_channels = 14;
> -		spec->channels = rf_vals;
> +		num_channels = 14;
> +		channels = rf_vals;
>  		break;
>  
>  	case RF2750:
>  	case RF2850:
> -		spec->num_channels = ARRAY_SIZE(rf_vals);
> -		spec->channels = rf_vals;
> +		num_channels = ARRAY_SIZE(rf_vals);
> +		channels = rf_vals;
>  		break;
>  
>  	case RF2020:
> @@ -11870,44 +11870,52 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>  	case RF5372:
>  	case RF5390:
>  	case RF5392:
> -		spec->num_channels = 14;
> +		num_channels = 14;
>  		if (rt2800_clk_is_20mhz(rt2x00dev))
> -			spec->channels = rf_vals_3x_xtal20;
> +			channels = rf_vals_3x_xtal20;
>  		else
> -			spec->channels = rf_vals_3x;
> +			channels = rf_vals_3x;
>  		break;
>  
>  	case RF7620:
> -		spec->num_channels = ARRAY_SIZE(rf_vals_7620);
> -		spec->channels = rf_vals_7620;
> +		num_channels = ARRAY_SIZE(rf_vals_7620);
> +		channels = rf_vals_7620;
>  		break;
>  
>  	case RF3052:
>  	case RF3053:
> -		spec->num_channels = ARRAY_SIZE(rf_vals_3x);
> -		spec->channels = rf_vals_3x;
> +		num_channels = ARRAY_SIZE(rf_vals_3x);
> +		channels = rf_vals_3x;
>  		break;
>  
>  	case RF3853:
> -		spec->num_channels = ARRAY_SIZE(rf_vals_3853);
> -		spec->channels = rf_vals_3853;
> +		num_channels = ARRAY_SIZE(rf_vals_3853);
> +		channels = rf_vals_3853;
>  		break;
>  
>  	case RF5592:
>  		reg = rt2800_register_read(rt2x00dev, MAC_DEBUG_INDEX);
>  		if (rt2x00_get_field32(reg, MAC_DEBUG_INDEX_XTAL)) {
> -			spec->num_channels = ARRAY_SIZE(rf_vals_5592_xtal40);
> -			spec->channels = rf_vals_5592_xtal40;
> +			num_channels = ARRAY_SIZE(rf_vals_5592_xtal40);
> +			channels = rf_vals_5592_xtal40;
>  		} else {
> -			spec->num_channels = ARRAY_SIZE(rf_vals_5592_xtal20);
> -			spec->channels = rf_vals_5592_xtal20;
> +			num_channels = ARRAY_SIZE(rf_vals_5592_xtal20);
> +			channels = rf_vals_5592_xtal20;
>  		}
>  		break;
>  	}
>  
> -	if (WARN_ON_ONCE(!spec->channels))
> +	if (WARN_ON_ONCE(!channels))
>  		return -ENODEV;
>  
> +	spec = kzalloc_flex(*spec, channels_info, num_channels);
> +	if (!spec)
> +		return -ENOMEM;
> +
> +	spec->num_channels = num_channels;
> +	spec->channels = channels;
> +	spec->supported_rates = SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
> +
>  	spec->supported_bands = SUPPORT_BAND_2GHZ;
>  	if (spec->num_channels > 14)
>  		spec->supported_bands |= SUPPORT_BAND_5GHZ;
> @@ -11959,19 +11967,13 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>  	/*
>  	 * Create channel information and survey arrays
>  	 */
> -	info = kzalloc_objs(*info, spec->num_channels);
> -	if (!info)
> -		return -ENOMEM;
> -
>  	rt2x00dev->chan_survey =
>  		kzalloc_objs(struct rt2x00_chan_survey, spec->num_channels);
>  	if (!rt2x00dev->chan_survey) {
> -		kfree(info);
> +		kfree(spec);
>  		return -ENOMEM;
>  	}
>  
> -	spec->channels_info = info;
> -
>  	default_power1 = rt2800_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_BG1);
>  	default_power2 = rt2800_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_BG2);
>  
> @@ -11982,10 +11984,11 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>  		default_power3 = NULL;
>  
>  	for (i = 0; i < 14; i++) {
> -		info[i].default_power1 = default_power1[i];
> -		info[i].default_power2 = default_power2[i];
> +		info = &spec->channels_info[i];
> +		info->default_power1 = default_power1[i];
> +		info->default_power2 = default_power2[i];
>  		if (default_power3)
> -			info[i].default_power3 = default_power3[i];
> +			info->default_power3 = default_power3[i];
>  	}
>  
>  	if (spec->num_channels > 14) {
> @@ -12002,10 +12005,11 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>  			default_power3 = NULL;
>  
>  		for (i = 14; i < spec->num_channels; i++) {
> -			info[i].default_power1 = default_power1[i - 14];
> -			info[i].default_power2 = default_power2[i - 14];
> +			info = &spec->channels_info[i];
> +			info->default_power1 = default_power1[i - 14];
> +			info->default_power2 = default_power2[i - 14];
>  			if (default_power3)
> -				info[i].default_power3 = default_power3[i - 14];
> +				info->default_power3 = default_power3[i - 14];
>  		}
>  	}
>  
> @@ -12033,6 +12037,8 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>  		break;
>  	}
>  
> +	rt2x00dev->spec = spec;
> +
>  	return 0;
>  }
>  
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
> index 7d313e86d3f2..babc04210a65 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
> @@ -404,9 +404,9 @@ struct hw_mode_spec {
>  
>  	unsigned int num_channels;
>  	const struct rf_channel *channels;
> -	const struct channel_info *channels_info;
>  
>  	struct ieee80211_sta_ht_cap ht;
> +	struct channel_info channels_info[] __counted_by(num_channels);
>  };
>  
>  /*
> @@ -802,7 +802,7 @@ struct rt2x00_dev {
>  	/*
>  	 * hw capability specifications.
>  	 */
> -	struct hw_mode_spec spec;
> +	struct hw_mode_spec *spec;
>  
>  	/*
>  	 * This is the default TX/RX antenna setup as indicated
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00config.c b/drivers/net/wireless/ralink/rt2x00/rt2x00config.c
> index f895f560a185..b97cb67c4361 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00config.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00config.c
> @@ -165,7 +165,7 @@ void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
>  static u16 rt2x00ht_center_channel(struct rt2x00_dev *rt2x00dev,
>  				   struct ieee80211_conf *conf)
>  {
> -	struct hw_mode_spec *spec = &rt2x00dev->spec;
> +	struct hw_mode_spec *spec = rt2x00dev->spec;
>  	int center_channel;
>  	u16 i;
>  
> @@ -194,6 +194,7 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
>  		      struct ieee80211_conf *conf,
>  		      unsigned int ieee80211_flags)
>  {
> +	struct hw_mode_spec *spec = rt2x00dev->spec;
>  	struct rt2x00lib_conf libconf;
>  	u16 hw_value;
>  	u16 autowake_timeout;
> @@ -218,13 +219,8 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
>  			hw_value = conf->chandef.chan->hw_value;
>  		}
>  
> -		memcpy(&libconf.rf,
> -		       &rt2x00dev->spec.channels[hw_value],
> -		       sizeof(libconf.rf));
> -
> -		memcpy(&libconf.channel,
> -		       &rt2x00dev->spec.channels_info[hw_value],
> -		       sizeof(libconf.channel));
> +		memcpy(&libconf.rf, &spec->channels[hw_value], sizeof(libconf.rf));
> +		memcpy(&libconf.channel, &spec->channels_info[hw_value], sizeof(libconf.channel));
>  
>  		/* Used for VCO periodic calibration */
>  		rt2x00dev->rf_channel = libconf.rf.channel;
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
> index edc1f8eac747..3ffbc8aabbae 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
> @@ -1097,7 +1097,7 @@ static void rt2x00lib_remove_hw(struct rt2x00_dev *rt2x00dev)
>  		rt2x00dev->hw->wiphy->bands[NL80211_BAND_5GHZ] = NULL;
>  	}
>  
> -	kfree(rt2x00dev->spec.channels_info);
> +	kfree(rt2x00dev->spec);
>  	kfree(rt2x00dev->chan_survey);
>  }
>  
> @@ -1116,7 +1116,7 @@ static const struct ieee80211_tpt_blink rt2x00_tpt_blink[] = {
>  
>  static int rt2x00lib_probe_hw(struct rt2x00_dev *rt2x00dev)
>  {
> -	struct hw_mode_spec *spec = &rt2x00dev->spec;
> +	struct hw_mode_spec *spec = rt2x00dev->spec;
>  	int status;
>  
>  	if (test_bit(DEVICE_STATE_REGISTERED_HW, &rt2x00dev->flags))
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt61pci.c b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
> index 79e1fd0a1fbd..479825f8bba9 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt61pci.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
> @@ -2654,7 +2654,10 @@ static const struct rf_channel rf_vals_seq[] = {
>  
>  static int rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>  {
> -	struct hw_mode_spec *spec = &rt2x00dev->spec;
> +	const struct rf_channel *channels;
> +	unsigned int num_channels = 0;
> +	unsigned int supported_bands;
> +	struct hw_mode_spec *spec;
>  	struct channel_info *info;
>  	u8 *tx_power;
>  	unsigned int i;
> @@ -2693,46 +2696,51 @@ static int rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>  	/*
>  	 * Initialize hw_mode information.
>  	 */
> -	spec->supported_bands = SUPPORT_BAND_2GHZ;
> -	spec->supported_rates = SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
> +	supported_bands = SUPPORT_BAND_2GHZ;
>  
>  	if (!rt2x00_has_cap_rf_sequence(rt2x00dev)) {
> -		spec->num_channels = 14;
> -		spec->channels = rf_vals_noseq;
> +		num_channels = 14;
> +		channels = rf_vals_noseq;
>  	} else {
> -		spec->num_channels = 14;
> -		spec->channels = rf_vals_seq;
> +		num_channels = 14;
> +		channels = rf_vals_seq;
>  	}
>  
>  	if (rt2x00_rf(rt2x00dev, RF5225) || rt2x00_rf(rt2x00dev, RF5325)) {
> -		spec->supported_bands |= SUPPORT_BAND_5GHZ;
> -		spec->num_channels = ARRAY_SIZE(rf_vals_seq);
> +		supported_bands |= SUPPORT_BAND_5GHZ;
> +		num_channels = ARRAY_SIZE(rf_vals_seq);
>  	}
>  
>  	/*
>  	 * Create channel information array
>  	 */
> -	info = kzalloc_objs(*info, spec->num_channels);
> -	if (!info)
> +	spec = kzalloc_flex(*spec, channels_info, num_channels);
> +	if (!spec)
>  		return -ENOMEM;
>  
> -	spec->channels_info = info;
> +	spec->num_channels = num_channels;
> +	spec->channels = channels;
> +	spec->supported_bands = supported_bands;
> +	spec->supported_rates = SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
>  
>  	tx_power = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_G_START);
>  	for (i = 0; i < 14; i++) {
> -		info[i].max_power = MAX_TXPOWER;
> -		info[i].default_power1 = TXPOWER_FROM_DEV(tx_power[i]);
> +		info = &spec->channels_info[i];
> +		info->max_power = MAX_TXPOWER;
> +		info->default_power1 = TXPOWER_FROM_DEV(tx_power[i]);
>  	}
>  
>  	if (spec->num_channels > 14) {
>  		tx_power = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A_START);
>  		for (i = 14; i < spec->num_channels; i++) {
> -			info[i].max_power = MAX_TXPOWER;
> -			info[i].default_power1 =
> -					TXPOWER_FROM_DEV(tx_power[i - 14]);
> +			info = &spec->channels_info[i];
> +			info->max_power = MAX_TXPOWER;
> +			info->default_power1 = TXPOWER_FROM_DEV(tx_power[i - 14]);
>  		}
>  	}
>  
> +	rt2x00dev->spec = spec;
> +
>  	return 0;
>  }
>  
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt73usb.c b/drivers/net/wireless/ralink/rt2x00/rt73usb.c
> index d6b7174d087a..17338378329b 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt73usb.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt73usb.c
> @@ -2088,7 +2088,10 @@ static const struct rf_channel rf_vals_5225_2527[] = {
>  
>  static int rt73usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>  {
> -	struct hw_mode_spec *spec = &rt2x00dev->spec;
> +	const struct rf_channel *channels;
> +	unsigned int num_channels = 0;
> +	unsigned int supported_bands;
> +	struct hw_mode_spec *spec;
>  	struct channel_info *info;
>  	u8 *tx_power;
>  	unsigned int i;
> @@ -2114,49 +2117,54 @@ static int rt73usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>  	/*
>  	 * Initialize hw_mode information.
>  	 */
> -	spec->supported_bands = SUPPORT_BAND_2GHZ;
> -	spec->supported_rates = SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
> +	supported_bands = SUPPORT_BAND_2GHZ;
>  
>  	if (rt2x00_rf(rt2x00dev, RF2528)) {
> -		spec->num_channels = ARRAY_SIZE(rf_vals_bg_2528);
> -		spec->channels = rf_vals_bg_2528;
> +		num_channels = ARRAY_SIZE(rf_vals_bg_2528);
> +		channels = rf_vals_bg_2528;
>  	} else if (rt2x00_rf(rt2x00dev, RF5226)) {
> -		spec->supported_bands |= SUPPORT_BAND_5GHZ;
> -		spec->num_channels = ARRAY_SIZE(rf_vals_5226);
> -		spec->channels = rf_vals_5226;
> +		supported_bands |= SUPPORT_BAND_5GHZ;
> +		num_channels = ARRAY_SIZE(rf_vals_5226);
> +		channels = rf_vals_5226;
>  	} else if (rt2x00_rf(rt2x00dev, RF2527)) {
> -		spec->num_channels = 14;
> -		spec->channels = rf_vals_5225_2527;
> +		num_channels = 14;
> +		channels = rf_vals_5225_2527;
>  	} else if (rt2x00_rf(rt2x00dev, RF5225)) {
> -		spec->supported_bands |= SUPPORT_BAND_5GHZ;
> -		spec->num_channels = ARRAY_SIZE(rf_vals_5225_2527);
> -		spec->channels = rf_vals_5225_2527;
> +		supported_bands |= SUPPORT_BAND_5GHZ;
> +		num_channels = ARRAY_SIZE(rf_vals_5225_2527);
> +		channels = rf_vals_5225_2527;
>  	}
>  
>  	/*
>  	 * Create channel information array
>  	 */
> -	info = kzalloc_objs(*info, spec->num_channels);
> -	if (!info)
> +	spec = kzalloc_flex(*spec, channels_info, num_channels);
> +	if (!spec)
>  		return -ENOMEM;
>  
> -	spec->channels_info = info;
> +	spec->num_channels = num_channels;
> +	spec->channels = channels;
> +	spec->supported_bands = supported_bands;
> +	spec->supported_rates = SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
>  
>  	tx_power = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_G_START);
>  	for (i = 0; i < 14; i++) {
> -		info[i].max_power = MAX_TXPOWER;
> -		info[i].default_power1 = TXPOWER_FROM_DEV(tx_power[i]);
> +		info = &spec->channels_info[i];
> +		info->max_power = MAX_TXPOWER;
> +		info->default_power1 = TXPOWER_FROM_DEV(tx_power[i]);
>  	}
>  
>  	if (spec->num_channels > 14) {
>  		tx_power = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A_START);
>  		for (i = 14; i < spec->num_channels; i++) {
> -			info[i].max_power = MAX_TXPOWER;
> -			info[i].default_power1 =
> -					TXPOWER_FROM_DEV(tx_power[i - 14]);
> +			info = &spec->channels_info[i];
> +			info->max_power = MAX_TXPOWER;
> +			info->default_power1 = TXPOWER_FROM_DEV(tx_power[i - 14]);
>  		}
>  	}
>  
> +	rt2x00dev->spec = spec;
> +
>  	return 0;
>  }
>  
> -- 
> 2.54.0
> 
