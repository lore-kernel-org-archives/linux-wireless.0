Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:7152 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904AbZAGMlB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 07:41:01 -0500
Received: by fg-out-1718.google.com with SMTP id 19so2993705fgg.17
        for <linux-wireless@vger.kernel.org>; Wed, 07 Jan 2009 04:40:59 -0800 (PST)
Message-ID: <3ace41890901070440w63fbb06fy39e3bcb387f08d60@mail.gmail.com> (sfid-20090107_134109_596342_64D1285C)
Date: Wed, 7 Jan 2009 12:40:59 +0000
From: "Hin-Tak Leung" <hintak.leung@gmail.com>
To: "Rodrigo Fresneda" <fresneda@gmail.com>
Subject: Re: trouble with compat-old
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <e6236e5f0901061740s20d817b1s2befb66cefbf72b0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <e6236e5f0901060312h6946f9a1p49e299e723cb0190@mail.gmail.com>
	 <3ace41890901061536k7722b63h906962283ce9e4ad@mail.gmail.com>
	 <e6236e5f0901061740s20d817b1s2befb66cefbf72b0@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 7, 2009 at 1:40 AM, Rodrigo Fresneda <fresneda@gmail.com> wrote:
> Thanks for your answer. Now, what exactly am I supposed to do? Take a
> look at the IWL section in config.mk:

That's a bit wrong... how about try changing the 4965 "y" to "m"?

>
> CONFIG_IWL3945=m
> CONFIG_IWL3945_DEBUG=n
> CONFIG_IWL3945_LEDS=y
> # CONFIG_IWL3945_RFKILL=y
> CONFIG_IWL3945_SPECTRUM_MEASUREMENT=y
> CONFIG_IWL4965=y
> CONFIG_IWL5000=y
> CONFIG_IWLAGN=m
> CONFIG_IWLAGN_LEDS=y
> CONFIG_IWLAGN_SPECTRUM_MEASUREMENT=y
> CONFIG_IWLCORE=m
> CONFIG_IWLWIFI=m
> CONFIG_IWLWIFI_DEBUG=n
> CONFIG_IWLWIFI_LEDS=y
>
> It seems CONFIG_IWL4965 is selected by default. Do you think there is
> a better selection than the default one? An unrelated question, is
> there a way to instruct make to build only the modules I want, i.e.,
> iwlagn?

yes and no... "y" sometimes means it assumes *your current kernel* has
it built-in (i.e. = "ignore this option").
A shame you aren't using the latest compat-wireless.

Well, if you want to skip some modules, you just put comment it out,
e.g. edit drivers/net/wireless/Makefile and put a "#" before any line
that doesn't contain obj-$(CONFIG_IWL*

>
> thanks again,
> rodrigo.
>
>
>
> On Wed, Jan 7, 2009 at 12:36 AM, Hin-Tak Leung <hintak.leung@gmail.com> wrote:
>> On Tue, Jan 6, 2009 at 11:12 AM, Rodrigo Fresneda <fresneda@gmail.com> wrote:
>>
>>> WARNING: "iwl4965_agn_cfg"
>>> [/home/fresneda/compat-wireless-2.6-old/drivers/net/wireless/iwlwifi/iwlagn.ko]
>>> undefined!
>>>
>>> The module is built, but it cannot be inserted:
>>>
>>> FATAL: Error inserting iwlagn
>>> (/lib/modules/2.6.26-1-amd64/updates/drivers/net/wireless/iwlwifi/iwlagn.ko):
>>> Unknown symbol in module, or unknown parameter (see
>>> dmesg)
>>>
>>> And the output of dmesg:
>>>
>>> iwlagn: Unknown symbol iwl4965_agn_cfg
>>
>>
>> symbol iwl4965_agn_cfg is enabled if you select "Intel Wireless WiFi
>> 4965AGN" support also.
>> config IWL4965 . Try selecting that when you build compat-wireless.old
>> . (seems that in some older version of
>> conpat-wireless, the 5000 code depends on the 4965 code).
>>
>> Also, make sure that you do "depmod -a"
>>
>
