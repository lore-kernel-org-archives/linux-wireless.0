Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53651 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab2G1UrO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jul 2012 16:47:14 -0400
Received: by obbuo13 with SMTP id uo13so6346786obb.19
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jul 2012 13:47:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5014065B.7070909@net.t-labs.tu-berlin.de>
References: <1343485971-31360-1-git-send-email-mickflemm@gmail.com>
	<1343485971-31360-3-git-send-email-mickflemm@gmail.com>
	<501404BE.7040606@net.t-labs.tu-berlin.de>
	<5014065B.7070909@net.t-labs.tu-berlin.de>
Date: Sat, 28 Jul 2012 23:47:14 +0300
Message-ID: <CAFtRNNzPnh_C2JqC4WjKrChn=QPcC4UG-8PigyGp4WLXuCb5GQ@mail.gmail.com> (sfid-20120728_224718_827159_BCCBB0D2)
Subject: Re: [PATCH 3/4] ath5k: Preserve tx power level requested from above
 on phy_init
From: Nick Kossifidis <mickflemm@gmail.com>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, mcgrof@gmail.com, jirislaby@gmail.com,
	nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/7/28 Thomas Huehn <thomas@net.t-labs.tu-berlin.de>:
> Let my correct myself
>
> Thomas Huehn schrieb:
>
>> Hi Nick,
>>
>> Nick Kossifidis schrieb:
>>
>>> By using cur_pwr on phy_init we re-use the power level previously set by the
>>> driver, not the one we got from above.
>>>
>>> Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
>>> ---
>>>  drivers/net/wireless/ath/ath5k/phy.c |    4 ++--
>>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
>>> index 84a9aaf..27ca993 100644
>>> --- a/drivers/net/wireless/ath/ath5k/phy.c
>>> +++ b/drivers/net/wireless/ath/ath5k/phy.c
>>> @@ -3802,8 +3802,8 @@ ath5k_hw_phy_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
>>>       * RF buffer settings on 5211/5212+ so that we
>>>       * properly set curve indices.
>>>       */
>>> -    ret = ath5k_hw_txpower(ah, channel, ah->ah_txpower.txp_cur_pwr ?
>>> -                    ah->ah_txpower.txp_cur_pwr / 2 : AR5K_TUNE_MAX_TXPOWER);
>>> +    ret = ath5k_hw_txpower(ah, channel, ah->power_level ?
>>> +                    ah->power_level * 2 : AR5K_TUNE_MAX_TXPOWER);
>>>      if (ret)
>>>              return ret;
>>>
>>
>>
>> I would suggest to initialise the power_level as AR5K_TUNE_MAX_TXPOWER
>> in base.c funktion ath5k_init(struct ieee80211_hw *hw)
>>
>>       /* init tx_power setting to maximum */
>>       ah->ah_txpower.txp_user_pwr = AR5K_TUNE_MAX_TXPOWER;
>>
>> that would simplify the readability form above into:
>>       ret = ath5k_hw_txpower(ah, channel, ah->power_level)
>>
>> What do you think ?
>>
>
>
> correct version i thought of should be:
>
>         /* init tx_power setting to maximum */
>         ah->ah_txpower.txp_user_pwr = AR5K_TUNE_MAX_TXPOWER / 2;
>
> that would simplify the readability form above into:
> ret = ath5k_hw_txpower(ah, channel, ah->power_level * 2)
>
>
> Greetings Thomas

init functions need cleanup, the idea is to split initialization per
unit and "layer", for example we have ath5k_init, ath5k_init_ah,
ath5k_hw_init etc, and an init function for each unit (phy, pcu,
qcu/dcu, dma etc). I haven't finished this process yet but for example
initializing phy parameters such as tx power (or any unit's
parameters) doesn't belong in the function that initializes driver
state and capabilities, it could belong to ath5k_hw_init but I want to
keep that minimal. Another example is queue initialization, it should
belong on a different function and not ath5k_init, there is also some
mess between ath5k_init_ah and ath5k_init, there is no obvious reason
to someone reading base.c why we have two init functions there and
what's each function purpose.

Anyway if readability is the issue we can just do something like

int txpower_halfdb = 0;

[...]

if(ah->power_level) {
 txpower_halfdb = ah->power_level * 2;
} else {
 txpower_halfdb = AR5K_TUNE_MAX_TXPOWER;
}

and then it'll look like this

ret = ath5k_hw_txpower(ah, channel, txpower_halfdb);

but really IMHO the compact form used right now is not that bad, it
gets better on the next patch I think:

+       ret = ath5k_hw_txpower(ah, channel, ah->ah_txpower.txp_requested ?
+                                       ah->ah_txpower.txp_requested * 2 :
+                                       AR5K_TUNE_MAX_TXPOWER);

We don't need to make things more complex, what we want to do is if we
got some tx power setting from above use it, else use the max power.
We don't need to split this across 2 different functions and use more
than a few loc.

>From another point of view there it's also misleading to initialize
the requested tx power value to something when no one ever requested
any tx power setting. This way we don't initialize
ah->ah_txpower.txp_requested and we can use that information in case
we want to do more checks later or in case someone from above needs
that information (wouldn't it be weird if someone from above asked us
what tx power was requested and we reply with max tx power ?).

-- 
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick
