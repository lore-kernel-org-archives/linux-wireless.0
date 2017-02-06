Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:38554 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750953AbdBFRhb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Feb 2017 12:37:31 -0500
Message-ID: <1486402642.26003.141.camel@coelho.fi> (sfid-20170206_183734_781926_42FF8134)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Date: Mon, 06 Feb 2017 19:37:22 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-5zexLNiVty6fGIdciClB"
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2017-02-06
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5zexLNiVty6fGIdciClB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Here's my second pull-request intended for v4.11.  Just the usual set of
fixes, cleanups and improvements, together with the continued work on
support for new hardware.  A bit more details in the tag description.

I have sent this out before and kbuildbot didn't find any issues.  I
have also removed my favorite mistakes, namely the "commit" after the
Fixes tag. ;)

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 36401cb7ffae731295a6dd1ce2b40d7ad74245f4=
:

  brcmfmac: be more verbose when PSM's watchdog fires (2017-02-02 08:14:26 =
+0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2017-02-06

for you to fetch changes up to 8364fbb497f00de21d6d347194fa8b6bbae1d6f5:

  iwlwifi: mvm: support new beacon template command (2017-02-06 19:19:27 +0=
200)

----------------------------------------------------------------
Second batch of improvements and fixes for v4.11.

  * A bunch of bugfixes for the DQA code;
  * Work on support for new A000 devices continues;
  * Some clean-ups and general improvements

----------------------------------------------------------------
Beni Lev (1):
      iwlwifi: mvm: Use aux queue for offchannel frames in dqa

Emmanuel Grumbach (1):
      iwlwifi: mvm: fix PS-Poll enablement

Golan Ben-Ami (1):
      iwlwifi: mvm: support v2 of mfuart load notification

Johannes Berg (7):
      iwlwifi: mvm: reduce usage of IEEE80211_SKB_CB()
      iwlwifi: mvm: fix D3 replay counter value
      iwlwifi: mvm: set AID to firmware only for associated stations
      iwlwifi: mvm: overwrite skb info later
      iwlwifi: mvm/pcie: adjust A-MSDU tx_cmd length in PCIe
      iwlwifi: mvm: align copy-break SKB payload for MQ RX
      iwlwifi: pcie: fix another RF-kill race

Liad Kaufman (1):
      iwlwifi: mvm: release static queues on bcast release

Luca Coelho (2):
      iwlwifi: remove unnecessary argument to iwl_drv_start()
      iwlwifi: remove unnecessary cfg element in iwl_drv

Sara Sharon (12):
      iwlwifi: mvm: support unification of INIT and RT images
      iwlwifi: mvm: cleanup incorrect and redundant define
      iwlwifi: mvm: support new statistics APIs
      iwlwifi: mvm: support new scan API
      iwlwifi: mvm: always free inactive queue when moving ownership
      iwlwifi: mvm: support new alive notification
      iwlwifi: mvm: synchronize firmware DMA paging memory
      iwlwifi: pcie: fix the set of DMA memory mask
      iwlwifi: mvm: fix pending frame counter calculation
      iwlwifi: mvm: cleanup iwl_mvm_tx_mpdu a bit
      iwlwifi: support two phys for a000 devices
      iwlwifi: mvm: support new beacon template command

 drivers/net/wireless/intel/iwlwifi/iwl-a000.c         |  30 +++++--
 drivers/net/wireless/intel/iwlwifi/iwl-config.h       |   3 +-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h          |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c          |  25 +++---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.h          |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c           |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-mac.h   |   7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-scan.h  | 106 ++++++++++++++=
+-------
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-stats.h |  29 +++++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h    |  29 +++++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h       |  90 +++++++-------=
-----
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c       |   4 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c           | 354 ++++++++++++++=
++++++++++++++++++++++++++++++++---------------------------
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c     | 105 ++++++++++++--=
--------
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c     |  24 +----
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h          |  18 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c          |  24 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/power.c        |  44 ++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c           |  70 +++++++++++---=
-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c         |  11 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c         | 230 ++++++++++++++=
+++++++++++++++++++--------------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c          | 227 ++++++++++++++=
++++++++++++++++++++-------------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h          |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c           | 112 +++++++++-----=
---------
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c        |  16 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c         |  17 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h    |   2 +
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c          |   4 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c       |   8 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c          |  23 ++++-
 30 files changed, 1035 insertions(+), 587 deletions(-)
--=-5zexLNiVty6fGIdciClB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAliYtFIACgkQoUecoho8
xfo36w/8C+39wiMBCg+CTrXSYph/pne6EjxZ+srpvSDm2Ir40foz+wmDIzIcNUTQ
dgLRG66W3xvlNRRqcdgcAOopcMAaM4jaLFDYHu6sUl2RoeDmXpesHXioDWMLM4jv
zU2vxg6D5kFoz+tXrTeCpFHarpcOw8CCWVv3GOnL3ut1aqjN3e0ys2T5ZwwssteU
HyS+wUHDYSe2piLLNKXgqnO9zRx3ddY0Brlmht2gJq7TevEzxHvQ72aFQlYoZm7Z
H7dRI0tkMPqTp5xFiPso11eXiQaFVhxG5w/GaigzCHO3BfHzsmzQzlLoJo9Gb8c6
/Pe6+sa1ho3FdryNeaqsR5DKfcwjC+uRk1yAo18iMKTturT+jSzmYp8yksYhRhaJ
TT3e56USaDVTUfW0Ntew5zzmRVeLTq+QU232FsIYxR1EbnEhWNwf0JkHhCIGaW4D
6Xl5sURXw3TqWJd1dyBFrMYLHiHP/nfhSFPkH2LgRmCDmkoEcwOtBLc3xoE8+n3I
yMIVL696Y4G4YDMcQTGPyaypYS9E4lMRjmTPow4HECqbW2EtfHJoG1TNLXF18yaE
JWws0oRPv19XSrpdv/2sLZUMYXeHWfzBddhR2SJa9ODYuS5p9oA8pzTAgkDC1D5s
dKI64M+G1eGL/K1ROm+5VIODBC54CzoIeNowMWeZYkNimXnFZkk=
=Rs7K
-----END PGP SIGNATURE-----

--=-5zexLNiVty6fGIdciClB--
