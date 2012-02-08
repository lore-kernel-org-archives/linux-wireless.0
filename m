Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:3073 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752501Ab2BHWSV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 17:18:21 -0500
Message-ID: <4F32F4AB.7040202@gmail.com> (sfid-20120208_231825_184632_2741726D)
Date: Wed, 08 Feb 2012 23:18:19 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: John Li <john.li.mediatek@gmail.com>
CC: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	John Li <chen-yang.li@mediatek.com>
Subject: Re: [PATCH] rt2x00:Add VCO recalibration
References: <1328706551-11263-1-git-send-email-john.li.mediatek@gmail.com>
In-Reply-To: <1328706551-11263-1-git-send-email-john.li.mediatek@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On 02/08/12 14:09, John Li wrote:
> From: John Li <chen-yang.li@mediatek.com>
> 
> Signed-off-by: John Li <chen-yang.li@mediatek.com>
> ---
>  drivers/net/wireless/rt2x00/rt2800.h       |    8 +++
>  drivers/net/wireless/rt2x00/rt2800lib.c    |   65 ++++++++++++++++++++++++++++
>  drivers/net/wireless/rt2x00/rt2800lib.h    |    1 +
>  drivers/net/wireless/rt2x00/rt2800pci.c    |    1 +
>  drivers/net/wireless/rt2x00/rt2800usb.c    |    1 +
>  drivers/net/wireless/rt2x00/rt2x00.h       |   11 +++++
>  drivers/net/wireless/rt2x00/rt2x00config.c |    3 +
>  drivers/net/wireless/rt2x00/rt2x00dev.c    |    2 +
>  drivers/net/wireless/rt2x00/rt2x00lib.h    |   13 ++++++
>  drivers/net/wireless/rt2x00/rt2x00link.c   |   38 ++++++++++++++++
>  10 files changed, 143 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
> index 2571a2f..51069b8 100644
> --- a/drivers/net/wireless/rt2x00/rt2800.h
> +++ b/drivers/net/wireless/rt2x00/rt2800.h
> @@ -985,6 +985,14 @@
>  #define TX_PIN_CFG_RFTR_POL		FIELD32(0x00020000)
>  #define TX_PIN_CFG_TRSW_EN		FIELD32(0x00040000)
>  #define TX_PIN_CFG_TRSW_POL		FIELD32(0x00080000)
> +#define TX_PIN_CFG_PA_PE_A2_EN		FIELD32(0x01000000)
> +#define TX_PIN_CFG_PA_PE_G2_EN		FIELD32(0x02000000)
> +#define TX_PIN_CFG_PA_PE_A2_POL		FIELD32(0x04000000)
> +#define TX_PIN_CFG_PA_PE_G2_POL		FIELD32(0x08000000)
> +#define TX_PIN_CFG_LNA_PE_A2_EN		FIELD32(0x10000000)
> +#define TX_PIN_CFG_LNA_PE_G2_EN		FIELD32(0x20000000)
> +#define TX_PIN_CFG_LNA_PE_A2_POL	FIELD32(0x40000000)
> +#define TX_PIN_CFG_LNA_PE_G2_POL	FIELD32(0x80000000)
>  
>  /*
>   * TX_BAND_CFG: 0x1 use upper 20MHz, 0x0 use lower 20MHz
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 22a1a8f..2fbd762 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -2414,6 +2414,71 @@ void rt2800_gain_calibration(struct rt2x00_dev *rt2x00dev)
>  }
>  EXPORT_SYMBOL_GPL(rt2800_gain_calibration);
>  
> +void rt2800_vco_calibration(struct rt2x00_dev *rt2x00dev)
> +{
> +	u32	tx_pin;
> +	u8	rfcsr;
> +	
> +	/*
> +	 * A voltage-controlled oscillator(VCO) is an electronic oscillator designed to be controlled in oscillation frequency by a voltage input.
> +	 * Maybe the temperature will affect the frequency of oscillation to be shifted.
> +	 * The VCO calibration will be called periodically to adjust the frequency to be precision.
> +	*/
> +
> +	switch (rt2x00dev->chip.rf) {
> +	case RF2020:
> +	case RF3020:
> +	case RF3021:
> +	case RF3022:
> +	case RF3320:
> +	case RF3052:
> +		rt2800_rfcsr_read(rt2x00dev, 7, &rfcsr);
> +		rt2x00_set_field8(&rfcsr, RFCSR7_RF_TUNING, 1);
> +		rt2800_rfcsr_write(rt2x00dev, 7, rfcsr);
> +		break;
> +	case RF5370:
> +	case RF5372:
> +	case RF5390:
> +		rt2800_rfcsr_read(rt2x00dev, 3, &rfcsr);
> +		rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 1);
> +		rt2800_rfcsr_write(rt2x00dev, 3, rfcsr);
> +		break;
> +	default:
> +		return;
> +	}

