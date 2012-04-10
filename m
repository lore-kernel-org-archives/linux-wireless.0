Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:38789 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689Ab2DJMFM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 08:05:12 -0400
Message-ID: <4F8421F6.2060004@mlbassoc.com> (sfid-20120410_140518_516391_5502543F)
Date: Tue, 10 Apr 2012 06:05:10 -0600
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: wl1271 watchdog interrupt
References: <4F6A7FD0.8090404@boundarydevices.com>    <4F71CDC7.2010207@mlbassoc.com> <1333355941.16990.23.camel@cumari>   <4F7BA34C.2030001@boundarydevices.com> <1333508285.24637.2.camel@cumari>  <4F7C2E85.4050902@mlbassoc.com> <1334039054.27729.116.camel@cumari>
In-Reply-To: <1334039054.27729.116.camel@cumari>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-04-10 00:24, Luciano Coelho wrote:
> On Wed, 2012-04-04 at 05:20 -0600, Gary Thomas wrote:
>> On 2012-04-03 20:58, Luciano Coelho wrote:
>>> On Tue, 2012-04-03 at 18:26 -0700, Troy Kisky wrote:
>>>> On 4/2/2012 1:39 AM, Luciano Coelho wrote:
>
> [...]
>
>>> Cool!
>>>
>>> Now, Gary, do you still have the same (or a similar) problem with your
>>> setup?
>>>
>>
>> Yes, I still have issues.  One problem is that the wlan interface will
>> not come up unless I manually perform a scan.  If I just do this to
>> bring it up (my AP uses WPA2)
>
> This is pretty weird.  Something to do with the interrupts, apparently.
>
>
>> # ifconfig wlan0 hw ether D4:94:A1:8E:1E:17
>> # ifconfig wlan0 up
>> ADDRCONF(NETDEV_UP): wlan0: link is not ready
>> # ifup wlan0
>> udhcpc (v1.19.3) started
>> Sending discover...
>> Read error: Network is down, reopening socket
>> wl1271: ERROR timeout waiting for the hardware to complete initialization
>> Sending discover...
>> udhcpc: sendto: Network is down
>> Read error: Network is down, reopening socket
>> Sending discover...
>> udhcpc: sendto: Network is down
>> Read error: Network is down, reopening socket
>> No lease, failing
>> root@cobra8148p81:~# wl1271: ERROR sdio read failed (-110)
>> wl1271: ERROR sdio write failed (-110)
>> wl1271: ERROR sdio read failed (-110)
>> wl1271: ERROR chip id doesn't match after firmware boot
>> wl1271: ERROR firmware boot failed despite 3 retries
>
> Hard to tell what's happening here.  What do you have in
> your /etc/network/interfaces file?

Here are the relevant parts.

=================== /etc/network/interfaces (partial) ======================
# Wireless interfaces
iface wlan0 inet dhcp
         wireless_mode managed
         wireless_essid any
         wpa-driver wext
         wpa-conf /etc/wpa_supplicant.conf
============================================================================

================== /etc/wpa_supplicant.conf (partial) ======================
network={
     ssid="LeManegeEnchante"
     scan_ssid=1
     key_mgmt=WPA-PSK
     psk="SOMEPASSWORD"
   }
============================================================================

>
>> However, if I bring it up with this sequence, it works:
>>
>> # ifconfig wlan0 hw ether D4:94:A1:8E:1E:17
>> # ifconfig wlan0 up
>> ADDRCONF(NETDEV_UP): wlan0: link is not ready
>> # iw wlan0 scan
>>     ... many AP shown
>> # ifup wlan0
>> udhcpc (v1.19.3) started
>> Sending discover...
>> ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
>> Sending discover...
>> Sending select for 192.168.12.184...
>> Lease of 192.168.12.184 obtained, lease time 600
>> adding dns 192.168.12.1
>
> Pretty weird.  Somehow triggering the scan is making things go more
> smoothly.  When booting the chip, we don't really wait for an interrupt,
> but poll the chip for completion.

Perhaps there's a stray interrupt laying around which the scan path handles
better than the other way.  I'll look into this.

> [...]
>
>> However, if I ever shut down the wlan0, it hangs up and the only
>> way to get it back is to reboot.
>>
>> # ifdown wlan0
>> cfg80211: Calling CRDA to update world regulatory domain
>> # ifup wlan0
>> wl1271: ERROR timeout waiting for the hardware to complete initialization
>> wl1271: ERROR timeout waiting for the hardware to complete initialization
>> wl1271: ERROR sdio read failed (-110)
>
> This looks like your MMC setup is not able to power on and off
> correctly.  Are you sure you have all the settings necessary in your
> board file? Especially the clock frequencies and the caps flag in the
> hsmmc_info configuration?
>
> Make sure you have MMC_CAP_POWER_OFF_CARD in the .caps field of your mmc
> info struct.

Is this absolutely necessary?  My device can't be powered off (it's soldered
on and the power supply is fixed, not regulated).  I do have control over the
RESET pin.  If power control is essential for this device we'll have to fix
the design.

>
>> # dmesg | tail -n2wl1271: ERROR sdio read failed (-110)
>> wl1271: ERROR chip id doesn't match after firmware boot
>> wl1271: ERROR firmware boot failed despite 3 retries
>> 0
>> ieee80211 phy0: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7 cWmax=15 txop=94 uapsd=1
>> ieee80211 phy0: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3 cWmax=7 txop=47 uapsd=1
>> ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
>> wl1271: Association completed.
>> wlan0: no IPv6 routers present
>> wlan0: deauthenticating from 00:24:b2:49:ef:12 by local choice (reason=3)
>> ieee80211 phy0: Removed STA 00:24:b2:49:ef:12
>> ieee80211 phy0: Destroyed STA 00:24:b2:49:ef:12
>> ieee80211 phy0: device now idle
>> cfg80211: All devices are disconnected, going to restore regulatory settings
>> cfg80211: Restoring regulatory settings
>> cfg80211: Calling CRDA to update world regulatory domain
>> wl1271: down
>> wl1271: ERROR timeout waiting for the hardware to complete initialization
>> wl1271: ERROR timeout waiting for the hardware to complete initialization
>> wl1271: ERROR sdio read failed (-110)
>> wl1271: ERROR sdio write failed (-110)
>> wl1271: ERROR sdio read failed (-110)
>> wl1271: ERROR chip id doesn't match after firmware boot
>> wl1271: ERROR firmware boot failed despite 3 retries
>>
>> I'm using the 2012-02-28 snapshot of compat-wireless, my kernel is 2.6.37
>>
>> Ideas?
>
> I'm running out of ideas.  And 2.6.37 is quite ancient, but AFAIK it
> should work as it is the first version that supports powering the MMC
> card on and off.  Any chance you could try a newer kernel? Just to find
> out it everything is working fine with newer kernels.  If it works, then
> we should focus on why 2.6.37 doesn't work.  Maybe we will have to
> cherry-pick some patches for the MMC subsystem.
>

Sadly, I'm stuck with this one.  The processor is DM8148/AM3874 which
TI only has 2.6.37

Thanks for your time

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
