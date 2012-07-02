Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33879 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab2GBNUX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2012 09:20:23 -0400
Message-ID: <1341235218.19642.13.camel@jlt3.sipsolutions.net> (sfid-20120702_152027_183808_48EA0F67)
Subject: pull-request: mac80211-next 2012-07-02
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 02 Jul 2012 15:20:18 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-SpwC870I6uIvlKxfQgw6"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SpwC870I6uIvlKxfQgw6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

Here's another pull request for mac80211-next. This time, on top of
Michal's cfg80211 multi-channel changes and a few cleanups we have the
first few VHT (11ac) and 60GHz (11ad) patches.

I merged wireless-next.git once to get a merge from you from
wireless.git to avoid merge issues with Michal's patches.

johannes


The following changes since commit bf52592fe4901f486a5266fd73e4ee80205b18b4=
:

  ath9k: Fix compilation breakage (2012-06-27 15:23:19 -0400)

are available in the git repository at:

  git://git.sipsolutions.net/mac80211-next.git for-john

for you to fetch changes up to ba0afa2f22e1e3f332e45460f99328025d44564e:

  mac80211: include VHT capability IE in probe requests (2012-07-02 15:13:0=
9 +0200)

----------------------------------------------------------------
Eliad Peller (3):
      mac80211: flush queues before deauth/disassoc
      mac80211: don't require associated->beacon_ies for ps
      mac80211: allow calling ieee80211_ap_probereq_get() during auth/assoc

Johannes Berg (4):
      mac80211: make __ieee80211_recalc_idle static
      cfg80211: don't allow WoWLAN support without CONFIG_PM
      mac80211: don't expose ieee80211_add_srates_ie()
      Merge remote-tracking branch 'wireless-next/master' into mac80211-nex=
t

Mahesh Palivela (3):
      wireless: add VHT (802.11ac) definitions
      cfg80211: allow advertising VHT capabilities
      mac80211: include VHT capability IE in probe requests

Michal Kazior (13):
      cfg80211: introduce cfg80211_stop_ap
      cfg80211: .stop_ap when interface is going down
      cfg80211: add channel tracking for AP and mesh
      cfg80211: track ibss fixed channel
      cfg80211: introduce cfg80211_get_chan_state
      cfg80211: track monitor interfaces count
      mac80211: refactor virtual monitor code
      cfg80211: refuse to .set_monitor_channel when non-monitors are presen=
t
      cfg80211: track monitor channel
      cfg80211: set initial monitor channel
      cfg80211/mac80211: remove .get_channel
      cfg80211: add channel checking for iface combinations
      cfg80211: respect iface combinations when starting operation

Vladimir Kondratiev (3):
      cfg80211: add 802.11ad (60gHz band) support
      wireless: regulatory for 60g
      wireless: 60g protocol constants

 drivers/net/wireless/ath/ath6kl/cfg80211.c |    2 +
 drivers/net/wireless/iwlegacy/3945-rs.c    |    2 +-
 drivers/net/wireless/ti/wlcore/main.c      |    2 +
 include/linux/ieee80211.h                  |  160 ++++++++++++++++-
 include/linux/nl80211.h                    |    8 +
 include/net/cfg80211.h                     |   36 +++-
 include/net/mac80211.h                     |    6 -
 net/mac80211/cfg.c                         |   24 +--
 net/mac80211/ieee80211_i.h                 |   11 +-
 net/mac80211/iface.c                       |  258 +++++++++++++-----------=
----
 net/mac80211/main.c                        |   15 +-
 net/mac80211/mesh_plink.c                  |    4 +-
 net/mac80211/mlme.c                        |   20 ++-
 net/mac80211/tx.c                          |    6 +-
 net/mac80211/util.c                        |   35 +++-
 net/wireless/Makefile                      |    2 +-
 net/wireless/ap.c                          |   46 +++++
 net/wireless/chan.c                        |   62 ++++++-
 net/wireless/core.c                        |   88 +++++++++-
 net/wireless/core.h                        |   62 ++++++-
 net/wireless/ibss.c                        |   11 ++
 net/wireless/mesh.c                        |   30 +++-
 net/wireless/mlme.c                        |   17 ++
 net/wireless/nl80211.c                     |   56 +++---
 net/wireless/reg.c                         |    5 +-
 net/wireless/util.c                        |  105 +++++++++--
 net/wireless/wext-compat.c                 |    9 +-
 27 files changed, 839 insertions(+), 243 deletions(-)
 create mode 100644 net/wireless/ap.c


--=-SpwC870I6uIvlKxfQgw6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJP8aASAAoJEDBSmw7B7bqratUQAMDDvBbEx8nA1YPNyHzYgkx1
/ktu3fJY7zZ55pdOx7sDzo1AIrw/DjfwTc88swvOAwKjoKVkWKLMQCETQ+48mmqx
XeckfFF1P4LK+FV38tXcIcbPWwAIUzZZ4ay7XzWpBsSKUL/4Kh0V23EQVyKxZ50E
v8nSXEOdJPDkY1Nw6SJhzCyGTTT7zuiCLx0OJ4bSW5A2rnDUYUtxnw1dT2g2TKGx
PfzXoADO9HDQR2AVvNdgtAyeCwid8/cJP9OadI1SxVDHY1KEQe+VZFuB5SfHrgFq
/V6otT9T7bsxYE+vUUbDHmSZ6EfEwY/CtrT4OHE/I8j2xiVJ/o1KeFo+XA4Lphty
QX8pMKRwAwl2YpN6HtAm33LUbyUuGycunaKB0uuZD9HhHreTDnSbS3MxjRhkCiHh
XFjDJU9ycl9Lq93RE+S1LQfWD5WrEx4Vi3yXIln/Z++kjAvMuKLZXoNzkKr50zgl
D021H27WjeDTVuexl/aoKGxWZqlUobPJCIORIACe2W3gyjMkdh6ygnnZ1IytwZEy
a7IlXFHG7IOStUSlqnJuXDNnF7jTpU5A8hJiKhlsNTf2HvU9lHoBdaflXy9Gkc6p
4RTESymCrxojQ9Cbd3fhsubABo/vA6EuQXzAi+2blc07/7526ekOgwcnk9aw6gu5
MeQLA86xol3CYLyxHkxh
=gpGv
-----END PGP SIGNATURE-----

--=-SpwC870I6uIvlKxfQgw6--

