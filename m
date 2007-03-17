Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:48412 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751845AbXCQVwh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Mar 2007 17:52:37 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: andy@warmcat.com
Subject: Re: [PATCH 2/2] mac80211: Monitor mode radiotap-based packet injection
Date: Sat, 17 Mar 2007 17:51:46 -0400
Cc: linux-wireless@vger.kernel.org
References: <20070317105800.659633351@warmcat.com> <20070317110751.352850972@warmcat.com> <200703171730.33349.flamingice@sourmilk.net>
In-Reply-To: <200703171730.33349.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1348326.Pt6YK3Eef3";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200703171751.50898.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1348326.Pt6YK3Eef3
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 17 March 2007 17:30, Michael Wu wrote:
> > +		/* process and remove the injection radiotap header */
> > +
> > +	if(control->flags & IEEE80211_TXCTL_INJECTED_PACKET) {
>
> dev points to the virtual interface that the frame originally came in on.
> You can get sdata from that and figure out if the interface was a monitor
> interface.
>
Of course, this depends on ifindex being set properly.

You added:
	pkt_data->ifindex =3D  local->mdev->ifindex;

but in that same function, this is used instead:
	pkt_data->ifindex =3D sdata->dev->ifindex;

Which allows the master device to figure out which virtual interface the sk=
b=20
came from.

=2DMichael Wu

--nextPart1348326.Pt6YK3Eef3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF/GL2T3Oqt9AH4aERAk7vAKDMUzvFRSAQSbYfxFHjQY3VewmP6wCeIdv1
QXx6LQfwumGdBFSzNJ4NeZ4=
=Z8o4
-----END PGP SIGNATURE-----

--nextPart1348326.Pt6YK3Eef3--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
