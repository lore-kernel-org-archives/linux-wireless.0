Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:59907 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab0ASRYV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2010 12:24:21 -0500
Received: by bwz19 with SMTP id 19so2966506bwz.28
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jan 2010 09:24:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <51058d551001190858k764926ddrafcd7e2c907b3266@mail.gmail.com>
References: <933379711001180712v7e6c0a3fx923123af900d90c7@mail.gmail.com>
	<933379711001180815r284ff41au733cadb40a7606fe@mail.gmail.com>
	<c988e1dc1001180938m24365028p63f611e7e9446663@mail.gmail.com>
	<933379711001190404q1232d2f5i899e7b6347357f23@mail.gmail.com>
	<51058d551001190858k764926ddrafcd7e2c907b3266@mail.gmail.com>
From: Giuseppe Fontana <gfontana13@gmail.com>
Date: Tue, 19 Jan 2010 18:23:57 +0100
Message-ID: <933379711001190923o680f5010vcd799b65e314fbd2@mail.gmail.com>
Subject: Re: Broadcom BCM4318 AirForceOne issue - Ubuntu 9.10 on Acer Aspire
	5024wlmi
To: Greg Oliver <oliver.greg@gmail.com>
Cc: linux-wireless@vger.kernel.org, Shang Wu <shang@ubuntu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!
ping from .1 -> .99  >>>> No ping
ping from .1 to <ip of nokia> >> I don't know how to determine Nokia
IP. I can't get it from the phone GUI. Is there a way to get it from
Windows? But I guess ping should work, cause Nokia phone can access
internet via wireless...

