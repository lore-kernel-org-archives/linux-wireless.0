Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39706 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbZG3OTQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 10:19:16 -0400
Subject: Re: [RFC PATCH] mac80211: FIF_PSPOLL filter flag
From: Johannes Berg <johannes@sipsolutions.net>
To: Igor Perminov <igor.perminov@inbox.ru>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1248962000.29068.170.camel@sunlight>
References: <1248962000.29068.170.camel@sunlight>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-KSIU7OVnBp9CU7GwVvcZ"
Date: Thu, 30 Jul 2009 16:18:45 +0200
Message-Id: <1248963525.16129.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KSIU7OVnBp9CU7GwVvcZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-30 at 17:53 +0400, Igor Perminov wrote:

> @@ -245,6 +247,14 @@ static int ieee80211_open(struct net_device *dev)
> =20
>  			ieee80211_start_mesh(sdata);
>  		}
> +		else if (sdata->vif.type =3D=3D NL80211_IFTYPE_AP) {

Put 'else if' on the same line as '}' please

> +		if (sdata->u.mntr_flags & MONITOR_FLAG_CONTROL) {
> +			local->fif_pspoll--;
>  			local->fif_control--;
> +		}

Yeah, that's exactly what I was thinking of :)

> @@ -497,6 +509,13 @@ static int ieee80211_stop(struct net_device *dev)
>  		}
>  		/* fall through */
>  	default:
> +		if (sdata->vif.type =3D=3D NL80211_IFTYPE_AP) {

I'd probably put this after a
	case NL80211_IFTYPE_AP:
label but you need the if () anyway ... hmm I guess we really should
clean up this code and split it into two switch statements...

johannes

--=-KSIU7OVnBp9CU7GwVvcZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKcau/AAoJEODzc/N7+Qma/fIQAJKg+cpEZq9ZsJ2E4nYMgpao
76IV9Hh4j2Kk1vxc280eoXJSLv6UCsct2HIKWjEU0vXRnnsSmSUkHGqUs7cn/bc4
OFDDWQbJFcC2HFRFi1/9A17f4W6hDjRaVRgacZe1qfkzFUVGFBEEvhgCWJoHuuTv
bLl+Y2pARLHfbLE2oo2XG1e+gFdTWbjqhjqF4UFQk/MpEGf6azsCqazcoBwTG2Aw
OaCpH/34ZwWFgYSl3I+yBu++7/WXVQsS3bChsRaqryT2cBAw2Gidmzt49Gx8pADG
2lTniPQBPAEl6CfPKXJx+j/pWtWs3LsmeyCTdUAVjbnM2w1iETUIr0bX+ATx6H+I
Y7cZscP6F/bpIJmCbaeCa5w9eP9j8b3NNwGCo4ZgV4MpuR/AkiDRR5hDVBtwXe/P
P7F3elXR4vTAFgcob/pK2N0VtaUig9UZyZN8P1OtvZmRajDzexLnLWepJSK+NED8
i0PcobndbgkVOvRaCMScWI3IVix6EFnT0cUEcIRdPEMHjhCGOQ/TknLchJjwO6xq
rhAhZWmI0NGlkepmeYxmacGnwt3bizZsap/XvJ+QTnMAp77ZbVWOINL+Tdl762TU
p3xetKY7rYp332l+dlfY/mXSqeS2QpxpdcF/zGzatXeK6VJX39w19dcaVGGj8Ihm
fjtLCAr4LBVldCEwhji8
=s5nH
-----END PGP SIGNATURE-----

--=-KSIU7OVnBp9CU7GwVvcZ--

