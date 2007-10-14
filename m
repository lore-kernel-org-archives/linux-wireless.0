Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38916 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876AbXJNJmq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Oct 2007 05:42:46 -0400
Subject: Re: b43 with upstream-davem stacktrace
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de,
	Christian Hoffmann <email@christianhoffmann.info>,
	linux-wireless@vger.kernel.org,
	Richard Purdie <rpurdie@openedhand.com>
In-Reply-To: <200710131726.14289.mb@bu3sch.de> (sfid-20071013_162714_205094_D26CE64D)
References: <200710131823.33420.email@christianhoffmann.info>
	 <200710131726.14289.mb@bu3sch.de> (sfid-20071013_162714_205094_D26CE64D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+Mt9OE0SOucXm7ZJdI7q"
Date: Sun, 14 Oct 2007 11:42:58 +0200
Message-Id: <1192354978.4770.100.camel@johannes.berg> (sfid-20071014_104250_217330_CF2CD815)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+Mt9OE0SOucXm7ZJdI7q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-10-13 at 17:26 +0200, Michael Buesch wrote:

> I also saw this sometimes, but I have absolutely no idea how that happens=
.
> Someone any idea?

Nope, but adding more CCs :) I briefly looked at the code and couldn't
track it. Got a powerpc oops with disassembly?

> > b43-phy0 debug: Loading firmware version 351.126 (2006-07-29 05:54:02)
> > Registered led device: b43-phy0:tx
> > Registered led device: b43-phy0:rx
> > general protection fault: 0000 [1] SMP
> > CPU 0
> > Modules linked in: eeprom ircomm_tty ircomm af_packet snd_pcm_oss
> > snd_mixer_oss snd_seq snd_seq_device radeon drm cpufreq_conservative
> > cpufreq_userspace cpufreq _powersave powernow_k8 pcmcia snd_atiixp_mode=
m
> > arc4 snd_atiixp ecb blkcipher rc8 0211_simple snd_ac97_codec yenta_sock=
et
> > ac97_bus snd_pcm rsrc_nonstatic snd_time r snd pcmcia_core b43
> > firmware_class parport_pc ohci1394 ide_cd ssb rfkill mac80 211 rtc_cmos
> > irda crc_ccitt rtc_core k8temp rtc_lib cfg80211 led_class tifm_7xx1 out=
put
> > battery ac parport ieee1394 button cdrom tifm_core container soundcore =
s
> > nd_page_alloc tg3 hwmon joydev input_polldev i2c_piix4 serio_raw ide_di=
sk
> > ehci_h cd ohci_hcd usbcore radeonfb fb_ddc i2c_algo_bit i2c_core edd ex=
t3
> > mbcache jbd f an atiixp ide_core thermal processor
> > Pid: 2295, comm: NetworkManager Not tainted 2.6.23-rc9-default #1
> > RIP: 0010:[<ffffffff802f38aa>]  [<ffffffff802f38aa>] strcmp+0x0/0x1a
> > RSP: 0018:ffff810078fe5740  EFLAGS: 00010283
> > RAX: ffff81007d1f5f70 RBX: ffff81007d1f5f40 RCX: ffffffff80418988
> > RDX: ffffffff881ed3d0 RSI: ffffffff8048498b RDI: 66355f306e616c77
> > RBP: ffff81007da723a8 R08: 0000000000000000 R09: 0000000000000000
> > R10: ffffffff881ed3a0 R11: ffffffff803921b5 R12: ffff81007da72000
> > R13: 0000000000000001 R14: 0000000000000000 R15: 66355f306e616c77
> > FS:  0000000040800950(0063) GS:ffffffff804fc000(0000)
> > knlGS:0000000000000000 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003=
3
> > CR2: 0000000000616278 CR3: 0000000079556000 CR4: 00000000000006e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > Process NetworkManager (pid: 2295, threadinfo ffff810078fe4000, task
> > ffff810079f be040)
> > Stack:  ffffffff803861f8 ffff81007da723a8 ffff81007da723a8 000000000000=
0000
> >  ffffffff881ec218 ffff81007da72000 ffff81007da7240a ffff81007da723a0
> >  ffffffff882da4ba ffff810078fe57f8 0000000000000000 ffff81007d5802e0
> > Call Trace:
> >  [<ffffffff803861f8>] led_trigger_set_default+0x3a/0x77
> >  [<ffffffff881ec218>] :led_class:led_classdev_register+0xb9/0x10d
> >  [<ffffffff882da4ba>] :b43:b43_register_led+0x83/0xb6
> >  [<ffffffff882da750>] :b43:b43_leds_init+0x263/0x293
> >  [<ffffffff8828501d>] :ssb:ssb_pci_switch_core+0x40/0x4b
> >  [<ffffffff882cae47>] :b43:b43_chip_init+0x56c/0x8d6
> >  [<ffffffff882cb435>] :b43:b43_wireless_core_init+0x284/0x766
> >  [<ffffffff882cc585>] :b43:b43_start+0x2e/0x6d
> >  [<ffffffff8824d8e9>] :mac80211:ieee80211_open+0x1b6/0x39d
> >  [<ffffffff8039704a>] dev_open+0x2f/0x67
> >  [<ffffffff80395c8a>] dev_change_flags+0xaa/0x161
> >  [<ffffffff8039db81>] do_setlink+0x279/0x34b
> >  [<ffffffff8039e60b>] rtnetlink_rcv_msg+0x0/0x1dc
> >  [<ffffffff8039edcf>] rtnl_setlink+0xf5/0x116
> >  [<ffffffff803ab484>] netlink_run_queue+0x68/0xf7
> >  [<ffffffff8039e587>] rtnetlink_rcv+0x28/0x43
> >  [<ffffffff803aba04>] netlink_data_ready+0x12/0x50
> >  [<ffffffff803aa6fa>] netlink_sendskb+0x23/0x3c
> >  [<ffffffff803ab9df>] netlink_sendmsg+0x2ac/0x2bf
> >  [<ffffffff80391845>] memcpy_fromiovec+0x36/0x66
> >  [<ffffffff8038a98c>] sock_sendmsg+0xea/0x107
> >  [<ffffffff8024699f>] autoremove_wake_function+0x0/0x2e
> >  [<ffffffff8024699f>] autoremove_wake_function+0x0/0x2e
> >  [<ffffffff8024699f>] autoremove_wake_function+0x0/0x2e
> >  [<ffffffff8038abc0>] sys_sendmsg+0x217/0x28a
> >  [<ffffffff803aa9b8>] netlink_insert+0x13c/0x14b
> >  [<ffffffff8038bb35>] sys_getsockname+0x9c/0xb2
> >  [<ffffffff8020bc8e>] system_call+0x7e/0x83
> >
> >
> > Code: 8a 17 88 d0 2a 06 48 ff c6 84 c0 75 09 84 d2 74 05 48 ff c7
> > RIP  [<ffffffff802f38aa>] strcmp+0x0/0x1a
> >  RSP <ffff810078fe5740>
> > (none):~ #
>=20

