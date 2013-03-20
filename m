Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42723 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab3CTNzX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 09:55:23 -0400
Message-ID: <1363787717.8224.7.camel@jlt4.sipsolutions.net> (sfid-20130320_145527_983730_3688EA2A)
Subject: pull-request: iwlwifi-next 2013-03-20
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 20 Mar 2013 14:55:17 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-wBlAq/v5Ek98pH8AXF1b"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wBlAq/v5Ek98pH8AXF1b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

I also have a bunch of new things for iwlwifi:

Andrei changed an instance of kmalloc+memdup to kmemdup, Stanislaw
removed the now unused 5ghz_disable module parameter. I also have a
number of fixes from Ilan, Emmanuel and myself, Emmanuel also continued
working on Bluetooth coexistence.

I had to merge wireless-next to get one of Ilan's patches in properly as
it depended on a mac80211 patch.

Please pull.

johannes



The following changes since commit 856a850afdd778fad7ded4240d333a8c3b05b136=
:

  rt2800: 5592: add more USB devices IDs (2013-03-18 16:38:35 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git fo=
r-john

for you to fetch changes up to e635c797b3b18ffbe4ef5db27971f48b661f03bd:

  iwlwifi: mvm: Add support for different ROC types (2013-03-20 14:31:04 +0=
100)

----------------------------------------------------------------
Andrei Epure (1):
      iwlwifi: use kmemdup instead of kmalloc+memcpy

Emmanuel Grumbach (8):
      iwlwifi: mvm: MVM op_mode is supported on 7000 only
      iwlwifi: mvm: fix the {ack,cts}_kill_msk
      iwlwifi: mvm: don't support multi-channel inhibition
      iwlwifi: mvm: print the flags in ALIVE notification
      iwlwifi: add debug message when a CMD is dropped in RFKILL
      iwlwifi: mvm: take the radio type / step / dash from TLVs
      iwlwifi: mvm: take the valid_{rx,tx}_ant from the TLV
      iwlwifi: mvm: tune the move to static SMPS due to BT load

Ilan Peer (5):
      iwlwifi: mvm: Add beacon notification handler
      iwlwifi: mvm: Remove obsolete queue definitions
      iwlwifi: mvm: Fix quota handling for monitor interface
      iwlwifi: mvm: Increase the max remain on channel time
      iwlwifi: mvm: Add support for different ROC types

Johannes Berg (4):
      iwlwifi: mvm: suppress key error messages in AP mode
      iwlwifi: mvm: specify filter flags in monitor mode
      iwlwifi: mvm: fix WoWLAN RF-kill bug
      Merge remote-tracking branch 'wireless-next/master' into iwlwifi-next

Stanislaw Gruszka (1):
      iwlwifi: remove 5ghz_disable option

 drivers/net/wireless/iwlwifi/iwl-drv.c        |   4 -
 drivers/net/wireless/iwlwifi/iwl-fw.h         |  25 +++++
 drivers/net/wireless/iwlwifi/iwl-modparams.h  |   2 -
 drivers/net/wireless/iwlwifi/iwl-test.c       |   3 +-
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c    |  21 ++--
 drivers/net/wireless/iwlwifi/mvm/d3.c         |  10 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h  |   6 ++
 drivers/net/wireless/iwlwifi/mvm/fw-api.h     |  38 +------
 drivers/net/wireless/iwlwifi/mvm/fw.c         |  23 +++--
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c   |  30 +++++-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c   |  29 ++++--
 drivers/net/wireless/iwlwifi/mvm/mvm.h        |  15 ++-
 drivers/net/wireless/iwlwifi/mvm/nvm.c        | 136 ++++++----------------=
----
 drivers/net/wireless/iwlwifi/mvm/ops.c        |  36 ++-----
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c   |   7 +-
 drivers/net/wireless/iwlwifi/mvm/quota.c      |   3 +-
 drivers/net/wireless/iwlwifi/mvm/scan.c       |   4 +-
 drivers/net/wireless/iwlwifi/mvm/time-event.c |  38 ++++---
 drivers/net/wireless/iwlwifi/mvm/time-event.h |   3 +-
 drivers/net/wireless/iwlwifi/mvm/tx.c         |  10 +-
 drivers/net/wireless/iwlwifi/pcie/tx.c        |   5 +-
 21 files changed, 195 insertions(+), 253 deletions(-)


--=-wBlAq/v5Ek98pH8AXF1b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRSb/FAAoJEDBSmw7B7bqr2U8P/1Vzqm70qEBHAYVaEN2/EsrI
PadfMbhkd5kz1aLGNHR9GO5mEWw0jMBe6KuyrH1QM4INwb1LdQNYqta3fauHDsjG
PFf52Sff3IkSCTcUIpcuakhTdXXwNEgIsaUYogRJLXYuUTDqnY2ZMBSMyzkBvBAf
KpDXiNxoSPvasLc75iqkq+Ur5bAeuZ+K2VPkoGnzET89flQEfbrOriIwFQlZe6+8
5wR+si6QJLWs42vVhtcWEYkBhs9PfeIfU3tbiI5zWikjr7Nm4iIJDAR+nLJdOprB
5R/weRufYVzO+07H1TB26yTZksrqnsvsm3GyRlClTNcHQW6WGm01o6UCJ5uIDeCC
yRJ3NuqvZecNelxUm2rS7UarS56ZO9RwyJ7znHXq1yx8Rs08g/270BMm2k0V8mLg
TRwfLnbtKquFyGtVvfBDBmV1ZAxcRWyi9HMhdOymA010xn+LQdnZXhTgt/zxfqQa
SAwtdeMKlYC0A/4f8cbNV+xIPef6Wcwe8eAUFn4mTZPelyQpkv+F31YmYJcRvCjs
hbpeddtRZJKrc1jneU9RaU+eiw9/GH+cyIAkR9Gcg8uJ8EF6Jy18ntSjavTIIB5K
D+BPOBG/X7xpngh9Vovk0U7d+CUhslsY1wzjCoPqTXuOqXNVWnYOyLYl5PnUeusi
GeHBMXXKGJsPvRe4oCUz
=WKi1
-----END PGP SIGNATURE-----

--=-wBlAq/v5Ek98pH8AXF1b--

