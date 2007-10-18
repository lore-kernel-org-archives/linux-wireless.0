Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:11677 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750802AbXJRBla (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Oct 2007 21:41:30 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [PATCH 1/1] mac80211: adding bss_config to low driver ops
Date: Wed, 17 Oct 2007 21:38:37 -0400
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
References: <11926651061687-git-send-email-tomas.winkler@intel.com>
In-Reply-To: <11926651061687-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2031122.aIXPfZJzxd";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200710172138.41444.flamingice@sourmilk.net> (sfid-20071018_024133_968047_F2EC9208)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2031122.aIXPfZJzxd
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 17 October 2007 19:51:46 you wrote:
> +#define ASSOC_CHNAGED_STATE     (1<<0)
> +#define ASSOC_CHNAGED_AID       (1<<1)
> +#define ASSOC_CHNAGED_ERP       (1<<2)
> +#define ASSOC_CHNAGED_WMM       (1<<3)
> +
s/CHNAGED/CHANGED/

> +		wrqu.ap_addr.sa_family =3D ARPHRD_ETHER;
> +		wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
> +		ifsta->last_probe =3D jiffies;
> +		ieee80211_led_assoc(local, bss_data->assoc);
The SIOCGIOAP event should happen on both association and disassociation, n=
ot=20
just association.

=2DMichael Wu

--nextPart2031122.aIXPfZJzxd
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHFrkhT3Oqt9AH4aERAqvvAKCxarF4FCGZyCWsCSwj9eUXVGeiNwCcD/F6
gFHoP05JrUaIN1W1TFI9lDc=
=qPnU
-----END PGP SIGNATURE-----

--nextPart2031122.aIXPfZJzxd--
