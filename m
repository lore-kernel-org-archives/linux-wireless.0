Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:50938 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbYLWQKG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 11:10:06 -0500
Received: by ewy10 with SMTP id 10so2801202ewy.13
        for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2008 08:10:03 -0800 (PST)
Message-ID: <49510D4F.7060102@gmail.com> (sfid-20081223_171016_090925_15DFD5A6)
Date: Tue, 23 Dec 2008 11:09:51 -0500
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: David Kilroy <kilroyd@googlemail.com>
CC: linux-wireless@vger.kernel.org, simon@thekelleys.org.uk,
	jussi.kivilinna@mbnet.fi, acme@ghostprotocols.net, pe1rxq@amsat.org
Subject: Re: [PATCH] wireless: Add channel/frequency conversions to ieee80211.h
References: <1230041018-13341-1-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1230041018-13341-1-git-send-email-kilroyd@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Kilroy wrote:
> Added mappings for FHSS, DSSS and OFDM channels - with macros to point
> HR DSSS and ERP to the DSSS mappings. Currently just static inline
> functions.
>
> Use the new functions in the older fullmac drivers. This eliminates a
> number of const static buffers and removes a couple of range checks that
> are now redundant.
>
> Signed-off-by: David Kilroy <kilroyd@googlemail.com>
> ---
>
> This has changed from the RFC as follows:
>
> - freq_to_chan conversions return the channel with the closest
>   center frequency (instead of rounding down)
> - Remove a couple frequency checks which are now redundant
> - Leaving the WE exponents alone
>
> Also note this changes the frequency reported by wl3501 for channel 14.
> I've assumed this is a fix...
>
> ---
>  drivers/net/wireless/airo.c            |   25 ++-----
>  drivers/net/wireless/atmel.c           |   20 ++---
>  drivers/net/wireless/orinoco/orinoco.c |   33 ++++-----
>  drivers/net/wireless/rndis_wlan.c      |   13 ++--
>  drivers/net/wireless/wl3501_cs.c       |    9 +--
>  drivers/net/wireless/zd1201.c          |    7 +-
>  include/linux/ieee80211.h              |  116 ++++++++++++++++++++++++++++++++
>  7 files changed, 155 insertions(+), 68 deletions(-)
>
> diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
> index 45f8384..35f28ee 100644
> --- a/drivers/net/wireless/airo.c
> +++ b/drivers/net/wireless/airo.c
> @@ -1070,10 +1070,6 @@ static WifiCtlHdr wifictlhdr8023 = {
>  	}
>  };
>  
> -// Frequency list (map channels to frequencies)
> -static const long frequency_list[] = { 2412, 2417, 2422, 2427, 2432, 2437, 2442,
> -				2447, 2452, 2457, 2462, 2467, 2472, 2484 };
> -
>  // A few details needed for WEP (Wireless Equivalent Privacy)
>  #define MAX_KEY_SIZE 13			// 128 (?) bits
>  #define MIN_KEY_SIZE  5			// 40 bits RC4 - WEP
> @@ -5735,16 +5731,12 @@ static int airo_set_freq(struct net_device *dev,
>  	int rc = -EINPROGRESS;		/* Call commit handler */
>  
>  	/* If setting by frequency, convert to a channel */
> -	if((fwrq->e == 1) &&
> -	   (fwrq->m >= (int) 2.412e8) &&
> -	   (fwrq->m <= (int) 2.487e8)) {
> +	if(fwrq->e == 1) {
>  		int f = fwrq->m / 100000;
> -		int c = 0;
> -		while((c < 14) && (f != frequency_list[c]))
> -			c++;
> +
>  		/* Hack to fall through... */
>  		fwrq->e = 0;
> -		fwrq->m = c + 1;
> +		fwrq->m = ieee80211_freq_to_dsss_chan(f);
>  	}
>  	/* Setting by channel number */
>  	if((fwrq->m > 1000) || (fwrq->e > 0))
> @@ -5788,7 +5780,7 @@ static int airo_get_freq(struct net_device *dev,
>  
>  	ch = le16_to_cpu(status_rid.channel);
>  	if((ch > 0) && (ch < 15)) {
> -		fwrq->m = frequency_list[ch - 1] * 100000;
> +		fwrq->m = ieee80211_dsss_chan_to_freq(ch) * 100000;
>  		fwrq->e = 1;
>  	} else {
>  		fwrq->m = ch;
> @@ -6805,8 +6797,8 @@ static int airo_get_range(struct net_device *dev,
>  	k = 0;
>  	for(i = 0; i < 14; i++) {
>  		range->freq[k].i = i + 1; /* List index */
> -		range->freq[k].m = frequency_list[i] * 100000;
> -		range->freq[k++].e = 1;	/* Values in table in MHz -> * 10^5 * 10 */
> +		range->freq[k].m = ieee80211_dsss_chan_to_freq(i + 1) * 100000;
> +		range->freq[k++].e = 1;	/* Values in MHz -> * 10^5 * 10 */
>  	}
>  	range->num_frequency = k;
>  
> @@ -7199,10 +7191,7 @@ static inline char *airo_translate_scan(struct net_device *dev,
>  	/* Add frequency */
>  	iwe.cmd = SIOCGIWFREQ;
>  	iwe.u.freq.m = le16_to_cpu(bss->dsChannel);
> -	/* iwe.u.freq.m containt the channel (starting 1), our 
> -	 * frequency_list array start at index 0...
> -	 */
> -	iwe.u.freq.m = frequency_list[iwe.u.freq.m - 1] * 100000;
> +	iwe.u.freq.m = ieee80211_dsss_chan_to_freq(iwe.u.freq.m) * 100000;
>  	iwe.u.freq.e = 1;
>  	current_ev = iwe_stream_add_event(info, current_ev, end_buf,
>  					  &iwe, IW_EV_FREQ_LEN);
> diff --git a/drivers/net/wireless/atmel.c b/drivers/net/wireless/atmel.c
> index f551ec0..28dedb8 100644
> --- a/drivers/net/wireless/atmel.c
> +++ b/drivers/net/wireless/atmel.c
> @@ -2207,9 +2207,6 @@ static int atmel_get_frag(struct net_device *dev,
>  	return 0;
>  }
>  
> -static const long frequency_list[] = { 2412, 2417, 2422, 2427, 2432, 2437, 2442,
> -				2447, 2452, 2457, 2462, 2467, 2472, 2484 };
> -
>  static int atmel_set_freq(struct net_device *dev,
>  			  struct iw_request_info *info,
>  			  struct iw_freq *fwrq,
> @@ -2219,16 +2216,12 @@ static int atmel_set_freq(struct net_device *dev,
>  	int rc = -EINPROGRESS;		/* Call commit handler */
>  
>  	/* If setting by frequency, convert to a channel */
> -	if ((fwrq->e == 1) &&
> -	    (fwrq->m >= (int) 241200000) &&
> -	    (fwrq->m <= (int) 248700000)) {
> +	if (fwrq->e == 1) {
>  		int f = fwrq->m / 100000;
> -		int c = 0;
> -		while ((c < 14) && (f != frequency_list[c]))
> -			c++;
> +
>  		/* Hack to fall through... */
>  		fwrq->e = 0;
> -		fwrq->m = c + 1;
> +		fwrq->m = ieee80211_freq_to_dsss_chan(f);
>  	}
>  	/* Setting by channel number */
>  	if ((fwrq->m > 1000) || (fwrq->e > 0))
> @@ -2387,8 +2380,11 @@ static int atmel_get_range(struct net_device *dev,
>  	if (range->num_channels != 0) {
>  		for (k = 0, i = channel_table[j].min; i <= channel_table[j].max; i++) {
>  			range->freq[k].i = i; /* List index */
> -			range->freq[k].m = frequency_list[i - 1] * 100000;
> -			range->freq[k++].e = 1;	/* Values in table in MHz -> * 10^5 * 10 */
> +
> +			/* Values in MHz -> * 10^5 * 10 */
> +			range->freq[k].m = (ieee80211_dsss_chan_to_freq(i) *
> +					    100000);
> +			range->freq[k++].e = 1;
>  		}
>  		range->num_frequency = k;
>  	}
> diff --git a/drivers/net/wireless/orinoco/orinoco.c b/drivers/net/wireless/orinoco/orinoco.c
> index b33e13f..bef7360 100644
> --- a/drivers/net/wireless/orinoco/orinoco.c
> +++ b/drivers/net/wireless/orinoco/orinoco.c
> @@ -178,12 +178,7 @@ static const struct ethtool_ops orinoco_ethtool_ops;
>  /* Data tables                                                      */
>  /********************************************************************/
>  
> -/* The frequency of each channel in MHz */
> -static const long channel_frequency[] = {
> -	2412, 2417, 2422, 2427, 2432, 2437, 2442,
> -	2447, 2452, 2457, 2462, 2467, 2472, 2484
> -};
> -#define NUM_CHANNELS ARRAY_SIZE(channel_frequency)
> +#define NUM_CHANNELS 14
>  
>  /* This tables gives the actual meanings of the bitrate IDs returned
>   * by the firmware. */
> @@ -3724,13 +3719,13 @@ static int orinoco_hw_get_essid(struct orinoco_private *priv, int *active,
>  	return err;       
>  }
>  
> -static long orinoco_hw_get_freq(struct orinoco_private *priv)
> +static int orinoco_hw_get_freq(struct orinoco_private *priv)
>  {
>  	
>  	hermes_t *hw = &priv->hw;
>  	int err = 0;
>  	u16 channel;
> -	long freq = 0;
> +	int freq = 0;
>  	unsigned long flags;
>  
>  	if (orinoco_lock(priv, &flags) != 0)
> @@ -3753,7 +3748,7 @@ static long orinoco_hw_get_freq(struct orinoco_private *priv)
>  		goto out;
>  
>  	}
> -	freq = channel_frequency[channel-1] * 100000;
> +	freq = ieee80211_dsss_chan_to_freq(channel);
>  
>   out:
>  	orinoco_unlock(priv, &flags);
> @@ -3980,7 +3975,8 @@ static int orinoco_ioctl_getiwrange(struct net_device *dev,
>  	for (i = 0; i < NUM_CHANNELS; i++) {
>  		if (priv->channel_mask & (1 << i)) {
>  			range->freq[k].i = i + 1;
> -			range->freq[k].m = channel_frequency[i] * 100000;
> +			range->freq[k].m = (ieee80211_dsss_chan_to_freq(i + 1) *
> +					    100000);
>  			range->freq[k].e = 1;
>  			k++;
>  		}
> @@ -4328,16 +4324,15 @@ static int orinoco_ioctl_setfreq(struct net_device *dev,
>  		/* Setting by channel number */
>  		chan = frq->m;
>  	} else {
> -		/* Setting by frequency - search the table */
> -		int mult = 1;
> +		/* Setting by frequency */
> +		int denom = 1;
>  		int i;
>  
> +		/* Calculate denominator to rescale to MHz */
>  		for (i = 0; i < (6 - frq->e); i++)
> -			mult *= 10;
> +			denom *= 10;
>  
> -		for (i = 0; i < NUM_CHANNELS; i++)
> -			if (frq->m == (channel_frequency[i] * mult))
> -				chan = i+1;
> +		chan = ieee80211_freq_to_dsss_chan(frq->m / denom);
>  	}
>  
>  	if ( (chan < 1) || (chan > NUM_CHANNELS) ||
> @@ -4374,7 +4369,7 @@ static int orinoco_ioctl_getfreq(struct net_device *dev,
>  		return tmp;
>  	}
>  
> -	frq->m = tmp;
> +	frq->m = tmp * 100000;
>  	frq->e = 1;
>  
>  	return 0;
> @@ -5595,7 +5590,7 @@ static inline char *orinoco_translate_scan(struct net_device *dev,
>  		current_ev = iwe_stream_add_event(info, current_ev, end_buf,
>  						  &iwe, IW_EV_FREQ_LEN);
>  
> -		iwe.u.freq.m = channel_frequency[channel-1] * 100000;
> +		iwe.u.freq.m = ieee80211_dsss_chan_to_freq(channel) * 100000;
>  		iwe.u.freq.e = 1;
>  		current_ev = iwe_stream_add_event(info, current_ev, end_buf,
>  						  &iwe, IW_EV_FREQ_LEN);
> @@ -5746,7 +5741,7 @@ static inline char *orinoco_translate_ext_scan(struct net_device *dev,
>  		current_ev = iwe_stream_add_event(info, current_ev, end_buf,
>  						  &iwe, IW_EV_FREQ_LEN);
>  
> -		iwe.u.freq.m = channel_frequency[channel-1] * 100000;
> +		iwe.u.freq.m = ieee80211_dsss_chan_to_freq(channel) * 100000;
>  		iwe.u.freq.e = 1;
>  		current_ev = iwe_stream_add_event(info, current_ev, end_buf,
>  						  &iwe, IW_EV_FREQ_LEN);
> diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
> index ed5785a..78a3ba8 100644
> --- a/drivers/net/wireless/rndis_wlan.c
> +++ b/drivers/net/wireless/rndis_wlan.c
> @@ -369,9 +369,6 @@ struct rndis_wext_private {
>  };
>  
>  
> -static const int freq_chan[] = { 2412, 2417, 2422, 2427, 2432, 2437, 2442,
> -				2447, 2452, 2457, 2462, 2467, 2472, 2484 };
> -
>  static const int rates_80211g[8] = { 6, 9, 12, 18, 24, 36, 48, 54 };
>  
>  static const int bcm4320_power_output[4] = { 25, 50, 75, 100 };
> @@ -640,8 +637,8 @@ static void dsconfig_to_freq(unsigned int dsconfig, struct iw_freq *freq)
>  static int freq_to_dsconfig(struct iw_freq *freq, unsigned int *dsconfig)
>  {
>  	if (freq->m < 1000 && freq->e == 0) {
> -		if (freq->m >= 1 && freq->m <= ARRAY_SIZE(freq_chan))
> -			*dsconfig = freq_chan[freq->m - 1] * 1000;
> +		if (freq->m >= 1 && freq->m <= 14)
> +			*dsconfig = ieee80211_dsss_chan_to_freq(freq->m) * 1000;
>  		else
>  			return -1;
>  	} else {
> @@ -1178,11 +1175,11 @@ static int rndis_iw_get_range(struct net_device *dev,
>  		range->throughput = 11 * 1000 * 1000 / 2;
>  	}
>  
> -	range->num_channels = ARRAY_SIZE(freq_chan);
> +	range->num_channels = 14;
>  
> -	for (i = 0; i < ARRAY_SIZE(freq_chan) && i < IW_MAX_FREQUENCIES; i++) {
> +	for (i = 0; (i < 14) && (i < IW_MAX_FREQUENCIES); i++) {
>  		range->freq[i].i = i + 1;
> -		range->freq[i].m = freq_chan[i] * 100000;
> +		range->freq[i].m = ieee80211_dsss_chan_to_freq(i + 1) * 100000;
>  		range->freq[i].e = 1;
>  	}
>  	range->num_frequency = i;
> diff --git a/drivers/net/wireless/wl3501_cs.c b/drivers/net/wireless/wl3501_cs.c
> index 68789c6..5e41756 100644
> --- a/drivers/net/wireless/wl3501_cs.c
> +++ b/drivers/net/wireless/wl3501_cs.c
> @@ -44,6 +44,7 @@
>  #include <linux/slab.h>
>  #include <linux/string.h>
>  #include <linux/wireless.h>
> +#include <linux/ieee80211.h>
>  
>  #include <net/iw_handler.h>
>  
> @@ -111,12 +112,6 @@ static void wl3501_release(struct pcmcia_device *link);
>   */
>  static dev_info_t wl3501_dev_info = "wl3501_cs";
>  
> -static int wl3501_chan2freq[] = {
> -	[0]  = 2412, [1]  = 2417, [2]  = 2422, [3]  = 2427, [4] = 2432,
> -	[5]  = 2437, [6]  = 2442, [7]  = 2447, [8]  = 2452, [9] = 2457,
> -	[10] = 2462, [11] = 2467, [12] = 2472, [13] = 2477,
> -};
> -
>  static const struct {
>  	int reg_domain;
>  	int min, max, deflt;
> @@ -1512,7 +1507,7 @@ static int wl3501_get_freq(struct net_device *dev, struct iw_request_info *info,
>  {
>  	struct wl3501_card *this = netdev_priv(dev);
>  
> -	wrqu->freq.m = wl3501_chan2freq[this->chan - 1] * 100000;
> +	wrqu->freq.m = ieee80211_dsss_chan_to_freq(this->chan) * 100000;
>  	wrqu->freq.e = 1;
>  	return 0;
>  }
> diff --git a/drivers/net/wireless/zd1201.c b/drivers/net/wireless/zd1201.c
> index 45a5747..59e00eb 100644
> --- a/drivers/net/wireless/zd1201.c
> +++ b/drivers/net/wireless/zd1201.c
> @@ -921,10 +921,9 @@ static int zd1201_set_freq(struct net_device *dev,
>  	if (freq->e == 0)
>  		channel = freq->m;
>  	else {
> -		if (freq->m >= 2482)
> -			channel = 14;
> -		if (freq->m >= 2407)
> -			channel = (freq->m-2407)/5;
> +		channel = ieee80211_freq_to_dsss_chan(freq->m);
> +		if (channel < 0)
> +			channel = 0;
>  	}
>  
>  	err = zd1201_setconfig16(zd, ZD1201_RID_CNFOWNCHANNEL, channel);
> diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
> index c4e6ca1..cade255 100644
> --- a/include/linux/ieee80211.h
> +++ b/include/linux/ieee80211.h
> @@ -1185,4 +1185,120 @@ static inline u8 *ieee80211_get_DA(struct ieee80211_hdr *hdr)
>  		return hdr->addr1;
>  }
>  
> +/**
> + * ieee80211_fhss_chan_to_freq - get channel frequency
> + * @channel: the FHSS channel
> + *
> + * Convert IEEE802.11 FHSS channel to frequency (MHz)
> + * Ref IEEE 802.11-2007 section 14.6
> + */
> +static inline int ieee80211_fhss_chan_to_freq(int channel)
> +{
> +	if ((channel > 1) && (channel < 96))
> +		return channel + 2400;
> +	else
> +		return -1;
> +}
> +
> +/**
> + * ieee80211_freq_to_fhss_chan - get channel
> + * @freq: the channels frequency
> + *
> + * Convert frequency (MHz) to IEEE802.11 FHSS channel
> + * Ref IEEE 802.11-2007 section 14.6
> + */
> +static inline int ieee80211_freq_to_fhss_chan(int freq)
> +{
> +	if ((freq > 2401) && (freq < 2496))
> +		return freq - 2400;
> +	else
> +		return -1;
> +}
> +
> +/**
> + * ieee80211_dsss_chan_to_freq - get channel center frequency
> + * @channel: the DSSS channel
> + *
> + * Convert IEEE802.11 DSSS channel to the center frequency (MHz).
> + * Ref IEEE 802.11-2007 section 15.6
> + */
> +static inline int ieee80211_dsss_chan_to_freq(int channel)
> +{
> +	if ((channel > 0) && (channel < 14))
> +		return 2407 + (channel * 5);
> +	else if (channel == 14)
> +		return 2484;
> +	else
> +		return -1;
> +}
> +
> +/**
> + * ieee80211_freq_to_dsss_chan - get channel
> + * @freq: the frequency
> + *
> + * Convert frequency (MHz) to IEEE802.11 DSSS channel
> + * Ref IEEE 802.11-2007 section 15.6
> + *
> + * This routine selects the channel with the closest center frequency.
> + */
> +static inline int ieee80211_freq_to_dsss_chan(int freq)
> +{
> +	if ((freq >= 2410) && (freq < 2475))
> +		return (freq - 2405) / 5;
> +	else if ((freq >= 2482) && (freq < 2487))
> +		return 14;
> +	else
> +		return -1;
> +}
> +
> +/* Convert IEEE802.11 HR DSSS channel to frequency (MHz) and back
> + * Ref IEEE 802.11-2007 section 18.4.6.2
> + *
> + * The channels and frequencies are the same as those defined for DSSS
> + */
> +#define ieee80211_hr_chan_to_freq(chan) ieee80211_dsss_chan_to_freq(chan)
> +#define ieee80211_freq_to_hr_chan(freq) ieee80211_freq_to_dsss_chan(freq)
> +
> +/* Convert IEEE802.11 ERP channel to frequency (MHz) and back
> + * Ref IEEE 802.11-2007 section 19.4.2
> + */
> +#define ieee80211_erp_chan_to_freq(chan) ieee80211_hr_chan_to_freq(chan)
> +#define ieee80211_freq_to_erp_chan(freq) ieee80211_freq_to_hr_chan(freq)
> +
> +/**
> + * ieee80211_ofdm_chan_to_freq - get channel center frequency
> + * @s_freq: starting frequency == (dotChannelStartingFactor/2) MHz
> + * @channel: the OFDM channel
> + *
> + * Convert IEEE802.11 OFDM channel to center frequency (MHz)
> + * Ref IEEE 802.11-2007 section 17.3.8.3.2
> + */
> +static inline int ieee80211_ofdm_chan_to_freq(int s_freq, int channel)
> +{
> +	if ((channel > 0) && (channel <= 200) &&
> +	    (s_freq >= 4000))
> +		return s_freq + (channel * 5);
> +	else
> +		return -1;
> +}
>   
Any desire to make 184-196 work? These are the 4.9 GHz channels.
> +
> +/**
> + * ieee80211_freq_to_ofdm_channel - get channel
> + * @s_freq: starting frequency == (dotChannelStartingFactor/2) MHz
> + * @freq: the frequency
> + *
> + * Convert frequency (MHz) to IEEE802.11 OFDM channel
> + * Ref IEEE 802.11-2007 section 17.3.8.3.2
> + *
> + * This routine selects the channel with the closest center frequency.
> + */
> +static inline int ieee80211_freq_to_ofdm_chan(int s_freq, int freq)
> +{
> +	if ((freq > (s_freq + 2)) && (freq <= (s_freq + 1202)) &&
> +	    (s_freq >= 4000))
> +		return (freq + 2 - s_freq) / 5;
> +	else
> +		return -1;
> +}
> +
>   
Same as above.
>  #endif /* LINUX_IEEE80211_H */
>   

I checked this all out pretty specifically, seems to work well. As if 
anyone cares but:

ACKED-By: Rick Farina
