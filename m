Return-path: <wireless-bounces@tuxdriver.com>
Received: from annwn13.rutgers.edu (smtp.rutgers.edu [128.6.72.243])
	by ra.tuxdriver.com (8.13.7/8.13.7) with ESMTP id l15HkMGf012426	for
 <wireless@lists.tuxdriver.org>; Mon, 05 Feb 2007 12:46:47 -0500
Date: Mon, 05 Feb 2007 12:45:30 -0500
From: Michael Wu <flamingice@sourmilk.net>
Subject: Re: [RFC PATCH 1/3] cfg80211 and nl80211
In-reply-to: <1170325092.2236.17.camel@johannes.berg>
Sender: wireless-bounces@tuxdriver.com
To: Johannes Berg <johannes@sipsolutions.net>
Cc: wireless@lists.tuxdriver.org
Errors-to: wireless-bounces@tuxdriver.com
Message-id: <200702051245.35452.flamingice@sourmilk.net>
MIME-version: 1.0
Content-type: multipart/mixed; boundary="===============0554357086=="
References: <20070131013717.GA28076@tuxdriver.com>
 <200701302146.05289.flamingice@sourmilk.net>
 <1170325092.2236.17.camel@johannes.berg>
List-Post: <mailto:wireless@lists.tuxdriver.org>
List-Subscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=subscribe>
List-Unsubscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=unsubscribe>
List-Archive: <http://lists.tuxdriver.org/pipermail/wireless>
List-Help: <mailto:wireless-request@lists.tuxdriver.org?subject=help>
List-Id: Linux wireless networking development <wireless.lists.tuxdriver.org>

--===============0554357086==
Content-Type: multipart/signed; boundary="nextPart4686705.a9Xxi1EMOT";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart4686705.a9Xxi1EMOT
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 01 February 2007 05:18, Johannes Berg wrote:
> I disagree. Generic netlink is trivially extensible while radiotap
> isn't, and I really don't want a radiotap parser in the kernel.
> Secondly, a lot of notification items will only be given via netlink
> anyway, like failed decryption or whatever, and we don't want to keep
> all this in fake management frames.
>
Okay then, let's not use fake frames then. Let's make monitor interfaces=20
resemble monitoring ethernet a little more by reporting both RXed frames an=
d=20
TXed frames. *BSD does this too and it makes running ethereal on monitor=20
interfaces much more useful. TX frame reporting can be done simply in the=20
ieee80211_tx_status call, allowing the TX status to be reported on real=20
frames.=20

Doing this is actually somewhat orthogonal to packet injection via netlink =
or=20
monitor interface, but if we are reporting TXed frames with a radiotap=20
header, we might as well allow frame injection with a radiotap frame for=20
consistency. It seems far better than receiving frames on one interface and=
=20
then using netlink to TX on some wiphy. Not to mention that using a=20
configuration interface to send data doesn't make much sense when there's a=
=20
perfectly fine network interface available. Radiotap parsing isn't much=20
harder than EID parsing, allows current frame injection programs to continu=
e=20
working, and might even make it easier to run those programs on BSD too. (I=
=20
don't know what mechanism BSD uses for frame injection)

=2DMichael Wu

--nextPart4686705.a9Xxi1EMOT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFx20/T3Oqt9AH4aERAvFVAJwK7Xa6KQ/pbkxIj6VG/h8O54BjyACgmvrv
gpTQj22tpW2iBhWmXAP70L0=
=RGFA
-----END PGP SIGNATURE-----

--nextPart4686705.a9Xxi1EMOT--

--===============0554357086==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
wireless mailing list
wireless@lists.tuxdriver.org
http://lists.tuxdriver.org/mailman/listinfo/wireless

--===============0554357086==--
