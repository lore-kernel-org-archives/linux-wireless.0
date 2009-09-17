Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx33.mail.ru ([94.100.176.47]:52100 "EHLO mx33.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754538AbZIQPWO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2009 11:22:14 -0400
Date: Thu, 17 Sep 2009 19:29:12 +0300
From: Nikolai ZHUBR <zhubr@mail.ru>
Message-ID: <2815684212.20090917192912@mail.ru>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless@vger.kernel.org,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Gaurav Jauhar <gaurav.jauhar@atheros.com>
Subject: Re[2]: 2.6.25 kernel & compat-wireless-2009-09-14
In-reply-To: <43e72e890909170557nf991a02n3e268f5c0e416fb0@mail.gmail.com>
References: <1214494232.20090917162242@mail.ru>
 <43e72e890909170557nf991a02n3e268f5c0e416fb0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thursday, September 17, 2009, 3:57:10 PM, Luis R. Rodriguez wrote:
> On Thu, Sep 17, 2009 at 6:22 AM, Nikolai ZHUBR <zhubr@mail.ru> wrote:
>> Hello people,
>>
>> So finally I got it mostly working and usable as AP:
>>
>> Hardware:
>> * ASUS WL-500gP (mips) with stock wireless card removed (broadcom).
>> * New shining Ralink RT2600 Mini-PCI card
>> Software:
>> * kernel 2.6.25.20 (openwrt 8.09.1)
>> * compat-wireless-2009-09-14 (without rfkill_backport and with ugly bus_id fix)
>> libnl-1.1
>> hostapd 0.6.9
>>
>> The led is now even blinking nicely.
>> Strange though that selecting static IP in the client didn't work,
>> but using DHCP works fine (it's ok for me now).

> That's great! Care to send some patches for this?
Well, it appears the only thing that really needs fixing is dev_set_name()
compatability function, but fixing it properly without making things worse
is a bit beyond my capability at this point. I think someone more familiar
with the code should have a look (a hint is below).
Regarding rfkill_backport, the issue is probably openwrt-specific, becase
there seems to be no way to load modules with circular dependencies without
modprobe (as far as I understand it). Commenting out CONFIG_RFKILL_BACKPORT
in config.mk "fixes" this and I think this issue can not be easily solved
inside compat-wireless package.

 Nikolai
 
--- everything.orig/net/wireless/core.c 2009-09-16 23:45:40.000000000 +0400
+++ everything/net/wireless/core.c      2009-09-16 23:48:22.000000000 +0400
@@ -350,6 +350,7 @@
 
        /* give it a proper name */
        dev_set_name(&rdev->wiphy.dev, PHY_NAME "%d", rdev->wiphy_idx);
+       snprintf(rdev->wiphy.dev.bus_id, BUS_ID_SIZE, PHY_NAME "%d", rdev->wiphy_idx);
 
        mutex_init(&rdev->mtx);
        mutex_init(&rdev->devlist_mtx);




>   Luis


