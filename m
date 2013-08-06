Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54458 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab3HFIuY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 04:50:24 -0400
Message-ID: <1375779012.8219.3.camel@jlt4.sipsolutions.net> (sfid-20130806_105029_600168_0730F8FC)
Subject: pull-request: iwlwifi-fixes 2013-08-06
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 06 Aug 2013 10:50:12 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-YWxVd9shNwKJPcdQ3hat"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YWxVd9shNwKJPcdQ3hat
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

I have a few more fixes for iwlwifi.

We revert an rfkill bugfix that unfortunately caused more bugs, shuffle
some code to avoid touching the PCIe device before it's enabled and
disconnect if firmware fails to do our bidding. I also have Stanislaw's
fix to not crash in some channel switch scenarios.

Let me know if there's any problem.

Thanks,
johannes

The following changes since commit a53ee0a308b16e392e0219c585b10f329345766b=
:

  iwlwifi: pcie: clear RFKILL interrupt in AMPG (2013-07-26 10:07:10 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git f=
or-john

for you to fetch changes up to 057397943eee0bf3bc01a58ee52a9a6f1810258e:

  iwlwifi: mvm: disconnect if time event scheduling fails (2013-08-06 10:35=
:19 +0200)

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: pcie: disable L1 Active after pci_enable_device

Guy Cohen (1):
      Revert "iwlwifi: pcie: clear RFKILL interrupt in AMPG"

Johannes Berg (1):
      iwlwifi: mvm: disconnect if time event scheduling fails

Stanislaw Gruszka (1):
      iwlwifi: dvm: fix calling ieee80211_chswitch_done() with NULL

 drivers/net/wireless/iwlwifi/dvm/mac80211.c   |  5 +++-
 drivers/net/wireless/iwlwifi/iwl-prph.h       |  2 --
 drivers/net/wireless/iwlwifi/mvm/time-event.c | 33 +++++++++++++++++++----=
----
 drivers/net/wireless/iwlwifi/pcie/rx.c        |  8 -------
 drivers/net/wireless/iwlwifi/pcie/trans.c     | 10 ++++----
 5 files changed, 32 insertions(+), 26 deletions(-)



--=-YWxVd9shNwKJPcdQ3hat
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJSALjEAAoJEDBSmw7B7bqrn9YP/A/yDuI6xWuMDCV2baJVoAa9
YjuYPx35gwA2yqXa3+PpOZluEDghjN+fJ3ej6GPz/+5eR4d8PmTpp8iC5vhEV5e4
jtngCS1haC9utpEdV/CGlnXYhvW8LbnJyE3bG8I4P+CxKXJnIE/hx3MyOvKz5vUL
ZFtGfygmYeeYcBBmwoQQ0x2MAINjNRG2TDTw3sX2QKDFJg6rLItt6zEBohmqqQd7
Cr4ZYDtQS3Y1k6x5tTau4uzcaUUbDuPgWjw0m1hCAnjwt8tSmXXzEYlmq0glmNTO
ehHpmv82IUu9nQJTz4iABwyrsmq6w5msUFP/z2ozF0wrEfU27EKU3GPEOihrsPHq
Tj8ws5F8B9Pq8JTgxzDE05Tw9hHHjBcC4DASxGXk5JCnkNIFdn7nWGkxkb48R+sp
YlaNHtuB6l7fag9emx91IcF0bsNnnynbqUlxENxpb+iWPLMk7lfkwuZwHTUrxiGe
/AUQTt0f1tWoeRS9VBGvk4hnIWuSCafIREq0EgmdXKDGOrF9Xzwo9MsEgeRtFsWD
j6qxY3f2oYXwkN0f2l1YoLaBYW2swsJy5UiZFHyT2rmtNjbJcq8ZscTOZeVky4U7
NWh4/kdG8K52DNyCxtyA8QNOoR8q4GT/k3CGpqQ71CQgZ2KyLvlxAHX5K4XPLfsU
EcB7Q0UzjBLmbbDI4frz
=DCcx
-----END PGP SIGNATURE-----

--=-YWxVd9shNwKJPcdQ3hat--

