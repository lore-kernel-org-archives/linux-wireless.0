Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from telenetsystems.com ([130.94.222.88]:60103 "EHLO
	telenetsystems.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab2GGLdV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jul 2012 07:33:21 -0400
Date: Sat, 07 Jul 2012 17:03:08 +0530
Subject: Re: [ath9k-devel] ath9k: Problems with diversity on AR9330
From: Sunil Mehta <sunil2@telenetsystems.com>
To: Mohammed Shafi <shafi.wireless@gmail.com>
CC: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Message-ID: <CC1E1B51.12FDA%sunil2@telenetsystems.com> (sfid-20120707_133400_101203_BF3A11F5)
In-Reply-To: <CAD2nsn1dkyWvuosr8dhJ1seP_hBO7mBqaFtWQnzNJQBvLKHXnw@mail.gmail.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi Shafi,

LSDK is a Atheros Release which supports AR9331. We are adding
applications on this.

We are unsure of how to confirm if the second LNA is enabled. How can we
check if the signals on LNA2 are being processed.

In the calibration data we are setting LNA1+LNA2 as primary. Are there any
other settings we should do.

Regards,
Sunil.


On 7/7/12 4:06 PM, "Mohammed Shafi" <shafi.wireless@gmail.com> wrote:

>Hi Sunil,
>
>>
>> We are facing similar problems with configuring the LNA2 of AR9331 for
>> diversity. Even though we try to set the RXCHAINMASK = 0x03, on checking
>> the value, it keeps showing as 0x01.
>
>chainmask is indeed 1 and its correct
>
> (AR_SREV_9485(ah) || AR_SREV_9285(ah) || AR_SREV_9330(ah))
>                chip_chainmask = 1;
>
>
>>
>> We are currently using LSDK-9.2.0_U10.1020. It appears that some where
>>the
>> value may be hardcoded to 0x01 in this Release.
>
>some internal build ?
>
>>
>> Can you suggest how to solve this.
>>
>> Regards,
>> Sunil.
>>
>>
>> On 7/7/12 3:44 PM, "Mohammed Shafi" <shafi.wireless@gmail.com> wrote:
>>
>>>On Sat, Jul 7, 2012 at 3:28 PM, Mohammed Shafi
>>><shafi.wireless@gmail.com>
>>>wrote:
>>>> Hi Sven,
>>>>
>>>> On Fri, Jul 6, 2012 at 10:05 PM, Sven Eckelmann <sven@narfation.org>
>>>>wrote:
>>>>> On Friday 06 July 2012 17:13:42 Sven Eckelmann wrote:
>>>>> [...]
>>>>>> > I just also observer the chain0 is "preferred" unless the RSSI is
>>>>>>so
>>>>>> > poor in it so chain1 is taken.
>>>>>> > Please check if this work out for your case too.
>>>>>>
>>>>>> Removing the antenna on chain0 doesn't change the alt_rssi value for
>>>>>>us. We
>>>>>> only noticed that frames with alt_rssi != -128 have  the value
>>>>>>rx_ant_conf
>>>>>> == 1 (LNA2) when only chain1 is attached and rx_ant_conf == 2 (LNA1)
>>>>>>when
>>>>>> both/chain0-only are attached. Still most of the packets had
>>>>>>alt_rssi
>>>>>>==
>>>>>> -128 and we saw changes in curr_main_set and curr_alt_set (after lot
>>>>>>of
>>>>>> data was sent).
>>>>>
>>>>> Here are some logs. We added some debug printk before first check in
>>>>> ath_ant_comb_scan ("if (main_rssi > 0 && alt_rssi > 0) {"). We can
>>>>>see
>>>>>a
>>>>> difference in the output after (a more or less long time) both
>>>>>antennas were
>>>>> unplugged. The output looks extreme different when at least one
>>>>>antenna is
>>>>> attached.
>>>>
>>>> thanks, i saw the logs. i could do some analysis with AR9485/AR9285.
>>>> as you had said before
>>>> alt_rssi is -128 when one antenna is unplugged, while having both out
>>>> seems to bring some
>>>> +tive value for alt_rssi.
>>>>
>>>>>
>>>>> alt_ant_conf is calculated using
>>>>> "alt_ant_conf = (rs->rs_rssi_ctl[2]) & ATH_ANT_RX_MASK;" and could be
>>>>>wrong.
>>>>> curr_alt_set and curr_main_set come from div_ant_conf queried using
>>>>> ath9k_hw_antdiv_comb_conf_get.
>>>>
>>>> thanks i would check this out.  As the algorithm itself is bit
>>>> complex, i would just revisit
>>>> and check it out. If i remember correctly Fast antenna diversity was
>>>> working fine with AR9485.
>>>
>>>further i check with the CCK/DETECT and MC_GAIN_CTRL in ar9485, it
>>>seems
>>>to be
>>> ar9003_hw_ant_ctrl_apply CCK_DETECT 80be6788
>>> ar9003_hw_ant_ctrl_apply MC_GAIN_CTRLL 13ef0200
>>>will check it out whats the one bit difference in CCK_DETECT
>>>
>>>
>>>>
>>>>>
>>>>> Kind regards
>>>>>         Sven
>>>>
>>>>
>>>>
>>>> --
>>>> thanks,
>>>> shafi
>>>
>>>
>>>
>>>--
>>>thanks,
>>>shafi
>>>_______________________________________________
>>>ath9k-devel mailing list
>>>ath9k-devel@lists.ath9k.org
>>>https://lists.ath9k.org/mailman/listinfo/ath9k-devel
>>
>>
>
>
>
>-- 
>thanks,
>shafi


