Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36099 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab2KLJBK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 04:01:10 -0500
Message-ID: <1352710901.9525.3.camel@jlt4.sipsolutions.net> (sfid-20121112_100114_809576_636E5E6D)
Subject: pull-request: mac80211 2012-11-12
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 12 Nov 2012 10:01:41 +0100
In-Reply-To: <1352534041.9759.0.camel@jlt4.sipsolutions.net> (sfid-20121110_085329_077961_291B6567)
References: <1352490162.9238.23.camel@jlt4.sipsolutions.net>
	 (sfid-20121109_204215_951530_427D6D95) <1352534041.9759.0.camel@jlt4.sipsolutions.net>
	 (sfid-20121110_085329_077961_291B6567)
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-5Asib16h2EQ521OTd9oG"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5Asib16h2EQ521OTd9oG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Another day, updated pull request. I'm going to let you merge this one,
even if somebody sends me new fixes right now :)

I have a locking fix for some SKB queues, a variable initialization to
avoid crashes in a certain failure case, another free_txskb fix from
Felix and another fix from him to avoid calling a stopped driver, a fix
for a (very unlikely) memory leak and a fix to not send null data
packets when resuming while not associated.

Please pull, the entire pull request is below.

johannes


The following changes since commit 6dbda2d00d466225f9db1dc695ff852443f28832=
:

  mac80211: make sure data is accessible in EAPOL check (2012-10-26 22:52:4=
2 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to 1f98ab7fef48a2968f37f422c256c9fbd978c3f0:

  mac80211: call skb_dequeue/ieee80211_free_txskb instead of __skb_queue_pu=
rge (2012-11-10 21:26:28 +0100)

----------------------------------------------------------------
Arik Nemtsov (1):
      mac80211: sync acccess to tx_filtered/ps_tx_buf queues

David Spinadel (1):
      mac80211: init sched_scan_ies

Felix Fietkau (2):
      mac80211: do not call ieee80211_configure_filter if no interfaces are=
 up
      mac80211: call skb_dequeue/ieee80211_free_txskb instead of __skb_queu=
e_purge

Johannes Berg (2):
      mac80211: fix memory leak in device registration error path
      mac80211: don't send null data packet when not associated

 net/mac80211/cfg.c         |  3 +++
 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/main.c        |  6 ++++--
 net/mac80211/scan.c        |  2 +-
 net/mac80211/sta_info.c    | 11 ++++++++---
 net/mac80211/status.c      |  9 +++++++++
 net/mac80211/tx.c          |  9 ++++++---
 net/mac80211/util.c        |  2 ++
 8 files changed, 35 insertions(+), 9 deletions(-)


--=-5Asib16h2EQ521OTd9oG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJQoLr1AAoJEDBSmw7B7bqrtYIQAJ+pWRL7tWkfvQdA5AxkSIHg
xMBzMyK0C9GxFOM9meJn15OlftNtnzYJSTywqtR194+WTenwYUeefmCe0nJsK0DJ
J5ChlmGygKJAMqxwPnI71Y3wGjsMxRlPHMXzsIR3mfC4MCQ1uOTyVK/q+V+Vm8kI
ZhfqJV+fMTdESW/Rkn2KJ+6pRMBf/KFQh/pdYRxQwR+PGAOAD245/Wt+ZuoCG4GJ
QBQLe00bbnWERyuYOZyeSXpLzRUsDu963uGJvQ1GIlT4suwIUuGAPpnQGF5a4zke
WPOr8vFs1U8FYqJ8l1EScE0cJpL1avfTzJDDIZLT+Uhj0TpjiNrubKyF1+b83v4r
I9WfxjbNBqLe4Ylbp9VFii2pb3fNg0yVfEAXg5Y+cUN0RBIUrnfz1XnaJZMvLWfL
Y8onxn/d7h9EP1WS8+G4lYI3AdJIiTiK9mRTmN2s/t/F/Vzgk3wEwTRiGnrXDwPa
Ads9t6fLm+aU15hDk9lYCttT3GqJb07mPt5PeMq9groVhMYRAe38wR8mpUIyeRMZ
P2UHhrIVEAaYCON+1oBASRlySEehtm5begbByJhpUJBTFnuM/eHlrp3mOJN3mO5P
Rqb9LSnemJvX9vHQ1UfzbO+RnlA25+8tHnC41+DKuzIaN2q2mwyCHCvPuGXapHx5
goJpF6FBUfYXL/GMcJuy
=+gJ3
-----END PGP SIGNATURE-----

--=-5Asib16h2EQ521OTd9oG--

