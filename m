Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37946 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbZDVWkK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 18:40:10 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Lwl6s-0000v4-UG
	for linux-wireless@vger.kernel.org; Thu, 23 Apr 2009 00:40:07 +0200
Subject: on radio_enabled
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-hiLMxtnIG2OP+FhMvRY/"
Date: Thu, 23 Apr 2009 00:39:35 +0200
Message-Id: <1240439975.30082.66.camel@johannes.local> (sfid-20090423_004017_994884_20399A62)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hiLMxtnIG2OP+FhMvRY/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi!

So I was looking through various drivers, and not all of them are able
to handle radio_enabled gracefully.

iwlwifi, for instance, turns off the radio but then is unable to fulfil
any configuration requests coming in while the radio is disabled.

The same is true, if I remember correctly what Ivo told me, for rt2x00.

It is not true for b43/legacy, for example, which leaves the MAC running
and thus can configure everything even if the radio is disabled.
Similarly for Atheros hw, I think.

Now, if we're going to use radio_enabled more, I wonder whether we
should completely deconfigure the hardware when we want to turn off
radio_enabled, and then completely reconfigure it once we enable the
radio again.

Pros:
 * configures all hardware correctly without the driver needing to do
   everything by itself
 * works with all hardware for sure

Cons:
 * higher latency

Also, sometimes we may want to disable the radio for just short periods
of time, I think, for regulatory compliance? 11h or so? How's that
handled, or rather supposed to be?

johannes

--=-hiLMxtnIG2OP+FhMvRY/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ75ykAAoJEKVg1VMiehFYbMYP/1Xep2GYDY1CHb2eZTcCM7Wz
ClheqrKJ/6j3wDAIu7IZQa6fuKAunJfaBixHWm1IdCfsgzkcpkFJKvXn7a+MDIse
dARgsT6/hUrAy1tXSSdCTSRk3F9aKxQw9Smw0M+n9iES/MIZpwi+7/4xNtIoej27
LlLRwpSa6gfXrtk/0ttsUeLv5/XcSQg6N5loK53ocCLzvcdRDSRVP9gcEzpl+3uI
p3QhQeK7iFXq4EgnOV6qz3G6qqp3eR+SJNInMpu24sdlBBov12yt+UOXchdRG7vK
IuplGqXYzStJrvzUNs13v2VdwvzipgVcR4crGBkxs/u7hZkaaMQ7cTKFpk7RCRIy
9+AU2eIivmE7AHnFhRHjkUg7pDt/XNufyJqJ6JCOkoaQlFIY5Ap9Gmb2gX97mPic
RGgatd98RQybRIGvKwhKBAKqKUWb9Q/6o+qWE7PfFmwEuf0Mejj38ledhUqQKOeG
AjjWh1qckkY7CsFeUfY1fCvNYCdGo1EnMU+d+WajYy8SvNF6lj7SCPHp8hWnAecf
3DL62XTGNlp1pvjqJVTB3zhNV5SrhnlAwN7rdSdhlXLugBlcMrnQuyRfl4jFy5UB
3osCtu7NKrTlVpbB//2cvVvMvcXRiiuCbKH5Rwr1rwIHzh1zTwQMbMqlQY3NtE1Q
tXkMupi1IY/0q4HaEofo
=XbCm
-----END PGP SIGNATURE-----

--=-hiLMxtnIG2OP+FhMvRY/--

