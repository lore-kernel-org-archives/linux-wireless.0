Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58326 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbZJPLgL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 07:36:11 -0400
Subject: Re: [PATCH] mac80211: fix SME warning by removing stale BSS upon
 assoc failure
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ic.felix@gmail.com" <ic.felix@gmail.com>
In-Reply-To: <20091014233528.GA4172@tux>
References: <1255481442-27130-1-git-send-email-lrodriguez@atheros.com>
	 <1255562895.4095.297.camel@johannes.local>  <20091014233528.GA4172@tux>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-V3VI1o5DgK962pDrEAc/"
Date: Fri, 16 Oct 2009 18:31:32 +0900
Message-Id: <1255685492.4095.309.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-V3VI1o5DgK962pDrEAc/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-10-14 at 16:35 -0700, Luis R. Rodriguez wrote:

> Well sure, but why do we want to keep the authentication present if
> association failed? And as a matter of fact it lingers there forever.
> Is that desired behaviour?

Yes, well, the SME is supposed to clean it up or try the association
again (possibly with different parameters in the IEs, e.g. different WPA
settings). The cfg80211 SME certainly does so (it deauthenticates).

> > > +++ b/net/mac80211/mlme.c
> > > @@ -1463,11 +1463,11 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee80211=
_sub_if_data *sdata,
> > >  	if (status_code !=3D WLAN_STATUS_SUCCESS) {
> > >  		printk(KERN_DEBUG "%s: AP denied association (code=3D%d)\n",
> > >  		       sdata->dev->name, status_code);
> > >  		list_del(&wk->list);
> > >  		kfree(wk);
> > > -		return RX_MGMT_CFG80211_ASSOC;
> > > +		return RX_MGMT_CFG80211_DEAUTH;
> >=20
> > I'm sure this is correct. Maybe cfg80211 doesn't react properly to
> > getting an assoc frame with non-zero status?
>=20
> I see, will have to take a look when I get a chance then, not now though.

> Actually can you elaborate a little on the logic here as to why
> we want to issue an association command with non-zero status to
> cfg80211 instead of just knocking off the current authentication
> and killing the BSS?

Is the above sufficient? Btw, please don't talk about "killing the BSS",
you're not talking about a BSS struct but rather one of the mlme work
structs.

johannes

--=-V3VI1o5DgK962pDrEAc/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK2D1vAAoJEODzc/N7+QmaanoP/0jW6Gz4UPtAHGFumWb+1Yzc
kC8d2VeVksJlh9hJ1c+z5EB5hQJANbQn34ZK2axMcWSgdXQkDDj25SpgRMsskvpM
WxLlouzQNMSvRaYDAhEWQCYuh3YZ2HNZ0GVT/ogF9hiv7p9+8lDUZN6bRF8jOWkr
Fbg3JSXmhtbkxLqgAcsxfktv7XSooeOZ97EONXUbaAoov0sA1zVFSLO1r9KtaAmF
cfehxpfuWdA1DdwcyZVww766FvU2/Q5CWuHUKUFM9ASDOcSZu4jV0w/KfTZ6jAc/
rSdZB7K3C/IxERPbyklrGxceyOVlzWDfLnTCHzQxi5UwAHT9oaSNBwmPQARZWg6o
MYEe1MaXvNpF3jKoKF3aykziU5MfQzgBz+TxuhMHQfHi98WPMPCDu2Ju9tcu7480
Oc193wdS0j7YmGXNckf1BVESPPW/x8gK6k42sfUPSoI0CUGIqcM7idkZRA07+H3l
Dk9ZWQQ2LwoUTg9rQ4oRKTU0F5r1301qffMr92Fv92AAzlIV7E2um0hHum7vJCpV
kZNlbACo28Z0p1my+Kr6akOO/80JlBHxSmG87lAkPU2efH/VuGNODKurDZno0SYb
hDrKafXpTFtOssgpYtpxjgt9waXdSvMJFaMFjtbauY+xkJLtsLfuZJFzACK0CuQ6
RlFqBJeYF2rXyWRwJHLy
=fnUE
-----END PGP SIGNATURE-----

--=-V3VI1o5DgK962pDrEAc/--

