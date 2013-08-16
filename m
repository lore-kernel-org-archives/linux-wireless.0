Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38860 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab3HPLGI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 07:06:08 -0400
Message-ID: <1376651161.15299.24.camel@jlt4.sipsolutions.net> (sfid-20130816_130613_284163_62C69448)
Subject: pull-request: iwlwifi-next 2013-08-16
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 16 Aug 2013 13:06:01 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-gMSd7Li3mSBK71NGJCYt"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gMSd7Li3mSBK71NGJCYt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

For iwlwifi-next I also have some new code...

This time I have some powersave work (notably uAPSD support), CQM
offloads, support for a new firmware API and various code cleanups.

Let me know if there's any problem.

johannes


The following changes since commit ef4394b9477f9078d78ae3e8359eae094c9b19d8=
:

  iwlwifi: mvm: use designated initialization for some arrays (2013-08-06 1=
0:35:04 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git fo=
r-john

for you to fetch changes up to 89716344806bd49d213ad5960661e8c2d38c4982:

  iwlwifi: mvm: Add PBW snoozing enablement (2013-08-16 12:13:28 +0200)

----------------------------------------------------------------
Alexander Bondar (3):
      iwlwifi: mvm: Fix beacon filtering enablement via debugfs
      iwlwifi: mvm: Add basic uAPSD client support
      iwlwifi: mvm: Add PBW snoozing enablement

Andrei Otcheretianski (1):
      iwlwifi: mvm: Implement CQM offloading

Dan Carpenter (1):
      iwlwifi: pcie: returning positive instead of negative

Eliad Peller (1):
      iwlwifi: mvm: don't clear tbl->win mistakenly

Eyal Shapira (4):
      iwlwifi: mvm: remove rate_scale_data debugfs entry
      iwlwifi: mvm: remove unused fields of iwl_rs_rate_info
      iwlwifi: mvm: remove MIMO3 from rate scale code
      iwlwifi: mvm: remove unused param of rs_dbgfs_set_mcs

Eytan Lifshitz (1):
      iwlwifi: mvm: add support to the new FW time event API

Ido Yariv (3):
      iwlwifi: pcie: Refactor iwl_queue_space
      iwlwifi: pcie: Refactor iwl_rxq_space
      iwlwifi: pcie: Remove duplicate code from pcie irq handlers

Johannes Berg (1):
      iwlwifi: mvm: refactor resume from WoWLAN code

Luciano Coelho (4):
      iwlwifi: pcie: don't swallow error codes in iwl_trans_pcie_alloc()
      iwlwifi: use a macro for default probe length
      iwlwifi: Kconfig: fix help texts wrt 7260 and 3160 devices
      iwlwifi: return -ENOMEM instead of NULL when OOM in iwl_drv_start()

Matti Gottlieb (1):
      iwlwifi: introduce external debug level

 drivers/net/wireless/iwlwifi/Kconfig            |  13 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h        |   2 +
 drivers/net/wireless/iwlwifi/iwl-drv.c          |  10 +-
 drivers/net/wireless/iwlwifi/iwl-fw.h           |   5 +
 drivers/net/wireless/iwlwifi/mvm/constants.h    |   9 +
 drivers/net/wireless/iwlwifi/mvm/d3.c           | 151 ++++----
 drivers/net/wireless/iwlwifi/mvm/debugfs.c      |  17 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h |  24 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api.h       | 228 +++++++++---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c     |  29 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h          |  27 +-
 drivers/net/wireless/iwlwifi/mvm/power.c        | 199 +++++++++-
 drivers/net/wireless/iwlwifi/mvm/rs.c           | 474 ++++----------------=
----
 drivers/net/wireless/iwlwifi/mvm/rs.h           |  64 +---
 drivers/net/wireless/iwlwifi/mvm/rx.c           |  61 ++-
 drivers/net/wireless/iwlwifi/mvm/time-event.c   |  96 +++--
 drivers/net/wireless/iwlwifi/pcie/drv.c         |   6 +-
 drivers/net/wireless/iwlwifi/pcie/rx.c          |  43 +--
 drivers/net/wireless/iwlwifi/pcie/trans.c       |  26 +-
 drivers/net/wireless/iwlwifi/pcie/tx.c          |  38 +-
 20 files changed, 809 insertions(+), 713 deletions(-)


--=-gMSd7Li3mSBK71NGJCYt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJSDgeZAAoJEDBSmw7B7bqrYjYP/iIppOsX/s9Rt1/nxnlKeFgN
T6IrJtzi5haYVRbSb6PlmtmSs7lEp2QWQ8m40qH6EDzhhCs6cIFIbXrjoM2i/nY6
CmCQjOHzw9leTrHFZneEjBgSJ7p6GzorCHM37zaCO/LnxU7iuRKpaeuLNYy+eLSD
qAo/O7LbIqG0PIkJHgp7t/rIJBqADvOWencDoAIaS6vOV6mRiCd+vSJuMkgkU0D5
0eDaU6sysF9g95EArf1qL/vSFRlE02KJjv6HGtnjckS1vOXuwLWrC6updizWdnas
qk3nhRKh47QRYHVB7UUSM/zRpFdD/fJDpYtQz+amCGakyGnCmIz5+cQDJEGv6gAN
jDnp/1ivzmlTG/DDVS3Pe1gD0UBrGEzNYj9WlB/L9j6UNqRQ9KUU7/nwC9PbHg6/
FUYXd9T29Xi092rQ0haRTDCPKodtb1fQ6311w+jzNKG4mR9Vf73KcxEhWe5vUwhl
Kk5JgOIaTqiRILMI4NpkmRsA59+IxwI0fs3hl5bOZ+59VWCXilmLhjccoBJ5f/My
iE4c5gk+vwhj57tyl5qlQ8nFM1NLCMbPN6ga/dKQZpdbmwruWMNw5En45oAjUrsJ
nRB2d1uFAT+Yr1iH5pI78rfONentzfezHibEgHZJd2PpJTRsSw2QA7ZwUOUzWiB5
FPCcYcKJFLe2ecUioca5
=hSii
-----END PGP SIGNATURE-----

--=-gMSd7Li3mSBK71NGJCYt--

