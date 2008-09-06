Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48847 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbYIFXo2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 19:44:28 -0400
Subject: Re: [PATCH 2/2 V2] mac80211: add direct probe before association
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
In-Reply-To: <1218240139-5009-1-git-send-email-tomas.winkler@intel.com> (sfid-20080809_020228_145527_D912EB5F)
References: <1218240139-5009-1-git-send-email-tomas.winkler@intel.com>
	 (sfid-20080809_020228_145527_D912EB5F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mnb7SDM3wEu0o3yTInQC"
Date: Sun, 07 Sep 2008 01:44:23 +0200
Message-Id: <1220744663.21016.28.camel@johannes.berg> (sfid-20080907_014444_613375_E2172763)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mnb7SDM3wEu0o3yTInQC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

I was just pondering rewriting parts of the state machine (and you've
already seen the other cleanups I did today) and found this:

> +	/* Direct probe is sent to broadcast address as some APs
> +	 * will not answer to direct packet in unassociated state.
> +	 */
> +	ieee80211_send_probe_req(dev, NULL,
> +				 ifsta->ssid, ifsta->ssid_len);

> +	/* direct probe may be part of the association flow */
> +	if (test_and_clear_bit(IEEE80211_STA_REQ_DIRECT_PROBE,
> +							&ifsta->request)) {
> +		printk(KERN_DEBUG "%s direct probe responded\n", dev->name);
> +		ieee80211_authenticate(dev, ifsta);

Doesn't the latter code have to check that the sender is the correct
one? First we broadcast the probe request, and then we may be getting
one from a different AP but still clear our direct probe association
flow step, no?

johannes

--=-mnb7SDM3wEu0o3yTInQC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIwxXTAAoJEKVg1VMiehFYLYkQAInupEzS3B3NGimkFPzqZiTr
r7HVdLkyciQBqtAnIZqFvhYlPwHEQ0xKY8rAvIjag5LJubO+9hvwSojubWSV6oOT
5PsSDPfTnZf6xp5dWJ7Bgprf3srGrljFmqGW88LBLRMiMhjkMnOHR64krLLxdqk/
HMYR/6b0E3SvDuhMS0XQxeXUr3bfaFNrNY2eTB55K0rxroZUpXBvW0gaR2fWSV/e
AhruONA2TzrMU6A9Hdo/gGLZvVojY8Ey9TzjQDXSgtBUe4zqKqIVT45XfSRZjLmj
tKKmezEQtv6bftZfgvSJTg9ogI+WhtrpsOgjmLW2OgduC7BdKA+qMPsLMBS3VdtM
NZnR8ri4Z3QHgoacoexoYXJiaVbICIJxiuiCIvkpb8dfrJ5nX/BN2WltPjGp75+1
g0QR6B6EBtrFG4u7MraVFmQ4kzkKMkzXPWYU7IxX9t62ege8IrXPUruJ2zBMK3zg
E2tbuVl6bW8HBzLcCTM46c+Rq8UAJWDaHUp2/RcfMoGSHUwWu873oSrZorhgsHmW
5oK1SFi3btEICaXZrduxH/SIN2+DgevExh/mGSGIcOKYJ917yQmdJl+LXGPknPC+
RRWi1QoDOfRvvV+HO2q0yys9Yqv1FnxOWm8O4Iht8DHyP5Vu9+OjDcetKtvKMGp7
4c6dE6iQrYijUgGPy3y6
=KZkL
-----END PGP SIGNATURE-----

--=-mnb7SDM3wEu0o3yTInQC--

