Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:53174 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752044AbdDTE7k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Apr 2017 00:59:40 -0400
Message-ID: <1492664371.31741.91.camel@coelho.fi> (sfid-20170420_065947_377675_1FC74265)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Date: Thu, 20 Apr 2017 07:59:31 +0300
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-7buxBuDGAUK20jB3fNRD"
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2017-04-19-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7buxBuDGAUK20jB3fNRD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Here's v2 of=C2=A0my second pull-request intended for v4.12.  It includes t=
he
last three patch series I sent out, namely 2017-04-13, 2017-04-19 and
the 2 fixes by Johannes that I sent a few minutes ago.

I also removed the "bump API to 31" patch.  I'll send a diff=C2=A0between
this tag and the HEAD of the patches I sent in the 2017-04-19 series.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 26ecfe01790381c4caa65ec9cce484c623f092c4=
:

  brcmfmac: only build fwsignal module for CONFIG_BRCMFMAC_PROTO_BCDC (2017=
-04-19 14:39:44 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2017-04-19-2

for you to fetch changes up to 718ceb22a0ccd0b3a02a4bd401d944a1eb16f3ce:

  iwlwifi: pcie: free context info in case of failures (2017-04-20 07:28:03=
 +0300)

----------------------------------------------------------------
Another series of patches intended for v4.12.  These are the changes:

 * Heavy work for the A000 device series;
 * Some cleanup patches;
 * A few fixes;
 * Dynamic SAR support;
 * Geographical SAR support;
 * Support a few new PCI device IDs;

----------------------------------------------------------------
David Spinadel (1):
      iwlwifi: mvm: change TX_CMD_SEC_KEY_FROM_TABLE value

Emmanuel Grumbach (3):
      iwlwifi: mvm: tell the firmware about the U-APSD parameters
      iwlwifi: mvm: provide the actual number of frames for the SP len
      iwlwifi: split the handler and the wake parts of the notification inf=
ra

Goodstein, Mordechay (1):
      iwlwifi: mvm: move new API code to the end

Haim Dreyfuss (2):
      iwlwifi: mvm: refactor SAR init to prepare for dynamic SAR
      iwlwifi: mvm: add GEO_TX_POWER_LIMIT cmd for geographic tx power tabl=
e

Johannes Berg (2):
      iwlwifi: pcie: fix mutex leak in gen2 start
      iwlwifi: pcie: free context info in case of failures

Liad Kaufman (2):
      iwlwifi: mvm: remove unneeded reg write in iwl_mvm_up()
      iwlwifi: a000: fix memory offsets and lengths

Luca Coelho (5):
      iwlwifi: mvm: spin off SAR profile selection function
      iwlwifi: mvm: add support for EWRD (Dynamic SAR) ACPI table
      iwlwifi: mvm: remove unnecessary debugging from UMAC scan
      iwlwifi: mvm: remove unnecessary label in iwl_mvm_handle_rx_statistic=
s()
      iwlwifi: pcie: remove RSA race workaround

Sara Sharon (34):
      iwlwifi: mvm: read new secure boot registers
      iwlwifi: mvm: add queues after adding station
      iwlwifi: cleanup unused function
      iwlwifi: mvm: prepare for station count change
      iwlwifi: mvm: use same scan API for all a000 devices
      iwlwifi: mvm: disable multi-queue for a000 devices
      iwlwifi: mvm: support new TX API
      iwlwifi: pcie: introduce a000 TX queues management
      iwlwifi: mvm: support a000 SCD queue configuration
      iwlwifi: mvm: support moving to mgmt tid
      iwlwifi: pcie: copy TX functions to new transport
      iwlwifi: pcie: cleanup old transport code from gen2
      iwlwifi: pcie: support new TX command
      iwlwifi: pcie: rewrite TFD creation
      iwlwifi: pcie: support host commands in new transport
      iwlwifi: pcie: support new write pointer width
      iwlwifi: pcie: remove block and freeze operations from new transport
      iwlwifi: pcie: prepare for dynamic queue allocation
      iwlwifi: pcie: introduce new stop_device
      iwlwifi: pcie: alloc queues dynamically
      iwlwifi: pcie: get rid of txq id assignment
      iwlwifi: mvm: support new TX response for TVQM
      iwlwifi: move to TVQM mode
      iwlwifi: mvm: do not turn on RX_FLAG_AMSDU_MORE
      iwlwifi: mvm: work around HW issue with AMSDU de-aggregation
      iwlwifi: mvm: ignore BAID for SN smaller than SSN
      iwlwifi: mvm: support change to a000 smem API
      iwlwifi: support a000 CDB product
      iwlwifi: mvm: support init extended command
      iwlwifi: mvm: disable RX queue notification for a000 devices
      iwlwifi: mvm: dump frames early on invalid rate
      iwlwifi: mvm: flip address 4 of AMSDU frames
      iwlwifi: mvm: support changing band for phy context
      iwlwifi: mvm: allow block ack response without data

Tzipi Peres (1):
      iwlwifi: add four new 8265 and 8275 series PCI IDs

 drivers/net/wireless/intel/iwlwifi/Makefile           |    2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-9000.c         |    2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-a000.c         |   26 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h       |   15 +-
 drivers/net/wireless/intel/iwlwifi/iwl-notif-wait.c   |   10 +-
 drivers/net/wireless/intel/iwlwifi/iwl-notif-wait.h   |   25 +-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h         |    7 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h        |   77 +++++-
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c         |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c           |    6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c  |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c      |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-mac.h   |    4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-power.h |   43 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-scan.h  |   14 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h   |   16 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h    |   86 ++++--
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h       |   67 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c       |  287 ++++++++++++-=
--------
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c           |  498 +++++++++++++=
++++++++++++++--------
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c     |   10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c     |   19 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h          |   58 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c          |   14 +-
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c     |   21 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c           |   93 ++++---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c         |   67 +++--
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c         |   85 +++---
 drivers/net/wireless/intel/iwlwifi/mvm/sf.c           |    6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c          |  291 +++++++++++++=
+-------
 drivers/net/wireless/intel/iwlwifi/mvm/tdls.c         |   22 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tof.c          |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c           |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c           |  124 +++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c        |   74 +++++-
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c   |    7 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c         |   11 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h    |   42 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c          |    9 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c  |  152 ++++++++++-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c       |   94 ++-----
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c     | 1018 +++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c          |  232 ++++++-------=
----
 43 files changed, 2818 insertions(+), 826 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
--=-7buxBuDGAUK20jB3fNRD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlj4QDMACgkQoUecoho8
xfonAg//X448wBOmXelfG8FPUeKRJE6Cvc97PKdkfNuVIgWEH6gLhGS9lrtpf3Ud
hnm12R0eOJTyV23CgZnMI/cYU0SS3VrnOb6764HsmMW0VP337cQyvsOliZMa104O
SUydqbGnI60TIa5JxPLM/62jpfM9Jx7280E8WSQkliilpwzo8RvfY5oWq7+bV56m
xpPuL2ft8+uQ5ytaCHNRriV0xXVxoCLtanQOo+Mpl0JcHd37F9emJ9TCGMjYOU9k
HpLAny+HZLxlmJeBzpZ/gZxKjEvttd69Q7Lqg9MhKHiHqmjaoSiAwn+7yjv8NqGd
ucqzvbf3V5nfKHTslmvk2axJeZViiErC+Z3c2qmmgo1kuEmQEGonELGyMZePrDcx
W4iaOvrbX6vmn9+J6jWh2cpGt2+Q3xPeXjzqsFIBX3GtBRMDWF4DQJ19oLQ/Kyqg
Rp3rUlXFzzOh9w4Z9Ny56K6nnIYzFhqgQ1u19edict2E3vNkJ0ucP04QZhNOMMnx
bk0teWsHMSt18KKdHYLEw7VgNQuuuBQbFP4N9sdoZPFQKW+HiGfuzU2gey3Mz+rg
ErtHSIUDuOEbgzBqrMOu79I1piF2etmLJPKYMLQAJGXEMUDXMfki6y1QiR8KWsrv
8SAIteMvCO7RNUDm8QX4qHfaY/Z+1cHf6ldRhkEAhHU4MD1UE+M=
=9uEc
-----END PGP SIGNATURE-----

--=-7buxBuDGAUK20jB3fNRD--
