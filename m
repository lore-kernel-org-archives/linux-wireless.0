Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51064 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbXICITN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Sep 2007 04:19:13 -0400
Subject: Re: letting drivers choose their preferred rate scale
From: Johannes Berg <johannes@sipsolutions.net>
To: ian <ischram@telenet.be>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <46DB537E.8030801@telenet.be>
References: <46CF95F9.6090802@telenet.be>
	 <1188028962.9529.13.camel@johannes.berg> <46D01D57.6060806@telenet.be>
	 <1188211749.6756.11.camel@johannes.berg>
	 <20070831180933.GB3352@tuxdriver.com>  <46DB537E.8030801@telenet.be>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5sdxM1TiSX93MAp/eCuo"
Date: Mon, 03 Sep 2007 10:20:23 +0200
Message-Id: <1188807623.14564.13.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5sdxM1TiSX93MAp/eCuo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-09-03 at 02:21 +0200, ian wrote:

> I read up on the code and kernel mechanisms involved and this is
> what i came up with
>=20
> Right now there is no way of knowing what the "default" rc should be
> other than that it has a module alias rc80211_default, checking
> for this is probably not done, and would be pretty unpractical.
> And it wouldn't be settable from userspace in the future either.
>=20
> We could however replace "simple" with a user settable variable.
> (global variable in ieee80211.c like the rate_ctrl_algs and mutex,
> with some accessors for a module parameter/debugfs/..?)
>=20
> we could additionally remove the module_alias from rc80211_simple
>=20
> I don't know too much of the rest of mac80211 code and conventions,
> so feel free to be brutal if this patch makes no sense.
> ---
> Make rc80211_simple the default rate scaling algorithm
>=20
> Signed-of-by: Ian Schram <ischram@telenet.be>

I think along with the patch from James this should work, with simple
being the default. We should additionally have a debugfs file associated
with "local" that allows you to set the "simple" string you've used
there to something else. That also allows us to test the error path
there :P

> --- a/net/mac80211/ieee80211_rate.c	2007-09-03 01:26:18.000000000 +0200
> +++ b/net/mac80211/ieee80211_rate.c	2007-09-03 01:46:54.000000000 +0200
> @@ -62,7 +62,7 @@ ieee80211_try_rate_control_ops_get(const
>=20
>  	mutex_lock(&rate_ctrl_mutex);
>  	list_for_each_entry(alg, &rate_ctrl_algs, list) {
> -		if (!name || !strcmp(alg->ops->name, name))
> +		if (!strcmp(alg->ops->name, name))
>  			if (try_module_get(alg->ops->module)) {
>  				ops =3D alg->ops;
>  				break;
> @@ -78,11 +78,12 @@ static struct rate_control_ops *
>  ieee80211_rate_control_ops_get(const char *name)
>  {
>  	struct rate_control_ops *ops;
> +	const char *try_name =3D name ? name : "simple";
>=20
> -	ops =3D ieee80211_try_rate_control_ops_get(name);
> +	ops =3D ieee80211_try_rate_control_ops_get(try_name);
>  	if (!ops) {
> -		request_module("rc80211_%s", name ? name : "default");
> -		ops =3D ieee80211_try_rate_control_ops_get(name);
> +		request_module("rc80211_%s", try_name);
> +		ops =3D ieee80211_try_rate_control_ops_get(try_name);
>  	}
>  	return ops;
>  }
>=20
>=20
>=20

--=-5sdxM1TiSX93MAp/eCuo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG28PH/ETPhpq3jKURAmOTAKC2DSI8vqvs9ZeoimM6AW1x5iM6BACfXgNk
vaaHEgATBZR1LA6/RsjOgsY=
=fAVt
-----END PGP SIGNATURE-----

--=-5sdxM1TiSX93MAp/eCuo--