Hmmm, with this switch statement you basically check on which chipsets
the VCO calibration needs to occur (which is basically anything but
RT28xx). However, this means that for RT28xx devices the VCO calibration
work struct will still be continuously scheduled, just to do nothing.

Maybe we should replace this check with a flag in the cap_flags field of
struct rt2x00_dev, so that a driver can indicate to the generic code
whether the VCO calibration work actually needs to be scheduled. This
capability would then only be set for the appropriate devices.

> +
> +	mdelay(1);
> +		
> +	rt2800_register_read(rt2x00dev, TX_PIN_CFG, &tx_pin);
> +	if (rt2x00dev->rf_channel <= 14)
> +	{
> +		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G0_EN, 1);
> +		if (rt2x00dev->default_ant.tx_chain_num >= 2)
> +		{
> +			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G1_EN, 1);
> +			if (rt2x00dev->default_ant.tx_chain_num == 3)
> +			{
> +				rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G2_EN, 1);
> +			}
> +		}


I think the above set of if statements on tx_chain_num can be simplified
and made better readable code by using a switch statement with fall
through on the cases. Something like this:

	switch (rt2x00dev->default_ant.tx_chain_num) {
	case 3:
		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A2_EN, 1);
		/* fall through */
	case 2:
		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A1_EN, 1);
		/* fall through */
	case 1:
	default:
		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A0_EN, 1);
		break;
	}

> +	}
> +	else
> +	{
> + 		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A0_EN, 1);
> +		if (rt2x00dev->default_ant.tx_chain_num >= 2)
> +		{
> +			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A1_EN, 1);
> +			if (rt2x00dev->default_ant.tx_chain_num == 3)
> +			{
> +				rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A2_EN, 1);
> +			}
> +		}

Same here.

