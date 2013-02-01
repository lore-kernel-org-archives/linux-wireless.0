Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58572 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598Ab3BAKiW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2013 05:38:22 -0500
Message-ID: <1359715120.8528.11.camel@jlt4.sipsolutions.net> (sfid-20130201_113829_297572_087C1EBA)
Subject: pull-request: iwlwifi-next 2013-02-01 (was: pull-request:
 iwlwifi-next 2013-01-30)
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 01 Feb 2013 11:38:40 +0100
In-Reply-To: <1359579712.8010.30.camel@jlt4.sipsolutions.net> (sfid-20130130_220148_052629_E172F315)
References: <1359579712.8010.30.camel@jlt4.sipsolutions.net>
	 (sfid-20130130_220148_052629_E172F315)
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-MI6rWi264kxxk8fAVGER"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MI6rWi264kxxk8fAVGER
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Please excuse my overriding an earlier pull request again. Fengguang
Wu's build testing found that we had a few symbol conflicts between the
two subdrivers (iwldvm and the new iwlmvm) so I fixed those. I also
included a few more patches that we'd worked on and I put in for
publishing since then.

So what I have here is some cleanups, preparations and the new MVM
(multi-virtual MAC) driver itself and (this is new) some work on the
transport API as well as a message flooding fix.

Let me know if there are any problems.

johannes

The following changes since commit c331997b6c9ad7f4b8075e6e60d3caa6e36f5938=
:

  wil6210: fix wil_vring_init_tx status (2013-01-30 15:07:19 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git fo=
r-john

for you to fetch changes up to e56b04efc1f795da42cf1d9651b52a4a5bebd730:

  iwlwifi: move register access lock into transport (2013-02-01 11:27:22 +0=
100)

----------------------------------------------------------------
Johannes Berg (8):
      iwlwifi: include debugfs.h
      Merge remote-tracking branch 'wireless-next/master' into iwlwifi-next
      iwlwifi: add 7000 series device configuration
      iwlwifi: clean up CMD_MODE enum
      iwlwifi: fix calibration parser
      iwlwifi: add NVM and PHY DB code for new MVM driver
      iwlwifi: add the MVM driver
      iwlwifi: lower BT coex aggregation message severity

Lilach Edelstein (2):
      iwlwifi: add iwl_set_bits_mask to transport API
      iwlwifi: move register access lock into transport

 drivers/net/wireless/iwlwifi/Kconfig            |   14 +-
 drivers/net/wireless/iwlwifi/Makefile           |    3 +
 drivers/net/wireless/iwlwifi/dvm/mac80211.c     |    6 +-
 drivers/net/wireless/iwlwifi/dvm/main.c         |   40 +-
 drivers/net/wireless/iwlwifi/dvm/rs.c           |    5 +-
 drivers/net/wireless/iwlwifi/dvm/tt.c           |    6 +-
 drivers/net/wireless/iwlwifi/iwl-config.h       |    1 +
 drivers/net/wireless/iwlwifi/iwl-debug.h        |    2 +
 drivers/net/wireless/iwlwifi/iwl-drv.c          |   23 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c |   14 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h |    9 +
 drivers/net/wireless/iwlwifi/iwl-fh.h           |    1 +
 drivers/net/wireless/iwlwifi/iwl-fw.h           |   16 +-
 drivers/net/wireless/iwlwifi/iwl-io.c           |   91 +-
 drivers/net/wireless/iwlwifi/iwl-io.h           |   13 +-
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c    |  346 +++
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.h    |   80 +
 drivers/net/wireless/iwlwifi/iwl-op-mode.h      |    2 +
 drivers/net/wireless/iwlwifi/iwl-phy-db.c       |  514 ++++
 drivers/net/wireless/iwlwifi/iwl-phy-db.h       |   82 +
 drivers/net/wireless/iwlwifi/iwl-prph.h         |    3 +
 drivers/net/wireless/iwlwifi/iwl-test.c         |   17 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h        |   42 +-
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
 drivers/net/wireless/iwlwifi/pcie/internal.h    |    4 +
 drivers/net/wireless/iwlwifi/pcie/trans.c       |   91 +-
 60 files changed, 19602 insertions(+), 178 deletions(-)
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


--=-MI6rWi264kxxk8fAVGER
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRC5swAAoJEDBSmw7B7bqrSRUP/A1mTgCwSpkTSIoVmSll7F44
atDbH1J6HHaZ6ujtXKD+IXrUgdvb56zl+yM3pRq+UgH2O2XoaJO5O6E9zaRY4gXf
cVi/xVV0N47hR4rMFgglHPOLOQQdYz1AvicNNuxu0dGyg/lWi1arNWW7kD4J5U3Z
erVNWuneAr+ZZkF+ugHTmszEa1QLRGgiMlkEnUlztJDSvzJJ52R6XXmqBk5oIe1e
rZ+A1y0DZVKJlN50csVgo6YWRBZCdXgZnJq87MvNTFi60yBKm2i1iqaHx0bwU8gt
80ThC+aGwZU6NJnf2Qnqkpt3noj/mGev2MCToW+Xi3nvySTtGVbPhLD1a3Prwj/p
XxoVwMnwbkrc3EdxbqzhugDciNHslwP8K/sBdwszlkPJcxII8ETXEu6kdb+/g+9u
ob5vxHkUzD1qxIg385iNeXXtajzydOJQ3QeZDsRrIpw2HW0jMOxxe9ir8v+Ln0ip
uSKdTrL2I65uy7fKWKfn7+cUAGDfa2nRu/gP1tVHHAt+0UOvVq9TtnC06atdfpI4
QMhYJo6lopND0WPw5oTTOPjTXBPiEJ3BFqXDQMiPGUbJPEl/2DYQtiJsvFNLl8lz
/k78EGieIpjesWVMb6BH5iT9Xn9mHBNnDrWcjaWxstgdm1WQFpMQ1KOpxKAJxAAm
TFECHNsyTwRGdjWrwkkr
=YhR2
-----END PGP SIGNATURE-----

--=-MI6rWi264kxxk8fAVGER--

