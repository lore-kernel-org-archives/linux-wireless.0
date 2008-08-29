Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33867 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbYH2HeT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2008 03:34:19 -0400
Subject: Re: VLAN testing (and mac80211_hwsim test cases in general)
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080828160401.GG4863@jm.kir.nu>
References: <20080617154008.883383150@localhost>
	 <1215625246.3246.40.camel@johannes.berg>
	 <1215626936.3246.45.camel@johannes.berg>  <20080828160401.GG4863@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2zFuxolm4qNE5q6+qiF1"
Date: Fri, 29 Aug 2008 09:33:31 +0200
Message-Id: <1219995211.25321.24.camel@johannes.berg> (sfid-20080829_093422_370347_9850E022)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2zFuxolm4qNE5q6+qiF1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-08-28 at 19:04 +0300, Jouni Malinen wrote:
> On Wed, Jul 09, 2008 at 08:08:56PM +0200, Johannes Berg wrote:
>=20
> > Just realised that it doesn't handle VLANs properly. Could you add a
> > static MAC/VLAN mapping to hostapd to make VLANs possible without
> > setting up radius? :)
>=20
> In order to get more people testing this, I finally gave in and added
> that option into hostapd ;-), so now you can do this without having to
> set up a RADIUS server. To make things even easier, I made an example
> configuration and test instructions for mac80211_hwsim available:
>=20
> http://w1.fi/gitweb/gitweb.cgi?p=3Dhostap.git;a=3Dtree;f=3Dmac80211_hwsim=
/tests/0002-vlan

Awesome, thanks. I'll look at the code, it seems to me that I actually
want to be able to configure to not reject unknown stations but put them
into their own VLAN, or something, then this feature could actually be
useful in production.

> I started collecting mac80211_hwsim test cases into mac80211_hwsim/tests
> directory in hostap.git. I hope this will make it easy for developers to
> test mac80211 features. For the time being, this is for manual testing,
> but hopefully at some point these tests can be run automatically with a
> script (e.g., daily or whenever wireless-testing changes, etc.). The
> test.txt file includes the commands needed to run both the AP and
> client(s). Some additional infrastructure would be needed to validate
> the end results and start/stop wpa_supplicant and hostapd in the
> background.

I'm not so much worried about starting/stopping them, you can easily
write a small program or so that simply forks and then runs them in the
foreground so that it has control over them and knows what PIDs they
have etc.

The validation is a bit harder, you can listen for wext events, but you
can't even try pinging between the interfaces... Maybe the validation
should check what's going on on the "air".

johannes

--=-2zFuxolm4qNE5q6+qiF1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIt6ZHAAoJEKVg1VMiehFYHyUP/i7f62w7hScvzyVhH6eA9U0x
jjdfXOEt8oFd90qPU1ka6txdHuQrtEeijX705Kfaw6GFEmaU86gVZfnkrkfVbGM8
vaA1FOxF0d8yFHj45ULgU2+ErbExi1mhdEvRmKgm5dDEIZFUNQXTCYBkHD6jqMlc
5z4bVi4BsrchHRoAtdiZwaGamMkuF+AfY2eCC/pixgyBXmS/ar6LOTGWTnglHqZ0
iEeDkjDHwLSCjA8BABd2v7kPq4ZTou8FVuuSDH5QOB4DOltO1W6ADuTtua02enJd
T+dYjz+yaUZy1ifxdafTAPqQ5I6G0eS4YPWRE6z2nFl4f1/UtI67eileqhcdn8wc
90H1vnyD6Mcdmc6kKowShHmxzaH6myHJvj+fRNWimTbTgUaMGfrJKRu7WTKEstFk
yZ1/wD2oW4tW90ch5x2XJd2Bj0VKAumWiMrlY0Dnk/DjOXDgHdPc6uWIB+6vWjz5
37auKzgSwvx/M+OLq+KDUX5fsDFswUiT4SLN3KvcK1sVWG1CwjvYpFhH5Gen7bP6
BEceow8WBzWRW7wnhH+mTj3LjFWS3BPxnGwHrb+rTRo0dChpzg3ruSM1LiKu6IFz
R40S2cafhFucX/MrL8ndXEO0X7LY8IL0Axf3BaSQfZA8t9ea/E5hPGa+d1i6v2DM
BNvd3+VItjIIsth6+Iz1
=jNiM
-----END PGP SIGNATURE-----

--=-2zFuxolm4qNE5q6+qiF1--

