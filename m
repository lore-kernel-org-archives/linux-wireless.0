Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:48174 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752458Ab2DEHBG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Apr 2012 03:01:06 -0400
Received: by bkuw11 with SMTP id w11so1178247bku.23
        for <linux-wireless@vger.kernel.org>; Thu, 05 Apr 2012 00:01:03 -0700 (PDT)
Message-ID: <1333609261.27729.80.camel@cumari> (sfid-20120405_090109_689409_D4D7B7C6)
Subject: Re: Issue with Compat Wireless-2012-04-03 with Wireless operations
From: Luciano Coelho <coelho@ti.com>
To: Girish B N <bngirish1@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 05 Apr 2012 10:01:01 +0300
In-Reply-To: <CACAxKDr11ySDxbggg1Zc2cZa7QCGk8Rb=WoPdSuOZX-08fTVhw@mail.gmail.com>
References: <CACAxKDr11ySDxbggg1Zc2cZa7QCGk8Rb=WoPdSuOZX-08fTVhw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Girish,

On Wed, 2012-04-04 at 21:21 +0530, Girish B N wrote: 
> With latest Compat wireless package (2012-04-03) and firmware ver (04
> - wl127x-fw-4-sr.bin and wl127x-fw-4-plt.bin, ) I am able to
> successfully calibrate and nvs file sucessfully.
> However, I am not able to connect to any device. there is crash in the
> modules. However I am able to do the scan operation successfully.
> There is crash after running the following commands
> >ifconfig wlan0 down
> >ifconfig wlan0 hw ether de:ad:be:ef:c0:fe
> >iwconfig wlan0 mode ad-hoc
> >iwconfig wlan0 essid brady123
> >ifconfig wlan0 192.168.1.6 up

Can you try to redo this with iw instead of iwconfig? Try this:

ifconfig wlan0 down
ifconfig wlan0 hw ether de:ad:be:ef:c0:fe
iw wlan0 set type ibss
ifconfig wlan0 up
iw wlan0 ibss join brady123

iwconfig is obsolete and if you use it, there is some wrapper code and
other things happening, so it's more difficult to follow.  It should
still work, of course, but if you use iw, I'll be able to help you more
easily.


> Please find the log below
> 
> Let us know the right version of the firmware and any patches to be
> applied for Compat Wireless package to be able to use for both
> calibration and successful wireless operation

[...]

> Powering on wl12xx<6>Compat-wireless backport release:
> compat-wireless-2012-04-02-2-1-g5c6c8e6
> Backport based on linux-next.git next-20120403
> cfg80211: Calling CRDA to update world regulatory domain
> wl1271_probe: the value of func->num = 0x2
> wl12xx: loaded
> wl12xx: firmware booted (Rev 6.3.5.0.98)

This seems to be the correct version to use with the latest upstream
code.


> wlan0: Creating new IBSS network, BSSID c1edff10
> wl12xx: ERROR command complete timeout
> ------------[ cut here ]------------
> WARNING: at /home/bps/compat-wireless-2012-04-03/drivers/net/wireless/wl12xx/cmd.c:108
> wl1271_cmd_send+0x340/0x374 [wl12xx]()

[...]

> wl12xx: ERROR failed to initiate cmd role enable
> wl12xx: WARNING cmd join failed -110
> wl12xx: ERROR command complete timeout
> ------------[ cut here ]------------

For some reason the firmware is not able to start the IBSS role.

Could you try this again with the iw commands I mentioned above and
enable debugging on the wl12xx module with debug_level 0x13800?

-- 
Cheers,
Luca.

