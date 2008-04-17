Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58085 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756730AbYDQR1B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2008 13:27:01 -0400
Subject: Re: [PATCH v3] mac80211: Replace ieee80211_tx_control->key_idx
	with ieee80211_key_conf
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <200804171923.41533.IvDoorn@gmail.com> (sfid-20080417_181910_751602_D6EDEAA9)
References: <200804171728.30188.IvDoorn@gmail.com>
	 <200804171759.54830.IvDoorn@gmail.com>
	 <200804171923.41533.IvDoorn@gmail.com>
	 (sfid-20080417_181910_751602_D6EDEAA9)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-oXXIereXqJ0YBlDDPRFE"
Date: Thu, 17 Apr 2008 19:26:49 +0200
Message-Id: <1208453209.4066.34.camel@johannes.berg> (sfid-20080417_182710_710020_5ECE86AB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oXXIereXqJ0YBlDDPRFE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

I hate to do this, but

>  /* Transmit control fields. This data structure is passed to low-level d=
river
>   * with each TX frame. The low-level driver is responsible for configuri=
ng
> - * the hardware to use given values (depending on what is supported). */
> -
> + * the hardware to use given values (depending on what is supported).
> + *
> + * NOTE: All pointers within this structure are only valid until
> + * ieee80211_ops->tx() returns. If the information is required
> + * at a later time (i.e. when defering the work to a workqueue)
> + * make sure that not only the contents of struct ieee80211_tx_control
> + * is copied, but also the data where the pointers refer to. */

This isn't true for all pointers, the rate pointers point into the array
rate array so they're valid until the phy is unregistered, the vif
pointer is valid until the interface is removed via the appropriate
callback (remove_interface? I forgot), and the key until that is removed
via set_key().

Maybe we should add that instead? Normally, people will not need the
pointers outside ->tx() though, of course.

Also, please move the */ to a new line while you're at it anyway.

Other than that,

Acked-by: Johannes Berg <johannes@sipsolutions.net>

johannes

--=-oXXIereXqJ0YBlDDPRFE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASAeIWKVg1VMiehFYAQL9NA//QPGivSdMKR//jC53ab+//5P1zmekN9wD
9Pu+B9AMEXPUVd9eXFzRj7rbgpUjZ543kXHtUtottqCtDiYEWACqNPzgRMv9lx+9
44v/ROjJtlLQ41TGYW1460208pd/ZjtTRjAcgnWH0yr9Rnj73a1xVjuiR/PhtJwe
dJNT9wDwuykWMkC4XvDnNXPc/sQ86X3OUTalDReRjQmncjn2nds7K6u5FR8WuYc+
sY7cxbzdIosjETlfd478wPmETQUkQmHA/Ox5LCi2e7Fy+FELlAWBNqoGIgj0pY8B
j2+jD1dnBuTJjQwgaLP/MPCL01qJwZ+rjaPtrZrJ1Ml49e4UNZxk8nzgvgR0A2BT
7JG0Pqs8vv1fQ56qBCuW4qcuRbQjLmGbDtB7u4zAazsE0m5E8z7MPvQuGcLTU5Rd
8TRcgorp2U4NscfPvku/u/Jy/4nabqMvvaK8nqYqqkYWH1Yj/qMZnJZFnuOA5NRE
w6Ja8RnP1FuCIqm/3i1n+W84OxYFv+WfpUEUpAhX85xuEjXqO+KoARKVq7ihl8ww
ARG+uqYnfsN6Yd6FdEmTiv2OEvA3mwBleBSdIcP8aCXDMMtwIiKeRlQM+Lqn+eYS
cNcCveLzdNrpmdk6thH1PThKsBUPqlCqphOif80lDkT8P6NwHEILPrmPGe6GqJ5+
pbzz6udKaRM=
=3+gf
-----END PGP SIGNATURE-----

--=-oXXIereXqJ0YBlDDPRFE--