--=-+Mt9OE0SOucXm7ZJdI7q
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARxHkoaVg1VMiehFYAQKXZQ/+J7hU6W6NDc5iWhqGZoP3PG0QJZX8lYLA
xm8pFllrXHfknDjXzyd6N8Sst44k9l+/80EZ3qGyAqYvHTe41et1lciQx+jYHVLW
+VDjNgiH5B5dUm8AYMhln4GHwkMGH8p51mv8HpXjrAmeZtLtBBwQoA1Ihddear4q
LnKNgaGuyMFsPhTdtGPRc4WFgXwbLV7bzsNhSpMyjg0BbVV+JzhsWmfRawCe42kj
PthZJzKty9wcUAhiEm05mExldskxYbmg1Htb2YH+0QY6rO//Zxqkev8Cuf3ktu7X
0rI3uOYZuqrXfs1RNj+3uDNewuhJCiEBKbjhl97mKkeZ6xW/vL9+D0kTGlad0omc
/deQDW8DKfZICTcqe7DmUEngNvpViNBtJDri31w4y2pk6TE8+1if7kAB1X1y1qSR
sMiZdWnWPEg5XGUxS4/1ULTgCHVkXHY0VWmCKXCTKPKmQ1KjTqFXsw86IvZ+yTYq
N2VaZIpe17IZ/84giHeE6zfi6ST78OCdMNT9IlV1wGbV4jWjuC93Jo2obB6fNtLu
VgW0GKFfSsgNps5a6zsawjibI6pMhq8rhnvAIGJVSrbmXtyt9DI1q9fYCVgyxxLQ
N9AVG+b0NS24gh6+zcAEJfTWiGZm3osT4B7Grk6aX78zubpfGWPqL76vxSD2KZma
GWY70GngsjM=
=I7AU
-----END PGP SIGNATURE-----

--=-+Mt9OE0SOucXm7ZJdI7q--

