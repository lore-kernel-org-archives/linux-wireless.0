Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:58152 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933737AbeE1VJG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 May 2018 17:09:06 -0400
Subject: Re: [PATCH v1] ath10k: fix band_center_freq handling for VHT160 in
 recent firmwares
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20180426094357.24358-1-s.gottschall@dd-wrt.com>
 <19b8766e-d474-31d3-ff38-993498ee670d@candelatech.com>
 <da5c7c56-9a41-99f0-28be-3a2c8e9fabbf@dd-wrt.com>
 <87wovr94ml.fsf@kamboji.qca.qualcomm.com>
 <71d17554-7727-cdfa-4a0d-5e1170dc32b7@candelatech.com>
 <43553b5b-9e06-2a6a-098e-9223a7aeeac6@dd-wrt.com>
 <62644a80-7125-4978-a6ca-c3aabc005c99@candelatech.com>
 <c368e4a9-5079-ba1b-8639-81f7672e2743@dd-wrt.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <cabe807c-7029-e8db-db3e-51c06bb693c9@candelatech.com> (sfid-20180528_230913_614434_4126B142)
Date: Mon, 28 May 2018 14:08:57 -0700
MIME-Version: 1.0
In-Reply-To: <c368e4a9-5079-ba1b-8639-81f7672e2743@dd-wrt.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 05/28/2018 10:54 AM, Sebastian Gottschall wrote:
>
>
> Am 28.05.2018 um 16:43 schrieb Ben Greear:
>>
>>
>> On 05/27/2018 03:25 PM, Sebastian Gottschall wrote:
>>>
>>>
>>> Am 25.05.2018 um 16:52 schrieb Ben Greear:
>>>> On 05/25/2018 07:44 AM, Kalle Valo wrote:
>>>>> Sebastian Gottschall <s.gottschall@dd-wrt.com> writes:
>>>>>
>>>>>> Am 26.04.2018 um 15:44 schrieb Ben Greear:
>>>>>>>
>>>>>>>
>>>>>>> On 04/26/2018 02:43 AM, s.gottschall@dd-wrt.com wrote:
>>>>>>>> From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
>>>>>>>>
>>>>>>>> starting with firmware 10.4.3.4.x series QCA changed the handling
>>>>>>>> of the channel property band_center_freq1 and band_center_freq2 in
>>>>>>>> vht160 operation mode
>>>>>>>> likelly for backward compatiblity with vht80 only capable clients.
>>>>>>>> this patch adjusts the handling to get vht160 to work again with
>>>>>>>> official qca firmwares newer than 3.3
>>>>>>>> consider that this patch will not work with older firmwares
>>>>>>>> anymore. to avoid undefined behaviour this we disable vht160
>>>>>>>> capability for outdated firmwares
>>>>>>>
>>>>>>> We should be able to use a feature-flag or otherwise determine if
>>>>>>> the firmware needs the old or new
>>>>>>> API and make the driver able to handle both.
>>>>>>
>>>>>> the new firmware must be used as is and it works. the old firmware can
>>>>>> be detected on the missing vht cap flag.
>>>>>> but thats not my task. i can only use feature flags if they are
>>>>>> included within the qca firmwares. but they arent
>>>>>> the old pre 3.3 firmwares should be treated as obsolete. they are more
>>>>>> than 2 years old and do not announce vht160 capability
>>>>>> even if it works with some ignorance, but on the other side the it has
>>>>>> backward incompatiblies with older vht80 only clients.
>>>>>> this is why the new way was introduced
>>>>>
>>>>> I was told ath10k could check for WMI_SERVICE_EXTENDED_NSS_SUPPORT flag.
>>>>> Can someone test and verify that?
>>>>>
>>>>
>>>> I do see that my firmware source based on older upstream QCA FW does not advertise
>>>> that flag, and newer QCA firmware does, so it would appear that test might
>>>> work.
>>> but your sourcebase is new enough that this new handling is required.  if i remember correct this handling is required starting with 10.4-3.4 source base
>>> if a 3.4 original firmware is not providing that flag, it cannot be used for correct handling and yours is 3.4 based
>>
>> With my current driver and my current (older) firmware source, 160Mhz works fine.
>>
>> I think my driver changes related to 160Mhz are upstream, so probably stock driver
>> works with my firmware at 160Mhz as well.
>>
>> If you change the driver, then it will likely break older firmware.  So, just change
>> the driver behaviour if the WMI_SERVICE_EXTENDED_NSS_SUPPORT is enabled.
> only pre 3.4 which isnt important. but without my change everything from 3.4 upwards wont work anymore. so my change fixes vht160 for firmwares released within the last 2 years.
> WMI_SERVICE_EXTENDED_NSS_SUPPORT condition cannot work since you explained that your driver base which is 3.4 doesnt provide this flag but 3.4 stock does require this change

I'll let you and Kalle work this out then.  I can fix my driver to work whatever
you do, and if I can ever get patches upstream, then I'll deal with it then.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
