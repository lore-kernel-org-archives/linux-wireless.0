Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:36993 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbaEGUAB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 16:00:01 -0400
Received: by mail-we0-f178.google.com with SMTP id u56so1503593wes.37
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 13:00:00 -0700 (PDT)
Message-ID: <536A90BD.8010204@gmail.com> (sfid-20140507_220011_428901_720E6D2D)
Date: Wed, 07 May 2014 22:59:57 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	ilw@linux.intel.com
Subject: pull request: iwlwifi 2014-05-07
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="i90MJA5e7uhFasxPges94rcRMWNHM4jTL"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--i90MJA5e7uhFasxPges94rcRMWNHM4jTL
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi John,

This is a pull request intended for 3.15 release.

Alex fixes the scan by disabling the fragmented scan. David prevents scan=
 offload while associated, the firmware seems not to like it. I fix a stu=
pid bug I made in BT Coex, and fix a bad #ifdef clause in rate scaling.
Along with that there is a fix for a NULL pointer exception that can happ=
en if we load the driver and our ISR gets called because the interrupt li=
ne is shared. The fix has been tested by the reporter.

Please pull.

The following changes since commit a6bc92803e7f765e02c923cf37c8e280e72964=
2a:

  iwlwifi: mvm: BT Coex - fix Look Up Table (2014-04-13 16:51:07 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git=
 master

for you to fetch changes up to 83f7a85f1134c6e914453f5747435415a23d516b:

  iwlwifi: pcie: disable interrupts upon PCIe alloc (2014-05-07 22:54:32 =
+0300)

----------------------------------------------------------------
Alexander Bondar (1):
      iwlwifi: mvm: several fixes in scan

David Spinadel (1):
      iwlwifi: mvm: do no sched scan while associated

Emmanuel Grumbach (3):
      iwlwifi: mvm: BT Coex - fix validity flags during init
      iwlwifi: mvm: rs - s/CPTCFG/CONFIG
      iwlwifi: pcie: disable interrupts upon PCIe alloc

 drivers/net/wireless/iwlwifi/mvm/coex.c        |  6 +++---
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h |  8 ++++----
 drivers/net/wireless/iwlwifi/mvm/mac80211.c    |  5 +++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h         |  3 +++
 drivers/net/wireless/iwlwifi/mvm/rs.c          |  2 +-
 drivers/net/wireless/iwlwifi/mvm/scan.c        | 53 ++++++++++++--------=
---------------------------------
 drivers/net/wireless/iwlwifi/mvm/utils.c       | 19 +++++++++++++++++++
 drivers/net/wireless/iwlwifi/pcie/trans.c      | 10 ++++++----
 8 files changed, 53 insertions(+), 53 deletions(-)


--i90MJA5e7uhFasxPges94rcRMWNHM4jTL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTapC9AAoJEC0Llv5uNjIBeRkP/0tsjHZGWJEoeYyqKJfm1uVU
AlCDqAzcghx5IqYHWsNUHsYNX2kmlCiyVuJsru4Qv88yxAzWSLnIIsOKqjY47+KO
d/pz8DTrwMMyt2VW2mAJ6vJf/BHK87x5bQptAMwSW3dJoHbTU9/UkIaFcq7IWxMT
VwsYLsZDkQo21l6Ddu0VicHZbrtLxPwWmpiaAAAxiQoxmO8FaUDZZ/YIZYptSz/b
0BdCsX4hXiXdwMPhzbyQW+Yr+FEr+a6c/qt8HDI6IDPtBz80SC1fUFTKKAqd9vdy
R+6KQoP9WPFVlIYC4b33kqjCRyvnN2+gL1D5WhwEQAHUcpm+PumBxAdV/vXW6TuU
TOuF0UHmHmGCPyBur2qzwbxNWG2bl35bWAF2mXWHa/Nt69p/KRfdLM/NcGcQ/8GB
ZM/3iMvL7PR6MzLFSSHWPMlEwTcDyMINcybuQOBR1xVrMJU6WczoJLnMxJjl+T+0
7wS77RItx2kap37IsL4cFy04IGzoP6VUm8mj3IIsAVtF4IdOUM7mgb2x3Xo46exv
YmRPVY4lTNPLSISqjEv60DgPrQvYUPdy+ha9PlwztMLVZe+qUYOw/ChYoiL4/YxM
Ch6MqS2aQizqqr9VsdLsGx16OBBr63YWKVN5nmChi3Qe+eJa/bJ+SeT3QwoyieCc
y7b+DMUHFmoX+XxXcg0J
=NoEl
-----END PGP SIGNATURE-----

--i90MJA5e7uhFasxPges94rcRMWNHM4jTL--
