Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:36649 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717AbZKHNxk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 08:53:40 -0500
Received: by ewy3 with SMTP id 3so2377759ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 05:53:44 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 6/9] rt2800: unify rt2800*_probe_hw_mode()
Date: Sun, 8 Nov 2009 14:53:42 +0100
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <20091108133854.23584.86842.sendpatchset@localhost.localdomain> <20091108133932.23584.75230.sendpatchset@localhost.localdomain>
In-Reply-To: <20091108133932.23584.75230.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200911081453.42602.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 08 November 2009, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2800: unify rt2800*_probe_hw_mode()
> 
> Add rf_vals tables and rt2800_probe_hw_mode() to rt2800lib.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |  218 ++++++++++++++++++++++++++++++++
>  drivers/net/wireless/rt2x00/rt2800lib.h |    1 
>  drivers/net/wireless/rt2x00/rt2800pci.c |  190 ---------------------------
>  drivers/net/wireless/rt2x00/rt2800usb.c |  211 ------------------------------
>  4 files changed, 221 insertions(+), 399 deletions(-)
> 
> Index: b/drivers/net/wireless/rt2x00/rt2800lib.c
> ===================================================================
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -1859,6 +1859,224 @@ int rt2800_init_eeprom(struct rt2x00_dev
>  EXPORT_SYMBOL_GPL(rt2800_init_eeprom);
>  
>  /*
> + * RF value list for rt28x0
> + * Supports: 2.4 GHz (all) & 5.2 GHz (RF2850 & RF2750)
> + */
> +static const struct rf_channel rf_vals[] = {
> +	{ 1,  0x18402ecc, 0x184c0786, 0x1816b455, 0x1800510b },
> +	{ 2,  0x18402ecc, 0x184c0786, 0x18168a55, 0x1800519f },
> +	{ 3,  0x18402ecc, 0x184c078a, 0x18168a55, 0x1800518b },
> +	{ 4,  0x18402ecc, 0x184c078a, 0x18168a55, 0x1800519f },
> +	{ 5,  0x18402ecc, 0x184c078e, 0x18168a55, 0x1800518b },
> +	{ 6,  0x18402ecc, 0x184c078e, 0x18168a55, 0x1800519f },
> +	{ 7,  0x18402ecc, 0x184c0792, 0x18168a55, 0x1800518b },
> +	{ 8,  0x18402ecc, 0x184c0792, 0x18168a55, 0x1800519f },
> +	{ 9,  0x18402ecc, 0x184c0796, 0x18168a55, 0x1800518b },
> +	{ 10, 0x18402ecc, 0x184c0796, 0x18168a55, 0x1800519f },
> +	{ 11, 0x18402ecc, 0x184c079a, 0x18168a55, 0x1800518b },
> +	{ 12, 0x18402ecc, 0x184c079a, 0x18168a55, 0x1800519f },
> +	{ 13, 0x18402ecc, 0x184c079e, 0x18168a55, 0x1800518b },
> +	{ 14, 0x18402ecc, 0x184c07a2, 0x18168a55, 0x18005193 },
> +
> +	/* 802.11 UNI / HyperLan 2 */
> +	{ 36, 0x18402ecc, 0x184c099a, 0x18158a55, 0x180ed1a3 },
> +	{ 38, 0x18402ecc, 0x184c099e, 0x18158a55, 0x180ed193 },
> +	{ 40, 0x18402ec8, 0x184c0682, 0x18158a55, 0x180ed183 },
> +	{ 44, 0x18402ec8, 0x184c0682, 0x18158a55, 0x180ed1a3 },
> +	{ 46, 0x18402ec8, 0x184c0686, 0x18158a55, 0x180ed18b },
> +	{ 48, 0x18402ec8, 0x184c0686, 0x18158a55, 0x180ed19b },
> +	{ 52, 0x18402ec8, 0x184c068a, 0x18158a55, 0x180ed193 },
> +	{ 54, 0x18402ec8, 0x184c068a, 0x18158a55, 0x180ed1a3 },
> +	{ 56, 0x18402ec8, 0x184c068e, 0x18158a55, 0x180ed18b },
> +	{ 60, 0x18402ec8, 0x184c0692, 0x18158a55, 0x180ed183 },
> +	{ 62, 0x18402ec8, 0x184c0692, 0x18158a55, 0x180ed193 },
> +	{ 64, 0x18402ec8, 0x184c0692, 0x18158a55, 0x180ed1a3 },
> +
> +	/* 802.11 HyperLan 2 */
> +	{ 100, 0x18402ec8, 0x184c06b2, 0x18178a55, 0x180ed783 },
> +	{ 102, 0x18402ec8, 0x184c06b2, 0x18578a55, 0x180ed793 },
> +	{ 104, 0x18402ec8, 0x185c06b2, 0x18578a55, 0x180ed1a3 },
> +	{ 108, 0x18402ecc, 0x185c0a32, 0x18578a55, 0x180ed193 },
> +	{ 110, 0x18402ecc, 0x184c0a36, 0x18178a55, 0x180ed183 },
> +	{ 112, 0x18402ecc, 0x184c0a36, 0x18178a55, 0x180ed19b },
> +	{ 116, 0x18402ecc, 0x184c0a3a, 0x18178a55, 0x180ed1a3 },
> +	{ 118, 0x18402ecc, 0x184c0a3e, 0x18178a55, 0x180ed193 },
> +	{ 120, 0x18402ec4, 0x184c0382, 0x18178a55, 0x180ed183 },
> +	{ 124, 0x18402ec4, 0x184c0382, 0x18178a55, 0x180ed193 },
> +	{ 126, 0x18402ec4, 0x184c0382, 0x18178a55, 0x180ed15b },
> +	{ 128, 0x18402ec4, 0x184c0382, 0x18178a55, 0x180ed1a3 },
> +	{ 132, 0x18402ec4, 0x184c0386, 0x18178a55, 0x180ed18b },
> +	{ 134, 0x18402ec4, 0x184c0386, 0x18178a55, 0x180ed193 },
> +	{ 136, 0x18402ec4, 0x184c0386, 0x18178a55, 0x180ed19b },
> +	{ 140, 0x18402ec4, 0x184c038a, 0x18178a55, 0x180ed183 },
> +
> +	/* 802.11 UNII */
> +	{ 149, 0x18402ec4, 0x184c038a, 0x18178a55, 0x180ed1a7 },
> +	{ 151, 0x18402ec4, 0x184c038e, 0x18178a55, 0x180ed187 },
> +	{ 153, 0x18402ec4, 0x184c038e, 0x18178a55, 0x180ed18f },
> +	{ 157, 0x18402ec4, 0x184c038e, 0x18178a55, 0x180ed19f },
> +	{ 159, 0x18402ec4, 0x184c038e, 0x18178a55, 0x180ed1a7 },
> +	{ 161, 0x18402ec4, 0x184c0392, 0x18178a55, 0x180ed187 },
> +	{ 165, 0x18402ec4, 0x184c0392, 0x18178a55, 0x180ed197 },
> +	{ 167, 0x18402ec4, 0x184c03d2, 0x18179855, 0x1815531f },
> +	{ 169, 0x18402ec4, 0x184c03d2, 0x18179855, 0x18155327 },
> +	{ 171, 0x18402ec4, 0x184c03d6, 0x18179855, 0x18155307 },
> +	{ 173, 0x18402ec4, 0x184c03d6, 0x18179855, 0x1815530f },
> +
> +	/* 802.11 Japan */
> +	{ 184, 0x15002ccc, 0x1500491e, 0x1509be55, 0x150c0a0b },
> +	{ 188, 0x15002ccc, 0x15004922, 0x1509be55, 0x150c0a13 },
> +	{ 192, 0x15002ccc, 0x15004926, 0x1509be55, 0x150c0a1b },
> +	{ 196, 0x15002ccc, 0x1500492a, 0x1509be55, 0x150c0a23 },
> +	{ 208, 0x15002ccc, 0x1500493a, 0x1509be55, 0x150c0a13 },
> +	{ 212, 0x15002ccc, 0x1500493e, 0x1509be55, 0x150c0a1b },
> +	{ 216, 0x15002ccc, 0x15004982, 0x1509be55, 0x150c0a23 },
> +};
> +
> +/*
> + * RF value list for rt3070
> + * Supports: 2.4 GHz
> + */
> +static const struct rf_channel rf_vals_3070[] = {
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
> +int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
> +{
> +	struct rt2x00_chip *chip = &rt2x00dev->chip;
> +	struct hw_mode_spec *spec = &rt2x00dev->spec;
> +	struct channel_info *info;
> +	char *tx_power1;
> +	char *tx_power2;
> +	unsigned int i;
> +	u16 eeprom;
> +
> +	/*
> +	 * Initialize all hw fields.
> +	 */
> +	rt2x00dev->hw->flags =
> +	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
> +	    IEEE80211_HW_SIGNAL_DBM |
> +	    IEEE80211_HW_SUPPORTS_PS |
> +	    IEEE80211_HW_PS_NULLFUNC_STACK;
> +
> +	if (rt2x00_intf_is_usb(rt2x00dev))
> +		rt2x00dev->hw->extra_tx_headroom =
> +			TXINFO_DESC_SIZE + TXWI_DESC_SIZE;
> +	else if (rt2x00_intf_is_pci(rt2x00dev))
> +		rt2x00dev->hw->extra_tx_headroom = TXWI_DESC_SIZE;
> +
> +	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
> +	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
> +				rt2x00_eeprom_addr(rt2x00dev,
> +						   EEPROM_MAC_ADDR_0));
> +
> +	rt2x00_eeprom_read(rt2x00dev, EEPROM_ANTENNA, &eeprom);
> +
> +	/*
> +	 * Initialize hw_mode information.
> +	 */
> +	spec->supported_bands = SUPPORT_BAND_2GHZ;
> +	spec->supported_rates = SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
> +
> +	if (rt2x00_rf(chip, RF2820) ||
> +	    rt2x00_rf(chip, RF2720) ||
> +	    (rt2x00_intf_is_pci(rt2x00dev) &&
> +	     (rt2x00_rf(chip, RF3020) ||
> +	      rt2x00_rf(chip, RF3021) ||
> +	      rt2x00_rf(chip, RF3022) ||
> +	      rt2x00_rf(chip, RF2020) ||
> +	      rt2x00_rf(chip, RF3052)))) {
> +		spec->num_channels = 14;
> +		spec->channels = rf_vals;
> +	} else if (rt2x00_rf(chip, RF2850) ||
> +		   rt2x00_rf(chip, RF2750)) {
> +		spec->supported_bands |= SUPPORT_BAND_5GHZ;
> +		spec->num_channels = ARRAY_SIZE(rf_vals);
> +		spec->channels = rf_vals;
> +	} else if (rt2x00_intf_is_usb(rt2x00dev) &&
> +		    (rt2x00_rf(chip, RF3020) ||
> +		     rt2x00_rf(chip, RF2020))) {
> +		spec->num_channels = ARRAY_SIZE(rf_vals_3070);
> +		spec->channels = rf_vals_3070;
> +	}
> +
> +	/*
> +	 * Initialize HT information.
> +	 */
> +	spec->ht.ht_supported = true;
> +	spec->ht.cap =
> +	    IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
> +	    IEEE80211_HT_CAP_GRN_FLD |
> +	    IEEE80211_HT_CAP_SGI_20 |
> +	    IEEE80211_HT_CAP_SGI_40 |
> +	    IEEE80211_HT_CAP_TX_STBC |
> +	    IEEE80211_HT_CAP_RX_STBC |
> +	    IEEE80211_HT_CAP_PSMP_SUPPORT;
> +	spec->ht.ampdu_factor = 3;
> +	spec->ht.ampdu_density = 4;
> +	spec->ht.mcs.tx_params =
> +	    IEEE80211_HT_MCS_TX_DEFINED |
> +	    IEEE80211_HT_MCS_TX_RX_DIFF |
> +	    ((rt2x00_get_field16(eeprom, EEPROM_ANTENNA_TXPATH) - 1) <<
> +		IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT);
> +
> +	switch (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RXPATH)) {
> +	case 3:
> +		spec->ht.mcs.rx_mask[2] = 0xff;
> +	case 2:
> +		spec->ht.mcs.rx_mask[1] = 0xff;
> +	case 1:
> +		spec->ht.mcs.rx_mask[0] = 0xff;
> +		spec->ht.mcs.rx_mask[4] = 0x1; /* MCS32 */
> +		break;
> +	}
> +
> +	/*
> +	 * Create channel information array
> +	 */
> +	info = kzalloc(spec->num_channels * sizeof(*info), GFP_KERNEL);
> +	if (!info)
> +		return -ENOMEM;
> +
> +	spec->channels_info = info;
> +
> +	tx_power1 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_BG1);
> +	tx_power2 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_BG2);
> +
> +	for (i = 0; i < 14; i++) {
> +		info[i].tx_power1 = TXPOWER_G_FROM_DEV(tx_power1[i]);
> +		info[i].tx_power2 = TXPOWER_G_FROM_DEV(tx_power2[i]);
> +	}
> +
> +	if (spec->num_channels > 14) {
> +		tx_power1 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A1);
> +		tx_power2 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A2);
> +
> +		for (i = 14; i < spec->num_channels; i++) {
> +			info[i].tx_power1 = TXPOWER_A_FROM_DEV(tx_power1[i]);
> +			info[i].tx_power2 = TXPOWER_A_FROM_DEV(tx_power2[i]);
> +		}
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(rt2800_probe_hw_mode);
> +
> +/*
>   * IEEE80211 stack callback functions.
>   */
>  static void rt2800_get_tkip_seq(struct ieee80211_hw *hw, u8 hw_key_idx,
> Index: b/drivers/net/wireless/rt2x00/rt2800lib.h
> ===================================================================
> --- a/drivers/net/wireless/rt2x00/rt2800lib.h
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.h
> @@ -131,6 +131,7 @@ int rt2800_init_rfcsr(struct rt2x00_dev 
>  
>  int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev);
>  int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev);
> +int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev);
>  
>  extern const struct ieee80211_ops rt2800_mac80211_ops;
>  
> Index: b/drivers/net/wireless/rt2x00/rt2800pci.c
> ===================================================================
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -1098,194 +1098,6 @@ static int rt2800pci_validate_eeprom(str
>  	return rt2800_validate_eeprom(rt2x00dev);
>  }
>  
> -/*
> - * RF value list for rt2860
> - * Supports: 2.4 GHz (all) & 5.2 GHz (RF2850 & RF2750)
> - */
> -static const struct rf_channel rf_vals[] = {
> -	{ 1,  0x18402ecc, 0x184c0786, 0x1816b455, 0x1800510b },
> -	{ 2,  0x18402ecc, 0x184c0786, 0x18168a55, 0x1800519f },
> -	{ 3,  0x18402ecc, 0x184c078a, 0x18168a55, 0x1800518b },
> -	{ 4,  0x18402ecc, 0x184c078a, 0x18168a55, 0x1800519f },
> -	{ 5,  0x18402ecc, 0x184c078e, 0x18168a55, 0x1800518b },
> -	{ 6,  0x18402ecc, 0x184c078e, 0x18168a55, 0x1800519f },
> -	{ 7,  0x18402ecc, 0x184c0792, 0x18168a55, 0x1800518b },
> -	{ 8,  0x18402ecc, 0x184c0792, 0x18168a55, 0x1800519f },
> -	{ 9,  0x18402ecc, 0x184c0796, 0x18168a55, 0x1800518b },
> -	{ 10, 0x18402ecc, 0x184c0796, 0x18168a55, 0x1800519f },
> -	{ 11, 0x18402ecc, 0x184c079a, 0x18168a55, 0x1800518b },
> -	{ 12, 0x18402ecc, 0x184c079a, 0x18168a55, 0x1800519f },
> -	{ 13, 0x18402ecc, 0x184c079e, 0x18168a55, 0x1800518b },
> -	{ 14, 0x18402ecc, 0x184c07a2, 0x18168a55, 0x18005193 },
> -
> -	/* 802.11 UNI / HyperLan 2 */
> -	{ 36, 0x18402ecc, 0x184c099a, 0x18158a55, 0x180ed1a3 },
> -	{ 38, 0x18402ecc, 0x184c099e, 0x18158a55, 0x180ed193 },
> -	{ 40, 0x18402ec8, 0x184c0682, 0x18158a55, 0x180ed183 },
> -	{ 44, 0x18402ec8, 0x184c0682, 0x18158a55, 0x180ed1a3 },
> -	{ 46, 0x18402ec8, 0x184c0686, 0x18158a55, 0x180ed18b },
> -	{ 48, 0x18402ec8, 0x184c0686, 0x18158a55, 0x180ed19b },
> -	{ 52, 0x18402ec8, 0x184c068a, 0x18158a55, 0x180ed193 },
> -	{ 54, 0x18402ec8, 0x184c068a, 0x18158a55, 0x180ed1a3 },
> -	{ 56, 0x18402ec8, 0x184c068e, 0x18158a55, 0x180ed18b },
> -	{ 60, 0x18402ec8, 0x184c0692, 0x18158a55, 0x180ed183 },
> -	{ 62, 0x18402ec8, 0x184c0692, 0x18158a55, 0x180ed193 },
> -	{ 64, 0x18402ec8, 0x184c0692, 0x18158a55, 0x180ed1a3 },
> -
> -	/* 802.11 HyperLan 2 */
> -	{ 100, 0x18402ec8, 0x184c06b2, 0x18178a55, 0x180ed783 },
> -	{ 102, 0x18402ec8, 0x184c06b2, 0x18578a55, 0x180ed793 },
> -	{ 104, 0x18402ec8, 0x185c06b2, 0x18578a55, 0x180ed1a3 },
> -	{ 108, 0x18402ecc, 0x185c0a32, 0x18578a55, 0x180ed193 },
> -	{ 110, 0x18402ecc, 0x184c0a36, 0x18178a55, 0x180ed183 },
> -	{ 112, 0x18402ecc, 0x184c0a36, 0x18178a55, 0x180ed19b },
> -	{ 116, 0x18402ecc, 0x184c0a3a, 0x18178a55, 0x180ed1a3 },
> -	{ 118, 0x18402ecc, 0x184c0a3e, 0x18178a55, 0x180ed193 },
> -	{ 120, 0x18402ec4, 0x184c0382, 0x18178a55, 0x180ed183 },
> -	{ 124, 0x18402ec4, 0x184c0382, 0x18178a55, 0x180ed193 },
> -	{ 126, 0x18402ec4, 0x184c0382, 0x18178a55, 0x180ed15b },
> -	{ 128, 0x18402ec4, 0x184c0382, 0x18178a55, 0x180ed1a3 },
> -	{ 132, 0x18402ec4, 0x184c0386, 0x18178a55, 0x180ed18b },
> -	{ 134, 0x18402ec4, 0x184c0386, 0x18178a55, 0x180ed193 },
> -	{ 136, 0x18402ec4, 0x184c0386, 0x18178a55, 0x180ed19b },
> -	{ 140, 0x18402ec4, 0x184c038a, 0x18178a55, 0x180ed183 },
> -
> -	/* 802.11 UNII */
> -	{ 149, 0x18402ec4, 0x184c038a, 0x18178a55, 0x180ed1a7 },
> -	{ 151, 0x18402ec4, 0x184c038e, 0x18178a55, 0x180ed187 },
> -	{ 153, 0x18402ec4, 0x184c038e, 0x18178a55, 0x180ed18f },
> -	{ 157, 0x18402ec4, 0x184c038e, 0x18178a55, 0x180ed19f },
> -	{ 159, 0x18402ec4, 0x184c038e, 0x18178a55, 0x180ed1a7 },
> -	{ 161, 0x18402ec4, 0x184c0392, 0x18178a55, 0x180ed187 },
> -	{ 165, 0x18402ec4, 0x184c0392, 0x18178a55, 0x180ed197 },
> -	{ 167, 0x18402ec4, 0x184c03d2, 0x18179855, 0x1815531f },
> -	{ 169, 0x18402ec4, 0x184c03d2, 0x18179855, 0x18155327 },
> -	{ 171, 0x18402ec4, 0x184c03d6, 0x18179855, 0x18155307 },
> -	{ 173, 0x18402ec4, 0x184c03d6, 0x18179855, 0x1815530f },
> -
> -	/* 802.11 Japan */
> -	{ 184, 0x15002ccc, 0x1500491e, 0x1509be55, 0x150c0a0b },
> -	{ 188, 0x15002ccc, 0x15004922, 0x1509be55, 0x150c0a13 },
> -	{ 192, 0x15002ccc, 0x15004926, 0x1509be55, 0x150c0a1b },
> -	{ 196, 0x15002ccc, 0x1500492a, 0x1509be55, 0x150c0a23 },
> -	{ 208, 0x15002ccc, 0x1500493a, 0x1509be55, 0x150c0a13 },
> -	{ 212, 0x15002ccc, 0x1500493e, 0x1509be55, 0x150c0a1b },
> -	{ 216, 0x15002ccc, 0x15004982, 0x1509be55, 0x150c0a23 },
> -};
> -
> -static int rt2800pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
> -{
> -	struct rt2x00_chip *chip = &rt2x00dev->chip;
> -	struct hw_mode_spec *spec = &rt2x00dev->spec;
> -	struct channel_info *info;
> -	char *tx_power1;
> -	char *tx_power2;
> -	unsigned int i;
> -	u16 eeprom;
> -
> -	/*
> -	 * Initialize all hw fields.
> -	 */
> -	rt2x00dev->hw->flags =
> -	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
> -	    IEEE80211_HW_SIGNAL_DBM |
> -	    IEEE80211_HW_SUPPORTS_PS |
> -	    IEEE80211_HW_PS_NULLFUNC_STACK;
> -
> -	if (rt2x00_intf_is_pci(rt2x00dev))
> -		rt2x00dev->hw->extra_tx_headroom = TXWI_DESC_SIZE;
> -
> -	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
> -	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
> -				rt2x00_eeprom_addr(rt2x00dev,
> -						   EEPROM_MAC_ADDR_0));
> -
> -	rt2x00_eeprom_read(rt2x00dev, EEPROM_ANTENNA, &eeprom);
> -
> -	/*
> -	 * Initialize hw_mode information.
> -	 */
> -	spec->supported_bands = SUPPORT_BAND_2GHZ;
> -	spec->supported_rates = SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
> -
> -	if (rt2x00_rf(chip, RF2820) ||
> -	    rt2x00_rf(chip, RF2720) ||
> -	    (rt2x00_intf_is_pci(rt2x00dev) &&
> -	     (rt2x00_rf(chip, RF3020) ||
> -	      rt2x00_rf(chip, RF3021) ||
> -	      rt2x00_rf(chip, RF3022) ||
> -	      rt2x00_rf(chip, RF2020) ||
> -	      rt2x00_rf(chip, RF3052)))) {
> -		spec->num_channels = 14;
> -		spec->channels = rf_vals;
> -	} else if (rt2x00_rf(chip, RF2850) ||
> -		   rt2x00_rf(chip, RF2750)) {
> -		spec->supported_bands |= SUPPORT_BAND_5GHZ;
> -		spec->num_channels = ARRAY_SIZE(rf_vals);
> -		spec->channels = rf_vals;
> -	}
> -
> -	/*
> -	 * Initialize HT information.
> -	 */
> -	spec->ht.ht_supported = true;
> -	spec->ht.cap =
> -	    IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
> -	    IEEE80211_HT_CAP_GRN_FLD |
> -	    IEEE80211_HT_CAP_SGI_20 |
> -	    IEEE80211_HT_CAP_SGI_40 |
> -	    IEEE80211_HT_CAP_TX_STBC |
> -	    IEEE80211_HT_CAP_RX_STBC |
> -	    IEEE80211_HT_CAP_PSMP_SUPPORT;
> -	spec->ht.ampdu_factor = 3;
> -	spec->ht.ampdu_density = 4;
> -	spec->ht.mcs.tx_params =
> -	    IEEE80211_HT_MCS_TX_DEFINED |
> -	    IEEE80211_HT_MCS_TX_RX_DIFF |
> -	    ((rt2x00_get_field16(eeprom, EEPROM_ANTENNA_TXPATH) - 1) <<
> -		IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT);
> -
> -	switch (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RXPATH)) {
> -	case 3:
> -		spec->ht.mcs.rx_mask[2] = 0xff;
> -	case 2:
> -		spec->ht.mcs.rx_mask[1] = 0xff;
> -	case 1:
> -		spec->ht.mcs.rx_mask[0] = 0xff;
> -		spec->ht.mcs.rx_mask[4] = 0x1; /* MCS32 */
> -		break;
> -	}
> -
> -	/*
> -	 * Create channel information array
> -	 */
> -	info = kzalloc(spec->num_channels * sizeof(*info), GFP_KERNEL);
> -	if (!info)
> -		return -ENOMEM;
> -
> -	spec->channels_info = info;
> -
> -	tx_power1 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_BG1);
> -	tx_power2 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_BG2);
> -
> -	for (i = 0; i < 14; i++) {
> -		info[i].tx_power1 = TXPOWER_G_FROM_DEV(tx_power1[i]);
> -		info[i].tx_power2 = TXPOWER_G_FROM_DEV(tx_power2[i]);
> -	}
> -
> -	if (spec->num_channels > 14) {
> -		tx_power1 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A1);
> -		tx_power2 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A2);
> -
> -		for (i = 14; i < spec->num_channels; i++) {
> -			info[i].tx_power1 = TXPOWER_A_FROM_DEV(tx_power1[i]);
> -			info[i].tx_power2 = TXPOWER_A_FROM_DEV(tx_power2[i]);
> -		}
> -	}
> -
> -	return 0;
> -}
> -
>  static const struct rt2800_ops rt2800pci_rt2800_ops = {
>  	.register_read		= rt2x00pci_register_read,
>  	.register_write		= rt2x00pci_register_write,
> @@ -1319,7 +1131,7 @@ static int rt2800pci_probe_hw(struct rt2
>  	/*
>  	 * Initialize hw specifications.
>  	 */
> -	retval = rt2800pci_probe_hw_mode(rt2x00dev);
> +	retval = rt2800_probe_hw_mode(rt2x00dev);
>  	if (retval)
>  		return retval;
>  
> Index: b/drivers/net/wireless/rt2x00/rt2800usb.c
> ===================================================================
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -672,215 +672,6 @@ static int rt2800usb_validate_eeprom(str
>  	return rt2800_validate_eeprom(rt2x00dev);
>  }
>  
> -/*
> - * RF value list for rt2870
> - * Supports: 2.4 GHz (all) & 5.2 GHz (RF2850 & RF2750)
> - */
> -static const struct rf_channel rf_vals[] = {
> -	{ 1,  0x18402ecc, 0x184c0786, 0x1816b455, 0x1800510b },
> -	{ 2,  0x18402ecc, 0x184c0786, 0x18168a55, 0x1800519f },
> -	{ 3,  0x18402ecc, 0x184c078a, 0x18168a55, 0x1800518b },
> -	{ 4,  0x18402ecc, 0x184c078a, 0x18168a55, 0x1800519f },
> -	{ 5,  0x18402ecc, 0x184c078e, 0x18168a55, 0x1800518b },
> -	{ 6,  0x18402ecc, 0x184c078e, 0x18168a55, 0x1800519f },
> -	{ 7,  0x18402ecc, 0x184c0792, 0x18168a55, 0x1800518b },
> -	{ 8,  0x18402ecc, 0x184c0792, 0x18168a55, 0x1800519f },
> -	{ 9,  0x18402ecc, 0x184c0796, 0x18168a55, 0x1800518b },
> -	{ 10, 0x18402ecc, 0x184c0796, 0x18168a55, 0x1800519f },
> -	{ 11, 0x18402ecc, 0x184c079a, 0x18168a55, 0x1800518b },
> -	{ 12, 0x18402ecc, 0x184c079a, 0x18168a55, 0x1800519f },
> -	{ 13, 0x18402ecc, 0x184c079e, 0x18168a55, 0x1800518b },
> -	{ 14, 0x18402ecc, 0x184c07a2, 0x18168a55, 0x18005193 },
> -
> -	/* 802.11 UNI / HyperLan 2 */
> -	{ 36, 0x18402ecc, 0x184c099a, 0x18158a55, 0x180ed1a3 },
> -	{ 38, 0x18402ecc, 0x184c099e, 0x18158a55, 0x180ed193 },
> -	{ 40, 0x18402ec8, 0x184c0682, 0x18158a55, 0x180ed183 },
> -	{ 44, 0x18402ec8, 0x184c0682, 0x18158a55, 0x180ed1a3 },
> -	{ 46, 0x18402ec8, 0x184c0686, 0x18158a55, 0x180ed18b },
> -	{ 48, 0x18402ec8, 0x184c0686, 0x18158a55, 0x180ed19b },
> -	{ 52, 0x18402ec8, 0x184c068a, 0x18158a55, 0x180ed193 },
> -	{ 54, 0x18402ec8, 0x184c068a, 0x18158a55, 0x180ed1a3 },
> -	{ 56, 0x18402ec8, 0x184c068e, 0x18158a55, 0x180ed18b },
> -	{ 60, 0x18402ec8, 0x184c0692, 0x18158a55, 0x180ed183 },
> -	{ 62, 0x18402ec8, 0x184c0692, 0x18158a55, 0x180ed193 },
> -	{ 64, 0x18402ec8, 0x184c0692, 0x18158a55, 0x180ed1a3 },
> -
> -	/* 802.11 HyperLan 2 */
> -	{ 100, 0x18402ec8, 0x184c06b2, 0x18178a55, 0x180ed783 },
> -	{ 102, 0x18402ec8, 0x184c06b2, 0x18578a55, 0x180ed793 },
> -	{ 104, 0x18402ec8, 0x185c06b2, 0x18578a55, 0x180ed1a3 },
> -	{ 108, 0x18402ecc, 0x185c0a32, 0x18578a55, 0x180ed193 },
> -	{ 110, 0x18402ecc, 0x184c0a36, 0x18178a55, 0x180ed183 },
> -	{ 112, 0x18402ecc, 0x184c0a36, 0x18178a55, 0x180ed19b },
> -	{ 116, 0x18402ecc, 0x184c0a3a, 0x18178a55, 0x180ed1a3 },
> -	{ 118, 0x18402ecc, 0x184c0a3e, 0x18178a55, 0x180ed193 },
> -	{ 120, 0x18402ec4, 0x184c0382, 0x18178a55, 0x180ed183 },
> -	{ 124, 0x18402ec4, 0x184c0382, 0x18178a55, 0x180ed193 },
> -	{ 126, 0x18402ec4, 0x184c0382, 0x18178a55, 0x180ed15b },
> -	{ 128, 0x18402ec4, 0x184c0382, 0x18178a55, 0x180ed1a3 },
> -	{ 132, 0x18402ec4, 0x184c0386, 0x18178a55, 0x180ed18b },
> -	{ 134, 0x18402ec4, 0x184c0386, 0x18178a55, 0x180ed193 },
> -	{ 136, 0x18402ec4, 0x184c0386, 0x18178a55, 0x180ed19b },
> -	{ 140, 0x18402ec4, 0x184c038a, 0x18178a55, 0x180ed183 },
> -
> -	/* 802.11 UNII */
> -	{ 149, 0x18402ec4, 0x184c038a, 0x18178a55, 0x180ed1a7 },
> -	{ 151, 0x18402ec4, 0x184c038e, 0x18178a55, 0x180ed187 },
> -	{ 153, 0x18402ec4, 0x184c038e, 0x18178a55, 0x180ed18f },
> -	{ 157, 0x18402ec4, 0x184c038e, 0x18178a55, 0x180ed19f },
> -	{ 159, 0x18402ec4, 0x184c038e, 0x18178a55, 0x180ed1a7 },
> -	{ 161, 0x18402ec4, 0x184c0392, 0x18178a55, 0x180ed187 },
> -	{ 165, 0x18402ec4, 0x184c0392, 0x18178a55, 0x180ed197 },
> -	{ 167, 0x18402ec4, 0x184c03d2, 0x18179855, 0x1815531f },
> -	{ 169, 0x18402ec4, 0x184c03d2, 0x18179855, 0x18155327 },
> -	{ 171, 0x18402ec4, 0x184c03d6, 0x18179855, 0x18155307 },
> -	{ 173, 0x18402ec4, 0x184c03d6, 0x18179855, 0x1815530f },
> -
> -	/* 802.11 Japan */
> -	{ 184, 0x15002ccc, 0x1500491e, 0x1509be55, 0x150c0a0b },
> -	{ 188, 0x15002ccc, 0x15004922, 0x1509be55, 0x150c0a13 },
> -	{ 192, 0x15002ccc, 0x15004926, 0x1509be55, 0x150c0a1b },
> -	{ 196, 0x15002ccc, 0x1500492a, 0x1509be55, 0x150c0a23 },
> -	{ 208, 0x15002ccc, 0x1500493a, 0x1509be55, 0x150c0a13 },
> -	{ 212, 0x15002ccc, 0x1500493e, 0x1509be55, 0x150c0a1b },
> -	{ 216, 0x15002ccc, 0x15004982, 0x1509be55, 0x150c0a23 },
> -};
> -
> -/*
> - * RF value list for rt3070
> - * Supports: 2.4 GHz
> - */
> -static const struct rf_channel rf_vals_3070[] = {
> -	{1,  241, 2, 2 },
> -	{2,  241, 2, 7 },
> -	{3,  242, 2, 2 },
> -	{4,  242, 2, 7 },
> -	{5,  243, 2, 2 },
> -	{6,  243, 2, 7 },
> -	{7,  244, 2, 2 },
> -	{8,  244, 2, 7 },
> -	{9,  245, 2, 2 },
> -	{10, 245, 2, 7 },
> -	{11, 246, 2, 2 },
> -	{12, 246, 2, 7 },
> -	{13, 247, 2, 2 },
> -	{14, 248, 2, 4 },
> -};
> -
> -static int rt2800usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
> -{
> -	struct rt2x00_chip *chip = &rt2x00dev->chip;
> -	struct hw_mode_spec *spec = &rt2x00dev->spec;
> -	struct channel_info *info;
> -	char *tx_power1;
> -	char *tx_power2;
> -	unsigned int i;
> -	u16 eeprom;
> -
> -	/*
> -	 * Initialize all hw fields.
> -	 */
> -	rt2x00dev->hw->flags =
> -	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
> -	    IEEE80211_HW_SIGNAL_DBM |
> -	    IEEE80211_HW_SUPPORTS_PS |
> -	    IEEE80211_HW_PS_NULLFUNC_STACK;
> -
> -	if (rt2x00_intf_is_usb(rt2x00dev))
> -		rt2x00dev->hw->extra_tx_headroom =
> -			TXINFO_DESC_SIZE + TXWI_DESC_SIZE;
> -
> -	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
> -	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
> -				rt2x00_eeprom_addr(rt2x00dev,
> -						   EEPROM_MAC_ADDR_0));
> -
> -	rt2x00_eeprom_read(rt2x00dev, EEPROM_ANTENNA, &eeprom);
> -
> -	/*
> -	 * Initialize hw_mode information.
> -	 */
> -	spec->supported_bands = SUPPORT_BAND_2GHZ;
> -	spec->supported_rates = SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
> -
> -	if (rt2x00_rf(chip, RF2820) ||
> -	    rt2x00_rf(chip, RF2720)) {
> -		spec->num_channels = 14;
> -		spec->channels = rf_vals;
> -	} else if (rt2x00_rf(chip, RF2850) ||
> -		   rt2x00_rf(chip, RF2750)) {
> -		spec->supported_bands |= SUPPORT_BAND_5GHZ;
> -		spec->num_channels = ARRAY_SIZE(rf_vals);
> -		spec->channels = rf_vals;
> -	} else if (rt2x00_intf_is_usb(rt2x00dev) &&
> -		    (rt2x00_rf(chip, RF3020) ||
> -		     rt2x00_rf(chip, RF2020))) {
> -		spec->num_channels = ARRAY_SIZE(rf_vals_3070);
> -		spec->channels = rf_vals_3070;
> -	}
> -
> -	/*
> -	 * Initialize HT information.
> -	 */
> -	spec->ht.ht_supported = true;
> -	spec->ht.cap =
> -	    IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
> -	    IEEE80211_HT_CAP_GRN_FLD |
> -	    IEEE80211_HT_CAP_SGI_20 |
> -	    IEEE80211_HT_CAP_SGI_40 |
> -	    IEEE80211_HT_CAP_TX_STBC |
> -	    IEEE80211_HT_CAP_RX_STBC |
> -	    IEEE80211_HT_CAP_PSMP_SUPPORT;
> -	spec->ht.ampdu_factor = 3;
> -	spec->ht.ampdu_density = 4;
> -	spec->ht.mcs.tx_params =
> -	    IEEE80211_HT_MCS_TX_DEFINED |
> -	    IEEE80211_HT_MCS_TX_RX_DIFF |
> -	    ((rt2x00_get_field16(eeprom, EEPROM_ANTENNA_TXPATH) - 1) <<
> -		IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT);
> -
> -	switch (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RXPATH)) {
> -	case 3:
> -		spec->ht.mcs.rx_mask[2] = 0xff;
> -	case 2:
> -		spec->ht.mcs.rx_mask[1] = 0xff;
> -	case 1:
> -		spec->ht.mcs.rx_mask[0] = 0xff;
> -		spec->ht.mcs.rx_mask[4] = 0x1; /* MCS32 */
> -		break;
> -	}
> -
> -	/*
> -	 * Create channel information array
> -	 */
> -	info = kzalloc(spec->num_channels * sizeof(*info), GFP_KERNEL);
> -	if (!info)
> -		return -ENOMEM;
> -
> -	spec->channels_info = info;
> -
> -	tx_power1 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_BG1);
> -	tx_power2 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_BG2);
> -
> -	for (i = 0; i < 14; i++) {
> -		info[i].tx_power1 = TXPOWER_G_FROM_DEV(tx_power1[i]);
> -		info[i].tx_power2 = TXPOWER_G_FROM_DEV(tx_power2[i]);
> -	}
> -
> -	if (spec->num_channels > 14) {
> -		tx_power1 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A1);
> -		tx_power2 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A2);
> -
> -		for (i = 14; i < spec->num_channels; i++) {
> -			info[i].tx_power1 = TXPOWER_A_FROM_DEV(tx_power1[i]);
> -			info[i].tx_power2 = TXPOWER_A_FROM_DEV(tx_power2[i]);
> -		}
> -	}
> -
> -	return 0;
> -}
> -
>  static const struct rt2800_ops rt2800usb_rt2800_ops = {
>  	.register_read		= rt2x00usb_register_read,
>  	.register_write		= rt2x00usb_register_write,
> @@ -914,7 +705,7 @@ static int rt2800usb_probe_hw(struct rt2
>  	/*
>  	 * Initialize hw specifications.
>  	 */
> -	retval = rt2800usb_probe_hw_mode(rt2x00dev);
> +	retval = rt2800_probe_hw_mode(rt2x00dev);
>  	if (retval)
>  		return retval;
>  
> 


