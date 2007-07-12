Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49284 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932713AbXGMJG6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2007 05:06:58 -0400
Subject: Re: [PATCH 1/1] mac80211: Replace overly "sticky" averaging  filters for rssi, signal, noise.
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: benmcahill@gmail.com, flamingice@sourmilk.net,
	linux-wireless@vger.kernel.org, ben.m.cahill@intel.com
In-Reply-To: <20070711022508.36db6129@logostar.upir.cz>
References: <11841087052370-git-send-email-ben.m.cahill@intel.com>
	 <20070711022508.36db6129@logostar.upir.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sKd8CnypWeHc+zeVcWXo"
Date: Thu, 12 Jul 2007 23:15:36 +0200
Message-Id: <1184274936.6669.72.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sKd8CnypWeHc+zeVcWXo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-07-11 at 02:25 +0200, Jiri Benc wrote:

> > +	/* Quantize the averages (divide by 16) */
> > +	sta->last_rssi =3D sta->accum_rssi >> 4;
> > +	sta->last_signal =3D sta->accum_signal >> 4;
> > +	sta->last_noise =3D sta->accum_noise >> 4;
>=20
> First, do not obfuscate the code, please. If you want to divide by 16,
> divide by 16. The compiler is perfectly capable of optimizing it.

No, you're wrong, the compiler can only optimise that if it knows for
sure that the values can't ever be negative. And quoting the patch
further below:

> +	int accum_rssi; /* hi-precision running average (rssi * 16) */
> +	int accum_signal; /* hi-precision average (signal-quality * 16) */
> +	int accum_noise; /* hi-precision running average (noise * 16) */

The compiler does some tricks to avoid the integer division IIRC but it
can't do a simple shift. But in principle you're right, the code should
say "/ 16" because either the variables need to be made unsigned (only
positive values are put into them) or using a shift is wrong (if
negative values can happpen)

Oh btw, is this the difference between "moving average" and "running
average"?

With the algorithm as I see it, each update is done by
update(new_value):
  avg =3D 15/16*avg + new_value

which means that all old samples are still influencing the current
output.

Doing two updates (update(a), update(b)) yields:
avg =3D 15/16 * (15/16*orig + a) + b =3D 225/256 * orig + 15/16 * a + b

And after 16 updates the original values still has an influence of about
3.5% on the output value:
update(a_0),...,update(a_15):
avg =3D (15/16)^16*orig + \sum_{i=3D0}^{15} (15/16)^i * a_i
    =3D 0.3560*orig + 0.3798*a_0 + ... (sum of coefficients is ~10.30)

Is this really what we want? Wouldn't it be better to have a ringbuffer
of the last 16 values and really do an average over those? [which is
what I understand as "moving average"]

johannes

--=-sKd8CnypWeHc+zeVcWXo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGlpn4/ETPhpq3jKURAsT0AKCJeVj2MIEn52BdIeOwM8iXnF6cvwCfYcZx
8QkB9o1ynse1W32HHm2/44U=
=rd8/
-----END PGP SIGNATURE-----

--=-sKd8CnypWeHc+zeVcWXo--

