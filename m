Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34832 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756383Ab0LPR6K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 12:58:10 -0500
Received: by iyi12 with SMTP id 12so1680211iyi.19
        for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 09:58:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101216174410.GB5677@tux>
References: <1292482775.3542.8.camel@jlt3.sipsolutions.net>
 <AANLkTi=pZAnyp5ztSqCo-MEF=_arECfAYg43JJ_j1Gb4@mail.gmail.com>
 <1292499024.3612.3.camel@jlt3.sipsolutions.net> <AANLkTimxoA+3GaZZWODKJ9MVJTJzRhnj5oh_jWGJhzWc@mail.gmail.com>
 <1292501047.3612.9.camel@jlt3.sipsolutions.net> <AANLkTiktMJvk55fz-Ww_nUtHcTS1mNVSR-hhkfbux+j_@mail.gmail.com>
 <1292502934.3612.15.camel@jlt3.sipsolutions.net> <AANLkTimZdxQNk2hr-ekGPAWJB5YTZBqxdppOAjdbrb1i@mail.gmail.com>
 <1292504020.3612.17.camel@jlt3.sipsolutions.net> <AANLkTinWkYK2Zu1LsKw9YQ4dAXJ2b_quEvZLc59-c_5q@mail.gmail.com>
 <20101216174410.GB5677@tux>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 16 Dec 2010 09:49:17 -0800
Message-ID: <AANLkTi=u875OgPEfV4PCijLcaVs4Nw3Ycu+GsYUBZuTH@mail.gmail.com>
Subject: Re: [PATCH] mac80211: Push idle state to driver before stop
To: Paul Stewart <pstew@google.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 16, 2010 at 9:44 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Thu, Dec 16, 2010 at 08:02:27AM -0800, Paul Stewart wrote:
>> On Thu, Dec 16, 2010 at 4:53 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Thu, 2010-12-16 at 04:46 -0800, Paul Stewart wrote:
>> > Not really -- the driver may throw away all internal state, mac80211
>> > will (attempt to) restore it all through drv_config() with changed = ~0.
>> > Evidently ath9k has some magic that makes this fail?
>>
>> The magic in question is as follows (ath9k_config()):
>>
>>     if (changed & IEEE80211_CONF_CHANGE_IDLE) {
>>         bool enable_radio;
>>         bool all_wiphys_idle;
>>         bool idle = !!(conf->flags & IEEE80211_CONF_IDLE);
>>
>>         spin_lock_bh(&sc->wiphy_lock);
>>         all_wiphys_idle =  ath9k_all_wiphys_idle(sc);
>>        ath9k_set_wiphy_idle(aphy, idle);
>>
>>         enable_radio = (!idle && all_wiphys_idle);
>>
>>         /*
>>          * After we unlock here its possible another wiphy
>>          * can be re-renabled so to account for that we will
>>          * only disable the radio toward the end of this routine
>>          * if by then all wiphys are still idle.
>>          */
>>         spin_unlock_bh(&sc->wiphy_lock);
>>
>>         if (enable_radio) {
>>             sc->ps_idle = false;
>>             ath_radio_enable(sc, hw);
>>             ath_dbg(common, ATH_DBG_CONFIG,
>>                     "not-idle: enabling radio\n");
>>         }
>>     }
>>
>> So, ath9k enables and disables the radio based on ps_idle (the
>> internal state), but that's not re-evaluated unless the wiphys
>> actually change.  In this case they do not change because ath9k was
>> never informed that the wiphy went idle (all_wiphys_idle evaluates to
>> false).  One solution would be to do an ah9k_set_wiphy_idle(aphy,
>> true) in ath9k_stop() instead of Luis' previous suggestion of setting
>> sc->ps_idle directly.  Perhaps in January when I return from vacation
>> I'll test this to make sure that performs as intended in the
>> suspend-resume-while-associated case.  It's a little bit of a lie to
>> do it in this case since in fact as far as mac80211 is concerned, the
>> wiphy is not idle in this case.
>
> Try this:
>
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index c68205d..3de3dbf 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -1350,6 +1350,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
>        ath9k_ps_restore(sc);
>
>        sc->ps_idle = true;
> +       ath9k_set_wiphy_idle(aphy, true);
>        ath_radio_disable(sc, hw);
>
>        sc->sc_flags |= SC_OP_INVALID;
> diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
> index 7ca8499..4538283 100644
> --- a/drivers/net/wireless/ath/ath9k/pci.c
> +++ b/drivers/net/wireless/ath/ath9k/pci.c
> @@ -310,6 +310,7 @@ static int ath_pci_resume(struct device *device)
>        ath9k_hw_set_gpio(sc->sc_ah, sc->sc_ah->led_pin, 1);
>
>        sc->ps_idle = true;
> +       ath9k_set_wiphy_idle(aphy, true);
>        ath_radio_disable(sc, hw);
>
>        return 0;

If this does not work then yes, I will argue that mac80211 is not
turning us on when it needs to. I was concered about the resume case
given that mac80211 only calls drv_start() when open_count is > 0. So
we'll see.

  Luis
