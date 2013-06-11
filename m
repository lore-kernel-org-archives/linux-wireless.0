Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38649 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab3FKSjy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 14:39:54 -0400
Message-ID: <1370975989.8356.66.camel@jlt4.sipsolutions.net> (sfid-20130611_203958_084428_3863B2A6)
Subject: pull-request: mac80211-next 2013-06-11
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 11 Jun 2013 20:39:49 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-OQrXshYBQejTcRubE7Qp"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OQrXshYBQejTcRubE7Qp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

And another one (last one for now!) for mac80211-next. This one's a
little bigger.

I have a number of mesh fixes and improvements from Colleen, Jacob,
Ashok and Thomas, powersave fixes in mac80211 from Alex, improved
management-TX from Antonio, and a few various things, including locking
fixes, from others and myself. Overall though, nothing really stands
out.

Thanks,
johannes


The following changes since commit 99e94940697adec4f84758adb2db71f4a82c7ba5=
:

  brcmsmac: Reduce log spam in heavy tx, make err print in debug (2013-06-0=
3 15:55:48 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to 940d0ac9dbe3fb9d4806e96f006286c2e476deed:

  cfg80211: fix rtnl leak in wiphy dump error cases (2013-06-11 16:52:39 +0=
200)

----------------------------------------------------------------
Alexander Bondar (2):
      mac80211: fix powersave bug and clean up ieee80211_rx_bss_info
      mac80211: Use suitable semantics for beacon availability indication

Antonio Quartulli (4):
      mac80211: make mgmt_tx accept a NULL channel
      brcm80211: make mgmt_tx in brcmfmac accept a NULL channel
      ath6kl: make mgmt_tx accept a NULL channel
      nl80211: allow sending CMD_FRAME without specifying any frequency

Ashok Nagarajan (1):
      {nl,mac,cfg}80211: Allow user to configure basic rates for mesh

Colleen Twitty (2):
      {nl,cfg}80211: make peer link expiration time configurable
      mac80211: expire mesh peers based on mesh configuration

Felix Fietkau (2):
      mac80211: add a tx control flag to indicate PS-Poll/uAPSD response
      nl80211: add kernel-doc for NL80211_FEATURE_ACTIVE_MONITOR

Jacob Minshall (1):
      mac80211: set mesh formation field properly

Johannes Berg (10):
      cfg80211: take WoWLAN support information out of wiphy struct
      nl80211: remove bogus genlmsg_end() error checking
      Merge remote-tracking branch 'wireless-next/master' into HEAD
      cfg80211/mac80211: clean up cfg80211 SME APIs
      cfg80211: separate internal SME implementation
      regulatory: use proper enum return value
      cfg80211: fix potential deadlock regression
      cfg80211: make wiphy index start at 0 again
      wireless: fix kernel-doc
      cfg80211: fix rtnl leak in wiphy dump error cases

Jouni Malinen (1):
      cfg80211: fix VHT TDLS peer AID verification

Pontus Fuchs (1):
      mac80211: set IEEE80211_TX_CTL_REQ_TX_STATUS on nullframes

Thomas Pedersen (2):
      mac80211: don't check local mesh TTL on TX
      mac80211: fix mesh deadlock

 Documentation/DocBook/80211.tmpl                   |  11 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |  51 +-
 drivers/net/wireless/ath/ath9k/init.c              |  18 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  15 +-
 drivers/net/wireless/cw1200/main.c                 |  13 +-
 drivers/net/wireless/iwlwifi/dvm/dev.h             |   3 +
 drivers/net/wireless/iwlwifi/dvm/mac80211.c        |  17 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c        |  28 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h             |   1 +
 drivers/net/wireless/mwifiex/cfg80211.c            |  16 +-
 drivers/net/wireless/ti/wlcore/main.c              |  19 +-
 include/linux/ieee80211.h                          |   1 +
 include/net/cfg80211.h                             | 115 ++---
 include/net/mac80211.h                             |  11 +-
 include/uapi/linux/nl80211.h                       |   9 +
 net/mac80211/cfg.c                                 |  20 +-
 net/mac80211/ieee80211_i.h                         |   3 +-
 net/mac80211/main.c                                |   3 +-
 net/mac80211/mesh.c                                |  38 +-
 net/mac80211/mesh.h                                |   5 +-
 net/mac80211/mesh_plink.c                          |   7 +-
 net/mac80211/mlme.c                                |  98 ++--
 net/mac80211/rx.c                                  |  26 +-
 net/mac80211/sta_info.c                            |   4 +-
 net/mac80211/sta_info.h                            |   3 +
 net/mac80211/tx.c                                  |   6 -
 net/mac80211/util.c                                |   5 +-
 net/wireless/core.c                                |  47 +-
 net/wireless/core.h                                |  30 +-
 net/wireless/ibss.c                                |   6 -
 net/wireless/mesh.c                                |  12 +
 net/wireless/mlme.c                                | 241 ++++-----
 net/wireless/nl80211.c                             | 192 ++++----
 net/wireless/reg.c                                 |   2 +-
 net/wireless/sme.c                                 | 542 ++++++++++-------=
----
 net/wireless/trace.h                               |  46 +-
 net/wireless/wext-sme.c                            |   8 +-
 37 files changed, 834 insertions(+), 838 deletions(-)


--=-OQrXshYBQejTcRubE7Qp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRt271AAoJEDBSmw7B7bqrrCAP/Rc0A9eiYNT4ZhdomUKa2m9S
HbGuPEK/q/XVJrgSD4VXEYHG7GMbcGwSv+8bP/q+OmgldtQoqEGiMl6yJj+MQPMb
nzN24J/7TCHGwGpqIS+zKvPjDVwhAlB2SSPVPvzqdIjYJmE5GZSdpbIXi+PtRhX7
enU0uzDYYlyyU2cWDGW5KtBmPBwfr190MB2FGn+zbWOww6R9DYXocpufU/z3JYwh
GPydpLuPNsbcF/ol9m0ulGEJUDSyW18DDcj0HSW3tiOjpcFreaKCKjREZcP930cs
yTmelig2g4VRyCCoXCuCh/HT5bRWYP4MVspjYAqcRETzVdJU/JZ/qvU1ZXabxFji
jW8aQYlfUvHFrtAvu+E8UDzAtNa8JBZDOOOEbLsShkG3VyW4j51gQnUR7EVAbBmL
3c4iPDNKfYVhC5au7CJMxa0LCBvADkNQg/UV9qW9ia+Pmvnn/otygVlNPdQ5CYg/
vhizo/j5iedyyr+JDM7CPOTHcfxn/HLoC7w8CJ/Ye/s5XRE5jkiyQ2lvHDXWmlNC
0VywLtjZFAzZtXmAxeo/J4SDFwSuxiNCFt3Zdf5kHvktyIkWnHBTXSM930Ze1dUN
5OIZFX0fxjySDvboPmAi7zFe0blLaE7jCUwUnu+0e0VB5NMadHUsMqNzbpBTJMOR
NR0DRzkudOlc+sDJ+Sge
=RSns
-----END PGP SIGNATURE-----

--=-OQrXshYBQejTcRubE7Qp--

