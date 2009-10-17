Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38202 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbZJQA2E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 20:28:04 -0400
Subject: Re: [PATCH] mac80211: fix SME warning by removing stale BSS upon
 assoc failure
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ic.felix@gmail.com" <ic.felix@gmail.com>
In-Reply-To: <20091016182039.GC6438@tuxdriver.com>
References: <1255481442-27130-1-git-send-email-lrodriguez@atheros.com>
	 <1255562895.4095.297.camel@johannes.local> <20091014233528.GA4172@tux>
	 <1255685492.4095.309.camel@johannes.local>
	 <20091016182039.GC6438@tuxdriver.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-DhVq75+gqotefz2/qtQU"
Date: Sat, 17 Oct 2009 09:28:00 +0900
Message-Id: <1255739280.4095.343.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DhVq75+gqotefz2/qtQU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-10-16 at 14:20 -0400, John W. Linville wrote:
> On Fri, Oct 16, 2009 at 06:31:32PM +0900, Johannes Berg wrote:
> > On Wed, 2009-10-14 at 16:35 -0700, Luis R. Rodriguez wrote:
> >=20
> > > Well sure, but why do we want to keep the authentication present if
> > > association failed? And as a matter of fact it lingers there forever.
> > > Is that desired behaviour?
> >=20
> > Yes, well, the SME is supposed to clean it up or try the association
> > again (possibly with different parameters in the IEs, e.g. different WP=
A
> > settings). The cfg80211 SME certainly does so (it deauthenticates).
> >=20
> > > > > +++ b/net/mac80211/mlme.c
> > > > > @@ -1463,11 +1463,11 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee8=
0211_sub_if_data *sdata,
> > > > >  	if (status_code !=3D WLAN_STATUS_SUCCESS) {
> > > > >  		printk(KERN_DEBUG "%s: AP denied association (code=3D%d)\n",
> > > > >  		       sdata->dev->name, status_code);
> > > > >  		list_del(&wk->list);
> > > > >  		kfree(wk);
> > > > > -		return RX_MGMT_CFG80211_ASSOC;
> > > > > +		return RX_MGMT_CFG80211_DEAUTH;
> > > >=20
> > > > I'm sure this is correct. Maybe cfg80211 doesn't react properly to
> > > > getting an assoc frame with non-zero status?
> > >=20
> > > I see, will have to take a look when I get a chance then, not now tho=
ugh.
> >=20
> > > Actually can you elaborate a little on the logic here as to why
> > > we want to issue an association command with non-zero status to
> > > cfg80211 instead of just knocking off the current authentication
> > > and killing the BSS?
> >=20
> > Is the above sufficient? Btw, please don't talk about "killing the BSS"=
,
> > you're not talking about a BSS struct but rather one of the mlme work
> > structs.
>=20
> So, should this patch be dropped?  It is currently in w-t...

Yes.

johannes

--=-DhVq75+gqotefz2/qtQU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK2Q+KAAoJEODzc/N7+QmafXcQAMobVMYrCuV/m6yrLXN5Vpiw
2VcPdchXSJ3ZhCH9b4bQRc6J5rEfk/8txbcb44b2ltQYBkYg1Q+08Tb78IaxZqao
xDmssmbsubYfsSnexw6MXD0e06zheMo9ogn5GARseAp/qIkTVmnfPwzRkxIgdhCS
mMhxP/GuIKcdXuTvewrDfD/qW3He+KOVc6cciDXXvkYbOP3K2vjSn0pUmennkWyN
n8Z3drtWGGZz4QoPg0q/nf/OifiZQyDozi/EWXxxKEJ61ee3dIK+rFgVoCuk+WRb
RiQ/cZ9hEHv6zNYrHUsQrnxi11vXOI/c5kQYJgAuAUuyQNuxyli7RxwmWmdeSwwj
n3qsijLgXStNkN4q0gBEXUc65c48QP2qlef6K/i+0kQBsfPGBZGb14BVcF2Qa8FA
NyP7MrA5bXO2KpVTxJ7NM51H2CgymUP8WE82N5HUjUr3oRm6M6KooUI2aQZ7FkYw
srliUt1ktBbt5IQNXL76cjhD1okQvM6PWVf2EV5mKwLxP6hNt6ZscXXmnDj4oz4W
uXwcAAY6uCoRyKKR2byjKL115uH7/kTVp01wm25jxfQyuTwe8NdhIyjvkFXpSxh0
Do46qZ7Fj+TuCVh3G28O/ggiqi/V0YTxSsNHj1JBk9ipdvNjsxfALNNoH4i8E6wU
+KFdF2tnECxycTI03Yln
=ULAq
-----END PGP SIGNATURE-----

--=-DhVq75+gqotefz2/qtQU--

