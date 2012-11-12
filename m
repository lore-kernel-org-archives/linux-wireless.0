Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37279 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985Ab2KLP1K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 10:27:10 -0500
Message-ID: <1352734061.9445.3.camel@jlt4.sipsolutions.net> (sfid-20121112_162714_615989_C03E9A17)
Subject: Re: pull-request: mac80211 2012-11-12
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 12 Nov 2012 16:27:41 +0100
In-Reply-To: <1352710901.9525.3.camel@jlt4.sipsolutions.net> (sfid-20121112_100114_809576_636E5E6D)
References: <1352490162.9238.23.camel@jlt4.sipsolutions.net>
	 (sfid-20121109_204215_951530_427D6D95) <1352534041.9759.0.camel@jlt4.sipsolutions.net>
	 (sfid-20121110_085329_077961_291B6567) <1352710901.9525.3.camel@jlt4.sipsolutions.net>
	 (sfid-20121112_100114_809576_636E5E6D)
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-klzwnzzqWodR55Pj7PIg"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-klzwnzzqWodR55Pj7PIg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-11-12 at 10:01 +0100, Johannes Berg wrote:
> Another day, updated pull request. I'm going to let you merge this one,
> even if somebody sends me new fixes right now :)
>=20
> I have a locking fix for some SKB queues, a variable initialization to
> avoid crashes in a certain failure case, another free_txskb fix from
> Felix and another fix from him to avoid calling a stopped driver, a fix
> for a (very unlikely) memory leak and a fix to not send null data
> packets when resuming while not associated.

I've amended the branch again, with the regulatory fix. Sorry about
that!

johannes

The following changes since commit 6dbda2d00d466225f9db1dc695ff852443f28832=
:

  mac80211: make sure data is accessible in EAPOL check (2012-10-26 22:52:4=
2 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to 43c771a1963ab461a2f194e3c97fded1d5fe262f:

  wireless: allow 40 MHz on world roaming channels 12/13 (2012-11-12 16:26:=
06 +0100)

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

Johannes Berg (3):
      mac80211: fix memory leak in device registration error path
      mac80211: don't send null data packet when not associated
      wireless: allow 40 MHz on world roaming channels 12/13

 net/mac80211/cfg.c         |  3 +++
 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/main.c        |  6 ++++--
 net/mac80211/scan.c        |  2 +-
 net/mac80211/sta_info.c    | 11 ++++++++---
 net/mac80211/status.c      |  9 +++++++++
 net/mac80211/tx.c          |  9 ++++++---
 net/mac80211/util.c        |  2 ++
 net/wireless/reg.c         |  5 ++---
 9 files changed, 37 insertions(+), 12 deletions(-)


--=-klzwnzzqWodR55Pj7PIg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJQoRVtAAoJEDBSmw7B7bqrxG8QAMQTw1yCEJzP3/AjgIsnrGQw
90zifQrR0yWsJC6ecTcdznmlC7yOJdNOKy1Wsne9I6ksfvLNThx6ZwYFHMxJnMYZ
kIEmTe+B6paB02xWK8jiurp01VPgOiGvuOwPDBQ/PMPTfoNrUDwJJZLvHq/534+C
LQrs5RV7YezKM7e38WI5HCmwJ8tD2YkoYy68JEo+6XHwOBkL2r/VwCgaMdXwgbHr
xnlyhNMwEo37W0ajUjWl9p90xC/NidvkjVIw21dNqtw8O3NVVn1k2tCEX3oBsMog
PiOpm8RTTjfiE538OpPZ7Jswv6TW5QM7HG0ui87qG3kbdYSKnMIX4L+cHQOEABCJ
op0fZOL0LKfbVhZPHCRXGF2XgqvMNFXRKshm5jR+klcxWEqZixWM3eo69cVK53Tx
SDO0W8jP0mI6tkPpskygnUYGbDgPpcM+hqqipAb+c8xcuNSl8PI+SKz9ODMJs860
bAJVib2ERM/Wu+RB4MYWtVB/wf/k63EYDQJJCkdwVCmJhIBFDXHdLQdYeYog/Hyj
MU3Cl60tY3LE4yCbJcZ9XfqLkEcUpMmjrqpeAqZ5xYhLH7kPL15PCs7e7UvKJ1f+
mHzhT60bCNEpDugRmQefa76HEKEO0pkncc+s3CNu/Q53v08+bRq9an6NYEvFjzsn
atPGYzx8F2Cqso8TBqIb
=5U/0
-----END PGP SIGNATURE-----

--=-klzwnzzqWodR55Pj7PIg--

