Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:44915 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756125Ab2DDLUj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Apr 2012 07:20:39 -0400
Message-ID: <4F7C2E85.4050902@mlbassoc.com> (sfid-20120404_132043_359672_D0335AFE)
Date: Wed, 04 Apr 2012 05:20:37 -0600
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: wl1271 watchdog interrupt
References: <4F6A7FD0.8090404@boundarydevices.com>   <4F71CDC7.2010207@mlbassoc.com> <1333355941.16990.23.camel@cumari>  <4F7BA34C.2030001@boundarydevices.com> <1333508285.24637.2.camel@cumari>
In-Reply-To: <1333508285.24637.2.camel@cumari>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-04-03 20:58, Luciano Coelho wrote:
> On Tue, 2012-04-03 at 18:26 -0700, Troy Kisky wrote:
>> On 4/2/2012 1:39 AM, Luciano Coelho wrote:
>>>>> wl12xx: ERROR watchdog interrupt received! starting recovery.
>>>>> wl12xx: Reading FW panic log
>>>>> wl12xx: ERROR command complete timeout
>>> This is a firmware bug.  Can you please take the contents
>>> of /sys/bus/platform/drivers/wl12xx_driver/wl12xx/fwlog and send it to
>>> us so we can take a look at what's going on?
>> Sorry, it isn't a firmware bug. It was a configuration problem on my
>> part. The defconfig
>> file I was using was enabling a TVOUT driver which this board doesn't
>> have. When
>> the driver wanted to blank the screen, it was turning off my slow clock
>> to my WL1271.
>>
>> When the WL1271 later becomes idle, it goes into a low power state which
>> depends upon
>> slow clock. So please tell your firmware guys, "never mind."
>
> Okay, cool that you found the reason for the problem. :) I thought it
> was a firmware problem because all the symptoms show that the chip
> stopped responding. :)
>
>
>>>> wl12xx: Hardware recovery in progress. FW ver: Rev 6.3.0.0.77 pc: 0x23923
>>> This tells us where the PC was when the crash happened.  I'll ask our
>>> firmware team to analyze this.
>> "Never mind...."
>
> Cool!
>
> Now, Gary, do you still have the same (or a similar) problem with your
> setup?
>

Yes, I still have issues.  One problem is that the wlan interface will
not come up unless I manually perform a scan.  If I just do this to
bring it up (my AP uses WPA2)

# ifconfig wlan0 hw ether D4:94:A1:8E:1E:17
# ifconfig wlan0 up
ADDRCONF(NETDEV_UP): wlan0: link is not ready
# ifup wlan0
udhcpc (v1.19.3) started
Sending discover...
Read error: Network is down, reopening socket
wl1271: ERROR timeout waiting for the hardware to complete initialization
Sending discover...
udhcpc: sendto: Network is down
Read error: Network is down, reopening socket
Sending discover...
udhcpc: sendto: Network is down
Read error: Network is down, reopening socket
No lease, failing
root@cobra8148p81:~# wl1271: ERROR sdio read failed (-110)
wl1271: ERROR sdio write failed (-110)
wl1271: ERROR sdio read failed (-110)
wl1271: ERROR chip id doesn't match after firmware boot
wl1271: ERROR firmware boot failed despite 3 retries

However, if I bring it up with this sequence, it works:

# ifconfig wlan0 hw ether D4:94:A1:8E:1E:17
# ifconfig wlan0 up
ADDRCONF(NETDEV_UP): wlan0: link is not ready
# iw wlan0 scan
   ... many AP shown
# ifup wlan0
udhcpc (v1.19.3) started
Sending discover...
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Sending discover...
Sending select for 192.168.12.184...
Lease of 192.168.12.184 obtained, lease time 600
adding dns 192.168.12.1
# dmesg | tail -n 50
PM: Adding info for No Bus:8:0
PM: Adding info for No Bus:sda
sd 0:0:0:0: [sda] Assuming drive cache: write through
  sda: sda1
PM: Adding info for No Bus:sda1
sd 0:0:0:0: [sda] Assuming drive cache: write through
sd 0:0:0:0: [sda] Attached SCSI removable disk
PM: Adding info for platform:regulatory.0
cfg80211: Calling CRDA to update world regulatory domain
PM: Adding info for platform:wl1271
PM: Adding info for No Bus:phy0
PM: Adding info for No Bus:wlan0
wl1271: loaded
wl1271: initialized
NET: Registered protocol family 10

