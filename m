Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:53414 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137Ab3BVLnr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 06:43:47 -0500
Date: Fri, 22 Feb 2013 12:43:40 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>,
	johannes@sipsolutions.net, antonio@open-mesh.com,
	marek@open-mesh.com,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: Re: [RFC] design discussion: Collecting information for (non-peer)
 stations
Message-ID: <20130222114340.GA11803@pandem0nium> (sfid-20130222_124352_093335_8CD3D109)
References: <20130215171938.GA4140@pandem0nium>
 <51274372.9030600@neratec.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
In-Reply-To: <51274372.9030600@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Zefir,

On Fri, Feb 22, 2013 at 11:07:46AM +0100, Zefir Kurtisi wrote:
> On 02/15/2013 06:19 PM, Simon Wunderlich wrote:
> > Hello wireless folks,
> >=20
> > Mathias Kretschmer and me would like to bring another new feature to th=
e kernel:
> > Collecting information for (non-peer) stations. [...]
> >=20
> > Cheers,
> >         Simon
> >=20
> Hi Simon,
>=20
> our areas of operations obviously highly overlap, since I did the same
> consideration path only recently ;)
>=20
> For the frequency planning feature we are currently working on, I need th=
ose
> extended statistics you are proposing with additional filtering rules (OU=
I or mask
> based) to classify peers.
>=20
> My initial idea was to do a sliding time window aggregation of those stat=
istics in
> the kernel with almost the same interface to the userspace you are propos=
ing.
>=20
> But with your integration of the spectral feature I realized how efficien=
t relay
> based continuous data transfer is (as compared to sending samples over ne=
tlink).
> Consequently I revised the initial plan and consider realizing the extend=
ed
> statistics collection in userspace.
>=20
> The modifications required in the kernel are minimal:
> * create relay file in debugfs
> * provide enable flag in debugfs
> * based on this flag, extract relevant information from frames and write =
to relay
>=20
> This way, you move complexity out of the kernel and maximize flexibility =
for
> statistical evaluation in userspace. Also, the overhead for moving data b=
etween
> kernel and userspace is minimized, since you do them in bulk.
>=20
> This is all in the planning phase, so I have no proof-of-concept patches =
yet.
> Would just like to hear what your thoughts are and whether this could be =
the way
> to go.

it is nice to hear that the relayfs approach works well. :)

Our biggest performance issue is probably the syscall for every packet, so =
minimizing
data to be sent to userspace and aggregate it to would benefit to our perfo=
rmance
problem.

I would also agree that this approach is simpler as we don't have to manage=
 lists
of clients and purge them. And we can evaluation in userspace, just as ever=
yone
needs for its application (maybe some of these statistics are not of genera=
l interest).

Issues I see are:
 * the relayfs has to be regularly polled for new data (maybe multiple time=
s a second),
   so it can't overflow. I'm just looking at a dump from a running iperf te=
st, it shows
   ~12000 packets per second (at 70Mbit/s). Assuming we are sending 64 byte=
 of metainfo
   per packet, this would sum up to 768k every second. Doing the statistics=
 computation
   in userspace makes no difference to doing it in kernelspace, imho.
 * in-kernel drivers can't use the gathered statistics (that would affect 8=
02.11s)
 * I wonder how debugfs use in mac80211 for this kind of feature is accepta=
ble. This
   would be a question for Johannes. :)

Thanks for sharing your thoughts!

Cheers,
	Simon

--wac7ysb48OaltWcw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlEnWewACgkQrzg/fFk7axYJaQCcC7V+DsFgRzhi65iM0if1DPkV
WPYAn3noBzyKZgHWFXlxNtJYslz8ihSB
=SOzp
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
