Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.248]:34142 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758695AbZAHPaw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 10:30:52 -0500
Received: by an-out-0708.google.com with SMTP id d40so2895329and.1
        for <linux-wireless@vger.kernel.org>; Thu, 08 Jan 2009 07:30:50 -0800 (PST)
Message-ID: <e6236e5f0901080730h49450037i862625f20e003897@mail.gmail.com> (sfid-20090108_163058_544397_94A056C0)
Date: Thu, 8 Jan 2009 16:30:50 +0100
From: "Rodrigo Fresneda" <fresneda@gmail.com>
To: "Hin-Tak Leung" <hintak.leung@gmail.com>
Subject: Re: trouble with compat-old
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <3ace41890901070440w63fbb06fy39e3bcb387f08d60@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <e6236e5f0901060312h6946f9a1p49e299e723cb0190@mail.gmail.com>
	 <3ace41890901061536k7722b63h906962283ce9e4ad@mail.gmail.com>
	 <e6236e5f0901061740s20d817b1s2befb66cefbf72b0@mail.gmail.com>
	 <3ace41890901070440w63fbb06fy39e3bcb387f08d60@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, I wanted to thank you for trying to help me, and to let you know
that I have given up compiling compat-wireless-old and have moved on
to kernel 2.6.28, with which my
wifi device works perfectly. It turns out that the amount of work I
had to do to get my wifi on was a lot more that to fix my device
issues with the latest kernel, so it simply wasn't worth it anymore.
I was especially appalled to learn that the iwl drivers were broken in
compat-wireless-old after 09/09/2008 and it has remained this way.
rodrigo.

On Wed, Jan 7, 2009 at 1:40 PM, Hin-Tak Leung <hintak.leung@gmail.com> wrote:
> On Wed, Jan 7, 2009 at 1:40 AM, Rodrigo Fresneda <fresneda@gmail.com> wrote:
>> Thanks for your answer. Now, what exactly am I supposed to do? Take a
>> look at the IWL section in config.mk:
>
> That's a bit wrong... how about try changing the 4965 "y" to "m"?
>
>>
>> CONFIG_IWL3945=m
>> CONFIG_IWL3945_DEBUG=n
>> CONFIG_IWL3945_LEDS=y
>> # CONFIG_IWL3945_RFKILL=y
>> CONFIG_IWL3945_SPECTRUM_MEASUREMENT=y
>> CONFIG_IWL4965=y
>> CONFIG_IWL5000=y
>> CONFIG_IWLAGN=m
>> CONFIG_IWLAGN_LEDS=y
>> CONFIG_IWLAGN_SPECTRUM_MEASUREMENT=y
>> CONFIG_IWLCORE=m
>> CONFIG_IWLWIFI=m
>> CONFIG_IWLWIFI_DEBUG=n
>> CONFIG_IWLWIFI_LEDS=y
>>
>> It seems CONFIG_IWL4965 is selected by default. Do you think there is
>> a better selection than the default one? An unrelated question, is
>> there a way to instruct make to build only the modules I want, i.e.,
>> iwlagn?
>
> yes and no... "y" sometimes means it assumes *your current kernel* has
> it built-in (i.e. = "ignore this option").
> A shame you aren't using the latest compat-wireless.
>
> Well, if you want to skip some modules, you just put comment it out,
> e.g. edit drivers/net/wireless/Makefile and put a "#" before any line
> that doesn't contain obj-$(CONFIG_IWL*
>
>>
>> thanks again,
>> rodrigo.
>>
>>
>>
>> On Wed, Jan 7, 2009 at 12:36 AM, Hin-Tak Leung <hintak.leung@gmail.com> wrote:
>>> On Tue, Jan 6, 2009 at 11:12 AM, Rodrigo Fresneda <fresneda@gmail.com> wrote:
>>>
>>>> WARNING: "iwl4965_agn_cfg"
>>>> [/home/fresneda/compat-wireless-2.6-old/drivers/net/wireless/iwlwifi/iwlagn.ko]
>>>> undefined!
>>>>
>>>> The module is built, but it cannot be inserted:
>>>>
>>>> FATAL: Error inserting iwlagn
>>>> (/lib/modules/2.6.26-1-amd64/updates/drivers/net/wireless/iwlwifi/iwlagn.ko):
>>>> Unknown symbol in module, or unknown parameter (see
>>>> dmesg)
>>>>
>>>> And the output of dmesg:
>>>>
>>>> iwlagn: Unknown symbol iwl4965_agn_cfg
>>>
>>>
>>> symbol iwl4965_agn_cfg is enabled if you select "Intel Wireless WiFi
>>> 4965AGN" support also.
>>> config IWL4965 . Try selecting that when you build compat-wireless.old
>>> . (seems that in some older version of
>>> conpat-wireless, the 5000 code depends on the 4965 code).
>>>
>>> Also, make sure that you do "depmod -a"
>>>
>>
>
