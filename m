Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44646 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516Ab3JXHdv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Oct 2013 03:33:51 -0400
Date: Thu, 24 Oct 2013 18:33:33 +1100
From: NeilBrown <neilb@suse.de>
To: "John W. Linville" <linville@tuxdriver.com>,
	Bing Zhao <bzhao@marvell.com>, Dan Williams <dcbw@redhat.com>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	Belisko Marek <marek.belisko@gmail.com>,
	"Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
	Daniel Drake <dsd@laptop.org>
Subject: [PATCH] libertas/sdio: make sure card enters power-off when
 firmware is loaded.
Message-ID: <20131024183333.2adcb262@notabene.brown> (sfid-20131024_093355_713987_689CE90E)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/XycUKxssFvwG2ZnLp1vuATA"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/XycUKxssFvwG2ZnLp1vuATA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable



Since firmware loading became async it is possible that if_sdio_finish_powe=
r_of
is called with only one remaining runtime_pm reference, so it isn't safe
to call pm_runtime_put_noidle.  We must call pm_runtime_put().

Diagnosed-by: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless=
/libertas/if_sdio.c
index 4557833..a39318b 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -853,7 +853,7 @@ static void if_sdio_finish_power_on(struct if_sdio_card=
 *card)
 			card->started =3D true;
 			/* Tell PM core that we don't need the card to be
 			 * powered now */
-			pm_runtime_put_noidle(&func->dev);
+			pm_runtime_put(&func->dev);
 		}
 	}
=20

--Sig_/XycUKxssFvwG2ZnLp1vuATA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUmjNTTnsnt1WYoG5AQLANg//fXgfB5o84rw6k1TLsAR/e5N8q3VtIrRR
KnYdr9hmCIneiz5+rIL26nHp5FezcbiYVIMIrqsMvf1ZiilwzmwBu/gUqqF7uKh/
5yO745+jKXmvVPDbZWrPnJjQfcJqgnjp4/WbnJHcPI3gox87USf7FbICYeknotYW
BwVXokkmyD+S7TfDnofGY6N7jrpJKhdD8CHc34ALpZR7J8Fi/SVAnLnauJQ6todI
WN2IiGuwqPGvMvP1bqTmmTipzWMt5U+UeO8cEEwA84VH5s9FSYUFNZjDA3L9Oah5
3yugOzKpPxSyVpP6iP1eLo/GHdIEUpACx2zyJW9ZqnOn1z0lTyrPk/TCdnVg3zdK
8ONR3Hg4DIWKtBOwoH5oO0B/Cos+JkLL0v+DCgzCiZQK5AW2wj5o57AkerLSpKFj
hHF3xfOmdLMjBPnqYMMRFeBPUCxgggIOSet/DvLvAEuZnPfylxFwlcAfxzyX7MZg
agwpmOzcGLoMTARM/8oV1QIieXB/o2cPq43ZkkdKwMAVVnTkIKZ5NnbBQ5Kju/r2
cboOCUWw7QZ+VD5MSf9xGr57xTkwInm5yhhJvwFRWcBY6zEm4UQFaJIaWSRtbOdG
7sGqCbWbCzF6BAu+diLeSJWkkMhnsKtjWwl13IoqcyQrPITuka5bFOmr8zZzp67x
MKRW3blE8DE=
=+E5o
-----END PGP SIGNATURE-----

--Sig_/XycUKxssFvwG2ZnLp1vuATA--
