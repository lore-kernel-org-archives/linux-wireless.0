Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:62071 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350AbaICTyV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 15:54:21 -0400
Received: by mail-wi0-f179.google.com with SMTP id q5so10531846wiv.6
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 12:54:20 -0700 (PDT)
Message-ID: <540771E5.6080908@gmail.com> (sfid-20140903_215425_751322_81C55DA9)
Date: Wed, 03 Sep 2014 22:54:13 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: pull request: iwlwifi-next 2014-09-03
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="po4EOUQv6p49BHpFCgmRF1VUbalLg3ihr"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--po4EOUQv6p49BHpFCgmRF1VUbalLg3ihr
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi John,

This is a pull request for 3.18.

We have a new big thing coming up which is called Dynamic Queue Allocatio=
n (or DQA).
This is a completely new way to work with the Tx queues and it requires m=
ajor refactoring.
This is being done by Johannes and Avri.
Besides this, Johannes disables U-APSD by default because of APs that wou=
ld disable A-MPDU if the association supports U-ASPD.
Luca contributed to the power area which he was cleaning up on the way wh=
ile working on CSA.
A few more random things here and there.

Please pull. I have checked that it doesn't conflict with iwlwifi-fixes.g=
it, but let me know
if you have other issues.
Thanks!

The following changes since commit 433ab34d26e29d0f036c3f514a09ae96f973d8=
c5:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2014-08-=
22 14:33:18 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git =
for-john

for you to fetch changes up to 712b24adc105518f7cbbb6f9f353efea48954bb9:

  iwlwifi: mvm: clean up AUX station handling (2014-09-03 22:49:13 +0300)=


----------------------------------------------------------------
Avri Altman (2):
      iwlwifi: consolidate hw scheduler configuration code
      iwlwifi: trans: configure the scheduler enable register

David Spinadel (1):
      iwlwifi: mvm: enable passive fragmented scan changes

Eliad Peller (2):
      iwlwifi: mvm: add use_ps-poll debugfs power option
      iwlwifi: mvm: clear d0i3 state on recovery

Emmanuel Grumbach (3):
      iwlwifi: mvm: reduce the AMPDU size in low latency mode
      iwlwifi: mvm: use dynamic SMPS for P2P Client
      iwlwifi: mvm: force protection for P2P

Eran Harary (2):
      iwlwifi: mvm: fix the dump_umac_error_log
      iwlwifi: mvm: fix comment typo

Eyal Shapira (1):
      iwlwifi: mvm: disable tx aggregation on low latency vifs

Johannes Berg (14):
      iwlwifi: make U-APSD default configurable at compile time
      iwlwifi: trans: refactor txq_enable arguments
      iwlwifi: mvm: add some debugging to quota allocation
      iwlwifi: don't export tracepoints unnecessarily
      iwlwifi: trans: allow skipping scheduler hardware config
      iwlwifi: trans: make aggregation explicit for TX queue handling
      iwlwifi: add Intel Mobile Communications copyright
      iwlwifi: mvm: correct firmware disassoc command sequence
      iwlwifi: mvm: clean up FIFO definitions
      iwlwifi: mvm: clarify stop_count, remove transport_stopped
      iwlwifi: mvm: use tdls indication from mac80211
      iwlwifi: mvm: use iwl_mvm_mac_get_queues_mask() more
      iwlwifi: mvm: clean up broadcast station handling
      iwlwifi: mvm: clean up AUX station handling

Liad Kaufman (1):
      iwlwifi: mvm: wait for TE notif when protecting TDLS session

Luciano Coelho (8):
      iwlwifi: mvm: reset the temperature when temperature test is disabl=
ed
      iwlwifi: mvm: don't run automatic checks if CT was caused by debugf=
s
      iwlwifi: mvm: add debugfs entry for ps_disabled
      iwlwifi: mvm: re-enable ps when monitor interfaces are removed
      iwlwifi: mvm: refactor iwl_mvm_power_set_pm() to spin the ps part o=
ff
      iwlwifi: mvm: add function to update only ps
      iwlwifi: mvm: add option that allows a vif to disable PS
      iwlwifi: mvm: set the TX disable bit when doing a chanctx switch

Matti Gottlieb (2):
      iwlwifi: mvm: Add set NIC temperature debug option
      iwlwifi: mvm: Add marker command 0xcb

 drivers/net/wireless/iwlwifi/Kconfig             |  10 ++++++++++
 drivers/net/wireless/iwlwifi/dvm/tx.c            |   6 +++---
 drivers/net/wireless/iwlwifi/iwl-7000.c          |   2 ++
 drivers/net/wireless/iwlwifi/iwl-8000.c          |   2 ++
 drivers/net/wireless/iwlwifi/iwl-csr.h           |   2 ++
 drivers/net/wireless/iwlwifi/iwl-debug.h         |   2 ++
 drivers/net/wireless/iwlwifi/iwl-devtrace.c      |   7 -------
 drivers/net/wireless/iwlwifi/iwl-drv.c           |  10 +++++++++-
 drivers/net/wireless/iwlwifi/iwl-drv.h           |   2 ++
 drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h |   2 ++
 drivers/net/wireless/iwlwifi/iwl-fw-file.h       |   2 ++
 drivers/net/wireless/iwlwifi/iwl-fw.h            |   5 +++++
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c     |   2 ++
 drivers/net/wireless/iwlwifi/iwl-op-mode.h       |   2 ++
 drivers/net/wireless/iwlwifi/iwl-prph.h          |   3 +++
 drivers/net/wireless/iwlwifi/iwl-scd.h           | 118 +++++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
