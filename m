Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.248]:4926 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681AbZAGBkG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 20:40:06 -0500
Received: by an-out-0708.google.com with SMTP id d40so2636018and.1
        for <linux-wireless@vger.kernel.org>; Tue, 06 Jan 2009 17:40:05 -0800 (PST)
Message-ID: <e6236e5f0901061740s20d817b1s2befb66cefbf72b0@mail.gmail.com> (sfid-20090107_024012_645378_CAD0DD81)
Date: Wed, 7 Jan 2009 02:40:05 +0100
From: "Rodrigo Fresneda" <fresneda@gmail.com>
To: "Hin-Tak Leung" <hintak.leung@gmail.com>
Subject: Re: trouble with compat-old
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <3ace41890901061536k7722b63h906962283ce9e4ad@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <e6236e5f0901060312h6946f9a1p49e299e723cb0190@mail.gmail.com>
	 <3ace41890901061536k7722b63h906962283ce9e4ad@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for your answer. Now, what exactly am I supposed to do? Take a
look at the IWL section in config.mk:

CONFIG_IWL3945=m
CONFIG_IWL3945_DEBUG=n
CONFIG_IWL3945_LEDS=y
# CONFIG_IWL3945_RFKILL=y
CONFIG_IWL3945_SPECTRUM_MEASUREMENT=y
CONFIG_IWL4965=y
CONFIG_IWL5000=y
CONFIG_IWLAGN=m
CONFIG_IWLAGN_LEDS=y
CONFIG_IWLAGN_SPECTRUM_MEASUREMENT=y
CONFIG_IWLCORE=m
CONFIG_IWLWIFI=m
CONFIG_IWLWIFI_DEBUG=n
CONFIG_IWLWIFI_LEDS=y

It seems CONFIG_IWL4965 is selected by default. Do you think there is
a better selection than the default one? An unrelated question, is
there a way to instruct make to build only the modules I want, i.e.,
iwlagn?

thanks again,
rodrigo.



On Wed, Jan 7, 2009 at 12:36 AM, Hin-Tak Leung <hintak.leung@gmail.com> wrote:
> On Tue, Jan 6, 2009 at 11:12 AM, Rodrigo Fresneda <fresneda@gmail.com> wrote:
>
>> WARNING: "iwl4965_agn_cfg"
>> [/home/fresneda/compat-wireless-2.6-old/drivers/net/wireless/iwlwifi/iwlagn.ko]
>> undefined!
>>
>> The module is built, but it cannot be inserted:
>>
>> FATAL: Error inserting iwlagn
>> (/lib/modules/2.6.26-1-amd64/updates/drivers/net/wireless/iwlwifi/iwlagn.ko):
>> Unknown symbol in module, or unknown parameter (see
>> dmesg)
>>
>> And the output of dmesg:
>>
>> iwlagn: Unknown symbol iwl4965_agn_cfg
>
>
> symbol iwl4965_agn_cfg is enabled if you select "Intel Wireless WiFi
> 4965AGN" support also.
> config IWL4965 . Try selecting that when you build compat-wireless.old
> . (seems that in some older version of
> conpat-wireless, the 5000 code depends on the 4965 code).
>
> Also, make sure that you do "depmod -a"
>
