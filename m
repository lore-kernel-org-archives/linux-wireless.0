Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59596 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751464AbdFFT2m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Jun 2017 15:28:42 -0400
Message-ID: <1496777308.9478.107.camel@coelho.fi> (sfid-20170606_212846_154879_5FB7B882)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 06 Jun 2017 22:28:28 +0300
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-keKtkwJOsXFqS+wKk96H"
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2017-06-06
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-keKtkwJOsXFqS+wKk96H
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Here's my first pull-request intended for v4.13.=C2=A0 This one is double t=
he
size of my normal pull-request since I'm sending to batches at once.  It
contain=C2=A0generic development work, with improvements, bug fixes and
cleanup all around.=C2=A0 More=C2=A0details in the tag description.

I have sent this out before, and kbuildbot reported success.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 219569ad0c41df7a7f999a2cad688c6b6ce173e2=
:

  rsi: use subdirectory for firmware file (2017-06-01 12:51:19 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2017-06-06

for you to fetch changes up to 0ae0bb3f409d48251a9a1730a514b3521d8f6042:

  iwlwifi: remove unnecessary code in iwl_trans_alloc_tx_cmd (2017-06-05 23=
:34:31 +0300)

----------------------------------------------------------------
First batch of iwlwifi driver patches 4.13

* Loads of FW API documentation improvements (for tools and htmldoc);
* Continued work for the new A000 family;
* Bumped the maximum supported FW API to 31;
* Improve the differentiation between 8000, 9000 and A000 families;
* A lot of fixes and cleanups here and there;

----------------------------------------------------------------
Beni Lev (1):
      iwlwifi: mvm: add TLV for NAN API differentiation

Haim Dreyfuss (1):
      iwlwifi: Add fw_name_pre_rf_next_step to support different rf steps

Johannes Berg (28):
      iwlwifi: mvm: fix endianness in lq_cmd declaration
      iwlwifi: mvm: document which group enums are used with which group ID
      iwlwifi: mvm: use proper sta_addr in firmware API
      iwlwifi: mvm: fix MCC endianness bug
      iwlwifi: mvm: use u8 for reserved fields
      iwlwifi: mvm: disentangle paging command structs
      iwlwifi: mvm: add documentation to some WoWLAN commands
      iwlwifi: mvm: fix some kernel-doc
      iwlwifi: mvm: add documentation links to various fields
      iwlwifi: mvm: disentangle binding command versions
      iwlwifi: mvm: create/name various enums
      iwlwifi: mvm: document structures used by commands
      iwlwifi: mvm: remove unused TX_CMD_NEXT_FRAME_*
      iwlwifi: kernel-doc: make proper links
      iwlwifi: mvm: remove unused REPLY_MAX
      iwlwifi: mvm: fix many kernel-doc warnings
      iwlwifi: mvm: document RX structures
      iwlwifi: mvm: check firmware is up in debugfs
      iwlwifi: mvm: use schedule_delayed_work()
      iwlwifi: mvm: add and use iwl_mvm_device_running()
      iwlwifi: mvm: convert ucode_loaded to a status bit
      iwlwifi: mvm: clear firmware running bit earlier
      iwlwifi: fix a kernel-doc tag
      iwlwifi: split firmware API from iwl-trans.h
      iwlwifi: mvm: link queue cmd docs to A000 command structs
      iwlwifi: mvm: document structures used for BEACON_TEMPLATE_CMD
      iwlwifi: mvm: link to TX commands in documentation
      iwlwifi: mvm: remove SCAN_GROUP

Liad Kaufman (5):
      iwlwifi: mvm: remove wrt support of page dumps in gen2
      iwlwifi: pcie: support page dumping in wrt in gen2
      iwlwifi: mvm: support init flow debugging
      iwlwifi: pcie: support dumping FH in a000 hw
      iwlwifi: mvm: disable prph collection in a000 hw

Luca Coelho (2):
      iwlwifi: bump max FW API to 31
      iwlwifi: remove unnecessary code in iwl_trans_alloc_tx_cmd

Mordechai Goodstein (1):
      iwlwifi: fw-api: cleanup cycle includes

Sara Sharon (12):
      iwlwifi: mvm: flush per station for DQA mode
      iwlwifi: mvm: support getting nvm data from firmware
      iwlwifi: mvm: support old method of NVM parsing
      iwlwifi: mvm: wait for the flushed queue only
      iwlwifi: update device ID for a000 family
      iwlwifi: add wait for tx queue empty
      iwlwifi: mvm: add AMSDU flag to offload assist
      iwlwifi: pcie: add AMSDU to gen2
      iwlwifi: cleanup references to 8000 family in NVM code
      iwlwifi: remove references to 8000 B-step devices
      iwlwifi: add dbgc_supported to transport configuration
      iwlwifi: add 9000 and A000 device families

 drivers/net/wireless/intel/iwlwifi/iwl-8000.c          |  10 +-
 drivers/net/wireless/intel/iwlwifi/iwl-9000.c          |  14 +-
 drivers/net/wireless/intel/iwlwifi/iwl-a000.c          |   8 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h        |  11 +-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h           |   8 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c           |   6 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.h           |  12 +-
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h            |   2 +
 drivers/net/wireless/intel/iwlwifi/iwl-fw-api.h        | 205 +++++++++++++=
++++++++++++++
 drivers/net/wireless/intel/iwlwifi/iwl-fw-error-dump.h |   8 +-
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h       |  16 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-io.c            |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-modparams.h     |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c     |  95 ++++++-------
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c         |   2 +
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h         | 167 +++----------=
---------
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c          |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h     |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c       |  82 ++++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-coex.h   |  10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-d3.h     |  29 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-mac.h    |  10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-power.h  |  45 +++---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rs.h     |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h     |  88 ++++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-scan.h   |  34 +++--
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h    |  46 +++---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-stats.h  |  29 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tof.h    |  18 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h     |  67 ++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h        | 555 +++++++++++++=
++++++++++++++++++++++++++++++++++++++++++++++++-----------
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c        |  52 +++----
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c            |  65 +++++----
 drivers/net/wireless/intel/iwlwifi/mvm/led.c           |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c      |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c      |  42 ++++--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h           |  25 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c           | 133 +++++++++++++=
+----
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c           |  32 +++--
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c          |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c           |  48 ++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h           |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/tdls.c          |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c    |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tof.c           |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c            |  18 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c            |  27 +++-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c          |  12 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h     |   3 +
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c        | 135 ++++++++++++-=
-----
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c      | 181 +++++++++++++=
++++++++++-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c           |   5 +-
 52 files changed, 1753 insertions(+), 645 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/iwl-fw-api.h
--=-keKtkwJOsXFqS+wKk96H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlk3AlwACgkQoUecoho8
xfoHZxAAonkli5mJTcp6b9yk7fUdL7RHKO8FrujHBnLnZGm9hqwEBISxi27vC3ps
aOiMHcuJig/eSdsV6KOdp8A2X3BXVpG1ak69T5+1/sNBXwlOdpO9lkVAPWdO9sZK
elJzYeidStZjLTdYEXPFRrQCf/GFoZ22dDLThd4WSVkTbFbW3nAmehJ0fKWX1EFy
kPNjlfDhOjU/jGUGmO9ADScOc5awUl1MSqs9SnFx5LzFF38Db5UPW1YHLw0SV+Et
Q8eCSyhdQKSFrLBLjc+vRpN5eph925wtV768i5LB7zzBKa9+D7XWBgKdVltOqWXf
2ZibAIdidr+S5hPZWQPaKP+f+fUf3ct9aI3SmnNpCAcr9UFOVGqKDwc2B8Td3A0r
2W2b3DpB31AkrZtgaQHs2qyb5+VWxj9mLFzlo9Ws4n97d69fm/d1P8sd2eXJaZ8b
0XcHYGEpGFYxIuttwf5A9aj0yZKnvhei8UyTf+3I8yds63AB8+5+BzhZZtlL4GQE
treYTmyoaRWgoazBRROCDmqfFrYMVkoCegoI3lS5Zxf6wJrz9csy4seYgyDoHfhY
djxj1bmProrSdjduM7jr9gSPljIWMUzmWvWbIppyQsnZE2Q+zc50HacRVKbNnBjc
3YBBEg+EM0Nqdd7Ug+2fxmJEGW3JfnXeR1N+goBhsYhhsh5MPvE=
=4mm8
-----END PGP SIGNATURE-----

--=-keKtkwJOsXFqS+wKk96H--
