Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41537 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533AbaBLPcy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 10:32:54 -0500
Message-ID: <52FB941E.1020300@openwrt.org> (sfid-20140212_163302_551660_4F5625F1)
Date: Wed, 12 Feb 2014 16:32:46 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 2/2] ath9k: implement p2p client powersave support
References: <1392113890-5097-1-git-send-email-nbd@openwrt.org>	<1392113890-5097-2-git-send-email-nbd@openwrt.org> <21243.36697.649170.35540@gargle.gargle.HOWL>
In-Reply-To: <21243.36697.649170.35540@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-02-12 16:12, Sujith Manoharan wrote:
> Felix Fietkau wrote:
>> +	sc->p2p_ps_timer = ath_gen_timer_alloc(sc->sc_ah, ath9k_p2p_ps_timer,
>> +		NULL, sc, AR_FIRST_NDP_TIMER);
>> +
>>  	ath9k_cmn_init_crypto(sc->sc_ah);
>>  	ath9k_init_misc(sc);
>>  	ath_fill_led_pin(sc);
>> @@ -1067,6 +1070,9 @@ static void ath9k_deinit_softc(struct ath_softc *sc)
>>  {
>>  	int i = 0;
>>  
>> +	if (sc->p2p_ps_timer)
>> +		ath_gen_timer_free(sc->sc_ah, sc->p2p_ps_timer);
>> +
> 
> Why do this in the global init/deinit routines ? Wouldn't the
> add/remove interface callbacks be a better place for this (based on
> vif->p2p), since this timer is needed only for p2p interfaces ?
It only allocates a very small struct. Doing this in the interface
add/remove callback means I'd have to handle interface change as well. I
figured keeping it simple is better than micro-optimizing a single small
memory allocation.

>> +	if (sc->ps_flags & PS_BEACON_SYNC)
>> +		return;
> 
> I think sc_pm_lock is required to use sc->ps_flags.
OK, will send v2 later.

- Felix
