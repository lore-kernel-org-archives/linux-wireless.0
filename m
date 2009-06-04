Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34609 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbZFDJDV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2009 05:03:21 -0400
Subject: Re: [RFT 1/3] iwlwifi: port to cfg80211 rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1244063570.17790.203.camel@rc-desk>
References: <20090602111027.460530075@sipsolutions.net>
	 <20090602111111.956543636@sipsolutions.net>
	 <1244063570.17790.203.camel@rc-desk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-mlxQEE6KrrZw8BxzZaGu"
Date: Thu, 04 Jun 2009 11:03:16 +0200
Message-Id: <1244106196.22576.65.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mlxQEE6KrrZw8BxzZaGu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Reinette,

Thanks for the comprehensive test.

> * I tried this patch on top of latest wireless-testing (rc8 based) on a
> Sony laptop. After I bring the interface up I enabled rfkill and saw a
> gpf in the sony-laptop module (log is below). I tried this test many
> times after this and did not see this gpf again.
>=20
> * I tried to load the modules with rfkill enabled and then disabled
> rfkill after interface up - that worked fine.
>=20
> * In another test I had rfkill disabled and successfully associated with
> AP. I then enabled rfkill and was disassociated as expected. I then
> disabled rfkill again and used "iwconfig" to reassociate successfully.=20
>=20
> * In another test rfkill was disabled and I associated with AP. I then
> enabled and disabled rfkill rapidly and did not loose association.
>=20
> In summary the testing went very well. There was that one gpf that
> clouded the testing a bit. I have no idea how it can be connected to the
> rfkill work though because the error appear to be contained in the
> sony-laptop module.

That looks like an error in sony-laptop, indeed. Should we go ahead with
the iwlwifi part then?

> [  709.366404] general protection fault: 0000 [#1] SMP=20
> [  709.366551] last sysfs file: /sys/class/rfkill/rfkill5/state
> [  709.366616] CPU 1=20

> [  709.369182] Pid: 66, comm: kacpi_notify Not tainted 2.6.30-rc8-wl #40 =
VGN-Z540N
> [  709.369182] RIP: 0010:[<ffffffffa0200dda>]  [<ffffffffa0200dda>] sony_=
nc_rfkill_set+0xa/0x40 [sony_laptop]
> [  709.369182] RSP: 0018:ffff8800bb663dc0  EFLAGS: 00010286
> [  709.369182] RAX: 0000000000000001 RBX: 0000000000000000 RCX: 000000000=
0000001
> [  709.369182] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff88003=
6f74480
> [  709.369182] RBP: ffff8800bb663dd0 R08: 0000000000000000 R09: 000000000=
0000000
> [  709.369182] R10: 0000000000000001 R11: 0000000000000001 R12: 000000000=
0000000
> [  709.369182] R13: 0000000000000000 R14: 0000000000000000 R15: ffff8800b=
b663df0
> [  709.369182] FS:  0000000000000000(0000) GS:ffff88000105e000(0000) knlG=
S:0000000000000000
> [  709.369182] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> [  709.369182] CR2: 00007ffff2051000 CR3: 00000000ba6b6000 CR4: 000000000=
00006e0
> [  709.369182] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
> [  709.369182] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 000000000=
0000400
> [  709.369182] Process kacpi_notify (pid: 66, threadinfo ffff8800bb662000=
, task ffff8800bb658f40)
> [  709.369182] Stack:
> [  709.369182]  0000000000000000 0000000000000000 ffff8800bb663e20 ffffff=
ffa0203292
> [  709.369182]  ffff8800bb659548 0000000000000246 0000000000000202 ffff88=
00b729e2f8
> [  709.369182]  ffff8800b5371898 ffff8800bb658f40 ffff880001058ec0 ffffff=
ff803b5596
> [  709.369182] Call Trace:
> [  709.369182]  [<ffffffffa0203292>] sony_nc_notify+0x222/0x260 [sony_lap=
top]
> [  709.369182]  [<ffffffff803b5596>] ? acpi_os_execute_deferred+0x0/0x39
> [  709.369182]  [<ffffffff803b8192>] acpi_device_notify+0x14/0x16

I wonder if sony has a race condition somewhere against itself.

johannes

--=-mlxQEE6KrrZw8BxzZaGu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKJ43RAAoJEODzc/N7+QmaNGoP/3duPF6ru6KPR5mVnAWvEVr9
XooEiwEI+wopg28cctSXmOMiCKFgXg2zQp+RZiKY/FeUaW67n2xIrPnHqKrtcUtA
DtIBZ7lsToFVIubW6jmbDaoVhMrcQEk9etKAej/BNyvxawS0SeXELt2c7tAeNJ0U
3ZW5E2P4VK101BY5kptf6zcMXUxkMUQkHgcs/JMM73tVn/0z/qwDSGCycjLfesc3
rU0YT4IrlqvQBHzxYCXiV1yx/F3a0yDCOxAlXov3Zs7OEDwnuAYisEft+qJ1K3xd
DAwrhA8dEV+mM36HHmrbsoNGcYYzlRkYr+sqK6/6yOuH2273PSQcWTFotGajbznL
GygdtUzBpE0ibLgnkEXPqNmCFiq2ofCkZ2uhWHMiJ8Zn4kE/nt1ZPlpC6flxxbgi
6x+MA2/Y14xqZD8iYo2a8Uvnw+QnzM17D1t4OSDp0OV/xlohHMCLskuFKKuHJJLk
KfrkipKR81QDKRi61b4HUhHE2aJq8jOUY6Br6+YTKYIXJYZyB1/wJLVomy8Q66kT
Zpey8hij3U8P5Ma+OPMM/3Ansdf2+tEy/VsT1qQD0Z/tV0fLmF7hOWhVichq+Nvx
5m8g4ebS48sgKzTLMkQCeh53obqVq7j7Iw6nITa5slO7Ty0MwLWvmphCKHIFZTtp
QnphIjX7SwM7qI3l9F46
=byHm
-----END PGP SIGNATURE-----

--=-mlxQEE6KrrZw8BxzZaGu--

