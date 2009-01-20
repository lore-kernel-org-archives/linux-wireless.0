Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from flock1.newmail.ru ([82.204.219.207]:57228 "HELO
	flock1.newmail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1762140AbZATR04 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2009 12:26:56 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: [Orinoco-devel] [PATCH] [2.6.29-rc2] orinoco: use GFP_ATOMIC in kmalloc in orinoco_ioctl_set_genie
Date: Tue, 20 Jan 2009 20:26:46 +0300
Cc: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200901171822.45476.arvidjaar@mail.ru> <1232334964.5609.37.camel@dv>
In-Reply-To: <1232334964.5609.37.camel@dv>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1805040.kiQC8LOHXu";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200901202026.49518.arvidjaar@mail.ru> (sfid-20090120_182714_903506_B612D06A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1805040.kiQC8LOHXu
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 19 =D1=8F=D0=BD=D0=B2=D0=B0=D1=80=D1=8F 2009 06:16:04 Pavel Roskin wrote:
> On Sat, 2009-01-17 at 18:22 +0300, Andrey Borzenkov wrote:
> > Subject: [PATCH] [2.6.29-rc2] orinoco: use GFP_ATOMIC in kmalloc in
> > orinoco_ioctl_set_genie
> > From: Andrey Borzenkov <arvidjaar@mail.ru>
> >
> > kmalloc is called with interrupt disabled and may not sleep. This
> > fixes this BUG:
>
> Please move kmalloc before the lock.  I don't see any reason to
> allocate memory with irqs disabled.  The contention happens later,
> when priv->wpa_ie is freed and assigned a new value.

OK.

This looks like -stable candidate.

=2D--

Subject: [PATCH] orinoco: move kmalloc(..., GFP_KERNEL) outside spinlock in=
=20
orinoco_ioctl_set_genie
=46rom: Andrey Borzenkov <arvidjaar@mail.ru>

As pointed out by Pavel Roskin, it need not be in critical section. Move
it outside of spinlock. This fixes this BUG:

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

 drivers/net/wireless/orinoco/orinoco.c |   30=20
+++++++++++++-----------------
 1 files changed, 13 insertions(+), 17 deletions(-)


diff --git a/drivers/net/wireless/orinoco/orinoco.c=20
b/drivers/net/wireless/orinoco/orinoco.c
index c3bb85e..39eab39 100644
=2D-- a/drivers/net/wireless/orinoco/orinoco.c
+++ b/drivers/net/wireless/orinoco/orinoco.c
@@ -5068,33 +5068,30 @@ static int orinoco_ioctl_set_genie(struct net_devic=
e=20
*dev,
 	struct orinoco_private *priv =3D netdev_priv(dev);
 	u8 *buf;
 	unsigned long flags;
=2D	int err =3D 0;
=20
 	/* cut off at IEEE80211_MAX_DATA_LEN */
 	if ((wrqu->data.length > IEEE80211_MAX_DATA_LEN) ||
 	    (wrqu->data.length && (extra =3D=3D NULL)))
 		return -EINVAL;
=20
=2D	if (orinoco_lock(priv, &flags) !=3D 0)
=2D		return -EBUSY;
=2D
 	if (wrqu->data.length) {
 		buf =3D kmalloc(wrqu->data.length, GFP_KERNEL);
=2D		if (buf =3D=3D NULL) {
=2D			err =3D -ENOMEM;
=2D			goto out;
=2D		}
+		if (buf =3D=3D NULL)
+			return -ENOMEM;
=20
 		memcpy(buf, extra, wrqu->data.length);
=2D		kfree(priv->wpa_ie);
=2D		priv->wpa_ie =3D buf;
=2D		priv->wpa_ie_len =3D wrqu->data.length;
=2D	} else {
=2D		kfree(priv->wpa_ie);
=2D		priv->wpa_ie =3D NULL;
=2D		priv->wpa_ie_len =3D 0;
+	} else
+		buf =3D NULL;
+
+	if (orinoco_lock(priv, &flags) !=3D 0) {
+		kfree(buf);
+		return -EBUSY;
 	}
=20
+	kfree(priv->wpa_ie);
+	priv->wpa_ie =3D buf;
+	priv->wpa_ie_len =3D wrqu->data.length;
+
 	if (priv->wpa_ie) {
 		/* Looks like wl_lkm wants to check the auth alg, and
 		 * somehow pass it to the firmware.
@@ -5103,9 +5100,8 @@ static int orinoco_ioctl_set_genie(struct net_device=
=20
*dev,
 		 */
 	}
=20
=2Dout:
 	orinoco_unlock(priv, &flags);
=2D	return err;
+	return 0;
 }
=20
 static int orinoco_ioctl_get_genie(struct net_device *dev,


--nextPart1805040.kiQC8LOHXu
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkl2CVkACgkQR6LMutpd94yBSQCeJ2RNYGDxPajHhsHno9zWZR/8
xbwAoNP8xT9U95I1T62rDoRx9qAbd1uZ
=c8qx
-----END PGP SIGNATURE-----

--nextPart1805040.kiQC8LOHXu--
