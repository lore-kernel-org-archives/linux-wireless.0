Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45469 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab2FLT5k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 15:57:40 -0400
Message-ID: <1339531055.4531.21.camel@jlt3.sipsolutions.net> (sfid-20120612_215743_461598_2A44FF39)
Subject: Re: iwlwifi updates for 3.6
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 12 Jun 2012 21:57:35 +0200
In-Reply-To: <1339408392-19425-1-git-send-email-johannes@sipsolutions.net> (sfid-20120611_115334_801449_87F3D667)
References: <1339408392-19425-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120611_115334_801449_87F3D667)
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-IYgsYAEheXhO8pqNwmQm"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-IYgsYAEheXhO8pqNwmQm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

please pull the iwlwifi-next tree.

I've included the patches here, in slightly fixed up versions, a small
additional warning that we need to flag/debug some issues, and also of
course the fix for the EEPROM refactoring vs. addition of the separate
configuration structure for 6035 devices.

The patches I posted previously included a few fixes for code that went
into the tree in my last pull and more debugging utilities.

johannes


The following changes since commit a59f975a78f0606a3a364939dfa9b949d5f87521=
:

  Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/li=
nville/wireless (2012-06-12 14:11:13 -0400)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git fo=
r-john

for you to fetch changes up to 7cd9174d02e2d6df3b6de25fea61ae1b7602d012:

  iwlwifi: fix 6035 device parameters (2012-06-12 21:43:28 +0200)

----------------------------------------------------------------
Brandon Misemer (1):
      iwlwifi: Fix Makefile build order for built-in driver

Dan Carpenter (1):
      iwlwifi: turn on a lockdep assertion

Emmanuel Grumbach (9):
      iwlwifi: s/iwl_read_targ_mem_words/iwl_read_targ_mem_bytes
      iwlwifi: iwl_{read,write}_targ_mem_words takes dwords
      iwlwifi: print more info when a queue is stuck
      iwlwifi: don't configure a txq that is being disabled
      iwlwifi: remove lock around txq_enable
      iwlwifi: comment that setting driver_data overrides info->control
      iwlwifi: print even more info when a queue is stuck
      iwlwifi: don't modify the timer if we don't Tx
      iwlwifi: warn if TFD index and WiFi Seq don't match

Ilan Peer (2):
      iwlwifi: refactor testmode
      iwlwifi: decouple testmode and iwl-test

Johannes Berg (3):
      iwlwifi: fix dynamic loading
      Merge remote-tracking branch 'wireless-next/master' into iwlwifi-next
      iwlwifi: fix 6035 device parameters

 drivers/net/wireless/iwlwifi/Makefile              |   10 +-
 drivers/net/wireless/iwlwifi/dvm/agn.h             |   17 +-
 drivers/net/wireless/iwlwifi/dvm/dev.h             |   26 +-
 drivers/net/wireless/iwlwifi/dvm/lib.c             |    2 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c        |    2 +-
 drivers/net/wireless/iwlwifi/dvm/main.c            |    6 +-
 drivers/net/wireless/iwlwifi/dvm/rx.c              |   24 +-
 drivers/net/wireless/iwlwifi/dvm/testmode.c        |  778 ++--------------=
--
 drivers/net/wireless/iwlwifi/dvm/tx.c              |    1 +
 drivers/net/wireless/iwlwifi/iwl-drv.c             |   15 +
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
 20 files changed, 1243 insertions(+), 856 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-test.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-test.h
 rename drivers/net/wireless/iwlwifi/{dvm/testmode.h =3D> iwl-testmode.h} (=
100%)


--=-IYgsYAEheXhO8pqNwmQm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJP158vAAoJEDBSmw7B7bqrAlcP/1zt1eElwyDi1NhHGpP0cTFb
VKbwEXlWN4n2COn6yBoSEo81uvJeIw/Uh2g6FnnIKyn8DzJ+vipgxwV1rhmtmUdR
eCavbbh7i8+IDG7nhirrQQsbwwYvRfLwP9/ndV1xw3Lso749W1cZpEnYExhDdEra
bPrx/vqHgB/cgPyvdU07e7XuxavNn+K0txR5q0HjIUn0GYJSFMPURVxMImGRwZFj
ymdtz/DVNJ204CVNdfi7cgTDWMw+N753Mkm1OFsM0PaRhpfE3Oq0Njmkkm/SG65i
K/zmKPE+i4Dq7ykNfQs8yHN/ODF8vTyIBHZhkGSz7iMBteoybWFsocu4t8BFq0rb
jwuayFtqIT5gLvYw+B45s0KKjIRRSSuuo/iFSG4sr6Gzmp7EIIriFVdQO730OCk7
KVJ7TTny/9FN6JIlgJiXDp6mRGYeyGr4mM1LvDyX2DkbTqKQZ24szitWVdnXW/La
w2S9F3/Lz8FvJOMPYs5d0L1tTROBaN2Y8GilybxEGUYcGw7cFcD8Ue54lpajt+vN
9FxEzc/a9RBT7OzHXOWhorRO3DfMHA6Yk5ZE5C3tQPLtBvW0Fm2qupInSOs/QqGn
7molelOlRTlUT26z5dlmFP1enOxd+U24QM11gxod+ZHmqEktoq/+68B57EKhe47M
08jpILEwNWMcqERsQ5ou
=ZVxk
-----END PGP SIGNATURE-----

--=-IYgsYAEheXhO8pqNwmQm--

