Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.214.180]:50852 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757832Ab0LMRi6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 12:38:58 -0500
Received: by iwn37 with SMTP id 37so9635081iwn.11
        for <linux-wireless@vger.kernel.org>; Mon, 13 Dec 2010 09:38:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTinak1g2w1WA44hDb5c=qaDu41SM=b5od-_+_iMu@mail.gmail.com>
References: <49CFD043.6020708@tls-tautenburg.de> <49CFDB1F.7040902@hauke-m.de>
 <43e72e890903301147hc09cec7rc8f214450a53efa7@mail.gmail.com>
 <4BA0FE74.4070906@tls-tautenburg.de> <43e72e891003170914u1b4e4cbdpca2522b5217c077b@mail.gmail.com>
 <4BA103DE.6010402@tls-tautenburg.de> <43e72e891003170932j7d675742x4bf350d3f5961c7a@mail.gmail.com>
 <4D04F420.9030802@tls-tautenburg.de> <AANLkTinak1g2w1WA44hDb5c=qaDu41SM=b5od-_+_iMu@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 13 Dec 2010 09:38:37 -0800
Message-ID: <AANLkTimCX1=LtFGnZ2cFOq=sRjxudM8ucD1gad2dFwVz@mail.gmail.com>
Subject: Re: iwlcore not in update
To: Bringfried Stecklum <stecklum@tls-tautenburg.de>
Cc: reinette chatre <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Including linux-wireless

On Mon, Dec 13, 2010 at 9:38 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Sun, Dec 12, 2010 at 8:11 AM, Bringfried Stecklum
> <stecklum@tls-tautenburg.de> wrote:
>> Dear Luis,
>>
>> I tried to install compat-wireless-2010-12-07 a few days ago but failed. The
>> reason is that iwlcore does not get build and installed in the update
>> modules folder which, of course, leads unresolved symbols
>>
>> stecklum@extragalactix:~/System/src/compat-wireless-2.6.37-rc5-2-s$ sudo
>> modprobe -v iwlagn
>> insmod /lib/modules/2.6.36-1-generic/updates/compat/compat.ko
>> insmod /lib/modules/2.6.36-1-generic/updates/net/wireless/cfg80211.ko
>> insmod /lib/modules/2.6.36-1-generic/updates/net/mac80211/mac80211.ko
>> insmod
>> /lib/modules/2.6.36-1-generic/kernel/drivers/net/wireless/iwlwifi/iwlcore.ko
>> WARNING: Error inserting iwlcore
>> (/lib/modules/2.6.36-1-generic/kernel/drivers/net/wireless/iwlwifi/iwlcore.ko):
>> Invalid argument
>> insmod
>> /lib/modules/2.6.36-1-generic/kernel/drivers/net/wireless/iwlwifi/iwlagn.ko
>> FATAL: Error inserting iwlagn
>> (/lib/modules/2.6.36-1-generic/kernel/drivers/net/wireless/iwlwifi/iwlagn.ko):
>> Unknown symbol in module, or unknown parameter (see
>>  dmesg)
>>
>> It seems I missed a change. In the past (e.g. compat-wireless-2010-05-22
>>  and kernel 2.6.31), iwlcore.ko was build and installed
>>
>> stecklum@extragalactix:~/System$ locate iwlcore.ko
>> /lib/modules/2.6.31-22-generic/kernel/drivers/net/wireless/iwlwifi/iwlcore.ko
>> /lib/modules/2.6.31-22-generic/updates/drivers/net/wireless/iwlwifi/iwlcore.ko
>> /lib/modules/2.6.36-1-generic/kernel/drivers/net/wireless/iwlwifi/iwlcore.ko
>
> Instead of CONFIG_IWLWIFI we use CONFIG_COMPAT_IWLWIFI, and we changed
> that the Makefile and config.mk
>
> mcgrof@tux ~/devel/compat-wireless-2.6 (git::linux-2.6.36.y)$ grep
> _IWLWIFI drivers/net/wireless/iwlwifi/Makefile
> obj-$(CONFIG_COMPAT_IWLWIFI)    += iwlcore.o
> iwlcore-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-debugfs.o
> iwlcore-$(CONFIG_IWLWIFI_DEVICE_TRACING) += iwl-devtrace.o
> iwlagn-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-agn-debugfs.o
> iwl3945-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-3945-debugfs.o
>
> mcgrof@tux ~/devel/compat-wireless-2.6 (git::linux-2.6.36.y)$ grep
> CONFIG_COMPAT_IWLWIFI config.mk
> CONFIG_COMPAT_IWLWIFI=m
>
> Can grep like this:
>
> mcgrof@tux ~/tmp/compat-wireless-2.6.37-rc5-4-sn $ grep
> CONFIG_COMPAT_IWLWIFI include/linux/compat_autoconf.h
> #ifndef CONFIG_COMPAT_IWLWIFI
> #define CONFIG_COMPAT_IWLWIFI 1
> #endif /* CONFIG_COMPAT_IWLWIFI *
>
>  Luis
>
