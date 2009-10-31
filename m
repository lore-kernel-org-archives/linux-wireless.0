Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51374 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932977AbZJaTXe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Oct 2009 15:23:34 -0400
Subject: Re: [PATCH 14/15] iwlwifi: add SM PS support for 6x50 series
From: Johannes Berg <johannes@sipsolutions.net>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1257011058.8387.14.camel@wwguy-ubuntu>
References: <1256938578-9638-1-git-send-email-reinette.chatre@intel.com>
	 <1256938578-9638-15-git-send-email-reinette.chatre@intel.com>
	 <1256968411.3555.77.camel@johannes.local>
	 <1257011058.8387.14.camel@wwguy-ubuntu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ZmeeEguAGWqaAo7vGVs0"
Date: Sat, 31 Oct 2009 20:23:30 +0100
Message-ID: <1257017010.3555.139.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZmeeEguAGWqaAo7vGVs0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-10-31 at 10:44 -0700, Guy, Wey-Yi wrote:

> > >  	ht_info->cap |=3D IEEE80211_HT_CAP_SGI_20;
> > > -	ht_info->cap |=3D (IEEE80211_HT_CAP_SM_PS &
> > > -			     (WLAN_HT_CAP_SM_PS_DISABLED << 2));
> > > +	if (priv->cfg->support_sm_ps)
> > > +		ht_info->cap |=3D (IEEE80211_HT_CAP_SM_PS &
> > > +				     (WLAN_HT_CAP_SM_PS_DYNAMIC << 2));
> > > +	else
> > > +		ht_info->cap |=3D (IEEE80211_HT_CAP_SM_PS &
> > > +				     (WLAN_HT_CAP_SM_PS_DISABLED << 2));
> >=20
> > here we always and unconditionally advertise dynamic SM-PS mode?
>=20
> I am confuse, it is based on "priv->cfg->support_sm_ps", so it is not
> always dynamic SM-PS mode.

Right, sorry -- but here it _only_ depends on "support_sm_ps", whereas

> > > +	if (priv->cfg->support_sm_ps) {
> > > +		/* # Rx chains when idling and maybe trying to save power */
> > > +		switch (priv->current_ht_config.sm_ps) {

Here it also depends on current_ht_config.sm_ps, which is not very
useful. Using the AP setting is wrong, and above, assuming
"support_sm_ps" [1] is true, this should just always fall into the
dynamic case so the value "current_ht_config.sm_ps" isn't useful and can
imho be removed.

johannes

[1] which btw I'd have called "use_sm_ps" since all hardware supports it
afaik

--=-ZmeeEguAGWqaAo7vGVs0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK7I6vAAoJEODzc/N7+QmaMn0QAIazj62oHZoqwXpw49b1rVoQ
Sl7E/DuLg7AFbLEV67kihx1qkBU1UlFw16/VmbGcuMGomH69LN7p86EsUs86ah8l
s7SHDJEit4iMGURy2gva40FeedkpBb0uEHqwUqvXqkpsNCsaRx1UcEyYgQXe5tO2
Ge0KtyyPbgBwnRjqL2H090qbbW/4/eOjEsX4PKPCP/bLUh1bvlbr6PmfAFX4VTH5
rLK6kWrc7SICe1Os6ly6Zbq4E86xXBHGou4/pwbn5z5Dnz9rCJCDwvwNZ3sE5kB3
+fiELU/7JTYdQtIQajdJQelFhADL6wQjWfFVIkbYTUSXwxnCtnS5vzFts3L1GXOm
gz+pirSYthDqpiKQp5Rrt1Qw9fdJolGYkyCTXP9/AF/tlZ8OOcGxqdkK1Jgd5Gd4
vx7Tv/UUO8LxEZRPc9U3VDkh0EsQVd1QNWeGTQrgKfjY14l0b5u3A/4ahOdx+z0L
fkl5/OWm6lxiHa+kmwd6IMU77z4XCUy7tZVgnprFhGvtz8ZfXJ1KG6bFZZfBTv00
nMnsSq52+nBIFjCFYa3YStcHDaDtsnt9ormzAn0wmXpVMyebC5XxsYs4n8RmfyH/
s9+yL9owPi+qT/86JEgViD7wDh7s9dl9/r/XDxzjCZlbCca7d9Dhs3H+uB8QtGrz
T+fdHbd1fIxbN2yFjPcF
=WSyx
-----END PGP SIGNATURE-----

--=-ZmeeEguAGWqaAo7vGVs0--

