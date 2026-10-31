Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.77.101.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793443941;
	b=a3wnWJ7o/oYsxr1Wu6w3bATVmtKCbhjiIBQmuARsmPRG0Uz8TzECvvg/BdiPqsw/YZNH
	 zVQ1oJjTS6xU4aQ6wkYI71b7rRQ40NuuaPyOsMMf+JaznWeZj5sMDMlRTybLrsPsSeS2t
	 dYo/nZoDgK7wp4yqOsuEBvlJyH6WweTXCuCUjO4UReaPbFEfaXNJk5tXp9a7w5IXDT2Sj
	 Z4fTEQG7pEDNmJqqS/UjnfP1styfg8wAQ0xWES4rQIeSmJLNjdCXkWfWk4O5XPfwqI/1r
	 F+/h1MUp3cdoDX4coirVq6rfrYMd2LEDWAtRdkUL2yepEHMitgMCem+UQ8AT8pWQx2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793443941;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-WP-MailID:X-WP-AV:X-WP-SPAM;
	bh=ZrakYmAgv2kSbBLVFd7ASY6rYHDj9yh5cHPYaCXsiQA=;
	b=H69eVF6ShHav1vdV67nqGkTI+OjyO4w/c6htla0TY4oKA1LnsbqI06fAUO9rEggYUeer
	 kMzr02PCAOhY+lO1dhdtQeumefivzMmAtq7ilEdRE/RH+uzamu08XBmnDyD5p3khD9Zgd
	 30dlkwnKroaa2CkC2v+fXC/BwwaXLK/Ei7tOQbQ+jHdvyQ3BiTNhpgbJbKq0K6cDtDc4m
	 Im3WMNZsjqM4aUmGLUcTww1znrnfhSpkhLqrpPfvFaNTGGL7ZRwUuMtABbrTCRRxWe/8K
	 JyJzPGW2M7iIGTjzC8kqB5uKBoZb40QZcsCHD+ykJrCZ1B/JyJ4U5bS8cvs+njROaFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wp.pl;
	spf=pass smtp.mailfrom=wp.pl;
	dkim=pass header.d=wp.pl header.i=@wp.pl header.a=rsa-sha256 header.s=s20261001 header.b=OowCtk8y;
	arc=none smtp.remote-ip=212.77.101.12
Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11FD9606A31C
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 10:52:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 11FD9606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wp.pl header.i=@wp.pl header.a=rsa-sha256 header.s=s20261001 header.b=OowCtk8y
Received: (wp-smtpd smtp.wp.pl 9948 invoked from network); 31 Oct 2026 11:52:17 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=s20261001;
          t=1793443937; bh=ZrakYmAgv2kSbBLVFd7ASY6rYHDj9yh5cHPYaCXsiQA=;
          h=From:To:Cc:Subject;
          b=OowCtk8yCuAcPvgpE6yw4TLmocyfrxqcAJNFnkD3UIwHmS9IKkjZFo/7Wh31E6MM0
           ioSIA6tEEjIdfy+q98UjwZcaBcJUHGshlkYoAX8OIRrN8J6KRC4z6e59MqjROPs+Yr
           6U/QIG+FQXie4dIxtHU+mmR4N0+ioqpdpnqei4bR4vIibVI+ROz0mdN9HHFcFx0M2D
           8H38c2DVhZ73fHOqJh/Bxms6/+lFlR2YikaWGQ062Mtr3GECIMiYigHS9WkFDmgtUs
           HhKVqUrJ4RLRPvKeDOmrwjtXuchyeCc/rcddM7evHNN7TFlIyGoxxjowk2e9kPi+Vt
           atDej1bQH0KCg==
Received: from localhost (77-236-11-144.static.play.pl [77.236.11.144])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <hjf3108@gmail.com>; 31 Oct 2026 11:52:17 +0100
Date: Sat, 31 Oct 2026 11:52:17 +0100
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Ho Jie Feng <hjf3108@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH wireless-next 2/8] wifi: rt2800: calibrate the crystal of
 RT3593 with the beacons
Message-ID: <20261031105217.GB31143@wp.pl>
References: <20261029134752.1299130-1-hjf3108@gmail.com>
 <20261029134752.1299130-3-hjf3108@gmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029134752.1299130-3-hjf3108@gmail.com>
X-WP-MailID: fdab078786ef4a78d6f5bcd3096608c3
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000003 [YSAB]                               

