Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40564 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754442AbeDTI7J (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Apr 2018 04:59:09 -0400
Message-ID: <92c9f150ac2ef6cf7fcf48f153eab9c4c7205804.camel@coelho.fi> (sfid-20180420_105914_404428_2CA63FCC)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, janet.morgan@intel.com, joe.konno@intel.com
Date: Fri, 20 Apr 2018 11:59:03 +0300
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-fXfPOVlRbxS9JixtMDbU"
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2018-04-20
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fXfPOVlRbxS9JixtMDbU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

This is the first batch of patches intended for v4.18 (or whatever
Linus turns out to call it ;).  Nothing major here, just the usual
continued development, bugfixes, new FW APIs and some new
features.  More details about the contents in the tag description.

I have sent this out before and kbuildbot reported success.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 5d1365940a68dd57b031b6e3c07d7d451cd69daf=
:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2018-04-12=
 11:09:05 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2018-04-20

for you to fetch changes up to bd8f3fc613919b50038c949f80b3f350a166293e:

  iwlwifi: mvm: support 22000 HW opening agg before traffic (2018-04-20 10:=
57:16 +0300)

----------------------------------------------------------------
iwlwifi patches for 4.18

* implement Traffic Condition Monitor;
* use TCM for scan and BT coex;
* use TCM to detect when the AP doesn't support UAPSD properly;
* some more work for the 22000 family of devices;
* introduce AMSDU rate control offload;
* a couple of clean-ups and bugfixes.

----------------------------------------------------------------
Emmanuel Grumbach (3):
      iwlwifi: mvm: BT Coex - make the primary / secondary pick traffic awa=
re
      iwlwifi: pcie: implement the overlow queue for Gen2 devices
      iwlwifi: mvm: set the MFP flag for keys that are used by MFP stations

Gregory Greenman (1):
      iwlwifi: mvm: support offload of AMSDU rate control

Haim Dreyfuss (1):
      iwlwifi: move timestamp functions from debugfs.h to dbg.h

Johannes Berg (2):
      iwlwifi: mvm: detect U-APSD breaking aggregation
      iwlwifi: mvm: clean up scan capability checks

Liad Kaufman (2):
      iwlwifi: support api ver2 of NVM_GET_INFO resp
      iwlwifi: mvm: support 22000 HW opening agg before traffic

Luca Coelho (5):
      iwlwifi: mvm: add traffic condition monitoring (TCM)
      iwlwifi: mvm: use TCM data to decide scan priority
      iwlwifi: mvm: fix OOC priority in scans
      iwlwifi: use flags to denote modifiers for the channel maps
      iwlwifi: remove upper case letters in sku_capa_band_*_enable

Naftali Goldstein (1):
      iwlwifi: mvm: update rs-fw API

Sara Sharon (7):
      iwlwifi: mvm: detect low latency and traffic load per band
      iwlwifi: pcie: allocate shorter TX queues for 22000 devices
      iwlwifi: Revert "iwlwifi: pcie: dynamic Tx command queue size"
      iwlwifi: add TX queue size parameter to TX queue allocation
      iwlwifi: pcie: use the queue size as sent by opmode
      iwlwifi: mvm: use shorter queues for mgmt and auxilary queues
      iwlwifi: mvm: use the new get_tid function

Shaul Triebitz (3):
      iwlwifi: move all NVM parsing code to the common files
      iwlwifi: pcie: gen2: fix race in cmd fifo write ptr
      iwlwifi: get rid of fw/nvm.c

 drivers/net/wireless/intel/iwlwifi/Makefile           |   2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c        |   1 -
 drivers/net/wireless/intel/iwlwifi/dvm/main.c         |   8 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h  |   5 --
 drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h   |  42 ++++++----
 drivers/net/wireless/intel/iwlwifi/fw/api/rs.h        | 156 +++++++++++++-=
---------------------
 drivers/net/wireless/intel/iwlwifi/fw/api/txq.h       |   2 +
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h           |  36 ++++++++
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c       |   1 +
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.h       |  31 -------
 drivers/net/wireless/intel/iwlwifi/fw/nvm.c           | 162 --------------=
----------------------
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h       |   1 -
 drivers/net/wireless/intel/iwlwifi/iwl-config.h       |   5 +-
 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h |   5 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c    | 354 ++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h    |  56 +++++++++----
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h        |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c         |  37 +++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h    |   7 ++
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c           |   7 ++
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c  |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c      |  25 ++++++
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c           |  10 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c     |  33 ++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h          | 101 ++++++++++++++=
+++++----
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c          | 208 +++-----------=
--------------------------------
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c          |  15 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c        | 117 ++++++++++++++=
------------
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c           |  15 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h           |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c           | 103 ++++++++++++++=
++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c         |  13 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c         | 194 ++++++++++++++=
+++++++++++++++++------------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c          |  28 +++++--
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h          |   7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c           |  57 ++++++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c        | 430 ++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
++++---
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c   |   2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h    |   5 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c     |  55 +++++++++----
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c          |  28 ++-----
 42 files changed, 1605 insertions(+), 776 deletions(-)
 delete mode 100644 drivers/net/wireless/intel/iwlwifi/fw/nvm.c
--=-fXfPOVlRbxS9JixtMDbU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlrZq9cACgkQoUecoho8
xfogiRAAifiKkc1PBvrcMEoa3G0QCXZinwnjGzTIhS375bZ1fHZOWrE9MVWg2iLs
CP6pXa1qpoHCIJwqR6rKPUTTONKu+P6qjH+jdVtq1RSYxD08aENa0GHL2Ezh8N0f
58DWRtmZdZzsDkxJ4VZJ+mtedA6cdctrbWIR6eybi6Sj8rOX7EzKFswWtBR3nqGQ
bWqeZHRagqDAVEhNToe2IcRmXXMcvKh9yXc75dnU2f+fNnGIQv2s2qq5qFRI0ZK4
5Fm5uH2FBFLLq8L2gPbSwCllcMz7Ui5qLQz1vFlh2LQDxJYTJv4Ph5nPchduSIlf
fRE4vZ7ezQgjOUVay4YXha/0wS+gr+YU/SDtwt+EvBeo9Y3B7x0nhUHlzuqKaeJT
KfRowSIu3tOABVaOP/zL3PDO/hkt2dcqs5QXlYIQ6IyaOYisyG8ybO/+VkiZMSoR
PN1oOVVu8sCEy6/uLOwV/8mDBtPAd3iKGP/IXHhimpB01oFYb3FJWUpEoQg9TGot
UQycTk96lWH1os2u82Dw0nWvbuzMy43NHrSR52NFklvpE+kxqcqyFjQEYgFUcgkP
+BWqOAExAZneBE+5TbzrSApm1Qxt7pd4qgq8YVly6r1r/k+VU2Opssdfwijw31WO
FzywT9jiGpE8uY3LimFK4k29HJmDJwlG8PPIZR+5Pwu5ylYlaxk=
=0Hl1
-----END PGP SIGNATURE-----

--=-fXfPOVlRbxS9JixtMDbU--
