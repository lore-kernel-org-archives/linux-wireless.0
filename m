Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35981 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbZCQOMV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 10:12:21 -0400
Subject: Re: rt2x00 mesh support
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Antonio Marques <froz@icix.org>,
	Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200903171031.41302.IvDoorn@gmail.com> (sfid-20090317_103150_606981_0D5CC206)
References: <E8FC0565-5438-4AB5-A004-CD31DD9C1AA3@icix.org>
	 <200903161558.01070.IvDoorn@gmail.com>
	 <A1AF7AF9-047F-41A1-829F-94F58821DB09@icix.org>
	 <200903171031.41302.IvDoorn@gmail.com>
	 (sfid-20090317_103150_606981_0D5CC206)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Y6+C3NKTRiDNtKoSKDoC"
Date: Tue, 17 Mar 2009 15:11:38 +0100
Message-Id: <1237299098.31814.12.camel@johannes.local> (sfid-20090317_151227_274610_073D96BB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Y6+C3NKTRiDNtKoSKDoC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-17 at 10:31 +0100, Ivo van Doorn wrote:
> On Monday 16 March 2009, Antonio Marques wrote:
> > On Mar 16, 2009, at 14:58 , Ivo van Doorn wrote:
> > > On Monday 16 March 2009, Ant=C3=B3nio Marques wrote:
> > >>
> > >> As requested, I have attached the output of the script run before an=
d
> > >> after
> > >> running 'iwlist mesh scan'. Unfortunately there seems to be no =20
> > >> change in
> > >> the output. I have also included the queue statistics as these do
> > >> change from
> > >> one state to the next. Any further pointers to help debug this? I'll
> > >> gladly test
> > >> any patches that try to address this issue.
> > >
> > > The dumps aren't correct, I had forgotten to update the script on =20
> > > the website
> > > after some API for the rt2x00 debugfs interface changes recently.
> > > Attached is the correct patch.
> > >
> > > Ivo
> > > <rt2x00_regdump.sh>
> >=20
> > Fixed, new dumps are attached.
>=20
> Thanks for the dumps, the reason why the beaconing isn't working
> is (fortunately) very obvious from the registers point of view.
> The "generate beacons" bit is simply not enabled. However the reason
> why this bit has not been set escapes me. Could you apply the attached
> patch? This will add extra debug messages to the driver to see when the
> beacon generation bit is set.

I think mac80211 is probably not requesting it until you scan -- since
once you scan it calls ieee80211_if_config internally and changes that
bit. Some mesh code needs to call ieee80211_if_config() with the beacon
enable change flag.

johannes

--=-Y6+C3NKTRiDNtKoSKDoC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJv6+YAAoJEKVg1VMiehFY7O8QAMCtmX3GDmpVCxiqzOa+GewO
TplyyH1iEKAt4YARWj7qaYMh0UsPh5kSUxWrGuN1cm0AaY2LoYHo5rieGb1P/pN/
31/4XplGX/2JZ9qT/cxfIf7jcsEirxJKJs23eq671rHlQdjOa/aAgDUCpMzeg9PH
75TmVq3hPgopFeGAKtINO5ef0U/cgLWmx9JDenKqdlnLcyxWH+zAvyem+mz4P6EV
+Bdx1I+69qwVorgK08dPj1TZx2LLe64WHGxJ/oA7kAxuxoQ0UmEr94X5GJfp3pHQ
swHy3HF672jACPTtczIVeyQ5/ajkq0FVTJPMw7KqAiepoWJ9Y7KRjQUURF3leXDs
mbT724ILD+ODG94yl48OxSR0Wb349feb8znddwE4+5XbXiNPjHH3UroP5uBBAAdX
O3dp1kJSEGsYnUPLernRbNamelzYyxQHPL7yfSd6bGb3GI7BhBR2yPHy3+bU5xwF
R6xJIMVDdw8FNQHH3BzYffbXmyXgWpL3KiYXf129beuoivKRwRT7T0pgCH6kIrVh
Xie90BDckWBO08hAM1QrsR+KqpHRa5gqqafdvj1xtGGEhweWav+7svPJYXyoDAJQ
05fwAMp8PDtKl6S/qHqm0D2SGdP5zuunF67GJrhITW8UTE+E8f6IdIU7YAPeyPr7
827b9H9pyy96/uhMJQfF
=fGzB
-----END PGP SIGNATURE-----

--=-Y6+C3NKTRiDNtKoSKDoC--