CPSW phy found : id is : 0x1410e11
PHY 0:01 not found
ADDRCONF(NETDEV_UP): eth0: link is not ready
PHY: 0:00 - Link is Up - 100/Full
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
eth0: no IPv6 routers present
PM: Adding info for No Bus:mmc1:0001:2
PM: Removing info for No Bus:mmc1:0001:2
PM: Adding info for No Bus:mmc1:0001:2
PM: Removing info for No Bus:mmc1:0001:2
wl1271: firmware booted (Rev 6.1.0.50.350)
ieee80211 phy0: device now idle
ADDRCONF(NETDEV_UP): wlan0: link is not ready
ieee80211 phy0: device no longer idle - scanning
ieee80211 phy0: device now idle
ieee80211 phy0: device no longer idle - scanning
ieee80211 phy0: device now idle
ieee80211 phy0: device no longer idle - working
wlan0: authenticate with 00:24:b2:49:ef:12 (try 1)
wlan0: authenticated
ieee80211 phy0: device now idle
ieee80211 phy0: device no longer idle - working
wlan0: associate with 00:24:b2:49:ef:12 (try 1)
wlan0: RX AssocResp from 00:24:b2:49:ef:12 (capab=0x411 status=0 aid=4)
wlan0: associated
ieee80211 phy0: Allocated STA 00:24:b2:49:ef:12
ieee80211 phy0: Inserted STA 00:24:b2:49:ef:12
ieee80211 phy0: WMM queue=2 aci=0 acm=0 aifs=3 cWmin=15 cWmax=1023 txop=0 uapsd=1
ieee80211 phy0: WMM queue=3 aci=1 acm=0 aifs=7 cWmin=15 cWmax=1023 txop=0 uapsd=1
ieee80211 phy0: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7 cWmax=15 txop=94 uapsd=1
ieee80211 phy0: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3 cWmax=7 txop=47 uapsd=1
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
wl1271: Association completed.
wlan0: no IPv6 routers present

This connection will now work fine - here's a ping via the WiFi to
a foreign network (actually across the Atlantic via VPN):
# ifconfig eth0 down
# ping 192.168.1.101
PING 192.168.1.101 (192.168.1.101): 56 data bytes
64 bytes from 192.168.1.101: seq=0 ttl=63 time=267.885 ms
64 bytes from 192.168.1.101: seq=1 ttl=63 time=291.215 ms
64 bytes from 192.168.1.101: seq=2 ttl=63 time=213.565 ms
^C
--- 192.168.1.101 ping statistics ---
3 packets transmitted, 3 packets received, 0% packet loss
round-trip min/avg/max = 213.565/257.555/291.215 ms
# route
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
192.168.12.0    *               255.255.255.0   U     0      0        0 wlan0
default         ns.local.org    0.0.0.0         UG    0      0        0 wlan0

However, if I ever shut down the wlan0, it hangs up and the only
way to get it back is to reboot.

# ifdown wlan0
cfg80211: Calling CRDA to update world regulatory domain
# ifup wlan0
wl1271: ERROR timeout waiting for the hardware to complete initialization
wl1271: ERROR timeout waiting for the hardware to complete initialization
wl1271: ERROR sdio read failed (-110)
^C
# dmesg | tail -n2wl1271: ERROR sdio read failed (-110)
wl1271: ERROR chip id doesn't match after firmware boot
wl1271: ERROR firmware boot failed despite 3 retries
0
ieee80211 phy0: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7 cWmax=15 txop=94 uapsd=1
ieee80211 phy0: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3 cWmax=7 txop=47 uapsd=1
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
wl1271: Association completed.
wlan0: no IPv6 routers present
wlan0: deauthenticating from 00:24:b2:49:ef:12 by local choice (reason=3)
ieee80211 phy0: Removed STA 00:24:b2:49:ef:12
ieee80211 phy0: Destroyed STA 00:24:b2:49:ef:12
ieee80211 phy0: device now idle
cfg80211: All devices are disconnected, going to restore regulatory settings
cfg80211: Restoring regulatory settings
cfg80211: Calling CRDA to update world regulatory domain
wl1271: down
wl1271: ERROR timeout waiting for the hardware to complete initialization
wl1271: ERROR timeout waiting for the hardware to complete initialization
wl1271: ERROR sdio read failed (-110)
wl1271: ERROR sdio write failed (-110)
wl1271: ERROR sdio read failed (-110)
wl1271: ERROR chip id doesn't match after firmware boot
wl1271: ERROR firmware boot failed despite 3 retries

I'm using the 2012-02-28 snapshot of compat-wireless, my kernel is 2.6.37

Ideas?

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
