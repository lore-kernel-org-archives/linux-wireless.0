Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42342 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559AbZAWQey (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 11:34:54 -0500
Subject: Re: [RFC PATCH v2 2/2] mac80211: use ps-poll when dynamic power
	save mode is disabled
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: vivek.natraj@gmail.com, linux-wireless@vger.kernel.org
In-Reply-To: <20090122114546.31443.79387.stgit@tikku>
References: <20090122114240.31443.18218.stgit@tikku>
	 <20090122114546.31443.79387.stgit@tikku>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Ikh0Tn2GTW93wLg2xJVL"
Date: Thu, 22 Jan 2009 18:02:09 +0100
Message-Id: <1232643729.5819.3.camel@johannes.local> (sfid-20090123_173457_386284_3E60A873)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Ikh0Tn2GTW93wLg2xJVL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-22 at 13:45 +0200, Kalle Valo wrote:

> +	printk(KERN_DEBUG "sending ps-poll");

remove one, add another? Or forgot quilt refresh? :)

If we receive a frame, but don't send any, we'll still stay awake.
Should receiving update the dynamic timer as well, to avoid that case?
Here, I mean:

> @@ -1816,9 +1851,24 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80=
211_sub_if_data *sdata,
...
> +                       if (local->hw.conf.dynamic_ps_timeout > 0) {
> +                               local->hw.conf.flags &=3D ~IEEE80211_CONF=
_PS;
> +                               ieee80211_hw_config(local,
> +                                                   IEEE80211_CONF_CHANGE=
_PS);
> +                               ieee80211_send_nullfunc(local, sdata, 0);

johannes

--=-Ikh0Tn2GTW93wLg2xJVL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJeKaOAAoJEKVg1VMiehFYpd0P/iai0HURIeukvCgyhtw/v1pk
UybwiQR+SUmipVa7S13u3dGoq1YYdvXiYN94q9p6Yiqx4g6SF/nJv5EQx8xqaalb
Y60JXrBPi4vOgARPr9lQwGTTsJ1sgkCLl0Ei7kwDoAbbwgJe6PwkTUsx1lDRbnx3
xnHUCXptpNIMqaOvhJOGfzIgoPhUH1sKFSZjJkyHeC6GN/1O+w9+MNDoF8jTId5H
JCF/cf5JLyNH4K1mPmoMe5fIDsfj9YVbAgEYwXgoFzaahZKyrIjUB9ZxHcOMC2SN
uHgE41wPF9OjhKRzB/ow+9RQP6MDHY1bd33GTNseOpc+Y4Fark62tQpi3MOk9n7l
UgWVqXPubuA5s0DLJmQtYPBxX7csnhqkBlphiFbtAx4BRIowh8h9AaUK0cS1K/gs
Hiz/ulT+D3FMj/yskNUmq0ELiu0qIVQzUcrbbXJwRo61Af6hRK4M0lNfSWfQfmum
QRTpmBZ8yxDB9pMbAjQtLGAHDblRwuKFrYHTe36JYFzDzjMuCS3Qs0sOrcJEl2Il
obJhcm/slqZGqiKs9icdrh0Ufoy3p6uOP9uxWkXvknqCXn4hhA8FcjCKPVBjVYUt
ocZUeqxYa/LqAH5C/2KTjDtqDRhsySdJKhQEjwjmMurllCVqHSOJLzoBCxwW9L/h
iSFer1mcGGvzGN8DjV5M
=M8ZZ
-----END PGP SIGNATURE-----

--=-Ikh0Tn2GTW93wLg2xJVL--

