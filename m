Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:53076 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1764645AbdDSTef (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Apr 2017 15:34:35 -0400
Message-ID: <1492630450.31741.87.camel@coelho.fi> (sfid-20170419_213445_040025_26459F2D)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Date: Wed, 19 Apr 2017 22:34:10 +0300
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-FdGnmHZd4x2I0o01mnj6"
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2017-04-19
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FdGnmHZd4x2I0o01mnj6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Here's my second pull-request intended for v4.12.  It includes the last
two patch series I sent out, namely 2017-04-13 and 2017-04-19.

This pull request has a small difference from the patch sets I sent out,
because I had to do a similar merge conflict resolution as you did.  Let
me know if you want me to send v2 of those series to reflect these small
changes (just for the record).

Kbuildbot didn't report any issues (before my conflict resolution).

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 26ecfe01790381c4caa65ec9cce484c623f092c4=
:

  brcmfmac: only build fwsignal module for CONFIG_BRCMFMAC_PROTO_BCDC (2017=
-04-19 14:39:44 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2017-04-19

for you to fetch changes up to 5a33254b5854058eede0acb53e3882b615560be7:

  iwlwifi: mvm: allow block ack response without data (2017-04-19 22:21:49 =
+0300)

----------------------------------------------------------------
Another series of patches intended for v4.12.  These are the changes:

 * Heavy work for the A000 device series;
 * Some cleanup patches;
 * A couple of fixes;
 * Dynamic SAR support;
 * Start supporting FW API version 31;
 * Geographical SAR support;
 * Support a few new PCI device IDs;

----------------------------------------------------------------
David Spinadel (1):
      iwlwifi: mvm: change TX_CMD_SEC_KEY_FROM_TABLE value

Emmanuel Grumbach (4):
      iwlwifi: mvm: tell the firmware about the U-APSD parameters
      iwlwifi: mvm: provide the actual number of frames for the SP len
      iwlwifi: split the handler and the wake parts of the notification inf=
ra
      iwlwifi: bump API to 31

Goodstein, Mordechay (1):
      iwlwifi: mvm: move new API code to the end

Haim Dreyfuss (2):
      iwlwifi: mvm: refactor SAR init to prepare for dynamic SAR
      iwlwifi: mvm: add GEO_TX_POWER_LIMIT cmd for geographic tx power tabl=
e

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
 drivers/net/wireless/intel/iwlwifi/iwl-8000.c         |    4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-9000.c         |    4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-a000.c         |   28 +-
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
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c   |    2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c         |   11 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h    |   42 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c          |    9 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c  |  147 +++++++++++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c       |   94 ++-----
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c     | 1018 +++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c          |  232 ++++++-------=
----
 44 files changed, 2815 insertions(+), 827 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
--=-FdGnmHZd4x2I0o01mnj6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlj3u7IACgkQoUecoho8
xfr2iw//bDlmVx5GpbosXKXigayRA5Weq2cntrDmEYov34lc9YOW3TNjYVkvJvus
fzLzn5tSGrkYMStD9O/KewO8gNkYB5nUzw+WZT28C8x0O8iqwB8UOiO6E7bcWMHW
Rcpu7LHAj+igsayou5B2vD8IJnz/vaRFk93WLlxNYbQPjrm9Cru8naLZ38PExmuH
cVLHE+dqb8sf+YDzeQJeQsF3HZAC5m8nWA/ieimUGaX9eKsSUDS3zAnUJ54XuOR6
z/Wqrp/Jy30k6uZDkjHw4pO9IhEoYQt+5NjJmLfnPF/06jSl/6pjpa1CnjkNANoP
bW4U/zFgjP9Ittu27o8y79tF0DICWSkN3U5dU1nF4Rfw8449jc0L6dsYfhKwTGy4
5Fwl7vS6zsGC8txhTjmQjpyDKceCIwsIASftYn0kxSY0BN3FS9vUSrmmQrwsGp32
xZpOqWz8YN7vg0Q7brynbuOZjQdlnTbZHclgtQJ41m543IKlSYWGUQDEXDgd9b54
+fzIrxecfiyuiB/RV/MzcTBLgv4buOPLhu5z84yqNvU0LsihJnsbnvRatnO1UfzW
ltReF3rqguRL3XkZYphhr2EjgxW1M1hYjvSj2mRtE2vXfd5VenekcpEy3K2MgBjY
vFgnqiOiE0Hwc1bDcam+qSxLYUa3YTt1eWqXnABoV648gBqRb7A=
=csqh
-----END PGP SIGNATURE-----

--=-FdGnmHZd4x2I0o01mnj6--
