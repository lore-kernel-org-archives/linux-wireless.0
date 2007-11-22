Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50210 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbXKVM73 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2007 07:59:29 -0500
Subject: Re: [PATCH] mac80211: free ifsta->extra_ie in ieee80211_stop
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1195701022.3250.496.camel@debian.sh.intel.com>
References: <11955417361539-git-send-email-yi.zhu@intel.com>
	 <1195565876.10920.29.camel@johannes.berg>
	 <1195615039.3250.453.camel@debian.sh.intel.com>
	 <1195658389.12000.26.camel@johannes.berg>
	 <1195701022.3250.496.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-O+o53ly3vOmV5TJzfut5"
Date: Thu, 22 Nov 2007 13:59:20 +0100
Message-Id: <1195736360.6323.91.camel@johannes.berg> (sfid-20071122_125931_344496_C5850965)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-O+o53ly3vOmV5TJzfut5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Thu, 2007-11-22 at 11:10 +0800, Zhu Yi wrote:
> On Wed, 2007-11-21 at 16:19 +0100, Johannes Berg wrote:
> > Yeah. Can you amend the patch to also clear the
> > IEEE80211_STA_PRIVACY_INVOKED flag?
>=20
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>

And if you adjust the patch subject now and fill in the description you
have my
Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>=20
> diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
> index 59350b8..69daf0a 100644
> --- a/net/mac80211/ieee80211.c
> +++ b/net/mac80211/ieee80211.c
> @@ -357,6 +357,11 @@ static int ieee80211_stop(struct net_device *dev)
>  			cancel_delayed_work(&local->scan_work);
>  		}
>  		flush_workqueue(local->hw.workqueue);
> +
> +		sdata->u.sta.flags &=3D ~IEEE80211_STA_PRIVACY_INVOKED;
> +		kfree(sdata->u.sta.extra_ie);
> +		sdata->u.sta.extra_ie =3D NULL;
> +		sdata->u.sta.extra_ie_len =3D 0;
>  		/* fall through */
>  	default:
>  		conf.if_id =3D dev->ifindex;
>=20

--=-O+o53ly3vOmV5TJzfut5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0V9JqVg1VMiehFYAQLpiw//V73amq/drJeO2o0vEBKoJZ4tHg0k5ceJ
vCHLBdenQUm8yfGOuslADvQD4Na8B+bRI/BltoXRqG9bB0dyLoRv1LM/hx6brGZp
7b1KNIqxr4SKuZ8tI/OtzzAJBKyet1HnmF7SPi9HuvFqcwGWiZRGKY2ctA8UJ1G/
5NKT2vFI1L82+8XXQB50SCZKk4G0ARma/ScZHdTHGOlxw7QsLLhFt7DSZz7mFEw1
sPJq7CzFCXBaV9Xx1+n/AwUul4yyx6uFOO4MKXi3F72SyZpr+A1xYfOo0vzmRL/4
YML2kKf45hmWfUnCmdWlnuUC8+Uqtt/zN+BVc3RmpUROBDR/foLEPdNTlL6PaP2F
SkhvtKfb89d6cdrEBXNaWhBRG6cb1mXwcYhTyLZg1zvDd6pojlbdX6GjO1DIg7Hb
S0IjIQBFsI2BpvxjEGqt/d3e3gJ/7VEE2lJMalPhkke4i7hw+La58m4VXlL+HLXb
DNuJGVxDrj2nKrCdDN8BM2EScWXG20K1tcYxs5eTDNP9xFiTTfiDHM3SF8luEJUS
j7N34lp/KPmqkEUtetUStB886q0lR8Tt9W3DeDc+9eCX+eOEZfa7ZGWOQR+mWL08
8KjRq/mKnAIc5bOqzGM2Mb2GOmGrrz8XJCGgpo7Mez8YzrR8j99SCvn1w3g+Ox7N
0RDmC1GZhpI=
=kwi6
-----END PGP SIGNATURE-----

--=-O+o53ly3vOmV5TJzfut5--

