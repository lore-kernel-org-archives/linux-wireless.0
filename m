Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from asmtpout025.mac.com ([17.148.16.100]:57067 "EHLO
	asmtpout025.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab0LWPe3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Dec 2010 10:34:29 -0500
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252
Received: from [192.168.1.30] ([87.201.169.175])
 by asmtp025.mac.com (Oracle Communications Messaging Exchange Server 7u4-20.01
 64bit (built Nov 21 2010)) with ESMTPSA id <0LDW002BV0KXHM80@asmtp025.mac.com>
 for linux-wireless@vger.kernel.org; Thu, 23 Dec 2010 07:34:13 -0800 (PST)
Subject: Re: Backporting wl1271 driver to kernel-2.6.32 using compat-wireless
From: Elvis Dowson <elvis.dowson@mac.com>
In-reply-to: <4D1266FA.7080305@hauke-m.de>
Date: Thu, 23 Dec 2010 19:33:54 +0400
Message-id: <326087F1-E68B-4C2F-BD3C-CF5CD222DA6F@mac.com>
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
 <A8ED3E8F-FA2A-46B9-95C6-F2C175581539@mac.com> <4D1266FA.7080305@hauke-m.de>
To: Linux Wireless Mailing List <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
       I think the .startup_delay field is missing in the fixed regulator for 2.6.32. 

I recall from the datasheets that during a reset, the WL_EN line should asserted
low for atleast 64 to 70ms before turning the power back on.

What do you think I should do?


/* Fixed voltage regulator for wlan module */
static struct fixed_voltage_config beagle_vwlan = {
	.supply_name		= "vwl1271",
	.microvolts		= 1850000, /* 1.8V */
	.gpio			= OMAP_BEAGLEBOARD20_WIFI_PMENA_GPIO,
	.startup_delay		= 70000, /* 70msec */
	.enable_high		= 1,
	.enabled_at_boot	= 0,
	.init_data		= &beagle_vmmc2,
};


  CC      arch/arm/mach-omap2/board-omap3beagle.o
arch/arm/mach-omap2/board-omap3beagle.c:409: error: unknown field ‘startup_delay’ specified in initializer
arch/arm/mach-omap2/board-omap3beagle.c:409: warning: large integer implicitly truncated to unsigned type
make[1]: *** [arch/arm/mach-omap2/board-omap3beagle.o] Error 1
make: *** [arch/arm/mach-omap2] Error 2

Elvis Dowson


