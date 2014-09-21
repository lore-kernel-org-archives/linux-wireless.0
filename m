Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:34796 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbaIUTPk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Sep 2014 15:15:40 -0400
Received: by mail-wg0-f49.google.com with SMTP id x12so1637569wgg.8
        for <linux-wireless@vger.kernel.org>; Sun, 21 Sep 2014 12:15:39 -0700 (PDT)
Message-ID: <541F23D2.90600@gmail.com> (sfid-20140921_211552_859892_DE7E610D)
Date: Sun, 21 Sep 2014 22:15:30 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: pull request: iwlwifi-next 2014-09-21
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="N88t5FdhbGibuHMFaPveJsmBwWbLcnHJp"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--N88t5FdhbGibuHMFaPveJsmBwWbLcnHJp
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi John,

Here is another (last?) pull request for 3.18.

I have here a few things that depend on the latest mac80211's changes: RR=
M, TPC, Quiet Period etc...
Eyal keeps improving our rate control and we have a new device ID. This l=
ast patch should probably
have gone to wireless.git, but at that stage, I preferred to send it to -=
next and CC stable.

Let me know if you have issues!

The following changes since commit 6bd2bd27baf12fa0f2e6d611509fc0e1bffb0f=
97:

  Merge tag 'mac80211-next-for-john-2014-09-12' of git://git.kernel.org/p=
ub/scm/linux/kernel/git/jberg/mac80211-next (2014-09-15 14:51:23 -0400)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git =
master

for you to fetch changes up to 908f324b609320a8839211922f8c4946c891d56c:

  iwlwifi: mvm: Refactor and fix max probe len computation (2014-09-21 13=
:25:50 +0300)

----------------------------------------------------------------
Alexander Bondar (1):
      iwlwifi: mvm: Allow schedule scan while connected

Andrei Otcheretianski (3):
      iwlwifi: mvm: Update TX power in TPC reports
      iwlwifi: mvm: Set RRM_ENABLED bit in scan commands
      iwlwifi: mvm: Refactor and fix max probe len computation

Assaf Krauss (1):
      iwlwifi: mvm: Announce Quiet Period support

Avri Altman (1):
      iwlwifi: mvm: prepare for scheduler config command

Emmanuel Grumbach (1):
      iwlwifi: mvm: disable BT Co-running by default

Eyal Shapira (5):
      iwlwifi: mvm: choose an initial tx rate based on rssi conditions
      iwlwifi: mvm: rs: refactor to allow direct rs updating
      iwlwifi: mvm: limit aggregation size in low latency to 6
      iwlwifi: mvm: report all BA notifs to RS
      iwlwifi: mvm: rs: fix logic in case of multiple TIDs

Ido Yariv (1):
      iwlwifi: mvm: support cloned tx skbs

Liad Kaufman (2):
      iwlwifi: pcie: fix HW_REV saving for 8000 series
      iwlwifi: 8000: fix fw name to account for revision

Luciano Coelho (1):
      iwlwifi: mvm: add debugfs entry to read the current temperature

Oren Givon (1):
      iwlwifi: Add missing PCI IDs for the 7260 series

 drivers/net/wireless/iwlwifi/iwl-8000.c        |   2 +-
 drivers/net/wireless/iwlwifi/iwl-drv.c         |  18 +++++++++++
 drivers/net/wireless/iwlwifi/iwl-fw.h          |  17 +++++++++-
 drivers/net/wireless/iwlwifi/mvm/constants.h   |   3 +-
 drivers/net/wireless/iwlwifi/mvm/debugfs.c     |  25 +++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h |   3 ++
 drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h   |   2 ++
 drivers/net/wireless/iwlwifi/mvm/fw-api.h      |  60 +++++++++++++++++++=
+++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c    |  20 ++++++------
 drivers/net/wireless/iwlwifi/mvm/mac80211.c    |  37 +++++++++++++++----=
---
 drivers/net/wireless/iwlwifi/mvm/mvm.h         |  43 +++++++++++++++++++=
+++++++
 drivers/net/wireless/iwlwifi/mvm/ops.c         |   3 +-
 drivers/net/wireless/iwlwifi/mvm/rs.c          | 240 +++++++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
+-------------------------------------------------
 drivers/net/wireless/iwlwifi/mvm/rs.h          |   4 +++
 drivers/net/wireless/iwlwifi/mvm/rx.c          |  41 +++++++++++++++----=
------
 drivers/net/wireless/iwlwifi/mvm/scan.c        |  79 +++++++++++++++++++=
++++++++++++++++++++--------
 drivers/net/wireless/iwlwifi/mvm/sta.c         |  20 ++++++++----
 drivers/net/wireless/iwlwifi/mvm/sta.h         |   2 ++
 drivers/net/wireless/iwlwifi/mvm/tt.c          |   2 +-
 drivers/net/wireless/iwlwifi/mvm/tx.c          |  60 +++++++++++++++++++=
+++++++++--------
 drivers/net/wireless/iwlwifi/mvm/utils.c       |  46 +++++++++++++++++++=
+++++++++
 drivers/net/wireless/iwlwifi/pcie/drv.c        |   4 +++
 drivers/net/wireless/iwlwifi/pcie/trans.c      |   2 +-
 23 files changed, 573 insertions(+), 160 deletions(-)


--N88t5FdhbGibuHMFaPveJsmBwWbLcnHJp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUHyPYAAoJEC0Llv5uNjIBNYAP/j78hLlkJB2CCGbPzFwqAFIM
3ncETTZOxalZ6gePgM5sxVqyWaKgATIjFFo46XUwCloODEJC217EyqWxSXpSnMq2
uI5skk9Gl2ML6XqLAZL8jdULpJcCNCwGpdx57iJ/dfFZfvFWKMXH48h/JjT1zYsl
DJ6RgWWhPbSiuhnFEvr4SVyUGbB+nbmJmUmbTL0vx9IX/65qnjJbCSjDSVZDPjT8
/4lueuizPhygxyXiZFNDVpHLs1gXjBeNFxdQTeSwHCH9X80WnBYPsaWgrEDQGGLZ
c8PNBDsv3fdFglWmzOeG7h3RKjV9WHHtubDfJD7a352q2iaamhDFTjZ+8CSszfSm
2pLxhrVrIk2fUmYcQ3wLUzV+qgOwRQNf/ArNbOH+QnR0d5XXzqTcg2Q28EdodSNC
XGFlvuR3JyOt4lJV7+hpVzmVpbM9CPJH1DTpTDmqZE+IUY85nfLp5ne19RfUStT+
fQwbE3/HNRzyIpKOUARJm6j8s2pX/jozP4zwZGCOvH78OUqDDmtEFEptMGkn6RTb
e/T+Z+2w+VvX1CRQOvBk1p9vHJiljfO2R6/W128n98M/qla258C2Y7uArJ6wHa5u
6R824VHjOLQdt4ST6LxefKFqK+iwk6NAY2devOLM9fFbvox2/hdd2B6wsg6mkTHd
F9wNR9JAVrsuup8uqBis
=wmiv
-----END PGP SIGNATURE-----

--N88t5FdhbGibuHMFaPveJsmBwWbLcnHJp--
