Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:51700 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaBLIwK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 03:52:10 -0500
Received: by mail-wi0-f177.google.com with SMTP id e4so6434495wiv.16
        for <linux-wireless@vger.kernel.org>; Wed, 12 Feb 2014 00:52:09 -0800 (PST)
Message-ID: <52FB360D.2060502@gmail.com> (sfid-20140212_095215_196027_A7DB533D)
Date: Wed, 12 Feb 2014 10:51:25 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: pull request: iwlwifi 2013-02-12
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="lUWJiDnvwx5QtRJ6MkGmiXBLes95gHNdi"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lUWJiDnvwx5QtRJ6MkGmiXBLes95gHNdi
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi John,

One single patch for this pull request for 3.14.

As explicitly written in the commit message, we prefer to disable Tx
AMPDU on NICs supported by iwldvm. This feature gives a big boost in Tx
performance, but the firmware is buggy and we can't rely on it.
Our hope is that most of the users out there want wifi to surf on the
web which means that they care more for Rx traffic than for Tx.
People who want to enable it can do so with a simple Kconfig entry.
Rx AMPDU is still enabled by default.

Please pull - thanks.

	emmanuel

The following changes since commit c512865446e6dd5b6e91e81187e75b734ad7cf=
c7:

  iwlwifi: mvm: don't allow A band if SKU forbids it (2014-02-02
11:08:42 +0200)

are available in the git repository at:


git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git
for-john

for you to fetch changes up to 930e106d90ca902c8ede0a8cb206cee1ef3c5cc0:

  iwlwifi: disable TX AMPDU by default for iwldvm (2014-02-12 10:38:44
+0200)

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: disable TX AMPDU by default for iwldvm

 drivers/net/wireless/iwlwifi/Kconfig         |   10 ++++++++
 drivers/net/wireless/iwlwifi/dvm/mac80211.c  |    8 +++----
 drivers/net/wireless/iwlwifi/dvm/tx.c        |   32
++++++++++++++------------
 drivers/net/wireless/iwlwifi/iwl-drv.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-modparams.h |    1 -
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c |    2 --
 drivers/net/wireless/iwlwifi/mvm/mac80211.c  |    8 -------
 7 files changed, 32 insertions(+), 31 deletions(-)


--lUWJiDnvwx5QtRJ6MkGmiXBLes95gHNdi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJS+zYpAAoJEC0Llv5uNjIBdzUP/1MBpTzBuqS6EWkfxhqlUsAT
EBn5Bzozu6ZEIqE7AQJDtW0Q4x4XTWjO8scf3Bt7xKrkg4Ohm3oY8un0Xdi6GYb4
dACB5YX21qG45OKF0cX1NZuYskrYi124pdleew/gRfsCt93boQELuFl2BLrbjrXN
Gfg+nLrNd2oGbb25CvBK+qVGITZiWpqTJ2TgDh2Uj7jxh94GAbOVH4HeLTuXDL7S
UPmbh/cOT94fXe4HpjkShcKTXPIN+rXbNghPpCTDfLV8s7SlS291QZs7p24kHYRr
hw/B06ptPNfLzZBDNE07kYAHJeTDHtP+8pO1jCalrWracdzgkQw0eN8/eHGvMsLw
wwWzsF+YPGRufmXaMsbZuvHjAmpOuPeHQIFG/iiTOU733p9ThM0P1Mv3D7gcygaC
+432QDkJbHlDZJRDStwXR2PVEtRbeFtxOjxa86jZcovH/D5ajAQM3ye01ewbFfQV
ljlN4IpXeehsucY8Ly1l7LyeqzYb8nQYs3hjxcPyvnaWKMPrbHsAjtYyvNHzOUi7
/XM+U0t8gheSX5w1Oo4sYeVnIj8ZP0rO65Islp3Z6h1hGarMkoqSE2fU3lE53+49
q1M9fm5rsCgvS/61/CeIDE0YjZnvAJw9nXNJSLKHMGnOq2FZuHSgJx1YqykBRU//
WzNf6PueLX9CbHqamKiH
=0qP8
-----END PGP SIGNATURE-----

--lUWJiDnvwx5QtRJ6MkGmiXBLes95gHNdi--