On Thu, Oct 29, 2026 at 09:47:43PM +0800, Ho Jie Feng wrote:
> On a Netgear WNDA4100 (RT3593), as the adapter warms up, the
> frequency offset drifts enough to affect the link quality.
> In certain cases it can cause the link speed to drop
> to 1Mbit/s or below.
> 
> Add a frequency calibration step function to RT3593 to use
> the frequency offset obtained from the beacon frames of the AP
> for tuning.

Presumably this is based on vendor driver? Could you point
the sources i.e. a link for some Github repo where the
correspond code is?

Regards
Stanislaw

> Test results:
>    before after
> TX 27.7   28.5
> RX 31.6   69.7
> 
> Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
> ---
>  drivers/net/wireless/ralink/rt2x00/rt2800.h   |   1 +
>  .../net/wireless/ralink/rt2x00/rt2800lib.c    | 101 ++++++++++++++++++
>  .../net/wireless/ralink/rt2x00/rt2800lib.h    |   4 +
>  .../net/wireless/ralink/rt2x00/rt2800usb.c    |   1 +
>  drivers/net/wireless/ralink/rt2x00/rt2x00.h   |   6 ++
>  .../net/wireless/ralink/rt2x00/rt2x00lib.h    |   2 +
>  .../net/wireless/ralink/rt2x00/rt2x00link.c   |   9 ++
>  7 files changed, 124 insertions(+)
> 
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800.h b/drivers/net/wireless/ralink/rt2x00/rt2800.h
> index 8930589b4967d..b9f6de3a462e3 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2800.h
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2800.h
> @@ -3163,6 +3163,7 @@ enum rt2800_eeprom_word {
>   */
>  #define RXWI_W3_SNR0			FIELD32(0x000000ff)
>  #define RXWI_W3_SNR1			FIELD32(0x0000ff00)
> +#define RXWI_W3_FOFFSET			FIELD32(0xff000000)
>  
>  /*
>   * Macros for converting txpower from EEPROM to mac80211 value
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> index 2e2e382b62475..e7b6edf485099 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> @@ -897,6 +897,28 @@ static int rt2800_agc_to_rssi(struct rt2x00_dev *rt2x00dev, u32 rxwi_w2)
>  	return (int)max(rssi0, rssi2);
>  }
>  
> +static void rt2800_rx_freq_offset(struct queue_entry *entry,
> +				  struct rxdone_entry_desc *rxdesc)
> +{
> +	struct rt2800_drv_data *drv_data = entry->queue->rt2x00dev->drv_data;
> +	__le32 *rxwi = (__le32 *) entry->skb->data;
> +	struct ieee80211_hdr *hdr =
> +	    (void *)(entry->skb->data + entry->queue->winfo_size);
> +	u32 word;
> +
> +	if (!(rxdesc->dev_flags & RXDONE_MY_BSS) ||
> +	    (rxdesc->flags & RX_FLAG_FAILED_FCS_CRC) ||
> +	    !ieee80211_is_beacon(hdr->frame_control))
> +		return;
> +
> +	word = rt2x00_desc_read(rxwi, 3);
> +
> +	spin_lock_bh(&drv_data->bcn_lock);
> +	drv_data->bcn_freq_offset = rt2x00_get_field32(word, RXWI_W3_FOFFSET);
> +	drv_data->bcn_rate_mode = rxdesc->rate_mode;
> +	spin_unlock_bh(&drv_data->bcn_lock);
> +}
> +
>  void rt2800_process_rxwi(struct queue_entry *entry,
>  			 struct rxdone_entry_desc *rxdesc)
>  {
> @@ -935,6 +957,14 @@ void rt2800_process_rxwi(struct queue_entry *entry,
>  	 * Convert descriptor AGC value to RSSI value.
>  	 */
>  	rxdesc->rssi = rt2800_agc_to_rssi(entry->queue->rt2x00dev, word);
> +
> +	/*
> +	 * The frequency offset of the beacons is used for the frequency
> +	 * calibration.
> +	 */
> +	if (rt2x00_rt(entry->queue->rt2x00dev, RT3593))
> +		rt2800_rx_freq_offset(entry, rxdesc);
> +
>  	/*
>  	 * Remove RXWI descriptor from start of the buffer.
>  	 */
> @@ -2443,6 +2473,7 @@ static inline bool rt2800_clk_is_20mhz(struct rt2x00_dev *rt2x00dev)
>  }
>  
>  #define FREQ_OFFSET_BOUND	0x5f
> +#define FREQ_OFFSET_INVALID	-128
>  
>  static void rt2800_freq_cal_mode1(struct rt2x00_dev *rt2x00dev)
>  {
> @@ -5633,6 +5664,73 @@ void rt2800_vco_calibration(struct rt2x00_dev *rt2x00dev)
>  }
>  EXPORT_SYMBOL_GPL(rt2800_vco_calibration);
>  
> +void rt2800_freq_calibration(struct rt2x00_dev *rt2x00dev)
> +{
> +	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
> +	struct link *link = &rt2x00dev->link;
> +	u8 activate_threshold, deactivate_threshold;
> +	u8 freq_offset, rate_mode;
> +	u16 eeprom;
> +	s8 offset;
> +
> +	if (!rt2x00_rt(rt2x00dev, RT3593))
> +		return;
> +
> +	if (!rt2x00dev->intf_associated) {
> +		eeprom = rt2800_eeprom_read(rt2x00dev, EEPROM_FREQ);
> +		rt2x00dev->freq_offset = rt2x00_get_field16(eeprom,
> +							    EEPROM_FREQ_OFFSET);
> +		link->freq_cal_adjusting = false;
> +		return;
> +	}
> +
> +	spin_lock_bh(&drv_data->bcn_lock);
> +	offset = drv_data->bcn_freq_offset;
> +	rate_mode = drv_data->bcn_rate_mode;
> +	drv_data->bcn_freq_offset = FREQ_OFFSET_INVALID;
> +	spin_unlock_bh(&drv_data->bcn_lock);
> +
> +	/* No beacons received */
> +	if (offset == FREQ_OFFSET_INVALID)
> +		return;
> +
> +	if (rate_mode == RATE_MODE_CCK) {
> +		activate_threshold = 4;
> +		deactivate_threshold = 2;
> +	} else {
> +		activate_threshold = 20;
> +		deactivate_threshold = 10;
> +	}
> +
> +	/* Hysteresis */
> +	if (abs(offset) >= activate_threshold)
> +		link->freq_cal_adjusting = true;
> +	else if (abs(offset) <= deactivate_threshold)
> +		link->freq_cal_adjusting = false;
> +
> +	if (!link->freq_cal_adjusting)
> +		return;
> +
> +	freq_offset = rt2x00_get_field8(rt2x00dev->freq_offset, RFCSR17_CODE);
> +	freq_offset = min_t(u8, freq_offset, FREQ_OFFSET_BOUND);
> +
> +	if (offset > 0) {
> +		if (freq_offset > 0)
> +			freq_offset--;
> +		else
> +			link->freq_cal_adjusting = false;
> +	} else {
> +		if (freq_offset < FREQ_OFFSET_BOUND)
> +			freq_offset++;
> +		else
> +			link->freq_cal_adjusting = false;
> +	}
> +
> +	rt2x00dev->freq_offset = freq_offset;
> +	rt2800_freq_cal_mode1(rt2x00dev);
> +}
> +EXPORT_SYMBOL_GPL(rt2800_freq_calibration);
> +
>  static void rt2800_config_retry_limit(struct rt2x00_dev *rt2x00dev,
>  				      struct rt2x00lib_conf *libconf)
>  {
> @@ -12032,6 +12130,7 @@ static int rt2800_probe_rt(struct rt2x00_dev *rt2x00dev)
>  
>  int rt2800_probe_hw(struct rt2x00_dev *rt2x00dev)
>  {
> +	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
>  	int retval;
>  	u32 reg;
>  
> @@ -12105,6 +12204,8 @@ int rt2800_probe_hw(struct rt2x00_dev *rt2x00dev)
>  	 */
>  	rt2x00dev->rssi_offset = DEFAULT_RSSI_OFFSET;
>  
> +	spin_lock_init(&drv_data->bcn_lock);
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(rt2800_probe_hw);
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.h b/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
> index a3c3a751f57e3..9a04a0fba113f 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
> @@ -45,6 +45,9 @@ struct rt2800_drv_data {
>  	unsigned int ampdu_factor_cnt[4];
>  	DECLARE_BITMAP(sta_ids, STA_IDS_SIZE);
>  	struct ieee80211_sta *wcid_to_sta[STA_IDS_SIZE];
> +	spinlock_t bcn_lock; /* protects bcn_freq_offset, bcn_rate_mode */
> +	s8 bcn_freq_offset;
> +	u8 bcn_rate_mode;
>  };
>  
>  struct rt2800_ops {
> @@ -241,6 +244,7 @@ void rt2800_link_tuner(struct rt2x00_dev *rt2x00dev, struct link_qual *qual,
>  		       const u32 count);
>  void rt2800_gain_calibration(struct rt2x00_dev *rt2x00dev);
>  void rt2800_vco_calibration(struct rt2x00_dev *rt2x00dev);
> +void rt2800_freq_calibration(struct rt2x00_dev *rt2x00dev);
>  
>  int rt2800_enable_radio(struct rt2x00_dev *rt2x00dev);
>  void rt2800_disable_radio(struct rt2x00_dev *rt2x00dev);
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
> index 15de3db124298..387c07e2251b7 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
> @@ -693,6 +693,7 @@ static const struct rt2x00lib_ops rt2800usb_rt2x00_ops = {
>  	.link_tuner		= rt2800_link_tuner,
>  	.gain_calibration	= rt2800_gain_calibration,
>  	.vco_calibration	= rt2800_vco_calibration,
> +	.freq_calibration	= rt2800_freq_calibration,
>  	.watchdog		= rt2800_watchdog,
>  	.start_queue		= rt2800usb_start_queue,
>  	.kick_queue		= rt2x00usb_kick_queue,
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
> index 7d313e86d3f20..a80508db32d9c 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
> @@ -319,6 +319,11 @@ struct link {
>  	 */
>  	struct ewma_rssi avg_rssi;
>  
> +	/*
> +	 * Controls interval of frequency calibration
> +	 */
> +	bool freq_cal_adjusting;
> +
>  	/*
>  	 * Work structure for scheduling periodic link tuning.
>  	 */
> @@ -559,6 +564,7 @@ struct rt2x00lib_ops {
>  			    struct link_qual *qual, const u32 count);
>  	void (*gain_calibration) (struct rt2x00_dev *rt2x00dev);
>  	void (*vco_calibration) (struct rt2x00_dev *rt2x00dev);
> +	void (*freq_calibration) (struct rt2x00_dev *rt2x00dev);
>  
>  	/*
>  	 * Data queue handlers.
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00lib.h b/drivers/net/wireless/ralink/rt2x00/rt2x00lib.h
> index 2f1385baa7ae9..a6f516ebdb2db 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00lib.h
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00lib.h
> @@ -22,6 +22,8 @@
>  #define LINK_TUNE_INTERVAL	round_jiffies_relative(LINK_TUNE_SECONDS * HZ)
>  #define AGC_SECONDS		4
>  #define VCO_SECONDS		10
> +#define FREQ_SECONDS		10
> +#define FREQ_ADJUST_SECONDS	1
>  
>  /*
>   * rt2x00_rate: Per rate device information
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00link.c b/drivers/net/wireless/ralink/rt2x00/rt2x00link.c
> index fb23d409fba87..2dc4edc12834f 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00link.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00link.c
> @@ -343,6 +343,7 @@ static void rt2x00link_tuner(struct work_struct *work)
>  	struct rt2x00_dev *rt2x00dev =
>  	    container_of(work, struct rt2x00_dev, link.work.work);
>  	struct link *link = &rt2x00dev->link;
> +	unsigned int freq_interval;
>  
>  	/*
>  	 * When the radio is shutting down we should
> @@ -362,6 +363,14 @@ static void rt2x00link_tuner(struct work_struct *work)
>  	    (link->count % (AGC_SECONDS / LINK_TUNE_SECONDS)) == 0)
>  		rt2x00dev->ops->lib->gain_calibration(rt2x00dev);
>  
> +	freq_interval = link->freq_cal_adjusting ?
> +			FREQ_ADJUST_SECONDS : FREQ_SECONDS;
> +
> +	/* VCO calibration should be done after frequency calibration */
> +	if (rt2x00dev->ops->lib->freq_calibration &&
> +	    (link->count % (freq_interval / LINK_TUNE_SECONDS)) == 0)
> +		rt2x00dev->ops->lib->freq_calibration(rt2x00dev);
> +
>  	if (rt2x00dev->ops->lib->vco_calibration &&
>  	    rt2x00_has_cap_vco_recalibration(rt2x00dev) &&
>  	    (link->count % (VCO_SECONDS / LINK_TUNE_SECONDS)) == 0)
> -- 
> 2.53.0
> 
