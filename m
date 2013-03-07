Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53000 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab3CGJ5N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 04:57:13 -0500
Message-ID: <1362650225.8694.13.camel@jlt4.sipsolutions.net> (sfid-20130307_105718_479114_404F713C)
Subject: pull-request: iwlwifi-next 2013-03-07
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 07 Mar 2013 10:57:05 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-/N38/POkX9didYnK6KsP"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/N38/POkX9didYnK6KsP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

And another pull request - for iwlwifi-next.

Here, I also merged iwlwifi-fixes to avoid conflicts, and otherwise have
various cleanups and improvements on the MVM driver, along with a few
throughout the driver. Other than Bluetooth Coexistence from Emmanuel
there's no over-arching theme, so listing them would pretty much
reproduce the shortlog.

Please pull.

Thanks,
johannes


The following changes since commit 6dbe51c251a327e012439c4772097a13df43c5b8=
:

  Linux 3.9-rc1 (2013-03-03 15:11:05 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git fo=
r-john

for you to fetch changes up to 25b9ea5c797b5d78f8ceced9ad9c7a7daf0db19c:

  iwlwifi: mvm: the SCD byte count is a TLV flag (2013-03-06 16:48:03 +0100=
)

----------------------------------------------------------------
Amnon Paz (1):
      iwlwifi: fix indirect write bug

Beni Lev (2):
      iwlwifi: 7000: disable HT greenfield support
      iwlwifi: disable greenfield transmissions as a workaround

Dor Shaish (6):
      iwlwifi: mvm: Remove testing of static PIC in PhyDB
      iwlwifi: mvm: Set valid TX antennas value before calib request
      iwlwifi: mvm: Take the phy_cfg from the TLV value
      iwlwifi: mvm: Remove overriding calibrations for the 7000 family
      iwlwifi: mvm: don't use cts to self
      iwlwifi: mvm: Change NVM default section read size

Emmanuel Grumbach (20):
      iwlwifi: disable 8K A-MSDU by default
      iwlwifi: mvm: restart the NIC of the cmd queue gets full
      iwlwifi: mvm: ignore STOP_AGG when restarting
      iwlwifi: mvm: update the rssi calculation
      iwlwifi: mvm: don't warn on normal BAR sending
      iwlwifi: a few fixes in license
      iwlwifi: mvm: respect disable Tx AGG parameter
      iwlwifi: mvm: free AGG queue when we STA is removed
      iwlwifi: mvm: support IEEE80211_AMPDU_TX_STOP_FLUSH
      iwlwifi: dvm: pad iwl_compressed_ba_resp
      iwlwifi: make device configuration bus agnostic
      iwlwifi: mvm: add CARD_STATE_NOTIFICATION to the cmd strings
      iwlwifi: mvm: add BT Coex FW API
      iwlwifi: mvm: begin basic BT-Coex implementation
      iwlwifi: mvm: handle BT-coex notification
      iwlwifi: mvm: update SMPS when BT gets active
      iwlwifi: mvm: export last bt_notif through debugfs
      iwlwifi: mvm: update firmware API - MAC ID in RX
      iwlwifi: move firmware restart debugfs hook to op_mode
      iwlwifi: mvm: the SCD byte count is a TLV flag

Eytan Lifshitz (1):
      iwlwifi: mvm: advertise VHT capabilities

Ilan Peer (2):
      iwlwifi: mvm: Update MAC context filter flags
      iwlwifi: mvm: Add support for additional addresses

Johannes Berg (14):
      iwlwifi: always copy first 16 bytes of commands
      iwlwifi: mvm: fix AP/GO mode station removal
      iwlwifi: fix wakeup status query and packet reporting
      iwlwifi: don't map complete commands bidirectionally
      iwlwifi: rename IWL_MAX_CMD_TFDS to IWL_MAX_CMD_TBS_PER_TFD
      iwlwifi: use coherent DMA memory for command header
      Merge remote-tracking branch 'iwlwifi-fixes/master' into HEAD
      iwlwifi: support DSSS/CCK mode in 40 MHz
      iwlwifi: use __get_str in tracing
      iwlwifi: mvm: implement remote wake
      iwlwifi: mvm: set up initial SMPS/NSS station info
      iwlwifi: mvm: don't read system time when modifying AP/GO MAC
      iwlwifi: allow selecting only MVM driver
      iwlwifi: export symbols only conditionally

Wei Yongjun (1):
      iwlwifi: convert to use simple_open()

 drivers/net/wireless/iwlwifi/Kconfig               |  11 +-
 drivers/net/wireless/iwlwifi/Makefile              |   3 +-
 drivers/net/wireless/iwlwifi/dvm/agn.h             |   2 +-
 drivers/net/wireless/iwlwifi/dvm/calib.c           |   2 +-
 drivers/net/wireless/iwlwifi/dvm/calib.h           |   2 +-
 drivers/net/wireless/iwlwifi/dvm/commands.h        |   3 +-
 drivers/net/wireless/iwlwifi/dvm/debugfs.c         |  26 +-
 drivers/net/wireless/iwlwifi/dvm/lib.c             |   2 +-
 drivers/net/wireless/iwlwifi/dvm/scan.c            |   2 +-
 drivers/net/wireless/iwlwifi/dvm/sta.c             |   2 +-
 drivers/net/wireless/iwlwifi/dvm/testmode.c        |   2 +-
 drivers/net/wireless/iwlwifi/dvm/tx.c              |   2 +-
 drivers/net/wireless/iwlwifi/dvm/ucode.c           |   2 +-
 .../wireless/iwlwifi/{pcie/1000.c =3D> iwl-1000.c}   |   1 -
 .../wireless/iwlwifi/{pcie/2000.c =3D> iwl-2000.c}   |   1 -
 .../wireless/iwlwifi/{pcie/5000.c =3D> iwl-5000.c}   |   1 -
 .../wireless/iwlwifi/{pcie/6000.c =3D> iwl-6000.c}   |   1 -
 .../wireless/iwlwifi/{pcie/7000.c =3D> iwl-7000.c}   |  63 +++-
 drivers/net/wireless/iwlwifi/iwl-agn-hw.h          |   2 +-
 drivers/net/wireless/iwlwifi/iwl-config.h          |  49 ++-
 drivers/net/wireless/iwlwifi/iwl-csr.h             |   2 +-
 drivers/net/wireless/iwlwifi/iwl-debug.c           |  13 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.h        |  14 +-
 drivers/net/wireless/iwlwifi/iwl-drv.c             |  17 +-
 drivers/net/wireless/iwlwifi/iwl-drv.h             |  17 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c    |   9 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h    |   2 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom-read.c     |   5 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom-read.h     |   2 +-
 drivers/net/wireless/iwlwifi/iwl-fh.h              |   2 +-
 drivers/net/wireless/iwlwifi/iwl-fw-file.h         |   2 +-
 drivers/net/wireless/iwlwifi/iwl-fw.h              |   4 +-
 drivers/net/wireless/iwlwifi/iwl-io.c              |  19 +-
 drivers/net/wireless/iwlwifi/iwl-modparams.h       |   6 +-
 drivers/net/wireless/iwlwifi/iwl-notif-wait.c      |  15 +-
 drivers/net/wireless/iwlwifi/iwl-notif-wait.h      |   2 +-
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c       |  51 ++-
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.h       |   2 +-
 drivers/net/wireless/iwlwifi/iwl-op-mode.h         |   2 +-
 drivers/net/wireless/iwlwifi/iwl-phy-db.c          |  27 +-
 drivers/net/wireless/iwlwifi/iwl-phy-db.h          |   2 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h            |   2 +-
 drivers/net/wireless/iwlwifi/iwl-test.c            |  11 +-
 drivers/net/wireless/iwlwifi/iwl-test.h            |   2 +-
 drivers/net/wireless/iwlwifi/iwl-testmode.h        |   2 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h           |  22 +-
 drivers/net/wireless/iwlwifi/mvm/Makefile          |   2 +-
 drivers/net/wireless/iwlwifi/mvm/binding.c         |   2 +-
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c         | 347 +++++++++++++++++=
+++
 drivers/net/wireless/iwlwifi/mvm/d3.c              | 364 +++++++++++++++++=
++--
 drivers/net/wireless/iwlwifi/mvm/debugfs.c         | 138 +++++++-
 drivers/net/wireless/iwlwifi/mvm/fw-api-bt-coex.h  | 319 +++++++++++++++++=
+
 drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h       |  53 ++-
 drivers/net/wireless/iwlwifi/mvm/fw-api-mac.h      |   2 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h    |   2 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h       |   2 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h     |   2 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h      |   2 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h       |   2 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api.h          |  30 +-
 drivers/net/wireless/iwlwifi/mvm/fw.c              | 147 +--------
 drivers/net/wireless/iwlwifi/mvm/led.c             |   2 +-
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c        |  45 ++-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c        |  69 +++-
 drivers/net/wireless/iwlwifi/mvm/mvm.h             |  24 +-
 drivers/net/wireless/iwlwifi/mvm/nvm.c             |  11 +-
 drivers/net/wireless/iwlwifi/mvm/ops.c             |  30 +-
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c        |   2 +-
 drivers/net/wireless/iwlwifi/mvm/power.c           |   2 +-
 drivers/net/wireless/iwlwifi/mvm/quota.c           |   2 +-
 drivers/net/wireless/iwlwifi/mvm/rs.c              |  14 +-
 drivers/net/wireless/iwlwifi/mvm/rx.c              |  39 ++-
 drivers/net/wireless/iwlwifi/mvm/scan.c            |   2 +-
 drivers/net/wireless/iwlwifi/mvm/sta.c             |  97 +++++-
 drivers/net/wireless/iwlwifi/mvm/sta.h             |   4 +-
 drivers/net/wireless/iwlwifi/mvm/time-event.c      |   2 +-
 drivers/net/wireless/iwlwifi/mvm/time-event.h      |   2 +-
 drivers/net/wireless/iwlwifi/mvm/tx.c              |   8 +-
 drivers/net/wireless/iwlwifi/mvm/utils.c           |   2 +-
 drivers/net/wireless/iwlwifi/pcie/cfg.h            | 115 -------
 drivers/net/wireless/iwlwifi/pcie/drv.c            |   4 +-
 drivers/net/wireless/iwlwifi/pcie/internal.h       |  35 +-
 drivers/net/wireless/iwlwifi/pcie/rx.c             |  14 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c          |  25 +-
 drivers/net/wireless/iwlwifi/pcie/tx.c             | 299 +++++++++--------
 85 files changed, 2000 insertions(+), 696 deletions(-)
 rename drivers/net/wireless/iwlwifi/{pcie/1000.c =3D> iwl-1000.c} (99%)
 rename drivers/net/wireless/iwlwifi/{pcie/2000.c =3D> iwl-2000.c} (99%)
 rename drivers/net/wireless/iwlwifi/{pcie/5000.c =3D> iwl-5000.c} (99%)
 rename drivers/net/wireless/iwlwifi/{pcie/6000.c =3D> iwl-6000.c} (99%)
 rename drivers/net/wireless/iwlwifi/{pcie/7000.c =3D> iwl-7000.c} (58%)
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/bt-coex.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/fw-api-bt-coex.h
 delete mode 100644 drivers/net/wireless/iwlwifi/pcie/cfg.h


--=-/N38/POkX9didYnK6KsP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJROGRxAAoJEDBSmw7B7bqrupQP+wRwzVGP76mwVo+jB9fybchB
0vkf97gbEbmr4NHLV/lqmHTCLsppc4l8uLKSAZD6WSY71Zt/xp7zcvzuHwQXovDD
sAarYWug5LeKVK0782eIiomGI4jXC86Q3E9ftiL6zrs49GJ3d1vrqhJQKGp8BQZu
1ulgMNFYUb4gCle7StNu4/ZI3oLGq76CQUqN0v4rYLXXJ+c+Znqgnr7c4i4YJnMo
vChhPhpsRWLPou0Yq6Tn5jf4dGXKVmTcQQNk/2EUYzGpMW0QyaOP/kdQNDUOoL6U
ELwq8pzkrFFCz8cjmRdIDyUZddZq+FwA5MLsM0lcHuua718p+NMTu7Wuyd4CEIPp
C6alMpucXiE5xsvq8xetgAbyReDPqUqCN4GVKutjzqB69uDSJ9ECECRPLnl+Q+PX
LmQXm6Y9wlIHfMd3yjMoIeAoewGOlFsNAH9LTeHK80XM759+5zvMCWVgPHnB+ovR
qxGGYiFJh5EBmwPYoC7QPUO2LE/i+VzDfO6d4Y0wPT7l4rglIcD24DZAiQvN4BVB
ntfESRoRs0/g/3pa+RrvEHepYNfzTl/IeaJ/gRh/DpZLhhEBX5kJqViYeuY3MIq7
GqfherZ6/hPobioft2vJk864RPHj0wMPhnM2ixnKZuixnxoNbgCbk/IQT1lN2x2C
FaIccqQVav3qZuR0nbPO
=+T/7
-----END PGP SIGNATURE-----

--=-/N38/POkX9didYnK6KsP--

