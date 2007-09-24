Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:40500 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756160AbXIXWh7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 18:37:59 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH 6/6] adm8211: Detect interface up/down in suspend/resume hooks correctly
Date: Mon, 24 Sep 2007 18:36:52 -0400
Cc: linux-wireless@vger.kernel.org
References: <20070924221025.6870.53754.stgit@magic.sourmilk.net> <20070924221025.6870.73757.stgit@magic.sourmilk.net>
In-Reply-To: <20070924221025.6870.73757.stgit@magic.sourmilk.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1527855.ny95f7diU1";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200709241836.56335.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1527855.ny95f7diU1
Content-Type: multipart/mixed;
  boundary="Boundary-01=_EwD+GTXKh5qxQQP"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_EwD+GTXKh5qxQQP
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 24 September 2007 18:10, Michael Wu wrote:
> From: Michael Wu <flamingice@sourmilk.net>
>
> Interface up/down detection was incorrectly changed during the filter API
> update.
>
> Signed-off-by: Michael Wu <flamingice@sourmilk.net>
Opps. This patch is missing one part that's needed to make it actually work=
=2E=20
Working patch attached. Please use this instead.

Thanks,
=2DMichael Wu

--Boundary-01=_EwD+GTXKh5qxQQP
Content-Type: text/x-diff;
  charset="utf-8";
  name="fix-suspend"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="fix-suspend"

commit 062677a448a8d8218d09f3f86520646fb4c1afee
Author: Michael Wu <flamingice@sourmilk.net>
Date:   Mon Sep 24 18:32:39 2007 -0400

    adm8211: Detect interface up/down in suspend/resume hooks correctly
   =20
    Interface up/down detection was incorrectly changed during the filter A=
PI
    update.
   =20
    Signed-off-by: Michael Wu <flamingice@sourmilk.net>

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index 95c8315..e4fdadb 100644
=2D-- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -1540,6 +1540,7 @@ static int adm8211_start(struct ieee80211_hw *dev)
 	ADM8211_CSR_WRITE(IER, ADM8211_IER_NIE | ADM8211_IER_AIE |
 			       ADM8211_IER_RCIE | ADM8211_IER_TCIE |
 			       ADM8211_IER_TDUIE | ADM8211_IER_GPTIE);
+	priv->mode =3D IEEE80211_IF_TYPE_MNTR;
 	adm8211_update_mode(dev);
 	ADM8211_CSR_WRITE(RDR, 0);
=20
@@ -1554,6 +1555,7 @@ static void adm8211_stop(struct ieee80211_hw *dev)
 {
 	struct adm8211_priv *priv =3D dev->priv;
=20
+	priv->mode =3D IEEE80211_IF_TYPE_MGMT;
 	priv->nar =3D 0;
 	ADM8211_CSR_WRITE(NAR, 0);
 	ADM8211_CSR_WRITE(IER, 0);
@@ -1896,7 +1898,7 @@ static int __devinit adm8211_probe(struct pci_dev *pd=
ev,
 	priv->tx_power =3D 0x40;
 	priv->lpf_cutoff =3D 0xFF;
 	priv->lnags_threshold =3D 0xFF;
=2D	priv->mode =3D IEEE80211_IF_TYPE_MNTR;
+	priv->mode =3D IEEE80211_IF_TYPE_MGMT;
=20
 	/* Power-on issue. EEPROM won't read correctly without */
 	if (pdev->revision >=3D ADM8211_REV_BA) {
@@ -1991,7 +1993,7 @@ static int adm8211_suspend(struct pci_dev *pdev, pm_m=
essage_t state)
 	struct ieee80211_hw *dev =3D pci_get_drvdata(pdev);
 	struct adm8211_priv *priv =3D dev->priv;
=20
=2D	if (priv->mode !=3D IEEE80211_IF_TYPE_MNTR) {
+	if (priv->mode !=3D IEEE80211_IF_TYPE_MGMT) {
 		ieee80211_stop_queues(dev);
 		adm8211_stop(dev);
 	}
@@ -2009,7 +2011,7 @@ static int adm8211_resume(struct pci_dev *pdev)
 	pci_set_power_state(pdev, PCI_D0);
 	pci_restore_state(pdev);
=20
=2D	if (priv->mode !=3D IEEE80211_IF_TYPE_MNTR) {
+	if (priv->mode !=3D IEEE80211_IF_TYPE_MGMT) {
 		adm8211_start(dev);
 		ieee80211_start_queues(dev);
 	}

--Boundary-01=_EwD+GTXKh5qxQQP--

--nextPart1527855.ny95f7diU1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBG+DwIT3Oqt9AH4aERAu5tAKCdMsLJtQCSv2yIIgGeEJHPz1AN9gCfYCih
K48L2ZxYKqQ9pQucQbvDGfY=
=omet
-----END PGP SIGNATURE-----

--nextPart1527855.ny95f7diU1--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
