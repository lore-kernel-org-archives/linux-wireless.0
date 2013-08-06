Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54470 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400Ab3HFI4i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 04:56:38 -0400
Message-ID: <1375779392.8219.9.camel@jlt4.sipsolutions.net> (sfid-20130806_105643_842575_9CB65D5B)
Subject: pull-request: mac80211-next 2013-08-06
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 06 Aug 2013 10:56:32 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-U37XtXKJdjldEWKBfA88"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-U37XtXKJdjldEWKBfA88
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

And one more for mac80211-next (and I have nothing for mac80211 today).

Here I have an IBSS improvement, interworking (11u) definitions, a
change to make the LED blinking nicer, more VHT (11ac) definitions, VHT
radiotap TX status, channel switch support in cfg80211 and mac80211 as
well as a small new debugfs file showing driver-buffered data for
sleeping clients.

Let me know if there's any problem.

Thanks,
johannes

The following changes since commit c82b5a74cc739385db6e4275fe504a0e9469bf01=
:

  mac80211: make active monitor injection work w/ HW queue (2013-07-16 09:5=
8:19 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to 73da7d5bab79ad7e16ff44d67c3fe8b9c0b33e5b:

  mac80211: add channel switch command and beacon callbacks (2013-08-01 18:=
30:33 +0200)

----------------------------------------------------------------
Antonio Quartulli (1):
      mac80211: ibss - remove not authorized station earlier

Avinash Patil (1):
      ieee80211: add definition for interworking support

Fabio Baltieri (1):
      mac80211: use oneshot blink API for LED triggers

Fred Zhou (1):
      ieee80211: add definition for 802.11ac information elements

Johannes Berg (1):
      mac80211: add debugfs for driver-buffered TID bitmap

Karl Beldan (1):
      mac80211: report some VHT radiotap infos for tx status

Simon Wunderlich (2):
      nl80211/cfg80211: add channel switch command
      mac80211: add channel switch command and beacon callbacks

 include/linux/ieee80211.h    |   9 +++
 include/net/cfg80211.h       |  33 ++++++++
 include/net/mac80211.h       |  37 +++++++++
 include/uapi/linux/nl80211.h |  30 +++++++
 net/mac80211/cfg.c           | 187 +++++++++++++++++++++++++++++++++++++++=
+++-
 net/mac80211/chan.c          |  58 ++++++++++++++
 net/mac80211/debugfs_sta.c   |   9 +++
 net/mac80211/driver-ops.h    |  13 +++
 net/mac80211/ibss.c          |  30 ++++++-
 net/mac80211/ieee80211_i.h   |  18 ++++-
 net/mac80211/iface.c         |   9 +++
 net/mac80211/led.c           |  19 ++---
 net/mac80211/led.h           |   4 +-
 net/mac80211/status.c        |  78 ++++++++++++++----
 net/mac80211/trace.h         |  26 ++++++
 net/mac80211/tx.c            |  79 +++++++++++++++++-
 net/wireless/nl80211.c       | 122 +++++++++++++++++++++++++++-
 net/wireless/rdev-ops.h      |  12 +++
 net/wireless/trace.h         |  33 ++++++++
 19 files changed, 772 insertions(+), 34 deletions(-)


--=-U37XtXKJdjldEWKBfA88
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJSALpAAAoJEDBSmw7B7bqrp8IP/1SA198OkBlRxhyshYvkZHUw
H2QhRKwhfFznkTZpgCk2EKt+lXElkQRHLJKUVP5kzBC7rKHXsdgG7MlcHrYBMMBd
T7l8AeEr/kgTCu5VxjYQAzCKIC7sgI/g4N+ih1USwxKw+93yiyJyKttvnkHWUI8y
XT5CpNfsRvBEg4FyvR4qivDf1te5pZ3GsznUlhegnfcvogiQDTw2d12yXCwsZu4o
8q1pWHq7tCI6TK0xCoVs0W/xKtj54iqHU1nHZ1rgnfkOmdBAmO/tuAeeMjBy8ZUB
CdubSHryi+Yym6C9ayFErGcPbHmD2+qc/CMH2MyA3DEAWcrVf/Rw2TCJSQ3mmaae
gRpKvfRpLaFwruyvXUYbG2gde9ZAX29SZwiV1D/5cIHgf2P20OvsBgL3FuPELf7n
qfBLAbU4PliMR88xkP/Sk5n1OdvWVrrm7r48fCZ7e3VNkxaDKXs35d3+5kJ2ETrg
XGuU0eKCST6HY4X3sHKsyc3F5wfNhHplfRJFTuu1F+WO+HQD8aBhmqNWJGzNs4Ef
Bbbwae8+5pjtxxQ+C6uB8B5wBv1lHEbNs/LQc17RIK7IS2kg7mELH054vUefkWGL
C5XGtPvbTvn6Z+wWArKEvUA42k/uY7NsZxy9WjD8oym0fHZET5Fso1efBOEd+BZY
zbRziphsc7G0f3udRH5A
=tCwq
-----END PGP SIGNATURE-----

--=-U37XtXKJdjldEWKBfA88--

