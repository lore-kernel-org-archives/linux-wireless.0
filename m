Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:65463 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab3KXUFD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 15:05:03 -0500
Received: by mail-bk0-f44.google.com with SMTP id d7so1581251bkh.31
        for <linux-wireless@vger.kernel.org>; Sun, 24 Nov 2013 12:05:01 -0800 (PST)
Message-ID: <52925BE7.4050406@gmail.com> (sfid-20131124_210538_676609_E6704B84)
Date: Sun, 24 Nov 2013 22:04:55 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Intel Linux Wireless <ilw@linux.intel.com>
Subject: pull request: iwlwifi-next 2013_11_24
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="LU0sSBdKPOUGulq2S6WhOA2uanaUjeOWX"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LU0sSBdKPOUGulq2S6WhOA2uanaUjeOWX
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi John,

This is the first batch for 3.14.

I have a bunch of small improvements and fixes. Avri made a thorough
work checking what bit to set to firmware w.r.t protection. Eliad worked
on WoWLAN, so did Luca. Johannes contributes a whole bunch of clean ups,
and Alex tries to handle better cases where the firmware dies. Eyal
survived his deep dive into the rate control algorigthm and provides a
new set of fixes for VHT. I am still playing a bit with BT Coex.

Note that I had to merge iwlwifi-fixes to avoid conflicts before they
hit linux-next.
Let me know about any issues!

The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42=
ae:

  Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git
for-john

for you to fetch changes up to b407dd53844e0d66e726583bae3a084cecdd59a4:

  Merge remote-tracking branch 'iwlwifi-fixes/master' into iwlwifi-next
(2013-11-24 21:49:45 +0200)

----------------------------------------------------------------

Alexander Bondar (2):
      iwlwifi: mvm: Add debugfs entry to generate NMI to NIC
      iwlwifi: pcie: stop sending commands to dead firmware

Avri Altman (1):
      iwlwifi: mvm: fix ht protection flags

Eliad Peller (4):
      iwlwifi: mvm: enable d3_test even if d3_test_pme_ptr is not availab=
le
      iwlwifi: mvm: disconnect on disconnection wakeup event
      iwlwifi: mvm: allow keeping connections in d3_test
      iwlwifi: mvm: fix scan offloading flag definition

Emmanuel Grumbach (10):
      iwlwifi: pcie: fix interrupt coalescing for 7260 / 3160
      iwlwifi: mvm: BT Coex - don't enable MULTI_PRIO_LUT
      iwlwifi: mvm: BT Coex fix another NULL pointer dereference
      iwlwifi: mvm: don't WARN about unsuccessful time event
      iwlwifi: bump required firmware API version for 3160/7260
      iwlwifi: remove TX_CMD id from transport layer
      iwlwifi: mvm: BT Coex - fine tune the aggregation size
      iwlwifi: mvm: a few more SKUs for 7260 and 3160
      iwlwifi: mvm: dump NVM from debugfs
      Merge remote-tracking branch 'iwlwifi-fixes/master' into iwlwifi-ne=
xt

Eyal Shapira (9):
      iwlwifi: mvm: fix and improve printing of rate scale table
      iwlwifi: mvm: simplify iwl_mvm_send_lq_cmd
      iwlwifi: mvm: refactor iwl_mvm_rs_rate_init
      iwlwifi: mvm: implement rate_update hook in rs
      iwlwifi: mvm: add LQ flags definitions
      iwlwifi: fix check for a single rx antenna
      iwlwifi: mvm: stop using MIMO in case BT doesn't allow it
      iwlwifi: mvm: don't enable VHT MCS9 in 20Mhz
      iwlwifi: mvm: don't configure mimo rates if nss is limited to 1

Haim Dreyfuss (1):
      iwlwifi: mvm: Implement low-priority scan

Johannes Berg (8):
      iwlwifi: mvm: check sta_id/drain values in debugfs
      iwlwifi: pcie: remove useless condition test
      iwlwifi: mvm: small debugfs cleanups
      iwlwifi: mvm: move interface-specific debugfs to a new file
      iwlwifi: mvm: don't use void pointers in debugfs
      iwlwifi: mvm: refactor debugfs copy_from_user()
      iwlwifi: mvm: add iwl_mvm_sta_from_mac80211
      iwlwifi: mvm: quota command max_duration should be zero

Luciano Coelho (3):
      iwlwifi: mvm: set seqno also when no keys are set
      iwlwifi: mvm: use a cast to calculate the last seqno from the next =
