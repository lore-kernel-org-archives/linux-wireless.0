Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59261 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbZBJKhC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 05:37:02 -0500
Subject: zd1211rw keeps failing
From: Johannes Berg <johannes@sipsolutions.net>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Daniel Drake <dsd@gentoo.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UFjlF/utd/r7cJipOODF"
Date: Tue, 10 Feb 2009 11:36:28 +0100
Message-Id: <1234262188.4302.0.camel@johannes.local> (sfid-20090210_113708_296347_B9312E94)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UFjlF/utd/r7cJipOODF
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

With the -rc4 based wireless tree:

[ 1810.855457] usb 1-1: firmware: requesting zd1211/zd1211b_ub
[ 1810.868857] usb 1-1: firmware: requesting zd1211/zd1211b_uphr
[ 1810.926526] zd1211rw 1-1:1.0: firmware version 4725
[ 1810.966529] zd1211rw 1-1:1.0: zd1211b chip 1582:6003 v4810 high 00-11-f6=
 AL2230_RF pa0 -----
[ 1810.969518] cfg80211: Calling CRDA for country: DE
[ 1811.970118] zd1211rw 1-1:1.0: error ioread32(CR_REG1): -110
[ 1812.030460] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
[ 1812.030467] BUG kmalloc-64: Poison overwritten
[ 1812.030470] ------------------------------------------------------------=
-----------------
[ 1812.030471]=20
[ 1812.030474] INFO: 0xffff880055000550-0xffff88005500057f. First byte 0x1 =
instead of 0x6b
[ 1812.030487] INFO: Allocated in zd_usb_enable_int+0xa5/0x180 [zd1211rw] a=
ge=3D114 cpu=3D0 pid=3D4209
[ 1812.030496] INFO: Freed in int_urb_complete+0x92/0x1bc [zd1211rw] age=3D=
107 cpu=3D0 pid=3D4209
[ 1812.030499] INFO: Slab 0xffffe20002288000 objects=3D30 used=3D28 fp=3D0x=
ffff880055000550 flags=3D0x40000000000000c3
[ 1812.030503] INFO: Object 0xffff880055000550 @offset=3D1360 fp=3D0xffff88=
00550003b8
[ 1812.030504]=20
[ 1812.030507] Bytes b4 0xffff880055000540:  42 c8 01 00 01 00 00 00 5a 5a =
5a 5a 5a 5a 5a 5a B=EF=BF=BD......ZZZZZZZZ
[ 1812.030529]   Object 0xffff880055000550:  01 90 82 96 00 00 80 96 a0 00 =
00 00 00 00 6b a5 ..............k=EF=BF=BD
[ 1812.030551]   Object 0xffff880055000560:  00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 ................
[ 1812.030573]   Object 0xffff880055000570:  00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 ................
[ 1812.030594]   Object 0xffff880055000580:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b 6b 6b 6b 6b a5 kkkkkkkkkkkkkkk=EF=BF=BD
[ 1812.030616]  Redzone 0xffff880055000590:  bb bb bb bb bb bb bb bb       =
                  =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD       =20
[ 1812.030638]  Padding 0xffff8800550005d0:  5a 5a 5a 5a 5a 5a 5a 5a       =
                  ZZZZZZZZ       =20
