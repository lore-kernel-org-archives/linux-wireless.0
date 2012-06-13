Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49826 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab2FMN6M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 09:58:12 -0400
Message-ID: <1339595889.4519.46.camel@jlt3.sipsolutions.net> (sfid-20120613_155816_462406_0F4989CC)
Subject: pull-request: iwlwifi-next 2012-06-13
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 13 Jun 2012 15:58:09 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-LmT/yzFz6YVIon/sQpWZ"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LmT/yzFz6YVIon/sQpWZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Please pull my iwlwifi-next tree. I've included debugging aids, fixes
for recently introduced bugs (the Makefile order & dynamic loading
locking/list corruption), some refactoring and various other changes.
Also, I've fixed the 6035 device configuration which was added in
wireless but in wireless-next now needs an EEPROM configuration pointer.

Thanks!

johannes

------

The following changes since commit a59f975a78f0606a3a364939dfa9b949d5f87521=
:

  Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/li=
nville/wireless (2012-06-12 14:11:13 -0400)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git fo=
r-john

for you to fetch changes up to 67711c17fc8bcab8f9e92c49049b8356f9a557c1:

  iwlwifi: WARN only once when we have trouble in reclaim (2012-06-13 09:02=
:09 +0200)

----------------------------------------------------------------
Brandon Misemer (1):
      iwlwifi: Fix Makefile build order for built-in driver

Dan Carpenter (1):
      iwlwifi: turn on a lockdep assertion

Emmanuel Grumbach (10):
      iwlwifi: s/iwl_read_targ_mem_words/iwl_read_targ_mem_bytes
      iwlwifi: iwl_{read,write}_targ_mem_words takes dwords
      iwlwifi: print more info when a queue is stuck
      iwlwifi: don't configure a txq that is being disabled
      iwlwifi: remove lock around txq_enable
      iwlwifi: comment that setting driver_data overrides info->control
      iwlwifi: print even more info when a queue is stuck
      iwlwifi: don't modify the timer if we don't Tx
      iwlwifi: warn if TFD index and WiFi Seq don't match
      iwlwifi: WARN only once when we have trouble in reclaim

Ilan Peer (2):
      iwlwifi: refactor testmode
      iwlwifi: decouple testmode and iwl-test

Johannes Berg (4):
      iwlwifi: fix dynamic loading
      Merge remote-tracking branch 'wireless-next/master' into iwlwifi-next
      iwlwifi: fix 6035 device parameters
      iwlwifi: use request_module instead of _nowait

 drivers/net/wireless/iwlwifi/Makefile              |   10 +-
 drivers/net/wireless/iwlwifi/dvm/agn.h             |   17 +-
 drivers/net/wireless/iwlwifi/dvm/dev.h             |   26 +-
 drivers/net/wireless/iwlwifi/dvm/lib.c             |    2 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c        |    2 +-
 drivers/net/wireless/iwlwifi/dvm/main.c            |    6 +-
 drivers/net/wireless/iwlwifi/dvm/rx.c              |   24 +-
 drivers/net/wireless/iwlwifi/dvm/testmode.c        |  778 ++--------------=
--
 drivers/net/wireless/iwlwifi/dvm/tx.c              |    4 +-
 drivers/net/wireless/iwlwifi/iwl-drv.c             |   34 +-
 drivers/net/wireless/iwlwifi/iwl-fh.h              |    2 +
 drivers/net/wireless/iwlwifi/iwl-io.c              |   20 +-
 drivers/net/wireless/iwlwifi/iwl-io.h              |   14 +-
 drivers/net/wireless/iwlwifi/iwl-test.c            |  856 ++++++++++++++++=
++++
 drivers/net/wireless/iwlwifi/iwl-test.h            |  161 ++++
 .../iwlwifi/{dvm/testmode.h =3D> iwl-testmode.h}     |    0
 drivers/net/wireless/iwlwifi/pcie/6000.c           |    1 +
 drivers/net/wireless/iwlwifi/pcie/internal.h       |    9 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c          |   60 +-
 drivers/net/wireless/iwlwifi/pcie/tx.c             |   95 +--
 20 files changed, 1263 insertions(+), 858 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-test.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-test.h
 rename drivers/net/wireless/iwlwifi/{dvm/testmode.h =3D> iwl-testmode.h} (=
100%)


--=-LmT/yzFz6YVIon/sQpWZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJP2JxxAAoJEDBSmw7B7bqrfZ4P/iy2KraXNQKhF0GroKTns3Zk
pCXJxN73SQMCQXf4s9rJkXmnDvZgXoa/KM6LUnKNZ/6SkBQ2fGZ1EBGDcfSrIjwN
jxQSDS5hvaThuFzUF0Yj3amBTNOKSXfFGv+XWCvEkyssDpXCuWSWr+otv6g2q1k1
LQau9hsnGuAtbSFVsVhjSlzJenEilMn1QEInu2SMIkvrlBNHjfGA2Qxj3bUoTUN2
KcUkZvyewmo9j7sDhRI6VPslce0XUMfZO0FrP6a0EOvqOEM3G64LSlir5WInbvCA
z7UcuP+dg+v1NSrvkQ6Tx/yW/l29Fr8XsYmNO3bTSP8Vi7z/xXFukunjoIf+Og9W
BOere7bfiyL/WuEsUSzxmbR1BzLNoENuS6ej0OV2sQ16rBZoPrkyk8dawSCjaIic
0EsRipB2Tud3LzsOx7wBjzzUES2TjAIoPF2o1QJJy3Q3Asa4Rvkf5z0Q2diZmTD4
xxc3+O6Yhls9nxQ/S+RlKhVV2p5HBBF15IQlWW9MDiKar3YPNlDnppwknfPNqvA8
uMRjluWHidV26U0vM4dD0ZrGQJ+f5lqIjEYIJIgbU2+MVTiJq0yJ1QOVqoMyxiKI
htx4htItstrZ2nP9wxOyhybLdGssI3ahTmgkVFldXYKobFI7tlvBGRZiZ9geN2O5
/JGjva5zguMsZRBUVzL1
=AhMZ
-----END PGP SIGNATURE-----

--=-LmT/yzFz6YVIon/sQpWZ--

