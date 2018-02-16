Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59018 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S966400AbeBPPJC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Feb 2018 10:09:02 -0500
Message-ID: <1518793739.7832.59.camel@coelho.fi> (sfid-20180216_160908_297903_65845298)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Date: Fri, 16 Feb 2018 17:08:59 +0200
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-BK0RAz7OtL4JM+GjGdSO"
Mime-Version: 1.0
Subject: pull-request: iwlwifi 2018-02-16-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BK0RAz7OtL4JM+GjGdSO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Here is v2 ofmy first set of fixes for 4.16.  More details in the tag
description.

This fixes a compilation problem that was found by kbuildbot (missing
include in in mvm.h on "iwlwifi: align timestamp cancel with timestamp
start").

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 7ac8ff95f48cbfa609a060fd6a1e361dd62feeb3=
:

  mvpp2: fix multicast address filter (2018-02-11 22:37:04 -0500)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git t=
ags/iwlwifi-for-kalle-2018-02-16-2

for you to fetch changes up to 6b7a5aea71b342ec0593d23b08383e1f33da4c9a:

  iwlwifi: mvm: always init rs with 20mhz bandwidth rates (2018-02-16 17:04=
:05 +0200)

----------------------------------------------------------------
First batch of iwlwifi fixes intended for 4.16:

* A couple of bugzilla fixes
  - Fix a bogus warning when freeing a TFD;
  - Fix severe throughput problem with 9000 series;
* Fix for a bug that caused queue hangs in certain situations;
* Fix for an issue with IBSS;
* Fix an issue with rate-scalingin AP-mode.

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: pcie: don't warn if we use all the transmit pointers

Naftali Goldstein (1):
      iwlwifi: mvm: always init rs with 20mhz bandwidth rates

Sara Sharon (2):
      iwlwifi: mvm: fix security bug in PN checking
      iwlwifi: mvm: fix IBSS for devices that support station type API

Shaul Triebitz (1):
      iwlwifi: align timestamp cancel with timestamp start

 drivers/net/wireless/intel/iwlwifi/fw/init.c      |  6 ------
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |  3 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |  4 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      |  2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c      |  2 --
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c       | 28 +++++++++++++++++++=
+--------
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c     | 39 +++++++++++++++++++=
+-------------------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      | 24 ++++++++++++-------=
-----
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c |  2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c      |  2 +-
 10 files changed, 62 insertions(+), 50 deletions(-)
--=-BK0RAz7OtL4JM+GjGdSO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlqG9AsACgkQoUecoho8
xfpMww//R1kVNyPWNl/ozORh49l4LDo6fe3Z474uy/rSripDeI0ycpowiTGYE5q1
NSvTo8Ethvfiw89+HEi1WXh37xJVGB1tQJy88fxmvMDVkvXlIn88g8FM1btmxMZ6
VkGa/RjZj1+qQNv7EDxEIxPzfziRiBbBOElonf8FMtQzk9BuiRL2guuYi1F0cmui
/tN0cllKKOncEcgRHgD8P+H6FuXr81EbRyaaovZQ2Th/F5E2tzVTBOOV6ENsmqiX
vE5PSh7OCvIJd0BsV+aUbWUaJhrE0uKT1P+5tAv6skLiOpe+yfMwWmheJszfIIUD
/W+4XTJG5Bieh3sbEkGI0X0WT4Tt9mt3zQ+cy8D0/WlGrYiPQ5ZPkKxNvlfhgzuJ
DgdvTz2Ay82Je6d1js4RJUrn3Z1ViaHAqwO6/j0N0+hUZEpBuO+qnaIoMJVqF2iB
ruBNtPhR3iQzjY7xRrBewznwiqh+oWA6UU65GLEw6IY796caOmSXTBPzsGaZNDU0
UsIRaDu/HZBdhlG+L0Ae+Q5xTvto3GdU4GOM8TA6b6ILYA7iid2yXpY6Ii27RpR/
k66815cLQt1a1xV7uFlZ8JLIQRDNf7jlfYl8K02as3rAcToPAt8Dm5z2xi+Q4Ye1
v/AGtgC/a6I1hOxhKylTxFHHtW9qW/ybfiMMEw8YnOFI+iH4ozA=
=hiP9
-----END PGP SIGNATURE-----

--=-BK0RAz7OtL4JM+GjGdSO--
