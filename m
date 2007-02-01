Return-path: <wireless-bounces@tuxdriver.com>
Received: from sipsolutions.net (Debian-exim@crystal.sipsolutions.net
	[195.210.38.204])
	by ra.tuxdriver.com (8.13.7/8.13.7) with ESMTP id l11EClk2014680
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO)
	for <wireless@lists.tuxdriver.org>; Thu, 1 Feb 2007 09:13:13 -0500
Subject: Re: [RFC] cfg80211 merge
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
In-Reply-To: <1ba2fa240702010604o3cc827d6j1319579e15f28b48@mail.gmail.com>
References: <20070131013717.GA28076@tuxdriver.com>
	<20070131024807.GA7061@jm.kir.nu>
	<20070131182908.13bfc374@griffin.suse.cz>
	<20070131183255.GB8776@tuxdriver.com>
	<20070131202549.5ee47bd4@griffin.suse.cz>
	<20070131200741.GA22448@infradead.org>
	<20070131204438.GB19669@tuxdriver.com>
	<1170277561.2236.6.camel@johannes.berg>
	<1ba2fa240701311554i435d28b1x6822803326138cb5@mail.gmail.com>
	<1170335262.17068.6.camel@johannes.berg>
	<1ba2fa240702010604o3cc827d6j1319579e15f28b48@mail.gmail.com>
Date: Thu, 01 Feb 2007 15:11:18 +0100
Message-Id: <1170339078.22420.3.camel@johannes.berg>
Mime-Version: 1.0
Cc: wireless@lists.tuxdriver.org
List-Id: Linux wireless networking development <wireless.lists.tuxdriver.org>
List-Unsubscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=unsubscribe>
List-Archive: <http://lists.tuxdriver.org/pipermail/wireless>
List-Post: <mailto:wireless@lists.tuxdriver.org>
List-Help: <mailto:wireless-request@lists.tuxdriver.org?subject=help>
List-Subscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1481849047=="
Sender: wireless-bounces@tuxdriver.com
Errors-To: wireless-bounces@tuxdriver.com


--===============1481849047==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-0HZqMi7x8HoI+R5rMYGQ"


--=-0HZqMi7x8HoI+R5rMYGQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-02-01 at 16:04 +0200, Tomas Winkler wrote:
> Can you elaborate shortly.  I'm not from time 0 on this list.

Well. cfg80211 will replace the common wext ioctls. All the private wext
ioctls will not be handled there.

The rationale is that
 (1) it doesn't delete priv ioctls, they'll still work for the migration
     period
 (2) you can't rely on private ioctls having a certain meaning for each
     driver, ie. other drivers are free the reassign numbers of
     sub-ioctls
 (3) any behaviour that is generally useful should be standardised.

johannes

--=-0HZqMi7x8HoI+R5rMYGQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBFwfUG/ETPhpq3jKURAo3PAJ0a4c9N7jxqGGHksxP5DciPa/FApwCgr4tA
Om5dZl4mRoE0qLHMCqa5X4g=
=QzV1
-----END PGP SIGNATURE-----

--=-0HZqMi7x8HoI+R5rMYGQ--


--===============1481849047==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
wireless mailing list
wireless@lists.tuxdriver.org
http://lists.tuxdriver.org/mailman/listinfo/wireless

--===============1481849047==--
