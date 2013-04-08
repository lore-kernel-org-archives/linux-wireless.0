Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52586 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab3DHLl1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 07:41:27 -0400
Message-ID: <1365421282.25475.11.camel@jlt4.sipsolutions.net> (sfid-20130408_134130_299128_AA323E71)
Subject: pull-request: iwlwifi-next 2013-04-08
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 08 Apr 2013 13:41:22 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-nOijQpZpfcBIaBSPuCeS"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nOijQpZpfcBIaBSPuCeS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

And also another pull request for iwlwifi-next.

The biggest work here is Bluetooth coexistence and power saving. Other
than that, I have a few small fixes that weren't really needed for 3.9
and a new PCI ID.

johannes


The following changes since commit 64513ef449e3beaacb801d41467f47642683e35a=
:

  b43: remove warning for LP-PHY with sprom < 8 (2013-03-25 16:47:06 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git fo=
r-john

for you to fetch changes up to 2d055afdcada4bd8b510e9d2a8566fbded3c9696:

  iwlwifi: dvm: handle FLUSH ampdu actions from mac80211 (2013-04-08 13:32:=
20 +0200)

----------------------------------------------------------------
Alexander Bondar (9):
      iwlwifi: mvm: downgrade to old power management API
      iwlwifi: mvm: Rename some power management definitions and methods
      iwlwifi: mvm: don't disable power management due to P2P device
      iwlwifi: mvm: Fix active-to-powersave transition time units
      iwlwifi: mvm: always send power table command
      iwlwifi: mvm: set keepalive period regardless of PM state
      iwlwifi: mvm: encapsulate power table command log message
      iwlwifi: mvm: change active-to-powersave transition time for BPS
      iwlwifi: mvm: remove redundant iwl_power_get_params()

Emmanuel Grumbach (9):
      iwlwifi: mvm: ignore bt_ch_announce module parameter
      iwlwifi: mvm: split long debug print
      iwlwifi: mvm: implement reduced Tx power
      iwlwifi: mvm: remove BT Coex constraints upon roaming to A band
      iwlwifi: mvm: beautify code in BT Coex
      iwlwifi: mvm: clean up invalid station handling
      iwlwifi: mvm: rename iwl_mvm_new_bt_coex_notif
      iwlwifi: mvm: remove users of nvm_data->valid_tx_ant
      iwlwifi: dvm: handle FLUSH ampdu actions from mac80211

Ilan Peer (1):
      iwlwifi: mvm: Sync FW API time event notification change

Johannes Berg (5):
      Merge remote-tracking branch 'wireless-next/master' into iwlwifi-next
      iwlwifi: mvm: add per-interface debugfs with mac_params file
      iwlwifi: print opmode when firmware is loaded
      iwlwifi: sleep for at least 10 seconds
      iwlwifi: print warning on request_module failure

Shuduo Sang (1):
      iwlwifi: add new pci id for 6x35 series

 drivers/net/wireless/iwlwifi/dvm/agn.h          |   6 +-
 drivers/net/wireless/iwlwifi/dvm/lib.c          |  16 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c     |   7 +-
 drivers/net/wireless/iwlwifi/dvm/tx.c           |  45 ++++
 drivers/net/wireless/iwlwifi/iwl-drv.c          |  14 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h        |   3 +-
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c      | 333 ++++++++++++++++++++=
----
 drivers/net/wireless/iwlwifi/mvm/d3.c           |   9 +-
 drivers/net/wireless/iwlwifi/mvm/debugfs.c      | 119 +++++++++
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h |  64 ++---
 drivers/net/wireless/iwlwifi/mvm/fw-api.h       |  33 ++-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c     |  31 ++-
 drivers/net/wireless/iwlwifi/mvm/mvm.h          |  27 +-
 drivers/net/wireless/iwlwifi/mvm/power.c        | 115 ++++----
 drivers/net/wireless/iwlwifi/mvm/rs.c           |  36 +--
 drivers/net/wireless/iwlwifi/mvm/sta.c          |   8 +-
 drivers/net/wireless/iwlwifi/mvm/sta.h          |   2 +
 drivers/net/wireless/iwlwifi/mvm/time-event.c   |  10 +-
 drivers/net/wireless/iwlwifi/mvm/tx.c           |  14 +-
 drivers/net/wireless/iwlwifi/mvm/utils.c        |   2 +-
 drivers/net/wireless/iwlwifi/pcie/drv.c         |   1 +
 drivers/net/wireless/iwlwifi/pcie/tx.c          |   2 +-
 22 files changed, 678 insertions(+), 219 deletions(-)


--=-nOijQpZpfcBIaBSPuCeS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRYqziAAoJEDBSmw7B7bqr+JMP/1rF4fSarp5CloNBWxA03DoC
wa6dLHu63DAo//B4uk01oV8OO4TBm1bZV+/Zd/O4ioXN5AlwAKx/Cd/IpGF8ohLV
Dc4PeeDXoTy41LGxHJBmz1fqlkyxNsManRLA0yQdFubWYioaMtA1/hrut+rM4qVj
qYOmox10P6RvUlgdYVgwnGJv8dq88+00EJrjMh3jYbqGxgXr9+Fsg7WWsoBdnRBa
uou42+r21rDS6mElaFAU9+Mnpymm16dqGsGHGkbYIQCKbYpPPzeVcyATk+yPGGu8
8w8O8bYsgi89USSBmLwvcVo6u5zjKlHfaZAu2GNylqutVUqe7XES5595EKjrLS3L
XaQRyLtySay9IX6gooEuTyE2mCkr4z/EML1/KTm3xJogF1CG5IZvMlVpUwHyaHzg
1yQ7SA/wzQ8TkhW/zB0ecDNc024LZZFIWxPW/6aQ8TVhFXOsF6EmYEMlj8OOxgbj
kwaFOTA2GldjH5UfskwyQmnYIfKEIk45vBbRtZVmPJZhk78PFsbDYGz2VWjw5BXu
x8pohOzjrSQSBxquXa87xoBqtbrVsoEzgayXAUHwEDA2HXjgLcG85tY76YJvzvm/
5xjwhhr8YuoEGarscyi+8+D20+FE+m4J0BLWimLVM+BHBulYB9sOEtoVLMNszmYC
9cA6jb+suZQLFoqonR7B
=oc7b
-----END PGP SIGNATURE-----

--=-nOijQpZpfcBIaBSPuCeS--

