Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61937 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932327Ab0HaOzQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Aug 2010 10:55:16 -0400
Received: by pwi3 with SMTP id 3so388430pwi.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 Aug 2010 07:55:15 -0700 (PDT)
Message-ID: <4C7D17CF.6030501@gmail.com>
Date: Tue, 31 Aug 2010 09:55:11 -0500
From: =?UTF-8?B?Q2FybG9zIFNhbHZhZG9yIFDDqXJleiBTYWxnYWRv?=
	<carlosalvatore@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: compat-wireless-2.6.35-rc6 won't build
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/31/2010 03:01 AM, Luis R. Rodriguez wrote:
> 2010/8/31 Carlos Salvador Pérez Salgado<carlosalvatore@gmail.com>:
>> Greetings
>>
>> I hope you can point me into the right direction.
>>
>> I've already tried this patch
>> http://trac.pentoo.ch/browser/portage/trunk/net-wireless/compat-wireless/files/WEXT-EXT-nuts.patch 
>>
>>
>>
>> #make clean&&  ./scripts/driver-select atheros&&  make
>>
>> make[1]: Entering directory `/media/disk/temp/linux-2.6.35.4'
>> CLEAN /media/disk/temp/compat-wireless-2.6.35-rc6
>> CLEAN /media/disk/temp/compat-wireless-2.6.35-rc6/.tmp_versions
>> make[1]: Leaving directory `/media/disk/temp/linux-2.6.35.4'
>> Processing new driver-select request...
>> Backing up makefile: Makefile.bk
>> Backup exists: drivers/net/wireless/Makefile.bk
>> Backup exists: net/wireless/Makefile.bk
>> Backup exists: drivers/net/Makefile.bk
>> Backup exists: drivers/ssb/Makefile.bk
>> Backup exists: drivers/misc/eeprom/Makefile.bk
>> ./scripts/gen-compat-autoconf.sh config.mk>  
>> include/linux/compat_autoconf.h
>> make -C /lib/modules/2.6.35.4-k8/build
>> M=/media/disk/temp/compat-wireless-2.6.35-rc6 modules
>> make[1]: Entering directory `/media/disk/temp/linux-2.6.35.4'
>> LD /media/disk/temp/compat-wireless-2.6.35-rc6/compat/built-in.o
>> CC [M] /media/disk/temp/compat-wireless-2.6.35-rc6/compat/main.o
>>
>> ...
>>
>> CC [M] /media/disk/temp/compat-wireless-2.6.35-rc6/net/wireless/core.o
>> /media/disk/temp/compat-wireless-2.6.35-rc6/net/wireless/core.c: In 
>> function
>> ‘cfg80211_netdev_notifier_call’:
>> /media/disk/temp/compat-wireless-2.6.35-rc6/net/wireless/core.c:703: 
>> error:
>> ‘struct net_device’ has no member named ‘wireless_handlers’
>> /media/disk/temp/compat-wireless-2.6.35-rc6/net/wireless/core.c:704: 
>> error:
>> ‘struct net_device’ has no member named ‘wireless_handlers’
>> make[3]: ***
>> [/media/disk/temp/compat-wireless-2.6.35-rc6/net/wireless/core.o] 
>> Error 1
>> make[2]: *** [/media/disk/temp/compat-wireless-2.6.35-rc6/net/wireless]
>> Error 2
>> make[1]: *** [_module_/media/disk/temp/compat-wireless-2.6.35-rc6] 
>> Error 2
>> make[1]: Leaving directory `/media/disk/temp/linux-2.6.35.4'
>> make: *** [modules] Error 2
>>
>> Thanks.
>>
>> I'm using ubuntu lucid, custom kernel 2.6.35.4 in an AMD Turion X2 64 
>> bits.
>> Using CFLAGS="-march=k8 -msse3 -O3"
> Why are you building compat-wireless-2.6.35-rc6 when you already ahve
> 2.6.35.4? You realize this is 100% pointless, right?
>
>    Luis
>
Hi Luis.

Because atheros wireless card is not injecting packets using aircrack, 
and the power is lower comparing it with older kerneles. I use to 
install ath5k modules compiled from compat-wireless-2.6.32.11 when I was 
using linux-image-2.6.32-24-generic and that worked for me.
Do you have a better idea of how can I fix that? I'll really appreciate it.
Thanks.
