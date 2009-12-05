Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:43614 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757944AbZLET3B (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Dec 2009 14:29:01 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1NH0JX-0007xp-Ji
	for linux-wireless@vger.kernel.org; Sat, 05 Dec 2009 20:29:07 +0100
Received: from 85-127-90-163.dynamic.xdsl-line.inode.at ([85.127.90.163])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 05 Dec 2009 20:29:07 +0100
Received: from tim by 85-127-90-163.dynamic.xdsl-line.inode.at with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 05 Dec 2009 20:29:07 +0100
To: linux-wireless@vger.kernel.org
From: Tim Blechmann <tim@klingt.org>
Subject: Re: rt61pci bug
Date: Sat, 05 Dec 2009 20:28:38 +0100
Message-ID: <hfec9b$kdo$1@ger.gmane.org>
References: <4AE43028.30703@klingt.org> <hcsfgm$bft$1@ger.gmane.org> 	<4B127E9E.1090008@klingt.org> <69e28c910911290859mc1da58ree7b2d3fa8dc371d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig0459A5309527B20E31275642"
In-Reply-To: <69e28c910911290859mc1da58ree7b2d3fa8dc371d@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0459A5309527B20E31275642
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 11/29/2009 05:59 PM, G=C3=A1bor Stefanik wrote:
> On Sun, Nov 29, 2009 at 3:01 PM, Tim Blechmann <tim-xpEK/MU0Hawdnm+yROf=
E0A@public.gmane.org> wrote:
>> On 11/04/2009 07:00 PM, Tim Blechmann wrote:
>>>> running the rt61pci module on 2.6.31.5 works fine, but using the rec=
ent
>>>> linus/master (2.6.32-rc5) results in this:
>>>
>>> same issue with 2.6.32-rc5 ... new bootlog with more debugging info
>>> attached ...
>>
>> i was still able to reproduce this issue with 2.6.32-rc8 ... it would
>> be nice, if someone could have a look into this issue before 2.6.32 is=

>> released ...
>>
>> dmesg from 2.6.32-rc8:
>> [   10.249098] rt61pci 0000:06:00.0: PCI INT A -> GSI 16 (level, low) =
-> IRQ 16
>> [   10.257182] phy0 -> rt61pci_validate_eeprom: EEPROM recovery - NIC:=
 0xff80
>> [   10.257184] phy0 -> rt61pci_validate_eeprom: EEPROM recovery - Led:=
 0xe0ff
>> [   10.257187] phy0 -> rt2x00_set_chip: Info - Chipset detected - rt: =
0302, rf: 0003, rev: 0002561c.
>> [   10.351794] Registered led device: rt61pci-phy0::radio
>> [   10.351839] Registered led device: rt61pci-phy0::assoc
>> [   14.342046] rt61pci 0000:06:00.0: firmware: requesting rt2561.bin
>> [   14.395533] phy0 -> rt2x00lib_request_firmware: Info - Firmware det=
ected - version: 0.8.
>> [   14.421238] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0=
 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 102.
>> [   14.421245] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1=
 - CWmin: 4, CWmax: 5, Aifs: 2, TXop: 188.
>> [   14.421252] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2=
 - CWmin: 5, CWmax: 10, Aifs: 3, TXop: 0.
>> [   14.421258] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3=
 - CWmin: 5, CWmax: 10, Aifs: 7, TXop: 0.
>> [  273.404685] phy0 -> rt2x00queue_write_tx_frame: Error - Arrived at =
non-free entry in the non-full queue 2.
>> [  273.404687] Please file bug report to http://rt2x00.serialmonkey.co=
m.
>> [  282.143549] wlan0: no IPv6 routers present
>> [  357.304908] phy0 -> rt61pci_txdone: Warning - TX status report miss=
ed for entry 2
>> [  357.333806] phy0 -> rt61pci_txdone: Warning - TX status report miss=
ed for entry 9
>> [  360.172776] phy0 -> rt2x00queue_write_tx_frame: Error - Arrived at =
non-free entry in the non-full queue 2.
>> [  360.172778] Please file bug report to http://rt2x00.serialmonkey.co=
m.
>> [  360.172782] phy0 -> rt2x00mac_tx_rts_cts: Warning - Failed to send =
RTS/CTS frame.
>> [  383.880010] No probe response from AP 00:24:fe:09:94:18 after 500ms=
, disconnecting.
>> [  383.880026] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0=
 - CWmin: 2, CWmax: 3, Aifs: 2, TXop: 47.
>> [  383.880034] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1=
 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 94.
>> [  383.880042] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2=
 - CWmin: 4, CWmax: 10, Aifs: 3, TXop: 0.
>> [  383.880050] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3=
 - CWmin: 4, CWmax: 10, Aifs: 7, TXop: 0.
>> [  385.220460] wlan0: direct probe to AP 00:24:fe:09:94:18 (try 1)
>> [  385.421337] wlan0: direct probe to AP 00:24:fe:09:94:18 (try 2)
>> [  385.621304] wlan0: direct probe to AP 00:24:fe:09:94:18 (try 3)
>> [  385.821264] wlan0: direct probe to AP 00:24:fe:09:94:18 timed out
>>
>>
>> lspci -vvv:
>>
>> 06:00.0 Network controller: RaLink RT2561/RT61 rev B 802.11g
>>        Subsystem: D-Link System Inc Device 3c09
>>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- Par=
Err- Stepping- SERR+ FastB2B- DisINTx-
>>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dslow >TAbort=
- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>        Latency: 64, Cache Line Size: 64 bytes
>>        Interrupt: pin A routed to IRQ 16
>>        Region 0: Memory at fb6f8000 (32-bit, non-prefetchable) [size=3D=
32K]
>>        Capabilities: [40] Power Management version 2
>>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1=
-,D2-,D3hot-,D3cold-)
>>                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
>>        Kernel driver in use: rt61pci
>>        Kernel modules: rt61pci
>>
>> thanks, tim
>=20
> Could you please try a bisect between 2.6.31 and 2.6.32-rc5? That
> should reveal the faulty commit.
>=20
>>
>> --
>> tim@klingt.org
>> http://tim.klingt.org
>>
>> Happiness is a byproduct of function, purpose, and conflict; those who=

