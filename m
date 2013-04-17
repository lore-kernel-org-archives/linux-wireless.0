Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56956 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966615Ab3DQPNc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 11:13:32 -0400
Message-ID: <1366211598.8217.18.camel@jlt4.sipsolutions.net> (sfid-20130417_171339_254853_31A2D122)
Subject: pull-request: mac80211-next 2013-04-17
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 17 Apr 2013 17:13:18 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-+DtmT3BlYYbvB1psqL2x"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+DtmT3BlYYbvB1psqL2x
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

Still I have more changes for the -next stream :-)

There are a few fixes in here that should probably later go to stable,
and I've marked them as such. Other than that, I have mostly a number of
small random changes, but there's also my CSA work here.

Please pull. Thanks,
johannes



The following changes since commit ddc4db2e3d5393ede7a9222bb3b7522a603a4678=
:

  mac80211: make ieee802_11_parse_elems an inline (2013-04-08 11:08:32 +020=
0)

are available in the git repository at:

  git://x-git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git f=
or-john

for you to fetch changes up to eea85999eca4d7f3528010cd8277392cd56ba713:

  mac80211: optimize minstrel_ewma (2013-04-17 17:08:49 +0200)

----------------------------------------------------------------
Alexander Bondar (1):
      mac80211: remove warning from ieee80211_beacon_loss

Felix Fietkau (2):
      mac80211: fix and optimize MCS mask handling
      mac80211: fix CTS protection handling

Johannes Berg (11):
      mac80211: always advertise STBC/MCSes even if no AP support
      wireless: regulatory: fix channel disabling race condition
      mac80211: use second center_freq segment only in 80+80
      mac80211: unify CSA action frame/beacon processing
      cfg80211: add ieee80211_operating_class_to_band
      mac80211: support extended channel switch
      mac80211: support secondary channel offset in CSA
      mac80211: handle extended channel switch announcement
      mac80211: parse VHT channel switch IEs
      mac80211: handle wide bandwidth channel switch
      mac80211: fix station entry leak/warning while suspending

Karl Beldan (7):
      mac80211: always pick a basic rate to tx RTS/CTS for pre-HT rates
      mac80211: fix rate control tx handler for VHT rates
      mac80211: adjust initial chandefs assignments in ieee80211_register_h=
w
      mac80211: VHT off-by-one NSS
      mac80211_hwsim: handle VHT rates in rx_status
      mac80211: cosmetics for minstrel_debugfs
      mac80211: optimize minstrel_ewma

Marek Puzyniak (2):
      mac80211: clear SSID when stopping AP
      mac80211: provide SSID in IBSS mode

Martin Pitt (1):
      mac80211_hwsim: Register and bind to driver

Simon Wunderlich (1):
      mac80211: fix recalc_radar hwconf sync problem

Thomas Pedersen (3):
      mac80211: unset FC retry bit in mesh fwding path
      mac80211: stringify another plink state
      mac80211: fix ieee80211_queue_stopped()

 drivers/net/wireless/iwlegacy/4965-mac.c    |  32 ++-
 drivers/net/wireless/iwlegacy/4965.c        |   2 +-
 drivers/net/wireless/iwlwifi/dvm/devices.c  |  10 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c |  20 +-
 drivers/net/wireless/iwlwifi/dvm/rxon.c     |   2 +-
 drivers/net/wireless/mac80211_hwsim.c       |  45 +++-
 drivers/net/wireless/ti/wl12xx/cmd.c        |   2 +-
 drivers/net/wireless/ti/wl18xx/cmd.c        |   6 +-
 include/linux/ieee80211.h                   |  43 +++-
 include/net/cfg80211.h                      |  11 +
 include/net/mac80211.h                      |  22 +-
 net/mac80211/cfg.c                          |  14 ++
 net/mac80211/chan.c                         |  43 +++-
 net/mac80211/ibss.c                         |   6 +-
 net/mac80211/ieee80211_i.h                  |  17 +-
 net/mac80211/main.c                         |  23 +-
 net/mac80211/mesh.c                         |   4 +-
 net/mac80211/mesh_hwmp.c                    |   2 +-
 net/mac80211/mesh_plink.c                   |   6 +-
 net/mac80211/mlme.c                         | 333 +++++++++++++++++++-----=
----
 net/mac80211/pm.c                           |   4 +-
 net/mac80211/rate.c                         |   9 +-
 net/mac80211/rc80211_minstrel.c             |   6 +-
 net/mac80211/rc80211_minstrel.h             |   5 +-
 net/mac80211/rc80211_minstrel_debugfs.c     |   4 +-
 net/mac80211/rx.c                           |  21 +-
 net/mac80211/scan.c                         |   2 +-
 net/mac80211/trace.h                        |   8 +-
 net/mac80211/tx.c                           |  60 +++--
 net/mac80211/util.c                         |  54 ++++-
 net/wireless/reg.c                          |   2 +-
 net/wireless/util.c                         |  20 ++
 32 files changed, 602 insertions(+), 236 deletions(-)


--=-+DtmT3BlYYbvB1psqL2x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRbrwOAAoJEDBSmw7B7bqr1mgP/3igAZDukkncHCiwJuT28pfS
uN1CjnCzNL2FhqUA3NMTZEih8VVpJaE8Gk7rtxUTXRX5H3RznnkpyHxtNQSYKaKC
n+ygbekyrqAV7SEhUP7BQkSQ/h5y/0K1BlSsz9nNtxGRGJyY5zvWGuMk2dhnWZEl
iSligyvqF++HcGoIbUxw7TTPPX8AQmyuDtZY7kFMW+4h1SSfC/koEsAYmil38WZJ
2PulmA2lK7vWK9UZn3z8vNBJU++JXeRRfTL6xCzFZBSgqdeHzVePeIOVh5VAFuhS
XNHv5AX5BMSVxi3VqHwq1ztbagkuR9UspS/uwfOtiaibkiCi1w2BcwykxbQCyOaS
9dNpV/Qi/bldR0T4/JD5XIM+IxQrGDWP1ljdEvRMWzpvLgQSiLGlS382o6XDQzYL
MpKp/SG8LHKNtbacugCTHPe+C6t2nu/GoiE3eGRHHm7iTGVeuhFN4tCdY10/RVL2
vMDBPJRKNyu/1WidwFKWRk86WXcXx5Gn23rWRQQ7v6R1z49DyjX/A+SlZxoR07DZ
n2aXl72FcF4BM8PWCl438l/jWhLhiazwEsdxK1YL7Of6elnp2SxBVCIBEfMXuBrL
m78yM9VPCQL024cYzlj2Q1Oaownd9xl4kqx9xDNvlS71y8diM5+idDLRYPDE4Fin
8cWPUQug4O/JM1qjSop5
=86eL
-----END PGP SIGNATURE-----

--=-+DtmT3BlYYbvB1psqL2x--

