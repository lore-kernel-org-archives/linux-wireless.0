Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aa002msb.fastweb.it ([85.18.95.81]:35314 "EHLO
	aa002msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756453AbYLPQvi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2008 11:51:38 -0500
Received: from [192.168.1.101] (39.234.158.229) by aa002msb.fastweb.it (8.0.013.8)
        id 493752D303232EFF for linux-wireless@vger.kernel.org; Tue, 16 Dec 2008 17:46:33 +0100
Message-ID: <4947DB68.4090704@techemia.com> (sfid-20081216_175144_018986_2BF22271)
Date: Tue, 16 Dec 2008 17:46:32 +0100
From: techmin <info@techemia.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: compat-wireless-2008-12-11 disassociating on intel pro wireless 4965
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All

I have problem with last compact wireless
i suppose the problem is present on 2.6.27 series linux kernel
this is the link of the bug for ubuntu
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/302069

(the ubuntu 8.04 with 2.6.24 kernel don't have problem, the wireless 
work correctly)

The problem is present on ubuntu precompiled kernel and on compiled 
compat-wireless-2008-12-11 from source.

I suppose the core of the problem is:
wlan0: disassociating by local choice (reason=3)

This is the dmesg

iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 
1.3.27ks                                      
[   12.356966] iwlagn: Copyright(c) 2003-2008 Intel 
Corporation                                                        
[   12.357803] iwlagn 0000:06:00.0: enabling device (0000 -> 
0002)                                                     
[   12.357816] iwlagn 0000:06:00.0: PCI INT A -> GSI 19 (level, low) -> 
IRQ 19                                         
[   12.357838] iwlagn 0000:06:00.0: setting latency timer to 
64                                                        
[   12.357884] iwlagn: Detected Intel Wireless WiFi Link 4965AGN 
REV=0x4                                               
[   12.400480] iwlagn: Tunable channels: 13 802.11bg, 19 802.11a 
channels                                              
[   12.401472] iwlagn 0000:06:00.0: PCI INT A 
disabled                                                                 
[   12.401977] phy0: Selected rate control algorithm 
'iwl-agn-rs'                 

[   28.513385] iwlagn 0000:06:00.0: PCI INT A -> GSI 19 (level, low) -> 
IRQ 19
[   28.513625] iwlagn 0000:06:00.0: restoring config space at offset 0x1 
(was 0x100002, writing 0x100006)
[   28.514905] firmware: requesting iwlwifi-4965-2.ucode
[   28.580500] iwlagn loaded firmware version 228.57.2.21
[   28.844315] Registered led device: iwl-phy0:radio
[   28.844331] Registered led device: iwl-phy0:assoc
[   28.844344] Registered led device: iwl-phy0:RX
[   28.844355] Registered led device: iwl-phy0:TX
[   29.216382] NET: Registered protocol family 17


[  282.441881] wlan0: direct probe to AP XX:XX:4b:15:a5:a0 try 1
[  282.443862] wlan0 direct probe responded
[  282.443876] wlan0: authenticate with AP XX:XX:4b:15:a5:a0
[  282.445670] wlan0: authenticated
[  282.445683] wlan0: associate with AP XX:XX:4b:15:a5:a0
[  282.447907] wlan0: RX AssocResp from XX:XX:4b:15:a5:a0 (capab=0x411 
status=0 aid=3)
[  282.447917] wlan0: associated
[  282.468876] wlan0: disassociating by local choice (reason=3)
[  282.492063] iwlagn: index 0 not used in uCode key table.
[  284.464387] wlan0: privacy configuration mismatch and mixed-cell 
disabled - disassociate


This is the lspci -vv

06:00.0 Network controller: Intel Corporation PRO/Wireless 4965 AG or 
AGN [Kedron] Network Connection (rev 61)
        Subsystem: Intel Corporation Device 
1101                                                             
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx- 
        Interrupt: pin A routed to IRQ 
19                                                                    
        Region 0: Memory at c2000000 (64-bit, non-prefetchable) 
[size=8K]                                    
        Capabilities: <access 
denied>                                                                         

        Kernel driver in use: 
iwlagn                                                                          

        Kernel modules: iwlagn


Tank you

techmin
