Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58058 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab3GZISF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:18:05 -0400
Message-ID: <1374826675.8248.11.camel@jlt4.sipsolutions.net> (sfid-20130726_101813_440989_C8E804CF)
Subject: pull-request: iwlwifi-fixes 2013-07-26
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 26 Jul 2013 10:17:55 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-FtN9qDVi7XkSFqu13IYo"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FtN9qDVi7XkSFqu13IYo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Yet some more fixes - we're adding tests and are doing a debug cycle
with them.

We have a scan fix for passive channels, a new PCI device ID for an old
device, a NIC reset fix, an RF-Kill fix, a fix for powersave when GO
interfaces are present as well as an aggregation session fix (for a
corner case) and a workaround for a firmware design issue - it only
supports a single GTK in D3.

Let me know if there's any problem.

johannes



The following changes since commit a590ad411891de551e6de1b51ea635c0484148d6=
:

  iwlwifi: mvm: remove extra SSID from probe request (2013-07-16 13:55:15 +=
0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git f=
or-john

for you to fetch changes up to a53ee0a308b16e392e0219c585b10f329345766b:

  iwlwifi: pcie: clear RFKILL interrupt in AMPG (2013-07-26 10:07:10 +0200)

----------------------------------------------------------------
David Spinadel (1):
      iwlwifi: mvm: set SSID bits for passive channels

Emmanuel Grumbach (3):
      iwlwifi: add DELL SKU for 5150 HMC
      iwlwifi: pcie: reset the NIC before the bring up
      iwlwifi: pcie: clear RFKILL interrupt in AMPG

Ilan Peer (1):
      iwlwifi: mvm: Disable managed PS when GO is added

Johannes Berg (2):
      iwlwifi: mvm: use only a single GTK in D3
      iwlwifi: mvm: fix flushing not started aggregation sessions

 drivers/net/wireless/iwlwifi/iwl-prph.h        |  2 ++
 drivers/net/wireless/iwlwifi/mvm/d3.c          | 15 ++++++---
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h |  1 -
 drivers/net/wireless/iwlwifi/mvm/mac80211.c    | 42 +++++++++++++---------=
----
 drivers/net/wireless/iwlwifi/mvm/scan.c        | 11 ++-----
 drivers/net/wireless/iwlwifi/mvm/sta.c         | 11 +++++--
 drivers/net/wireless/iwlwifi/pcie/drv.c        |  1 +
 drivers/net/wireless/iwlwifi/pcie/rx.c         |  8 +++++
 drivers/net/wireless/iwlwifi/pcie/trans.c      |  5 +++
 9 files changed, 57 insertions(+), 39 deletions(-)


--=-FtN9qDVi7XkSFqu13IYo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJR8jCzAAoJEDBSmw7B7bqrWtoP/14X9Uaw4u0Fg182pnDihVHg
ZueMUZerc17yitX5wHMXu5+KkPShY6i6I85XyG2WhqM+dZa3L5JPqwATmJMJXK/q
1BYOpXpShCP47AxrriE8b0BNKBwEovrIPXfe5TsMtiHeSuxWjUHTAfRWPIzbMx3V
djRZZDNkoDnaAT93a+Q5KdRSHnR0HlfHhxz/RHnRBVX1ZpnqaTBTsrzU+jjfJCsY
JGzQp+LEBiegNXPMvrID4sycktTwcjpCBqxTL1kepKmPFLFBV36HsyBVHxohCmXX
wnJNr/vlDkZPuXKYvwIS7Mk2tFVt15DhzkXik2uNXqhFtlv+ny67BespyqFFaU44
ARHA9yeRWTDBrPZuO/aHYOFOMfHgvw00pad/7wrZ0ndTl2Sdvz1GDMcuwxheTLu1
tJE8gMA6vBbYZZRCEhGT+wkoLk8Is6arANzCzI6oUD5udw4++Td2fakE9boM/egF
or1jPKIC4q/Hhp08++C4ZpK/QVWBRd4MHvqFfilqJn/cytTOxM4tTwphQ1Fyp6wb
mbcZE10gIA3bCo9slIows2fk+P3kj8PJkSxCKgR2q7C4DoctSoSOFo/5NRHwNGzH
vEHtptwd2gs69WqP3F47pGBRz1E83dtChnvSXCd6qukrxo/Jq4FSU0+sV8KgfXer
Y7Qa3AjdjMXgQIUHvq/K
=lwf/
-----END PGP SIGNATURE-----

--=-FtN9qDVi7XkSFqu13IYo--