one
      iwlwifi: mvm: don't restart HW if suspending fails before D3 image
is loaded

Michal Nazarewicz (1):
      iwlwifi: pcie: remove minor dead code

Oren Givon (1):
      iwlwifi: add new HW - 7265 series

 drivers/net/wireless/iwlwifi/dvm/rs.h          |    7 -
 drivers/net/wireless/iwlwifi/dvm/tx.c          |    1 +
 drivers/net/wireless/iwlwifi/iwl-7000.c        |   29 +-
 drivers/net/wireless/iwlwifi/iwl-config.h      |   11 +
 drivers/net/wireless/iwlwifi/iwl-csr.h         |    5 +-
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c   |    3 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h        |    3 +
 drivers/net/wireless/iwlwifi/mvm/Makefile      |    1 +
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c     |   16 +-
 drivers/net/wireless/iwlwifi/mvm/d3.c          |   43 +-
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c |  190 +++++++
 drivers/net/wireless/iwlwifi/mvm/debugfs.c     |  640
++----------------------
 drivers/net/wireless/iwlwifi/mvm/debugfs.h     |  101 ++++
 drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h   |   27 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h |    5 +-
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c    |   51 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c    |   19 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h         |   11 +-
 drivers/net/wireless/iwlwifi/mvm/nvm.c         |   23 +
 drivers/net/wireless/iwlwifi/mvm/quota.c       |    3 +-
 drivers/net/wireless/iwlwifi/mvm/rs.c          |  223 ++++++---
 drivers/net/wireless/iwlwifi/mvm/rs.h          |   23 +-
 drivers/net/wireless/iwlwifi/mvm/scan.c        |   55 +-
 drivers/net/wireless/iwlwifi/mvm/sta.c         |   14 +-
 drivers/net/wireless/iwlwifi/mvm/sta.h         |    6 +
 drivers/net/wireless/iwlwifi/mvm/time-event.c  |    7 +-
 drivers/net/wireless/iwlwifi/mvm/tt.c          |    2 +-
 drivers/net/wireless/iwlwifi/mvm/tx.c          |   11 +-
 drivers/net/wireless/iwlwifi/mvm/utils.c       |    8 +-
 drivers/net/wireless/iwlwifi/pcie/drv.c        |   26 +
 drivers/net/wireless/iwlwifi/pcie/internal.h   |    8 +
 drivers/net/wireless/iwlwifi/pcie/rx.c         |   33 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c      |    3 -
 drivers/net/wireless/iwlwifi/pcie/tx.c         |   37 +-
 34 files changed, 832 insertions(+), 813 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/debugfs.h


--LU0sSBdKPOUGulq2S6WhOA2uanaUjeOWX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJSklvrAAoJEC0Llv5uNjIBkaYP/RxoxrNZP8SAPQSHFOLfALe2
doW0Szc5Mq1MGyYGM7oKzEFcTXfv/sJodLqMz7w7leuhKO7fLK+UyUcmJgVvFaRF
olzGIMc4Bm1LCB2Qota3+H9Ii068J3YXJX3vpd42GFpTWM+1DMmAyWBO+H+KuVm3
gYsEgAD5SQYNdV+NaqK9R5tvbRpnERTrXsVj/7pahjMPCxDeI01nFIL0kZKcoqDi
L5ZdaV2EbCiqKRXJuvvZ+X1VZ49RVTiIVTZWsFkAhLmEa3AL3P3C5sJg5PZx/MvQ
GrZn4lUdB17y8J788rytXg5LArbSQUUpK0qvRDjhCndzBqJEV0QhutSrrXmot1AF
YEcdx6qEVxZXoF7KU3BYC8PoK4k1Hm7ueDSWWim8rcWUzQ7ss1bD1VfdD5F9/+si
oPRLE87eynI+4KKKDpkaysPLk8P0xsN/0QnTQYpILSVRowMGfN5Ym/JwoOoVYYcr
sOxm/vXmSlhNmatk74ZneXCJawx6go15tIWcFm49+un6KBADOfqBLr/XzzhKdJfK
11y94UNPEYab2peKp+MniEWia4VWigL2XZZ7ssBiW1p7BoBjM2IC7hjEosqc1eE2
qXrB6V0ngfSLfw9tQz4DPQxn8+PFNJjY1IidBQRX3M4wq6aq4oEOalT7vR910d0K
dYz8TdXN9WId2qW48+kR
=aPd7
-----END PGP SIGNATURE-----

--LU0sSBdKPOUGulq2S6WhOA2uanaUjeOWX--
