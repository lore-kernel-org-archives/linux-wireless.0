Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:35801 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbYGFTmz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2008 15:42:55 -0400
Received: by fg-out-1718.google.com with SMTP id 19so716127fgg.17
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2008 12:42:54 -0700 (PDT)
Message-ID: <30353c3d0807061242s48dfeed0i2f1e44c02d4c4c73@mail.gmail.com> (sfid-20080706_214300_162140_00EAB72A)
Date: Sun, 6 Jul 2008 15:42:54 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: b43legacy: local packet loss
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
In-Reply-To: <487110CE.3050304@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <30353c3d0807061106x78e796f4r95f2ce7e56a4bb5c@mail.gmail.com>
	 <487110CE.3050304@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 6, 2008 at 2:37 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> David Ellingsworth wrote:
>>
>> While using the latest b43legacy driver, I have severe packet loss
>> originating from the machine using the b43legacy driver. However, when
>> packets are routed through the machine using NAT, no packet loss
>> occurs. Ping results are as follows:
>>
>> using 'ping -c 100 192.168.1.1'
>>
>>> From local machine (192.168.1.100) to wireless router (192.168.1.1)
>>
>>    43% packet loss, average rtt 13.987ms
>>
>>> From nat machine(192.168.2.100) to wireless router (192.168.1.1) via
>>
>> b43legacy router(eth0:192.168.2.1, wlan0:192.168.1.100)
>>    0% packet loss, average rtt 3.621ms
>>
>> The only logical conclusion I can draw from the above information is
>> that there is something wrong with how packets are created locally and
>> delivered to the device. I'm willing to provide any help necessary
>> needed to correct the issue.
>
> More information please.
>
> 1. Is your "latest b43legacy" from wireless-testing, 2.6.26-rc9, or what?
>
> 2. What BCM43xx card are you using?
>
> 3. What wireless router are you using?
>
> Using the wireless-testing git tree with a BCM4306/2 and working with a
> Linksys WRT54GL router with standard firmware, my statistics for the ping -c
> 100 192.168.1.1 command are 0% packet loss with average rtt of 2.919 ms.
>
> Larry
>

1. I'm using the latest b43legacy driver from wireless-testing as of
this morning, which looks to be 2.6.26-rc8-wl.

2. The card is a BCM4306/2 mini-pci card in a Compaq Presario laptop.
relevant lspci info is as follows:
00:09.0 0280: 14e4:4320 (rev 02)
        Subsystem: 0e11:00e7
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64
        Interrupt: pin A routed to IRQ 10
        Region 0: Memory at d0000000 (32-bit, non-prefetchable) [size=8K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME+
        Kernel driver in use: b43-pci-bridge
        Kernel modules: ssb

dmesg info is as follows:
b43legacy-phy0: Broadcom 4306 WLAN found
b43legacy-phy0 debug: Found PHY: Analog 1, Type 2, Revision 1
b43legacy-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
b43legacy-phy0 debug: Radio initialized
firmware: requesting b43legacy/ucode4.fw
firmware: requesting b43legacy/pcm4.fw
firmware: requesting b43legacy/b0g0initvals2.fw
b43legacy-phy0: Loading firmware version 0x127, patch level 14
(2005-04-18 02:36:27)
b43legacy-phy0 debug: Chip initialized
b43legacy-phy0 debug: 30-bit DMA initialized
b43legacy-phy0 debug: Wireless interface started
b43legacy-phy0 debug: Adding Interface type 2

3. I'm using the laptop as the wireless router. My current setup is as follows:
comp(192.168.2.100)->(eth0:192.168.2.1)laptop(wlan0:192.168.1.100)->(192.168.1.1)WRT54G->internet.
Pings from the laptop to the WRT54G experience a high packet loss.
Those from the computer being routed through the laptop to the WRT54G
do not.

Regards,

David Ellingsworth
