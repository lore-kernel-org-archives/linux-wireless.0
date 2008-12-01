Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51550 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbYLALJm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 06:09:42 -0500
Subject: cfg80211 regulatory segfaults
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kRDpBRXmHBIohojvfUdm"
Date: Mon, 01 Dec 2008 11:56:00 +0100
Message-Id: <1228128960.18011.4.camel@johannes.berg> (sfid-20081201_120947_318407_5EA2DE47)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kRDpBRXmHBIohojvfUdm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Dec  1 11:53:27 johannes kernel: [47185.697308] Unable to handle kernel pag=
ing request for data at address 0x00000000
Dec  1 11:53:27 johannes kernel: [47185.697322] Faulting instruction addres=
s: 0xf27b8414
Dec  1 11:53:27 johannes kernel: [47185.697338] Oops: Kernel access of bad =
area, sig: 11 [#1]
Dec  1 11:53:27 johannes kernel: [47185.697343] PREEMPT PowerMac
Dec  1 11:53:27 johannes kernel: [47185.697349] Modules linked in: isofs zl=
ib_inflate udf crc_itu_t btusb af_packet radeon drm binfmt_misc rfcom
m l2cap bluetooth nls_utf8 hfsplus nls_base fuse dm_snapshot dm_mirror dm_r=
egion_hash dm_log sha256_generic joydev snd_aoa_codec_tas snd_aoa_fab
ric_layout snd_aoa appletouch arc4 usbhid b43(-) mac80211 cfg80211 snd_aoa_=
i2sbus snd_pcm snd_page_alloc snd_seq ams evdev snd_timer snd_seq_dev
ice input_polldev snd soundcore snd_aoa_soundbus ohci1394 ehci_hcd ohci_hcd=
 ieee1394 ssb usbcore yenta_socket rsrc_nonstatic pcmcia pcmcia_core=20
uninorth_agp agpgart unix hid_apple [last unloaded: btusb]
Dec  1 11:53:27 johannes kernel: [47185.697481] NIP: f27b8414 LR: f27b7368 =
CTR: c03517a4
Dec  1 11:53:27 johannes kernel: [47185.697489] REGS: d47afd20 TRAP: 0300  =
 Tainted: G        W   (2.6.28-rc6-wl-dirty)
Dec  1 11:53:27 johannes kernel: [47185.697495] MSR: 00009032 <EE,ME,IR,DR>=
  CR: 28000442  XER: 00000000
Dec  1 11:53:27 johannes kernel: [47185.697513] DAR: 00000000, DSISR: 40000=
000
Dec  1 11:53:27 johannes kernel: [47185.697519] TASK =3D c15c0000[22122] 'r=
mmod' THREAD: d47ae000
Dec  1 11:53:27 johannes kernel: [47185.697524] GPR00: ef16e0a0 d47afdd0 c1=
5c0000 ef16e0a0 22222222 00000000 d47afd88 efaa9278=20
Dec  1 11:53:27 johannes kernel: [47185.697544] GPR08: 0000005a 00000000 c0=
3f97e0 c03517a4 24000444 1001a338 100e0000 100df49c=20
Dec  1 11:53:27 johannes kernel: [47185.697564] GPR16: 100b54c0 100df49c 10=
0ddd20 102ee8e8 100b5340 102ee7c8 00000000 00000000=20
Dec  1 11:53:27 johannes kernel: [47185.697584] GPR24: 1023d008 c067d7a8 c0=
67d7b4 ef16e0a0 ef16e000 ef16e00c efa861fc ef16e280=20
Dec  1 11:53:27 johannes kernel: [47185.697628] NIP [f27b8414] reg_device_r=
emove+0xc/0x30 [cfg80211]
Dec  1 11:53:27 johannes kernel: [47185.697641] LR [f27b7368] wiphy_unregis=
ter+0x68/0xa4 [cfg80211]
Dec  1 11:53:27 johannes kernel: [47185.697646] Call Trace:
Dec  1 11:53:27 johannes kernel: [47185.697659] [d47afdd0] [f27b7360] wiphy=
_unregister+0x60/0xa4 [cfg80211] (unreliable)
Dec  1 11:53:27 johannes kernel: [47185.697721] [d47afdf0] [f2813334] ieee8=
0211_unregister_hw+0xdc/0x128 [mac80211]
Dec  1 11:53:27 johannes kernel: [47185.697768] [d47afe00] [f28953a8] b43_r=
emove+0x8c/0x90 [b43]
Dec  1 11:53:27 johannes kernel: [47185.697796] [d47afe20] [f25bc33c] ssb_d=
evice_remove+0x38/0x60 [ssb]
Dec  1 11:53:27 johannes kernel: [47185.697814] [d47afe30] [c023acb4] __dev=
ice_release_driver+0x94/0xd0
Dec  1 11:53:27 johannes kernel: [47185.697824] [d47afe50] [c023adb8] drive=
r_detach+0xc8/0xcc
Dec  1 11:53:27 johannes kernel: [47185.697834] [d47afe70] [c0239e10] bus_r=
emove_driver+0x9c/0xd8
Dec  1 11:53:27 johannes kernel: [47185.697844] [d47afe90] [c023b39c] drive=
r_unregister+0x4c/0x60
Dec  1 11:53:27 johannes kernel: [47185.697861] [d47afea0] [f25bdb80] ssb_d=
river_unregister+0x14/0x24 [ssb]
Dec  1 11:53:27 johannes kernel: [47185.697882] [d47afeb0] [f28b1a6c] b43_e=
xit+0x18/0x30 [b43]
Dec  1 11:53:27 johannes kernel: [47185.697895] [d47afec0] [c0061c1c] sys_d=
elete_module+0x18c/0x254
Dec  1 11:53:27 johannes kernel: [47185.697902] Instruction dump:
Dec  1 11:53:27 johannes kernel: [47185.697909] 2f9c0001 3b7b0001 3b9c0001 =
40beff8c 80010034 bb210014 38210030 7c0803a6=20
Dec  1 11:53:27 johannes kernel: [47185.697934] 4e800020 3d20f27c 7c601b78 =
81294650 <80690000> 2f830000 4d9e0020 7f830000=20
Dec  1 11:53:27 johannes kernel: [47185.697961] ---[ end trace 1d075317cac4=
03bc ]---


this was on rmmod.

I also had one on my G5 which I don't know right now, might have been
the same one.

johannes

--=-kRDpBRXmHBIohojvfUdm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJM8K9AAoJEKVg1VMiehFYxy0P/jHBMggV78l8kUeYu8JhIE5t
ptsccZIlE3A0kei68YfBoR730cc3wUdV20t905QB6pfTSR7iUjU9XsEgt67N18Ij
xHocgtPNLGk1jfeerd9UCsgqeYVQDyHkYi514ZS5se7qZJVkU7eqmpFvq1efZirR
+MIVOkwgbaYK+qkFgfaIvPbHR00ZpBzmkaN1kXEwBNRUD0+benJvafjirlLtr+O6
aDVPMCwKQAHHmhizXuEifWB29TtHWi4aFi5xEFEvAj+NKmQs+AJHs400oCfNjDod
7n+Pt/bcLqY98yJUnCpLWXoSWXxrhqVW0C6rQCFgaIUuWq+jYG+6bnPHAtycpG83
N6OSpZ+5aA60wxnt6eDznTR8FrRqbNPVrDAycfWv2SJlqkhvae5ceKYcFBuLSVeX
ooaRlqGqj79bqCM27OHcGRkZXBZSxFJPcrDRbeLpED8IQuPy0Gzsr3eB2lAl7UZy
ps/6TQWfYNbK/BgvJa2mwgAfdghjHpjhnH9Y8BCz6jpLedmi/hnElb7atL9lMAX7
BoBRkP1XhNkHHdMVm0BKK0yaswOJ6VC7INpvFTAEwPJZu1huEBYa60WEtmP90cGv
kaZ+f2AxkI5MXKm7YA2K7WZoyNpXTbNT1nsfLtCW547780O7j0XPweKSzBY9Eg4n
LG3ErsZGVN0rQ+H3lSvg
=khX7
-----END PGP SIGNATURE-----

--=-kRDpBRXmHBIohojvfUdm--

