Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:62712 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab0GVGlM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 02:41:12 -0400
Subject: Re: wl1271 firmware
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Pazzo Da Legare <pazzodalegare@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Levi, Shahar" <shahar_levi@ti.com>,
	Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <AANLkTinnYeJPV-xxg7DdPXnWW_kD7X1TVcd9HrhupJWS@mail.gmail.com>
References: <4C37BCA0.5090607@deltatee.com>
	 <AC090B9732AB2B4DB7FF476E907FE660010685F34E@dnce02.ent.ti.com>
	 <AANLkTilHNKeRZX5CMplyriTo2hTPBrz_z1_Zpwoy3SZx@mail.gmail.com>
	 <AC090B9732AB2B4DB7FF476E907FE66001069662F2@dnce02.ent.ti.com>
	 <AC090B9732AB2B4DB7FF476E907FE6600106966BA5@dnce02.ent.ti.com>
	 <4C45ED36.2090604@deltatee.com>
	 <AANLkTinjvF9UeV7d2aBUy6HfexuAeL_cdsVPGVxSRVMp@mail.gmail.com>
	 <AANLkTinnYeJPV-xxg7DdPXnWW_kD7X1TVcd9HrhupJWS@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Jul 2010 09:40:48 +0300
Message-ID: <1279780848.2322.31.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Pazzo,


On Wed, 2010-07-21 at 19:27 +0200, ext Pazzo Da Legare wrote:
> Dear All again,
> 
> I've just test with compact-wireless-2010-07-20 but I've the same problem:
> 
> root@hawkboard:~# ifconfig wlan0 192.168.0.1 up
> [   68.920000] wl1271_sdio mmc0:0001:2: firmware: requesting wl1271-fw.bin
> [   69.100000] wl1271_sdio mmc0:0001:2: firmware: requesting wl1271-nvs.bin
> [   69.510000] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> root@hawkboard:~# [   70.020000] wl1271: ERROR ELP wakeup timeout!
> [   70.520000] wl1271: ERROR ELP wakeup timeout!
> 
> 
> looking at dmesg:
> 
> [  68.920000] wl1271_sdio mmc0:0001:2: firmware: requesting wl1271-fw.bin
> [   69.100000] wl1271_sdio mmc0:0001:2: firmware: requesting wl1271-nvs.bin
> [   69.500000] wl1271: firmware booted (Rev 6.1.0.0.310)
> [   69.510000] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [   70.020000] wl1271: ERROR ELP wakeup timeout!
> [   70.520000] wl1271: ERROR ELP wakeup timeout!
> 
> [   68.920000] wl1271_sdio mmc0:0001:2: firmware: requesting wl1271-fw.bin
> [   69.100000] wl1271_sdio mmc0:0001:2: firmware: requesting wl1271-nvs.bin
> [   69.500000] wl1271: firmware booted (Rev 6.1.0.0.310)
> [   70.020000] wl1271: ERROR ELP wakeup timeout!
> [   70.520000] wl1271: ERROR ELP wakeup timeout!
> 
> Do you have any clue?

I'm not sure what this is, but usually an ERROR ELP wakeup timeout means
that the firmware has crashed.

Could you enable the following DEBUG flags in wl1271.h and send the logs
again? Maybe they provide more clues...

#define DEBUG_LEVEL (DEBUG_BOOT | DEBUG_ACX | DEBUG_CMD | DEBUG_PSM | \
		     DEBUG_IRQ | DEBUG_EVENT)


-- 
Cheers,
Luca.

