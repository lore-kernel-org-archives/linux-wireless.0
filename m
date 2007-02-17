Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34104 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965137AbXBQKYA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Feb 2007 05:24:00 -0500
Subject: even more breakage in wireless-dev.git
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Jiri Benc <jbenc@suse.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dZb4rSEVNLJDQi5BXKlP"
Date: Sat, 17 Feb 2007 11:23:58 +0100
Message-Id: <1171707838.3487.11.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dZb4rSEVNLJDQi5BXKlP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hah, I get to complain too.

http://thread.gmane.org/gmane.linux.network/52202 still exists:

[  441.994183] bcm43xx_d80211: Radio turned off
[  442.310739] eth1: skb_queue not empty
[  442.313338] Unable to handle kernel paging request for data at address 0=
x6b6b6b73

[... warn_on() stuff removed ...]

[  442.314609] Oops: Kernel access of bad area, sig: 11 [#1]
[  442.314624]
[  442.314635] Modules linked in: binfmt_misc hci_usb rfcomm l2cap bluetoot=
h fuse af_packet snd_powermac configfs nls_utf8 hfsplus nls_base dm_snapsho=
t dm_mirror sha256 joydev eth1394 snd_aoa_codec_tas snd_aoa_fabric_layout a=
ppletouch snd_aoa usbhid pcmcia snd_aoa_i2sbus snd_pcm_oss snd_mixer_oss sn=
d_pcm snd_timer snd_page_alloc snd ieee80211softmac ieee80211 ieee80211_cry=
pt arc4 rc80211_simple soundcore ohci1394 ieee1394 ehci_hcd snd_aoa_soundbu=
s ohci_hcd yenta_socket rsrc_nonstatic firmware_class usbcore ssb
pcmcia_core 80211 cfg80211 uninorth_agp agpgart evdev unix
[  442.315368] NIP: C0030ADC LR: C0030CB4 CTR: C0030A5C
[  442.315386] REGS: c037dbc0 TRAP: 0300   Not tainted  (2.6.20-g3ff05f36-d=
irty)
[  442.315401] MSR: 00009032 <EE,ME,IR,DR>  CR: 42040444  XER: 20000000
[  442.315477] DAR: 6B6B6B73, DSISR: 40000000
[  442.315494] TASK =3D effa8720[481] 'udevd' THREAD: c037c000
[  442.315509] GPR00: 00009032 C037DC70 EFFA8720 C077DA48 C056D780 00000001=
 00000000 C0428774
[  442.315596] GPR08: 00000000 00000000 00000000 6B6B6B6B 22040442 1002714C=
 28204422 00000000
[  442.315692] GPR16: 100FB7C8 100D0000 100B0000 100D0000 00000007 0000000F=
 00000000 000001A4
[  442.315787] GPR24: C0780000 00000000 C077F458 00000001 C0780000 C0570000=
 00000001 6B6B6B6B
[  442.315881] NIP [C0030ADC] tasklet_action+0x80/0xec

[rest just posted for completeness]

[  442.315910] LR [C0030CB4] __do_softirq+0x80/0xf4
[  442.315937] Call Trace:
[  442.315952] [C037DC70] [F220F804] ohci_irq+0x68/0x270 [ohci_hcd] (unreli=
able)
[  442.316003] [C037DC90] [C0030CB4] __do_softirq+0x80/0xf4
[  442.316039] [C037DCC0] [C00069A8] do_softirq+0x58/0x5c
[  442.316081] [C037DCD0] [C0030A4C] irq_exit+0x48/0x58
[  442.316114] [C037DCE0] [C0006A54] do_IRQ+0xa8/0xc8
[  442.316383] [C037DCF0] [C0011A28] ret_from_except+0x0/0x14
[  442.316420] --- Exception: 501 at down_write+0xc/0x64
[  442.316453]     LR =3D notify_change+0x1f8/0x284
[  442.316468] [C037DDB0] [C02C6D28] __mutex_lock_slowpath+0x110/0x1ac (unr=
eliable)
[  442.316513] [C037DDD0] [C009BC70] notify_change+0x38/0x284
[  442.316550] [C037DE00] [C0082868] do_truncate+0x5c/0x84
[  442.316586] [C037DE50] [C008E080] may_open+0x148/0x200
[  442.316618] [C037DE70] [C0090548] open_namei+0x88/0x6b4
[  442.316653] [C037DEC0] [C0082480] do_filp_open+0x30/0x78
[  442.316689] [C037DF20] [C0082520] do_sys_open+0x58/0xf8
[  442.316724] [C037DF40] [C0011380] ret_from_syscall+0x0/0x38
[  442.316760] --- Exception: c01 at 0xff205ac
[  442.316788]     LR =3D 0xffb3d70
[  442.316801] Instruction dump:
[  442.316824] 7d40f078 7c00492d 40a2fff4 71400001 41820084 806b0010 816b00=
0c 7d6903a6
[  442.316903] 4e800421 2f9f0000 7febfb78 419e0054 <800b0008> 392b0004 83eb=
0000 2f800000
[  442.316984]  <0>Kernel panic - not syncing: Fatal exception in interrupt
[  442.317035]  <0>Rebooting in 180 seconds..

johannes

--=-dZb4rSEVNLJDQi5BXKlP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF1te+/ETPhpq3jKURAiiVAJ9lF9P8khHjTi4S4hBDOIN8jw22YgCeOhOt
JegnXpb7CHQes7Z479Ze1BU=
=pOf4
-----END PGP SIGNATURE-----

--=-dZb4rSEVNLJDQi5BXKlP--

