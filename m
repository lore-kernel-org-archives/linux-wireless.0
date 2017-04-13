Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51168 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751083AbdDMMel (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 08:34:41 -0400
Message-ID: <1492086857.31741.20.camel@coelho.fi> (sfid-20170413_143445_583813_EFCD691B)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Date: Thu, 13 Apr 2017 15:34:17 +0300
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-ap8De3enMNK43Q6t/mkR"
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2017-04-13
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ap8De3enMNK43Q6t/mkR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Here's my first pull-request intended for v4.12.  This is generic
development work, nothing really stands out.  More
details in the tag description.

I have sent this out before, and kbuildbot reported success.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 1aed89640a899cd695bbfc976a4356affa474646=
:

  mwifiex: apply radar flag (2017-04-05 15:54:52 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2017-04-13

for you to fetch changes up to 87d0e1af9db3bff4ec2f68fd4d032f89c23867a4:

  iwlwifi: mvm: separate queue mapping from queue enablement (2017-04-11 15=
:25:00 +0300)

----------------------------------------------------------------
Patches intended for v4.12:

  * Some small fixes here and there;
  * The usual cleanups and small improvements;
  * Work to support A000 devices continues;
  * New FW API version;
  * Some debugging improvements;

----------------------------------------------------------------
Emmanuel Grumbach (2):
      iwlwifi: mvm: add DQA_ENABLE_CMD to the command list
      iwlwifi: pcie: print less data upon firmware crash

Golan Ben-Ami (1):
      iwlwifi: mvm: support MFUART dump in case of MFUART assert

Johannes Berg (3):
      iwlwifi: mvm: fix RX SKB header size and align it properly
      iwlwifi: use upper_32_bits/lower_32_bits where appropriate
      iwlwifi: pcie: use iwl_get_dma_hi_addr()

Liad Kaufman (1):
      iwlwifi: add support for 9000 HW B-step NICs

Luca Coelho (4):
      iwlwifi: be more verbose about needed firmware
      iwlwifi: remove support for deprecated RF
      iwlwifi: mvm: bump max API to 30
      iwlwifi: remove unnecessary dev_cmd_headroom parameter

Sara Sharon (14):
      iwlwifi: mvm: support new binding API
      iwlwifi: mvm: adjust new API of compressed BA
      iwlwifi: mvm: cleanup pending frames in DQA mode
      iwlwifi: mvm: add multicast station
      iwlwifi: mvm: support new ADD_MODIFY_STA_KEY command
      iwlwifi: mvm: optimize reorder timeout frame releasing
      iwlwifi: mvm: don't assume static queue numbers
      Revert "iwlwifi: introduce trans API to get byte count table"
      iwlwifi: pcie: remove the active field in struct iwl_txq
      iwlwifi: pcie: use WFPM_GP for debugging D3 flows
      iwlwifi: pcie: introduce split point to a000 devices
      iwlwifi: pcie: add context information support
      iwlwifi: mvm: remove call for paging in new init flow
      iwlwifi: mvm: separate queue mapping from queue enablement

 drivers/net/wireless/intel/iwlwifi/Makefile           |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-7000.c         |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-8000.c         |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-9000.c         |  46 +++++--------
 drivers/net/wireless/intel/iwlwifi/iwl-a000.c         |   5 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h       |  12 ++--
 drivers/net/wireless/intel/iwlwifi/iwl-context-info.h | 203 ++++++++++++++=
++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h          |   1 -
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c          |  34 +++++++--
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h           |   6 +-
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h      |   5 ++
 drivers/net/wireless/intel/iwlwifi/iwl-io.c           |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h         |   2 +
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c        |   7 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h        |  28 ++------
 drivers/net/wireless/intel/iwlwifi/mvm/binding.c      |  17 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c           |  20 +++++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h   |  34 +++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h    |   5 ++
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h       |  40 +++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c           |  32 ++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c     |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c     |  34 +++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h          |  25 ++++---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c          |  12 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c           |  18 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c         |  20 ++++--
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c          | 241 ++++++++++++++=
++++++++++++++++++++++++++++----------------------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h          |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c           |  49 ++++++-------
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c        |  34 +++++----
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c   | 274 ++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c         |  17 ++---
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h    |  53 ++++++++++++--
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c          |  48 ++++++++++---
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c  | 226 ++++++++++++++=
++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c       | 218 ++++++++++++++=
+++++++++++++++-----------------------------
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c          |  99 ++++++++++++++=
++-----------
 38 files changed, 1462 insertions(+), 422 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/iwl-context-info.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
--=-ap8De3enMNK43Q6t/mkR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAljvcEkACgkQoUecoho8
xfrnLxAAjpLl2T+U/viBVow60a4tBRAtXrriPuyBOiRhyvCz7ZR72rttiA/aanxo
uoLJ+GUrQThu2Per/0hL7WHV0y3c0aaFIf1c1YpQmnrLgNX9xgybgQoaIce/Fjn9
AzlXh0ZgMkyN5w0W0pzaq+y+0EBFiaOZ4JwSXDCAEiwvhn7/Ao4FMg+OhEzDiAtZ
Ea6kacv6hXk2eVowFhfOUZE1WhGsZ/+Erw3tchusdzqzp2SaIQBzh/UWI09AQewX
6W2KNVYEP31EvqwjylFiVDvIKIfMtS6uvpTsZcb9YbH3+sw96RbE0saMO1+zR57d
76SxKeD8NF3lsGMcP7jrB05DTOcLpZeiKA6tE3FGkSFWlAJ6jX73O85ta/SO+m/H
RPzYlBUXSDQYQYXnVJZVEI94vWIGkXL+2lZStmea7G0AZgdB+/lQqy4UZIyQOi3+
rTaeSw6yy0AXSBZcGPY5GPNG8AEMEqZFwDzgBQc8Rlhygd+FmFBZPEK+LWSbepPV
VpdCAlTcyLneiyZO/dWY9y7fwWx9SMtjit8Z2OIZnNTQm+dVH12TXXuPUjCsM4ya
qwrpAtd0WdXNOJ9mG6Ujxp0QzYerAVkRkR+L/PANKlJtw3eQBl0un4K7b1nbS1xR
OrvyBAWEIPu3B3w1rC6siPRxWP4xhU+Ry7EnlptmtV/4rZLKgmo=
=vMef
-----END PGP SIGNATURE-----

--=-ap8De3enMNK43Q6t/mkR--
