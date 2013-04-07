Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ht1.myhostedexchange.com ([69.50.2.37]:7114 "EHLO
	ht1.hostedexchange.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1762419Ab3DGVSj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Apr 2013 17:18:39 -0400
Date: Sun, 7 Apr 2013 23:17:12 +0200
From: Antonio Quartulli <antonio@open-mesh.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Will Hawkins <hawkinsw@opentechinstitute.org>
Subject: Re: [PATCHv3 2/2] mac80211: in AD-HOC mode wait for the AUTH response
Message-ID: <20130407211654.GA6083@open-mesh.com> (sfid-20130407_231844_811565_D14FEC0B)
References: <50E400A7.5060100@lri.fr>
 <20130107114048.GH27589@ritirata.org>
 <50EACA95.8040004@lri.fr>
 <1359151524.4655.37.camel@jlt4.sipsolutions.net>
 <5103C774.4080403@lri.fr>
 <1359459469.8108.11.camel@jlt4.sipsolutions.net>
 <5107D5D5.3070601@lri.fr>
 <1359639241.8415.17.camel@jlt4.sipsolutions.net>
 <510A7D40.2030206@lri.fr>
 <1359642373.8415.57.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="xXmbgvnjoT4axfJE"
In-Reply-To: <1359642373.8415.57.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--xXmbgvnjoT4axfJE
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

let's resurrect this thread :)

On Thu, Jan 31, 2013 at 06:26:13AM -0800, Johannes Berg wrote:
> On Thu, 2013-01-31 at 15:18 +0100, Nicolas Cavallari wrote:
>=20
> > > I think that's acceptable, but if it requires a wpa_s change anyway we
> > > could just implement reboot detection there instead of adding all the=
se
> > > new events etc.? I.e. rather than having a new supplicant say "OK I w=
ill
> > > listen to the right event when handling reboot detection", it could j=
ust
> > > use the existing infrastructure and implement it itself?
> >=20
> > Well i already have wpa_supplicant patches for that. Might just need to=
 clean that up a
> > bit so it's at least configurable.
> >=20

Would you mind sharing this code? Maybe I can help and offload some work. :)
Anyhow I did not understand how you can detect a node reboot from userspace=
 if, as
you stated, wpa_s is not able to distinguish encrypted from un-encrypted fr=
ames.

But why did we trash the idea of simply postponing the moment when NEW_STA =
is
sent to userspace? It can be sent when the kernel has received the AUTH "Re=
ply"
message and avoid the current race condition.
Actually this would mean to send the NEW_STA at the same moment the kernel =
with
this patch would send the IBSS_STA.

> > But now i'm reminded that transmitting management frames from userspace=
 requires a
> > frequency. For wpasupp to be race-free during ibss merges, we should ha=
ve a way to
> > transmit management frames to the current bss without specifying a freq=
uency...
>=20
> That seems reasonable.
>=20

This is a common problem I faced in other contexts too...


Cheers,

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--xXmbgvnjoT4axfJE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJRYeJYAAoJEADl0hg6qKeOkOoQAKRMj2VdcZyjTw++cfVx7tYI
ETRGyHXJ2J/aqaIXZ9n8L8vYEaznwY5rKS+F9FecA+EJS+qye1tKq6UAvFPp5kk2
R+N/l3m+/VvV9fLAtj+rOFSvBfLT77lTdBXcF2+8zhvElH/tppEJoShtYrkiCYtW
eHxNQgJkzkOR1VGLtlPqJaUBRMkyEc3RqlFcTGhFn9zECqbgAl6YXeBxo0lrBDuK
52MH+TAPduzlTnF7dHeq2SC2WTngBIRQge33lCHQ58YFeLpjCLfkCflOGWwyVDwC
RB6t2GGmmhcf5oKmZ4Qwrk3Kn+DIoQT8PoDRuIzAVOIrCJ66HKZN0h7GtUf60hVR
MhhSf6wkKp9e1ekHZSqCSI/3neXB2aabi6H5tuUa/C/MmlZcGl/IE+tmmxrlYJWj
+j16aG1/J0gW384oEJQaCBmlI5rZ4VZb/T9XSTWQmRaWeMMR2Hd3ESuDb/u8kHPo
4e2tSnb/lO/SvNvk/iLn7+hknIWj30rST/Ca4VcmJASlEmKJjDruMSGOf61sGOGh
6+F0x5kB4BXVXbEJizHrZYksdYmWvEaGkyKQSmTXUCbJVSQoI6BnPcSY1QMNmeEz
XaMhOh1fEE3zocFRc+CRPteDmLpjUrHPASvwnJAbGtJV6OwnS8rIJxGZwSdP+l1G
EqFHJeosdYYDJefnAoRa
=buMK
-----END PGP SIGNATURE-----

--xXmbgvnjoT4axfJE--
