Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47162 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbYKJJgp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2008 04:36:45 -0500
Subject: Re: [RFC 2/2] mac80211: implement dynamic power save
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1226245439-30329-3-git-send-email-kalle.valo@nokia.com> (sfid-20081109_164424_115149_4F11A949)
References: <1226245439-30329-1-git-send-email-kalle.valo@nokia.com>
	 <1226245439-30329-3-git-send-email-kalle.valo@nokia.com>
	 (sfid-20081109_164424_115149_4F11A949)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MrVt6y+yvf2KHQDrZjZO"
Date: Mon, 10 Nov 2008 10:36:48 +0100
Message-Id: <1226309808.4004.16.camel@johannes.berg> (sfid-20081110_103649_704110_B7CE2EAF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MrVt6y+yvf2KHQDrZjZO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-11-09 at 17:43 +0200, Kalle Valo wrote:

>  	bool powersave;
> +	int dynamic_ps_timeout;
> +	struct work_struct ps_enable_work;
> +	struct work_struct ps_disable_work;
> +	struct timer_list dynamic_ps_timer;

I think you could use a delayed work for the enable-work+timer, that
combines them already.

Looks good to me.

johannes

--=-MrVt6y+yvf2KHQDrZjZO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJGACsAAoJEKVg1VMiehFY8ZkP/RSKhD3wTHd++Oic5gByXf27
DolMZ9EeC5/9K5Y/ATarlszyWfZoOkL4mjvQaw8aIhH/NG9rPQP7VZdEXXAiMyUf
DrzA8OjiK4/j1X2QwfAoS668CjUYo8B6t3k9x8QeUhK7go6SyLjkdvLsZAn2C25k
uYBC8lEi7tXz07MA1QYDNHzUX8HpFKsD5UeHzAQc5whU70CgmSmtedzK3xhLLnoC
8fI3PSPHi0QzNjnpKlad4gfUKD5nx25wrW51kVytmJUCSuadtNV+5FkU7AspXdLn
4xAdB8zTM191jd5Y+fxTwdwQkCMI7j64z07GnlAkz1u3NWImU1I3kx2IQLplwijx
D84djnfKauc/OV7V8Oio8FLtpvIeOq3lQFrq/FJ9c0ORoD7zT9CwWtycyC4y9CTA
N5YciD4UJy5WTnmt71DKnsO87vY6gGbHIHwJqF/vSGJVkWoeuxW3BDsJuynkBOWs
+BwBKLoBrHnSuM1bSt+SU3ANtw1LB6kyIV5PPQjxaUCgnpW883KMvqLOS2x0ptUE
XQXBUatpnJCuKxB7+CioQfXdGQh6hI92LLCOHEecyzpGLpg0b2JZVY1FKuEziy2c
8EUr4fQP3+DVCv/qXqZ2vBy3QbZwnP1LJFTvSf4SE2VOsuMgEgeVRJlN8d85oafJ
NEZgVPiX/ogp5F7hOTGY
=QVUo
-----END PGP SIGNATURE-----

--=-MrVt6y+yvf2KHQDrZjZO--

