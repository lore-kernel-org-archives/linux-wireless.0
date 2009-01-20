Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35236 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809AbZATKxk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2009 05:53:40 -0500
Subject: Re: [PATCH] mac80211: Add capability to enable/disable beaconing
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni.Malinen@Atheros.com
In-Reply-To: <18805.33791.193195.755178@gargle.gargle.HOWL>
References: <18805.33791.193195.755178@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0Rhod930F51Hge6/jIkm"
Date: Tue, 20 Jan 2009 11:52:59 +0100
Message-Id: <1232448779.20158.4.camel@johannes.local> (sfid-20090120_115345_204075_FA067EE8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0Rhod930F51Hge6/jIkm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

cOn Tue, 2009-01-20 at 13:27 +0530, Sujith wrote:
> This patch adds a flag to notify drivers to start and
> stop beaconing when needed, for example, during a scan run.


> +	if ((changed & IEEE80211_IFCC_BEACON) &&
> +	    (sdata->vif.type =3D=3D NL80211_IFTYPE_AP ||
> +	     sdata->vif.type =3D=3D NL80211_IFTYPE_ADHOC ||
> +	     sdata->vif.type =3D=3D NL80211_IFTYPE_MESH_POINT)) {
> +		if (local->sw_scanning || local->hw_scanning)
> +			conf.enable_beacon =3D false;
> +		else
> +			conf.enable_beacon =3D true;
> +	}
> +

You really just want to do the minimal thing, right? :)

That won't work when userspace disables the beacon by removing it, for
instance, right now drivers won't know when hostapd removed the beacon
except that ieee80211_beacon_get will start returning 0... Also, I think
a separate change flag would be appropriate, sometimes we might just
re-enable the beacon without having changed it, after scanning?

johannes

--=-0Rhod930F51Hge6/jIkm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJda0HAAoJEKVg1VMiehFYjlMP/ixqrgYHQTDqV+bV27DHtcuB
XDoxmrQ8w+W3UrCarYbwaS7qYflUmBrJmP37SMnRgoOEIcJSd9rbF3fXx49oK952
4awKq9lziE5p1bQBlef60PFvLkbhBowa0bvJawLNvKNiNvkwRPS4s1fLN0lla2Tz
dOdKaRroHZfziNjgLWYamFLHvjDFPOyA9ai/3Mh0fYXV1yKdsXQ7q62Bm1uV6wml
4xcIVBqkKF6wfftPgcoCthd04RP+25Ia/qimocRv3lBYNvyx66o3a0atYw+k8FPk
6SydN08nd1d972eOpFstO45lR4b8Q88QHfCW0A0noA9ZOrNflv1U4/kNvaKa/iVa
guYijmNCTPfilkKuGHJ6w7jsQT4KlN2U4fgpbNFKRJcmvydyrLLiBLr3n5AdyAR+
g2ITYOAfVB3Se+UEdtBpkRWjd/VvnhFaKPNSo7XtTunqjq650m6aAoXXh0iSejAC
CdaA5FvMPrmjw9X63u2VVug8enm8c7b5xkTV3OfcMcxsfExSL2zv07HGOqr3/7GI
VD+bT3yBwKRxhEyLQqKKAt5aIibAmnpUDz6kdT87FZTdjwX08PhBhXKM4KCSetrm
cEWa549o2pQ6rwlY3YHPqEb7CTQsNWrR1801qfzR8Ez/MLjHKONvStQIaRMEHMCX
0tncODykNIjfaSvEbei4
=hwhA
-----END PGP SIGNATURE-----

--=-0Rhod930F51Hge6/jIkm--

