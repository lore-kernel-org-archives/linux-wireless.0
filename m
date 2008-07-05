Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:32983 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbYGESrt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jul 2008 14:47:49 -0400
Subject: Re: [RFC PATCH] iwlwifi: Memory allocation optimization.
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Gregory Greenman <gregory.greenman@intel.com>
In-Reply-To: <1ba2fa240807051144g65821ba1neabcd56ff56d273c@mail.gmail.com> (sfid-20080705_204505_915789_B450D197)
References: <1215103274-8516-1-git-send-email-tomas.winkler@intel.com>
	 <1215275435.6848.12.camel@johannes.berg>
	 <1ba2fa240807051144g65821ba1neabcd56ff56d273c@mail.gmail.com>
	 (sfid-20080705_204505_915789_B450D197)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DWsttKv14WyJOXhcBMbE"
Date: Sat, 05 Jul 2008 20:47:32 +0200
Message-Id: <1215283652.6848.17.camel@johannes.berg> (sfid-20080705_204752_320630_B07F8631)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DWsttKv14WyJOXhcBMbE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> We have to improve more places in allocation and we hopefully had
> mapped all of them.
> This patch fixes allocation that was in order 5 in( (ATOMCI | DMA) and
> was most urgent.
> The section you've suggested is I think on 3rd or 4th place. Don't
> worry we get there.
> What is more important now that we get some feedback on this fix.

Fair enough. I can't really comment on that patch. You might want to
have somebody do some spring cleaning in iwlwifi, I just found this
comment I inserted there during some refactoring:

4150c572 (Johannes Berg      2007-09-17 01:29:23 -0400 6941) /*
4150c572 (Johannes Berg      2007-09-17 01:29:23 -0400 6942)  * very dubiou=
s code was here; the probe filtering flag is never set:
4150c572 (Johannes Berg      2007-09-17 01:29:23 -0400 6943)  *
b481de9c (Zhu Yi             2007-09-25 17:54:57 -0700 6944)    if (unlikel=
y(test_bit(STATUS_SCANNING, &priv->status)) &&
b481de9c (Zhu Yi             2007-09-25 17:54:57 -0700 6945)        !(priv-=
>hw->flags & IEEE80211_HW_NO_PROBE_FILTERING)) {
4150c572 (Johannes Berg      2007-09-17 01:29:23 -0400 6946)  */

:)

johannes

--=-DWsttKv14WyJOXhcBMbE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIb8HAAAoJEKVg1VMiehFYdEoQAJodQ55JFqKOG5vuHKk/Fdky
d5uYeLLZOm7DmGmwW3RCp4VakZzJ6mT0n9VRa6iDKAZ6Sx6BQa7i7KbgH0IVA9Nl
5cmN7WAvPce6xr/RmabrIdA5FYRo+68Z0ZVdoP9mMKt9AtDdwWkZIpEnGzqAx+ur
TO1y+crB+RmT5J1XU5avpTiGWnKZ4zdoeaVBgyll7x27LuL+Js9zgvaNmovVsSYS
2c3hOa2CTOVyk91v8jSw+7yEFilmggwmK9p4nf/cTmhVjEZDuiZRF3bjGKODl38H
TFMe+0F2sHxfILH/fB5muXOZgEz8Cscvr2ksAg6OWeRS3wrh68gQICW1FDmzX2Nk
IS7Dl8uSv1o35OkYCBbaJpB3rYfOM8Q2nfVy2dooQNReOOmX+ywyeqeOC3Uqw+2b
Jm0LahEKeqg3bt6S9ezurSSNOwS0e0hkCpKNCqW/WxzclRUVdb+GE3A1Xsfk0IoE
dQ7w81OH2NvRgxAzj8Sn0Foz7pC+PX3h6kys/4lAL8/01hWgwmwMDqz4xNsm/W7C
UK/Wnp3lYYw9PfrSKarrKkJWmCbapGMpPb2BxRRgJUa+X5OSLIArMndaSRmtfh3z
JRxXEBM6KqmyFqS8e5WsSVi4SyC1ZsjG0SwqVSXGKf6gRfovbO2cYkNh7uzAvn6N
2BuzeQQTGN3IPgFezV/S
=jOUC
-----END PGP SIGNATURE-----

--=-DWsttKv14WyJOXhcBMbE--

