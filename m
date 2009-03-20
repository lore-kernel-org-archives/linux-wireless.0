Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57854 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbZCTJmw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2009 05:42:52 -0400
Subject: Re: [RFC PATCH v2 1/4] mac80211: decrease execution of the
 associated timer
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
In-Reply-To: <87zlfglfa2.fsf@litku.valot.fi> (sfid-20090320_102318_775065_E8F12DE1)
References: <20090314171234.11126.21125.stgit@tikku>
	 <20090314171431.11126.51242.stgit@tikku>
	 <1237051084.5235.97.camel@johannes.local> <49BBFB78.6070708@nokia.com>
	 <87zlfglfa2.fsf@litku.valot.fi> (sfid-20090320_102318_775065_E8F12DE1)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-uIULExfBoPLQntE8cChU"
Date: Fri, 20 Mar 2009 10:42:46 +0100
Message-Id: <1237542166.5100.137.camel@johannes.local> (sfid-20090320_104257_948360_2401C72D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-uIULExfBoPLQntE8cChU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-03-20 at 11:22 +0200, Kalle Valo wrote:

> >>> +void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
> >>> +			     struct ieee80211_hdr *hdr)
> >>> +{
> >>> +	/* timer triggers only when there is no unicast traffic */
> >>> +	if (!is_multicast_ether_addr(hdr->addr1))
> >>> +		mod_timer(&sdata->u.mgd.timer,
> >>> +			  jiffies + IEEE80211_MONITORING_INTERVAL);
> >>> +}
> >>
> >> Do we really need the multicast check? The frame will be coming from t=
he
> >> AP in managed mode in both cases, so why regard the data path as idle
> >> when we're receiving multicast traffic?
> >
> > It seems that I had a good vacation because I can't remember anymore
> > why I added the check :D Too bad that even the comment I wrote was
> > next to useless.
> >
> > I'll remove the multicast check because I don't see the point for it.
> > And if in case I finally recall the reason I'll definitely add a
> > better comment.
>=20
> Now I remember what this test was about. In ieee80211_associated()
> there are two tests: probe request check after an data idle period
> (currently 60 secs) and beacon loss check for drivers not supporting
> filtering (2 secs).
>=20
> The former test has been originally (even before my beacon filter
> patches) implemented so that the probe request is sent even though we
> are receiving beacons. mod_timer() is called only for unicast traffic
> so that the probe request test will trigger when we are still
> receiving beacons.

Why would we not want to change that? I don't see a reason to send a
probe request when we're still receiving beacons. It was meant to be
used when beacons got lost _during_ a data idle period to verify that
the AP is still there, afaict.

> I'll add a proper comment explaining all this.
>=20
> Also currently ieee80211_associated() is called every two seconds, we
> need to fix this in future to avoid waking up cpu needlessly. I don't
> want to make too intrusive changes right now.

I thought you already did that too :)

johannes

--=-uIULExfBoPLQntE8cChU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJw2UTAAoJEKVg1VMiehFYVd0P/A0tobALU48SdpCu7VE22dYo
Vw73+TWMi2YrAby3N1VMmHUKPjyxRvHNYfXxDp4FAFxBvx7IPsQ0VDd8Xx7WuVQm
4OIX/6Qa2vaRrLYsblAmNMKlJCxNiDEruFEGsVx2PQbbOwdS07OAPXPaP9y/mbyO
HqJpxm6q4Qy5y/JhKXpdHEm7tWOaqh0Imw8jXp4ArV6B4jMhkFfuEm7wDQZrlFwo
q1v6AXEhr05qX6G0028kDP4naVV0f/D1d58MmFSdWnnc+yQev9x3Il+Pa2aMWlqX
IVNUL9SlS95ydYqgfCRcVqPbJ3r13pVVap3sCApZjbBkT4tpMEWxNlCW83cr6yK2
ccrYHABo7QfLn0RB80Zo/Qt2SpC5g6vbTRwPyyVq0kVQ8FJhopqSefAs4snka+ek
mR7yiqhNbvFGUPvYMHbnY1ATCABAA8WiZ4qTo+D/vAxgdaJsVhNfZwyjjiHHev6P
NIAHMuexOytNGVH6tnl0XT9M7q15RQw+GF+bloabtp6G1WZqaWRs+JJaKwtVZV1o
p7SQTati8rNFZIvdd5aqmW3ovn6a2cxO3AcqsqTwhHqawLgkMkWszgHyb6tDtyG+
gg4rsrC+PM1vFR3CMG2pOxK9yfO1bzMvOllCePB2bhABjIlnFEJHNzUmr0CjOMmr
Q50mCtlsslKEQP5JH3Ai
=5xNI
-----END PGP SIGNATURE-----

--=-uIULExfBoPLQntE8cChU--

