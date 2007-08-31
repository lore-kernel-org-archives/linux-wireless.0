Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58702 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbXHaVus (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Aug 2007 17:50:48 -0400
Subject: Re: [PATCH] mac80211: don't send invalid QoS frames
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>,
	Kalle Valo <Kalle.Valo@nokia.com>
In-Reply-To: <1188483732.3978.13.camel@johannes.berg>
References: <1188483732.3978.13.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Mufl5UXYwufcLBBq8xm0"
Date: Fri, 31 Aug 2007 13:25:28 +0200
Message-Id: <1188559528.7585.35.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Mufl5UXYwufcLBBq8xm0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Oh, I see a bug.

On Thu, 2007-08-30 at 16:22 +0200, Johannes Berg wrote:

> +	if (fc & IEEE80211_STYPE_QOS_DATA) {
> +		__le16 *qos_control;
> +
> +		memcpy(skb_push(skb, hdrlen - 2), &hdr, hdrlen - 2);
> +		qos_control =3D (__le16*) skb_push(skb, 2);

These last two statements should be the other way around, of course.
We're pushing data into the head of the skb here, so we need to push the
QoS control field first and then the header. The way I wrote it there
the zeroed field ends up being the frame control field, indicating that
it's an association request frame. You should be seeing those as mangled
frames in wireshark though.

johannes

--=-Mufl5UXYwufcLBBq8xm0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG1/qn/ETPhpq3jKURAkc9AKCrvlLar5rJzR4wdoFGSEKxxy0bqwCeMItn
vmA05ur/NKKcQLR65m7xqQY=
=koag
-----END PGP SIGNATURE-----

--=-Mufl5UXYwufcLBBq8xm0--

