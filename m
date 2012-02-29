Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:48533 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab2B2USN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 15:18:13 -0500
Message-ID: <4F4E8802.8090903@mlbassoc.com> (sfid-20120229_211815_484122_5B89574A)
Date: Wed, 29 Feb 2012 13:18:10 -0700
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: Thomas Pedersen <thomas@cozybit.com>
CC: Linux Wireless <linux-wireless@vger.kernel.org>,
	Luciano Coelho <coelho@ti.com>
Subject: Re: Help building compat-wireless
References: <4F4E47BC.8000306@mlbassoc.com> <4F4E731B.7080704@mlbassoc.com> <4F4E801A.1090701@mlbassoc.com> <CAG6hwVOgFuQ8XSGvYjM7aSiWe2O2T_UdVVWz+pyEHROEfqNE-g@mail.gmail.com>
In-Reply-To: <CAG6hwVOgFuQ8XSGvYjM7aSiWe2O2T_UdVVWz+pyEHROEfqNE-g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-02-29 12:59, Thomas Pedersen wrote:
> Hi Gary,
>
> On Wed, Feb 29, 2012 at 11:44 AM, Gary Thomas<gary@mlbassoc.com>  wrote:
>> On 2012-02-29 11:48, Gary Thomas wrote:
>>>
>>> On 2012-02-29 08:43, Gary Thomas wrote:
>>>>
>>>> I'm struggling a bit to build compat-wireless in a cross-build
>>>> environment.
>>>> I normally don't build kernels in-tree, rather I use a build tree, e.g.
>>>> % cd<linux-source>
>>>> % mkdir /tmp/kernel_build
>>>> % make O=/tmp/kernel_build<some_config>
>>>> % make O=/tmp/kernel_build uImage
>>>>
>>>> I can't see how to use this setup with the compat-wireless package.
>>>> I tried [all the combinations I could think of] something like this:
>>>> % cd<compat-wireless>
>>>> % make KLIB=<linux-source>  KLIB_BUILD=/tmp/kernel_build
>>>> However, this seems to not work as all I get are errors like this:
>>>> /local/compat-wireless-2012-02-28/config.mk:242: "WARNING:
>>>> CONFIG_CFG80211_WEXT will be deactivated or not working because kernel was
>>>> compiled with CONFIG_WIRELESS_EXT=n. Tools
>>>> using wext interface like iwconfig will not work. To activate it build
>>>> your kernel e.g. with CONFIG_LIBIPW=m."
>>>>
>>>> Does this process work in my workflow? What do I need to do to
>>>> get it going?
>>>
>>>
>>> I managed to get past this, using this
>>> % make KLIB=/tmp/kernel_build KLIB_BUILD=/tmp/kernel_build
>>> but to get it to actually build anything, I had to append the
>>> 'modules' target, e.g.
>>> % make KLIB=/tmp/kernel_build KLIB_BUILD=/tmp/kernel_build modules
>>>
>>> Next problems:
>>> * How do I select sub-options? I only want WL12xx support with SDIO, but
>>> that requires some sub-options to be set that don't appear to happen.
>>> I get the main wl12xx module, but not wl12xx_sdio or wl12xx_platform_data
>>> * There are a number of files which don't build against my 2.6.37 kernel,
>>> but none of these are important to me (they are in the bluetooth driver
>>> which I don't need, but nonetheless it gets built)
>>> * The make/install is terribly broken for cross-builds.
>>>
>>> I hacked my way past these problems and finally got some modules which
>>> I can try. Sadly, they don't work at all:
>>> # modprobe wl12xx_sdio
>>> wl12xx: loaded
>>> # ifconfig wlan0 up
>>> wl1271_sdio mmc1:0001:2: sdio write failed (-110)
>>> wl1271_sdio mmc1:0001:2: sdio write failed (-110)
>>> ...
>>
>>
>> Sadly, this one was my fault - one of my build hacks got in the way :-(
>>
>> Now, I'm getting this error:
>>   wl12xx: ERROR could not get firmware ti-connectivity/wl127x-fw-4-sr.bin: -2
>> But this file is not available at the Linux firmware tree
>> (git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git)
>>
>> Where can I find it?
>>
>
> Try here:  git://github.com/TI-OpenLink/firmwares.git

Thanks.  Do you know if these will be moving to kernel.org anytime soon?
My build recipes expect that to be the official home for firmware.

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
