Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:49765 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbaGVTPm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 15:15:42 -0400
Received: by mail-wi0-f177.google.com with SMTP id ho1so978205wib.16
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2014 12:15:40 -0700 (PDT)
Message-ID: <53CEB854.9000008@gmail.com> (sfid-20140722_211545_973944_64BCEF49)
Date: Tue, 22 Jul 2014 22:15:32 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: pull request: iwlwifi-next 2014-07-22
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="R4aJcimbgeGIfRrgKsRAfUNqPfpH1LrPI"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--R4aJcimbgeGIfRrgKsRAfUNqPfpH1LrPI
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi John,

here is a pull request for 3.17.

I have the usual amount of BT Coex stuff. Arik continues to work on TDLS =
and Ariej contributes a few things for HS2.0. I added a few more things t=
o the firmware debugging infrastructure. Eran fixes a small bug - pretty =
normal content.

I merged iwlwifi-fixes to avoid a conflict. I also merged wireless-next b=
ecause I needed some bits from mac80211.
Let me know if this causes you any trouble!


The following changes since commit a006827a152c3f4d09324157096c8f89cf7ddc=
a3:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next=
 (2014-07-22 13:49:34 -0400)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git =
for-john

for you to fetch changes up to f697267f827516fba4d0c325ed1db1e72f402f11:
----------------------------------------------------------------
Ariej Marjieh (3):
      iwlwifi: mvm: Enabling Aux Queue
      iwlwifi: mvm: Define AUX ROC Command
      iwlwifi: mvm: add Aux ROC request/response flow

Arik Nemtsov (1):
      iwlwifi: mvm: teardown TDLS peers during chan-switch and AP DCM

Eliad Peller (3):
      iwlwifi: mvm: pass beacons from foreign APs
      iwlwifi: mvm: add some missing iwl_mvm_ref_sync() calls
      iwlwifi: mvm: wait for handlers when stopping scans

Emmanuel Grumbach (13):
      iwlwifi: mvm: fix merge damage
      iwlwifi: mvm: BT Coex - fix TLC with old API
      iwlwifi: fix Kconfig issues
      iwlwifi: mvm: use C99 initializers for add_sta
      iwlwifi: mvm: BT Coex - fix the ACK / CTS kill mask
      iwlwifi: mvm: BT Coex - don't change AP SMPS mode
      iwlwifi: fix inconsistency about power_save module parameter
      iwlwifi: split fw-error-dump between transport and mvm
      iwlwifi: dump periphery registers to fw-error-dump
      iwlwifi: dump CSRs to fw-error-dump
      iwlwifi: mvm: reset beacon filtering and BT Coex data upon FW resta=
rt
      Merge branch 'iwlwifi-fixes' into iwlwifi-next
      Merge remote-tracking branch 'wireless-next/master' into iwlwifi-ne=
xt

Eran Harary (2):
      iwlwifi: mvm: minor change in debug print
      iwlwifi: mvm: update smart fifo / beacon filtering upon association=


Eytan Lifshitz (1):
      iwlwifi: mvm: fix wrong offset while reading from NVM

Oren Givon (1):
      iwlwifi: add max RX aggregation size

 drivers/net/wireless/iwlwifi/Kconfig             |  25 +--
 drivers/net/wireless/iwlwifi/iwl-8000.c          |   4 +
 drivers/net/wireless/iwlwifi/iwl-config.h        |   2 +
 drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h |  17 +-
 drivers/net/wireless/iwlwifi/iwl-modparams.h     |   2 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h         |  21 +--
 drivers/net/wireless/iwlwifi/mvm/coex.c          | 193 ++++++++++-------=
-----
 drivers/net/wireless/iwlwifi/mvm/coex_legacy.c   | 119 +++-----------
 drivers/net/wireless/iwlwifi/mvm/debugfs.c       | 104 +++++++++---
 drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h   |   2 +
 drivers/net/wireless/iwlwifi/mvm/fw-api.h        |  67 ++++++++
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c      |  15 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c      | 383 +++++++++++++++++=
++++++++++++++++-----------
 drivers/net/wireless/iwlwifi/mvm/mvm.h           |  52 +++++-
 drivers/net/wireless/iwlwifi/mvm/nvm.c           |   4 +-
 drivers/net/wireless/iwlwifi/mvm/ops.c           |  14 +-
 drivers/net/wireless/iwlwifi/mvm/sta.c           |  24 +--
 drivers/net/wireless/iwlwifi/mvm/time-event.c    |  89 ++++++++--
 drivers/net/wireless/iwlwifi/mvm/tt.c            |  12 +-
 drivers/net/wireless/iwlwifi/mvm/tx.c            |  10 ++
 drivers/net/wireless/iwlwifi/pcie/trans.c        | 202 +++++++++++++++++=
+++++-
 21 files changed, 966 insertions(+), 395 deletions(-)


--R4aJcimbgeGIfRrgKsRAfUNqPfpH1LrPI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTzrhZAAoJEC0Llv5uNjIBJUAP/jjhU699kBGHpt0xp5P3OUdL
72V6biE224Cva79/FCdCdEZ6uYcVyH7Vz4BQZYEL31a+qReWWTC+8GDPKMgDlnde
HfgxGmgxdEwKLfQwEig6NPq6u8qfbOgb2Db20pniWIW6LkPANQUuZzJLIuvpVcSp
7I92nR+WEDpywMgDNi+tYS6M7M4clvURqjZIZbLSALMTEvvxT1T2cD+mfFwq+mre
3VE1SGJagQ4oY1CSn1Tavwp/ighibfqfbFSvcuHma285l7Zt+t1mlaahij/9q7cD
3tlzRo/O8IOYNu4+zXCI04MJ4HL8yRvyEajNdrXLNljPEZf+eQyLbVU3nYCV4VTS
q4+liltvlMkjHmhuq6baefKWWOiOdjGkuSfFcweq9VFVrfZf2OG2L3Q3hYxYueLR
0rWqSt2J+VxPmdyI5ud1hgo2CPHyKpWK2CelhDzTgFhW2LHenYo59FGJJ3+Z8dfX
kFHgIbl6sDv2napaQP3TsLOF20QCeqztFtSX4nlFH/N/Juk4GCXQtyonlIPgcIWd
HdT4+np1D3XHrTVQs62CPZTrISWhaw7WEciz8SomVX8GkDJwDzCNC+PZzPr36ab3
cBwghurKrW0IxjzWBh2COT4xpo4aZLKxUR3u6Fnh43gVNJJD5AtAohWGnl+QYi6Y
f8T8ix98/x8v5iGLZq4u
=pUMv
-----END PGP SIGNATURE-----

--R4aJcimbgeGIfRrgKsRAfUNqPfpH1LrPI--
