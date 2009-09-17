Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from adelie.canonical.com ([91.189.90.139]:59574 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758279AbZIQDeh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 23:34:37 -0400
Message-ID: <4AB1AE43.6000602@canonical.com>
Date: Thu, 17 Sep 2009 11:34:27 +0800
From: Bryan Wu <bryan.wu@canonical.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: mb@bu3sch.de, stefano.brivio@polimi.it,
	linux-wireless@vger.kernel.org
Subject: Re: [b43] About supporting of BCM4312 [14e4:4315] with Low Power
 PHY
References: <4AA9B46E.8020100@canonical.com> <69e28c910909102318u465f6c75w46a2404a8e8d9f08@mail.gmail.com> 	<4AB0EDEB.9010803@canonical.com> <69e28c910909160813h2a91ff32hb5fa836f1f7a4963@mail.gmail.com>
In-Reply-To: <69e28c910909160813h2a91ff32hb5fa836f1f7a4963@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gábor Stefanik wrote:
> 2009/9/16 Bryan Wu <bryan.wu@canonical.com>:
>> Hi Gabor,
>>
>> I tried the latest cmpat-wireless 09-16 snapshot on my machine which runs on 2.6.31
>> Ubuntu Karmic latest kernel. The hardware probing passes and wlan1 interface shows up.
>> But the iwlist scanning got no data from wlan1 interface,
>>
>> dmesg:
>> ---
>> [  364.371703] b43-pci-bridge 0000:07:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
>> [  364.371761] b43-pci-bridge 0000:07:00.0: setting latency timer to 64
>> [  364.437779] ssb: Sonics Silicon Backplane found on PCI device 0000:07:00.0
>> [  364.491488] b43-phy0: Broadcom 4312 WLAN found (core revision 15)
>> [  364.533562] b43-phy0 debug: Found PHY: Analog 6, Type 5, Revision 1
>> [  364.533604] b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2062, Revision 2
>> [  364.693040] phy0: Selected rate control algorithm 'minstrel'
>> [  364.701666] Broadcom 43xx driver loaded [ Features: PML, Firmware-ID: FW13 ]
>> [  364.748486] udev: renamed network interface wlan0 to wlan1
>> [  364.824296] b43 ssb0:0: firmware: requesting b43/ucode15.fw
>> [  364.901848] b43 ssb0:0: firmware: requesting b43/lp0initvals15.fw
>> [  364.931482] b43 ssb0:0: firmware: requesting b43/lp0bsinitvals15.fw
>> [  365.140212] b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)
> 
> Please test with v478 or newer.

OK, do you know where can I find this firmware? I just followed the wiki page to get the firmware, but it seems the same version as I am using.
http://linuxwireless.org/en/users/Drivers/b43#device_firmware

> 
>> [  365.144349] b43-phy0 debug: b2062: Using crystal tab entry 19200 kHz.
>> [  365.412558] b43-phy0 debug: Chip initialized
>> [  365.413163] b43-phy0 debug: 64-bit DMA initialized
>> [  365.413356] b43-phy0 debug: QoS enabled
> 
> Try disabling QoS via modparam. Also, try earlier compat-wireless versions.
> 
Yeah, I disabled the QoS via qos=0 modparam, but the result it is the same.


>> [  365.434064] Registered led device: b43-phy0::tx
>> [  365.434315] Registered led device: b43-phy0::rx
>> [  365.434545] Registered led device: b43-phy0::radio
>> [  365.435079] b43-phy0 debug: Wireless interface started
>> [  365.435208] b43-phy0 debug: Adding Interface type 2
>> ----
>>
>> ifconfig:
>> ---
>> $ ifconfig
>> eth0      Link encap:Ethernet  HWaddr 00:24:e8:bd:c9:3d
>>          inet addr:10.101.46.6  Bcast:10.101.46.255  Mask:255.255.255.0
>>          inet6 addr: fe80::224:e8ff:febd:c93d/64 Scope:Link
>>          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
>>          RX packets:797 errors:0 dropped:0 overruns:0 frame:0
>>          TX packets:663 errors:0 dropped:0 overruns:0 carrier:0
>>          collisions:0 txqueuelen:1000
>>          RX bytes:76364 (76.3 KB)  TX bytes:452350 (452.3 KB)
>>          Interrupt:30 Base address:0xc000
>>
>> lo        Link encap:Local Loopback
>>          inet addr:127.0.0.1  Mask:255.0.0.0
>>          inet6 addr: ::1/128 Scope:Host
>>          UP LOOPBACK RUNNING  MTU:16436  Metric:1
>>          RX packets:29 errors:0 dropped:0 overruns:0 frame:0
>>          TX packets:29 errors:0 dropped:0 overruns:0 carrier:0
>>          collisions:0 txqueuelen:0
>>          RX bytes:6202 (6.2 KB)  TX bytes:6202 (6.2 KB)
>>
>> wlan1     Link encap:Ethernet  HWaddr 00:25:56:a0:15:58
>>          UP BROADCAST MULTICAST  MTU:1500  Metric:1
>>          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
>>          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
>>          collisions:0 txqueuelen:1000
>>          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
>> ---
>>
>> $ iwconfig wlan1
>> wlan1     IEEE 802.11bg  Mode:Managed  Access Point: Not-Associated
>>          Tx-Power=20 dBm
>>          Retry  long limit:7   RTS thr:off   Fragment thr:off
>>          Power Management:off
>>
>> $ sudo iwlist wlan1 scanning
>> wlan1     No scan results
> 
> Use "sudo iw dev wlan1 scan" with mac80211 drivers.
> 

