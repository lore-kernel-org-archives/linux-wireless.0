Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41790 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755982AbeDZMpi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Apr 2018 08:45:38 -0400
Message-ID: <d70efddcc5ef39561504f61eb0069281b76d8ce2.camel@coelho.fi> (sfid-20180426_144627_574826_0B600FAE)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Date: Thu, 26 Apr 2018 15:45:34 +0300
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-92c5D/K9+OVoZpOD2E7q"
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2018-04-26
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-92c5D/K9+OVoZpOD2E7q
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

This is the second batch of patches intended for v4.18.  Nothing major
here, just the usual continued development, bugfixes, new FW APIs and
some new features.  More details about the contents in the tag
description.

I have sent this out before and kbuildbot reported success.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 0ddcf3e76ae4d02918e609342a1020b50258fadd=
:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-driver=
s.git (2018-04-26 13:26:37 +0300)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2018-04-26

for you to fetch changes up to d3a6f7fb97fc34a38e40cc56392e701598f99863:

  iwlwifi: mvm: set wakeup filters for wowlan "any" configuration (2018-04-=
26 15:18:07 +0300)

----------------------------------------------------------------
Second batch of iwlwifi patches for 4.18

* Some preparations for new hardware;
* A workaround to rescan the bus for the rare situation when older
  devices become irresponsive,
* Hardening of the firmware loading code to avoid issues with
  corrupted files;
* A few clean-ups and bugfixes.

----------------------------------------------------------------
Eliad Peller (2):
      iwlwifi: pcie: allow sending pre-built A-MSDUs
      iwlwifi: mvm: set wakeup filters for wowlan "any" configuration

Golan Ben Ami (2):
      iwlwifi: allow different csr flags for different device families
      iwlwifi: support new csr addresses for hw address

Golan Ben-Ami (1):
      iwlwifi: introduce Image Loader (IML) - new firmware image

Johannes Berg (1):
      iwlwifi: mvm: move skb padding reservation earlier

Luca Coelho (5):
      iwlwifi: cfg: remove unnecessary cfg data in non-dvm devices
      iwlwifi: fw: harden page loading code
      iwlwifi: fw: combine loading of last page block into main copy loop
      iwlwifi: pcie: remove non-responsive device
      iwlwifi: make bitfield a u32 instead of u16

Sara Sharon (1):
      iwlwifi: mvm: remove check for non low latency TIDs

 drivers/net/wireless/intel/iwlwifi/cfg/1000.c        |   8 +++---
 drivers/net/wireless/intel/iwlwifi/cfg/2000.c        |  13 ++++++---
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c       |  10 ++++---
 drivers/net/wireless/intel/iwlwifi/cfg/5000.c        |   8 +++---
 drivers/net/wireless/intel/iwlwifi/cfg/6000.c        |  19 +++++++++-----
 drivers/net/wireless/intel/iwlwifi/cfg/7000.c        |  12 ++++-----
 drivers/net/wireless/intel/iwlwifi/cfg/8000.c        |  10 +++----
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c        |   6 ++---
 drivers/net/wireless/intel/iwlwifi/fw/file.h         |   3 +++
 drivers/net/wireless/intel/iwlwifi/fw/img.h          |   6 +++++
 drivers/net/wireless/intel/iwlwifi/fw/paging.c       |  78 +++++++++++++++=
+++++++++++++++++----------------------
 drivers/net/wireless/intel/iwlwifi/iwl-config.h      |  87 +++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++---
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h         |  28 ++-------------=
-----
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c         |  14 ++++++++++
 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.c |   8 +++---
 drivers/net/wireless/intel/iwlwifi/iwl-modparams.h   |   2 ++
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c   |  14 +++++++---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h       |   5 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c          |  15 +++++++----
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c         |   3 +++
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c        |  20 +++++++-------
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c          |   1 -
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c       |   8 +++---
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h   |   5 ++++
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c         |   3 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c |  15 +++++++----
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c      | 139 +++++++++++++++=
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------=
-------
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c         |  24 +++++++++++----=
--
 28 files changed, 400 insertions(+), 164 deletions(-)
--=-92c5D/K9+OVoZpOD2E7q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlrhye4ACgkQoUecoho8
xfpXrRAApp84owG1QLSVU1Ca7j8HVkM6sQeHMiURp1il4VAI18CKT1p8f6gkUyJ0
eOXLFzttV7I/Ssm1bDezIXLnqWIHQRbKMWjL+PXisw3wqrr3/uTGE3Ebyp/1Khy1
wBgRk0FveE/hvpFsdiO7WLrv8Ni5L2FIS9fW4N9eb8FaCJ4dPFHx90s6+JTwc6Ly
3POM2r/aKPeiVUUmZMYb5NQT1RSn6UwPX1Jkneto2AgDCOo1X0o12wFtdTjebcDb
oG/egPZGdeDxeD7ymYQa3Cq6WsXKzNdNSluZ5qkmq/v1SFELhUDU4ui4hsNRz14S
Ul6x8HRJDBmanXxgj3u38H2ygdDhR/KQe2GX1zdBzSpwH/Wy6L3djDd3LVwcipbi
O2UH0eCau/Gmr0WOVkpaXAEtuNqLUWQrKvbvvqNF4GKaCX/sgufHWiXtvkKrND0h
pJuk0MjCI0pTLdf5zZ08xyjRH8N+xsl7bTPeMv/S9VTRMyprZO7+MCu4Ywq+S6Fo
dtObJRt/I/EoXiYLB2nqYz/LbcK4uBon4KrFasvthFglv4XGsx5mCt6CopnS+baA
9bFxmqLyFkl9NI+ni7pDc/wrUqbrPI2hbZPaO6RzayKeSkmQMG9SEGkDVKF3zm/6
beXTgIJqiPFXujJB9SF0OlEoqkIM59H6J4T+Zp0vnWetD64hjPM=
=WzkQ
-----END PGP SIGNATURE-----

--=-92c5D/K9+OVoZpOD2E7q--
