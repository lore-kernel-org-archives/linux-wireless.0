Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:50269 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab3FNKs5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jun 2013 06:48:57 -0400
Message-ID: <1371206930.8278.8.camel@jlt4.sipsolutions.net> (sfid-20130614_124900_055729_93C857CC)
Subject: pull-request: iwlwifi-next 2013-06-14
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 14 Jun 2013 12:48:50 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-jatdQXumKhEx0wHPKSGv"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jatdQXumKhEx0wHPKSGv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Here are some more things for -next. I will have another pull request
some time next week because we're preparing to release the firmware for
the 7000 series devices, and unfortunately that will require an API
bump.

This time I have a number of cleanups, a small fix from Emmanuel and two
performance improvements that combined reduce our driver's CPU
utilisation as much as 75% in high TX-throughput scenarios.

johannes


The following changes since commit 8eb3871076875f247483f4a1fe6713e6d440c53e=
:

  iwlwifi: mvm: Update the supported interface combinations (2013-06-11 20:=
17:06 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git fo=
r-john

for you to fetch changes up to adaf69186c24100d34c2fb107dacd33546cad3c5:

  iwlwifi: mvm: remove obsolete comment (2013-06-13 16:43:16 +0200)

----------------------------------------------------------------
David Spinadel (1):
      iwlwifi: remove calib channel section from PHY DB

Emmanuel Grumbach (2):
      iwlwifi: mvm: take the seqno from packet if transmit failed
      iwlwifi: mvm: remove obsolete comment

Johannes Berg (5):
      iwlwifi: make TX seqno validation more efficient
      iwlwifi: pcie: don't read INTA register in ICT IRQ handler
      iwlwifi: reduce debug ifdefs using the optimiser
      iwlwifi: mvm: mark scratch area in TX command
      iwlwifi: create opmode/device dependencies

Oren Givon (1):
      iwlwifi: mvm: removed an unused parameter from a function

 drivers/net/wireless/iwlwifi/Makefile        |  6 ++--
 drivers/net/wireless/iwlwifi/dvm/main.c      |  7 -----
 drivers/net/wireless/iwlwifi/iwl-config.h    |  4 +++
 drivers/net/wireless/iwlwifi/iwl-debug.h     |  4 +++
 drivers/net/wireless/iwlwifi/iwl-modparams.h |  2 ++
 drivers/net/wireless/iwlwifi/iwl-phy-db.c    | 36 ++---------------------
 drivers/net/wireless/iwlwifi/mvm/d3.c        | 15 +++++-----
 drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h |  9 +++---
 drivers/net/wireless/iwlwifi/mvm/tx.c        |  5 ++--
 drivers/net/wireless/iwlwifi/pcie/drv.c      |  4 +++
 drivers/net/wireless/iwlwifi/pcie/internal.h |  2 ++
 drivers/net/wireless/iwlwifi/pcie/rx.c       | 44 ++++++++++--------------=
----
 drivers/net/wireless/iwlwifi/pcie/tx.c       | 10 +++----
 13 files changed, 58 insertions(+), 90 deletions(-)


--=-jatdQXumKhEx0wHPKSGv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRuvUSAAoJEDBSmw7B7bqrKpYP/1yiOO9Sk/YasYQ18M7e3P5X
igYqdI+5yGGSxGdnKh1iWdGmsdJBzOFcdUxI7ml3O6l1ma74ldTrGXYH40Ke9AGb
2t85oGifZkK9Xr2KHzvlM9RWx5bDfXWOxBtYL3e+b8bAVYVYSB7dASqm+ML+Kboz
hWVGOGfPUAXj58pOi0p7Zaa9k6y5Afz2Ys7SwpIDnVLYGCRNqJvBnI4AhAd/CCHu
WTFCx8L7sn4jevSczi4es+9U7xupmbzOKc81Qw6kgTKEO4o30GOKNxGZs7+BMBLa
ZuT/VULmOnnkYl92m9E5gUjTUvw5D1MeM0vQzwwL71/fbhcN+djqRUt7z6iTlGqs
jwLy/wlLY6hS0rK7dONoKWInaKbp6xMUHnbV5Q/bCBXpp8EUov2BnCeXpDqKG3cq
mnLAH+2RjH9sKE4/R9MMsGYGi3DifSlvBmzYAuQlivU8KwC1UD8aHAhFzDJvJ426
UxI8reTIcfDKTRapgxkMfmEUBiyv6XywVgoEa+eA4agDEtDZbgmEr8vZerCveS07
jkz0yqrzTQBus8rC0FzjrjjMwCHbHvWYxr7AYaJBrXYb+KVcCUrrfw8uxnVs0Jc3
ZXRUp3cBHm7HrOpnCHo5DYuriRV/z1/OK9yL5DCCgCOmoA5EEup4k0DHgG0XvTre
e5orLHs397E+sv//xFfd
=AjgW
-----END PGP SIGNATURE-----

--=-jatdQXumKhEx0wHPKSGv--