> +	}
> +	rt2800_register_write(rt2x00dev, TX_PIN_CFG, tx_pin);
> +
> +}
> +EXPORT_SYMBOL_GPL(rt2800_vco_calibration);
> +
>  static void rt2800_config_retry_limit(struct rt2x00_dev *rt2x00dev,
>  				      struct rt2x00lib_conf *libconf)
>  {
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
> index 8c3c281..419e36c 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.h
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.h
> @@ -184,6 +184,7 @@ void rt2800_reset_tuner(struct rt2x00_dev *rt2x00dev, struct link_qual *qual);
>  void rt2800_link_tuner(struct rt2x00_dev *rt2x00dev, struct link_qual *qual,
>  		       const u32 count);
>  void rt2800_gain_calibration(struct rt2x00_dev *rt2x00dev);
> +void rt2800_vco_calibration(struct rt2x00_dev *rt2x00dev);
>  
>  int rt2800_enable_radio(struct rt2x00_dev *rt2x00dev);
>  void rt2800_disable_radio(struct rt2x00_dev *rt2x00dev);
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> index 837b460..25fd45c 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -1050,6 +1050,7 @@ static const struct rt2x00lib_ops rt2800pci_rt2x00_ops = {
>  	.reset_tuner		= rt2800_reset_tuner,
>  	.link_tuner		= rt2800_link_tuner,
>  	.gain_calibration	= rt2800_gain_calibration,
> +	.vco_calibration	= rt2800_vco_calibration,
>  	.start_queue		= rt2800pci_start_queue,
>  	.kick_queue		= rt2800pci_kick_queue,
>  	.stop_queue		= rt2800pci_stop_queue,
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index 7f21005..2fab90e 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -783,6 +783,7 @@ static const struct rt2x00lib_ops rt2800usb_rt2x00_ops = {
>  	.reset_tuner		= rt2800_reset_tuner,
>  	.link_tuner		= rt2800_link_tuner,
>  	.gain_calibration	= rt2800_gain_calibration,
> +	.vco_calibration	= rt2800_vco_calibration,
>  	.watchdog		= rt2800usb_watchdog,
>  	.start_queue		= rt2800usb_start_queue,
>  	.kick_queue		= rt2x00usb_kick_queue,
> diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
> index b03b22c..b865e16 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00.h
> @@ -355,6 +355,11 @@ struct link {
>  	 * Work structure for scheduling periodic AGC adjustments.
>  	 */
>  	struct delayed_work agc_work;
> +
> +	/*
> +	 * Work structure for scheduling periodic VCO calibration.
> +	 */
> +	struct delayed_work vco_work;
>  };
>  
>  enum rt2x00_delayed_flags {
> @@ -579,6 +584,7 @@ struct rt2x00lib_ops {
>  	void (*link_tuner) (struct rt2x00_dev *rt2x00dev,
>  			    struct link_qual *qual, const u32 count);
>  	void (*gain_calibration) (struct rt2x00_dev *rt2x00dev);
> +	void (*vco_calibration) (struct rt2x00_dev *rt2x00dev);
>  
>  	/*
>  	 * Data queue handlers.
> @@ -979,6 +985,11 @@ struct rt2x00_dev {
>  	struct tasklet_struct autowake_tasklet;
>  
>  	/*
> +	 * Used for VCO periodic calibration.
> +	 */
> +	int rf_channel;
> +
> +	/*
>  	 * Protect the interrupt mask register.
>  	 */
>  	spinlock_t irqmask_lock;
> diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
> index b704e5b..006b939 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00config.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00config.c
> @@ -232,6 +232,9 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
>  		memcpy(&libconf.channel,
>  		       &rt2x00dev->spec.channels_info[hw_value],
>  		       sizeof(libconf.channel));
> +		
> + 		/* Used for VCO periodic calibration */
> +		rt2x00dev->rf_channel = libconf.rf.channel;
>  	}
>  
>  	if (test_bit(REQUIRE_PS_AUTOWAKE, &rt2x00dev->cap_flags) &&
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index c3e1aa7..f78266e 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -88,6 +88,7 @@ int rt2x00lib_enable_radio(struct rt2x00_dev *rt2x00dev)
>  	rt2x00queue_start_queues(rt2x00dev);
>  	rt2x00link_start_tuner(rt2x00dev);
>  	rt2x00link_start_agc(rt2x00dev);
> +	rt2x00link_start_vcocal(rt2x00dev);
>  
>  	/*
>  	 * Start watchdog monitoring.
> @@ -111,6 +112,7 @@ void rt2x00lib_disable_radio(struct rt2x00_dev *rt2x00dev)
>  	 * Stop all queues
>  	 */
>  	rt2x00link_stop_agc(rt2x00dev);
> +	rt2x00link_stop_vcocal(rt2x00dev);
>  	rt2x00link_stop_tuner(rt2x00dev);
>  	rt2x00queue_stop_queues(rt2x00dev);
>  	rt2x00queue_flush_queues(rt2x00dev, true);
> diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
> index 4cdf247..78bd43b 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00lib.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
> @@ -33,6 +33,7 @@
>  #define WATCHDOG_INTERVAL	round_jiffies_relative(HZ)
>  #define LINK_TUNE_INTERVAL	round_jiffies_relative(HZ)
>  #define AGC_INTERVAL		round_jiffies_relative(4 * HZ)
> +#define VCO_INTERVAL		round_jiffies_relative(10 * HZ) /* 10 sec */
>  
>  /*
>   * rt2x00_rate: Per rate device information
> @@ -278,12 +279,24 @@ void rt2x00link_stop_watchdog(struct rt2x00_dev *rt2x00dev);
>  void rt2x00link_start_agc(struct rt2x00_dev *rt2x00dev);
>  
>  /**
> + * rt2x00link_start_vcocal - Start periodic VCO calibration
> + * @rt2x00dev: Pointer to &struct rt2x00_dev.
> + */
> +void rt2x00link_start_vcocal(struct rt2x00_dev *rt2x00dev);
> +
> +/**
>   * rt2x00link_stop_agc - Stop periodic gain calibration
>   * @rt2x00dev: Pointer to &struct rt2x00_dev.
>   */
>  void rt2x00link_stop_agc(struct rt2x00_dev *rt2x00dev);
>  
>  /**
> + * rt2x00link_stop_vcocal - Stop periodic VCO calibration
> + * @rt2x00dev: Pointer to &struct rt2x00_dev.
> + */
> +void rt2x00link_stop_vcocal(struct rt2x00_dev *rt2x00dev);
> +
> +/**
>   * rt2x00link_register - Initialize link tuning & watchdog functionality
>   * @rt2x00dev: Pointer to &struct rt2x00_dev.
>   *
> diff --git a/drivers/net/wireless/rt2x00/rt2x00link.c b/drivers/net/wireless/rt2x00/rt2x00link.c
> index ea10b00..5da1dab 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00link.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00link.c
> @@ -447,11 +447,27 @@ void rt2x00link_start_agc(struct rt2x00_dev *rt2x00dev)
>  					     AGC_INTERVAL);
>  }
>  
> +void rt2x00link_start_vcocal(struct rt2x00_dev *rt2x00dev)
> +{
> +	struct link *link = &rt2x00dev->link;
> +
> +	if (test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags) &&
> +	    rt2x00dev->ops->lib->vco_calibration)
> +		ieee80211_queue_delayed_work(rt2x00dev->hw,
> +					     &link->vco_work,
> +					     VCO_INTERVAL);
> +}
> +
>  void rt2x00link_stop_agc(struct rt2x00_dev *rt2x00dev)
>  {
>  	cancel_delayed_work_sync(&rt2x00dev->link.agc_work);
>  }
>  
> +void rt2x00link_stop_vcocal(struct rt2x00_dev *rt2x00dev)
> +{
> +	cancel_delayed_work_sync(&rt2x00dev->link.vco_work);
> +}
> +
>  static void rt2x00link_agc(struct work_struct *work)
>  {
>  	struct rt2x00_dev *rt2x00dev =
> @@ -473,9 +489,31 @@ static void rt2x00link_agc(struct work_struct *work)
>  					     AGC_INTERVAL);
>  }
>  
> +static void rt2x00link_vcocal(struct work_struct *work)
> +{
> +	struct rt2x00_dev *rt2x00dev =
> +	    container_of(work, struct rt2x00_dev, link.vco_work.work);
> +	struct link *link = &rt2x00dev->link;
> +
> +	/*
> +	 * When the radio is shutting down we should
> +	 * immediately cease the VCO calibration.
> +	 */
> +	if (!test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
> +		return;
> +
> +	rt2x00dev->ops->lib->vco_calibration(rt2x00dev);
> +
> +	if (test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
> +		ieee80211_queue_delayed_work(rt2x00dev->hw,
> +					     &link->vco_work,
> +					     VCO_INTERVAL);
> +}
> +
>  void rt2x00link_register(struct rt2x00_dev *rt2x00dev)
>  {
>  	INIT_DELAYED_WORK(&rt2x00dev->link.agc_work, rt2x00link_agc);
> +	INIT_DELAYED_WORK(&rt2x00dev->link.vco_work, rt2x00link_vcocal);
>  	INIT_DELAYED_WORK(&rt2x00dev->link.watchdog_work, rt2x00link_watchdog);
>  	INIT_DELAYED_WORK(&rt2x00dev->link.work, rt2x00link_tuner);
>  }


-- 
---
Gertjan
