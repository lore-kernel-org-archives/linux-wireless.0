Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36784 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753325AbdAZUbE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Jan 2017 15:31:04 -0500
Message-ID: <1485462650.26003.11.camel@coelho.fi> (sfid-20170126_213108_222494_231C1AD8)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Date: Thu, 26 Jan 2017 22:30:50 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-qOL/YLurkDg2m+TT2YRf"
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2017-01-26
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qOL/YLurkDg2m+TT2YRf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Here's my first pull-request intended for v4.11.  It has a bunch of
fixes, cleanups and improvements here and there, as well as a few new
features.  More details in the tag description.

I have sent this out before and kbuildbot didn't find any issues.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 106e0deca1ac6ac627a10617fe77a95200cb01a7=
:

  rtlwifi: rtl8192cu: Convert driver to use common macros (2017-01-20 12:06=
:10 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2017-01-26

for you to fetch changes up to 758c98e089389e90732fe45087fdee3177493a81:

  iwlwifi: mvm: cleanup redundant assignment (2017-01-26 09:39:02 +0200)

----------------------------------------------------------------
Some improvements, bugfixes and new features:
 * A bunch of cleanups here and there;
 * A few simple bugfixes;
 * Some more work in preparation for A000 family support;
 * Add support for radiotap timestamps;
 * Some work on our firmware debugging capabilities;

----------------------------------------------------------------
Johannes Berg (5):
      iwlwifi: mvm: expose device timestamp in radiotap
      iwlwifi: mvm: accept arbitrary memory dump TLVs
      iwlwifi: mvm: make iwl_dump_prph() void
      iwlwifi: allow memory debug TLV to specify the memory type
      iwlwifi: mvm: properly check for transport data in dump

J=C3=BCrg Billeter (1):
      iwlwifi: fix MODULE_FIRMWARE for 6030

Kirtika Ruchandani (3):
      iwlwifi: mvm: rs: Remove unused 'mvmvif'/'mvmsta' variables
      iwlwifi: mvm: rs: Remove unused 'mcs' variable
      iwlwifi: pcie: trans: Remove unused 'shift_param'

Luca Coelho (7):
      iwlwifi: mvm: don't restart HW if suspend fails with unified image
      iwlwifi: mvm: bump max API to 28
      iwlwifi: mvm: remove unused variable in iwl_mvm_handle_statistics()
      iwlwifi: dvm: make rs_tl_get_load() return void
      iwlwifi: mvm: remove unused sta_id variable in iwl_mvm_change_queue_o=
wner()
      iwlwifi: dvm: remove unused variable compiler warning in debugfs.c
      iwlwifi: mvm: mark ret as maybe_unused in iwl_dbgfs_fw_restart_write(=
)

Sara Sharon (9):
      iwlwifi: mvm: simplify paging allocation code
      iwlwifi: mvm: replace the number of blocks calculation
      iwlwifi: enlarge number of ucode sections
      iwlwifi: mvm: change iwl_mvm_tx_csum to return value
      iwlwifi: mvm: separate rate calculation to a new function
      iwlwifi: mvm: support version 2 of stored beacon notification
      iwlwifi: pcie: cleanup rfkill checks
      iwlwifi: mvm: use mvm_disable_queue instead of sharing logic
      iwlwifi: mvm: cleanup redundant assignment

 drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c  |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c       |  11 +++----
 drivers/net/wireless/intel/iwlwifi/dvm/ucode.c    |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-6000.c     |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-7000.c     |   4 +--
 drivers/net/wireless/intel/iwlwifi/iwl-8000.c     |   4 +--
 drivers/net/wireless/intel/iwlwifi/iwl-9000.c     |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-a000.c     |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c      |  98 ++++++++++++++++++=
+++++++++++++++++--------------------------
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h  |  24 +++++++--------
 drivers/net/wireless/intel/iwlwifi/iwl-fw.h       |   7 +++--
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c       |  13 +++++----
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c  |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h   |   6 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c   | 123 ++++++++++++++++++=
+++++++++++++++++++++++++++++++----------------------------
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c       |  69 ++++++++++++------=
-------------------------
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |   9 +++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      |   4 +--
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c       |  10 +------
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c       |   2 --
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      |  31 +++++-------------=
--
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c       | 107 ++++++++++++++++++=
++++++++++++++++++-------------------------------
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c    |  14 ++++-----
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c   |  51 ++++++++++++++----=
--------------
 26 files changed, 299 insertions(+), 304 deletions(-)

--=-qOL/YLurkDg2m+TT2YRf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAliKXHoACgkQoUecoho8
xfqGuA//YxS2dHFXatVt+nybNkXsMOzxaNw2K37NblvrnRRyCp+2KOHKmAWijPGa
DAiOG3GoLy5nUKyk9uJRGkmldwdBXbR19atkjUMrfrUXJWUPAkat+Ji0o4uhyqLJ
F6SoKuNdV94IV+YIJBtSeH2VIG+otoy2uY27uZa47qNoX+X3qPEpaRsF6nC7sxQQ
qTk9xBsw5nJzlplqio46CLtNt8G9+mAYl/vLoUFsTCz3GYKRChtdaHCQByFc1/SM
Jfbu/OErcrpcnUAx9XsChUXWqrM7k5MHMRtitVHaByFuwP3LT3wbFqmCSt202p8+
fouHOh/sJR8UsFvvM0XzKqVDwQMHXNbTme46/R4JbdG9ZD0+aj/IWDK72XhVAHB2
pFDDmeIO04OJbbJFoAKZeQn+50fvj0EZxmJC9WSCihWFIcda2yfNRmXDHAMurHxh
TZX0jY/gqgPKemfAaWjwwxiT08/upN4MKg+gPmeIW/1p1iY+xB2KwPoMSKIMicuq
OeK3q1oru/P3iR2gQMwioWwN58HEMTddtEjksVcxejBz1wZOF6CNEBTkkt/9kFV4
BtcPHBnAjRe17RBgI5YkRypUJKpIeDtFsXixxpOGk2dNiJO00u2A6oYWUTcNrVwU
oBnZ3+cWO1IrSQEy5GO/v+wePYUaSFe7UANfSES48ScK3D+JrC4=
=Dflg
-----END PGP SIGNATURE-----

--=-qOL/YLurkDg2m+TT2YRf--
