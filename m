Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1957 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674Ab3ABLP5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 06:15:57 -0500
Message-ID: <50E416E4.5010407@broadcom.com> (sfid-20130102_121617_506611_13FFA378)
Date: Wed, 2 Jan 2013 12:15:48 +0100
From: "Piotr Haber" <phaber@broadcom.com>
MIME-Version: 1.0
To: "Vojtech Havel" <xhavel1@fi.muni.cz>
cc: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com
Subject: Re: bugreport brcmsmac weak signal
References: <1707792.Sg5XObDUQq@ledge> <50E3DFD3.6010803@broadcom.com>
 <1536004.hKi75cttfX@ledge>
In-Reply-To: <1536004.hKi75cttfX@ledge>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/02/13 10:09, Vojtech Havel wrote:
> On Wednesday 02 of January 2013 08:20:51 Piotr Haber wrote:
>> On 01/02/13 01:09, Vojtech Havel wrote:
>>> Hi,
>>>
>>> I have problems with my Broadcom BCM4313 wifi card while using brcmsmac
>>> module.
>>>
>>> The wifi signal is terribly weak. When the distance between my laptop and
>>> AP is more than ~5 m the network is not visible at all. When the laptop
>>> is closer, it connects, but it is very slow due to weak signal. I have to
>>> sit next to AP when I want link quality more than 60/70.
>>>
>>> If I use Broadcom hybrid driver - wl - it works normally (but has
>>> different
>>> problems...).
>>>
>>> I tried to use three different wifi networks with this combination and all
>>> of them had the same problem.
>>>
>>> -----
>>> My setting:
>>> $ uname -r
>>> 3.8.0-rc1
>>>
>>> I applied the patch from:
>>> http://marc.info/?l=linux-wireless&m=135635090121154&w=2
>>>
>>> The same with 3.5.7 gentoo kernel.
>>> -----
>>> wavemon info: (with brcmsmac, ~5 m between my laptop and the ap)
>>>
>>> ┌─Interface────────────────────────────────────────────────
>>> │wlan0 (IEEE 802.11bgn, WPA/WPA2),  ESSID: "ihome"
>>> ├─Levels───────────────────────────────────────────────────
>>> │
>>> │link quality: 23/70
>>> │======================
>>> │
>>> │signal level: -87 dBm (2,00 pW)
>>> │========
>>> │
>>> │
>>> ├─Statistics───────────────────────────────────────────────
>>> │RX: 3 8178(2,41 MiB), invalid: 0 nwid, 0 crypt, 0 frag, 3 misc
>>> │TX: 4 1789(779,619KiB), mac retries: 31, missed beacons: 0
>>> ├─Info─────────────────────────────────────────────────────
>>> │mode: Managed,  access point: (not relevant :-))
>>> │freq: 2,437 GHz, channel: 6,  bitrate: 5,5 Mbit/s
>>> │power mgt: off,  tx-power: 19 dBm (79,43 mW)
>>> │retry: long limit 7,  rts/cts: off,  frag: off
>>> │encryption: n/a (requires CAP_NET_ADMIN permissions)
>>> ├─Network──────────────────────────────────────────────────
>>> │wlan0 (UP RUNNING BROADCAST MULTICAST)
>>> │mac: (not relevant :-)), qlen: 1000
>>> │ip: 192.168.1.103/24,  bcast: 255.255.255.255
>>> └──────────────────────────────────────────────────────────
>>
>> Hi Vojtech,
>> I see you are running v3.8-rc1, that's great since you can provide us
>> with the content of /sys/kernel/debug/brcmsmac/bcma0:0/hardware so we
>> know exactly which hardware you have.
>> Also dmesg contents would be helpful i think
>>
>> Kind regards
>> Piotr
> 
> Hi Piotr,
> 
> # cat /sys/kernel/debug/brcmsmac/bcma0:0/hardware
> board vendor: 14e4
> board type: 608
> board revision: 1109
> board flags: 402201
> board flags2: 884
> firmware revision: 262032b
> 
Hi,

what you have here is a Bluetooth combo board, with shared BT & WiFi
antenna.
There were reports before of poor performance on such boards.
Currently brcmsmac driver does not support BT coexistence.
You might try and disable BT and see if this helps.

Sorry we cannot do more for you.

Kind regards
Piotr



> $ dmesg
> mtrr: your BIOS has configured an incorrect mask, fixing it.
> ata1.00: failed to get Identify Device Data, Emask 0x1
> ata1.00: failed to get Identify Device Data, Emask 0x1
> ata1.00: configured for UDMA/100
> ata1: EH complete
> EXT4-fs (sda3): re-mounted. Opts: commit=0
> EXT4-fs (sda4): re-mounted. Opts: commit=0
> NET: Registered protocol family 10
> cfg80211: Calling CRDA to update world regulatory domain
> bcma: bus0: Found chip with id 0x4313, rev 0x01 and package 0x08
> bcma: bus0: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x24, class 
> 0x0)
> bcma: bus0: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x18, class 
> 0x0)
> bcma: bus0: Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev 0x11, class 0x0)
> bcma: bus0: Found rev 8 PMU (capabilities 0x084C3008)
> bcma: bus0: SPROM offset 0x830
> bcma: bus0: GPIO driver not activated
> bcma: bus0: Bus registered
> brcmsmac bcma0:0: mfg 4bf core 812 rev 24 class 0 irq 17
> bcma: bus0: Switched to core: 0x812
> ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
> brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: false (implement)
> brcmsmac bcma0:0: brcms_ops_config: change power-save mode: false (implement)
> IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> wlan0: authenticate with 00:25:86:df:49:64
> wlan0: direct probe to 00:25:86:df:49:64 (try 1/3)
> wlan0: send auth to 00:25:86:df:49:64 (try 2/3)
> wlan0: authenticated
> brcmsmac bcma0:0 wlan0: disabling HT as WMM/QoS is not supported by the AP
> brcmsmac bcma0:0 wlan0: disabling VHT as WMM/QoS is not supported by the AP
> wlan0: associate with 00:25:86:df:49:64 (try 1/3)
> wlan0: RX AssocResp from 00:25:86:df:49:64 (capab=0x431 status=0 aid=1)
> brcmsmac bcma0:0: brcmsmac: brcms_ops_bss_info_changed: associated
> brcmsmac bcma0:0: brcms_ops_bss_info_changed: arp filtering: enabled true, 
> count 0 (implement)
> brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: false (implement)
> wlan0: associated
> IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready


