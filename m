Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60694 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751966AbcGAU73 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2016 16:59:29 -0400
Message-ID: <1467405215.1837.15.camel@coelho.fi> (sfid-20160701_225934_147316_388C55F6)
From: Luca Coelho <luca@coelho.fi>
To: kvalo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 01 Jul 2016 23:33:35 +0300
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-GmxeqAfh/pRWISvrJ9/d"
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2016-07-01
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GmxeqAfh/pRWISvrJ9/d
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Here are some patches intended for 4.8. =C2=A0I have a lot more patches
pending in our internal tree, but I decided to take smaller steps
because it's easier to find a few hours to push a few patches than it
is to find many hours to send all pending patches. =C2=A0Is it okay for you
if I send a bunch of 10-20 patches pull-reqs or do you prefer if I hold
them back and send bigger pull-reqs later?

There's not much here, more details in the tag description.

Let me know if everything's fine (or not). :)

Luca.


The following changes since commit af5e964f3045b66f1cd720b9c5abd37e47e613e2=
:

  MAINTAINERS: add myself as co-maintainer of the iwlwifi driver (2016-05-1=
0 22:34:11 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2016-07-01

for you to fetch changes up to 58035432d60616cc2ef6514a3d0e6d6ad01bf705:

  iwlwifi: mvm: handle FRAME_RELEASE in MQ code (2016-07-01 18:09:46 +0300)

----------------------------------------------------------------
* More work on the RX path for the 9000 device series
* Some more dynamic queue allocation work
* A few bugfixes and other improvements

----------------------------------------------------------------
Andrei Otcheretianski (1):
      iwlwifi: mvm: Support CSA countdown offloading

Avraham Stern (1):
      iwlwifi: rename CAPA_P2P_STANDALONE_UAPSD to CAPA_P2P_SCM_UAPSD

Emmanuel Grumbach (1):
      iwlwifi: advertise maximal MPDU length when Rx MQ is supported

Johannes Berg (2):
      iwlwifi: mvm: fix comment indentation
      iwlwifi: mvm: handle FRAME_RELEASE in MQ code

Liad Kaufman (1):
      iwlwifi: mvm: free dqa queues on STA removal also in non-bss

Sara Sharon (7):
      iwlwifi: mvm: do not trust NSSN for amsdu sub-frames
      iwlwifi: mvm: remove RX_PHY support for 9000 device
      iwlwifi: mvm: update mpdu metadata API
      iwlwifi: pcie: workaround HW shadow registers bug
      iwlwifi: pcie: set RB chunk size per bus
      iwlwifi: pcie: allow more than one frame in RB for 9000 devices
      iwlwifi: pcie: make sure packet arrived to destined queue

 drivers/net/wireless/intel/iwlwifi/dvm/main.c         |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-9000.c         |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-config.h       |   4 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h          |   6 +++--
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c          |   3 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c |   4 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h           |   4 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h      |   9 +++++--
 drivers/net/wireless/intel/iwlwifi/iwl-modparams.h    |   9 ++++---
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c    |   7 +++++
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h        |  11 +++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h    |  52 ++++++++++++++=
+++++++--------------
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h    |  27 ++++++++++++++=
++---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h       |  12 ++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c     | 108 ++++++++++++++=
++++++++++++++++++++++++++++++++++++++++++++++++++---------
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c     |  12 ++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h          |  11 +++++---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c          |  37 ++++++++++++++=
++++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/power.c        |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c           |  13 +++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c         |  97 ++++++++++++++=
++++++++++++++++++++++++++++-----------------------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c          |   5 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h    |   2 ++
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c          |  42 ++++++++++++++=
+++++++--------
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c       |   4 +++
 25 files changed, 376 insertions(+), 107 deletions(-)
--=-GmxeqAfh/pRWISvrJ9/d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXdtOfAAoJEKFHnKIaPMX6EecP/jPKF61JbKyeI8YDNNcGh3Il
S0UMYavdgdMU6fSnMZ8qbDhQs2eG9+5TTfo6+eVaMu6qDdx7VfPggQOnhMlMdNz/
Etj3b2ddMn9dbHYfimjihqYe4xrNXhHtWqdeDmvDjWPw4Ran413pU32pMxiWpDdz
RFRqrwnT5Orf5kFfuS6ONYraBFFtHjR+MQnn+nOBXTdIpMCM2VbctMQP/LRrCgjz
tlavHpbf5ZjpcV+ZTgZnQh6WbcwgfT/ZSxImIyOI2Nrsaly/o9rf/iwqhnmoND8v
airwnurnR1F00L0WzFV4P0gsVMUnc6buP4dhHF1tMlwmFGabCWKR907MGWlCxpxZ
y2xbCFYNAf0j8R8U+fksdzmmuisFB4uoB8Y+gpDVJrTnnrU37K37doUBdnWhTk/t
0CrKULlwv2LkflGqOmebZVTYHPo2DrqhYUmi1Z0kHJZ1KImzmbBG6qXKBEvMRZne
OzTdQxDuhfBd8G5C8rz+mKpG65LpoAZaRXciijaD1ADWUuPaf1xnNUI/zmlDV2Q/
L0Q2QufG0F1FWM3GAxuX29mKfJkF2EOELNV5W9NSpT5/6JFC9/YpEtUm5sC2GtmN
TNt7r/LBQEEyDQRjGi0t5EAcKgw9FlJone2aDTUssgooVUHbHpfCs2J02GdwKWw/
/Nww7VUG0n0hIqxCq5Rf
=N35s
-----END PGP SIGNATURE-----

--=-GmxeqAfh/pRWISvrJ9/d--

