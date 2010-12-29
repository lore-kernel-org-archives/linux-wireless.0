Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:45000 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab0L2VJH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Dec 2010 16:09:07 -0500
Received: by ewy5 with SMTP id 5so4881100ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Dec 2010 13:09:06 -0800 (PST)
Date: Thu, 30 Dec 2010 00:07:37 +0300
From: Sergey Matyukevich <geomatsi@gmail.com>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: linux-wireless@vger.kernel.org
Subject: wl1271: how to use without runtime pm
Message-ID: <20101230000737.74d30852@lair>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Luciano,

I use omap3evm board with wl1271 extension module. Current version of
wl1271 driver works fine on upstream kernel and (with minor
modifications resulting from older mac80211) on 2.6.32 kernel with
integrated SDIO runtime PM patches from Ohad Ben-Cohen.

In the current kernel runtime PM support is always enabled for
omap2plus boards. However this is not the case for the earlier kernels.
Besides, on some other boards there might be no gpio pin to control
power supply of wl1271 card.

So the question is: what is the proper use of wl1271 driver in the case
when  wl1271 card is powered all the time ?

In a simple experiment I removed all pm_runtime functions from
wl1271_sdio.c and removed MMC_CAP_POWER_OFF_CARD flag from mmc slot
settings in board file. However I can't do ifdown/ifup procedure
properly:

root@omap3evm_minimal:~# ifconfig wlan0 down
root@omap3evm_minimal:~# ifconfig wlan0 up
[   55.313201] wl1271: ERROR timeout waiting for the hardware to
complete initialization
[   58.813964] wl1271: ERROR timeout waiting for the hardware to
complete initialization
[   60.648651] wl1271: ERROR sdio read failed (-110)
[   60.653686] wl1271: ERROR sdio write failed (-110)
[   62.057067] wl1271: ERROR sdio read failed (-110)
[   62.062072] wl1271: ERROR chip id doesn't match after firmware boot
[   62.068786] wl1271: ERROR firmware boot failed despite 3 retries
	ifconfig: SIOCSIFFLAGS: Input/output error
 
It looks like init procedure of wl1271 card can not be done twice
without powering off wl1271 card. 


Thanks,
Sergey
