Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.klingt.org ([86.59.21.178]:57228 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168AbZK3Qqd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 11:46:33 -0500
Message-ID: <4B13F6EC.5090701@klingt.org>
Date: Mon, 30 Nov 2009 17:46:36 +0100
From: Tim Blechmann <tim@klingt.org>
MIME-Version: 1.0
To: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: rt61pci bug
References: <4AE43028.30703@klingt.org> <hcsfgm$bft$1@ger.gmane.org> 	<4B127E9E.1090008@klingt.org> <69e28c910911290859mc1da58ree7b2d3fa8dc371d@mail.gmail.com>
In-Reply-To: <69e28c910911290859mc1da58ree7b2d3fa8dc371d@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD0A4B94720F86F4FE6592A32"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD0A4B94720F86F4FE6592A32
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 11/29/2009 05:59 PM, G=C3=A1bor Stefanik wrote:
> On Sun, Nov 29, 2009 at 3:01 PM, Tim Blechmann <tim@klingt.org> wrote:
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

unfortunately, this bug seems to be shadowed by another bug, so
bisecting was not really successful ... do you have suggestions for
commits to revert?

the commits touching drivers/net/wireless/rt2x00/* are:
Alexey Dobriyan (1):
      headers: remove sched.h from interrupt.h

Andrew Price (1):
      rt2x00: fix the definition of rt2x00crypto_rx_insert_iv

Benoit PAPILLAULT (1):
      rt2x00: Add support for retry rates

David S. Miller (2):
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6

Igor Perminov (3):
      rt2x00: Fix for race condition while update beacon
      rt2x00: FIF_PSPOLL filter flag support
      rt2x00: Fix beacon de-synchronization while update beacon

Ivo van Doorn (18):
      rt2x00: use wiphy rfkill interface
      rt2x00: Remove DEVICE_STATE_DISABLED_RADIO_HW
      rt2x00: Fix build error when crypto support is disabled
      rt2x00: Remove usage of deprecated radio_enabled &
IEEE80211_CONF_CHANGE_RADIO_ENABLED
      rt2x00: Use IEEE80211_TX_CTL_MORE_FRAMES flag
      rt2x00: Align ieee80211 header to 4-byte boundary for PCI devices
      rt2x00: Fix RFKILL polling
      rt2x00: Fix for rt2800usb for SHARED_KEY_TABLE initializations
      rt2x00: Add new RF chip defines
      rt2x00: Set SKBDESC_L2_PADDED in RX path
      rt2x00: wireless CLI ID and packet ID must not be 0
      rt2x00: Fix MCS register intialization
      rt2x00: configure_filter() callback is allowed to sleep
      rt2x00: bss_info_changed() callback is allowed to sleep
      rt2x00: Cleanup rt2x00mac_bss_info_changed()
      rt2x00: Fix TX status reporting
      rt2x00: Reorganize padding & L2 padding
      rt2x00: Hardcode TX ack timeout and consume time

Johannes Berg (4):
      rt2x00: remove skb->do_not_encrypt usage
      mac80211: push rx status into skb->cb
      wireless: remove print_mac uses
      mac80211: allow configure_filter callback to sleep

Lars Ericsson (3):
      rt2x00: Don't alter rt2x00dev->default_ant
      rt2x00: Fix quality houskeeping for software diversity
      rt2x00: Fix rounding errors in RSSI average calculation

Luis Correia (1):
      rt2x00: Comment spellchecking

Luis R. Rodriguez (2):
      rt2x00: move experimental on kconfig only to rt2800usb
      mac80211: redefine usage of the mac80211 workqueue

Michal Szalata (1):
      rt2x00: Thrustmaster FunAccess WIFI USB and rt73usb

Pavel Roskin (2):
      rt61pci: fix module reloading
      rt2x00: cancel all work on disconnect

Stefan Steuerwald (1):
      rt2x00: Implement set_tim callback for all drivers


--=20
tim@klingt.org
http://tim.klingt.org

Which is more musical, a truck passing by a factory or a truck passing
by a music school?
  John Cage


--------------enigD0A4B94720F86F4FE6592A32
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAksT9uwACgkQdL+4qsZfVssbegCcCxg6qI8IR2T7zdwMQh1MY+01
yOEAn0XQDliz3IL3ZWpN06GTGaXn95a8
=hFz7
-----END PGP SIGNATURE-----

--------------enigD0A4B94720F86F4FE6592A32--
