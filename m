Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52689 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab2INMxT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 08:53:19 -0400
Message-ID: <1347627232.4060.10.camel@jlt4.sipsolutions.net> (sfid-20120914_145345_569013_89C9F12A)
Subject: pull-request: iwlwifi-next 2012-09-14
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 14 Sep 2012 14:53:52 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-6hU2h41ISb3k8nXnZmA9"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6hU2h41ISb3k8nXnZmA9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

Another pull request, this one for iwlwifi, but it has fewer changes
than mac80211 :-)

This is mostly random fixes/cleanups all over, including the firmware
allocation change. I've not tagged that for stable (yet) since we didn't
really cause the regression, I have a feeling that it might be better to
just set __GFP_REPEAT in stable kernels as Mel Gorman had pointed out
that this was previously implicitly included and now gone due to
allocator changes.

johannes

----

The following changes since commit c5d472212024543e32cf3eea4381ab91b9f6b812=
:

  iwlwifi: remove radio_config from eeprom_data (2012-09-05 16:18:01 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git fo=
r-john

for you to fetch changes up to 83f84d7bd49f9e4deea0a77a76c9882673ee1f3c:

  iwlwifi: load firmware in chunks (2012-09-10 19:14:30 +0200)

----------------------------------------------------------------
David Spinadel (2):
      iwlwifi: don't reset interupts after disabling
      iwlwifi: stop interrupts before stopping device

Emmanuel Grumbach (2):
      iwlwifi: some clean up in transport layer
      iwlwifi: don't access the HW when it is not available

Johannes Berg (3):
      iwlwifi: remove unused IDI code stubs
      iwlwifi: fix indentation in iwl_load_given_ucode
      iwlwifi: load firmware in chunks

 drivers/net/wireless/iwlwifi/dvm/ucode.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-drv.c       |   26 ++++----
 drivers/net/wireless/iwlwifi/iwl-fw.h        |    3 +-
 drivers/net/wireless/iwlwifi/pcie/drv.c      |   13 ----
 drivers/net/wireless/iwlwifi/pcie/internal.h |    2 +-
 drivers/net/wireless/iwlwifi/pcie/rx.c       |   75 +++++++++++++---------=
-
 drivers/net/wireless/iwlwifi/pcie/trans.c    |   84 +++++++++++++++++-----=
----
 7 files changed, 117 insertions(+), 90 deletions(-)


--=-6hU2h41ISb3k8nXnZmA9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJQUyjgAAoJEDBSmw7B7bqr4kUP/Aj7KsTCM3MkhL+v25v6BMRI
6bRtoWDrSsCbp5ZjwOVv/xSHO7raPZyej6PFFETbE3hC7Pvj9d6WaU+167mrLR8Y
71i3dYWxM9pwTG6yJoej9rpp8ShrEBfHWoDCGqQ2H7Ja61uWtxW77meNbjaw9xRx
Mb2N23KQyTzp8dWBFrt3KAm1sNzc4tbtku9cbr288R0DO2OqbkKliaskkIMedLZn
P6lAI3nud0z+pTd3QVTiycXIQzx6nh1MgQD7yo18aTtx1X2ICcY2JPZRt+f1ZZ/G
HO1e4hrItPmMVBYV4TchZ7Fjeuef7q/7NEdVx1GxmlIQoYLM8j+2ayGvOrFxLf3K
ru25PrERh7nAaFoG349M+OqJd0FDtRwrASGPhCBfEq1q9DI8ZcdaI4jtS33HpA9C
qS6wjCI2zz9e9OlFetxzSmY+9fN/WiNZ6PaW8cNHW1K+zGNvb1g3qogmgWPn4zdv
qS/aWo8k9hleqVkIl1MKbECCaJqowPo/Bu26XallSRRWi6pM7pldodsi/nOpXZdy
ZNZPbWBvwlmQ3lJT6A525md4ULFANN/g3K85tQAkBRbtFMw7QqGwJyW4n1im/zGr
QwS3tCn52GYNsA2kdSFEYDw5coYUvDx3gg9sjO4WyOxNAfP1f9LUk3Vnj7hkAi/j
tyqCzUllJcNjwxheUBtg
=YJvD
-----END PGP SIGNATURE-----

--=-6hU2h41ISb3k8nXnZmA9--