2010/1/19 Greg Oliver <oliver.greg@gmail.com>:
> On Tue, Jan 19, 2010 at 6:04 AM, Giuseppe Fontana <gfontana13@gmail.com> wrote:
>> Yes, I installed b43-fwcutter to extract the adapter firmware, as
>> suggested in linux-wireless page.
>> I did other experiments and I have an update: the issue is only with
>> ad-hoc networks.
>> Moreover yesterday I successufully connected to a Windows ad-hoc
>> network using Network Manager (that is able to force BSSID address to
>> grant access to the same cell of the ad-hoc network) following these
>> steps:
>>
>> 1. I created an ad-hoc network (essid "SkyNet") under WinXPPro, to
>> share my Internet connection via wireless. To   achieve this result I
>> manually set 192.168.0.1 IP address and 255.255.255.0 netmask. I also
>> selected connection sharing option under the adapter connected to the
>> internet.
>>  2. Connected to the ad-hoc network using my Nokia E52 phone. The
>> phone and WinXPPro successfully created the network and negotiated IP
>> addresses via DHCP (note that after connection the phone can access
>> internet and navigate)
>> 3. At this point, I connected Ubuntu to the ad-hoc network via Network
>> Manager. dhcpclient founds an active network and connection happens :)
>> (Note that I later I discovered that I can achieve the same result
>> skipping step 2 and manually setting a 192.168.0.x address in Ubuntu
>> via Network Manager profile).
>>
>> However I still have a problem: even if the connection is established,
>> I cannot ping the 192.168.0.1 address and the Ubunbtu laptop can't use
>> the shared internet connection. Here is the syslog printed during the
>> connection (with dhcp negotiation):
>
> Can you ping from .1 -> .99 and from .1 to <ip of nokia>?
>
>>
>> 2010/1/18 Shang Wu <shang@ubuntu.com>:
>>> In 9.04, it used to be installing the package b43-fwcutter. Is the package
>>> installed on your system? Can you also pastebin the syslog?
>>> Thanks,
>>>
>>> On Mon, Jan 18, 2010 at 11:15 AM, Giuseppe Fontana <gfontana13@gmail.com>
>>> wrote:
>>>>
>>>> Hi! I installed Ubuntu 9.10 on my Acer 5024wlmi and followed Linux
>>>> wireless instructions to enable my Broadcom AirForceOne BCM4318 wifi
>>>> card. Now the wireless adapter is on (laptop front led also is on), I
>>>> can see wifi networks but connection fails (even with a simple ad-hoc
>>>> open wifi network!). I tried with Network Manager/WICD/Wifi Radar and
>>>> also using terminal lfconfig/lwconfig commands without success. It
>>>> seems that my wifi card cannot ping access points: for example see
>>>> this log from WICD connection session:
>>>>
>>>> -2010/01/16 22:51:15 :: Connecting to wireless network Winx
>>>> -2010/01/16 22:51:15 :: ping -q -w 3 -c 1 192.168.0.1
>>>> -2010/01/16 22:51:17 :: iwconfig wlan0
>>>> -2010/01/16 22:51:18 :: Connection Failed: Failed to ping the access
>>>> point!
>>>>
>>>> Here there are some useful data about my laptop/Ubuntu configuration.
>>>> Hope you can help!
>>>>
>>>>
>>>> ------------------------------------------------------------------------------------------------------------------------------------------
>>>> Laptop model >> Acer Aspire 5024wlmi laptop
>>>> giuseppe@giuseppe-laptop:~$ lsb_release -d >> Description:    Ubuntu 9.10
>>>> giuseppe@giuseppe-laptop:~$ uname -mr >> 2.6.31-17-generic i686
>>>>
>>>> ------------------------------------------------------------------------------------------------------------------------------------------
>>>> giuseppe@giuseppe-laptop:~$ sudo lspci | grep 'Broadcom'
>>>> 06:05.0 Network controller: Broadcom Corporation BCM4318 [AirForce One
>>>> 54g] 802.11g Wireless LAN Controller (rev 02)
>>>>
>>>> ------------------------------------------------------------------------------------------------------------------------------------------
>>>> giuseppe@giuseppe-laptop:~$ sudo iwconfig wlan0
>>>> wlan0     IEEE 802.11bg  ESSID:""
>>>>           Mode:Managed  Frequency:2.462 GHz  Access Point: Not-Associated
>>>>           Tx-Power=20 dBm
>>>>           Retry  long limit:7   RTS thr:off   Fragment thr:off
>>>>           Encryption key:off
>>>>           Power Management:off
>>>>           Link Quality:0  Signal level:0  Noise level:0
>>>>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>>>>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
>>>>
>>>>
>>>> ------------------------------------------------------------------------------------------------------------------------------------------
>>>> giuseppe@giuseppe-laptop:~$ sudo lsmod | grep "b43"
>>>> b43                   122168  0
>>>> mac80211              181140  1 b43
>>>> cfg80211               93052  2 b43,mac80211
>>>> led_class               4096  3 acer_wmi,b43,sdhci
>>>> ssb                    35364  1 b43
>>>>
>>>> ------------------------------------------------------------------------------------------------------------------------------------------
>>>> giuseppe@giuseppe-laptop:~$ dmesg | grep b43
>>>> [    2.717660] b43-pci-bridge 0000:06:05.0: PCI INT A -> GSI 21
>>>> (level, low) -> IRQ 21
>>>> [   14.884317] b43-phy0: Broadcom 4318 WLAN found (core revision 9)
>>>> [   16.516094] b43 ssb0:0: firmware: requesting b43/ucode5.fw
>>>> [   16.739725] b43 ssb0:0: firmware: requesting b43/pcm5.fw
>>>> [   16.745578] b43 ssb0:0: firmware: requesting b43/b0g0initvals5.fw
>>>> [   16.751202] b43 ssb0:0: firmware: requesting b43/b0g0bsinitvals5.fw
>>>> [...]
>>>> [ 4300.736074] b43-phy0: Loading firmware version 410.2160 (2007-05-26
>>>> 15:32:10)
>>>> [ 4300.776488] Registered led device: b43-phy0::tx
>>>> [ 4300.776531] Registered led device: b43-phy0::rx
>>>> [ 4300.776575] Registered led device: b43-phy0::radio
>>>>
>>>> ------------------------------------------------------------------------------------------------------------------------------------------
>>>> giuseppe@giuseppe-laptop:~$ sudo lshw -C network
>>>>   *-network:0
>>>>        description: Network controller
>>>>        product: BCM4318 [AirForce One 54g] 802.11g Wireless LAN Controller
>>>>        vendor: Broadcom Corporation
>>>>        physical id: 5
>>>>        bus info: pci@0000:06:05.0
>>>>        version: 02
>>>>        width: 32 bits
>>>>        clock: 33MHz
>>>>        capabilities: bus_master
>>>>        configuration: driver=b43-pci-bridge latency=64
>>>>        resources: irq:21 memory:c0204000-c0205fff
>>>>   *-network:1
>>>>        description: Ethernet interface
>>>>        product: RTL-8169 Gigabit Ethernet
>>>>        vendor: Realtek Semiconductor Co., Ltd.
>>>>        physical id: 7
>>>>        bus info: pci@0000:06:07.0
>>>>        logical name: eth0
>>>>        version: 10
>>>>        serial: 00:0a:e4:e8:a2:87
>>>>        size: 1GB/s
>>>>        capacity: 1GB/s
>>>>        width: 32 bits
>>>>        clock: 66MHz
>>>>        capabilities: pm bus_master cap_list rom ethernet physical tp
>>>> mii 10bt 10bt-fd 100bt 100bt-fd 1000bt 1000bt-fd autonegotiation
>>>>        configuration: autonegotiation=on broadcast=yes driver=r8169
>>>> driverversion=2.3LK-NAPI duplex=full ip=192.168.0.242 latency=64
>>>> link=yes maxlatency=64 mingnt=32 multicast=yes port=MII speed=1GB/s
>>>>        resources: irq:23 ioport:a000(size=256)
>>>> memory:c0209400-c02094ff memory:44000000-4401ffff(prefetchable)
>>>>   *-network
>>>>        description: Wireless interface
>>>>        physical id: 1
>>>>        logical name: wlan0
>>>>        serial: 00:14:a4:49:c7:fc
>>>>        capabilities: ethernet physical wireless
>>>>        configuration: broadcast=yes multicast=yes wireless=IEEE 802.11bg
>>>>
>>>> ------------------------------------------------------------------------------------------------------------------------------------------
>>>> giuseppe@giuseppe-laptop:~$ sudo iwlist scan
>>>> (...)
>>>> wlan0     Scan completed :
>>>>           Cell 01 - Address: 02:1D:E0:00:08:5A
>>>>                     Channel:11
>>>>                     Frequency:2.462 GHz (Channel 11)
>>>>                     Quality=62/70  Signal level=-48 dBm
>>>>                     Encryption key:off
>>>>                     ESSID:"Winx"
>>>>                     Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s
>>>>                     Bit Rates:6 Mb/s; 9 Mb/s; 12 Mb/s; 18 Mb/s; 24 Mb/s
>>>>                               36 Mb/s; 48 Mb/s; 54 Mb/s
>>>>                     Mode:Ad-Hoc
>>>>                     Extra:tsf=00000001035383eb
>>>>                     Extra: Last beacon: 272ms ago
>>>>                     IE: Unknown: 000457696E78
>>>>                     IE: Unknown: 010482840B16
>>>>                     IE: Unknown: 03010B
>>>>                     IE: Unknown: 06020000
>>>>                     IE: Unknown: 2A0100
>>>>                     IE: Unknown: 32080C1218243048606C
>>>>                     IE: Unknown: DD070giuseppe@giuseppe-laptop:~$ sudo
>>>> iwlist scan050F202000100
>>>>
>>>> ------------------------------------------------------------------------------------------------------------------------------------------
>>>> giuseppe@giuseppe-laptop:~$ sudo /etc/init.d/networking restart
>>>>  * Reconfiguring network interfaces...
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
>>>> in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>>>
>>> --
>>> Shang Wu
>>> ----------------------------------------------------------------
>>> Key ID: 4B2BCA02
>>> Fingerprint: 4832 D5D0 D124 CE1D FD07  167A 3E93 FF44 4B2B CA02
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
