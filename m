Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pD9E7DD47.dip.t-dialin.net ([217.231.221.71]:53745 "EHLO
	apo2k4.ath.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247AbZAYBHa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 20:07:30 -0500
Received: from lucien (unknown [10.8.1.2])
	by apo2k4.ath.cx (Postfix) with ESMTPA id E86CE150076
	for <linux-wireless@vger.kernel.org>; Sun, 25 Jan 2009 02:07:27 +0100 (CET)
Date: Sun, 25 Jan 2009 02:07:27 +0100
From: Valentin <apo@apo2k4.ath.cx>
To: linux-wireless@vger.kernel.org
Subject: Fw: [linux-wireless] Re: p54 + ISL3887 + master mode?
Message-ID: <20090125020727.544a6819@lucien> (sfid-20090125_020737_198414_A37CA60F)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/X62VAW74fxqTsiDiHIZIJ79";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/X62VAW74fxqTsiDiHIZIJ79
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

> On Sat, 24 Jan 2009 16:51:25 +0100
> Artur Skawina <art.08.09@gmail.com> wrote:
>=20
> > > you probably want a kernel w/ at least this=20
> > > http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=
=3Dcommit;h=3De5ea92a7528d304e8e327d0d261653e98b163e8a
> > > hence 2.6.29+ or even newer to get the other p54 fixes.
> >=20
> > meant 2.6.28+, of course.
>=20
> Right, I'm going to try that. Thanks :)

That did help, thanks :) But it's not working completely yet:

When I start hostapd, it create a mon.wlan# interface and sets wlan#
into master mode, but other boxes don't see the network. Here's
hostapd's output:

Configuration file: .conf
ctrl_interface_group=3D0
Opening raw packet socket for ifindex 209
BSS count 1, BSSID mask ff:ff:ff:ff:ff:ff (0 bits)
SIOCGIWRANGE: WE(compiled)=3D22 WE(source)=3D21 enc_capa=3D0xf
nl80211: Added 802.11b mode based on 802.11g information
Allowed channel: mode=3D1 chan=3D1 freq=3D2412 MHz max_tx_power=3D27 dBm
...
Allowed channel: mode=3D0 chan=3D11 freq=3D2462 MHz max_tx_power=3D27 dBm
RATE[0] rate=3D10 flags=3D0x6
RATE[1] rate=3D20 flags=3D0x6
RATE[2] rate=3D55 flags=3D0x4
RATE[3] rate=3D110 flags=3D0x4
Passive scanning not supported
Flushing old station entries
Deauthenticate all stations
Using interface wlan1 with hwaddr ... and ssid '...'
SSID - hexdump_ascii(len=3D6):
...
PSK (ASCII passphrase) - hexdump_ascii(len=3D13):
...
PSK (from passphrase) - hexdump(len=3D32): ...
WPA: group state machine entering state GTK_INIT (VLAN-ID 0)
GMK - hexdump(len=3D32): [REMOVED]
GTK - hexdump(len=3D32): [REMOVED]
WPA: group state machine entering state SETKEYSDONE (VLAN-ID 0)
Failed to set beacon head/tail
wlan1: Setup of interface done.

The only interesting part here seems to be "Failed to set beacon
head/tail", but I can't find anything helpful about that on google.

This is my hostapd config:

interface=3Dwlan1
driver=3Dnl80211
logger_syslog=3D-1
logger_syslog_level=3D1
logger_stdout=3D-1
logger_stdout_level=3D0
dump_file=3D/tmp/hostapd.dump
ctrl_interface=3D/var/run/hostapd
ctrl_interface_group=3D0
auth_algs=3D3
ssid=3D...
wpa=3D2
wpa_passphrase=3D...
wpa_key_mgmt=3DWPA-PSK
wpa_pairwise=3DTKIP CCMP


Any new ideas? Sorry if my questions are stupid...

--Valentin


--Sig_/X62VAW74fxqTsiDiHIZIJ79
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkl7u08ACgkQ22z6WcGtDs+8eQCgtrEra3g02NHwSxATqefClIBE
gQ0AnAsqtZHuso08uRbiPnx3IySNbR9x
=BnNy
-----END PGP SIGNATURE-----

--Sig_/X62VAW74fxqTsiDiHIZIJ79--
