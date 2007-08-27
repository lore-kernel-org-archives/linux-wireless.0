Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from seehuhn.de ([80.68.93.199]:2988 "EHLO seehuhn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756472AbXH0Wig (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2007 18:38:36 -0400
Received: from vburmah.vpn.seehuhn.de ([10.98.27.6] helo=burmah.maths.warwick.ac.uk)
	by seehuhn.de with esmtps (TLS-1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.63)
	(envelope-from <voss@seehuhn.de>)
	id 1IPnEA-0004JS-7i
	for linux-wireless@vger.kernel.org; Mon, 27 Aug 2007 23:38:34 +0100
Received: from voss by burmah.maths.warwick.ac.uk with local (Exim 4.67)
	(envelope-from <voss@seehuhn.de>)
	id 1IPnE9-0004GZ-Qj
	for linux-wireless@vger.kernel.org; Mon, 27 Aug 2007 23:38:33 +0100
Date: Mon, 27 Aug 2007 23:38:33 +0100
From: Jochen Voss <voss@seehuhn.de>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: which hostapd version for which wireless driver
Message-ID: <20070827223833.GA15515@seehuhn.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

I am trying to get hostapd up and running on my Soekris net4521 board,
until now without much success.  One of the problems might be that I
am completely at a loss which version of hostapd is supposed to work
together with which driver.

Any help about which combinations of hostapd and device driver have at
least a chance of working together would be more than welcome.

I tried the following PCMCIA cards, device drivers and hostapd
versions:


*** LinkSys WRT54GL (broadcom 4318) ***

I tried the following drivers:

1) CONFIG_B43 in current wireless-dev
2) CONFIG_BCM43XX in current wireless-dev
3) CONFIG_BCM43XX in 2.6.23-rc3
4) CONFIG_BCM43XX in 2.6.22.5

I can succesfully use wpa_supplicant with this card, e.g. with driver
1) above, but there are some error messages.  On the console:

    ioctl[SIOCSIWAUTH]: Operation not supported
    WEXT auth param 4 value 0x0 - ioctl[SIOCSIWAUTH]: Operation not support=
ed
    WEXT auth param 5 value 0x1 - Internet Systems Consortium DHCP Client V=
3.0.4
    Copyright 2004-2006 Internet Systems Consortium.
    All rights reserved.
    For info, please visit http://www.isc.org/sw/dhcp/

dmesg output (note the bbatt error):

    pccard: CardBus card inserted into slot 1
    PCI: Enabling device 0000:05:00.0 (0000 -> 0002)
    PCI: Setting latency timer of device 0000:05:00.0 to 64
    b43-phy7: Broadcom 4318 WLAN found
    wmaster0: Selected rate control algorithm 'simple'
    ssb: Sonics Silicon Backplane found on PCI device 0000:05:00.0
    b43-phy7 ERROR: bbatt(11) >=3D size of LO array
    ...

lspci output for the card:

05:00.0 Network controller: Broadcom Corporation BCM4318 [AirForce One 54g]=
 802.11g Wireless LAN Controller (rev 02)
        Subsystem: Linksys WPC54G-EU version 3 [Wireless-G Notebook Adapter]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR-
        Latency: 64
        Interrupt: pin A routed to IRQ 10
        Region 0: Memory at 1c000000 (32-bit, non-prefetchable) [size=3D8K]


*** Netgear WG511 (prism54) ***

I tried the following drivers:

5) CONFIG_P54_PCI in the latest wireless-dev
6) PRISM54 in the lates wireless-dev
7) PRISM54 in 2.6.23-rc3
8) PRISM54 in 2.6.22.5

I also found hints to some driver called "islsm" on the internet, but
I did not find a place to download this.  Also I only found
contradicting information about whether this is USB only or not.

Again, I can successfully use wpa_supplicant with this card (at least
with driver 5 above).

dmesg output:

    pccard: CardBus card inserted into slot 0
    PCI: Enabling device 0000:01:00.0 (0000 -> 0002)
    PCI: Setting latency timer of device 0000:01:00.0 to 64
    p54: LM86 firmware
    wmaster0: Selected rate control algorithm 'simple'
    phy3: hwaddr 00:09:5b:c8:cf:14, isl3890

lspci output:

01:00.0 Network controller: Intersil Corporation ISL3890 [Prism GT/Prism Du=
ette]/ISL3886 [Prism Javelin/Prism Xbow] (rev 01)
        Subsystem: Netgear WG511 Wireless Adapter
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-=
 Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (2500ns min, 7000ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 10
        Region 0: Memory at 14000000 (32-bit, non-prefetchable) [size=3D8K]
        Capabilities: [dc] Power Management version 1
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1+,D2=
+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-


*** hostapd ***

I tried the following versions

a) 1:0.5.5-3.1 from the current Debian/stable distribution
b) 0.6.0 from the hostapd web page
c) current git from http://w1.fi/hostap.git


*** the problem ***

