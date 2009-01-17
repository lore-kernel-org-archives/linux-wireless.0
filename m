Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from flock1.newmail.ru ([82.204.219.207]:39180 "HELO
	flock1.newmail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758562AbZAQPWx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Jan 2009 10:22:53 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: [PATCH] [2.6.29-rc2] orinoco: use GFP_ATOMIC in kmalloc in orinoco_ioctl_set_genie
Date: Sat, 17 Jan 2009 18:22:43 +0300
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3586920.UGEu2y5suV";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200901171822.45476.arvidjaar@mail.ru> (sfid-20090117_162259_362460_ADC269D5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3586920.UGEu2y5suV
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Subject: [PATCH] [2.6.29-rc2] orinoco: use GFP_ATOMIC in kmalloc in=20
orinoco_ioctl_set_genie
=46rom: Andrey Borzenkov <arvidjaar@mail.ru>

kmalloc is called with interrupt disabled and may not sleep. This
fixes this BUG:

[   56.923623] BUG: sleeping function called from invalid context at=20
/home/bor/src/linux-git/mm/slub.c:1599
[   56.923644] in_atomic(): 0, irqs_disabled(): 1, pid: 3031, name:=20
wpa_supplicant
[   56.923656] 2 locks held by wpa_supplicant/3031:
[   56.923662]  #0:  (rtnl_mutex){--..}, at: [<c02abd1f>] rtnl_lock+0xf/0x20
[   56.923703]  #1:  (&priv->lock){++..}, at: [<dfc840c2>]=20
orinoco_ioctl_set_genie+0x52/0x130 [orinoco]
[   56.923782] irq event stamp: 910
[   56.923788] hardirqs last  enabled at (909): [<c01957db>]=20
__kmalloc+0x7b/0x140
[   56.923820] hardirqs last disabled at (910): [<c0309419>]=20
_spin_lock_irqsave+0x19/0x80
[   56.923847] softirqs last  enabled at (880): [<c0124f54>]=20
__do_softirq+0xc4/0x110
[   56.923865] softirqs last disabled at (871): [<c01049ae>]=20
do_softirq+0x8e/0xe0
[   56.923895] Pid: 3031, comm: wpa_supplicant Not tainted 2.6.29-rc2-1avb=
=20
#1
[   56.923905] Call Trace:
[   56.923919]  [<c01049ae>] ? do_softirq+0x8e/0xe0
[   56.923941]  [<c011ad12>] __might_sleep+0xd2/0x100
[   56.923952]  [<c0195837>] __kmalloc+0xd7/0x140
[   56.923963]  [<c030946a>] ? _spin_lock_irqsave+0x6a/0x80
[   56.923981]  [<dfc840e9>] ? orinoco_ioctl_set_genie+0x79/0x130 [orinoco]
[   56.923999]  [<dfc840c2>] ? orinoco_ioctl_set_genie+0x52/0x130 [orinoco]
[   56.924017]  [<dfc840e9>] orinoco_ioctl_set_genie+0x79/0x130 [orinoco]
[   56.924036]  [<c0209325>] ? copy_from_user+0x35/0x130
[   56.924061]  [<c02ffd96>] ioctl_standard_call+0x196/0x380
[   56.924085]  [<c029f945>] ? __dev_get_by_name+0x85/0xb0
[   56.924096]  [<c02ff88f>] wext_handle_ioctl+0x14f/0x230
[   56.924113]  [<dfc84070>] ? orinoco_ioctl_set_genie+0x0/0x130 [orinoco]
[   56.924132]  [<c02a3da5>] dev_ioctl+0x495/0x570
[   56.924155]  [<c0293e05>] ? sys_sendto+0xa5/0xd0
[   56.924171]  [<c0142fe8>] ? mark_held_locks+0x48/0x90
[   56.924183]  [<c0292880>] ? sock_ioctl+0x0/0x280
[   56.924193]  [<c029297d>] sock_ioctl+0xfd/0x280
[   56.924203]  [<c0292880>] ? sock_ioctl+0x0/0x280
[   56.924235]  [<c01a51d0>] vfs_ioctl+0x20/0x80
[   56.924246]  [<c01a53e2>] do_vfs_ioctl+0x72/0x570
[   56.924257]  [<c0293e62>] ? sys_send+0x32/0x40
[   56.924268]  [<c02947c0>] ? sys_socketcall+0x1d0/0x2a0
[   56.924280]  [<c010339f>] ? sysenter_exit+0xf/0x16
[   56.924292]  [<c01a5919>] sys_ioctl+0x39/0x70
[   56.924302]  [<c0103371>] sysenter_do_call+0x12/0x31

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>

=2D--

Why did not we see it before?

 drivers/net/wireless/orinoco/orinoco.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/net/wireless/orinoco/orinoco.c=20
b/drivers/net/wireless/orinoco/orinoco.c
index c3bb85e..779ab10 100644
=2D-- a/drivers/net/wireless/orinoco/orinoco.c
+++ b/drivers/net/wireless/orinoco/orinoco.c
@@ -5079,7 +5079,7 @@ static int orinoco_ioctl_set_genie(struct net_device=
=20
*dev,
 		return -EBUSY;
=20
 	if (wrqu->data.length) {
=2D		buf =3D kmalloc(wrqu->data.length, GFP_KERNEL);
+		buf =3D kmalloc(wrqu->data.length, GFP_ATOMIC);
 		if (buf =3D=3D NULL) {
 			err =3D -ENOMEM;
 			goto out;


--nextPart3586920.UGEu2y5suV
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklx98UACgkQR6LMutpd94xM+QCeOAwYsZpTGPnEvfH8RoE1dOdL
x/QAnAwIESwhuqaa0/h1a94v1X3XR/6k
=5wgW
-----END PGP SIGNATURE-----

--nextPart3586920.UGEu2y5suV--
