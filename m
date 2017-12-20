Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51432 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753342AbdLTQbq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Dec 2017 11:31:46 -0500
Message-ID: <1513787503.4827.488.camel@coelho.fi> (sfid-20171220_173150_794039_204A068D)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, janet.morgan@intel.com, joe.konno@intel.com
Date: Wed, 20 Dec 2017 18:31:43 +0200
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-j6vAuTAwdcEfCHYRujrh"
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2017-12-20
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-j6vAuTAwdcEfCHYRujrh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

This is my third batch of patches intended for v4.16.  Nothing major
here, just the usual continued development.  More details about the
contents in the tag description.

I have sent this out before and kbuildbot reported success.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit f39a5c01c3d24f2f61ec9d8c7d7e81f9aca506ce=
:

  Merge branch 'nfp-flower-add-Geneve-tunnel-support' (2017-12-19 14:52:13 =
-0500)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2017-12-20

for you to fetch changes up to 4243edb4704ed950a43440dfb4cbd5613db6ab6c:

  iwlwifi: define and use if iwl_mvm_has_tlc_offload (2017-12-20 18:28:25 +=
0200)

----------------------------------------------------------------
Third batch of updates for v4.16

* Small cleanups in the new rate-scaling code;
* Some improvements in debugging;
* New FW API changes;
* Fix a bug where we got a false-positive warning;
* Fix forced quota debugfs functionality;

----------------------------------------------------------------
Emmanuel Grumbach (2):
      iwlwifi: fw: fix the enums in the rate scaling API
      iwlwifi: define and use if iwl_mvm_has_tlc_offload

Golan Ben Ami (2):
      iwlwifi: support internal debug data collection for new devices
      iwlwifi: avoid duplicate sw reset executions in the code

Mordechay Goodstein (2):
      iwlwifi: runtime: sync FW and host clocks for logs
      iwlwifi: add skb address to tx cmd in trace events data

Sara Sharon (2):
      iwlwifi: mvm: support RX flags API change
      iwlwifi: mvm: don't warn on multiple packets when opening a queue

Shaul Triebitz (3):
      iwlwifi: mvm: force quota update upon NoA setting
      iwlwifi: mvm: adjust to quota offload
      iwlwifi: mvm: send the low latency command

 drivers/net/wireless/intel/iwlwifi/Makefile               |   1 +
 drivers/net/wireless/intel/iwlwifi/fw/api/debug.h         |   4 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/mac-cfg.h       |  19 +++++++++
 drivers/net/wireless/intel/iwlwifi/fw/api/rs.h            |  34 ++++++++--=
------
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c           | 195 ++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
+++++++
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.h           |  87 ++++++++++=
+++++++++++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/fw/file.h              |  33 ++++++++++=
++++--
 drivers/net/wireless/intel/iwlwifi/fw/img.h               |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/init.c              |  13 ++++++-
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h           |  14 ++++++-
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace-iwlwifi.h |   7 ++--
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c              |  99 ++++++++++=
+++++++++++++++++++++++++++++--------
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h            |   9 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c          |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c         |   6 +--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h              |   6 +++
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c              |   6 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/quota.c            |   4 ++
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c               |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c               |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c             |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c              |   5 +--
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c               |   8 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c            |  30 ++++++++++=
++---
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h        |   7 ----
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c      |   4 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c           |  77 ++++++++++=
++++++++++++++------------
 27 files changed, 582 insertions(+), 104 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/debugfs.h
--=-j6vAuTAwdcEfCHYRujrh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlo6kG8ACgkQoUecoho8
xfrI7Q//XWiKF+Q6KfxJXPmlyr0lQhHr4N92QCUza8TEbRXOQBsM9zaATsv8RNr1
yycNagT0NYzlLpe+Bj/3p7tPPqvbhHDGWPRQlGwvqWlSYoSDuy9PqiWBWWQMG3wx
BZQYiX8HYxGcWn+5zvb1ygA5tQ3bcb1SJeGuc9gl4vC3Qh88K9oCSuv8DJKognry
7M85HCOOboLEiN2Z+f6E9bi7ho+SSNEsxlfmGix+YxIqMYvaGVM7qyX8+sD/Z5ng
cONBMCjE9UBqtHhsfv8j5269+mm/QoDZdtkcy2UX6kG2Q2ccx195wXfDp1AHvYB2
24VZoxn4RszJUDuQXJ6jl94TrGF2JvbCTy5swSKci0gsy0Ll1gdTP70rGKf2cUrD
qvp2q4MupWPt5yxaP0Ye+KfMi0d4O86n3NuizdeeVps7EOqQ0AAskLbPmSrG0Xvx
M1dpnsrRevFzzuZdOCqXa67ep14XxR6Bhng06acYxuMvIWeV4oTCdp5n3BHZ6koc
229eC1rr8Z4UPSsTZxglazGozFiFxBdoLUCl/dF9OX2MN47lFwIiYsGHDk10xzOU
N1FGCQSqlInVb/LHrTqhxNYK+pfi0MzgOjdPf8Enf2QhXQG/ni2nx17XoTBj5JV0
aTshEoeB/Y5CvojmTSytKEQGh9qmXwcnGgENNQyLfwTJNIu5APc=
=9ebu
-----END PGP SIGNATURE-----

--=-j6vAuTAwdcEfCHYRujrh--
