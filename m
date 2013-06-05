Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39881 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab3FEHIk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 03:08:40 -0400
Message-ID: <1370416113.8920.10.camel@jlt4.sipsolutions.net> (sfid-20130605_090854_019617_B0743A4F)
Subject: pull-request: iwlwifi-next 2013-06-05
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 05 Jun 2013 09:08:33 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-5FhIal1SuDHsWG0KP3NC"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5FhIal1SuDHsWG0KP3NC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

And just like the fixes for old code never end, also the fixes for new
code :-) But I also have some new features. I also had to merge
wireless-next to get a cfg80211 change that the D3 test feature depends
on.

Here I mostly have various fixes for AP/GO mode, Bluetooth coexistence
and power save modes. The only new thing is the introduction of "D3
test" mode, accessible through debugfs for D3 firmware debugging.

Please pull.

Thanks,
johannes

The following changes since commit a910e4a94f6923c8c988565525f017f687bf7205=
:

  cw1200: add driver for the ST-E CW1100 & CW1200 WLAN chipsets (2013-05-29=
 15:26:40 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git fo=
r-john

for you to fetch changes up to fded313ec045024d4f769ce6b3e41fe343c167b0:

  iwlwifi: mvm: don't request SMPS on non-STA iface (2013-06-05 09:06:13 +0=
200)

----------------------------------------------------------------
Alexander Bondar (2):
      iwlwifi: mvm: Change location of vif_count verification for PM
      iwlwifi: mvm: enable PM always in unassociated mode

Emmanuel Grumbach (7):
      iwlwifi: mvm: fix the LUT for BT Coex
      iwlwifi: mvm: limit the length of the AMPDU when BT is running
      iwlwifi: mvm: don't start BA agreement when BT is active
      iwlwifi: mvm: don't enable MIMO when BT is active
      iwlwifi: mvm: reorder Rx handler for performance purposes
      iwlwifi: mvm: correctly configure MCAST in AP mode
      iwlwifi: mvm: fix MCAST in AP mode

Eran Harary (1):
      iwlwifi: don't return -ERFKILL if SEND_IF_RFKILL is set

Eytan Lifshitz (1):
      iwlwifi: mvm: don't request SMPS on non-STA iface

Ilan Peer (1):
      iwlwifi: mvm: Fix quota command settings

Johannes Berg (2):
      Merge remote-tracking branch 'wireless-next/master' into iwlwifi-next
      iwlwifi: mvm: implement D3 testing

 drivers/net/wireless/iwlwifi/dvm/mac80211.c   |   4 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h      |  14 +--
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c    |   2 +-
 drivers/net/wireless/iwlwifi/mvm/d3.c         | 149 ++++++++++++++++++++++=
++--
 drivers/net/wireless/iwlwifi/mvm/debugfs.c    |   1 +
 drivers/net/wireless/iwlwifi/mvm/fw-api-mac.h |   8 +-
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c   |   6 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c   |  35 ++----
 drivers/net/wireless/iwlwifi/mvm/mvm.h        |   4 +
 drivers/net/wireless/iwlwifi/mvm/ops.c        |   9 +-
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c   |   3 +-
 drivers/net/wireless/iwlwifi/mvm/power.c      |  13 +++
 drivers/net/wireless/iwlwifi/mvm/quota.c      |  25 +++--
 drivers/net/wireless/iwlwifi/mvm/rs.c         | 115 +++++++++++++++++++-
 drivers/net/wireless/iwlwifi/mvm/rs.h         |  12 +++
 drivers/net/wireless/iwlwifi/mvm/tt.c         |   3 +
 drivers/net/wireless/iwlwifi/mvm/tx.c         |   2 +-
 drivers/net/wireless/iwlwifi/mvm/utils.c      |  10 ++
 drivers/net/wireless/iwlwifi/pcie/trans.c     |  19 +++-
 drivers/net/wireless/iwlwifi/pcie/tx.c        |   3 +-
 20 files changed, 371 insertions(+), 66 deletions(-)


--=-5FhIal1SuDHsWG0KP3NC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRruPxAAoJEDBSmw7B7bqrrmYP/1yaXmT7hP21Be4IGytClTRT
tXLDq4jF1sHPeKZ1inOcJwnatjqY2XFYjB8Nmu0xaFc4NS8jGeJGJuQTAGrJHQMx
TDnUBRzdjQuNMNlW7NJqwL15RB5fWv+iLKzSm9r+muGzvzVuTGed9z/xeCem3/Eh
8QJCz6p45CElUArZtpcx33TIgDewZbQYOBacZAjUczC9XLRwRjGvXSgM5vcGm6J5
80dc8AuGnukcHayTUkrUfgjbJ6qayrLE8ITNhikP2/eBUdCDOAgDnGEN8CIF4wK5
rCabfgcQBPnlTZheNtOgrZ1ulZvzQfHjepIUelxxCG+3d32n+eX1VS+QMAnrw24o
cRpVGlqSJSjOWK5d2k9quAb2ZZ8h0ODQyp7cVsUQ/o99dY8DBWDlVNVIcRH4wdEp
GnqwvZz3dLgUHAt9X8frhZNpIChj8Q0neMDNJ0qwZfbLSswk311aZ9IhLHIKZLps
Sd6+bvnef9uVfuJHFkSuW2JftFosqY+jTBiSM0Hn4KGlyLbTm7VvAki+J8esc1Dy
1Ak6yJ70iS+xMv6LfklDuxnoVXAXAVtKybYI2gqhhPTC5XwHmzK9KpMYUuKLhi1j
Q2U/m5xC17DgElQeF8iHyMCi6fxcIj1lDiv38pUoJrEk+piuv2AxzOuPnVn+STUP
sAIF+txvK9YyiH6iZaNQ
=Jjff
-----END PGP SIGNATURE-----

--=-5FhIal1SuDHsWG0KP3NC--

