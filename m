Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11890 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760Ab2FYTYZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 15:24:25 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20456.47690.633636.869442@gargle.gargle.HOWL> (sfid-20120625_212429_561655_7A547DAE)
Date: Tue, 26 Jun 2012 00:51:46 +0530
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	"Rajkumar Manoharan" <rmanohar@qca.qualcomm.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	<vadivel@qca.qualcomm.com>, <rhu@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Subject: [PATCH v3 09/10] ath9k: Add WoW related mac80211 callbacks
In-Reply-To: <1340633579-7514-10-git-send-email-mohammed@qca.qualcomm.com>
References: <1340633579-7514-1-git-send-email-mohammed@qca.qualcomm.com>
	<1340633579-7514-10-git-send-email-mohammed@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan wrote:
> +#ifdef CONFIG_PM_SLEEP
> +
> +void ath_wow_cleanup(struct ath_softc *sc)
> +{
> +	struct ath9k_wow_info *wow_info = &sc->wow_info;
> +	struct ath9k_wow_pattern *wow_pattern  = NULL, *tmp;
> +
> +	if (!(sc->wow_enabled & AH_WOW_USER_PATTERN_EN))
> +		return;
> +
> +	list_for_each_entry_safe(wow_pattern, tmp,
> +				 &wow_info->wow_patterns, list) {
> +
> +		list_del(&wow_pattern->list);
> +		kfree(wow_pattern);
> +	}
> +
> +}

I am slightly unclear about this...

> +	u8 dis_deauth_pattern[MAX_PATTERN_SIZE];
> +	u8 dis_deauth_mask[MAX_PATTERN_SIZE];
> +
> +	memset(dis_deauth_pattern, 0, MAX_PATTERN_SIZE);
> +	memset(dis_deauth_mask, 0, MAX_PATTERN_SIZE);

MAX_PATTERN_MASK_SIZE ?

> +		memset(wow_pattern->pattern_bytes, 0, MAX_PATTERN_SIZE);
> +		memset(wow_pattern->mask_bytes, 0, MAX_PATTERN_SIZE);

The memset() calls are not needed, but maybe I am missing something -
why exactly are we maintaining a list of patterns in the driver ?
Can't the patterns be retrieved as part of the suspend() callback
and just programmed in the HW ?

> +
> +	if (!device_can_wakeup(sc->dev)) {
> +		ath_dbg(common, WOW, "device_can_wakeup failed, WoW is not enabled\n");
> +		ret = 1;
> +		goto fail_wow;
> +	}

Can this happen ?

> +	/*
> +	 * we can now sync irq and kill any running tasklets, since we already
> +	 * disabled interrupts and not holding a spin lock
> +	 */
> +	synchronize_irq(sc->irq);
> +	tasklet_kill(&sc->intr_tq);
> +
> +	ath9k_hw_wow_enable(ah, wow_triggers_enabled);
> +
> +	ath9k_ps_restore(sc);
> +	ath_dbg(common, ANY, "WoW enabled in ath9k\n");
> +	sc->wow_sleep_proc_intr = true;

This is racy with the ISR, atomic ops can be used instead, since this
(along with wow_got_bmiss_intr) are just boolean variables.

> +static void ath9k_set_wakeup(struct ieee80211_hw *hw, bool enabled)
> +{
> +	struct ath_softc *sc = hw->priv;
> +
> +	mutex_lock(&sc->mutex);
> +	device_init_wakeup(sc->dev, 1);
> +	device_set_wakeup_enable(sc->dev, enabled);
> +	mutex_unlock(&sc->mutex);
> +}

device_init_wakeup() should be part of the probe sequence, I think.

Sujith
