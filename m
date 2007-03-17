Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:56158 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933339AbXCQEh6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Mar 2007 00:37:58 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Paul TBBle Hampson <Paul.Hampson@pobox.com>
Subject: Re: prism54pci fails to read eeprom on PowerPC, then bugs in pci code
Date: Sat, 17 Mar 2007 00:37:10 -0400
Cc: linux-wireless@vger.kernel.org
References: <20070317034607.GA1522@keitarou>
In-Reply-To: <20070317034607.GA1522@keitarou>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart45184827.H491RMaYht";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200703170037.14875.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart45184827.H491RMaYht
Content-Type: multipart/mixed;
  boundary="Boundary-01=_2B3+FE5FYkPjahc"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_2B3+FE5FYkPjahc
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 16 March 2007 23:46, Paul TBBle Hampson wrote:
> The (built-in) bcm43xx-mac80211 driver works, but when I try to load a
> CardBus Atheros card I've got lying around with dadwifi-openhal, it
> fails with some sort of hardware error.  (ie. it _might_ be a dodgey
> Cardbus port, although both cardbus cards used to work in this machine,
> using prism54 hardmac and the dadwifi with atheros hal driver
> respectively)
>
Can you rule out the port first? Load the fullmac driver first, bring it up=
 &=20
down, unload it, and then try p54.

> (Albeit the hardmach driver never managed to WPA, and as of 2.6.20 still
> doesn't, haven't tried the version in wireless-dev yet)
>
Hardmac version in wireless-dev is the same thing. wireless-dev is just for=
=20
mac80211 and cfg80211 code.

> So maybe the BUG isn't a problem with the p54 driver, but I'd appreciate
> help with making it find the eeprom so it doesn't happen...
I just found a leak in a probe error path. It might somehow cause the probl=
em=20
in the pci code. I've attached a patch to fix it.

Thanks,
=2DMichael Wu

--Boundary-01=_2B3+FE5FYkPjahc
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="fix-p54-error-leak.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="fix-p54-error-leak.diff"

p54pci: Fix error path when eeprom read fails

=46rom: Michael Wu <flamingice@sourmilk.net>

The p54 PCI driver leaks memory when eeprom read fails. This fixes it.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
=2D--

 drivers/net/wireless/mac80211/p54/prism54pci.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mac80211/p54/prism54pci.c b/drivers/net/w=
ireless/mac80211/p54/prism54pci.c
index 578ec39..798a5ee 100644
=2D-- a/drivers/net/wireless/mac80211/p54/prism54pci.c
+++ b/drivers/net/wireless/mac80211/p54/prism54pci.c
@@ -567,11 +567,11 @@ static int __devinit p54p_probe(struct pci_dev *pdev,
=20
 	err =3D p54p_upload_firmware(dev);
 	if (err)
=2D		goto err_iounmap;
+		goto err_free_desc;
=20
 	err =3D p54p_read_eeprom(dev);
 	if (err)
=2D		goto err_iounmap;
+		goto err_free_desc;
=20
 	priv->common.open =3D p54p_open;
 	priv->common.stop =3D p54p_stop;
@@ -583,7 +583,7 @@ static int __devinit p54p_probe(struct pci_dev *pdev,
 	if (err) {
 		printk(KERN_ERR "%s (prism54pci): Cannot register netdevice\n",
 		       pci_name(pdev));
=2D		goto err_free_desc;
+		goto err_free_common;
 	}
=20
 	printk(KERN_INFO "%s: hwaddr " MAC_FMT ", isl38%02x\n",
@@ -592,8 +592,10 @@ static int __devinit p54p_probe(struct pci_dev *pdev,
=20
 	return 0;
=20
=2D err_free_desc:
+ err_free_common:
 	p54_free_common(dev);
+
+ err_free_desc:
 	pci_free_consistent(pdev, sizeof(*priv->ring_control),
 			    priv->ring_control, priv->ring_control_dma);
=20

--Boundary-01=_2B3+FE5FYkPjahc--

--nextPart45184827.H491RMaYht
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF+3B6T3Oqt9AH4aERAlVKAJ4vCxCDFnRS8OCmpGa9mBBHqAilzACgjx/p
+A5HKZEIS2800MyyzWJcNB0=
=9Bby
-----END PGP SIGNATURE-----

--nextPart45184827.H491RMaYht--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
