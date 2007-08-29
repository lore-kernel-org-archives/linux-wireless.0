Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from seehuhn.de ([80.68.93.199]:3785 "EHLO seehuhn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756022AbXH2Wh5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Aug 2007 18:37:57 -0400
Date: Wed, 29 Aug 2007 23:37:52 +0100
From: Jochen Voss <voss@seehuhn.de>
To: linux wireless list <linux-wireless@vger.kernel.org>
Cc: linville@tuxdriver.com
Subject: oops with recent wireless-dev tree
Message-ID: <20070829223752.GA6969@seehuhn.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

when I use the b43 driver with my PCMCIA LinkSys WRT54GL adapter
(Broadcom 4318), run hostapd on the interface, and then try to add the
interface to a bridge, I get the following oops:

    BUG: unable to handle kernel NULL pointer dereference at virtual addres=
s 00000000
     printing eip:
    *pde =3D 00000000
    Oops: 0000 [#1]
    CPU:    0
    EIP:    0060:[<c02a2cb2>]    Not tainted VLI
    EFLAGS: 00010292   (2.6.23-rc3-wd #1)
    EIP is at port_cost+0x11/0xaa
    eax: c3c40000   ebx: c3c40000   ecx: 00000000   edx: 000000c0
    esi: 00000000   edi: c2a3ea80   ebp: c2a31e00   esp: c2a31dc8
    ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
    Process brctl (pid: 1498, ti=3Dc2a30000 task=3Dc25734c0 task.ti=3Dc2a30=
000)
    Stack: c0119bcf c3680140 c10beea0 c2a31ddc c0148dc4 0000000d c2a31e00 0=
0000296=20
	   f000007e c10beea0 000080d0 c2bb7700 c3c40000 c2a3ea80 c2a31e2c c02a2ee3=
=20
	   c251b600 c3680270 00000001 c2bb7700 c3073380 c01117df c3c40000 00000001=
=20
    Call Trace:
     [<c010294f>] show_trace_log_lvl+0x1a/0x2f
     [<c0102a01>] show_stack_log_lvl+0x9d/0xa5
     [<c0102d76>] show_registers+0x1a5/0x277
     [<c0102f24>] die+0xdc/0x1a5
     [<c01082d1>] do_page_fault+0x461/0x530
     [<c02db49a>] error_code+0x6a/0x70
     [<c02a2ee3>] br_add_if+0x119/0x290
     [<c02a35b0>] add_del_if+0x40/0x56
     [<c02a3acc>] br_dev_ioctl+0x506/0x537
     [<c0219bc8>] dev_ifsioc+0x3c1/0x3dd
     [<c0219f2b>] dev_ioctl+0x347/0x3d4
     [<c02110ec>] sock_ioctl+0x183/0x18f
     [<c01435d4>] do_ioctl+0x1c/0x4b
     [<c01437d3>] vfs_ioctl+0x1d0/0x1df
     [<c0143815>] sys_ioctl+0x33/0x4a
     [<c0102422>] syscall_call+0x7/0xb
     =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
    Code: ff 31 c0 eb 05 b8 ea ff ff ff 5b 5d c3 55 89 e5 83 e8 7c e8 35 58=
 e9 ff 5d c3 55 89 e5 57 56 53 83 ec 2c 89 c3 8b b0 b4 00 00 00 <83> 3e 00 =
74 53=20
    EIP: [<c02a2cb2>] port_cost+0x11/0xaa SS:ESP 0068:c2a31dc8

If I read this correctly, the EIP in the last line corresponds to
net/bridge/br_if.c, line 36:

    static int port_cost(struct net_device *dev)
    {
	    if (dev->ethtool_ops->get_settings) {
                               ^^^^

As far as I can figure out, dev->ethtool_ops is NULL and the crash
happens while trying to derefernce ...->get_settings.

Is dev->ethtool_ops allowed to be NULL?  In this case the appended
patch might be the correct fix.  At least it makes the oops disappear
for me.  Another possible fix would be to add an ethtool_ops structure
to the device created by b43.

I hope this helps,
Jochen
--=20
http://seehuhn.de/
----------------------------------------------------------------------
Avoid crashes while determining initial path cost for a bridge.

Check whether 'dev->ethtool_ops' is non-NULL before accessing
'dev->ethtool_ops->get_settings'.

Signed-off-by: Jochen Voss <voss@seehuhn.de>

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index b40dada..5b396ea 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -33,7 +33,7 @@
  */
 static int port_cost(struct net_device *dev)
 {
-       if (dev->ethtool_ops->get_settings) {
+       if (dev->ethtool_ops && dev->ethtool_ops->get_settings) {
                struct ethtool_cmd ecmd =3D { ETHTOOL_GSET };
                int err =3D dev->ethtool_ops->get_settings(dev, &ecmd);
                if (!err) {

--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFG1fVAf+iD8yEbECURAsRjAKCxQysMZw9EPPL10tat2srxmaI5BACbBoor
KVSqdE4g0KkCkjiPVf77Am8=
=KpuN
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
