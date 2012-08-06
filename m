Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41158 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932477Ab2HFTPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 15:15:12 -0400
Date: Mon, 6 Aug 2012 15:03:17 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] p54: parse output power table
Message-ID: <20120806190317.GB26210@tuxdriver.com> (sfid-20120806_211520_253663_50ACD9D1)
References: <E1Suve7-0006U2-4H@debian64.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <E1Suve7-0006U2-4H@debian64.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

patching file drivers/net/wireless/p54/eeprom.c
Hunk #1 succeeded at 77 with fuzz 2 (offset 1 line).
Hunk #2 succeeded at 175 (offset 1 line).
Hunk #3 FAILED at 192.
Hunk #4 succeeded at 233 (offset 2 lines).
Hunk #5 FAILED at 244.
Hunk #6 succeeded at 321 (offset 3 lines).
Hunk #7 succeeded at 847 (offset 3 lines).
2 out of 7 hunks FAILED -- saving rejects to file drivers/net/wireless/p54/eeprom.c.rej
patching file drivers/net/wireless/p54/eeprom.h

On Sat, Jul 28, 2012 at 02:57:51AM +0200, Christian Lamparter wrote:
> For the upcoming tpc changes, the driver needs
> to provide sensible max output values for each
> supported channel.
> 
> And while the eeprom always had a output_limit
> table, which defines the upper limit for each
> frequency and modulation, it was never really
> useful for anything... until now.
> 
> Note: For anyone wondering about what your card
> is calibrated for: check "iw list".
> 	* 2412 MHz [1] (18.0 dBm)
> 	* 2437 MHz [6] (19.0 dBm)
> 	[...]
> 	* 5180 MHz [36] (18.0 dBm)
> 	* 5260 MHz [52] (17.0 dBm) (radar detection)
> 	* 5680 MHz [136] (19.0 dBm) (radar detection)
> (for a Dell Wireless 1450 USB Adapter)
> 
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> ---
>  drivers/net/wireless/p54/eeprom.c |  104 ++++++++++++++++++++++++++++---------
>  drivers/net/wireless/p54/eeprom.h |   12 +++++
>  2 files changed, 92 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/net/wireless/p54/eeprom.c b/drivers/net/wireless/p54/eeprom.c
> index fa8ce51..d9ee222 100644
> --- a/drivers/net/wireless/p54/eeprom.c
> +++ b/drivers/net/wireless/p54/eeprom.c
> @@ -76,6 +76,7 @@ struct p54_channel_entry {
>  	u16 freq;
>  	u16 data;
>  	int index;
> +	int max_power;
>  	enum ieee80211_band band;
>  };
>  
> @@ -173,6 +174,7 @@ static int p54_generate_band(struct ieee80211_hw *dev,
>  	for (i = 0, j = 0; (j < list->band_channel_num[band]) &&
>  			   (i < list->entries); i++) {
>  		struct p54_channel_entry *chan = &list->channels[i];
> +		struct ieee80211_channel *dest = &tmp->channels[j];
>  
>  		if (chan->band != band)
>  			continue;
> @@ -190,14 +192,15 @@ static int p54_generate_band(struct ieee80211_hw *dev,
>  			continue;
>  		}
>  
> -		tmp->channels[j].band = chan->band;
> -		tmp->channels[j].center_freq = chan->freq;
> +		dest->band = chan->band;
> +		dest->center_freq = chan->freq;
> +		dest->max_power = chan->max_power;
>  		priv->survey[*chan_num].channel = &tmp->channels[j];
>  		priv->survey[*chan_num].filled = SURVEY_INFO_NOISE_DBM |
>  			SURVEY_INFO_CHANNEL_TIME |
>  			SURVEY_INFO_CHANNEL_TIME_BUSY |
>  			SURVEY_INFO_CHANNEL_TIME_TX;
> -		tmp->channels[j].hw_value = (*chan_num);
> +		dest->hw_value = (*chan_num);
>  		j++;
>  		(*chan_num)++;
>  	}
> @@ -229,10 +232,11 @@ err_out:
>  	return ret;
>  }
>  
> -static void p54_update_channel_param(struct p54_channel_list *list,
> -				     u16 freq, u16 data)
> +static struct p54_channel_entry *p54_update_channel_param(struct p54_channel_list *list,
> +							  u16 freq, u16 data)
>  {
> -	int band, i;
> +	int i;
> +	struct p54_channel_entry *entry = NULL;
>  
>  	/*
>  	 * usually all lists in the eeprom are mostly sorted.
> @@ -241,30 +245,74 @@ static void p54_update_channel_param(struct p54_channel_list *list,
>  	 */
>  	for (i = list->entries; i >= 0; i--) {
>  		if (freq == list->channels[i].freq) {
> -			list->channels[i].data |= data;
> +			entry = &list->channels[i];
>  			break;
>  		}
>  	}
>  
>  	if ((i < 0) && (list->entries < list->max_entries)) {
>  		/* entry does not exist yet. Initialize a new one. */
> -		band = p54_get_band_from_freq(freq);
> +		int band = p54_get_band_from_freq(freq);
>  
>  		/*
>  		 * filter out frequencies which don't belong into
>  		 * any supported band.
>  		 */
> -		if (band < 0)
> -			return ;
> +		if (band >= 0) {
> +			i = list->entries++;
> +			list->band_channel_num[band]++;
> +
> +			entry = &list->channels[i];
> +			entry->freq = freq;
> +			entry->band = band;
> +			entry->index = ieee80211_frequency_to_channel(freq);
> +			entry->max_power = 0;
> +			entry->data = 0;
> +		}
> +	}
>  
> -		i = list->entries++;
> -		list->band_channel_num[band]++;
> +	if (entry)
> +		entry->data |= data;
>  
> -		list->channels[i].freq = freq;
> -		list->channels[i].data = data;
> -		list->channels[i].band = band;
> -		list->channels[i].index = ieee80211_frequency_to_channel(freq);
> -		/* TODO: parse output_limit and fill max_power */
> +	return entry;
> +}
> +
> +static int p54_get_maxpower(struct p54_common *priv, void *data)
> +{
> +	switch (priv->rxhw & PDR_SYNTH_FRONTEND_MASK) {
> +	case PDR_SYNTH_FRONTEND_LONGBOW: {
> +		struct pda_channel_output_limit_longbow *pda = data;
> +		int j;
> +		u16 rawpower = 0;
> +		pda = data;
> +		for (j = 0; j < ARRAY_SIZE(pda->point); j++) {
> +			struct pda_channel_output_limit_point_longbow *point =
> +				&pda->point[j];
> +			rawpower = max(rawpower, le16_to_cpu(point->val_qpsk));
> +			rawpower = max(rawpower, le16_to_cpu(point->val_bpsk));
> +			rawpower = max(rawpower, le16_to_cpu(point->val_16qam));
> +			rawpower = max(rawpower, le16_to_cpu(point->val_64qam));
> +		}
> +		/* longbow seems to use 1/16 dBm units */
> +		return rawpower / 16;
> +		}
> +
> +	case PDR_SYNTH_FRONTEND_DUETTE3:
> +	case PDR_SYNTH_FRONTEND_DUETTE2:
> +	case PDR_SYNTH_FRONTEND_FRISBEE:
> +	case PDR_SYNTH_FRONTEND_XBOW: {
> +		struct pda_channel_output_limit *pda = data;
> +		u8 rawpower = 0;
> +		rawpower = max(rawpower, pda->val_qpsk);
> +		rawpower = max(rawpower, pda->val_bpsk);
> +		rawpower = max(rawpower, pda->val_16qam);
> +		rawpower = max(rawpower, pda->val_64qam);
> +		/* raw values are in 1/4 dBm units */
> +		return rawpower / 4;
> +		}
> +
> +	default:
> +		return 20;
>  	}
>  }
>  
> @@ -315,12 +363,19 @@ static int p54_generate_channel_lists(struct ieee80211_hw *dev)
>  		}
>  
>  		if (i < priv->output_limit->entries) {
> -			freq = le16_to_cpup((__le16 *) (i *
> -					    priv->output_limit->entry_size +
> -					    priv->output_limit->offset +
> -					    priv->output_limit->data));
> -
> -			p54_update_channel_param(list, freq, CHAN_HAS_LIMIT);
> +			struct p54_channel_entry *tmp;
> +
> +			void *data = (void *) ((unsigned long) i *
> +				priv->output_limit->entry_size +
> +				priv->output_limit->offset +
> +				priv->output_limit->data);
> +
> +			freq = le16_to_cpup((__le16 *) data);
> +			tmp = p54_update_channel_param(list, freq,
> +						       CHAN_HAS_LIMIT);
> +			if (tmp) {
> +				tmp->max_power = p54_get_maxpower(priv, data);
> +			}
>  		}
>  
>  		if (i < priv->curve_data->entries) {
> @@ -834,11 +889,12 @@ good_eeprom:
>  		goto err;
>  	}
>  
> +	priv->rxhw = synth & PDR_SYNTH_FRONTEND_MASK;
> +
>  	err = p54_generate_channel_lists(dev);
>  	if (err)
>  		goto err;
>  
> -	priv->rxhw = synth & PDR_SYNTH_FRONTEND_MASK;
>  	if (priv->rxhw == PDR_SYNTH_FRONTEND_XBOW)
>  		p54_init_xbow_synth(priv);
>  	if (!(synth & PDR_SYNTH_24_GHZ_DISABLED))
> diff --git a/drivers/net/wireless/p54/eeprom.h b/drivers/net/wireless/p54/eeprom.h
> index afde72b..20ebe39 100644
> --- a/drivers/net/wireless/p54/eeprom.h
> +++ b/drivers/net/wireless/p54/eeprom.h
> @@ -57,6 +57,18 @@ struct pda_channel_output_limit {
>  	u8 rate_set_size;
>  } __packed;
>  
> +struct pda_channel_output_limit_point_longbow {
> +	__le16 val_bpsk;
> +	__le16 val_qpsk;
> +	__le16 val_16qam;
> +	__le16 val_64qam;
> +} __packed;
> +
> +struct pda_channel_output_limit_longbow {
> +	__le16 freq;
> +	struct pda_channel_output_limit_point_longbow point[3];
> +} __packed;
> +
>  struct pda_pa_curve_data_sample_rev0 {
>  	u8 rf_power;
>  	u8 pa_detector;
> -- 
> 1.7.10.4
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
