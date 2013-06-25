Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39987 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab3FYLgf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jun 2013 07:36:35 -0400
Message-ID: <1372160186.8372.13.camel@jlt4.sipsolutions.net> (sfid-20130625_133638_863842_2396148D)
Subject: pull-request: iwlwifi-next 2013-06-25
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 25 Jun 2013 13:36:26 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-YjeCXEr+MkqlnSZuc2Rg"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YjeCXEr+MkqlnSZuc2Rg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

This is hopefully going to be the last big pull request for
iwlwifi-next, luckily it actually mostly removes code ;-)

Emmanuel removed some unneeded/unsupported module parameters and adds a
Bluetooth 1x1 lookup-table for some upcoming products. From Alex I have
an older patch to add low-power receive support, this depended on a
mac80211 commit that only just came in with the merge from wireless-next
I did. Ilan made beacon timings better, and Eytan added some debug
statements for thermal throttling. I have a few cleanups, a fix for a
long-standing but rare warning, and, arguably the most important patch
here, the firmware API version bump for the 7260/3160 devices.

Let me know if there are any issues.

johannes



The following changes since commit 9fbdc75116f7a2b183464d42f3abccb616584105=
:

  Merge branch 'for-upstream' of git://git.kernel.org/pub/scm/linux/kernel/=
git/bluetooth/bluetooth-next (2013-06-24 14:45:50 -0400)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git fo=
r-john

for you to fetch changes up to bd4ace2a36e7c87bb5f3eceb54d3b304d395dcf0:

  iwlwifi: mvm: Add support for Low Power RX (2013-06-25 12:21:19 +0200)

----------------------------------------------------------------
Alexander Bondar (1):
      iwlwifi: mvm: Add support for Low Power RX

Emmanuel Grumbach (4):
      iwlwifi: remove bt_ch_announce module param
      iwlwifi: remove plcp_check module parameter
      iwlwifi: remove auto_agg module parameter
      iwlwifi: mvm: add BT-Coex LUT for 1x1 products

Ilan Peer (1):
      iwlwifi: mvm: Change the settings of AP beacon time

Johannes Berg (7):
      iwlwifi: bump required firmware API version for 3160/7260
      iwlwifi: mvm: allow firmware crashes to wake system for debug
      iwlwifi: remove testmode
      iwlwifi: pcie: rework RX buffer list init and freeing
      iwlwifi: always use 'rxq' as RX queue struct name
      iwlwifi: always use 'trans_pcie' name
      Merge remote-tracking branch 'wireless-next/master' into iwlwifi-next

eytan lifshitz (1):
      iwlwifi: mvm: add thermal throttling debugging

 drivers/net/wireless/iwlwifi/Kconfig            |  10 -
 drivers/net/wireless/iwlwifi/Makefile           |   1 -
 drivers/net/wireless/iwlwifi/dvm/Makefile       |   1 -
 drivers/net/wireless/iwlwifi/dvm/agn.h          |  37 -
 drivers/net/wireless/iwlwifi/dvm/dev.h          |  13 +-
 drivers/net/wireless/iwlwifi/dvm/lib.c          |   6 -
 drivers/net/wireless/iwlwifi/dvm/mac80211.c     |   2 -
 drivers/net/wireless/iwlwifi/dvm/main.c         |  15 +-
 drivers/net/wireless/iwlwifi/dvm/rs.c           |  43 +-
 drivers/net/wireless/iwlwifi/dvm/rx.c           |  40 +-
 drivers/net/wireless/iwlwifi/dvm/testmode.c     | 471 -------------
 drivers/net/wireless/iwlwifi/dvm/tx.c           |  12 -
 drivers/net/wireless/iwlwifi/iwl-7000.c         |  12 +-
 drivers/net/wireless/iwlwifi/iwl-config.h       |   1 +
 drivers/net/wireless/iwlwifi/iwl-drv.c          |  16 -
 drivers/net/wireless/iwlwifi/iwl-modparams.h    |   6 -
 drivers/net/wireless/iwlwifi/iwl-test.c         | 852 --------------------=
----
 drivers/net/wireless/iwlwifi/iwl-test.h         | 161 -----
 drivers/net/wireless/iwlwifi/iwl-testmode.h     | 309 ---------
 drivers/net/wireless/iwlwifi/iwl-trans.h        |   2 -
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c      |  21 +-
 drivers/net/wireless/iwlwifi/mvm/d3.c           |   6 +
 drivers/net/wireless/iwlwifi/mvm/debugfs.c      |  27 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h |   5 +
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c     |  56 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h          |   8 +-
 drivers/net/wireless/iwlwifi/mvm/power.c        |  22 +-
 drivers/net/wireless/iwlwifi/mvm/rs.c           |  30 +-
 drivers/net/wireless/iwlwifi/mvm/tt.c           |  22 +-
 drivers/net/wireless/iwlwifi/pcie/rx.c          |  71 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c       |  17 +-
 31 files changed, 251 insertions(+), 2044 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlwifi/dvm/testmode.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-test.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-test.h
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-testmode.h


--=-YjeCXEr+MkqlnSZuc2Rg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRyYC6AAoJEDBSmw7B7bqrqxYQAMsI3R/8EucsX3FIkvI+3lqX
whWN6VBTwFFVcsIzkXxlkEiw7bFJRvyMQ9foMC4uyK6frfiSgYxyXf74wSF5AMSK
1ZID1VnyYvm4WiL1nxxZqv+vxpkGgNONIzulYiY8Lj062gSVEu6DqLjUL0de1ius
ydAur8o2fsYh23QS3eAAEQVgeA4jLiMVqb9HSzupecHR0/ERRj97RCeEFQqAuYzF
FPNssJ9nAwmfFLP1xS+g0blmCH3s8JbxwnICckzzRtr9wfLUiMM26z/IzHmaoVUJ
bX1E+1LSJaAZnb3PXYy5zPG35mlfsBUPLXPdbEQpWT/lO5GHSzBvTIwlLEgbJsEU
G+N16nIODMLwcjgkG+LR5rm4ST78r9SQR10eVboicXPV+Vvi3KJuvjUozd3T6XIc
3iLn8Qjt/5mz0g4OJ8X1eObOCSkHNZ9wKC4cFxWXTknpkxBrOLTQDvoRKP8xov5z
2FCqGU2BW5RfmHWG34DDv4ecdV5OlB+csL5Qpzkha3Y4OOdo85ZoxLc2Jn161KQK
QNFLQMC5L13Z5j1QXsI7D2cdBNTAqehcBMw+615UDz1MADjSEytLW+ze0XxliEzp
YotLfHergtp2047GljNorWx2fw8JI5embOMe0t3fLVCFf/8BWGtjoFfmHJ9dGSi/
2v/bV75kVzafDKFWowW8
=4n0v
-----END PGP SIGNATURE-----

--=-YjeCXEr+MkqlnSZuc2Rg--

