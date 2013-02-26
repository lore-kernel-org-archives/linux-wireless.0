Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47724 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759860Ab3BZVGH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2013 16:06:07 -0500
Message-ID: <1361912748.8440.25.camel@jlt4.sipsolutions.net> (sfid-20130226_220612_554361_DEC8F948)
Subject: pull-request: mac80211 2013-02-26
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 26 Feb 2013 22:05:48 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-g85dSKQwCTmsZyAi2Ob4"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-g85dSKQwCTmsZyAi2Ob4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Here are my first few fixes, before it's even rc1 time :-)

Seth fixes a stupid bug I introduced into one of his earlier patches,
Chun-Yeow fixes mesh forwarding and Felix fixes monitor mode. I myself
fixed a small locking issue and, the biggest change here, removed some
nl80211 information with which sometimes the per wiphy information was
getting too large for the typical 4k-minus-overhead. In my -next tree I
have a patch to allow splitting that and add back the information
removed now.

Let me know if there's any issue.

Thanks,
johannes


The following changes since commit dc4a787c8f52f9d6e46156953f8014a3353bcbc7=
:

  brcmfmac: fix missing unlock on error in brcmf_notify_vif_event() (2013-0=
2-22 14:50:47 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to cb601ffa326bc5c74a6ecd8e72ae9631e5f12f75:

  mac80211: fix monitor mode channel reporting (2013-02-26 21:53:38 +0100)

----------------------------------------------------------------
Chun-Yeow Yeoh (1):
      mac80211: fix the problem of forwarding from DS to DS in Mesh

Felix Fietkau (2):
      mac80211: fix idle handling in monitor mode
      mac80211: fix monitor mode channel reporting

Johannes Berg (3):
      mac80211: fix tim_lock locking
      nl80211: remove radar information
      nl80211: remove TCP WoWLAN information

Seth Forshee (1):
      mac80211: Ensure off-channel frames don't get queued

 net/mac80211/cfg.c     | 12 ++++++--
 net/mac80211/iface.c   |  2 +-
 net/mac80211/tx.c      | 77 ++++++++++++++++++++++++++++++++--------------=
----
 net/wireless/nl80211.c | 61 ++-------------------------------------
 4 files changed, 62 insertions(+), 90 deletions(-)


--=-g85dSKQwCTmsZyAi2Ob4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRLSOsAAoJEDBSmw7B7bqrC1MP/AlwYPF5RxjMF97DJ4lmSPyq
Qa9kmXtLwhp7ExJwxRhTIy3yZL2NDqiTMz/io+BnSx7Fe9k3kjWqrEImRcyNDNmt
D/Ig5wU6ePgImE+cJAdHqMM9NPl7j3ADE/9gF7/qXAK7DvLzby6n6lLs/xo6Ysb/
TaJVcsoL6oFFNEj3WWNp8gDTTDM82nMSF96m5YyfdXbC7Hl03cPvwiMa1pFMvZhZ
v2x5NxOQyPV4JLphlCyiI5Yq6Sve3mPz3SUw7hqFxH735sJcDnXKuGW9I+y+TP//
JP2AlWXrEZcjayfesl2RikchQ0nq2/iUEVdTsxvuCRlNhemJYLyh/RcIsOqKKWVf
i2NWD1qzJjPLi63WBeul8/tYpsjXgCwAhlS508BH8d4db59EsOKHY2uXAAZ2GAh9
+WGoGhUBoLibX4F0nwDE+g2baubPZZte4sNosYo33iAutME7iq4z88g1RZsKWPcM
EHT/VQeROYv3EZ1ox5HDQO2AnL/4Mdvt7iy8jToDWUFHnqmdjkz+dDyNd6sjjFd0
sv8sq87DE/4U+5bHs7TNNwaLLL50IXAgg7z97dddMR5NrU+PKYLRt85ncORNKfzC
Iw4KDFUF2x61CUwLQv/DTkUNN1t9/emlvn1h3/17Afn/R1bWvn0LatZbmMdpLTXT
7MMOx1lgWfBOI0YW5MEw
=O7Rr
-----END PGP SIGNATURE-----

--=-g85dSKQwCTmsZyAi2Ob4--

