Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43310 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526Ab3C1P3l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Mar 2013 11:29:41 -0400
Message-ID: <1364484573.10397.4.camel@jlt4.sipsolutions.net> (sfid-20130328_162945_299070_B0DB5C45)
Subject: pull-request: mac80211 2013-03-28
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 28 Mar 2013 16:29:33 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-RJMGWY2HAtpcEin+EJXg"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RJMGWY2HAtpcEin+EJXg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Before I disappear for Easter vacation, I decided to send you two more
mac80211 fixes.

I had changed the idle handling to simplify it, but broken the
sequencing of commands, at least for ath9k-htc, one patch restores the
sequence. The other patch fixes a crash Jouni found while stress-testing
the remain-on-channel code, when an item is deleted the work struct can
run twice and crash the second time.

Please pull. Thanks,
johannes


The following changes since commit 370bd005937c0e00f9104a602f9fe1dd6b21b54b=
:

  mac80211: Don't restart sta-timer if not associated. (2013-03-24 11:15:59=
 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to 382a103b2b528a3085cde4ac56fc69d92a828b72:

  mac80211: fix idle handling sequence (2013-03-25 16:50:18 +0100)

----------------------------------------------------------------
Johannes Berg (2):
      mac80211: fix remain-on-channel cancel crash
      mac80211: fix idle handling sequence

 net/mac80211/cfg.c         |  6 ++++--
 net/mac80211/chan.c        | 17 ++++++++++++++---
 net/mac80211/ieee80211_i.h |  4 +++-
 net/mac80211/iface.c       |  2 +-
 net/mac80211/offchannel.c  | 23 +++++++++++++++++------
 5 files changed, 39 insertions(+), 13 deletions(-)


--=-RJMGWY2HAtpcEin+EJXg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRVGHdAAoJEDBSmw7B7bqryIEP/3YG2u4qwPynGLXBah1LMKIP
MSWNsURnugG0E9FZQo/odpoPNsn3HOnkA02j3k0xzgg/NXuBTLojXDb6FWXbbnS5
dGDnlf46teQO0dn8r8Au9ZNZBa3HVeyNGQYjKJ28d2aF6iQpCKB9YvAvSRytFwV/
Fjk8BjLnwLiJ1O3fapHJl8FwP1WEJRztLx8CmuOOPlnY2KqY+tBuij2dLr0W4Bc8
V0JLgCYvu5r+wZsg5CAtewc2E2mO2V3EWVQ06TkPzcM4OkNEitxjEw7NTHxkPSfF
E/YxFyjRAN5tk+/5mKOMQ2FZNP6rBSo3eEOGjpdPaeA3wHFfQb4I/s0v9J/Ixr95
ND5Ai7/+sHi/PhZ0WPyGd/TYVjXZcAOuLbeucP5527msfPKcFbcWhY7tXDLDEat5
1Nn5NIy9DIgcdB/5XJI6enGL1njzaGqax0Tn5TYSMnqpGmvcqH/GVhX16iP3b5EA
7k8bshamM8+OyM60RrSSCkn2DsRvNu3OrUCEySB+dFAr7Jw0OFGTBLBsvav9pmcH
4e24qGX6A5iVx2650nDUgnqrYEm9CEwt2j8QiFw4WryZ0E3sSSCUMaEBMYL1MWtO
j9xX1ws5MdTxDLxYIt6P+uXpJ4FxIjOi2RL+/pwRinN0k59yT3MdXBqMa+A75c0u
L2inrAWDyarNc5DXuTdh
=JCT6
-----END PGP SIGNATURE-----

--=-RJMGWY2HAtpcEin+EJXg--

