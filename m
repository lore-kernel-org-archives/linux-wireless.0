Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:9165 "EHLO annwn14.rutgers.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752337AbXHCIEE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 04:04:04 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: mac80211 IPv6 problems
Date: Fri, 3 Aug 2007 01:02:12 -0700
Cc: David Woodhouse <dwmw2@infradead.org>,
	Daniel Drake <dsd@gentoo.org>, linux-wireless@vger.kernel.org,
	jbenc@suse.cz, Michael Buesch <mb@bu3sch.de>,
	Bcm43xx-dev@lists.berlios.de,
	Larry Finger <larry.finger@lwfinger.net>
References: <46b1fde0.b+weBDN75J0SPe2a%Larry.Finger@lwfinger.net> <1186094778.6701.6.camel@shinybook.infradead.org> <20070803005517.GA4261@tuxdriver.com>
In-Reply-To: <20070803005517.GA4261@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1256112.BM8N9uY2kE";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200708030102.17358.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1256112.BM8N9uY2kE
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 02 August 2007 17:55, John W. Linville wrote:
>  				} else if (!multicast &&
>  					   compare_ether_addr(sdata->dev->dev_addr,
> -							      hdr->addr1) !=3D 0) {
> +							      hdr->addr1)) {
Good idea. Should do this for all the other cases in the function to keep=20
things consistent.

>  					if (!sdata->promisc)
>  						continue;
>  					rx.u.rx.ra_match =3D 0;
> -				}
> +				} else if (multicast &&
> +					   !compare_ether_addr(sdata->dev->dev_addr,
> +							       hdr->addr3))
> +					rx.u.rx.ra_match =3D 0;
This doesn't seem quite right. I think ieee80211_rx_h_data is a safer place=
=20
for this check (inside the IEEE80211_FCTL_FROMDS case), and allows various=
=20
statistics to be updated. ieee80211_rx_h_sta_process is another function th=
at=20
might work though that would probably involve more code to add all the righ=
t=20
checks.

Another alternate is to continue - doing rx.u.rx.ra_match =3D 0; still pass=
es=20
the frame through the rx chain, though I think I'd prefer to update the=20
statistics.

=2DMichael Wu

--nextPart1256112.BM8N9uY2kE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGsuEJT3Oqt9AH4aERAnuJAJ9o5WlqZ4H3WVTG618AtvWomrC2GwCffEkB
Jt4lo0qx/Vr1X9LLIrI0WMU=
=gaZU
-----END PGP SIGNATURE-----

--nextPart1256112.BM8N9uY2kE--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
