Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51850 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751901AbdJFMDl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Oct 2017 08:03:41 -0400
Message-ID: <1507291417.908.130.camel@coelho.fi> (sfid-20171006_140350_487150_E9E2946E)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, linuxwifi@intel.com
Date: Fri, 06 Oct 2017 15:03:37 +0300
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-aC02EOIzYeeVhbzb/j01"
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2017-10-06
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aC02EOIzYeeVhbzb/j01
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Here's my first pull-request intended for v4.15.  It
contains the last two patch sets I sent out.

I have sent this out before and kbuildbot reported success.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit a7c9acc452b21b56c99dd7dfe0ab542f7baa6563=
:

  brcmfmac: Delete redundant length check (2017-10-02 17:07:00 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2017-10-06

for you to fetch changes up to c4152ad91d5c865b9002cb6e6480b17c81dc64f4:

  iwlwifi: remove dflt_pwr_limit from the transport (2017-10-06 14:57:26 +0=
300)

----------------------------------------------------------------
First batch of iwlwifi patches for 4.15

* Cleanups: - remove an unused value that we read from the NVM;
            - remove link quality measurement code that was never used;
* One FW command API update;
* A fix and an addition for PCI devices for the A000 family;
* Tiny refactor of ref/unref code used by runtime-PM;
* Some debugging improvements;
* Implementation of a more flexible way to define command queue sizes;
* ACPI code refactoring;
* Some coding-style fixes;
* Avoid redundant command to the firmware;
* Add a struct with the format of one FW command;
* Change an error log to a warning when the FW API is not aligned with
  the driver (important during development);
* Change a WARN_ON to WARN_ONCE to make it more descriptive and less
  noisy (i.e. no repeated warnings on a firmware triggered error);
* Dump PCI registers when an error occurs, to make it easier to debug;

----------------------------------------------------------------
Chaya Rachel Ivgi (1):
      iwlwifi: remove redundant reading from NVM file

Christoph B=C3=B6hmwalder (1):
      iwlwifi: fix minor code style issues

David Spinadel (1):
      iwlwifi: mvm: Add new quota command API

Emmanuel Grumbach (3):
      iwlwifi: mvm: remove support for Link Quality Measurements
      iwlwifi: mvm: support firmware debug trigger on frame reorder timeout
      iwlwifi: mvm: don't send identical PHY_CTXT_CMD

Ilan Peer (1):
      iwlwifi: Add few debug prints to the WRT dump flow

Johannes Berg (3):
      iwlwifi: fw: api: remove excess enum value documentation
      iwlwifi: fix indentation in a000 family configuration
      iwlwifi: mvm: warn on invalid statistics size

Liad Kaufman (1):
      iwlwifi: mvm: add dbgfs entry for fw info

Luca Coelho (11):
      iwlwifi: trans: move ref/unref code to the common part of the transpo=
rt
      iwlwifi: acpi: add common code to read from ACPI
      iwlwifi: acpi: move ACPI method definitions to acpi.h
      iwlwifi: acpi: move ACPI-related definitions to acpi.h
      iwlwifi: acpi: generalize iwl_mvm_sar_find_wifi_pkg()
      iwlwifi: acpi: use iwl_acpi_get_wifi_pkg when reading reading SPLC
      iwlwifi: acpi: make iwl_get_bios_mcc() use the common acpi functions
      iwlwifi: acpi: remove a couple of unnecessary ifdefs
      iwlwifi: acpi: move function to get mcc into acpi code
      iwlwifi: acpi: move code that reads SPLC to acpi
      iwlwifi: remove dflt_pwr_limit from the transport

Mordechay Goodstein (1):
      iwlwifi: mvm: add marker cmd response struct.

Oren Givon (2):
      iwlwifi: fix wrong struct for a000 device
      iwlwifi: add a new a000 device

Rajat Jain (1):
      iwlwifi: pcie: dump registers when HW becomes inaccessible

Sara Sharon (1):
      iwlwifi: mvm: change warning to warn_once()

Shahar S Matityahu (1):
      iwlwifi: pcie: dynamic Tx command queue size

 drivers/net/wireless/intel/iwlwifi/Makefile          |   1 +
 drivers/net/wireless/intel/iwlwifi/cfg/a000.c        | 103 +++++++++++++++=
+++++++++------------------------
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c         | 210 +++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
+++++++
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h         | 138 +++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/fw/api/binding.h  |  41 +++++++++++++++=
++--
 drivers/net/wireless/intel/iwlwifi/fw/api/commands.h |   1 +
 drivers/net/wireless/intel/iwlwifi/fw/api/debug.h    |   9 +++++
 drivers/net/wireless/intel/iwlwifi/fw/api/mac-cfg.h  |  67 ---------------=
----------------
 drivers/net/wireless/intel/iwlwifi/fw/api/power.h    |   3 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/sta.h      |   4 --
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c          |  15 +++++++
 drivers/net/wireless/intel/iwlwifi/fw/file.h         |   3 ++
 drivers/net/wireless/intel/iwlwifi/iwl-config.h      |   3 ++
 drivers/net/wireless/intel/iwlwifi/iwl-debug.h       |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c         |   7 ++--
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c   |  98 +--------------=
------------------------------
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h   |  17 --------
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c       |  16 ++++++++
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h       |  16 +-------
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c          |  16 +++++---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c |  76 ---------------=
--------------------
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c     |  32 +++++++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c          | 207 +++++++++++++++=
++++-----------------------------------------------------------------------=
-----
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c    |  52 ++++++++-------=
---------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h         |  62 +++++++++++++++=
+++-----------
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c         |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c         |  22 ++++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c    |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/quota.c       |  59 +++++++++++++++=
+-----------
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c          |   7 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c        |   8 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c         |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c       |  96 ++++++++++++---=
-----------------------------
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c  |   2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c        | 100 ++-------------=
-------------------------------
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h   |   4 ++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c      |  88 +++++++++++++++=
++++++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c    |   8 +++-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c         |  23 ++++++++++-
 39 files changed, 845 insertions(+), 775 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/acpi.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/acpi.h
--=-aC02EOIzYeeVhbzb/j01
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlnXcRkACgkQoUecoho8
xfrUmxAAp37lXijStijWgrRh6B8w791q0vPg3RTOLcso0dQNc5pgV7/52PE6yEe8
wB9vWthdUiJic4ffMi0vrVF0qSOLGe+u7bROQeNf0YrfFsYbGoXYfX2Qfq+WJp6z
Di4U0ysWia35vAHL3yYNqOyfAfJ4/s1tJ62GTlqYpwUucpSrLcF9IZ6ni/yIihQx
hHZH9On0HqEQVWCWnTWk/X44DfjaDzQvrkF2qhFnTbSpHXdgXTrduDMVj3p7E2Wu
4FvbKu/+FJa2ogniDbqTITIJDEIUZanrg79PTfuVtk2QHE09Q/DaZTGc7WjJOBjf
AhHwLSM1fr9FxwlxYErhJ/cr82VlzyPAaaHCoh/SYEDlk3z8FKoDORQL9GCWeQ7D
/ltZRcjZKcal7MkdVJPAlrXERnPIY6/9SWEP9I5hTfyBv2gXLrVA49gP/0D9Cemk
kJeEdUuW1ZrrF/lNT6Ko7KmZsfIcBueTFtlNNOLydcVLwJuLZJ1KTB7SAqbS1L1H
yyepNiNmoFCA4yld4Qu2gvtDooQ+2okIh8jeIVI82HvBLTYcaOJZt9IIm82Hfdgy
wgZzeoWjZohWFLDhOCdDkdVYZSSsNUuot2CtujHJTJjQfue/6+lYrzUecmk3gUj+
66ShFkrBVU+6IOuU5aFayruBqeQlD/s1hgnCjykBCa0JdtWJAlE=
=5dlV
-----END PGP SIGNATURE-----

--=-aC02EOIzYeeVhbzb/j01--
