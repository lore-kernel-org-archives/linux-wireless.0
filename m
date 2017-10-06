Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51882 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751841AbdJFMc6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Oct 2017 08:32:58 -0400
Message-ID: <1507293175.908.134.camel@coelho.fi> (sfid-20171006_143306_546975_4F9EBAEC)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, linuxwifi@intel.com
Date: Fri, 06 Oct 2017 15:32:55 +0300
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-3ug0WUU60w1/gtro5jjZ"
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2017-10-06-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3ug0WUU60w1/gtro5jjZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Here's the second version of my first pull-request intended for
v4.15.  It contains the last two patch sets I sent out with v2 of the
pci dump patch.

In v2 we have fixed a potential kernel oops when our driver is used
with qemu, for instance.  In that case, the root port is NULL and we
were trying to access it without checing.

I have sent this out before and kbuildbot reported success.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit a7c9acc452b21b56c99dd7dfe0ab542f7baa6563=
:

  brcmfmac: Delete redundant length check (2017-10-02 17:07:00 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2017-10-06-2

for you to fetch changes up to f2abcfa6c86e503b352846ace9d6ab9b02ade0ab:

  iwlwifi: remove dflt_pwr_limit from the transport (2017-10-06 15:22:34 +0=
300)

----------------------------------------------------------------
First batch of iwlwifi patches for 4.15 (v2)

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
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c      |  89 +++++++++++++++=
++++++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c    |   8 +++-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c         |  23 ++++++++++-
 39 files changed, 846 insertions(+), 775 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/acpi.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/acpi.h
--=-3ug0WUU60w1/gtro5jjZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlnXd/gACgkQoUecoho8
xfphRg/9F7YKUldcaP9pYde7UrY5LWFirEjZF0YRUbdlt7KCrXk/VnojMrwevEI6
LllUctZT1MCaYWc3/VmfKZYRhAdgtYN7VVRDXa1RT+pe97r8kX8pBRp8vBEdRIsH
lXrxI+N5ri/AJ/zWgJ5D7TkfWxJbDpLnWlb/Z6aHU5SQ9mlMl5n6r/DGMwn171Sp
4USSFAQnagjHaZ+v/zqRS6p4lpESJGRBIuPOn7GeII+H7zZGau9QdiP0+6VKsbNr
95hM6Ew5JrNJb3xP2dxJb5Av1EY96yuFDCIkELjMj6GEHMhdj4Fu+9ZtcMMTEpMK
Ro8MHgIIRvwXERQLlcaQ3nuGFMhQVpDVT/wsAOZYD7OzwNLrN4mgJqoU6JGZxJ8I
XI6iSli2bBVaRWjqrSMjdnHpLqVsy2jnbMlosvU61xNVKBaF6C1SzemBX0WlO1RR
+DaHU0vnSox4Pl099rMVGCAkbFC6x2kGN1Lqpz/F4nzFgebDWpDs9f9g2DTPlM8J
63jKav4s6iLNTOi91mm+XoYS9ieUuCDrAwID/LX361R20D9I9kmpn76fwuuPeUQ/
SbYuw9lUjwVox9ldtJsgYIveHZhZM/AZZJK9Dt+vhq+a8CdcEkDcPMs8ZEY+SLKz
wDEQxfJFD6ZCoN84Zr5o34QtvwN/WIHBbbVCQvLopYxwpk4Xf50=
=Fqln
-----END PGP SIGNATURE-----

--=-3ug0WUU60w1/gtro5jjZ--