Tried that, but the same result, nothing shows up.

Thanks a lot
-Bryan

>> Do you guys think it is related to 64bit DMA issue? I really want to help to develop this b43 opensource driver,
>> anything need me to do, please feel free ping me.
>>
>> Thanks
>> -Bryan
>>
>> Gábor Stefanik wrote:
>>> This chip works (though not quite "supported", that is, can't
>>> guarantee that it will work for you, and speed is not up to par with
>>> wl_hybrid) in wireless-testing. It should also work in
>>> compat-wireless, though compat-wireless is having problems with 64-bit
>>> DMA lately (probably also affects the G-PHY 4311/02). Specifically,
>>> the Dell 1397 (half-mini version of the 1395) and the HP 459263-002
>>> are known to work.
>>>
>>> On Fri, Sep 11, 2009 at 4:22 AM, Bryan Wu <bryan.wu@canonical.com> wrote:
>>>> Dear Michael and Stefano,
>>>>
>>>> I have a project which integrate Broadcom Wifi chip. But the mainline b43 still does not support this chip, because it has Low Power PHY.
>>>>
>>>> Here is my lspci -vvnn output for this device:
>>>> ------
>>>> 07:00.0 Network controller [0280]: Broadcom Corporation BCM4312 802.11b/g [14e4:4315] (rev 01)
>>>>        Subsystem: Dell Device [1028:000c]
>>>>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>>>>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>        Latency: 0, Cache Line Size: 32 bytes
>>>>        Interrupt: pin A routed to IRQ 17
>>>>        Region 0: Memory at f0100000 (64-bit, non-prefetchable) [size=16K]
>>>>        Capabilities: [40] Power Management version 3
>>>>                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>>>                Status: D0 PME-Enable- DSel=0 DScale=2 PME-
>>>>        Capabilities: [58] Vendor Specific Information <?>
>>>>        Capabilities: [e8] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
>>>>                Address: 0000000000000000  Data: 0000
>>>>        Capabilities: [d0] Express (v1) Endpoint, MSI 00
>>>>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
>>>>                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
>>>>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>>>>                        RlxdOrd- ExtTag+ PhantFunc- AuxPwr- NoSnoop-
>>>>                        MaxPayload 128 bytes, MaxReadReq 128 bytes
>>>>                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
>>>>                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <4us, L1 <64us
>>>>                        ClockPM+ Suprise- LLActRep- BwNot-
>>>>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
>>>>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>>>                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>>>>        Kernel driver in use: b43-pci-bridge
>>>>        Kernel modules: ssb
>>>> ------
>>>>
>>>> Do you guys know how to support this device in 2.6.31 kernel? Need I backport some code from wireless-testing? I enabled the PHY_LP config manually in 2.6.31 kernel and b43 driver recognized the hardware wifi device, but it still
>>>> does not work at all.
>>>>
>>>> Or there is no choice but Broadcom's STA driver? I do not like such non-GPL stuff.
>>>>
>>>> Thanks a lot
>>>> --
>>>> Bryan Wu <bryan.wu@canonical.com>
>>>> Kernel Developer    +86.138-1617-6545 Mobile
>>>> Ubuntu Kernel Team | Hardware Enablement Team
>>>> Canonical Ltd.      www.canonical.com
>>>> Ubuntu - Linux for human beings | www.ubuntu.com
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>
