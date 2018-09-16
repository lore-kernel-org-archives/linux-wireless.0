Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36010 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727391AbeIPO4f (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Sep 2018 10:56:35 -0400
Date: Sun, 16 Sep 2018 11:34:14 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linuxwifi@intel.com
Subject: Re: 4.19-rc[23] iwlwifi: BUG in swiotlb
Message-ID: <20180916093414.GA4299@amd> (sfid-20180916_113424_947034_18C826C6)
References: <0c5e53e5-2afa-8d38-0b48-272c670c4bc5@infradead.org>
 <1536651177.3224.106.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
In-Reply-To: <1536651177.3224.106.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > Any ideas?
>=20
> Hmm. Is this new?
>=20
> > 2018-09-10T18:47:54.532837-07:00 dragon kernel: [   31.472371] kernel B=
UG at ../kernel/dma/swiotlb.c:521!
>=20
>         nslots =3D ALIGN(size, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
> 	[...]
> 	BUG_ON(!nslots)
>=20
> > 2018-09-10T18:47:54.613655-07:00 dragon kernel: [   31.490325]  swiotlb=
_alloc+0x88/0x170
> > 2018-09-10T18:47:54.613656-07:00 dragon kernel: [   31.490329]  ? __kma=
lloc+0x1cc/0x200
> > 2018-09-10T18:47:54.613657-07:00 dragon kernel: [   31.491652]  iwl_pci=
e_txq_alloc+0x1d4/0x3b0 [iwlwifi]
>=20
> There are two calls to dma_alloc_coherent() here, should those even hit
> swiotlb? The sizes of those should be
>  * 256 x 128 (32k)
>  * 32 x 256 (8k) [TFH, unlikely to be the case here]
>  * 256 x 256 (65k) [TFH]
>  * 32 x 64 (2k)
>  * 256 x 64 (16k)
>=20
>=20
> IO_TLB_SHIFT is 11, so we get 2k alignment, so even the smallest size
> (32*64) should result in nslots being 1?
>=20
> In fact, unless the driver passed *ZERO* as the size, this should never
> happen (hence the BUG_ON), since ALIGN() would take care of rounding up
> any smaller allocation here.
>=20
> Presumably you can reproduce this pretty easily (and I don't know what
> specific model of NIC you have etc.), so perhaps you can do something
> like this?
>=20
> https://p.sipsolutions.net/aa0dccd7a60fe176.txt

That results in: ... if I'm not mistaken. Tested on top of today's
mainline. (-rc3.95 :-)

[    9.318335] e1000e: eth2 NIC Link is Up 100 Mbps Full Duplex, Flow Contr=
ol: Rx/Tx
[    9.318342] e1000e 0000:00:19.0 eth2: 10/100 speed: disabling TSO
[   10.078165] random: crng init done
[   10.078170] random: 7 urandom warning(s) missed due to ratelimiting
[   89.607425] iwlwifi 0000:03:00.0: RF_KILL bit toggled to enable radio.
[   89.609870] iwlwifi 0000:03:00.0: reporting RF_KILL (radio enabled)
[   89.634418] iwlwifi 0000:03:00.0: Radio type=3D0x0-0x0-0x3
[   89.635668] ------------[ cut here ]------------
[   89.636445] kernel BUG at kernel/dma/swiotlb.c:521!
[   89.637220] invalid opcode: 0000 [#1] SMP PTI
[   89.637937] CPU: 1 PID: 3126 Comm: NetworkManager Not tainted 4.19.0-rc3=
 #7
[   89.638665] Hardware name: LENOVO 42872WU/42872WU, BIOS 8DET74WW (1.44 )=
 03/13/2018
[   89.639415] RIP: 0010:swiotlb_tbl_map_single+0x17f/0x2c0
[   89.640147] Code: 21 c6 49 89 f5 49 81 c5 ff 07 00 00 49 c1 ed 0b 48 83 =
f8 ff 0f 84 f2 fe ff ff 48 8d 90 00 08 00 00 48 c1 ea 0b e9 e2 fe ff ff <0f=
> 0b 42 8d 0c 3b 89 d8 39 cb 7d 12 48 63 d0 83 c0 01 39 c8 41 c7
[   89.641746] RSP: 0000:ffffc9000092f070 EFLAGS: 00010246
[   89.642560] RAX: 00000000ffffffff RBX: 0000000000000000 RCX: 00000000000=
00000
[   89.643399] RDX: 0000000000200000 RSI: 00000000d699f000 RDI: ffff8801970=
960a8
[   89.644235] RBP: ffffc9000092f0c8 R08: 0000000000000002 R09: 00000000000=
00000
[   89.645080] R10: 0000000000000034 R11: 0000000000000000 R12: 00000000000=
00001
[   89.645917] R13: 00000000001ad33e R14: 0000000000000000 R15: 00000000000=
00000
[   89.646750] FS:  0000000000000000(0000) GS:ffff88019e240000(0063) knlGS:=
00000000f70437c0
[   89.647599] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[   89.648442] CR2: 0000000056767120 CR3: 00000001938fa003 CR4: 00000000000=
606a0
[   89.649302] Call Trace:
[   89.650150]  ? dma_direct_alloc+0x6f/0x140
[   89.651001]  swiotlb_alloc+0x88/0x170
[   89.651838]  iwl_pcie_txq_alloc+0x205/0x420
[   89.652669]  ? iwl_pcie_tx_init+0x28d/0x390
[   89.653502]  iwl_pcie_tx_init+0x325/0x390
[   89.654338]  iwl_trans_pcie_start_fw+0x267/0x590
[   89.655185]  iwl_load_ucode_wait_alive+0xde/0x1b0
[   89.656024]  ? iwl_init_notification_wait+0x78/0x90
[   89.656865]  ? iwl_alloc_all+0x30/0x30
[   89.657701]  iwl_run_init_ucode+0xa3/0x130
[   89.658528]  ? iwl_run_init_ucode+0xa3/0x130
[   89.659352]  ? iwl_alive_notify+0x1b0/0x1b0
[   89.660167]  ? mutex_unlock+0xd/0x10
[   89.660975]  iwlagn_mac_start+0x112/0x200
[   89.661785]  ? iwlagn_mac_start+0x112/0x200
[   89.662600]  drv_start+0x2e/0x50
[   89.663424]  ieee80211_do_open+0x356/0x920
[   89.664230]  ? mutex_unlock+0xd/0x10
[   89.665027]  ieee80211_open+0x4e/0x60
[   89.665809]  __dev_open+0xba/0x130
[   89.666572]  __dev_change_flags+0x19c/0x200
[   89.667330]  ? __switch_to_asm+0x34/0x70
[   89.668070]  ? __switch_to_asm+0x40/0x70
[   89.668800]  dev_change_flags+0x24/0x60
[   89.669518]  do_setlink+0x2f4/0xce0
[   89.670216]  ? _raw_spin_unlock_irq+0x22/0x30
[   89.670933]  ? finish_task_switch+0xa3/0x250
[   89.671631]  ? finish_task_switch+0x76/0x250
[   89.672322]  ? __schedule+0x36c/0x830
[   89.673006]  ? blk_flush_plug_list+0xdd/0x250
[   89.673694]  ? nla_parse+0x36/0x130
[   89.674374]  rtnl_newlink+0x483/0x770
[   89.675061]  ? update_group_capacity+0x27/0x2f0
[   89.675735]  ? find_busiest_group+0x141/0xad0
[   89.676398]  ? find_held_lock+0x39/0xb0
[   89.677044]  ? load_balance+0x709/0xb80
[   89.677647]  ? find_held_lock+0x39/0xb0
[   89.678200]  ? cache_alloc_refill+0x4c1/0xc80
[   89.678735]  ? find_held_lock+0x39/0xb0
[   89.679265]  ? __lock_acquire.isra.25+0x39e/0xa50
[   89.679786]  rtnetlink_rcv_msg+0x316/0x3e0
[   89.680290]  ? rtnl_calcit.isra.40+0x140/0x140
[   89.680792]  netlink_rcv_skb+0xcd/0x100
[   89.681291]  rtnetlink_rcv+0x10/0x20
[   89.681779]  netlink_unicast+0x179/0x210
[   89.682253]  netlink_sendmsg+0x307/0x3a0
[   89.682713]  sock_sendmsg+0x18/0x30
[   89.683168]  ___sys_sendmsg+0x2a5/0x2c0
[   89.683619]  ? find_held_lock+0x39/0xb0
[   89.684071]  ? find_held_lock+0x39/0xb0
[   89.684511]  ? __fget+0x8a/0xd0
[   89.684947]  ? __fget+0xa2/0xd0
[   89.685377]  __sys_sendmsg+0x63/0xa0
[   89.685804]  ? __sys_sendmsg+0x63/0xa0
[   89.686232]  __ia32_compat_sys_socketcall+0xde/0x220
[   89.686660]  do_int80_syscall_32+0x50/0x100
[   89.687099]  entry_INT80_compat+0x7d/0x82
[   89.687527] RIP: 0023:0xf7f98c42
[   89.687950] Code: 65 8b 15 04 00 00 00 8b 0e 8b 0c ca 83 f9 ff 75 0c 89 =
04 24 89 f0 e8 b3 fe ff ff eb 05 8b 46 04 01 c8 83 c4 14 5b 5e c3 cd 80 <c3=
> 8d b6 00 00 00 00 8d bc 27 00 00 00 00 8b 1c 24 c3 8d b6 00 00
[   89.688990] RSP: 002b:00000000ff933894 EFLAGS: 00200293 ORIG_RAX: 000000=
0000000066
[   89.689535] RAX: ffffffffffffffda RBX: 0000000000000010 RCX: 00000000ff9=
338a0
[   89.690093] RDX: 00000000f7c09000 RSI: 0000000000000000 RDI: 00000000081=
ae170
[   89.690653] RBP: 0000000008248118 R08: 0000000000000000 R09: 00000000000=
00000
[   89.691226] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000000=
00000
[   89.691792] R13: 0000000000000000 R14: 0000000000000000 R15: 00000000000=
00000
[   89.692354] Modules linked in:
[   89.692929] ---[ end trace 3906e4f171da79b4 ]---
[   89.693651] RIP: 0010:swiotlb_tbl_map_single+0x17f/0x2c0
[   89.693653] Code: 21 c6 49 89 f5 49 81 c5 ff 07 00 00 49 c1 ed 0b 48 83 =
f8 ff 0f 84 f2 fe ff ff 48 8d 90 00 08 00 00 48 c1 ea 0b e9 e2 fe ff ff <0f=
> 0b 42 8d 0c 3b 89 d8 39 cb 7d 12 48 63 d0 83 c0 01 39 c8 41 c7
[   89.693654] RSP: 0000:ffffc9000092f070 EFLAGS: 00010246
[   89.693656] RAX: 00000000ffffffff RBX: 0000000000000000 RCX: 00000000000=
00000
[   89.693657] RDX: 0000000000200000 RSI: 00000000d699f000 RDI: ffff8801970=
960a8
[   89.693666] RBP: ffffc9000092f0c8 R08: 0000000000000002 R09: 00000000000=
00000
[   89.693667] R10: 0000000000000034 R11: 0000000000000000 R12: 00000000000=
00001
[   89.693668] R13: 00000000001ad33e R14: 0000000000000000 R15: 00000000000=
00000
[   89.693670] FS:  0000000000000000(0000) GS:ffff88019e240000(0063) knlGS:=
00000000f70437c0
[   89.693671] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[   89.693672] CR2: 0000000056767120 CR3: 00000001938fa003 CR4: 00000000000=
606a0
[   90.235267] usb 1-1.4: new full-speed USB device number 5 using ehci-pci
[   90.349748] usb 1-1.4: New USB device found, idVendor=3D0a5c, idProduct=
=3D217f, bcdDevice=3D 7.48
[   90.351888] usb 1-1.4: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D3
[   90.353967] usb 1-1.4: Product: Broadcom Bluetooth Device
[   90.356097] usb 1-1.4: Manufacturer: Broadcom Corp
[   90.356794] usb 1-1.4: SerialNumber: 7CE9D3B855AA


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlueI5UACgkQMOfwapXb+vJYDACgxAz+24cPahXrHtrd6Zj7Rget
k6YAoL0rqTyUyIRUPs+GbVl6HsNhkRwt
=OwZ4
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