[ 1812.030662] Pid: 4, comm: ksoftirqd/0 Not tainted 2.6.29-rc4-wl-13559-g0=
416c58-dirty #40
[ 1812.030666] Call Trace:
[ 1812.030669]  <IRQ>  [<ffffffff802d3116>] print_trailer+0x106/0x160
[ 1812.030681]  [<ffffffff802d3875>] check_bytes_and_report+0x125/0x180
[ 1812.030685]  [<ffffffff802d397c>] check_object+0xac/0x270
[ 1812.030704]  [<ffffffffa005d7ae>] ? ohci_urb_enqueue+0xae/0x360 [ohci_hc=
d]
[ 1812.030709]  [<ffffffff802d4595>] alloc_debug_processing+0x105/0x1a0
[ 1812.030714]  [<ffffffff802d59d6>] __slab_alloc+0x96/0x2f0
[ 1812.030721]  [<ffffffffa005d7ae>] ? ohci_urb_enqueue+0xae/0x360 [ohci_hc=
d]
[ 1812.030728]  [<ffffffffa005d7ae>] ? ohci_urb_enqueue+0xae/0x360 [ohci_hc=
d]
[ 1812.030732]  [<ffffffff802d6a06>] __kmalloc+0x106/0x140
[ 1812.030739]  [<ffffffffa005d7ae>] ohci_urb_enqueue+0xae/0x360 [ohci_hcd]
[ 1812.030762]  [<ffffffffa0017838>] usb_hcd_submit_urb+0x88/0x1c0 [usbcore=
]
[ 1812.030779]  [<ffffffffa0017dfd>] usb_submit_urb+0x10d/0x340 [usbcore]
[ 1812.030789]  [<ffffffffa00934ce>] hid_irq_in+0x9e/0x210 [usbhid]
[ 1812.030806]  [<ffffffffa0016050>] usb_hcd_giveback_urb+0x60/0xe0 [usbcor=
e]
[ 1812.030813]  [<ffffffffa005ab11>] finish_urb+0xa1/0x110 [ohci_hcd]
[ 1812.030820]  [<ffffffffa005ac3b>] takeback_td+0xbb/0x160 [ohci_hcd]
[ 1812.030826]  [<ffffffffa005ad93>] dl_done_list+0xb3/0x110 [ohci_hcd]
[ 1812.030833]  [<ffffffffa005f470>] ohci_irq+0x2f0/0x3cc [ohci_hcd]
[ 1812.030850]  [<ffffffffa0015930>] ? usb_hcd_irq+0x20/0xb0 [usbcore]
[ 1812.030867]  [<ffffffffa0015950>] usb_hcd_irq+0x40/0xb0 [usbcore]
[ 1812.030873]  [<ffffffff8029166b>] handle_IRQ_event+0x3b/0x80
[ 1812.030877]  [<ffffffff802931f1>] handle_fasteoi_irq+0x91/0x110
[ 1812.030883]  [<ffffffff8020e43c>] do_IRQ+0x9c/0x150
[ 1812.030887]  [<ffffffff8020c6d3>] ret_from_intr+0x0/0xf
[ 1812.030893]  [<ffffffff8024ccb0>] ? tasklet_action+0x140/0x160
[ 1812.030898]  [<ffffffff8024ccac>] ? tasklet_action+0x13c/0x160
[ 1812.030902]  [<ffffffff8024d71d>] ? __do_softirq+0x9d/0x190
[ 1812.030907]  [<ffffffff8020cebc>] ? call_softirq+0x1c/0x40
[ 1812.030909]  <EOI>  [<ffffffff8020e1a5>] ? do_softirq+0x75/0xc0
[ 1812.030916]  [<ffffffff8024cd54>] ? ksoftirqd+0x84/0x1b0
[ 1812.030920]  [<ffffffff8024ccd0>] ? ksoftirqd+0x0/0x1b0
[ 1812.030924]  [<ffffffff8024ccd0>] ? ksoftirqd+0x0/0x1b0
[ 1812.030929]  [<ffffffff8025f2e9>] ? kthread+0x49/0x90
[ 1812.030934]  [<ffffffff8020cdba>] ? child_rip+0xa/0x20
[ 1812.030938]  [<ffffffff8020c780>] ? restore_args+0x0/0x30
[ 1812.030942]  [<ffffffff8025f2a0>] ? kthread+0x0/0x90
[ 1812.030946]  [<ffffffff8020cdb0>] ? child_rip+0x0/0x20
[ 1812.030949] FIX kmalloc-64: Restoring 0xffff880055000550-0xffff880055000=
57f=3D0x6b
[ 1812.030950]=20
[ 1812.030953] FIX kmalloc-64: Marking all objects used
[ 1812.057052] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[ 1819.141519] wlan1: authenticate with AP 8e:b5:9c:32:62:6e
[ 1819.340080] wlan1: authenticate with AP 8e:b5:9c:32:62:6e
[ 1819.550073] wlan1: authenticate with AP 8e:b5:9c:32:62:6e
[ 1819.750061] wlan1: authentication with AP 8e:b5:9c:32:62:6e timed out

johannes

--=-UFjlF/utd/r7cJipOODF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJkViqAAoJEKVg1VMiehFYCxwQAL4gmn2chQOPdVCQoM9A9302
K0lmpvwOZ3Jf0hK0qtO4NUrdlNjEqWzpWdYaSt6doSFDRK+xjVzH+yeavUvUEvuR
a3oCj9RIyooMqrDCyInOaAcIb1Loj2Dfscezsm1LMZ7hSj65qpQcKgRwpGAzgXCr
5rRvhvlElmeF/fVwTlP0CEcgVvww6oVcvy+MUPfLZJqrn3NjOsPFLEw8xcthJdEN
D2Hb4im4IwDACTwtkXyRmz5Vjx0nBkQziedHCfLTfHmCPJvDSZGR6lf8WTW03SuT
jl3nxN+bmWtCzTSjZGUIvimXuKX36MFcCLpvukxRB+00D0ybBUeUDFf+1ufNDVFq
6bhefZyDrK3+dHK/uLVcw9uSCrKbjfYSe3HHnbRmQUpJFdkxoDdoNhUcY0z5AvhL
9nt5K532dpLJogZeUcUzytdV6M/G0HhTszP0QT9rP7Ijhdp3mrQ3rPJM6Nw9DdPO
xs3K89w28vGELv/YfhXs0VCVXGiki6OkV1pYFx0qeY1YzxA0+mgIqfaS95sjDQA5
jVBiAzj2AJU/g/RMLDY6fee/+XFVKaIykXOgvfOJ2PMKYEUrG8st0UQEsqOiMUMW
Syt6O6lOn5uwMTatGWL/RODOBpASDEin/n5dAmlokc/OxnNeKDeuroFRbcrUs7uw
huhiu1uZQL5qBGlJLSad
=CzVj
-----END PGP SIGNATURE-----

--=-UFjlF/utd/r7cJipOODF--

