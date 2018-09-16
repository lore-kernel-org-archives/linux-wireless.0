Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36492 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727663AbeIPPSB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Sep 2018 11:18:01 -0400
Date: Sun, 16 Sep 2018 11:55:35 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linuxwifi@intel.com
Subject: Re: 4.19-rc[23] iwlwifi: BUG in swiotlb
Message-ID: <20180916095535.GA4245@amd> (sfid-20180916_115545_988525_3D8DFD90)
References: <0c5e53e5-2afa-8d38-0b48-272c670c4bc5@infradead.org>
 <1536651177.3224.106.camel@sipsolutions.net>
 <20180916093414.GA4299@amd>
 <20180916094142.GB4299@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
In-Reply-To: <20180916094142.GB4299@amd>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > IO_TLB_SHIFT is 11, so we get 2k alignment, so even the smallest size
> > > (32*64) should result in nslots being 1?
> > >=20
> > > In fact, unless the driver passed *ZERO* as the size, this should nev=
er
> > > happen (hence the BUG_ON), since ALIGN() would take care of rounding =
up
> > > any smaller allocation here.
> > >=20
> > > Presumably you can reproduce this pretty easily (and I don't know what
> > > specific model of NIC you have etc.), so perhaps you can do something
> > > like this?
> > >=20
> > > https://p.sipsolutions.net/aa0dccd7a60fe176.txt
> >=20
> > That results in: ... if I'm not mistaken. Tested on top of today's
> > mainline. (-rc3.95 :-)
>=20
> Hold on. I was confused by my build system. Let me retry.
>=20
> Are you sure you are not mistaking WARN and WARN_ON?

I changed WARNs to printks, and yes, we seem to be pushing 0s where we
should not.

Looks simple to me...
								Pavel

