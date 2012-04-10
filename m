Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:60014 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751864Ab2DJGYU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 02:24:20 -0400
Received: by lahl5 with SMTP id l5so8797478lah.1
        for <linux-wireless@vger.kernel.org>; Mon, 09 Apr 2012 23:24:17 -0700 (PDT)
Message-ID: <1334039054.27729.116.camel@cumari> (sfid-20120410_082424_288710_82DFBACE)
Subject: Re: wl1271 watchdog interrupt
From: Luciano Coelho <coelho@ti.com>
To: Gary Thomas <gary@mlbassoc.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 10 Apr 2012 09:24:14 +0300
In-Reply-To: <4F7C2E85.4050902@mlbassoc.com>
References: <4F6A7FD0.8090404@boundarydevices.com>
	   <4F71CDC7.2010207@mlbassoc.com> <1333355941.16990.23.camel@cumari>
	  <4F7BA34C.2030001@boundarydevices.com> <1333508285.24637.2.camel@cumari>
	 <4F7C2E85.4050902@mlbassoc.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-04-04 at 05:20 -0600, Gary Thomas wrote: 
> On 2012-04-03 20:58, Luciano Coelho wrote:
> > On Tue, 2012-04-03 at 18:26 -0700, Troy Kisky wrote:
> >> On 4/2/2012 1:39 AM, Luciano Coelho wrote:

[...]

> > Cool!
> >
> > Now, Gary, do you still have the same (or a similar) problem with your
> > setup?
> >
> 
> Yes, I still have issues.  One problem is that the wlan interface will
> not come up unless I manually perform a scan.  If I just do this to
> bring it up (my AP uses WPA2)

This is pretty weird.  Something to do with the interrupts, apparently.


> # ifconfig wlan0 hw ether D4:94:A1:8E:1E:17
> # ifconfig wlan0 up
> ADDRCONF(NETDEV_UP): wlan0: link is not ready
> # ifup wlan0
> udhcpc (v1.19.3) started
> Sending discover...
> Read error: Network is down, reopening socket
> wl1271: ERROR timeout waiting for the hardware to complete initialization
> Sending discover...
> udhcpc: sendto: Network is down
> Read error: Network is down, reopening socket
> Sending discover...
> udhcpc: sendto: Network is down
> Read error: Network is down, reopening socket
> No lease, failing
> root@cobra8148p81:~# wl1271: ERROR sdio read failed (-110)
> wl1271: ERROR sdio write failed (-110)
> wl1271: ERROR sdio read failed (-110)
> wl1271: ERROR chip id doesn't match after firmware boot
> wl1271: ERROR firmware boot failed despite 3 retries

Hard to tell what's happening here.  What do you have in
your /etc/network/interfaces file?


> However, if I bring it up with this sequence, it works:
> 
> # ifconfig wlan0 hw ether D4:94:A1:8E:1E:17
> # ifconfig wlan0 up
> ADDRCONF(NETDEV_UP): wlan0: link is not ready
> # iw wlan0 scan
>    ... many AP shown
> # ifup wlan0
> udhcpc (v1.19.3) started
> Sending discover...
> ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> Sending discover...
> Sending select for 192.168.12.184...
> Lease of 192.168.12.184 obtained, lease time 600
> adding dns 192.168.12.1

Pretty weird.  Somehow triggering the scan is making things go more
smoothly.  When booting the chip, we don't really wait for an interrupt,
but poll the chip for completion.

[...]

> However, if I ever shut down the wlan0, it hangs up and the only
> way to get it back is to reboot.
> 
> # ifdown wlan0
> cfg80211: Calling CRDA to update world regulatory domain
> # ifup wlan0
> wl1271: ERROR timeout waiting for the hardware to complete initialization
> wl1271: ERROR timeout waiting for the hardware to complete initialization
> wl1271: ERROR sdio read failed (-110)

This looks like your MMC setup is not able to power on and off
correctly.  Are you sure you have all the settings necessary in your
board file? Especially the clock frequencies and the caps flag in the
hsmmc_info configuration?

Make sure you have MMC_CAP_POWER_OFF_CARD in the .caps field of your mmc
info struct.


> # dmesg | tail -n2wl1271: ERROR sdio read failed (-110)
> wl1271: ERROR chip id doesn't match after firmware boot
> wl1271: ERROR firmware boot failed despite 3 retries
> 0
> ieee80211 phy0: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7 cWmax=15 txop=94 uapsd=1
> ieee80211 phy0: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3 cWmax=7 txop=47 uapsd=1
> ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> wl1271: Association completed.
> wlan0: no IPv6 routers present
> wlan0: deauthenticating from 00:24:b2:49:ef:12 by local choice (reason=3)
> ieee80211 phy0: Removed STA 00:24:b2:49:ef:12
> ieee80211 phy0: Destroyed STA 00:24:b2:49:ef:12
> ieee80211 phy0: device now idle
> cfg80211: All devices are disconnected, going to restore regulatory settings
> cfg80211: Restoring regulatory settings
> cfg80211: Calling CRDA to update world regulatory domain
> wl1271: down
> wl1271: ERROR timeout waiting for the hardware to complete initialization
> wl1271: ERROR timeout waiting for the hardware to complete initialization
> wl1271: ERROR sdio read failed (-110)
> wl1271: ERROR sdio write failed (-110)
> wl1271: ERROR sdio read failed (-110)
> wl1271: ERROR chip id doesn't match after firmware boot
> wl1271: ERROR firmware boot failed despite 3 retries
> 
> I'm using the 2012-02-28 snapshot of compat-wireless, my kernel is 2.6.37
> 
> Ideas?

I'm running out of ideas.  And 2.6.37 is quite ancient, but AFAIK it
should work as it is the first version that supports powering the MMC
card on and off.  Any chance you could try a newer kernel? Just to find
out it everything is working fine with newer kernels.  If it works, then
we should focus on why 2.6.37 doesn't work.  Maybe we will have to
cherry-pick some patches for the MMC subsystem.

-- 
Cheers,
Luca.

