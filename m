Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43859 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869Ab3BRT2s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 14:28:48 -0500
Message-ID: <1361215715.8555.45.camel@jlt4.sipsolutions.net> (sfid-20130218_202853_285271_74FED3FD)
Subject: pull-request: iwlwifi-next 2013-02-18
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 18 Feb 2013 20:28:35 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-0yYgkkgWU1LmdpH1gJA6"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0yYgkkgWU1LmdpH1gJA6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

I hadn't expected to ask you to pull iwlwifi-next again, but I have a
number of fixes most of which I'd also send in after rc1, so here it is.

The first commit is a merge error between mac80211-next and
iwlwifi-next; in addition I have fixes for P2P scanning and MVM driver
MAC (virtual interface) management from Ilan, a CT-kill (critical
temperature) fix from Eytan, and myself fixed three different little but
annoying bugs in the MVM driver.

The only ones I might not send for -rc1 are Emmanuel's debug patch, but
OTOH it should help greatly if there are any issues, and my own time
event debugging patch that I used to find the race condition but we
decided to keep it for the future.

If you don't want to pull this any more, let me know and I'll split the
tree into -fixes and -next later.

Thanks,
Johannes


The following changes since commit 9e97d14b4923da524d202f2e005d5d30b70db9d6=
:

  Merge branch 'for-linville' of git://github.com/kvalo/ath6kl (2013-02-15 =
14:06:32 -0500)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git=
=20

for you to fetch changes up to cfe418287c61f4c4a3ccb94e8a286434d64e0236:

  iwlwifi: dvm: improve (again) the prints in reclaim path (2013-02-18 20:1=
9:25 +0100)

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: dvm: improve (again) the prints in reclaim path

Eytan Lifshitz (1):
      iwlwifi: dvm: fix delayed enter to CT-kill bug

Ilan Peer (3):
      iwlwifi: mvm: Set the scan type according to the vif type
      iwlwifi: mvm: Fix resource allocation for P2P Device
      iwlwifi: mvm: Reserve MAC id 0 for managed interfaces

Johannes Berg (6):
      Merge remote-tracking branch 'wireless-next/master' into iwlwifi-next
      iwlwifi: mvm: fix merge error
      iwlwifi: mvm: program DTIM timings properly
      iwlwifi: mvm: fix GO powersave client manipulation
      iwlwifi: mvm: add debug statement to time event add
      iwlwifi: mvm: fix time event command handling race

 drivers/net/wireless/iwlwifi/dvm/commands.h   |  1 +
 drivers/net/wireless/iwlwifi/dvm/tt.c         |  2 +-
 drivers/net/wireless/iwlwifi/dvm/tx.c         | 51 +++++++++++++++++++----=
----
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c   | 47 +++++++++++++++++++++--=
-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c   | 10 +++---
 drivers/net/wireless/iwlwifi/mvm/rx.c         |  1 +
 drivers/net/wireless/iwlwifi/mvm/scan.c       |  7 +++-
 drivers/net/wireless/iwlwifi/mvm/sta.c        | 14 +++++---
 drivers/net/wireless/iwlwifi/mvm/sta.h        |  6 ++--
 drivers/net/wireless/iwlwifi/mvm/time-event.c | 10 +++++-
 10 files changed, 114 insertions(+), 35 deletions(-)


--=-0yYgkkgWU1LmdpH1gJA6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRIoDjAAoJEDBSmw7B7bqrkJ0P/R9KGPbRARBwUDDLiNFCMpum
DVcnq4+yQBe7SOJNmCBLpXsNWy5aHrYIYc8RnQdBT0s7lezQJ5SFBYUpUL62EgPX
elNKWx9/qFq1ckWCHnl33QsK4m4ocwZ1kMRAKqOsjCFp8fQ/ng+t/uxL6doHPgbN
vjLJboYD+UQBv9Fayh1drN57SD54Hca8GkE60yxcwd+JffQc7ylFIBw/SSDOSNfl
VrKDznvrUhhpPP/nq12KgwrIeIP2kz/NL1p8lUfQTnyonl8jQguBHwWhiuoeopBN
ybET2ANRiwqd2N3u86HGVGm7WMOk/OZEiFpIUkjs5VN1VJVcYqQ8Z5PfJQ6rZtKK
StLlGs7EHruUMJmVJHzOvUtMbpkR/8VM17ymLWkbrgpxmT3QYVNXTe/D3evP9b9s
0U0KbcmjtX9Yc3VgjsuDNUm53tAVCQb6aNzVT5dupxsduZ2SBK2MKJ4ams5UNHh2
zYC7kiVTWXh8z3G+xvuDyZk0Jcmzlsd3LcPCKdX9UAt1AY/weffC4DV+Z9M3c76o
rcD3ocCBoFPPdULbjaiLm8o5IHvP7tlR3SyqgW+BC1RvDYD0mmFkgju7gjojGi/S
sW5bZnEtlc20YLwrZGuiTwCdszwH1KKpi2pGhWEbT6spH9n1Obhu42FTvyslarLS
XuFW0ZPAsi+7+VPJJBus
=+V2y
-----END PGP SIGNATURE-----

--=-0yYgkkgWU1LmdpH1gJA6--

