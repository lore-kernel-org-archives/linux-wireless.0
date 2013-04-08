Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ht2.myhostedexchange.com ([69.50.2.38]:17457 "EHLO
	ht1.hostedexchange.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934839Ab3DHJNI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 05:13:08 -0400
Date: Mon, 8 Apr 2013 11:11:42 +0200
From: Antonio Quartulli <antonio@open-mesh.com>
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Will Hawkins <hawkinsw@opentechinstitute.org>
Subject: Re: [PATCHv3 2/2] mac80211: in AD-HOC mode wait for the AUTH response
Message-ID: <20130408091142.GB6083@open-mesh.com> (sfid-20130408_111326_317204_7B18A360)
References: <50EACA95.8040004@lri.fr>
 <1359151524.4655.37.camel@jlt4.sipsolutions.net>
 <5103C774.4080403@lri.fr>
 <1359459469.8108.11.camel@jlt4.sipsolutions.net>
 <5107D5D5.3070601@lri.fr>
 <1359639241.8415.17.camel@jlt4.sipsolutions.net>
 <510A7D40.2030206@lri.fr>
 <1359642373.8415.57.camel@jlt4.sipsolutions.net>
 <20130407211654.GA6083@open-mesh.com>
 <51627793.1040505@lri.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="p2kqVDKq5asng8Dg"
In-Reply-To: <51627793.1040505@lri.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--p2kqVDKq5asng8Dg
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 08, 2013 at 12:53:55AM -0700, Nicolas Cavallari wrote:
> On 07/04/2013 23:17, Antonio Quartulli wrote:
> > Hi all,
> >=20
> > let's resurrect this thread :)
> >=20
> > On Thu, Jan 31, 2013 at 06:26:13AM -0800, Johannes Berg wrote:
> >> On Thu, 2013-01-31 at 15:18 +0100, Nicolas Cavallari wrote:
> >>
> >>>> I think that's acceptable, but if it requires a wpa_s change anyway =
we
> >>>> could just implement reboot detection there instead of adding all th=
ese
> >>>> new events etc.? I.e. rather than having a new supplicant say "OK I =
will
> >>>> listen to the right event when handling reboot detection", it could =
just
> >>>> use the existing infrastructure and implement it itself?
> >>>
> >>> Well i already have wpa_supplicant patches for that. Might just need =
to clean that up a
> >>> bit so it's at least configurable.
> >>>
> >=20
> > Would you mind sharing this code?
>=20
> Well yes, i just need to untangle it with some other local policies ;)
>=20
> > Maybe I can help and offload some work. :)
> > Anyhow I did not understand how you can detect a node reboot from users=
pace if, as
> > you stated, wpa_s is not able to distinguish encrypted from un-encrypte=
d frames.
>=20

Ah ok. I thought we were not talking about registering for AUTH frames here=
=2E Got
it now.


I'm wondering why it is better to implement kernel reboot detection in
userspace, but I think it is cleaner and less racy...Then I think it is bet=
ter
to revert the "delete and add station" mechanism we currently have.

>=20
> >>> But now i'm reminded that transmitting management frames from userspa=
ce requires a
> >>> frequency. For wpasupp to be race-free during ibss merges, we should =
have a way to
> >>> transmit management frames to the current bss without specifying a fr=
equency...
> >>
> >> That seems reasonable.
> >>
> >=20
> > This is a common problem I faced in other contexts too...
>=20
> I sent a patch shorty after this message, trying to solve the problem, ex=
cept Johannes
> pointed out that it could still introduce races, at least in some non-mac=
80211 drivers,
> the most problematic being ath6kl. I don't have any ath6kl hardware here,=
 and i don't like
> patching things that i can't test.

Understood. Thanks for the explanation.


Cheers,

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--p2kqVDKq5asng8Dg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJRYonOAAoJEADl0hg6qKeOmCsP/3kS1OgLe0cWJxK9Bus/qKf+
HU06h8p9iQbsuxHSO1uuCkctBlPr2DmzpsGjmOm1nVx/HYbxAJfrzBiGvORz/3IZ
66imro9eILKI753QYpbZ7eV9PFtqOOoRS7A6mzXCpHeWPUlNs0OgzjEuRHgbQ3eT
w3dSUushA5c9sK4O0goxzUM3hn/Qn3ExpNfvDSqqwJFBA40okjG/oLgKRF348pE3
OD++yjhEPN/qMnW9XbyOUmdjSfMtzWUsmSVke55NM7aHkrpRM79lGUD9cvMxjjRZ
MHlrEj+Fd5Lv9YGQ1poI3daKP9qVOOvx45FXz8oG0JUT3GEgE9vYBJwrSG2n/R4m
cYJbE0CIgmFutmOn+rsm2aNslPeDiuL+PBhBc48+RC1XNbl1BfODSw089m8rDDZO
aUQBXBgjNbhuaZapEKZaxr/39q2ksXXCt0hjcZwEuHE3DueC+5Hwsob3829oxvs5
UU0UVYrmA8GVw6os1oFNWwszFnmyAuVI2LGCFzG64/zpfSFke3y/wbVNiZzNhjyN
StuQZuaXuIM7wDdalzzBpKpEU2P0aVwl+sU0Y08MqZc0qPqT/LA0uaRZkoAN0Dz/
fdLFAaF+yyCAJF17twHJ/1f9QifcKN2gKZJPj9xNxSKVGdesyg8dw306BC4a/OfD
+fV0NLK3QgUj1YHzXQMB
=UtRH
-----END PGP SIGNATURE-----

--p2kqVDKq5asng8Dg--
