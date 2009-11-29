Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:58751 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056AbZK2OB3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Nov 2009 09:01:29 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1NEkLG-0003WH-RG
	for linux-wireless@vger.kernel.org; Sun, 29 Nov 2009 15:01:34 +0100
Received: from 85-127-91-18.dynamic.xdsl-line.inode.at ([85.127.91.18])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 29 Nov 2009 15:01:34 +0100
Received: from tim by 85-127-91-18.dynamic.xdsl-line.inode.at with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 29 Nov 2009 15:01:34 +0100
To: linux-wireless@vger.kernel.org
From: Tim Blechmann <tim@klingt.org>
Subject: Re: rt61pci bug
Date: Sun, 29 Nov 2009 15:01:02 +0100
Message-ID: <4B127E9E.1090008@klingt.org>
References: <4AE43028.30703@klingt.org> <hcsfgm$bft$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4E94235E0AA08E8D965FD4C4"
In-Reply-To: <hcsfgm$bft$1@ger.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4E94235E0AA08E8D965FD4C4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 11/04/2009 07:00 PM, Tim Blechmann wrote:
>> running the rt61pci module on 2.6.31.5 works fine, but using the recen=
t=20
>> linus/master (2.6.32-rc5) results in this:
>=20
> same issue with 2.6.32-rc5 ... new bootlog with more debugging info
> attached ...

i was still able to reproduce this issue with 2.6.32-rc8 ... it would=20
be nice, if someone could have a look into this issue before 2.6.32 is=20
released ...

dmesg from 2.6.32-rc8:
[   10.249098] rt61pci 0000:06:00.0: PCI INT A -> GSI 16 (level, low) -> =
IRQ 16
[   10.257182] phy0 -> rt61pci_validate_eeprom: EEPROM recovery - NIC: 0x=
ff80
[   10.257184] phy0 -> rt61pci_validate_eeprom: EEPROM recovery - Led: 0x=
e0ff
[   10.257187] phy0 -> rt2x00_set_chip: Info - Chipset detected - rt: 030=
2, rf: 0003, rev: 0002561c.
[   10.351794] Registered led device: rt61pci-phy0::radio
[   10.351839] Registered led device: rt61pci-phy0::assoc
[   14.342046] rt61pci 0000:06:00.0: firmware: requesting rt2561.bin
[   14.395533] phy0 -> rt2x00lib_request_firmware: Info - Firmware detect=
ed - version: 0.8.
[   14.421238] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - =
CWmin: 3, CWmax: 4, Aifs: 2, TXop: 102.
[   14.421245] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - =
CWmin: 4, CWmax: 5, Aifs: 2, TXop: 188.
[   14.421252] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - =
CWmin: 5, CWmax: 10, Aifs: 3, TXop: 0.
[   14.421258] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - =
CWmin: 5, CWmax: 10, Aifs: 7, TXop: 0.
[  273.404685] phy0 -> rt2x00queue_write_tx_frame: Error - Arrived at non=
-free entry in the non-full queue 2.
[  273.404687] Please file bug report to http://rt2x00.serialmonkey.com.
[  282.143549] wlan0: no IPv6 routers present
[  357.304908] phy0 -> rt61pci_txdone: Warning - TX status report missed =
for entry 2
[  357.333806] phy0 -> rt61pci_txdone: Warning - TX status report missed =
for entry 9
[  360.172776] phy0 -> rt2x00queue_write_tx_frame: Error - Arrived at non=
-free entry in the non-full queue 2.
[  360.172778] Please file bug report to http://rt2x00.serialmonkey.com.
[  360.172782] phy0 -> rt2x00mac_tx_rts_cts: Warning - Failed to send RTS=
/CTS frame.
[  383.880010] No probe response from AP 00:24:fe:09:94:18 after 500ms, d=
isconnecting.
[  383.880026] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - =
CWmin: 2, CWmax: 3, Aifs: 2, TXop: 47.
[  383.880034] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - =
CWmin: 3, CWmax: 4, Aifs: 2, TXop: 94.
[  383.880042] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - =
CWmin: 4, CWmax: 10, Aifs: 3, TXop: 0.
[  383.880050] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - =
CWmin: 4, CWmax: 10, Aifs: 7, TXop: 0.
[  385.220460] wlan0: direct probe to AP 00:24:fe:09:94:18 (try 1)
[  385.421337] wlan0: direct probe to AP 00:24:fe:09:94:18 (try 2)
[  385.621304] wlan0: direct probe to AP 00:24:fe:09:94:18 (try 3)
[  385.821264] wlan0: direct probe to AP 00:24:fe:09:94:18 timed out


lspci -vvv:

06:00.0 Network controller: RaLink RT2561/RT61 rev B 802.11g
	Subsystem: D-Link System Inc Device 3c09
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Step=
ping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dslow >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at fb6f8000 (32-bit, non-prefetchable) [size=3D32K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3c=
old-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Kernel driver in use: rt61pci
	Kernel modules: rt61pci

thanks, tim

--=20
tim@klingt.org
http://tim.klingt.org

Happiness is a byproduct of function, purpose, and conflict; those who
seek happiness for itself seek victory without war.
  William S. Burroughs


--------------enig4E94235E0AA08E8D965FD4C4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAksSfqEACgkQdL+4qsZfVsvFFgCgm6y5W74z8KXIy+mvMQGmmf7Z
E2cAnRKusCa+Qk1Z1PlR/FvGyyXjpRh1
=ugc6
-----END PGP SIGNATURE-----

--------------enig4E94235E0AA08E8D965FD4C4--

