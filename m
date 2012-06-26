Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30909 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757180Ab2FZFYX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 01:24:23 -0400
Message-ID: <4FE9477E.5000902@qca.qualcomm.com> (sfid-20120626_072440_884254_F5CE58F6)
Date: Tue, 26 Jun 2012 10:54:14 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	<vadivel@qca.qualcomm.com>, <rhu@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Subject: Re: [PATCH v3 09/10] ath9k: Add WoW related mac80211 callbacks
References: <1340633579-7514-1-git-send-email-mohammed@qca.qualcomm.com>	<1340633579-7514-10-git-send-email-mohammed@qca.qualcomm.com> <20456.47690.633636.869442@gargle.gargle.HOWL>
In-Reply-To: <20456.47690.633636.869442@gargle.gargle.HOWL>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sujith,

On Tuesday 26 June 2012 12:51 AM, Sujith Manoharan wrote:
> Mohammed Shafi Shajakhan wrote:
>> +#ifdef CONFIG_PM_SLEEP
>> +
>> +void ath_wow_cleanup(struct ath_softc *sc)
>> +{
>> +	struct ath9k_wow_info *wow_info =&sc->wow_info;
>> +	struct ath9k_wow_pattern *wow_pattern  = NULL, *tmp;
>> +
>> +	if (!(sc->wow_enabled&  AH_WOW_USER_PATTERN_EN))
>> +		return;
>> +
>> +	list_for_each_entry_safe(wow_pattern, tmp,
>> +				&wow_info->wow_patterns, list) {
>> +
>> +		list_del(&wow_pattern->list);
>> +		kfree(wow_pattern);
>> +	}
>> +
>> +}
>
> I am slightly unclear about this...
>
>> +	u8 dis_deauth_pattern[MAX_PATTERN_SIZE];
>> +	u8 dis_deauth_mask[MAX_PATTERN_SIZE];
>> +
>> +	memset(dis_deauth_pattern, 0, MAX_PATTERN_SIZE);
>> +	memset(dis_deauth_mask, 0, MAX_PATTERN_SIZE);
>
> MAX_PATTERN_MASK_SIZE ?

thanks, filling up 0xff requires MAX_PATTERN_MASK_SIZE.

>
>> +		memset(wow_pattern->pattern_bytes, 0, MAX_PATTERN_SIZE);
>> +		memset(wow_pattern->mask_bytes, 0, MAX_PATTERN_SIZE);
>
> The memset() calls are not needed, but maybe I am missing something -
> why exactly are we maintaining a list of patterns in the driver ?
> Can't the patterns be retrieved as part of the suspend() callback
> and just programmed in the HW ?

the user pattern needs bit more stuff, we need to convert it to our chip 
specific format(ie proper 802.11 format), previously there was
a logic of duplicate patterns before programming to HW, where a list in 
the driver was necessary, i removed it to simplify few things.
will check it out if its really needed for any enhancements in future.

>
>> +
>> +	if (!device_can_wakeup(sc->dev)) {
>> +		ath_dbg(common, WOW, "device_can_wakeup failed, WoW is not enabled\n");
>> +		ret = 1;
>> +		goto fail_wow;
>> +	}
>
> Can this happen ?

the wow capabilities are initialized only if
device_can_wakeup passes. would check it out if this is needed.

>
>> +	/*
>> +	 * we can now sync irq and kill any running tasklets, since we already
>> +	 * disabled interrupts and not holding a spin lock
>> +	 */
>> +	synchronize_irq(sc->irq);
>> +	tasklet_kill(&sc->intr_tq);
>> +
>> +	ath9k_hw_wow_enable(ah, wow_triggers_enabled);
>> +
>> +	ath9k_ps_restore(sc);
>> +	ath_dbg(common, ANY, "WoW enabled in ath9k\n");
>> +	sc->wow_sleep_proc_intr = true;
>
> This is racy with the ISR, atomic ops can be used instead, since this
> (along with wow_got_bmiss_intr) are just boolean variables.

thanks, will check this out.

>
>> +static void ath9k_set_wakeup(struct ieee80211_hw *hw, bool enabled)
>> +{
>> +	struct ath_softc *sc = hw->priv;
>> +
>> +	mutex_lock(&sc->mutex);
>> +	device_init_wakeup(sc->dev, 1);
>> +	device_set_wakeup_enable(sc->dev, enabled);
>> +	mutex_unlock(&sc->mutex);
>> +}
>
> device_init_wakeup() should be part of the probe sequence, I think.
>

in v2 i had it in my pci_probe only, but device_init_wakeup seems to 
call device_set_wakeup_enable. we actually set device_set_wakeup_enable 
explicitly to 'true' only when wow triggers are enabled, otherwise
we would set our chip to wakeup capable during pci_probe.

-- 
thanks,
shafi
