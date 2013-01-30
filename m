Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52193 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761Ab3A3VBo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2013 16:01:44 -0500
Message-ID: <1359579712.8010.30.camel@jlt4.sipsolutions.net> (sfid-20130130_220148_052629_E172F315)
Subject: pull-request: iwlwifi-next 2013-01-30
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 30 Jan 2013 22:01:52 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-U4sZTpM6q5/NP3/25YbD"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-U4sZTpM6q5/NP3/25YbD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

I was only waiting for you to merge mac80211-next, so I could merge
wireless-next into iwlwifi-next and send you a new pull request :-)

So here it is, just the patches with the new driver I posted earlier.
This is the MVM driver for the new firmware API for 7000 series devices.

Please pull (or let me know if it's broken :) )

johannes


The following changes since commit c331997b6c9ad7f4b8075e6e60d3caa6e36f5938=
:

  wil6210: fix wil_vring_init_tx status (2013-01-30 15:07:19 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git fo=
r-john

for you to fetch changes up to 5f4c5fa8a6ab5f23bba87b159e80f1edf4885ba5:

  iwlwifi: add the MVM driver (2013-01-30 21:46:23 +0100)

----------------------------------------------------------------
Johannes Berg (7):
      iwlwifi: include debugfs.h
      Merge remote-tracking branch 'wireless-next/master' into iwlwifi-next
      iwlwifi: add 7000 series device configuration
      iwlwifi: clean up CMD_MODE enum
      iwlwifi: fix calibration parser
      iwlwifi: add NVM and PHY DB code for new MVM driver
      iwlwifi: add the MVM driver

 drivers/net/wireless/iwlwifi/Kconfig            |   14 +-
 drivers/net/wireless/iwlwifi/Makefile           |    3 +
 drivers/net/wireless/iwlwifi/iwl-config.h       |    1 +
 drivers/net/wireless/iwlwifi/iwl-debug.h        |    2 +
 drivers/net/wireless/iwlwifi/iwl-drv.c          |   23 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c |   14 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h |    9 +
 drivers/net/wireless/iwlwifi/iwl-fh.h           |    1 +
 drivers/net/wireless/iwlwifi/iwl-fw.h           |   16 +-
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c    |  346 +++
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.h    |   80 +
 drivers/net/wireless/iwlwifi/iwl-op-mode.h      |    2 +
 drivers/net/wireless/iwlwifi/iwl-phy-db.c       |  514 ++++
 drivers/net/wireless/iwlwifi/iwl-phy-db.h       |   82 +
 drivers/net/wireless/iwlwifi/iwl-prph.h         |    3 +
 drivers/net/wireless/iwlwifi/iwl-trans.h        |   10 +-
 drivers/net/wireless/iwlwifi/mvm/Makefile       |   10 +
 drivers/net/wireless/iwlwifi/mvm/binding.c      |  197 ++
 drivers/net/wireless/iwlwifi/mvm/d3.c           |  841 ++++++
 drivers/net/wireless/iwlwifi/mvm/debugfs.c      |  378 +++
 drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h    |  282 +++
 drivers/net/wireless/iwlwifi/mvm/fw-api-mac.h   |  369 +++
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h |  140 +
 drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h    |  312 +++
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h  |  561 ++++
 drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h   |  380 +++
 drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h    |  580 +++++
 drivers/net/wireless/iwlwifi/mvm/fw-api.h       |  949 +++++++
 drivers/net/wireless/iwlwifi/mvm/fw.c           |  644 +++++
 drivers/net/wireless/iwlwifi/mvm/led.c          |  134 +
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c     |  951 +++++++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c     | 1310 ++++++++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h          |  500 ++++
 drivers/net/wireless/iwlwifi/mvm/nvm.c          |  311 +++
 drivers/net/wireless/iwlwifi/mvm/ops.c          |  679 +++++
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c     |  292 +++
 drivers/net/wireless/iwlwifi/mvm/power.c        |  207 ++
 drivers/net/wireless/iwlwifi/mvm/quota.c        |  178 ++
 drivers/net/wireless/iwlwifi/mvm/rs.c           | 3096 +++++++++++++++++++=
++++
 drivers/net/wireless/iwlwifi/mvm/rs.h           |  393 +++
 drivers/net/wireless/iwlwifi/mvm/rx.c           |  355 +++
 drivers/net/wireless/iwlwifi/mvm/scan.c         |  437 ++++
 drivers/net/wireless/iwlwifi/mvm/sta.c          | 1211 +++++++++
 drivers/net/wireless/iwlwifi/mvm/sta.h          |  368 +++
 drivers/net/wireless/iwlwifi/mvm/time-event.c   |  569 +++++
 drivers/net/wireless/iwlwifi/mvm/time-event.h   |  214 ++
 drivers/net/wireless/iwlwifi/mvm/tx.c           |  916 +++++++
 drivers/net/wireless/iwlwifi/mvm/utils.c        |  472 ++++
 drivers/net/wireless/iwlwifi/pcie/7000.c        |  111 +
 drivers/net/wireless/iwlwifi/pcie/cfg.h         |    2 +
 drivers/net/wireless/iwlwifi/pcie/drv.c         |    6 +
 51 files changed, 19454 insertions(+), 21 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-nvm-parse.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-phy-db.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-phy-db.h
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/Makefile
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/binding.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/d3.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/debugfs.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/fw-api-mac.h
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/fw-api.h
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/fw.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/led.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/mac80211.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/mvm.h
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/nvm.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/ops.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/power.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/quota.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/rs.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/rs.h
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/rx.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/scan.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/sta.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/sta.h
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/time-event.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/time-event.h
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/tx.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/utils.c
 create mode 100644 drivers/net/wireless/iwlwifi/pcie/7000.c


--=-U4sZTpM6q5/NP3/25YbD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRCYpAAAoJEDBSmw7B7bqrexgP/R1kIxvSc/tRZiOcA/FK/PQE
CwmfHG6+L+ePswwXov5BTIeztJVUrkgPsxCGb891VKCq4mvjjHRSR6a0BS5fIgyc
iTY8H3YkuU+r5cnaFVTMzD/X4hxiUNr8yhns81cX7VF4V90suf7+ldbwKgh3TDQT
S2kwXF5dlkBHDm/m5bZvUWs1OWd+A9mGIdIhdWqoyVznMC/S+W+rPkq+iwQwKoH2
Bi2wxKCoHqiTIYAAzK1nwq3tRc3hwftNllL+nEc4nFP96OOdR2PyIw6XM8gyle/H
Amn+A9daNFwTyuHqbmE1R0yuCWn7IbdPoxwGVk72GfL8JkikKPgCFsIe4n662v0y
RN7wrsD1wohu1taNpe5groQQV2ZE9kPwkWBvbAPKhFwSo/Y+Zq7gMjhZu2Iuuj4Z
bsWpK5W2aRD7tjdADLfaEWlCz14lDRGOZJMoP7ZiDy5msAhzFHbrwP8NQtgcrml7
bNRxvACKyyrlBY3yJo3h+2lrpwWwODGqnrnsSBMFwkuPxD84TEy1It+3LUtAs4Sf
IQJkQYLQPB3G68P/IEHOCNyloHQtspBTeEfBKW688VbE+G3X8+9hvxuMShKLUzSd
BCk3kycTBj4bvM4YaK/LhYi0SpBawWqUFowyApLl03uE4dMfvqDDOi/GlvvbrGrM
ZDFMv1FhkpYwnqJbnJGw
=3SnS
-----END PGP SIGNATURE-----

--=-U4sZTpM6q5/NP3/25YbD--

