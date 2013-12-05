Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:47456 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289Ab3LEAMZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Dec 2013 19:12:25 -0500
Received: by mail-oa0-f44.google.com with SMTP id m1so17702116oag.3
        for <linux-wireless@vger.kernel.org>; Wed, 04 Dec 2013 16:12:25 -0800 (PST)
Message-ID: <529FC4D8.6090703@lwfinger.net> (sfid-20131205_011229_299839_1F84539E)
Date: Wed, 04 Dec 2013 18:12:08 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?RGF2aWQgUGluaWxsYSBDYXBhcnLDs3M=?= <dpini@caliu.cat>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Weak Signal and slow tx Rate with RTL8723AE
References: <CA+OxbLhpRV2GhHbYD_VpoWgdYfR1uV4g38OO=gT4WPEt=F8_Og@mail.gmail.com>	<529FAF1B.5040706@lwfinger.net> <CA+OxbLiZUPMj0Qv=7ZsgXWT1KWT06ZgUpptARHW5U39e69jD8w@mail.gmail.com>
In-Reply-To: <CA+OxbLiZUPMj0Qv=7ZsgXWT1KWT06ZgUpptARHW5U39e69jD8w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/04/2013 05:08 PM, David Pinilla Caparrós wrote:
> 2013/12/4 Larry Finger <Larry.Finger@lwfinger.net>:
>> On 12/04/2013 03:40 PM, David Pinilla Caparrós wrote:
>>>
>>> Hello,
>>>
>>> I have mailed with Larry Finger asking for a problem and he has
>>> pointed me to this list.
>>>
>>> I am an Arch Linux User with a Clevo based laptop.
>>>
>>> It ships with the RTL8723AE. I have been reading posts around the net
>>> and found that some people are having problems and talking about the
>>> driver and something about the RX or TX Power.
>>>
>>>
>>> With the 2 APs wich I usually use I can only reach 18Mb/s of Bit rate
>>> whatever the signal level or link quality is. Both of them are 802.11
>>> G and not N I think.
>>>
>>> The connection is very unstable. Sometimes powering the wifi off and
>>> on increases the performance a bit when it's impossible to do anything
>>> (pings to gateway don't reply)
>>>
>>> If they are related to the driver, I would be proud to help with
>>> anything that I am able to. Testing for example.
>>>
>>> I have a recent version of the stable Kernel but I dont know if the
>>> firmware files are up to date.
>>>
>>>
>>>
>>> Some data:
>>>
>>> 03:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8723AE
>>> PCIe Wireless Network Adapter
>>>       Subsystem: Realtek Semiconductor Co., Ltd. Device 0726
>>>       Flags: bus master, fast devsel, latency 0, IRQ 18
>>>       I/O ports at d000 [size=256]
>>>       Memory at f7900000 (64-bit, non-prefetchable) [size=16K]
>>>       Capabilities: [40] Power Management version 3
>>>       Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
>>>       Capabilities: [70] Express Endpoint, MSI 00
>>>       Capabilities: [100] Advanced Error Reporting
>>>       Capabilities: [140] Virtual Channel
>>>       Capabilities: [160] Device Serial Number 01-23-87-fe-ff-4c-e0-00
>>>       Kernel driver in use: rtl8723ae
>>>       Kernel modules: rtl8723ae
>>>
>>>    root  ~  dmesg | grep rtl
>>> [    2.734124] rtl8723ae 0000:03:00.0: enabling device (0000 -> 0003)
>>> [    2.749732] rtl8723ae: Using firmware rtlwifi/rtl8723fw_B.bin
>>> [    2.752940] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
>>> [    2.753057] rtlwifi: wireless switch is on
>>> [ 8838.570486] rtlwifi: wireless switch is o
>>>
>>>
>>>    root  ~  uname -a
>>> Linux DPini-Laptop 3.12.2-1-ARCH #1 SMP PREEMPT Fri Nov 29 21:14:15
>>> CET 2013 x86_64 GNU/Linux
>>>
>>>
>>> Iwconfig:
>>>
>>> wlp3s0    IEEE 802.11bgn  ESSID:"Pinis_AP"
>>>             Mode:Managed  Frequency:2.462 GHz  Access Point:
>>> 00:1A:2B:12:34:56
>>>             Bit Rate=18 Mb/s   Tx-Power=20 dBm
>>>             Retry  long limit:7   RTS thr=2347 B   Fragment thr:off
>>>             Encryption key:off
>>>             Power Management:off
>>>             Link Quality=50/70  Signal level=-60 dBm
>>>             Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>>>             Tx excessive retries:0  Invalid misc:9   Missed beacon:0
>>>
>>>    root  ~  rfkill list
>>> 0: phy0: Wireless LAN
>>>       Soft blocked: no
>>>       Hard blocked: no
>>> 1: hci0: Bluetooth
>>>       Soft blocked: no
>>>       Hard blocked: no
>>>
>>>    root  ⋯  lib  firmware  rtlwifi  md5sum rtl8723fw*
>>> ce50dfe07dbb1bfe9e14bdb315a4b28a  rtl8723fw_B.bin
>>> 69ccaffbe94cc0ef1b89c25290e19b2e  rtl8723fw.bin
>>
>
> Inline reply
>
>> Those md5sums match those of the latest firmware.
>
> Thanks. It's a great notice
>
>> Your signal is a bit lower than mine. My iwconfig shows
>>
>> wlp14s0   IEEE 802.11bgn  ESSID:"NETGEAR81"
>>            Mode:Managed  Frequency:2.437 GHz  Access Point: 20:E5:2A:01:F7:EA
>>            Bit Rate=7.2 Mb/s   Tx-Power=20 dBm
>>
>>            Retry  long limit:7   RTS thr=2347 B   Fragment thr:off
>>            Power Management:off
>>            Link Quality=60/70  Signal level=-50 dBm
>>
>>            Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>>            Tx excessive retries:0  Invalid misc:2254   Missed beacon:0
>>
>> My AP is 802.11n. Note that the 7.2 Mbps is misleading. When I pushed data
>> through using netperf, it jumped to 72.2 Mbps, and my throughput was
>>
>> TCP_MAERTS Test:  30.64 27.65 30.54 28.86 33.33 33.59 37.86 39.40 39.76
>> 37.20
>> RX Results: max 39.76, min 27.65. Mean 33.88(4.22)
>>
>> TCP_STREAM Test:  35.34 37.34 29.59 20.10 36.11 40.24 40.67 41.93 38.08
>> 33.93
>> TX Results: max 41.93, min 20.10. Mean 35.33(6.13)
>>
>> When I switch to an 802.11g AP, I get the following:
>>
>> TCP_MAERTS Test:  10.77 10.81 11.53 11.69 10.46 10.16 11.04 10.66  7.34
>> 10.90
>> RX Results: max 11.69, min  7.34. Mean 10.54(1.15)
>>
>> TCP_STREAM Test:   5.74  6.24  6.76  6.43  7.37  6.23  7.63  7.07  7.07
>> 6.50
>> TX Results: max  7.63, min  5.74. Mean  6.70(0.55)
>
> Here at home I get similar results:
>
>   dpini  ~  iperf -c 192.168.1.102
> ------------------------------------------------------------
> Client connecting to 192.168.1.102, TCP port 5001
> TCP window size: 22.9 KByte (default)
> ------------------------------------------------------------
> [  3] local 192.168.1.117 port 36449 connected with 192.168.1.102 port 5001
> [ ID] Interval       Transfer     Bandwidth
> [  3]  0.0-10.3 sec  10.0 MBytes  8.13 Mbits/sec
>   dpini  ~  iperf -c 192.168.1.102
> ------------------------------------------------------------
> Client connecting to 192.168.1.102, TCP port 5001
> TCP window size: 22.9 KByte (default)
> ------------------------------------------------------------
> [  3] local 192.168.1.117 port 36450 connected with 192.168.1.102 port 5001
> [ ID] Interval       Transfer     Bandwidth
> [  3]  0.0-10.1 sec  7.50 MBytes  6.25 Mbits/sec
>
>
> I will try it tomorrow at school, where I have the most of the problems.
>
>
>> Those numbers could probably be improved, but without any details on how the
>> chip works, what could one do. Messing with power settings on the amplifiers
>> could lead to destruction of radios. I cannot take that chance.
>
> Im ok with that. When I was talking about the power is because I have
> read somwhere that there were problems with power management in the
> driver. I am trying to get working another wireless card in a router.
> I could be confused about the power problem.
>
>>
>> As to stability, I am in the middle of a long-term test of rtl8723ae. After
>> roughly 86,000 seconds of connect time, I have had only 9 disconnections,
>> and all were due to a bug in the roaming code that I have so far been unable
>> to find. The interface thinks it has lost the APs beacons, does a
>> disconnect, and immediately reconnects. Otherwise, the connection was stable
>> until I forced a reconnect to my G AP for this reply.
>
> Sorry for beeing the cause of this disconnection. I really appreciate
> the work that you and others do so everyone can use FLOSS drivers.
>
>> Unfortunately, I have no idea what to do for your complaints. If you want
>> higher throughput, then an 802.11n AP seems warranted.
>
> The hope that we can replace the wireless home router soon.
>
> But for the AP on the school I can't do anything. Thay have spent a
> lof of money buying HP AP with central management and I can't do
> anything to change them.
>
>> Larry
>>
>
> I think that the problems in the school can be because channel saturation.
>
> There are some APs reachable with the same SSID (every AP have 3 SSID
> I think). But the other students doesn't have any problems. I have
> checked with "other OS and the RTL drivers" on the laptop and the
> connection is ok.
>
> It coluld be related with the bug with roaming?
>
> Any tip for diagnosing this? I can help you with the bug providing
> data or doing any test?

Please do not drop the mailing list from the reply. Always use "Reply-to-All". I 
have added the Cc on my reply, but because it was not on your mail, I dare not 
trim the reply.

You will see messages like the following if you have the bug:

finger@larrylap:~/realtek> dmesg | grep watchdog
[24098.632094] rtlwifi:rtl_watchdog_wq_callback():<0-0> AP off, try to reconnect now
[88203.348090] rtlwifi:rtl_watchdog_wq_callback():<0-0> AP off, try to reconnect now
[88221.856380] rtlwifi:rtl_watchdog_wq_callback():<0-0> AP off, try to reconnect now
[88228.360104] rtlwifi:rtl_watchdog_wq_callback():<0-0> AP off, try to reconnect now
[88238.520095] rtlwifi:rtl_watchdog_wq_callback():<0-0> AP off, try to reconnect now
[88346.876102] rtlwifi:rtl_watchdog_wq_callback():<0-0> AP off, try to reconnect now
[88353.032106] rtlwifi:rtl_watchdog_wq_callback():<0-0> AP off, try to reconnect now
[88377.196053] rtlwifi:rtl_watchdog_wq_callback():<0-0> AP off, try to reconnect now
[88417.776110] rtlwifi:rtl_watchdog_wq_callback():<0-0> AP off, try to reconnect now

As you can see this happens quite infrequently. Finding it will not be easy.

Larry

