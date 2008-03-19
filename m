Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56606 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939966AbYCSWL5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 18:11:57 -0400
Subject: Re: [ipw3945-devel] [PATCH 1/5] mac80211: allows driver to request
	a Phase 2 key
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Jouni Malinen <j@w1.fi>, Emmanuel Grumbach <egrumbach@gmail.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1ba2fa240803191504i26732013ye34b6df817a06f0f@mail.gmail.com> (sfid-20080319_220449_038368_41772324)
References: <1205781593.16475.20.camel@johannes.berg>
	 <1ba2fa240803171327r4c817228kc4f248abf0a0cea@mail.gmail.com>
	 <20080318080435.GA5308@jm.kir.nu> <1205831880.16475.43.camel@johannes.berg>
	 <20080318102344.GG5308@jm.kir.nu>
	 <8704f27d0803190942h19b5a9ebjd3b27537c30ef719@mail.gmail.com>
	 <20080319173922.GB5308@jm.kir.nu>
	 <1ba2fa240803191141y7feae800g607432f2e9628e37@mail.gmail.com>
	 <20080319201004.GC5308@jm.kir.nu> <1205957728.16475.72.camel@johannes.berg>
	 <1ba2fa240803191504i26732013ye34b6df817a06f0f@mail.gmail.com>
	 (sfid-20080319_220449_038368_41772324)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MLSliB4jAlWFHjxCxJ9o"
Date: Wed, 19 Mar 2008 23:11:33 +0100
Message-Id: <1205964693.16475.75.camel@johannes.berg> (sfid-20080319_221313_289399_23A12B7F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MLSliB4jAlWFHjxCxJ9o
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Thu, 2008-03-20 at 00:04 +0200, Tomas Winkler wrote:
> On Wed, Mar 19, 2008 at 10:15 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> >
> >  > The IEEE 802.11 name for this would be "default key". IEEE 802.1X (o=
r
> >  > well, RFC 3580 is the authoritative specification for this) calls it
> >  > "broadcast (default key)". Please note that this is not really a key
> >  > that is always used both for unicast and broadcast. If there is a
> >  > key-mapping key (unicast/individual) for the matching
> >  > transmitter/receiver addresses, that key will be used instead. The "=
old
> >  > WEP key" way of using only statically configured default keys just d=
oes
> >  > not set the key-mapping key and because of that, the default key end=
s up
> >  > being used for all frames (or well, one of the possible four default
> >  > keys).
> >
> >  That agrees with what I did in mac80211, but not with Intel's hardware=
.
>=20
> You wish, you didn't have clue yourself :)

I know :P
I actually just cleaned up the original code (and added the distinction
for TX-only keys.)

Actually, it makes things quite complicated for the driver because it
has to keep track of whether pairwise keys are enabled even if they are
for an encryption algorithm that it doesn't handle. I suppose making
mac80211 track that would be nicer.

johannes

--=-MLSliB4jAlWFHjxCxJ9o
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR+GPlKVg1VMiehFYAQIecxAAsXqmULHqP9ThCV0AL7AG9SHVLERdefEe
++d2xeOH0/Zhmz5GxWLRzbxruAOUSd6RuX1IO/PPByFEn6DDBl9K9LmKbkMQh3xe
ApOOSqZU5QqPgHx8lnyHvlBbGD6MAtwX7GM6XrxgNkYavo4s5OLVrWwVzZ/MItTn
EwlprshHAkvz2MfZtVVgjRFZoSbLEKppDh+53Uf4JUC6bd1Ir+Rz+qYiCsgIQa1U
Q6jk4pA7F/5Fx64+ry31fKqnGqCon8/wiBQLz+qZRFhQEpU90rrWIMzyi/MidojP
c9sJK1ekFb9gXKCFa82uPOg9jTwz6k8fqTAnDFA+/Wact0zs+XGDQZMsJZRomrjG
WXBAsPnMVhygcnOlhX1bLruMvIMxpNVsLnosmbGyqu+6wyzM6ueCvXr0zDg83uol
shtSzQaiPj45sH80A33HOWwy2JCvPXplnvskgWaDbVIEvsR2D+eSZws+FnmuIZk9
8jIr5u20jTsNtnpKkIkA0doSNn3fRaw+OZ3H16jNrA85wXsAZEfskqbQa3BQNDh1
fJ+oD13mnMPFq96J+JZfSdf4QV9z5W2f1Q3/nCZGSD8KEx1D+vFX2f+5SWie3qS3
pP6DV4fQEsOOKGOxnSpQtkk19n0Afd+WZq9UsbgdQcxB25zMibbTFsSG8YdJr6yI
d/g+IZ5FY2E=
=6tBA
-----END PGP SIGNATURE-----

--=-MLSliB4jAlWFHjxCxJ9o--

