Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:39428 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726631AbeHBJpG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Aug 2018 05:45:06 -0400
Message-ID: <0919a20b8b06324dd8e408a1f136c64c6e0dd4de.camel@coelho.fi> (sfid-20180802_095513_512705_FE1654E7)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Date: Thu, 02 Aug 2018 10:55:06 +0300
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-RszgWp1dIijITEVOqy/8"
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2018-08-02
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RszgWp1dIijITEVOqy/8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

This is another batch of patches intended for v4.19.  Usual development
work, mostly focused on the new 22560, and some other small fixes and
improvements.  More details about the contents in the tag description.

I have sent this out before and kbuildbot this morning, but I didn't
get any replies from it yet.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 24ebfcbdd1ba623daa1ba140067d7b6102bcfe0d=
:

  rt2x00: remove redundant functions rt2x00mac_sta_{add/remove} (2018-07-31=
 10:27:40 +0300)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2018-08-02

for you to fetch changes up to 45904e7edcd08730d1888cb79071654e344774a7:

  iwlwifi: pcie: split tx to amsdu and non amsdu (2018-08-02 10:50:09 +0300=
)

----------------------------------------------------------------
More iwlwifi patches for 4.19

* New PCI IDs for 22000 and 22560;
* Some fixes and an improvement in debug dumps and recording;
* Remove some old dead code;
* Fix compilation when only IPv6 is not enabled;
* Continued work on 22560 devices;

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: pcie: don't access periphery registers when not available

Golan Ben Ami (4):
      iwlwifi: pcie: support rx structures for 22560 devices
      iwlwifi: support new rx_mpdu_desc api
      iwlwifi: hard code power save mode to CAM for 22560 devices
      iwlwifi: move some msix and rx functions to a common place

Luca Coelho (4):
      iwlwifi: pcie: add a bunch of PCI IDs for 22000 and 22560
      iwlwifi: d3: disable dbg recording before entering D3
      iwlwifi: mvm: remove dead gscan code
      iwlwifi: pcie: include tcp.h implicitly

Sara Sharon (6):
      iwlwifi: pcie: unionize used bd and completion descriptor
      iwlwifi: pcie: move rxb retrieval to a helper function
      iwlwifi: trans: add a new op for getting DMA data
      iwlwifi: mvm: configure multi RX queue
      Revert "iwlwifi: implement fseq version mismatch warning"
      iwlwifi: pcie: split tx to amsdu and non amsdu

Shahar S Matityahu (1):
      iwlwifi: allow masking out memory areas from the fw dump

 drivers/net/wireless/intel/iwlwifi/Makefile          |   1 -
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c       |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/alive.h    |  18 +------
 drivers/net/wireless/intel/iwlwifi/fw/api/commands.h |   7 ---
 drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h |   7 +++
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h       | 211 +++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++----------------
 drivers/net/wireless/intel/iwlwifi/fw/common_rx.c    |  88 ---------------=
---------------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c          | 284 +++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++----------------------------------=
-------
 drivers/net/wireless/intel/iwlwifi/fw/file.h         |  40 ++------------
 drivers/net/wireless/intel/iwlwifi/fw/img.h          |  37 +------------
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h      |   3 --
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c         |  67 +++++----------=
--------
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h       |  27 ++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c          |   7 +++
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c     |   8 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c          |  48 +++++++++++++++=
--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c    |   7 ---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c         |  20 ++++---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c        |  95 +++++++++++++++=
++++++++++--------
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c        |  25 +++++++--
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h   |  78 +++++++++++++++=
++++++++++--
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c         | 170 +++++++++++++++=
+++++++++++++++++++++++--------------------
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c      | 174 +++++++++++++++=
+++++++++++++++++---------------------------
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c    | 150 +++++++++++++++=
+++++++++++++++++++-----------------
 24 files changed, 936 insertions(+), 638 deletions(-)
 delete mode 100644 drivers/net/wireless/intel/iwlwifi/fw/common_rx.c
--=-RszgWp1dIijITEVOqy/8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAltiuNoACgkQoUecoho8
xfqy6g//ZjAZiJCivWqy84sZvDQsIjmYZVKGssPFJkhoBBvfX8sapd5bZFKpM1kF
VfgDA2kSbUbUWqNYYLRsSCjvbpx1RLz61h9xUMXRuQs2OgfjIAcGcns7B+hSxKqP
Lh9pcOPbaCPGv3zZSYHpHi5/cmdyDorLuX49uZi6uzoVnWkUZO3ATCPQpT9E05Gh
Vn36l+MM4Jh7tAC2q/ETWBOrb4CEMEZLbj1WO3Jjb/06r7D6jPJHhJFCYXXwMGq2
kbTZMPi/iCcNmXIqqgki3txLT6nrNj1ozAbIbtCIsFuk9oN7qJhyJJwx2xUWGHqQ
KPKZDwwcpFHhGRyuhNKxU3wGmqrw5W4Y64z2oJeQzQc9rDfZ9tMEEW88XL61r4gA
llOLTlzvE5Rcq4nDifLbSq+G7FVtZ3YcL750h3ZM/68vTSH07JP+hY3FTEiKfULN
i+QXv+XXFFqkAdLmSXubOJJJQP3+dR4xFExsV02SKBLuzdgrgUr0M3LJ2X6AWkOz
1XZZGW8CRw/OTHKkCqS6y67+MnYgGvsSI30DSm0cwjyEvR7dlm1WPegER5M19diS
urXmfZSk6MKcPPw61w/cxZQ8tEmoTVTGco3iA01ARO0RUJ/nBgAgCaIbNr9FH3rd
mczPOzYIEHE8sZwgqWF4uTgDtv0zLb/GBHorgaTYgtVz6R0o0qM=
=8mTO
-----END PGP SIGNATURE-----

--=-RszgWp1dIijITEVOqy/8--
