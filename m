Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34485 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbYJNPVs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 11:21:48 -0400
Subject: Re: [PATCH v2] iwlwifi: fix DMA code and bugs
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>
In-Reply-To: <1223309405.15196.32.camel@johannes.berg> (sfid-20081006_181043_313891_E9288151)
References: <1223308831.15196.28.camel@johannes.berg>
	 (sfid-20081006_180110_939098_1A64839A)  <1223309405.15196.32.camel@johannes.berg>
	 (sfid-20081006_181043_313891_E9288151)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ogVEtrxney4qiM9HAYkX"
Date: Tue, 14 Oct 2008 17:21:08 +0200
Message-Id: <1223997668.10113.40.camel@johannes.berg> (sfid-20081014_172216_586877_646399AB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ogVEtrxney4qiM9HAYkX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-06 at 18:10 +0200, Johannes Berg wrote:
> This patch cleans up the DMA code to be understandable and not
> completely wrong. In particular:
>  * there is no need to have a weird iwl_tfd_frame_data struct that is
>    used 10 times, just use an address struct 20 times
>  * therefore, all the is_odd junk goes away
>  * fix a bug in iwl_hcmd_queue_reclaim where it would reclaim all the
>    fragments of a descriptor rather than all descriptors (this may be
>    the cause of the dma unmapping problem I reported)
>  * some more cleanups
>=20
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> Tested on 5000 hw, please apply.
>=20
> v2: fixes small issue with getting rid of iwl_get_dma_hi_address.

John, can you apply this? I keep getting invalid frees, or double-frees
without this patch.

[ 1831.106142] iommu_free: invalid entry
[ 1831.106207] 	free_entry=3D 0xb0040
[ 1831.106213] 	npages    =3D 0x1
[ 1831.106219] 	entry     =3D 0xb0040
[ 1831.106225] 	dma_addr  =3D 0xb0040100
[ 1831.106231] 	Table     =3D 0xc00000000083f348
[ 1831.106238] 	bus#      =3D 0x0
[ 1831.106244] 	size      =3D 0x80000
[ 1831.106249] 	startOff  =3D 0x0
[ 1831.106255] 	index     =3D 0x0
[ 1831.106266] ------------[ cut here ]------------
[ 1831.106273] Badness at arch/powerpc/kernel/iommu.c:260
[ 1831.106281] NIP: c000000000021a8c LR: c000000000021a88 CTR: c00000000004=
7354
[ 1831.106291] REGS: c00000000080b140 TRAP: 0700   Tainted: G        W  (2.=
6.27-wl-03370-gea51ef8-dirty)
[ 1831.106299] MSR: 9000000000029032 <EE,ME,IR,DR>  CR: 44004084  XER: 0000=
0000
[ 1831.106337] TASK =3D c000000000773340[0] 'swapper' THREAD: c000000000808=
000 CPU: 0
[ 1831.106348] GPR00: c000000000021a88 c00000000080b3c0 c00000000080cd98 00=
00000000000023=20
[ 1831.106373] GPR04: 0000000000000001 c00000000003e10c 0000000000000000 00=
00000000000002=20
[ 1831.106397] GPR08: 0000000000000000 c000000000808000 0000000000000000 00=
00000000000001=20
[ 1831.106422] GPR12: 00000000000186a0 c00000000083c300 c0000000005b6b00 c0=
00000000503a98=20
[ 1831.106446] GPR16: 0000000000000000 c00000020dc25ca8 c000000000808000 c0=
0000020dc25cc0=20
[ 1831.106471] GPR20: 0000000000000001 c00000020dc31d80 0000000000000064 00=
00000000000008=20
[ 1831.106496] GPR24: c00000020dc31d80 c00000020dc34008 00000000b0040100 00=
00000000000001=20
[ 1831.106520] GPR28: c00000000083f348 00000000000b0040 c00000000079dae0 00=
000000000b0040=20
[ 1831.106556] NIP [c000000000021a8c] .__iommu_free+0x104/0x170
[ 1831.106566] LR [c000000000021a88] .__iommu_free+0x100/0x170
[ 1831.106573] Call Trace:
[ 1831.106582] [c00000000080b3c0] [c000000000021a88] .__iommu_free+0x100/0x=
170 (unreliable)
[ 1831.106600] [c00000000080b460] [c000000000021b50] .iommu_free+0x58/0xc0
[ 1831.106615] [c00000000080b500] [c00000000002188c] .dma_iommu_unmap_singl=
e+0x14/0x28
[ 1831.106655] [c00000000080b570] [d000000000377c7c] .iwl_tx_cmd_complete+0=
x35c/0x408 [iwlcore]
[ 1831.106689] [c00000000080b620] [d00000000033c788] .iwl_rx_handle+0x334/0=
x4a8 [iwlagn]
[ 1831.106716] [c00000000080b720] [d00000000033d278] .iwl4965_irq_tasklet+0=
x97c/0xccc [iwlagn]
[ 1831.106732] [c00000000080b7e0] [c0000000000551dc] .tasklet_action+0x14c/=
0x244
[ 1831.106746] [c00000000080b890] [c0000000000560cc] .__do_softirq+0xd8/0x1=
c4
[ 1831.106761] [c00000000080b940] [c00000000000c298] .do_softirq+0x5c/0xb8
[ 1831.106774] [c00000000080b9c0] [c000000000055b08] .irq_exit+0x74/0xe0
[ 1831.106788] [c00000000080ba40] [c00000000000c3fc] .do_IRQ+0x108/0x14c
[ 1831.106802] [c00000000080bad0] [c000000000004794] hardware_interrupt_ent=
ry+0x1c/0x20
[ 1831.106819] --- Exception: 501 at .cpu_idle+0x118/0x200
[ 1831.106821]     LR =3D .cpu_idle+0x118/0x200
[ 1831.106831] [c00000000080bdc0] [c000000000011ea8] .cpu_idle+0xd0/0x200 (=
unreliable)
[ 1831.106852] [c00000000080be60] [c0000000003eeaec] .rest_init+0x8c/0xa4
[ 1831.106868] [c00000000080bee0] [c000000000587bc0] .start_kernel+0x4a0/0x=
4c8
[ 1831.106882] [c00000000080bf90] [c000000000007568] .start_here_common+0x3=
c/0x54
[ 1831.106893] Instruction dump:
[ 1831.106903] e89c0008 e87e8060 483d29ed 60000000 e89c0010 e87e8068 483d29=
dd 60000000=20
[ 1831.106971] e87e8070 e89c0020 483d29cd 60000000 <0fe00000> 48000040 e93e=
8078 7fe4fb78=20


--=-ogVEtrxney4qiM9HAYkX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI9LjhAAoJEKVg1VMiehFY9X0P/i7TN0mTKjD4Iya/DXbpctBC
fzFAAP/AuBirttSI75RceGbbl5LncCtQb+9kc95c2byxpJ/f7mIsdq2Tdpknv+94
V4YhYiS1HAMAKrqWEHwgviepxAffmhReL6rfSpu9DgpDYjS1SWcHwZ4E4rawjNbA
99pCslWWkDeiNottVTeafT3k2BsHukwB1jDHpW+BzzXBqv8tMoqA1QXefKFDZ/ph
0ZwKuIAhR/AtalR9lm7KEt7lJVKCqUTe/lWfIOQWge8yVy9/zcppsnnjREvxBXvN
iJCMPNVgJ6S0/k1HUcK3aLLbcX0dv11JldqKoEDMTb18jagAJEMSqM5bUSdZbzxi
bzWRigkzqJcG1A0Hgf2CA9iVZEbNzPLVHMhS0rkPqwkVo/Xnr7UtBxsgAhulhtUT
v7ecij2+Gf0dmEZW56oCoe1Shi3BNO0wUF8gsHeC3iqx9naPyVKgPENqqiUKFAuL
Dg+iKDwAijDlCMwvfRQuOg5bAHKWqjn3m75+3PV+3XTfAPo4s11xVCcit5MSikw4
VQvuSo5fHnMKJkF0Byj9+8Hy37CihfzoOXFjp+AcNu9Rg1SOZOR7qZ9/ObLhg3RJ
xFSO157IP/wuCb9vad6Q/xTqVQ6ica4ar0wH9mKH801ejLjI+0/1XcRjEXU8DX7h
UY7PF44nebipsdpoj6Xl
=ujed
-----END PGP SIGNATURE-----

--=-ogVEtrxney4qiM9HAYkX--

