Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:46423 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757186Ab1GDKOo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jul 2011 06:14:44 -0400
Received: by gwaa18 with SMTP id a18so1939054gwa.19
        for <linux-wireless@vger.kernel.org>; Mon, 04 Jul 2011 03:14:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E1190FF.9010701@openwrt.org>
References: <1309758467-1712-1-git-send-email-nbd@openwrt.org>
	<1309758467-1712-2-git-send-email-nbd@openwrt.org>
	<1309758467-1712-3-git-send-email-nbd@openwrt.org>
	<1309758467-1712-4-git-send-email-nbd@openwrt.org>
	<1309758467-1712-5-git-send-email-nbd@openwrt.org>
	<1309758467-1712-6-git-send-email-nbd@openwrt.org>
	<1309758467-1712-7-git-send-email-nbd@openwrt.org>
	<CAFtRNNyPJOtjW8vDnjveqmMD3snt_iaDV45p3QZEOKrSyED3yg@mail.gmail.com>
	<4E1190FF.9010701@openwrt.org>
Date: Mon, 4 Jul 2011 13:14:43 +0300
Message-ID: <CAFtRNNyyx2e3YhKgGwG4h678dEKkQwdVf8pXBtWqYHZzx9r0cQ@mail.gmail.com> (sfid-20110704_121448_341908_238F24A2)
Subject: Re: [PATCH 7/8] ath5k: disable 32KHz sleep clock operation
From: Nick Kossifidis <mickflemm@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/7/4 Felix Fietkau <nbd@openwrt.org>:
> On 2011-07-04 4:58 PM, Nick Kossifidis wrote:
>>
>> 2011/7/4 Felix Fietkau<nbd@openwrt.org>:
>>>
>>>  While 32 KHz sleep clock might provide some power saving benefits,
>>>  it is also a major source of stability issues, on OpenWrt it produced
>>>  some reproducible data bus errors on register accesses on several
>>>  different MIPS platforms.
>>>
>>>  All the Atheros drivers that I can find do not enable this feature,
>>>  so it makes sense to leave it disabled in ath5k as well.
>>>
>>>  Signed-off-by: Felix Fietkau<nbd@openwrt.org>
>>>  ---
>>>   drivers/net/wireless/ath/ath5k/reset.c |    9 ---------
>>>   1 files changed, 0 insertions(+), 9 deletions(-)
>>>
>>>  diff --git a/drivers/net/wireless/ath/ath5k/reset.c
>>> b/drivers/net/wireless/ath/ath5k/reset.c
>>>  index 55276ce..192c0cb 100644
>>>  --- a/drivers/net/wireless/ath/ath5k/reset.c
>>>  +++ b/drivers/net/wireless/ath/ath5k/reset.c
>>>  @@ -1285,15 +1285,6 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum
>>> nl80211_iftype op_mode,
>>>          */
>>>         ath5k_hw_dma_init(ah);
>>>
>>>  -
>>>  -       /* Enable 32KHz clock function for AR5212+ chips
>>>  -        * Set clocks to 32KHz operation and use an
>>>  -        * external 32KHz crystal when sleeping if one
>>>  -        * exists */
>>>  -       if (ah->ah_version == AR5K_AR5212&&
>>>  -           op_mode != NL80211_IFTYPE_AP)
>>>  -               ath5k_hw_set_sleep_clock(ah, true);
>>>  -
>>>         /*
>>>          * Disable beacons and reset the TSF
>>>          */
>>>  --
>>>  1.7.3.2
>>>
>>
>> a) LegacyHAL and Sam's HAL both enable it
>
> At least in the Legacy HAL (and in all other HALs that I looked a) I found
> this in the attach function:
>    ahp->ah_enable32kHzClock = DONT_USE_32KHZ;/* XXX */
>

Ouch, I missed that part...

>> b) Not many cards have a 32KHz crystal anyway (disabled on EEPROM)
>> c) Please don't just remove code, if you want to disable it you can
>> always comment it out
>
> OK.
>
>> d) Why not make it a module parameter instead ?
>
> I'm not sure 32 KHz has been tested properly and found to be stable
> anywhere, so I'm not convinced it will be useful to anybody. Also, I think a
> debugfs parameter might be better because then it can be enabled/disabled
> per card.
>
> - Felix
>

O.K. let's comment it out then and add some information that it's
disabled by default on available HALs...


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