[    6.307381] device-mapper: ioctl: error adding target to table
[    8.882203] e1000e: eth2 NIC Link is Up 100 Mbps Full Duplex, Flow Contr=
ol: Rx/Tx
[    8.882211] e1000e 0000:00:19.0 eth2: 10/100 speed: disabling TSO
[    9.850102] random: crng init done
[    9.850119] random: 7 urandom warning(s) missed due to ratelimiting
[   34.443033] iwlwifi 0000:03:00.0: RF_KILL bit toggled to enable radio.
[   34.443053] iwlwifi 0000:03:00.0: reporting RF_KILL (radio enabled)
[   34.467728] iwlwifi 0000:03:00.0: Radio type=3D0x0-0x0-0x3
[   34.468122] tfd_sz is 0 - tfh:0, slots:256, tfd_size:128, maxq:0
[   34.468129] ------------[ cut here ]------------
[   34.468132] kernel BUG at kernel/dma/swiotlb.c:521!
[   34.468156] invalid opcode: 0000 [#1] SMP PTI
[   34.468160] CPU: 0 PID: 3126 Comm: NetworkManager Not tainted 4.19.0-rc3=
 #8
[   34.468162] Hardware name: LENOVO 42872WU/42872WU, BIOS 8DET74WW (1.44 )=
 03/13/2018
[   34.468170] RIP: 0010:swiotlb_tbl_map_single+0x17f/0x2c0
[   34.468175] Code: 21 c6 49 89 f5 49 81 c5 ff 07 00 00 49 c1 ed 0b 48 83 =
f8 ff 0f 84 f2 fe ff ff 48 8d 90 00 08 00 00 48 c1 ea 0b e9 e2 fe ff ff <0f=
> 0b 42 8d 0c 3b 89 d8 39 cb 7d 12 48 63 d0 83 c0 01 39 c8 41 c7
[   34.468179] RSP: 0000:ffffc90000ab3070 EFLAGS: 00010246
[   34.468183] RAX: 00000000ffffffff RBX: 0000000000000000 RCX: 00000000000=
00000
[   34.468188] RDX: 0000000000200000 RSI: 00000000d699f000 RDI: ffff8801970=
d10a8
[   34.468190] RBP: ffffc90000ab30c8 R08: 0000000000000002 R09: 00000000000=
00000
[   34.468192] R10: 0000000000000034 R11: 303a7178616d2000 R12: 00000000000=
00001
[   34.468194] R13: 00000000001ad33e R14: 0000000000000000 R15: 00000000000=
00000
[   34.468196] FS:  0000000000000000(0000) GS:ffff88019e200000(0063) knlGS:=
00000000f70617c0
[   34.468199] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[   34.468201] CR2: 0000000008227c48 CR3: 0000000193a9e006 CR4: 00000000000=
606b0
[   34.468203] Call Trace:
[   34.468208]  ? dma_direct_alloc+0x6f/0x140
[   34.468212]  swiotlb_alloc+0x88/0x170
[   34.468216]  iwl_pcie_txq_alloc+0x2aa/0x450
[   34.468220]  iwl_pcie_tx_init+0x325/0x390
[   34.468223]  iwl_trans_pcie_start_fw+0x267/0x590
[   34.468228]  iwl_load_ucode_wait_alive+0xde/0x1b0
[   34.468231]  ? iwl_init_notification_wait+0x78/0x90
[   34.468235]  ? iwl_alloc_all+0x30/0x30
[   34.468239]  iwl_run_init_ucode+0xa3/0x130
[   34.468242]  ? iwl_run_init_ucode+0xa3/0x130
[   34.468246]  ? iwl_alive_notify+0x1b0/0x1b0
[   34.468251]  ? mutex_unlock+0xd/0x10
[   34.468254]  iwlagn_mac_start+0x112/0x200
[   34.468257]  ? iwlagn_mac_start+0x112/0x200
[   34.468262]  drv_start+0x2e/0x50
[   34.468267]  ieee80211_do_open+0x356/0x920
[   34.468270]  ? mutex_unlock+0xd/0x10
[   34.468274]  ieee80211_open+0x4e/0x60
[   34.468279]  __dev_open+0xba/0x130
[   34.468282]  __dev_change_flags+0x19c/0x200
[   34.468286]  ? __switch_to_asm+0x34/0x70
[   34.468289]  ? __switch_to_asm+0x40/0x70
[   34.468293]  dev_change_flags+0x24/0x60
[   34.468297]  do_setlink+0x2f4/0xce0
[   34.468301]  ? _raw_spin_unlock_irq+0x22/0x30
[   34.468304]  ? finish_task_switch+0xa3/0x250
[   34.468308]  ? finish_task_switch+0x76/0x250
[   34.468311]  ? __schedule+0x36c/0x830
[   34.468317]  ? blk_flush_plug_list+0xdd/0x250
[   34.468322]  ? nla_parse+0x36/0x130
[   34.468325]  rtnl_newlink+0x483/0x770
[   34.468330]  ? update_group_capacity+0x27/0x2f0
[   34.468333]  ? find_busiest_group+0x141/0xad0
[   34.468339]  ? cpumask_next_and+0x1d/0x20
[   34.468342]  ? load_balance+0x204/0xb80
[   34.468346]  ? find_held_lock+0x39/0xb0
[   34.468350]  ? find_held_lock+0x39/0xb0
[   34.468353]  ? __lock_acquire.isra.25+0x39e/0xa50
[   34.468358]  rtnetlink_rcv_msg+0x316/0x3e0
[   34.468362]  ? rtnl_calcit.isra.40+0x140/0x140
[   34.468366]  netlink_rcv_skb+0xcd/0x100
[   34.468369]  rtnetlink_rcv+0x10/0x20
[   34.468372]  netlink_unicast+0x179/0x210
[   34.468375]  netlink_sendmsg+0x307/0x3a0
[   34.468379]  sock_sendmsg+0x18/0x30
[   34.468382]  ___sys_sendmsg+0x2a5/0x2c0
[   34.468386]  ? sock_def_readable+0xce/0xe0
[   34.468392]  ? unix_dgram_sendmsg+0x46b/0x6a0
[   34.468396]  ? find_held_lock+0x39/0xb0
[   34.468401]  ? __fget+0x8a/0xd0
[   34.468405]  ? __fget+0xa2/0xd0
[   34.468408]  __sys_sendmsg+0x63/0xa0
[   34.468411]  ? __sys_sendmsg+0x63/0xa0
[   34.468415]  __ia32_compat_sys_socketcall+0xde/0x220
[   34.468418]  ? __ia32_compat_sys_time+0x10/0x40
[   34.468424]  do_int80_syscall_32+0x50/0x100
[   34.468428]  entry_INT80_compat+0x7d/0x82
[   34.468431] RIP: 0023:0xf7fb6c42
[   34.468434] Code: 65 8b 15 04 00 00 00 8b 0e 8b 0c ca 83 f9 ff 75 0c 89 =
04 24 89 f0 e8 b3 fe ff ff eb 05 8b 46 04 01 c8 83 c4 14 5b 5e c3 cd 80 <c3=
> 8d b6 00 00 00 00 8d bc 27 00 00 00 00 8b 1c 24 c3 8d b6 00 00
[   34.468436] RSP: 002b:00000000ff93a304 EFLAGS: 00200293 ORIG_RAX: 000000=
0000000066
[   34.468440] RAX: ffffffffffffffda RBX: 0000000000000010 RCX: 00000000ff9=
3a310
[   34.468442] RDX: 00000000f7c27000 RSI: 0000000000000000 RDI: 00000000081=
ae170
[   34.468444] RBP: 00000000081b8080 R08: 0000000000000000 R09: 00000000000=
00000
[   34.468446] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000000=
00000
[   34.468448] R13: 0000000000000000 R14: 0000000000000000 R15: 00000000000=
00000
[   34.468451] Modules linked in:
[   34.468457] ---[ end trace 301c76c6cfaad410 ]---
[   34.468462] RIP: 0010:swiotlb_tbl_map_single+0x17f/0x2c0
[   34.468466] Code: 21 c6 49 89 f5 49 81 c5 ff 07 00 00 49 c1 ed 0b 48 83 =
f8 ff 0f 84 f2 fe ff ff 48 8d 90 00 08 00 00 48 c1 ea 0b e9 e2 fe ff ff <0f=
> 0b 42 8d 0c 3b 89 d8 39 cb 7d 12 48 63 d0 83 c0 01 39 c8 41 c7
[   34.468469] RSP: 0000:ffffc90000ab3070 EFLAGS: 00010246
[   34.468472] RAX: 00000000ffffffff RBX: 0000000000000000 RCX: 00000000000=
00000
[   34.468474] RDX: 0000000000200000 RSI: 00000000d699f000 RDI: ffff8801970=
d10a8
[   34.468476] RBP: ffffc90000ab30c8 R08: 0000000000000002 R09: 00000000000=
00000
[   34.468478] R10: 0000000000000034 R11: 303a7178616d2000 R12: 00000000000=
00001
[   34.468480] R13: 00000000001ad33e R14: 0000000000000000 R15: 00000000000=
00000
[   34.468483] FS:  0000000000000000(0000) GS:ffff88019e200000(0063) knlGS:=
00000000f70617c0
[   34.468486] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[   34.468488] CR2: 0000000008227c48 CR3: 0000000193a9e006 CR4: 00000000000=
606b0
[   34.928276] usb 1-1.4: new full-speed USB device number 5 using ehci-pci
[   35.043018] usb 1-1.4: New USB device found, idVendor=3D0a5c, idProduct=
=3D217f, bcdDevice=3D 7.48
[   35.043032] usb 1-1.4: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D3
[   35.043040] usb 1-1.4: Product: Broadcom Bluetooth Device
[   35.043046] usb 1-1.4: Manufacturer: Broadcom Corp
[   35.043052] usb 1-1.4: SerialNumber: 7CE9D3B855AA




--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlueKJcACgkQMOfwapXb+vIfIQCfRv5dNtUIxR6Bw23x6hX+/+Ph
lY8AoMR/faTpMglZBYbk0S3qjvHj1aMK
=oli8
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
