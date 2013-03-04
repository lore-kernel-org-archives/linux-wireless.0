Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41853 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756992Ab3CDOAT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 09:00:19 -0500
Message-ID: <1362405609.21028.12.camel@jlt4.sipsolutions.net> (sfid-20130304_150022_806769_D9E47392)
Subject: pull-request: iwlwifi-fixes 2013-03-04
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 04 Mar 2013 15:00:09 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-pmXA8U8iphRIaDZ8LCaE"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-pmXA8U8iphRIaDZ8LCaE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

For iwlwifi I have a relatively large pull request:

The patches from Dor fix a bunch of calibration issues in the new MVM
driver, and Emmanuel has a number of fixes there as well. Also, we
decided to disable 8k A-MSDU by default, so that's in there. My own
patches are addressing an issue we found with the new devices but that
seems to also exist on older ones, the DMA writeback the devices do can
be delayed and cause issues. The fix is unfortunately relatively large
and depends on two other changes (to not be hugely conflicting), but I
think it's still worth it at this point.

Let me know if there are any issues.

johannes


The following changes since commit e477598351a40769f5b46ccea78479a1aad6f161=
:

  iwlwifi: mvm: Remove testing of static PIC in PhyDB (2013-02-27 09:14:08 =
+0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git f=
or-john

for you to fetch changes up to 2470b36e84a2e680d7a7e3809cbceae5bfae3606:

  iwlwifi: mvm: don't warn on normal BAR sending (2013-03-04 13:39:02 +0100=
)

----------------------------------------------------------------
Dor Shaish (3):
      iwlwifi: mvm: Set valid TX antennas value before calib request
      iwlwifi: mvm: Take the phy_cfg from the TLV value
      iwlwifi: mvm: Remove overriding calibrations for the 7000 family

Emmanuel Grumbach (5):
      iwlwifi: disable 8K A-MSDU by default
      iwlwifi: mvm: restart the NIC of the cmd queue gets full
      iwlwifi: mvm: ignore STOP_AGG when restarting
      iwlwifi: mvm: update the rssi calculation
      iwlwifi: mvm: don't warn on normal BAR sending

Johannes Berg (3):
      iwlwifi: don't map complete commands bidirectionally
      iwlwifi: rename IWL_MAX_CMD_TFDS to IWL_MAX_CMD_TBS_PER_TFD
      iwlwifi: use coherent DMA memory for command header

 drivers/net/wireless/iwlwifi/dvm/sta.c       |   2 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.h  |   2 +-
 drivers/net/wireless/iwlwifi/iwl-drv.c       |   3 +-
 drivers/net/wireless/iwlwifi/iwl-modparams.h |   2 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h     |  20 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api.h    |  18 +-
 drivers/net/wireless/iwlwifi/mvm/fw.c        | 133 +-------------
 drivers/net/wireless/iwlwifi/mvm/mvm.h       |   3 +-
 drivers/net/wireless/iwlwifi/mvm/ops.c       |  18 +-
 drivers/net/wireless/iwlwifi/mvm/rx.c        |  37 ++--
 drivers/net/wireless/iwlwifi/mvm/sta.c       |  10 +
 drivers/net/wireless/iwlwifi/mvm/tx.c        |   6 +-
 drivers/net/wireless/iwlwifi/pcie/internal.h |  34 +++-
 drivers/net/wireless/iwlwifi/pcie/rx.c       |  14 +-
 drivers/net/wireless/iwlwifi/pcie/tx.c       | 266 +++++++++++++----------=
----
 15 files changed, 229 insertions(+), 339 deletions(-)


--=-pmXA8U8iphRIaDZ8LCaE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRNKjpAAoJEDBSmw7B7bqra6IQAM3bfXesg+at/hpzsyeScIS9
k6nCviM7TMFsd/0NYJp2SzTEvEPHolBP8A0VgqoMJdgi8ce1YFNx3fkv4pkLX1ZE
QlE8IFzuupJ1LCNv7geeLvm0MoUzfHw6zMnzuxLhWv+6kFgAHlqoxfx5zRI8IIok
DH6swfCNIK4RxqleuKBYwTSNmBeIuniTstr78yyIEI0DRpvLdH0XZljzlmbNRU1O
l8sM5p5EamScYlSffxb/JDf0W5f2rAd7omEVxaBH9L/ZFApb3lNuSjJIYnlVU8+4
dWoRTjLMvaO5Nis79VGeoYXfzPjjdQ9kBTxM61z9iuWYOEea/hkWGiBza1RKB/PM
SY8PO6R1JUEB+CbCyeMO0iTr09R4h5PBEzq/iyEbk402PFC6VhQ1afmo5rvDLTlA
hKaEdtp0zdoH5MJByYcnmgHSB2qAYIm6REidx2Q1gok3b5rDQYo0kAlzZQOZxzYT
4NDZ4Z0iFiCSA3aPGamFYuDrg6+YVn+FM2w9/0Rsdkf19TTivZ7CM4PP3eGj35Ax
Hvq4Z56/tqTz2+AFJY25Ri1cE6/gm9x26w75MWYA7/NTNNLXrI1rFYVyguS4yA4s
74K7Vd17ivBxa8usclYws20TKQHIKATX8MYRvHe8C6gjxu8aE3tAJzzVbF/jwTzF
N2ZZIXYF330ZprDwcQKg
=+Sfp
-----END PGP SIGNATURE-----

--=-pmXA8U8iphRIaDZ8LCaE--

