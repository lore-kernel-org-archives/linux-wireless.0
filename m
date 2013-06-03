Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:53637 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177Ab3FCOva (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 10:51:30 -0400
Message-ID: <1370271087.8227.8.camel@jlt4.sipsolutions.net> (sfid-20130603_165133_399563_6E5228AB)
Subject: pull-request: mac80211-next 2013-06-03
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 03 Jun 2013 16:51:27 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-cMc0Moay6lTVv0NAowoA"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cMc0Moay6lTVv0NAowoA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Here's another small pull request for mac80211-next, I wanted to get a
few fixes out. I have more stuff pending but not sure I can get that
reviewed right away and don't want anyone waiting for the warning fix.

I have two reverts for patches I accidentally merged in via a tree I
shouldn't have merged and a the locking fix for the locking rework I
did. On top of that, Felix's active monitor implementation, a patch to
always send multicast on the CAB queue to avoid races and a small
cleanup.

johannes


The following changes since commit 6abb9cb99f33b20c2f32f18a3ae9cc7543e46edb=
:

  cfg80211: make WoWLAN configuration available to drivers (2013-05-27 15:1=
0:58 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to ed405be5cb5e8e494e8dcd83b6eb1add34dc752a:

  mac80211: fix sdata locking around __ieee80211_request_smps (2013-06-03 1=
3:51:59 +0200)

----------------------------------------------------------------
Felix Fietkau (2):
      cfg80211: support an active monitor interface flag
      mac80211: support active monitor interfaces

Johannes Berg (5):
      cfg80211: remove cleanup_work kernel-doc
      mac80211: always send multicast on CAB queue
      Revert "iwlwifi: mvm: remove P2P_DEVICE support"
      Revert "mac80211_hwsim: remove P2P_DEVICE support"
      mac80211: fix sdata locking around __ieee80211_request_smps

 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 14 +++++++++++++-
 drivers/net/wireless/mac80211_hwsim.c       |  4 +++-
 include/net/cfg80211.h                      |  3 ++-
 include/uapi/linux/nl80211.h                |  4 ++++
 net/mac80211/cfg.c                          | 13 +++++++++----
 net/mac80211/driver-ops.h                   |  3 ++-
 net/mac80211/iface.c                        | 29 +++++++++++++++++++++++--=
----
 net/mac80211/tx.c                           |  5 +++--
 net/mac80211/util.c                         |  6 ++++++
 net/wireless/nl80211.c                      | 10 ++++++++++
 10 files changed, 75 insertions(+), 16 deletions(-)


--=-cMc0Moay6lTVv0NAowoA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRrK1vAAoJEDBSmw7B7bqrGTUQANLth2AjdRMqulu5IWnIit/6
PbpmSQpK4MEWyc0WXvEn0PFVk3V8hDxUBl++BWjIHd4tR2rDcWjbWYWI3vrSy3gN
soho+nC7JMDzJDRxEuBFDzNn+IcPvU8BM8W78XLlWPBPtxDDzxPZ425Q6w9x2VeN
U62Qpw5fxvLhEgPmZw66i2Z3BNh0U8mxZ89Bcm5EMHJ4oddgbyJM09ermY0oUkid
1dkPelEqM4gERJHU3woaOXfMTK+DsqUMojGmUebqrwd5K3j1aZkW5WjVjmAeHwbr
6n38cMRKYzNJg3XYPe4MYUhcjwkjsRGGzpf7ovLz2NrgMPCHVpm64txMNaF/bnLU
5tMRfL+BtthJXB+PamihWrE8BBPpAu0CrPD4M9EsFt0j/iWGWXUJ9p37yX5HYSxB
bYd6ja9/LQ64nrp9bTdvBhgcnr+Sj4O5OKs53Iam/xeNgbRqPUktnwyycliqHAfc
pNsl/6DD/5YvmgegBHxRLO097dWCskWwR+J1XGlA8O3Hp/nqyBBRAsZOQXyZPd6r
4qh0ykXOB4qXAcgF2Q2gBK7YmAPInXlRSa1FA5P7wqFsQDqkikzk88jH06muFYqb
dX34AtvPBQKVv+QtC2gRCMr+bCuMzLG4qSdRAMxegTUJLMOWMiKL1jJis7Tcmvd2
lxzW+pDCk8zTFfqUCblW
=izRG
-----END PGP SIGNATURE-----

--=-cMc0Moay6lTVv0NAowoA--