+++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-trans.h         |  67 +++++++++++++++++=
+++++++++++++++++++++++++++++++++-------------
 drivers/net/wireless/iwlwifi/mvm/coex.c          |   2 ++
 drivers/net/wireless/iwlwifi/mvm/coex_legacy.c   |   2 ++
 drivers/net/wireless/iwlwifi/mvm/constants.h     |   2 ++
 drivers/net/wireless/iwlwifi/mvm/d3.c            |   4 +++-
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c   |  10 ++++++++++
 drivers/net/wireless/iwlwifi/mvm/debugfs.c       |  76 +++++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/debugfs.h       |   2 ++
 drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h   |   2 ++
 drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h     |   2 ++
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h  |   2 ++
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h   |   2 ++
 drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h    |   2 ++
 drivers/net/wireless/iwlwifi/mvm/fw-api.h        |  48 +++++++++++++++++=
+++++++++++++++++++++++++----
 drivers/net/wireless/iwlwifi/mvm/fw.c            |   6 ++++--
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c      | 106 +++++++++++++++++=
++++++++++++++++++++++++++++++++++++-------------------------------------=
----------
 drivers/net/wireless/iwlwifi/mvm/mac80211.c      | 104 +++++++++++++++++=
++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------=
--------
 drivers/net/wireless/iwlwifi/mvm/mvm.h           |  41 +++++++++++++++++=
++++++++++------------
 drivers/net/wireless/iwlwifi/mvm/nvm.c           |   2 ++
 drivers/net/wireless/iwlwifi/mvm/offloading.c    |   2 ++
 drivers/net/wireless/iwlwifi/mvm/ops.c           |  16 ++++++++--------
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c      |   2 ++
 drivers/net/wireless/iwlwifi/mvm/power.c         | 148 +++++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
+++++++++++++++++---------------------------------
 drivers/net/wireless/iwlwifi/mvm/quota.c         |  14 ++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/rs.c            |  66 +++++++++++++++++=
++++++++++++++++++++++++++++-----------------
 drivers/net/wireless/iwlwifi/mvm/rx.c            |  21 +++++++++++++++++=
+++
 drivers/net/wireless/iwlwifi/mvm/scan.c          |  50 +++++++++++++++++=
+++++++++++++++++++++---------
 drivers/net/wireless/iwlwifi/mvm/sf.c            |   2 ++
 drivers/net/wireless/iwlwifi/mvm/sta.c           |  94 +++++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++---------------------------
 drivers/net/wireless/iwlwifi/mvm/sta.h           |  22 ++++++++++-------=
----
 drivers/net/wireless/iwlwifi/mvm/testmode.h      |   2 ++
 drivers/net/wireless/iwlwifi/mvm/time-event.c    |  61 +++++++++++++++++=
+++++++++++++++++++++++++++++++++++++++--
 drivers/net/wireless/iwlwifi/mvm/time-event.h    |   8 ++++++--
 drivers/net/wireless/iwlwifi/mvm/tt.c            |  24 +++++++++++++++++=
++++--
 drivers/net/wireless/iwlwifi/mvm/tx.c            |   4 +++-
 drivers/net/wireless/iwlwifi/mvm/utils.c         |  23 ++++++++++++++++-=
-----
 drivers/net/wireless/iwlwifi/pcie/drv.c          |   2 ++
 drivers/net/wireless/iwlwifi/pcie/internal.h     |   8 +++++---
 drivers/net/wireless/iwlwifi/pcie/rx.c           |   1 +
 drivers/net/wireless/iwlwifi/pcie/trans.c        |   2 ++
 drivers/net/wireless/iwlwifi/pcie/tx.c           | 137 +++++++++++++++++=
++++++++++++++++++++++++++++++++++++++++++++++++-------------------------=
---------------------------------------
 57 files changed, 1053 insertions(+), 315 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-scd.h


--po4EOUQv6p49BHpFCgmRF1VUbalLg3ihr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUB3HqAAoJEC0Llv5uNjIBwucP/A7H73TxlbLyA+FPbDctMjlW
r6XmyaNipx03AgWGTiCx/iq6Q4tQ8ya4QMMWTN3VPqCmcapo1sQMdKZcLs0TwCue
wVm+eGNz/Xziz+SQSJz0q3rLsauCrOQU2cAmsDfkd7pM2NnjA9uTjqxO3Tz8uxvz
L8+syWpaFGdNgLF+2/pDWx0n5PemEBsVuqE6z7BhCYJlD/UFbJDDbFBfk2qoHG4C
UQB85xzG2B/GboHBVQJzFCEnLrv2X7QWxQ8KNGSJTY/P8KXkDOyD77G00LGqcKo5
S4DssmlV3bLAIDCyw0WlxHBnw9FWt0d8+GHjRrAyQJht21YyBa+xNcYg65xHfVWF
LcInHRki8YwlPpqGvdbkaKXxlduWtY/tdXMxCwJ2u7Z+6gcTYNY8WOpbtzhEywTO
+XSaFRECirf7V3wRRCWCZiBeRP660Aig6g+zQMfnsEcX1fYWI0tcdQKNmPUAZaiX
hBpEIb1Czjc2mTcKqll3N5NGNXXSYQnV8P4GyoEn3Ju4mewpgj7EyPk9x4oj2Ypt
eZcs9ZmOGQq8gEZwvx61+P9u6hr2GYhNnmuVnONi92tVhtJUFgCWxP5LkQkezsAP
bHoIeeB8XyHnXGkDD4XG6g6I5DEqH8Bz/MtxXEyG7lW6H6EgeUgoYV559/m24dLt
h4JUaFaJAozMLvwhmK4l
=n6Hi
-----END PGP SIGNATURE-----

--po4EOUQv6p49BHpFCgmRF1VUbalLg3ihr--
