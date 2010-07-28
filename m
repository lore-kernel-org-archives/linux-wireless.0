Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:56285 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641Ab0G1W2F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 18:28:05 -0400
Message-ID: <4C50AEF4.4060905@openwrt.org>
Date: Thu, 29 Jul 2010 00:28:04 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 1/3] ath9k: prevent calibration during off-channel 	activity
References: <1280339151-37084-1-git-send-email-nbd@openwrt.org> 	<AANLkTimZ8zTZWDcXwr7Hu2FT=gDPeCiiUFXcBmpYpp7M@mail.gmail.com> 	<4C509C65.4020305@openwrt.org> <AANLkTimqsXoynA2CPJ1tFmj6wUetztDUJ3iKCpQHJKCe@mail.gmail.com>
In-Reply-To: <AANLkTimqsXoynA2CPJ1tFmj6wUetztDUJ3iKCpQHJKCe@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-07-29 12:12 AM, Luis R. Rodriguez wrote:
> On Wed, Jul 28, 2010 at 2:08 PM, Felix Fietkau <nbd@openwrt.org> wrote:
>> On 2010-07-28 10:43 PM, Luis R. Rodriguez wrote:
>>> On Wed, Jul 28, 2010 at 10:45 AM, Felix Fietkau <nbd@openwrt.org> wrote:
>>>> Previously the software scan callback was used to indicate to the hardware,
>>>> when it was safe to calibrate. This didn't really work properly, because it
>>>> depends on a specific order of software scan callbacks vs. channel changes.
>>>> Also, software scans are not the only thing that triggers off-channel
>>>> activity, so it's better to use the newly added indication from mac80211 for
>>>> this and not use the software scan callback for anything calibration related.
>>>>
>>>> This fixes at least some of the invalid noise floor readings that I've seen
>>>> in AP mode on AR9160
>>>
>>> Neat!
>>>
>>>> --- a/drivers/net/wireless/ath/ath9k/main.c
>>>> +++ b/drivers/net/wireless/ath/ath9k/main.c
>>>> @@ -154,6 +154,27 @@ void ath9k_ps_restore(struct ath_softc *sc)
>>>>        spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
>>>>  }
>>>>        spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
>>>>  }
>>>>
>>>> +static void ath_start_ani(struct ath_common *common)
>>>> +{
>>>> +       struct ath_hw *ah = common->ah;
>>>> +       unsigned long timestamp = jiffies_to_msecs(jiffies);
>>>> +       struct ath_softc *sc = (struct ath_softc *) common->priv;
>>>> +
>>>> +       if (!(sc->sc_flags & SC_OP_ANI_RUN))
>>>> +               return;
>>>> +
>>>> +       if (sc->sc_flags & SC_OP_OFFCHANNEL)
>>>> +               return;
>>>> +
>>>> +       common->ani.longcal_timer = timestamp;
>>>> +       common->ani.shortcal_timer = timestamp;
>>>> +       common->ani.checkani_timer = timestamp;
>>>> +
>>>> +       mod_timer(&common->ani.timer,
>>>> +                 jiffies +
>>>> +                       msecs_to_jiffies((u32)ah->config.ani_poll_interval));
>>>> +}
>>>
>>> I would prefer if you do this sort of code shift in a separate patch.
>>> In this case its pretty easy to see the code is the same so I think
>>> its fine the way it is now but for next time please. Otherwise looks
>>> good, thanks!!
>> If it had been a bigger function, I'd have made a separate patch, but I
>> figured for something as trivial as this it wouldn't matter.
> 
> iw event -t while  pinging and then issuing a scan:
> 
> 1280354915.820607: wlan32 (phy #0): scan started
> 1280354920.390438: wlan32 (phy #0): scan finished: 2412 2417 2422 2427
> 2432 2437 2442 2447 2452 2457 2462 5180 5200 5220 5240 5260 5280 5300
> 5320 5500 5520 5540 5560 5580 5660 5680 5700 5745 5765 5785 5805 5825,
> ""
> 1280354923.103628: wlan32 (phy #0): deauth FOO -> BAR reason 4:
> Disassociated due to inactivity
> 1280354923.103736: wlan32 (phy #0): disconnected (local request)
> 1280354923.111251: phy #0: regulatory domain change: set to world
> roaming by the wireless core upon initialization request
> 
> So this seems to re-introduce the same issue I was seeing before.
Are you sure it's this change? Can you make a log with debug=0x8?
What's the specific symptom here? Does the rx path turn deaf?

- Felix
