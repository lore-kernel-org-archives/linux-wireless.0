Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from investici.nine.ch ([217.150.252.179]:31244 "EHLO
	confino.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab2IEOhR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 10:37:17 -0400
Date: Wed, 5 Sep 2012 16:37:00 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211: reply to AUTH frame with a DEAUTH if sta
 allocation fails
Message-ID: <20120905143659.GA4788@ritirata.org> (sfid-20120905_163723_547861_974D26E6)
References: <1345995273-27358-1-git-send-email-ordex@autistici.org>
 <1345995273-27358-2-git-send-email-ordex@autistici.org>
 <1346853503.4364.16.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
In-Reply-To: <1346853503.4364.16.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 05, 2012 at 03:58:23 +0200, Johannes Berg wrote:
> On Sun, 2012-08-26 at 17:34 +0200, Antonio Quartulli wrote:
> > Whenever a host gets an AUTH frame it first allocates a new station and=
 then
> > replies with another AUTH frame. However, if sta allocations fails the =
host
> > should send a DEAUTH frame instead to tell the other end that something=
 went
> > wrong
>=20
> Well, ok, but...
>=20
> >  	/*
> > +	 * if we have any problem in allocating the new station, we reply wit=
h a
> > +	 * DEAUTH frame to tell the other end that we had a problem
> > +	 */
> > +	if (!sta) {
> > +		ieee80211_send_deauth_disassoc(sdata, sdata->u.ibss.bssid,
> > +					       IEEE80211_STYPE_DEAUTH,
> > +					       WLAN_REASON_UNSPECIFIED, true,
> > +					       deauth_frame_buf);
>=20
> You can't call the function in IBSS mode, it accesses sdata->u.mgd. You
> should probably fix that in the first patch and make it conditional on
> the sdata->vif.type actually being station mode.

argh ok. I see the problem. Will fix and send v2.

Thank you


--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlBHY4sACgkQpGgxIkP9cwcdNQCeNFsFD32oWvFXGhuEm0nbM51n
BwAAn18vkqadckrHjZ1wmpdqzOPzXEK0
=ZK9o
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
