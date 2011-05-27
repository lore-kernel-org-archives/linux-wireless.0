Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54200 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab1E0Hqs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 May 2011 03:46:48 -0400
Received: by gxk21 with SMTP id 21so593840gxk.19
        for <linux-wireless@vger.kernel.org>; Fri, 27 May 2011 00:46:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=Hxaj+mDm5Ecqut2hxefNHyuO8-Q@mail.gmail.com>
References: <24ECC725-EA49-48CA-8B9D-FDD71BD257A0@cs.washington.edu>
	<BANLkTi=Hxaj+mDm5Ecqut2hxefNHyuO8-Q@mail.gmail.com>
Date: Fri, 27 May 2011 15:46:47 +0800
Message-ID: <BANLkTi=3mGWzGghuip2xyo+24yd2mJXfUg@mail.gmail.com> (sfid-20110527_094652_011245_6321947B)
Subject: Re: [PATCH/RFC] ath9k: fix two more bugs in tx power
From: Adrian Chadd <adrian@freebsd.org>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: Daniel Halperin <dhalperi@cs.washington.edu>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	stable@kernel.org, blaise@willowgarage.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

That should only really hit 0 if you're configuring a low TX power level.. ?

Hm, I spy with my little eye a small bug with the eeprom power
handling for the v14 eeprom.
The modal header has:

        u8 pwrDecreaseFor2Chain;
        u8 pwrDecreaseFor3Chain;

but the EEPROM code is hard-coded to use -6 for 2-chain reduction and
-9 for 3-chain reduction.

A completely untested patch (but FreeBSD does this) :

diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c
b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index 17f0a68..09f587b 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -906,6 +906,7 @@ static void
ath9k_hw_set_def_power_per_rate_table(struct ath_hw *ah,
        struct chan_centers centers;
        int tx_chainmask;
        u16 twiceMinEdgePower;
+       u8 pwrDecreaseFor2Chain, pwrDecreaseFor3Chain;

        tx_chainmask = ah->txchainmask;

@@ -924,6 +925,11 @@ static void
ath9k_hw_set_def_power_per_rate_table(struct ath_hw *ah,
        twiceLargestAntenna = (int16_t)min(AntennaReduction -
                                           twiceLargestAntenna, 0);

+       pwrDecreaseFor2Chain = pEepData->modalHeader
+                                 [IS_CHAN_2GHZ(chan)].pwrDecreaseFor2Chain;
+       pwrDecreaseFor3Chain = pEepData->modalHeader
+                                 [IS_CHAN_2GHZ(chan)].pwrDecreaseFor3Chain;
+
        maxRegAllowedPower = twiceMaxRegulatoryPower + twiceLargestAntenna;

        if (regulatory->tp_scale != ATH9K_TP_SCALE_MAX) {
@@ -937,14 +943,14 @@ static void
ath9k_hw_set_def_power_per_rate_table(struct ath_hw *ah,
        case 1:
                break;
        case 2:
-               if (scaledPower > REDUCE_SCALED_POWER_BY_TWO_CHAIN)
-                       scaledPower -= REDUCE_SCALED_POWER_BY_TWO_CHAIN;
+               if (scaledPower > pwrDecreaseFor2Chain)
+                       scaledPower -= pwrDecreaseFor2Chain;
                else
                        scaledPower = 0;
                break;
        case 3:
-               if (scaledPower > REDUCE_SCALED_POWER_BY_THREE_CHAIN)
-                       scaledPower -= REDUCE_SCALED_POWER_BY_THREE_CHAIN;
+               if (scaledPower > pwrDecreaseFor3Chain)
+                       scaledPower -= pwrDecreaseFor3Chain;
                else
                        scaledPower = 0;
                break;


On 27 May 2011 15:18, Mohammed Shafi <shafi.wireless@gmail.com> wrote:
> On Thu, May 26, 2011 at 10:13 PM, Daniel Halperin
> <dhalperi@cs.washington.edu> wrote:
>> This is the same fix as
>>
>>    commit 841051602e3fa18ea468fe5a177aa92b6eb44b56
>>    Author: Matteo Croce <technoboy85@gmail.com>
>>    Date:   Fri Dec 3 02:25:08 2010 +0100
>>
>>    The ath9k driver subtracts 3 dBm to the txpower as with two radios the
>>    signal power is doubled.
>>    The resulting value is assigned in an u16 which overflows and makes
>>    the card work at full power.
>>
>> in two more places. I grepped the ath tree and didn't find any others.
>>
>> Cc: stable@kernel.org
>> Signed-off-by: Daniel Halperin <dhalperi@cs.washington.edu>
>> ---
>> RFC: Blaise Gassend actually pointed these two bugs out on 12/7/2010 but no
>> one fixed. There was some discussion about refactoring/improving this code,
>> but it never seemed to get anywhere. See this thread:
>>
>>    http://comments.gmane.org/gmane.linux.drivers.ath9k.devel/4601
>> ---
>>  drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   10 ++++++++--
>>  drivers/net/wireless/ath/ath9k/eeprom_9287.c   |   10 ++++++++--
>>  2 files changed, 16 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
>> index 729534c..934e419 100644
>> --- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
>> +++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
>> @@ -4645,10 +4645,16 @@ static void ar9003_hw_set_power_per_rate_table(struct ath_hw *ah,
>>        case 1:
>>                break;
>>        case 2:
>> -               scaledPower -= REDUCE_SCALED_POWER_BY_TWO_CHAIN;
>> +               if (scaledPower > REDUCE_SCALED_POWER_BY_TWO_CHAIN)
>> +                       scaledPower -= REDUCE_SCALED_POWER_BY_TWO_CHAIN;
>> +               else
>> +                       scaledPower = 0;
>
> should we make the scaledPower as '0' lets have the first check if it
> fails, let us retain the  scaledPower obtained by
>  scaledPower = min(powerLimit, maxRegAllowedPower);
>
> am I missing something ?
> making scaledPower affects this
>   minCtlPower = (u8)min(twiceMaxEdgePower, scaledPower);
>
> which in turn affects
>  pPwrArray[i] =
>                                          (u8)min((u16)pPwrArray[i],
>                                                  minCtlPower);
>
> which in turn affects target Power values
>
>
>
>
>
>>                break;
>>        case 3:
>> -               scaledPower -= REDUCE_SCALED_POWER_BY_THREE_CHAIN;
>> +               if (scaledPower > REDUCE_SCALED_POWER_BY_THREE_CHAIN)
>> +                       scaledPower -= REDUCE_SCALED_POWER_BY_THREE_CHAIN;
>> +               else
>> +                       scaledPower = 0;
>>                break;
>>        }
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
>> index 7856f0d..343fc9f 100644
>> --- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
>> +++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
>> @@ -524,10 +524,16 @@ static void ath9k_hw_set_ar9287_power_per_rate_table(struct ath_hw *ah,
>>        case 1:
>>                break;
>>        case 2:
>> -               scaledPower -= REDUCE_SCALED_POWER_BY_TWO_CHAIN;
>> +               if (scaledPower > REDUCE_SCALED_POWER_BY_TWO_CHAIN)
>> +                       scaledPower -= REDUCE_SCALED_POWER_BY_TWO_CHAIN;
>> +               else
>> +                       scaledPower = 0;
>>                break;
>>        case 3:
>> -               scaledPower -= REDUCE_SCALED_POWER_BY_THREE_CHAIN;
>> +               if (scaledPower > REDUCE_SCALED_POWER_BY_THREE_CHAIN)
>> +                       scaledPower -= REDUCE_SCALED_POWER_BY_THREE_CHAIN;
>> +               else
>> +                       scaledPower = 0;
>>                break;
>>        }
>>        scaledPower = max((u16)0, scaledPower);
>> --
>> 1.7.0.4
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> shafi
>
