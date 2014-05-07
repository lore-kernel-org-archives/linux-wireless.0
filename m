Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:40897 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbaEGTwM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 15:52:12 -0400
Received: by mail-wi0-f171.google.com with SMTP id hm4so9733401wib.10
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 12:52:11 -0700 (PDT)
Message-ID: <536A8EE3.2050906@gmail.com> (sfid-20140507_215226_981795_799D9F7C)
Date: Wed, 07 May 2014 22:52:03 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	ilw@linux.intel.com
Subject: pull request: iwlwifi-next 2014-05-07
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="DKIMblhHK1f6a3L6FDpuX36a9P6KaIkRi"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DKIMblhHK1f6a3L6FDpuX36a9P6KaIkRi
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi John,

I have here another pull request for 3.16.
I merged wireless-next.git because of dependencies on changes in mac80211=
=2E I merged iwlwifi-fixes.git (that feeds wireless.git) because of depen=
dencies in the rate scaling changes that were sent to wireless.git.

Eran continues to work on new devices, Eyal is still digging in the rate =
control stuff, and Johannes added new functionality to the debug system w=
e have in place now along with a few cleanups he made on the way.
That's pretty much it.

Please pull.=20

The following changes since commit 48d11dc37977614a461bfedddc52d1c651bc27=
9f:

  rsi: Changing opcode for sta mode according to changes in firmware (201=
4-04-30 12:13:16 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git =
for-john

for you to fetch changes up to 017a64161f6d082f6e3ed85646217bd7217af15a:

  iwlwifi: mvm: rs: enable MCS9 for Tx (2014-05-07 22:44:43 +0300)

----------------------------------------------------------------
Alexander Bondar (1):
      iwlwifi: mvm: several fixes in scan

Andrei Otcheretianski (1):
      iwlwifi:mvm: Add AP/GO channel switch support

Eliad Peller (1):
      iwlwifi: mvm: wait for d0i3 exit in some more ampdu actions

Emmanuel Grumbach (6):
      iwlwifi: mvm: BT Coex - fix validity flags during init
      iwlwifi: mvm: rs - s/CPTCFG/CONFIG
      Merge remote-tracking branch 'iwlwifi-fixes/master' into iwlwifi-ne=
xt
      Merge remote-tracking branch 'wireless-next/master' into iwlwifi-ne=
xt
      iwlwifi: mvm: implement mac80211's flush callback
      iwlwifi: mvm: fix sparse warning when _DEBUGFS isn't set

Eran Harary (5):
      iwlwifi: mvm: fix bug with OTP memory size
      iwlwifi: mvm: prevent nic to powered up at driver load
      iwlwifi: mvm: Prioritize external nvm values on top of the OTP valu=
es
      iwlwifi: mvm: select the MAC address according to priority
      iwlwifi: mvm: fix bug in parse_nvm_sections

Eyal Shapira (6):
      iwlwifi: mvm: rs: revert changes to search cycle rules
      iwlwifi: mvm: rs: overhaul rs_get_best_rate
      iwlwifi: mvm: rs: don't allow TPC when power save is disabled
      iwlwifi: mvm: rs: avoid TPC while in search cycle
      iwlwifi: mvm: rs: choose correct expected tpt table
      iwlwifi: mvm: rs: enable MCS9 for Tx

Johannes Berg (5):
      iwlwifi: mvm: remove useless variable
      iwlwifi: make LED support optional
      iwlwifi: pcie: use bool for iwl_pcie_txq_build_tfd() argument
      iwlwifi: pcie: get rid of q->n_bd
      iwlwifi: mvm/pcie: capture last commands on firmware error

 drivers/net/wireless/iwlwifi/Kconfig                                    =
  |  12 ++++++---
 drivers/net/wireless/iwlwifi/dvm/Makefile                               =
  |   3 ++-
 drivers/net/wireless/iwlwifi/dvm/dev.h                                  =
  |   2 ++
 drivers/net/wireless/iwlwifi/dvm/led.h                                  =
  |  12 +++++++++
 drivers/net/wireless/iwlwifi/iwl-7000.c                                 =
  |   2 +-
 drivers/net/wireless/iwlwifi/iwl-8000.c                                 =
  |   2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-hw.h                               =
  |   4 +--
 drivers/net/wireless/iwlwifi/iwl-config.h                               =
  |   6 +++++
 drivers/net/wireless/iwlwifi/{mvm/fw-error-dump.h =3D> iwl-fw-error-dump=
=2Eh} |  26 +++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-fw.h                                   =
  |   2 ++
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c                            =
  |  46 +++++++++++++++++++++++++++------
 drivers/net/wireless/iwlwifi/iwl-trans.h                                =
  |  19 ++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/Makefile                               =
  |   3 ++-
 drivers/net/wireless/iwlwifi/mvm/coex.c                                 =
  |   6 ++---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c                              =
  |   2 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h                          =
  |   8 +++---
 drivers/net/wireless/iwlwifi/mvm/fw.c                                   =
  |   2 +-
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c                             =
  |  12 +++++++++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c                             =
  |  91 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---=

 drivers/net/wireless/iwlwifi/mvm/mvm.h                                  =
  |  16 +++++++++++-
 drivers/net/wireless/iwlwifi/mvm/nvm.c                                  =
  |  30 ++++++++++++++--------
 drivers/net/wireless/iwlwifi/mvm/ops.c                                  =
  |  36 ++++++++++++++++++++------
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c                             =
  |   9 +++----
 drivers/net/wireless/iwlwifi/mvm/rs.c                                   =
  | 173 +++++++++++++++++++++++++++++++++++++++++------------------------=
----------------------------------------------------------
 drivers/net/wireless/iwlwifi/mvm/scan.c                                 =
  |  53 +++++++++-----------------------------
 drivers/net/wireless/iwlwifi/mvm/utils.c                                =
  |   2 ++
 drivers/net/wireless/iwlwifi/pcie/internal.h                            =
  |  24 +++++++++--------
 drivers/net/wireless/iwlwifi/pcie/rx.c                                  =
  |   2 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c                               =
  |  64 ++++++++++++++++++++++++++++++++++++++++++++--
 drivers/net/wireless/iwlwifi/pcie/tx.c                                  =
  | 129 ++++++++++++++++++++++++++++++++++++++++++++++-------------------=
--------------------------
 30 files changed, 507 insertions(+), 291 deletions(-)
 rename drivers/net/wireless/iwlwifi/{mvm/fw-error-dump.h =3D> iwl-fw-err=
or-dump.h} (84%)


--DKIMblhHK1f6a3L6FDpuX36a9P6KaIkRi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTao7nAAoJEC0Llv5uNjIBmUIQAI3FAO/oSvKhvQ55WD2h3XhK
BdNZydj8cFjEdzZJ7rtlXMM3h1WzAAk0KZczgKjak4sQBzjYeRkUEaUo4jZlHPho
jxV4GTCmX4fNTknalJxhtuuGh2UrYz5Y9uK4Wmn31WdSx7ZdvHfDSvEGO1CowohR
LX+uOAdET+nS7Sl3eYEOeeiSs0/k0jKxRmi6Wd+gShqM51pCLYSx5SF1BSsC7DgZ
zDwN2Y+VjbLK46M4ux/44fGt+uEIXhMrvLGTufwAZ4qEYJWzBVZWczhiBed5p+XV
6vlhcLdsdno9farQO5hm+mRavSlFKPEBkuZyN/d9TN1RRB/C3TOeoftr5uL+NmDy
LdKqAuKFLEUv+UpiI+R04grf6f5u7QK0RGUzeCcAdILAmD3F1JiPvri+F8TZ639S
pkJehd9wnOwTQRBjv1UL90vdDAoDUI/aQOM31s2Z+X+vteNxjPuAm29FSn7y8QgJ
uHfQa+Edqzq2gwZGStDY8DGI8lEAtezpYfvr3CD7nHamhTzRJZgsaJGwUNN/2mtb
nm0zuj0z8JaDpRMf7CQZu2YDTDYWy3zIJXbK3bkFuVeW34x5qexWcwIMP/Tbe4eR
p3rpPjFmNq37xn+buOdY2gNvW9EtrZL1siNL/fHcA+GHkqDzlc9ZyyHTqvCzrsse
A/lA32jAB3sCqrzKcbS4
=Lyj/
-----END PGP SIGNATURE-----

--DKIMblhHK1f6a3L6FDpuX36a9P6KaIkRi--
