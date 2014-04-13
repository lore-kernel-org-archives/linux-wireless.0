Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48475 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083AbaDMNA0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 09:00:26 -0400
Received: by mail-wg0-f44.google.com with SMTP id m15so7186370wgh.27
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 06:00:25 -0700 (PDT)
Message-ID: <534A8A49.2030100@gmail.com> (sfid-20140413_150031_318913_8DEB4EFE)
Date: Sun, 13 Apr 2014 15:59:53 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: pull request: iwlwifi 2014-04-13
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="XoGP7sVKBib7unjthHfGioKlB6VvePwoI"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XoGP7sVKBib7unjthHfGioKlB6VvePwoI
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi John,

This is a first pull request of fixes for 3.15.

I have new device IDs and a new firmware API. These are the trivial ones.=
 The less trivial ones are Johannes's fix that delays the enablement of a=
n interrupt coalescing hardware until after association - this fixes a fe=
w connection problems seen in the field. Eyal has a bunch of rate control=
 fixes. I decided to add these for 3.15 because they fix some disconnecti=
on and packet loss scenarios which were reported by the field. I also hav=
e a fix for a memory leak that happens only with a very new NIC.

I'll be with low connectivity for the coming week and a half, so I want h=
ope you won't have any issues with this pull request. If you do have issu=
es, please let me know, but I am not sure I'll be able to handle the prob=
lems immediately.

Thanks!

The following changes since commit 67b3bd4e65f0854aca70e0134d59b1daede495=
04:

  brcmfmac: fallback to mimo_bw_cap for older firmwares (2014-03-20 11:55=
:41 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git=
 for-john

for you to fetch changes up to f59913dfbb8ce07d7fb527f67b26791aa849aa1c:

  iwlwifi: mvm: BT Coex - fix Look Up Table (2014-04-13 15:57:36 +0300)

----------------------------------------------------------------
Emmanuel Grumbach (4):
      iwlwifi: mvm: BT Coex - send the new LUT upon antenna coupling chan=
ge
      iwlwifi: 7000: bump API to 9
      iwlwifi: add MODULE_FIRMWARE for 7265
      iwlwifi: mvm: BT Coex - fix Look Up Table

Eyal Shapira (7):
      iwlwifi: mvm: rs: fix mimo delimiter in LQ cmd
      iwlwifi: mvm: rs: use correct max expected throughput figures
      iwlwifi: mvm: rs: fix and cleanup rs_get_rate_action
      iwlwifi: mvm: rs: reinit rs if no tx for a long time
      iwlwifi: mvm: rs: fallback to legacy Tx columns
      iwlwifi: mvm: avoid searching unnecessary columns
      iwlwifi: mvm: rs: clear per rate stats when aggregation changes

Johannes Berg (1):
      iwlwifi: mvm: delay enabling smart FIFO until after beacon RX

Oren Givon (1):
      iwlwifi: add new 7265 HW IDs

 drivers/net/wireless/iwlwifi/iwl-7000.c     |   5 +-
 drivers/net/wireless/iwlwifi/mvm/coex.c     |  18 +++++---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |   1 +
 drivers/net/wireless/iwlwifi/mvm/rs.c       | 261 ++++++++++++++++++++++=
++++++++++++++++++++++++++++++++++++++++++++-----------------------------=
----------
 drivers/net/wireless/iwlwifi/mvm/rs.h       |  14 ++++--
 drivers/net/wireless/iwlwifi/mvm/sf.c       |   3 +-
 drivers/net/wireless/iwlwifi/pcie/drv.c     |   2 +
 7 files changed, 195 insertions(+), 109 deletions(-)


--XoGP7sVKBib7unjthHfGioKlB6VvePwoI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTSopgAAoJEC0Llv5uNjIBEOUP/2K/T48HSBU3Nx+4pAx2Y5tc
boFrq/s2xPD7raxAaDYob0RxhD9Y04MTMBQZDMTVi/JD98f/zDr6Mk9z3E/4RkLu
BycXlWtlFBot2n7V4wdACKmZJEJUVkT8qmWllvc+KBO59BZJRxqQ6zneqC/Vnjhs
N+kKfhzxG2JGNsGIzFueaX7LevqZBpUXyv9yc8oJCe71tuy0dr8IGHWdrteKc8G+
e1jwMNizSYn65RepPcl5JA03jNpUIDMsE/nWqJiHEcMxlokxjvDR62oAMQ1AIUT+
KXoxAVfd9ZrtmNMnpcaoyAWy0UKwbdaz41acYmnJyclmjI8pLXSoUFGLV4r+Srs+
KHhFiZ5dLO00sGgPjbP/2B9wx3PT0AvTlsOeswbBTA55SRqXSnTgYUATYD1nvPLo
MoMsSBHbIP5SCt9uVCNbemUBUC6rikkK0x4MHKrwLxljOM2UcKhBE3IuvkZ0JrDp
4/tYv3tIiw5c/m1ruw0BsJMw95cg5x/YezU7qRzKzCEJzKNPBmmEf6zh9u+4M+DP
ud3IxmW0JiveY5Vo9aiVjsRv+HYc1BLALnuIlK1orrdzK7rud9/ZdT4uH8O0AIa0
GOAB2KdGQxw1ZIrOu2j8/6AaID4WUk7ucKI1oZhp2ABie25IGQpy1vL5L2pKB6Is
LukJCk4hzR/seB/3J8b2
=L71g
-----END PGP SIGNATURE-----

--XoGP7sVKBib7unjthHfGioKlB6VvePwoI--
