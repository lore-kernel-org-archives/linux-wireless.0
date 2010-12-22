Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from asmtpout023.mac.com ([17.148.16.98]:40455 "EHLO
	asmtpout023.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab0LVUet (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 15:34:49 -0500
MIME-version: 1.0
Content-type: text/plain; CHARSET=US-ASCII
Received: from [192.168.1.30] ([87.201.169.175])
 by asmtp023.mac.com (Oracle Communications Messaging Exchange Server 7u4-20.01
 64bit (built Nov 21 2010)) with ESMTPSA id <0LDU001YLJTXBQ10@asmtp023.mac.com>
 for linux-wireless@vger.kernel.org; Wed, 22 Dec 2010 12:34:49 -0800 (PST)
Subject: Re: Backporting wl1271 driver to kernel-2.6.32 using compat-wireless
From: Elvis Dowson <elvis.dowson@mac.com>
In-reply-to: <4D125B9F.7090503@hauke-m.de>
Date: Thu, 23 Dec 2010 00:34:32 +0400
Cc: Linux Wireless Mailing List <linux-wireless@vger.kernel.org>
Message-id: <A8ED3E8F-FA2A-46B9-95C6-F2C175581539@mac.com>
References: <1CA1EE34-CB3D-404D-ADEE-612C8783BFCF@mac.com>
 <AANLkTin8RZwVrWAdNn_Q+_bX8BAHgKreyHiVjznZtMxU@mail.gmail.com>
 <1A56906E-D786-45E6-9C77-C9D600B508B0@mac.com>
 <AANLkTikhLKuw56BhDkBUMU-nf8ZYF1v5Berj-+qupAtO@mail.gmail.com>
 <E90F18E9-6332-4A7C-97DA-01169E5BB5E1@mac.com>
 <AANLkTik6m0rabY3ZCseoch7fwxhMksMD83A-ygtN4cVu@mail.gmail.com>
 <F4DFEC94-D5AC-4C12-890D-8F242E757071@mac.com>
 <AANLkTi=owvDyO3qfahUwRv4MxJrvMK9hjh5NOwRHQuO+@mail.gmail.com>
 <7F14B85B-566C-45A9-BF8B-FE9DED7944D0@mac.com>
 <AANLkTik7jvW9pA3deanBRXxJh6tLeO7WQgqrkN3xa9LG@mail.gmail.com>
 <4D122B8F.5090302@hauke-m.de> <1813D0B1-5391-48DB-9882-A6586DAB180C@mac.com>
 <AANLkTimMWH63yG2tdu7OHemHs=6OOy_i5fpeEDhhh6O9@mail.gmail.com>
 <4D123FBB.1050801@hauke-m.de> <C7700580-CCBB-498D-9EA5-73E2BF748C68@mac.com>
 <A7C7741B-634A-4C4B-A6F1-EBEA5F2EEED5@mac.com> <4D125B9F.7090503@hauke-m.de>
To: Hauke Mehrtens <hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Dec 23, 2010, at 12:12 AM, Hauke Mehrtens wrote:

> Is CONFIG_CRC7=y set in your kernel config, the wl12xx module needs
> this? If it is not set the module will not be build.

It wasn't :-). After enabling it in the kernel and recompiling both the kernel and 
compat-wireless wl12xx, it generated the following modules:

cfg80211.ko
compat.ko
compat_firmware_class.ko
mac80211.ko
wl1251.ko
wl1251_sdio.ko
wl1251_spi.ko
wl1271.ko
wl1271_spi.ko

I haven't applied the SDIO runtime PM patches yet. 

http://www.spinics.net/lists/linux-mmc/msg03966.html

So, is a wl1271_sdio.ko also supposed to be generated, but didn't because I didn't add the SDIO pm patches?

To use this at run-time on the target, should I do insmod for multiple modules:

insmod cfg80211.ko
insmod compat.ko
insmod compat_firmware_class.ko
insmod mac80211.ko
insmod wl1271.ko


Elvis Dowson
