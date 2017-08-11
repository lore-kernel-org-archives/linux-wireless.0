Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:43546 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751299AbdHKHEU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Aug 2017 03:04:20 -0400
Message-ID: <1502435046.15969.207.camel@coelho.fi> (sfid-20170811_090424_524234_44FA7A20)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
Date: Fri, 11 Aug 2017 10:04:06 +0300
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-yEhHWham5Ev5KGTuV1TN"
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2017-08-11
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yEhHWham5Ev5KGTuV1TN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Here's my second pull-request intended for v4.14.=C2=A0 It contains
more=C2=A0generic development work, with improvements, bug fixes and
cleanup all around.=C2=A0 More=C2=A0details in the tag description.

I have sent this out before, and kbuildbot reported success.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 2db3aaba0a9fc769435477059c1224c439061752=
:

  rt2x00: Fix MMIC Countermeasures (2017-08-08 14:53:36 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2017-08-11

for you to fetch changes up to 88c5f476bac964eb96e751b004f5684c90629eab:

  iwlwifi: mvm: fix the coex firmware API (2017-08-09 21:14:44 +0300)

----------------------------------------------------------------
Sencond batch of iwlwifi patches for 4.14

* Some more code moved to a new directory;
* Fixes in LED handling;
* Some FW API updates;
* General fixes and cleanups here and there.

----------------------------------------------------------------
Bhumika Goyal (1):
      iwlwifi: mvm: add const to thermal_cooling_device_ops structure

Chaya Rachel Ivgi (2):
      iwlwifi: mvm: add debugfs to force CT-kill
      iwlwifi: mvm: set the default cTDP budget

Emmanuel Grumbach (3):
      iwlwifi: pcie: don't init a Tx queue with an SSN > size of the queue
      iwlwifi: pcie: free the TSO page when a Tx queue is unmapped on A000 =
devices
      iwlwifi: mvm: fix the coex firmware API

Golan Ben-Ami (2):
      iwlwifi: dump smem configuration when firmware crashes
      iwlwifi: fix nmi triggering from host

Haim Dreyfuss (1):
      iwlwifi: mvm: support new beacon template command

Johannes Berg (2):
      iwlwifi: mvm: remove useless condition in LED code
      iwlwifi: mvm: use firmware LED command where applicable

Liad Kaufman (1):
      iwlwifi: fix a000 RF_ID define

Luca Coelho (2):
      iwlwifi: fix a few instances of misaligned kerneldoc parameters
      iwlwifi: remove references to unsupported HW

Matt Chen (1):
      iwlwifi: mvm: don't send CTDP commands via debugfs if not supported

Sharon Dvir (1):
      iwlwifi: change functions that can only return 0 to void

Shaul Triebitz (2):
      iwlwifi: mvm: move a000 device NVM retrieval to a common place
      iwlwifi: mvm: add station before allocating a queue

Tzipi Peres (1):
      iwlwifi: add support of FPGA fw

 drivers/net/wireless/intel/iwlwifi/Makefile          |   2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/a000.c        |  14 +++++++++
 drivers/net/wireless/intel/iwlwifi/dvm/commands.h    |   8 +----
 drivers/net/wireless/intel/iwlwifi/fw/api/coex.h     |  14 +++------
 drivers/net/wireless/intel/iwlwifi/fw/api/commands.h |   5 +++
 drivers/net/wireless/intel/iwlwifi/fw/api/led.h      |  71 +++++++++++++++=
++++++++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h       |  19 ++++++++----
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c          |  38 +++++++++++++++=
+++++---
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h   |  30 +++++++++++++++=
+++
 drivers/net/wireless/intel/iwlwifi/fw/file.h         |   1 +
 drivers/net/wireless/intel/iwlwifi/fw/nvm.c          | 162 +++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
+++++++
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h      |   2 ++
 drivers/net/wireless/intel/iwlwifi/fw/smem.c         |   3 ++
 drivers/net/wireless/intel/iwlwifi/iwl-config.h      |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h         |   4 +--
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c         |  24 +++++----------
 drivers/net/wireless/intel/iwlwifi/iwl-io.c          |  14 ++-------
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h        |  13 +++++---
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c        |   7 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c     |  24 +++++++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h      |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c          |  15 +++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/led.c         |  59 +++++++++++++++=
++++++++++++--------
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c    |  47 +++++++++++++++=
+++++--------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h         |   6 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c         |  91 ---------------=
---------------------------------------
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c         |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c         | 108 +++++++++++++++=
+++++++++++++++++++++++---------------------------
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c          |   4 +--
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h   |   2 ++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c      |  20 +++++++++---
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c    |  16 ++++++++--
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c         |   4 +--
 33 files changed, 588 insertions(+), 242 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/led.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/nvm.c
--=-yEhHWham5Ev5KGTuV1TN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlmNVuYACgkQoUecoho8
xfqaGQ/9Hx1uaAfXIaxfw9BjUlDTU9M3HLLznRfNOhtBfXC1w4BjOpiI/+59kkdg
3UBLa4zILKlJUCv/vsnpuWBsT3LKmVrl5hRFAn9ZcE9RNQxRYhZr58ZL6M5dj+Lt
2o4X+biU8DaUtZv9UFnseFNmjLb081vv27DIxcRjcYBX5vpaCSzN1lqCohg4mzi8
szBCQZ3U0iBgpnHZjJymNHw0+IsVOgZEOOI9lpM8ZiyuJQokk3/WstliMwdZs5ac
UxQSAshsjeq6GDhfFtW1Hc8QRvWHDyX5abPb1GQK9sFCLb8MCfXl6+PT0oXTYfmn
yodfKJzUkRVMggytp4sClbO+zH1AsWF0Dj4mETi6P81RQjWgZ0G9BpOQ3KKICu/U
Un8zTJv4JwG/sRhy/gkalLSAO2dUFUslMuzoxD0ZkFX1rbgYLh6TVScKBbxYhaNX
RVTdpvGjtwIJPP1MUpbDq2ysryc74Z4bZSCYFZE8SG094q5O9ssrWQdYAPznJSwl
/wEGqANG2gnHPgiy8Os58Nc89VZ8NnSgz3EI/26Yds1bdUCOt/Dnxh/b3aD6nmSJ
Sw6TR0ksgo5KxH3iALf0/lWGyFqUz+SClQOu4c0xyREHxOIhk1DZljooj3tEnfWq
L+OiFQO0yBWoj2cnFxO++Aqpudy4jjcxcV3TrG6Ioo0KG1z6VSE=
=bZPZ
-----END PGP SIGNATURE-----

--=-yEhHWham5Ev5KGTuV1TN--
