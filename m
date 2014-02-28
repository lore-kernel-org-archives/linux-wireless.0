Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39208 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbaB1N4Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 08:56:24 -0500
Message-ID: <1393595772.4133.6.camel@jlt4.sipsolutions.net> (sfid-20140228_145627_719895_31C08EDD)
Subject: pull-request: mac80211 2014-02-28
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 28 Feb 2014 14:56:12 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-yNVD3f1FHSN+lZZMkfyz"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yNVD3f1FHSN+lZZMkfyz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

It's getting later in the rc cycle, and the pull requests are getting
smaller, but we still have some fixes...

This time I have a fix to get out of an 'infinite error state' in case
regulatory domain updates failed and two fixes for VHT associations: one
to not disconnect immediately when the AP uses more bandwidth than the
new regdomain would allow after a change due to association country
information getting used, and one for an issue in the code where
mac80211 doesn't correctly ignore a reserved field and then uses an HT
instead of VHT association.

Please let me know if there's any problem.

johannes

The following changes since commit e3685e03b40f5ec7926d9a75bf63467fc4071df9=
:

  mac80211: fix station wakeup powersave race (2014-02-20 11:54:09 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to cb664981607a6b5b3d670ad57bbda893b2528d96:

  mac80211: fix association to 20/40 MHz VHT networks (2014-02-27 20:53:01 =
+0100)

----------------------------------------------------------------
Janusz Dziedzic (1):
      cfg80211: regulatory: reset regdomain in case of error

Johannes Berg (2):
      mac80211: don't validate unchanged AP bandwidth while tracking
      mac80211: fix association to 20/40 MHz VHT networks

 net/mac80211/mlme.c | 23 +++++++++++++++++++++++
 net/wireless/reg.c  | 10 +++++++++-
 2 files changed, 32 insertions(+), 1 deletion(-)


--=-yNVD3f1FHSN+lZZMkfyz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJTEJV8AAoJEDBSmw7B7bqrTK0QANNnS/Zsn5YxsAnjs+gYlqBn
hCv9aQVBoeOFgQwiFwmGLIrFXezrqIxdSFYsiIGHvSv6/UBG+dDhF8C9Y4ioZ8h6
8Tks7a053hPaGYO4B6A41HNkygCQNJ4ICE8I4LPq1mcKIhznwK4FI/RQ8PuncW8u
clzRcvIHHnbbOrqY5uM367M/mivvh7DNDqSc8nx6EQ2lR1fb3JQQhJAKjqOpawYq
4JOC7Mt+/BBOVDGcWJMV2tqiDHimU93x8N1QGv9pi/RXmTyIGAtLLxbDZ2I3CWDO
RNAKx9kbZb/0FevHnCTSgdQYRFv9dXB8T3LwlApSmYU/17E5Fo+j5aRMX1te3rdP
VVlHCdncxQ6N0J+UCTpxbU+654rKgvwk1mX2O7RHZovym79vZI5rP4t85KJEAhZ+
+HyPfK2N/htgAFs5unA4jZEh8nO4YyoDaricdfoUyvjC3jQgZxPcWpY00ToU3NWq
u2jeYM+VxybZF48Hb9NhobqDgJ62Phil06kjT4eJZFycsTuf2VHmEsdm8mDzrw9P
rHZDGtmA4Eyz8iwD7cg7zagLNiSSocYEB783FxOmoNJsiy8zu2ZGQjoCLv+6oNP5
DgNZdl2LKSOtjJ8GQRNUM3LVtR9E2tYtWzs0AlwZ2UBePJR1T0fMCh/CLNSJFZ66
2TldYz1KASx45hyrCRCY
=TAxj
-----END PGP SIGNATURE-----

--=-yNVD3f1FHSN+lZZMkfyz--