I did not find any combination of a hostapd version (a, b, or c) and a
device driver (1, 2, ..., 8) which would work together for me.

Example: combination 1c (CONFIG_B43 in wireless-dev, current
http://w1.fi/hostap.git) gives

    root@funk [~] iwconfig wlan1 mode master
    root@funk [~] iwconfig wlan1 essid "SR20"
    root@funk [~] iwconfig wlan1 channel 6
    root@funk [~] iwconfig wlan1 rate 11M
    root@funk [~] ifconfig wlan1 up
    b43-phy2 ERROR: bbatt(11) >=3D size of LO array
    root@funk [~] ifconfig wlan1 192.168.2.1
    root@funk [~] iwconfig wlan1
    wlan1     IEEE 802.11g  ESSID:"SR20" =20
	      Mode:Master  Frequency:2.437 GHz  Tx-Power=3D27 dBm  =20
	      Retry min limit:7   RTS thr:off   Fragment thr=3D2346 B  =20
	      Encryption key:off
	      Link Quality:0  Signal level:0  Noise level:0
	      Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
	      Tx excessive retries:0  Invalid misc:0   Missed beacon:0

    root@funk [~] ifconfig wlan1
    wlan1     Link encap:Ethernet  HWaddr 00:18:39:EE:B3:25 =20
	      inet addr:192.168.2.1  Bcast:192.168.2.255  Mask:255.255.255.0
	      inet6 addr: fe80::218:39ff:feee:b325/64 Scope:Link
	      UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
	      RX packets:0 errors:0 dropped:0 overruns:0 frame:0
	      TX packets:4 errors:0 dropped:0 overruns:0 carrier:0
	      collisions:0 txqueuelen:1000=20
	      RX bytes:0 (0.0 b)  TX bytes:440 (440.0 b)

    root@funk [~] grep "^[^#]" /etc/hostapd.conf
    interface=3Dwlan1
    driver=3Ddevicescape
    logger_syslog=3D-1
    logger_syslog_level=3D2
    logger_stdout=3D-1
    logger_stdout_level=3D2
    debug=3D4
    dump_file=3D/tmp/hostapd.dump
    ctrl_interface=3D/var/run/hostapd
    ctrl_interface_group=3D0
    ssid=3DSR20
    hw_mode=3Db
    channel=3D6
    beacon_int=3D100
    dtim_period=3D2
    max_num_sta=3D255
    rts_threshold=3D2347
    fragm_threshold=3D2346
    macaddr_acl=3D0
    auth_algs=3D3
    ignore_broadcast_ssid=3D0
    wme_enabled=3D1
    wme_ac_bk_cwmin=3D4
    wme_ac_bk_cwmax=3D10
    wme_ac_bk_aifs=3D7
    wme_ac_bk_txop_limit=3D0
    wme_ac_bk_acm=3D0
    wme_ac_be_aifs=3D3
    wme_ac_be_cwmin=3D4
    wme_ac_be_cwmax=3D10
    wme_ac_be_txop_limit=3D0
    wme_ac_be_acm=3D0
    wme_ac_vi_aifs=3D2
    wme_ac_vi_cwmin=3D3
    wme_ac_vi_cwmax=3D4
    wme_ac_vi_txop_limit=3D94
    wme_ac_vi_acm=3D0
    wme_ac_vo_aifs=3D2
    wme_ac_vo_cwmin=3D2
    wme_ac_vo_cwmax=3D3
    wme_ac_vo_txop_limit=3D47
    wme_ac_vo_acm=3D0
    eapol_key_index_workaround=3D0
    eap_server=3D0
    own_ip_addr=3D127.0.0.1

    root@funk [~] hostapd /etc/hostapd.conf
    Configuration file: /etc/hostapd.conf
    Opening raw packet socket for ifindex 15
    BSS count 1, BSSID mask ff:ff:ff:ff:ff:ff (0 bits)
    Hardware does not support configured mode
    wlan1: IEEE 802.11 Hardware does not support configured mode (2)
    Could not select hw_mode and channel. (-1)
    rmdir[ctrl_interface]: No such file or directory

dmesg output for this run:

    PCI: Enabling device 0000:05:00.0 (0000 -> 0002)
    PCI: Setting latency timer of device 0000:05:00.0 to 64
    b43-phy2: Broadcom 4318 WLAN found
    wmaster0: Selected rate control algorithm 'simple'
    ssb: Sonics Silicon Backplane found on PCI device 0000:05:00.0
    b43-phy2 ERROR: bbatt(11) >=3D size of LO array

I tried many other combinations of drivers and hostapd version but
nothing worked wor me.  Does anybody have any hints about this
combination of driver and hostapd currently have the biggest chance of
working together?

Many thanks,
Jochen
--=20
http://seehuhn.de/

--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFG01Jpf+iD8yEbECURArVcAJwJYW/HlPZnM+Yd5xGTIYOxBAramACfRm9x
mvy4oPDgiHDHWSYWCd1cjyc=
=6fxX
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
