Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47812 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab3BZV1c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2013 16:27:32 -0500
Message-ID: <1361914034.8440.27.camel@jlt4.sipsolutions.net> (sfid-20130226_222736_869147_FAE81193)
Subject: pull-request: iwlwifi-fixes 2013-02-26
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 26 Feb 2013 22:27:14 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-kngSTsZeQ+WNNAepOGeb"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kngSTsZeQ+WNNAepOGeb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Also the first set of fixes for iwlwifi.

I have a fix for a pretty important bug regarding DMA mapping, that
could cause the DMA engine to overwrite data we wanted to send to it, so
that the next time we send it it would be bad. This particularly affects
calibration results. Other than that, three little fixes for the MVM
driver.

Please pull.

Thanks,
johannes


The following changes since commit dc4a787c8f52f9d6e46156953f8014a3353bcbc7=
:

  brcmfmac: fix missing unlock on error in brcmf_notify_vif_event() (2013-0=
2-22 14:50:47 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git f=
or-john

for you to fetch changes up to fc2999ef2a0b652a672a9ff0c2099c6830b934f2:

  iwlwifi: mvm: Remove testing of static PIC in PhyDB (2013-02-26 22:21:26 =
+0100)

----------------------------------------------------------------
Dor Shaish (1):
      iwlwifi: mvm: Remove testing of static PIC in PhyDB

Johannes Berg (3):
      iwlwifi: always copy first 16 bytes of commands
      iwlwifi: mvm: fix AP/GO mode station removal
      iwlwifi: fix wakeup status query and packet reporting

 drivers/net/wireless/iwlwifi/iwl-devtrace.h  |  10 ++-
 drivers/net/wireless/iwlwifi/iwl-phy-db.c    |  16 -----
 drivers/net/wireless/iwlwifi/mvm/d3.c        | 103 ++++++++++++++++++++---=
----
 drivers/net/wireless/iwlwifi/mvm/mac80211.c  |  19 +++--
 drivers/net/wireless/iwlwifi/mvm/mvm.h       |   4 ++
 drivers/net/wireless/iwlwifi/pcie/internal.h |   9 +++
 drivers/net/wireless/iwlwifi/pcie/tx.c       |  75 ++++++++++++++-----
 7 files changed, 165 insertions(+), 71 deletions(-)


--=-kngSTsZeQ+WNNAepOGeb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRLSiyAAoJEDBSmw7B7bqr9z4P/ip2i6aA0JER27TsOllq0pgp
zdiIuZGoq3AA8FFsxaBTbg3775eoB84LLJXn4DXpzuCEq0cciFdfLKRz3M/qyJ3D
VRlB3vodNzPW3B7uszfu0sj0Dy8qQ9UqUvbN0tmOPoFaCuFMqMRYCvcsX7ifkmMf
JP91Ve8lOz9NjN6QdARkML3NSGeNdOIOdgTi6/mGSU9iHK4XC0lEAWAWHnTYsY9h
qpx9TDt+qwkzIm0+6RjbfYhfKAo0scEgl0ZgnueIAzgWhxpTUotpFNl/AZ51oyE2
KVGtbsM7WetNqcnVz77v0PfIZUrIHKtJKCIPhgbwSv9cwVDx/kUtjkqtJPPK9KHx
hWohXRHSlHrE/5NBEFDQr4T4d+9BBjbJ0SyAcIjaHKe3edb8doMebX+2IBoAnD1L
O4+oR/eAY/I9GiYX2UJ+j8ROliVHnlXyNIUL5nhD5CNM7u3FHWTuAn+ZJ7aJOt3u
bYMJTLocH5w3tvBkpMwfcFpS19CnBGzyYOWrXVI8Mvx4/q2r/UvemD9heUBxlTWE
6sizojX/TMBvA5EuJUyp2wRqwGcZJU0QPDI0i8nKGW3nHZbciptWQjOA8155BWr6
PmcVy6Pc9EQ3t3mVv0uzpVEeWZTPs2IHNhEPZbc0b2ioLd1eZ4Nj3sSeGW5zaD0I
XFB/ROMFGMJH7ua7LH6d
=VA8R
-----END PGP SIGNATURE-----

--=-kngSTsZeQ+WNNAepOGeb--

