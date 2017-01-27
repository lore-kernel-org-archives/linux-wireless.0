Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:32817 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932414AbdA0KFp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jan 2017 05:05:45 -0500
Received: by mail-pf0-f177.google.com with SMTP id y143so72519498pfb.0
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jan 2017 02:05:40 -0800 (PST)
Subject: Re: [PATCH 2/6] wl1251: Use request_firmware_prefer_user() for
 loading NVS calibration data
To: =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali.rohar@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <1482598381-16513-1-git-send-email-pali.rohar@gmail.com>
 <1482598381-16513-3-git-send-email-pali.rohar@gmail.com>
 <87tw8lnei3.fsf@codeaurora.org> <20170127094342.GC24223@pali>
Cc: Ming Lei <ming.lei@canonical.com>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Gnedt <david.gnedt@davizone.at>,
        Michal Kazior <michal.kazior@tieto.com>,
        Daniel Wagner <wagi@monom.org>,
        Tony Lindgren <tony@atomide.com>,
        Sebastian Reichel <sre@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Grazvydas Ignotas <notasas@gmail.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <def4c357-64c0-0681-a5d5-f49a6cb84a92@broadcom.com> (sfid-20170127_111031_605868_06556B2B)
Date: Fri, 27 Jan 2017 11:05:32 +0100
MIME-Version: 1.0
In-Reply-To: <20170127094342.GC24223@pali>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27-1-2017 10:43, Pali Rohár wrote:
> On Friday 27 January 2017 09:33:40 Kalle Valo wrote:
>> Pali Rohár <pali.rohar@gmail.com> writes:
>>
>>> NVS calibration data for wl1251 are model specific. Every one device with
>>> wl1251 chip has different and calibrated in factory.
>>>
>>> Not all wl1251 chips have own EEPROM where are calibration data stored. And
>>> in that case there is no "standard" place. Every device has stored them on
>>> different place (some in rootfs file, some in dedicated nand partition,
>>> some in another proprietary structure).
>>>
>>> Kernel wl1251 driver cannot support every one different storage decided by
>>> device manufacture so it will use request_firmware_prefer_user() call for
>>> loading NVS calibration data and userspace helper will be responsible to
>>> prepare correct data.
>>>
>>> In case userspace helper fails request_firmware_prefer_user() still try to
>>> load data file directly from VFS as fallback mechanism.
>>>
>>> On Nokia N900 device which has wl1251 chip, NVS calibration data are stored
>>> in CAL nand partition. CAL is proprietary Nokia key/value format for nand
>>> devices.
>>>
>>> With this patch it is finally possible to load correct model specific NVS
>>> calibration data for Nokia N900.
>>>
>>> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
>>> ---
>>>  drivers/net/wireless/ti/wl1251/Kconfig |    1 +
>>>  drivers/net/wireless/ti/wl1251/main.c  |    2 +-
>>>  2 files changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/wireless/ti/wl1251/Kconfig b/drivers/net/wireless/ti/wl1251/Kconfig
>>> index 7142ccf..affe154 100644
>>> --- a/drivers/net/wireless/ti/wl1251/Kconfig
>>> +++ b/drivers/net/wireless/ti/wl1251/Kconfig
>>> @@ -2,6 +2,7 @@ config WL1251
>>>  	tristate "TI wl1251 driver support"
>>>  	depends on MAC80211
>>>  	select FW_LOADER
>>> +	select FW_LOADER_USER_HELPER
>>>  	select CRC7
>>>  	---help---
>>>  	  This will enable TI wl1251 driver support. The drivers make
>>> diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
>>> index 208f062..24f8866 100644
>>> --- a/drivers/net/wireless/ti/wl1251/main.c
>>> +++ b/drivers/net/wireless/ti/wl1251/main.c
>>> @@ -110,7 +110,7 @@ static int wl1251_fetch_nvs(struct wl1251 *wl)
>>>  	struct device *dev = wiphy_dev(wl->hw->wiphy);
>>>  	int ret;
>>>  
>>> -	ret = request_firmware(&fw, WL1251_NVS_NAME, dev);
>>> +	ret = request_firmware_prefer_user(&fw, WL1251_NVS_NAME, dev);
>>
>> I don't see the need for this. Just remove the default nvs file from
>> filesystem and the fallback user helper will be always used, right?
> 
> It is part of linux-firmware repository. And already part of all
> previous versions of linux-firmware packages in lot of linux
> distributions. So removing it is not possible...

You are probably saying that on your platform you can not remove
anything from /lib/firmware, right? I don't see how you come from "it is
part of firmware package" to "removing is not possible". Trying to
understand this and it makes no sense.

>> Like we discussed earlier, the default nvs file should not be used by
>> normal users.
> 
> But already is and we need to deal with this fact.

Why? Are there other platforms that use the default nvs file and have a
working wifi. So your "removing is not possible" would be about
regression for those?

Regards,
Arend