>> seek happiness for itself seek victory without war.
>>  William S. Burroughs

btw, on v2.6.31.6-rt19, i get the following messages continuously:

[35097.254691] phy0 -> rt61pci_txdone: Warning - TX status report missed =
for entry 15
[35097.352620] phy0 -> rt61pci_txdone: Warning - TX status report missed =
for entry 21
[35097.400820] phy0 -> rt61pci_txdone: Warning - TX status report missed =
for entry 11
[35097.682924] phy0 -> rt61pci_txdone: Warning - TX status report missed =
for entry 17
[35098.050321] phy0 -> rt61pci_txdone: Warning - TX status report missed =
for entry 5
[35098.203187] phy0 -> rt61pci_txdone: Warning - TX status report missed =
for entry 23
[35098.390729] phy0 -> rt61pci_txdone: Warning - TX status report missed =
for entry 15
[35098.572894] phy0 -> rt61pci_txdone: Warning - TX status report missed =
for entry 15
[35098.735895] phy0 -> rt61pci_txdone: Warning - TX status report missed =
for entry 19
[35099.069564] phy0 -> rt61pci_txdone: Warning - TX status report missed =
for entry 7
[35099.407685] phy0 -> rt61pci_txdone: Warning - TX status report missed =
for entry 9
[35099.408726] phy0 -> rt61pci_txdone: Warning - TX status report missed =
for entry 13
[35099.417144] phy0 -> rt61pci_txdone: Warning - TX status report missed =
for entry 17
[35099.420996] phy0 -> rt61pci_txdone: Warning - TX status report missed =
for entry 21
[35099.518701] phy0 -> rt61pci_txdone: Warning - TX status report missed =
for entry 23
[35100.012178] phy0 -> rt61pci_txdone: Warning - TX status report missed =
for entry 11
[35101.354838] phy0 -> rt61pci_txdone: Warning - TX status report missed =
for entry 15
[35101.448263] phy0 -> rt61pci_txdone: Warning - TX status report missed =
for entry 7
[35101.498144] phy0 -> rt61pci_txdone: Warning - TX status report missed =
for entry 13
[35102.168253] phy0 -> rt61pci_txdone: Warning - TX status report missed =
for entry 9
[35102.548745] phy0 -> rt61pci_txdone: Warning - TX status report missed =
for entry 9

what does this tell me? i am not able to get any network connection
with any 2.6.32-rc build, with (and without) the previously posted
error messages

tim

--=20
tim@klingt.org
http://tim.klingt.org

Who need fossil fuel when the sun ain't goin' nowhere
  Amiri Baraka


--------------enig0459A5309527B20E31275642
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAksatGYACgkQdL+4qsZfVssLVwCfbdoH4iVJLzhVTcaOa4pPGdE7
pDQAnjssmYPRpY1GMPr6nsxTptmrtYWl
=Z4Y3
-----END PGP SIGNATURE-----

--------------enig0459A5309527B20E31275642--

