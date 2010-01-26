Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38852 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab0AZIJ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2010 03:09:57 -0500
Subject: Re: [PATCH] mac80211: fix NULL pointer dereference when ftrace is
 enabled
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	stable@kernel.org
In-Reply-To: <1264492737-16877-1-git-send-email-yi.zhu@intel.com>
References: <1264492737-16877-1-git-send-email-yi.zhu@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-mO3+08envJCXB2yWCU5W"
Date: Tue, 26 Jan 2010 09:09:48 +0100
Message-ID: <1264493389.25642.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mO3+08envJCXB2yWCU5W
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2010-01-26 at 15:58 +0800, Zhu Yi wrote:
> I got below kernel oops when I try to bring down the network interface if
> ftrace is enabled. The root cause is drv_ampdu_action() is passed with a
> NULL ssn pointer in the BA session tear down case. We need to check and
> avoid dereferencing it in trace entry assignment.

>  		__entry->tid =3D tid;
> -		__entry->ssn =3D *ssn;
> +		__entry->ssn =3D ssn ? *ssn : 0;
>  	),

Good catch, thanks.

johannes

--=-mO3+08envJCXB2yWCU5W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLXqNIAAoJEODzc/N7+Qmae0YQAM/RZN6vQLEMJ6iKs9KimUi3
MaA1PIXDAfJigmaZX9PbSMBizNS/IMnxsv7AhdpwErg59+94OIRt374hMseN3AHW
uSTGGG2DhD4gLdxkBuq3wK4iIkBFExNdaBpXyIS2XlUK9kkgKb9gTza3CZif+5wY
s31/bPlVXQL7wR+OojCPqCU5coA3ClTKaknlYjZ5iPKpzVqIpTFCi38Bzd+v/V67
CSy1vcs63k7ow9cOchpTCODNLTL+wr5wRIjFUh9S0ywWMz7JwGJ2m8RxfyyrXR4V
RKoW+KuEqlB6VdyW/YOi4IuEJ99UglT5h3YeBTq9HA/VAEIbqRlzNuDgFQAaB9bp
hz+RgJ/MC0ZVNMCzMrTIkgECB992LmDQ2Q1kfJdkjcQL50+Lp24OeTmcZD1IO8iL
9AfTPOfxmIP5w5Z3bZ9vTjQS6ekKWDCHWuKzLJP5dgtdxpxWgSdnLPSMu3x4VJ/E
o5NCmAhXYUfD+0dMU0pqQ3pvZTixeuV/HOqZwS06Spr4vNfFsb5FlB9ea67TtgIW
bFApe8C95+t+dVY7W7BNi/KOSw02JA9QoA2vfuX6ke45ZeRnjue+vxUINso2SGKC
Qc2w2nS6rQW7XzS+n9rNDGLsf/PP1KyGvYLD0g/GRMJ9ipb3AJ42lCM5XVbROSl8
x3ndCGOsXRXCwJeTOjJ1
=XBnv
-----END PGP SIGNATURE-----

--=-mO3+08envJCXB2yWCU5W--

