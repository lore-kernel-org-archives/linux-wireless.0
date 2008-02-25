Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48777 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761624AbYBYWzV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 17:55:21 -0500
Subject: Re: mac80211: sta info locking
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Carlos Cobo <luisca@cozybit.com>
In-Reply-To: <1ba2fa240802251450x4ee13b94yb93e64fd9ebfcec8@mail.gmail.com> (sfid-20080225_225021_085141_92532BB4)
References: <1203677069.26341.52.camel@johannes.berg>
	 <20080222143745.GB3067@tuxdriver.com>
	 <1203693409.7082.30.camel@johannes.berg>
	 <20080222155704.GD3067@tuxdriver.com>
	 <1203972413.13162.163.camel@johannes.berg>
	 <1ba2fa240802251450x4ee13b94yb93e64fd9ebfcec8@mail.gmail.com>
	 (sfid-20080225_225021_085141_92532BB4)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-KyPbpPsmMliSGU+9Z+au"
Date: Mon, 25 Feb 2008 23:55:05 +0100
Message-Id: <1203980105.13162.182.camel@johannes.berg> (sfid-20080225_225540_855449_A963A4EC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KyPbpPsmMliSGU+9Z+au
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Tue, 2008-02-26 at 00:50 +0200, Tomas Winkler wrote:
> On Mon, Feb 25, 2008 at 10:46 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> >
> >  On Fri, 2008-02-22 at 10:57 -0500, John W. Linville wrote:
> >  > On Fri, Feb 22, 2008 at 04:16:49PM +0100, Johannes Berg wrote:
> >  > >
> >  > > > > Hence, I think we can actually get away without more locking i=
f we
> >  > > > > protect the flags better. Should we use a spinlock or the atom=
ic
> >  > > > > set_bit()/clear_bit()/etc. operations?
> >  > > >
> >  > > > Using the atomic operations seems appropriate to me.
> >  > >
> >  > > Right, but I figured if we could get rid of the AMPDU spinlocks an=
d just
> >  > > use a single one in total (for flags as well) then that'd be of be=
nefit
> >  > > too; even with the dynamic allocation strategy (see other mail) we=
'd not
> >  > > need to allocate two more spinlocks for ampdu.
> >  >
> >  > Yes, I thought that was behind your question.  I'll let Ron comment
> >  > on the AMPDU spinlock usage.
> >
> >  Ok so the mesh code came with a spinlock too, the AMPDU code has two.
> >
> >  Ron/Tomas, does the ampdu MLME really need two spinlocks?
>=20
> The problem is that RX a TX BA establishments usually happens
> concurrently for single STA, those are independent state machines.  We
> have to review this carefully before spinlokcs are removed.

I wouldn't want to remove them, but it seems overkill two have two
spinlocks. What I'd like to do is remove the ampdu tx, ampdu rx and mesh
spinlocks and instead use just a single one for all three uses, and then
use that one to protect the flags as well.

It seems to me that even if the RX/TX BA establishment is happening
concurrently then it's still serialized by the frames on the air so
ultimately can't actually happen on different CPUs so the lock won't be
contended.

johannes

--=-KyPbpPsmMliSGU+9Z+au
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8NHSKVg1VMiehFYAQLZXg/+L/ha4eUamavZisiNFPGAmxmHIth8HMwr
r+Adbe83IifjLt1f9zGWZikNHDV7Vish2A5RA+6Tts5xkm/Y1TxYf686cmVnhLli
TgNkhQ8ExNQ4Ax5ycCzXCOUy6qKnqCGC4/2txkmn+hCDkyew8u6vXhXadIaTqOLc
64Wy4xVpkXI+91vOCElgA1L6IwFA9ekmiT5Psh4crawPY/b7vMv7EYHJBbmuOxFs
106CiS+zzuw1iXb+YxWUdkAPkC7LMY8/ft7dRhZaSoIaUFtHzNb/sHlLU6bKeDkA
AsWEZfv4CGV2ce6UbrNXskrT6M/qT9IcRBP5Uk18xmeVrse2KXWwfJIIyGJLBiXa
ZL5XFv1uvlVA8RIzmyULppmgB6l/jYVHrT3HT36L14Y1HJAIdzg5J5NjCSgt+Vee
UJQnYslMIDKCQMv2ZaYMzEziQGUGBmytWF2kCQgGwwVqZQWnwzlyy2Ah0taGWyav
vst7N0DtvdwQjfk6/+o6Ak/gUDA0aOEpJ0W4Wo+IF4U7DSCd/vY29ad9lVM0xi9u
8nzgvWPc7kcBM/FcQsIssFTpN31KBWIMDPkdfdY4l2GJX4mKTY2uawDO6pOPyZBl
EbdvuwlWYUVMKmF5+Qf4lYyYuEawZ9wst8GeMIeIqLMMwhcJrfC/b7KNq4ovTSsp
88RljEMqw1w=
=PjEi
-----END PGP SIGNATURE-----

--=-KyPbpPsmMliSGU+9Z+au--

