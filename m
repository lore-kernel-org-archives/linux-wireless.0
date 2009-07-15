Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57137 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462AbZGOQGh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 12:06:37 -0400
Subject: Re: [PATCH 01/21] mac80211: drop frames for sta with no valid rate
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
In-Reply-To: <20090715145601.GA5682@mosca>
References: <1247616853-11221-1-git-send-email-lrodriguez@atheros.com>
	 <1247616853-11221-2-git-send-email-lrodriguez@atheros.com>
	 <1247659121.2477.1.camel@johannes.local>  <20090715145601.GA5682@mosca>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-wRxGNqHf8Kodj3XuCB6y"
Date: Wed, 15 Jul 2009 18:05:45 +0200
Message-Id: <1247673945.10754.15.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wRxGNqHf8Kodj3XuCB6y
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-07-15 at 07:56 -0700, Luis R. Rodriguez wrote:
> On Wed, Jul 15, 2009 at 04:58:41AM -0700, Johannes Berg wrote:
> > On Tue, 2009-07-14 at 20:13 -0400, Luis R. Rodriguez wrote:
> >=20
> > > +	if (unlikely((tx->local->sw_scanning) &&
> > > +	    (sta_flags & WLAN_STA_ASSOC) &&
> > > +	    !rate_usable_index_exists(sband, &tx->sta->sta))) {
> > > +#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
> > > +		printk(KERN_DEBUG "%s: dropped data frame -- no "
> > > +		       "supported rate for station %pM on %c GHz band\n",
> > > +		       tx->dev->name, hdr->addr1,
> > > +		       tx->channel->band ? '5' : '2');
> > > +#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
> > > +		WARN_ON(1);
> > > +		return TX_DROP;
> >=20
> > Can you use WARN(),
>=20
> sure.
>=20
> > and put it into the if() please?
>=20
> It is already in the if() branch, do you mean in the #ifdef?

No, I mean if (WARN(...)) return TX_DROP;

johannes

--=-wRxGNqHf8Kodj3XuCB6y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKXf5WAAoJEODzc/N7+QmaI6IQAM0FCjX9NpMReDjqglfCyDfD
/mUmpijLRQ1krKw5elXu5kpMtJAmXZ8v6Vob0d5aDbtvVIIOOk7MqCGMjJbt+d4x
DWJCpPh7sjtBTXd2/tR3CIFu4C7k4/1GRHo2bg1XyoGbwwBEgrGp8mnxVq6lcEjn
lin6UJwa+zkf1+/vSsPJb0yvJN4D+oK7TNEqkhclCdNebjI29i+GVX15QHHXeWCW
uljrR2R6GTqe9iN/oyg88p/7o0eQC4NU+UDYonxhOS9RiOlYQNOh7i9Tt9P1yYIp
D6RgrM/ufUTkCROsNkRO7daPWt4QOtdGZVuy3CXYELtyc1AJhbM2EX449TJWnF8j
NEiZmh+hUGwS1SfRCalVqF+k99yps5oCGi3OOBe9WhC8p6hfWNpxdIedqLtE8daE
Io8VCSn77fQHYciKbK1Qh7iBzpsSIb7PF6P23pHAdBV6eqyfKhH8In3rkv0wCKNp
jgurr+S4IIEE/cefazwFRnypRbvAub40bN1+oSz7DnhCA8KbJbhSgY+w0ni+je4G
huDzsv9zloF9iZom+U0PFP83UlV9JpVRmclndBifky5ti0jG/OPwOiYGP7FWAwsh
ixRcMKjC6g2Sq0mB/sJlbVYlO0/LqSMIBiTE1M0fT2h3GTF7ogHBxAVWwtXcNx0W
EvARRdF0VGCoXtl22Itg
=Hc3q
-----END PGP SIGNATURE-----

--=-wRxGNqHf8Kodj3XuCB6y--

