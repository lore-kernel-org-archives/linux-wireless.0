Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:46828 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213Ab0LVVAy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 16:00:54 -0500
Message-ID: <4D1266FA.7080305@hauke-m.de>
Date: Wed, 22 Dec 2010 22:00:42 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Elvis Dowson <elvis.dowson@mac.com>
CC: Linux Wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: Re: Backporting wl1271 driver to kernel-2.6.32 using compat-wireless
References: <1CA1EE34-CB3D-404D-ADEE-612C8783BFCF@mac.com> <AANLkTin8RZwVrWAdNn_Q+_bX8BAHgKreyHiVjznZtMxU@mail.gmail.com> <1A56906E-D786-45E6-9C77-C9D600B508B0@mac.com> <AANLkTikhLKuw56BhDkBUMU-nf8ZYF1v5Berj-+qupAtO@mail.gmail.com> <E90F18E9-6332-4A7C-97DA-01169E5BB5E1@mac.com> <AANLkTik6m0rabY3ZCseoch7fwxhMksMD83A-ygtN4cVu@mail.gmail.com> <F4DFEC94-D5AC-4C12-890D-8F242E757071@mac.com> <AANLkTi=owvDyO3qfahUwRv4MxJrvMK9hjh5NOwRHQuO+@mail.gmail.com> <7F14B85B-566C-45A9-BF8B-FE9DED7944D0@mac.com> <AANLkTik7jvW9pA3deanBRXxJh6tLeO7WQgqrkN3xa9LG@mail.gmail.com> <4D122B8F.5090302@hauke-m.de> <1813D0B1-5391-48DB-9882-A6586DAB180C@mac.com> <AANLkTimMWH63yG2tdu7OHemHs=6OOy_i5fpeEDhhh6O9@mail.gmail.com> <4D123FBB.1050801@hauke-m.de> <C7700580-CCBB-498D-9EA5-73E2BF748C68@mac.com> <A7C7741B-634A-4C4B-A6F1-EBEA5F2EEED5@mac.com> <4D125B9F.7090503@hauke-m.de> <A8ED3E8F-FA2A-46B9-95C6-F2C175581539@mac.com>
In-Reply-To: <A8ED3E8F-FA2A-46B9-95C6-F2C175581539@mac.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/22/2010 09:34 PM, Elvis Dowson wrote:
> 
> On Dec 23, 2010, at 12:12 AM, Hauke Mehrtens wrote:
> 
>> Is CONFIG_CRC7=y set in your kernel config, the wl12xx module needs
>> this? If it is not set the module will not be build.
> 
> It wasn't :-). After enabling it in the kernel and recompiling both the kernel and 
> compat-wireless wl12xx, it generated the following modules:
> 
> cfg80211.ko
> compat.ko
> compat_firmware_class.ko
> mac80211.ko
> wl1251.ko
> wl1251_sdio.ko
> wl1251_spi.ko
> wl1271.ko
> wl1271_spi.ko
> 
> I haven't applied the SDIO runtime PM patches yet. 
> 
> http://www.spinics.net/lists/linux-mmc/msg03966.html
> 
> So, is a wl1271_sdio.ko also supposed to be generated, but didn't because I didn't add the SDIO pm patches?
> 
> To use this at run-time on the target, should I do insmod for multiple modules:
> 
> insmod cfg80211.ko
> insmod compat.ko
> insmod compat_firmware_class.ko
> insmod mac80211.ko
> insmod wl1271.ko
> 
> 
> Elvis Dowson

Compat-wireless does not check what patches you applied to your kernel
yet, it just checks what kernel version you are using and want patches
are applied to it in the vanilla version. If you add some patches
yourself to the kernel to backport some stuff you have to manually edit
compat-wireless's config.mk file.

You also have to backport the CONFIG_WL12XX_PLATFORM_DATA and activate
it in your kernel config, wl1271_sdio depends on that.

Probably you have to change some other stuff on your architecture code
so that your device finds this sdio card, but I do not know what you
have to do exactly.

Hauke
