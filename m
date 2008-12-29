Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:44037 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbYL2OYL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2008 09:24:11 -0500
Received: by bwz14 with SMTP id 14so16194414bwz.13
        for <linux-wireless@vger.kernel.org>; Mon, 29 Dec 2008 06:24:09 -0800 (PST)
Message-ID: <8e92b4100812290624i7a7eebc0t75a2868dd8532994@mail.gmail.com> (sfid-20081229_152416_085557_6EDBFBB7)
Date: Mon, 29 Dec 2008 19:54:07 +0530
From: "Vivek Natarajan" <vivek.natraj@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH v2] ath9k: Enable dynamic power save in ath9k.
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1230559969.3116.56.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20081229135341.GB2914@myhost.users.atheros.com>
	 <1230559969.3116.56.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 29, 2008 at 7:42 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2008-12-29 at 19:23 +0530, Vivek Natarajan wrote:
>
>> +static inline void ath9k_ps_wakeup(struct ath_softc *sc)
>> +{
>> +     if ((atomic_inc_return(&sc->ps_usecount) == 1) &&
>> +         (sc->sc_ah->ah_powerMode !=  ATH9K_PM_AWAKE)) {
>> +             sc->sc_ah->ah_restoreMode = sc->sc_ah->ah_powerMode;
>> +             ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_AWAKE);
>> +     }
>> +}
>> +
>> +static inline void ath9k_ps_restore(struct ath_softc *sc)
>> +{
>> +     if (atomic_dec_and_test(&sc->ps_usecount) &&
>> +        (sc->hw->conf.flags & IEEE80211_CONF_PS))
>> +             ath9k_hw_setpower(sc->sc_ah, sc->sc_ah->ah_restoreMode);
>
> Not sure which is intended, but maybe you should do the flags/powermode
> check before doing the refcount change? In either case, I would probably
> nest it into two if statements so it's clear which one is intended?

The count has to be incremented or decremented for every call.
Otherwise, the mode might not be restored in some corner case
conditions. Anyhow, I will nest it as two if
statements.

Thanks,
Vivek.
