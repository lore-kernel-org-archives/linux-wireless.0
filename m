Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36530 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752613AbdF3KIu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Jun 2017 06:08:50 -0400
Message-ID: <1498817319.22048.161.camel@coelho.fi> (sfid-20170630_120918_785157_E2A7FA31)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
Date: Fri, 30 Jun 2017 13:08:39 +0300
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-OTlrc0Ks5EZw3AYZmL8b"
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2017-06-30
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OTlrc0Ks5EZw3AYZmL8b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Here's my final pull-request intended for v4.13.=C2=A0 Again, this pull-
request includes the last two patchsets I sent out.=C2=A0 Most importantly,
it contains critical fixes and FW API changes to support the upcoming FW
that we will release publicly for the 9000 HW family.=C2=A0 More=C2=A0detai=
ls in
the tag description.

I have sent this out before, and kbuildbot reported success.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit fdcbe65d618af080ee23229f0137ffd37f2de36b=
:

  Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/a=
th.git (2017-06-28 22:10:48 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2017-06-30

for you to fetch changes up to ba320dd61ec91bbe98730f3407a486facc174d63:

  iwlwifi: bump MAX API for 8000/9000/A000 to 33 (2017-06-29 21:09:58 +0300=
)

----------------------------------------------------------------
Final set of patches for 4.13

* Some important fixes for 9000 HW;
* FW API changes for the upcoming -30 ucode release;
* A few new PCI IDs for 9000 series;
* Reorganization of common files;
* Some more fixes and improvements here and there
* Initialization and other important fixes for 9000 series;
* Support for version 30 of the FW API for 8000 and 9000 series;

----------------------------------------------------------------
Emmanuel Grumbach (5):
      iwlwifi: mvm: change when the BT_COEX is sent
      iwlwifi: mvm: don't send fetch the TID from a non-QoS packet in TSO
      iwlwifi: mvm: don't mess the SNAP header in TSO for non-QoS packets
      iwlwifi: pcie: propagate iwl_pcie_apm_init's status
      iwlwifi: pcie: wait longer after device reset

Haim Dreyfuss (2):
      iwlwifi: mvm: refactor geo init
      iwlwifi: mvm: Add debugfs entry to retrieve SAR geographic profile

Johannes Berg (31):
      iwlwifi: mvm: remove some CamelCase from firmware API
      iwlwifi: mvm: fix various "Excess ... description" kernel-doc warning=
s
      iwlwifi: mvm: remove various unused command IDs/structs
      iwlwifi: mvm: use __le16 even for reserved fields
      iwlwifi: mvm: add documentation for all command IDs
      iwlwifi: mvm: fix a bunch of kernel-doc warnings
      iwlwifi: dvm: use macros for format strings
      iwlwifi: pcie: only apply retention workaround on 9000-series A-step
      iwlwifi: pcie: fix 9000-series RF-kill interrupt propagation
      iwlwifi: mvm: use proper CDB check in PHY context modify
      iwlwifi: pcie: improve "invalid queue" warning
      iwlwifi: pcie: improve debug in iwl_pcie_rx_handle_rb()
      iwlwifi: unify external & internal modparam names
      iwlwifi: pcie: make ctxt-info free idempotent
      iwlwifi: pcie: warn if paging is already initialized during init
      iwlwifi: mvm: unconditionally stop device after init
      iwlwifi: mvm: fix deduplication start logic
      iwlwifi: mvm: rename iwl_shared_mem_cfg_v1 to the correct _v2
      iwlwifi: create new subdirectory for FW interaction
      iwlwifi: move notification wait into fw/
      iwlwifi: move configuration into sub-directory
      iwlwifi: mvm: remove version 2 of paging command
      iwlwifi: mvm: quietly accept non-sta assoc response frames
      iwlwifi: pcie: add MSI-X interrupt tracing
      iwlwifi: mvm: properly enable IP header checksumming
      iwlwifi: mvm: fix mac80211 queue tracking
      iwlwifi: mvm: map cab_queue to real one earlier
      iwlwifi: mvm: fix mac80211's hw_queue in DQA mode
      iwlwifi: pcie: reconfigure MSI-X HW on resume
      iwlwifi: mvm: remove DQA non-STA client mode special case
      iwlwifi: mvm: quietly accept non-sta disassoc frames

Liad Kaufman (3):
      iwlwifi: mvm: support aggs of 64 frames in A000 family
      iwlwifi: mvm: support multi tid ba notif
      iwlwifi: mvm: update rx statistics cmd api

Luca Coelho (2):
      iwlwifi: mvm: simplify CHECK_MLME_TRIGGER macro
      iwlwifi: bump MAX API for 8000/9000/A000 to 33

Sharon Dvir (1):
      iwlwifi: mvm: change sta_id to u8

Tzipi Peres (2):
      iwlwifi: add the new a000_2ax series
      iwlwifi: add twelve new 9560 series PCI IDs

 drivers/net/wireless/intel/iwlwifi/Makefile                               =
  |   6 +-
 drivers/net/wireless/intel/iwlwifi/{iwl-1000.c =3D> cfg/1000.c}           =
    |   0
 drivers/net/wireless/intel/iwlwifi/{iwl-2000.c =3D> cfg/2000.c}           =
    |   0
 drivers/net/wireless/intel/iwlwifi/{iwl-5000.c =3D> cfg/5000.c}           =
    |   0
 drivers/net/wireless/intel/iwlwifi/{iwl-6000.c =3D> cfg/6000.c}           =
    |   0
 drivers/net/wireless/intel/iwlwifi/{iwl-7000.c =3D> cfg/7000.c}           =
    |   0
 drivers/net/wireless/intel/iwlwifi/{iwl-8000.c =3D> cfg/8000.c}           =
    |   4 +-
 drivers/net/wireless/intel/iwlwifi/{iwl-9000.c =3D> cfg/9000.c}           =
    |   2 +-
 drivers/net/wireless/intel/iwlwifi/{iwl-a000.c =3D> cfg/a000.c}           =
    |  12 +-
 drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c                          =
  |  15 +-
 drivers/net/wireless/intel/iwlwifi/dvm/dev.h                              =
  |   4 +-
 drivers/net/wireless/intel/iwlwifi/dvm/lib.c                              =
  |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c                         =
  |   8 +-
 drivers/net/wireless/intel/iwlwifi/dvm/main.c                             =
  |   4 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rx.c                               =
  |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rxon.c                             =
  |   2 +-
 drivers/net/wireless/intel/iwlwifi/{iwl-fw-api.h =3D> fw/api.h}           =
    |  24 ++++
 drivers/net/wireless/intel/iwlwifi/{iwl-fw-error-dump.h =3D> fw/error-dump=
.h} |   0
 drivers/net/wireless/intel/iwlwifi/{iwl-fw-file.h =3D> fw/file.h}         =
    |   4 +
 drivers/net/wireless/intel/iwlwifi/{iwl-fw.h =3D> fw/img.h}               =
    |  10 +-
 drivers/net/wireless/intel/iwlwifi/{iwl-notif-wait.c =3D> fw/notif-wait.c}=
    |   2 +-
 drivers/net/wireless/intel/iwlwifi/{iwl-notif-wait.h =3D> fw/notif-wait.h}=
    |   0
 drivers/net/wireless/intel/iwlwifi/iwl-config.h                           =
  |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h                              =
  |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace-io.h                      =
  |  26 +++-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c                              =
  |  14 +-
 drivers/net/wireless/intel/iwlwifi/iwl-modparams.h                        =
  |  16 +--
 drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c                           =
  |  18 ---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h                            =
  |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c                             =
  |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c                               =
  |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c                          =
  | 293 ++++++++++++++++++++++++++-------------
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-coex.h                      =
  |  11 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-d3.h                        =
  |  11 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-mac.h                       =
  |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-power.h                     =
  |   9 ++
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rs.h                        =
  |   3 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h                        =
  |  37 +++--
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-scan.h                      =
  |  36 +++--
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h                       =
  |  63 ++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-stats.h                     =
  | 167 ++++++++++++++++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tof.h                       =
  |  14 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h                        =
  |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h                           =
  | 376 ++++++++++++++++++++++++++++++++++++++++-----------
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.h                           =
  |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c                               =
  | 123 ++++++++++-------
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c                         =
  |  32 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c                         =
  |  32 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h                              =
  |  33 +++--
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c                              =
  |  35 +++--
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c                         =
  |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c                               =
  |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h                               =
  |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c                               =
  |  83 ++++++++----
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c                             =
  |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c                              =
  |  32 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c                       =
  |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c                               =
  | 101 +++++++-------
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c                            =
  |  10 +-
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c                       =
  |   7 +
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c                             =
  |  25 +++-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h                        =
  |  17 +++
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c                              =
  |  41 ++++--
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c                      =
  |   8 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c                           =
  |  46 +++----
 65 files changed, 1299 insertions(+), 571 deletions(-)
 rename drivers/net/wireless/intel/iwlwifi/{iwl-1000.c =3D> cfg/1000.c} (10=
0%)
 rename drivers/net/wireless/intel/iwlwifi/{iwl-2000.c =3D> cfg/2000.c} (10=
0%)
 rename drivers/net/wireless/intel/iwlwifi/{iwl-5000.c =3D> cfg/5000.c} (10=
0%)
 rename drivers/net/wireless/intel/iwlwifi/{iwl-6000.c =3D> cfg/6000.c} (10=
0%)
 rename drivers/net/wireless/intel/iwlwifi/{iwl-7000.c =3D> cfg/7000.c} (10=
0%)
 rename drivers/net/wireless/intel/iwlwifi/{iwl-8000.c =3D> cfg/8000.c} (99=
%)
 rename drivers/net/wireless/intel/iwlwifi/{iwl-9000.c =3D> cfg/9000.c} (99=
%)
 rename drivers/net/wireless/intel/iwlwifi/{iwl-a000.c =3D> cfg/a000.c} (94=
%)
 rename drivers/net/wireless/intel/iwlwifi/{iwl-fw-api.h =3D> fw/api.h} (93=
%)
 rename drivers/net/wireless/intel/iwlwifi/{iwl-fw-error-dump.h =3D> fw/err=
or-dump.h} (100%)
 rename drivers/net/wireless/intel/iwlwifi/{iwl-fw-file.h =3D> fw/file.h} (=
99%)
 rename drivers/net/wireless/intel/iwlwifi/{iwl-fw.h =3D> fw/img.h} (98%)
 rename drivers/net/wireless/intel/iwlwifi/{iwl-notif-wait.c =3D> fw/notif-=
wait.c} (99%)
 rename drivers/net/wireless/intel/iwlwifi/{iwl-notif-wait.h =3D> fw/notif-=
wait.h} (100%)
--=-OTlrc0Ks5EZw3AYZmL8b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAllWIycACgkQoUecoho8
xfpR7Q//djFPtrtxgFygzB6rxZP4CdIvQiwUYtUpW8AZKd/jsUujYyvngItbLA3R
TAFHtcGRUfqbYv+mJhBMMrgicT1RM0auBbrW70zMJxbx2jHTKPoC242uaFbEnZhV
lkzExZzqSaFKj8y+wIH7fUDNPgFp8rbqzu0GxUvZiNmh9yUonDgsqFgPWyFOTAte
sTsmA957UVYM+Bf4jndJawp4pOurvwqPGx1QFtr7fLT+OtR1ODMfuNOpTaxQY5Pr
fWZnC8XpROlihEckk0tztSgn/lukmBlaFT2KRSsYMVcSZrgjACgR/jjCLPdD+5zu
1qxN20CIjLM4cg8Sg2kc692ECL8iDM0pfL86Miq1w49pfSFaV2xg5HOMIPVR9xi4
uYAI0tf/EKoqrRngJSXmlJXsLJqSjz3+eZTOvCV0BrOOVXymNXww6Kf5ol+z6TO8
VMGshTNBHeZgrpgUYAIVCHnCpCLHXzbu1/qNcoDjlY64z/kVnhB6FdAmAhLqpBxM
qIRSGVvryv9z2amB67kstkvDSoCVdpKBlK+aPcDr8OHunHfIQHcGippksxlPUOO0
f8UMAf08UTa3crUB5BzJkxwObxN1SMjXtfEBj1mDflwlV9frdg9rPSwSCrKPcLmV
WzciajIlKUdjPn+hrurk/7tp+qHiKFXPeEJpLj0IT1VaFHT/yMs=
=wNl1
-----END PGP SIGNATURE-----

--=-OTlrc0Ks5EZw3AYZmL8b--
