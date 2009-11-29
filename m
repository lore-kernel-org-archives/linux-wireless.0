Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:39182 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbZK2Q7w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Nov 2009 11:59:52 -0500
Received: by fxm5 with SMTP id 5so2966921fxm.28
        for <linux-wireless@vger.kernel.org>; Sun, 29 Nov 2009 08:59:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B127E9E.1090008@klingt.org>
References: <4AE43028.30703@klingt.org> <hcsfgm$bft$1@ger.gmane.org>
	<4B127E9E.1090008@klingt.org>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sun, 29 Nov 2009 17:59:36 +0100
Message-ID: <69e28c910911290859mc1da58ree7b2d3fa8dc371d@mail.gmail.com>
Subject: Re: rt61pci bug
To: Tim Blechmann <tim@klingt.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 29, 2009 at 3:01 PM, Tim Blechmann <tim@klingt.org> wrote:
> On 11/04/2009 07:00 PM, Tim Blechmann wrote:
>>> running the rt61pci module on 2.6.31.5 works fine, but using the recent
>>> linus/master (2.6.32-rc5) results in this:
>>
>> same issue with 2.6.32-rc5 ... new bootlog with more debugging info
>> attached ...
>
> i was still able to reproduce this issue with 2.6.32-rc8 ... it would
> be nice, if someone could have a look into this issue before 2.6.32 is
> released ...
>
> dmesg from 2.6.32-rc8:
> [   10.249098] rt61pci 0000:06:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [   10.257182] phy0 -> rt61pci_validate_eeprom: EEPROM recovery - NIC: 0xff80
> [   10.257184] phy0 -> rt61pci_validate_eeprom: EEPROM recovery - Led: 0xe0ff
> [   10.257187] phy0 -> rt2x00_set_chip: Info - Chipset detected - rt: 0302, rf: 0003, rev: 0002561c.
> [   10.351794] Registered led device: rt61pci-phy0::radio
> [   10.351839] Registered led device: rt61pci-phy0::assoc
> [   14.342046] rt61pci 0000:06:00.0: firmware: requesting rt2561.bin
> [   14.395533] phy0 -> rt2x00lib_request_firmware: Info - Firmware detected - version: 0.8.
> [   14.421238] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 102.
> [   14.421245] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 4, CWmax: 5, Aifs: 2, TXop: 188.
> [   14.421252] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 5, CWmax: 10, Aifs: 3, TXop: 0.
> [   14.421258] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - CWmin: 5, CWmax: 10, Aifs: 7, TXop: 0.
> [  273.404685] phy0 -> rt2x00queue_write_tx_frame: Error - Arrived at non-free entry in the non-full queue 2.
> [  273.404687] Please file bug report to http://rt2x00.serialmonkey.com.
> [  282.143549] wlan0: no IPv6 routers present
> [  357.304908] phy0 -> rt61pci_txdone: Warning - TX status report missed for entry 2
> [  357.333806] phy0 -> rt61pci_txdone: Warning - TX status report missed for entry 9
> [  360.172776] phy0 -> rt2x00queue_write_tx_frame: Error - Arrived at non-free entry in the non-full queue 2.
> [  360.172778] Please file bug report to http://rt2x00.serialmonkey.com.
> [  360.172782] phy0 -> rt2x00mac_tx_rts_cts: Warning - Failed to send RTS/CTS frame.
> [  383.880010] No probe response from AP 00:24:fe:09:94:18 after 500ms, disconnecting.
> [  383.880026] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 2, CWmax: 3, Aifs: 2, TXop: 47.
> [  383.880034] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 94.
> [  383.880042] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 4, CWmax: 10, Aifs: 3, TXop: 0.
> [  383.880050] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - CWmin: 4, CWmax: 10, Aifs: 7, TXop: 0.
> [  385.220460] wlan0: direct probe to AP 00:24:fe:09:94:18 (try 1)
> [  385.421337] wlan0: direct probe to AP 00:24:fe:09:94:18 (try 2)
> [  385.621304] wlan0: direct probe to AP 00:24:fe:09:94:18 (try 3)
> [  385.821264] wlan0: direct probe to AP 00:24:fe:09:94:18 timed out
>
>
> lspci -vvv:
>
> 06:00.0 Network controller: RaLink RT2561/RT61 rev B 802.11g
>        Subsystem: D-Link System Inc Device 3c09
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 64, Cache Line Size: 64 bytes
>        Interrupt: pin A routed to IRQ 16
>        Region 0: Memory at fb6f8000 (32-bit, non-prefetchable) [size=32K]
>        Capabilities: [40] Power Management version 2
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>        Kernel driver in use: rt61pci
>        Kernel modules: rt61pci
>
> thanks, tim

Could you please try a bisect between 2.6.31 and 2.6.32-rc5? That
should reveal the faulty commit.

>
> --
> tim@klingt.org
> http://tim.klingt.org
>
> Happiness is a byproduct of function, purpose, and conflict; those who
> seek happiness for itself seek victory without war.
>  William S. Burroughs
>
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
