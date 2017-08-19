Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:44750 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750854AbdHSImI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 19 Aug 2017 04:42:08 -0400
Message-ID: <1503132116.15969.327.camel@coelho.fi> (sfid-20170819_104213_425550_0359E061)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, linuxwifi@intel.com
Date: Sat, 19 Aug 2017 11:41:56 +0300
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-+p3Ks+/ZlU8Z7QKl1bkZ"
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2017-08-18
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+p3Ks+/ZlU8Z7QKl1bkZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Here's my third pull-request intended for v4.14.=C2=A0 We continued doing
generic development work, with improvements, bug fixes and=C2=A0cleanups al=
l
around.=C2=A0 More=C2=A0details in the tag description.

My patch "iwlwifi: update channel flags parser" is going to cause a
conflict with net because they both change the same string in debug
message.  Emmanuel's patch "iwlwifi: split the regulatory rules when the
bandwidth flags require it" added "reg_flags" to the string and changed
the Ad-hoc string.  My patch added a few %s's and also changed the Ad-
hoc string.  The result of the conflict resolution should look like
this:

"Ch. %d [%sGHz] %s%s%s%s%s%s%s%s%s%s%s%s(0x%02x) reg_flags 0x%x: %s\n"


I have sent this out before, and kbuildbot reported success.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 38ef62353acbaa0eea062a9f047b33aebd7d52ce=
:

  rsi: security enhancements for AP mode (2017-08-17 10:07:00 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2017-08-18

for you to fetch changes up to 8fe34b060a4b11be35ffd9383acdd0bc7bee72e2:

  iwlwifi: use big-endian for the hw section of the nvm (2017-08-18 17:36:4=
2 +0300)

----------------------------------------------------------------
Third set of iwlwifi patches for 4.14

* Work for the upcoming A000 device family continues;
* Improvements in debugging;
* A couple of improvements in block-ack sessions;
* Some fixes for channel switch;
* A workaround for a HW data bug;
* Some FW API updates;
* General fixes and cleanups here and there.

----------------------------------------------------------------
Avraham Stern (1):
      iwlwifi: mvm: remove session protection to allow channel switch

Emmanuel Grumbach (7):
      iwlwifi: mvm: remove the corunning support
      iwlwifi: mvm: support new Coex firmware API
      iwlwifi: pcie: support short Tx queues for A000 device family
      iwlwifi: mvm: add command name for FRAME_RELEASE
      iwlwifi: mvm: include more debug data when we get an unexpected baid
      iwlwifi: mvm: update the firmware API in TX
      iwlwifi: mvm: don't send BAR on flushed frames

Gregory Greenman (1):
      iwlwifi: mvm: change open and close criteria of a BA session

Ilan Peer (1):
      iwlwifi: mvm: Fix channel switch in case of count <=3D 1

Jo=C3=A3o Paulo Rechi Vita (1):
      iwlwifi: Demote messages about fw flags size to info

Luca Coelho (12):
      iwlwifi: mvm: consider RFKILL during INIT as success
      iwlwifi: call iwl_remove_notification from iwl_wait_notification
      iwlwifi: mvm: group all dummy SAR function declarations together
      iwlwifi: mvm: use mvmsta consistently in rs.c
      iwlwifi: move BT_MBOX_PRINT macro to common header
      iwlwifi: pci: add new PCI ID for 7265D
      iwlwifi: update channel flags parser
      iwlwifi: add workaround to disable wide channels in 5GHz
      iwlwifi: fw: fix lar_enabled endian problem in iwl_fw_get_nvm
      iwlwifi: mvm: remove useless argument in iwl_nvm_init()
      iwlwifi: mvm: remove useless check for mvm->cfg in iwl_parse_nvm_sect=
ion()
      iwlwifi: use big-endian for the hw section of the nvm

Tzipi Peres (1):
      iwlwifi: distinguish different RF modules in A000 devices

 drivers/net/wireless/intel/iwlwifi/cfg/a000.c        |  34 ++++++++++-
 drivers/net/wireless/intel/iwlwifi/fw/api/coex.h     |  50 +++++++++++----=
-
 drivers/net/wireless/intel/iwlwifi/fw/api/commands.h |  12 ----
 drivers/net/wireless/intel/iwlwifi/fw/api/config.h   |   8 ---
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h       |   9 +--
 drivers/net/wireless/intel/iwlwifi/fw/file.h         |   3 +
 drivers/net/wireless/intel/iwlwifi/fw/notif-wait.c   |  25 ++++----
 drivers/net/wireless/intel/iwlwifi/fw/nvm.c          |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h      |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h         |   7 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c         |  12 ++--
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c   | 118 +++++++++++++++=
++++++++++++-----------
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h   |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c        | 301 +++++++++------=
---------------------------------------------------------------------------=
-------
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h   |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c     |  30 ++++------
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c          |  54 ++++++++++-----=
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c    |  16 ++++--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h         |  31 +++-------
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c         | 106 +++++++++++++++=
++-----------------
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c         |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c          | 143 +++++++++++++++=
++++++++++---------------------
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c        |   8 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h         |   7 +++
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c  |  34 ++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c          |   9 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c  |   2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c        |  24 ++++++--
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h   |  13 +++--
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c         |   2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c      |   4 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c    |  41 +++++++-------
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c         |  13 +++--
 33 files changed, 511 insertions(+), 624 deletions(-)
--=-+p3Ks+/ZlU8Z7QKl1bkZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlmX+dUACgkQoUecoho8
xfqtrQ//ZbHvHU0wOZmC6D+Fl6ZMGGN0gNxS9YulUWZXLCnhuBE+P+9dXpakoP1+
yVPi1e4w1MpUKajwufdBBSP1tCtLZb+VRMtpG7aEgfeK3w1zSJUtOuNcMU5UFJ83
2rHF79aFF2YZoIILwPDHa4UjGvQkSzZ6dfdWnrqb89LaLwG5nCUmWiX/wfH4O7/8
PF7PYDNGsZFGoyp9KLf+K3BKBu1tkEmWizKpvMbQldXfiq8wYfYZhaUnEY4lJrck
yF/gE30JEyroK4d/iaBkFwYuB5s5fJ4ceHd1Tj/iH2O/75m11SHyZIVZbs3RXlG6
LAJOdUcDtJV6CfxrbwlLBxHYOKF/3i4YWMTwh6a2CuNswfpSncdnwTRxj8kN/ZET
FujAQUuvez6ea6ooTaOcozlf6kdJTJ9y+FzV3An+ieUL5sh3LBb0vUb4Vb3S0UBU
6Fv30a09Ib9/Jg4TJtfd8RUmDez4Qn75sjkTk8aiFbIPDdQSYDbdZ7J0YRDDOcjg
HwFuYcSXl61Cevsq88yWmiOrsB8PLfWxtD7qYt++YxithmUl7wVndM4/AE3woFba
JUeYNrAEZh+355b5+MORWBNXELPPLRVTNwaN1wzeduviF5S3yZpJFN/xB/EuBeSD
p4B/8VnrbL3aurU25S2czHm0bOoIiW98b+RsH7LLOR7/S3gHW2U=
=oNlI
-----END PGP SIGNATURE-----

--=-+p3Ks+/ZlU8Z7QKl1bkZ--
