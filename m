Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54434 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbYFJLQ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2008 07:16:56 -0400
Subject: Re: mac80211_hwsim - simulator of 802.11 radios for mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080610105058.GA6961@jm.kir.nu> (sfid-20080610_125146_081395_B69CEE5E)
References: <20080610105058.GA6961@jm.kir.nu>
	 (sfid-20080610_125146_081395_B69CEE5E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Olbj6FHkbuKV8pZrFWY2"
Date: Tue, 10 Jun 2008 13:16:15 +0200
Message-Id: <1213096575.3668.6.camel@johannes.berg> (sfid-20080610_131723_211697_2B6A3C83)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Olbj6FHkbuKV8pZrFWY2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-06-10 at 13:50 +0300, Jouni Malinen wrote:
> hostapd and wpa_supplicant include a test driver interface that allows
> them to be tested on a single host without any wireless hardware for
> development purposes. I have found this very valuable both for
> developing new functionality and for testing existing code.
>=20
> In order to provide similar mechanism for mac80211 developers and to
> extend the scope of suitable test cases for hostapd/wpa_supplicant, I've
> written a Linux kernel module that provides a similar test interface at
> a lower layer. mac80211_hwsim simulates WLAN hardware and the air
> interface between the radios by acting as a low-level radio driver for
> mac80211. Neither mac80211 nor user space programs need any changes to
> work with the simulated radios.

Way cool!

> The initial version of mac80211_hwsim is available from the
> mac80211_hwsim subdirectory of my hostap Git tree:
> git://w1.fi/srv/git/hostap.git
> http://w1.fi/gitweb/gitweb.cgi?p=3Dhostap.git;a=3Dtree;f=3Dmac80211_hwsim
>=20
> If there is interest in moving mac80211_hwsim module into the Linux
> kernel tree, I'm open to doing that, too.

I think that would make sense, yes, especially since one look at the
code already tells me that it needs to follow large API changes to work
with the current mac80211.

One thing caught my eye: you use GFP_KERNEL in the tx routine, that's
not good, it is running under a spinlock.

One thing that I'd like to add is a having a "global" monitor interface
that is registered by the hwsim module and not mac80211 and shows all
frames, regardless of channel etc.

johannes

--=-Olbj6FHkbuKV8pZrFWY2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJITmJ8AAoJEKVg1VMiehFYhB4QAIa6lKf/qR9jRpRweM4c60N9
BgAeEytHek8oQSMCsG2YTwJNaYu/Rlw8kyj3rXZWhaVmBgtigqrGyGCte9d/WVdn
zEHcdepTLjD3fhadfjv33dJQZQzmeVMd8W2YLbrHYoX5+udA4Hx66UwnNJH4no5x
0GP5ubDLGIDp8fUumbJWxmVSGUn3bz52hEtxJzbVdq+ekXm3P6o08xqyZO2Dkwm2
VbTq2xWgIg96isiN88pYWJB8ZGK9NRl/rCZkFgPlYJK8huxkyeyFUE96YIKdk3La
5m6IZF7+9bxCjxyZ2qMKBg4KyMui0sNkebBEBFHtAXr153iOYYmloQFLxks6zDaC
b+96j3jI1iYDeP+BCke6GvPICCixhIRg0xTwdSP+SPp+vfS9yWyAEj2qZBOXYqRa
o4AnV9xCKhxLyJJ90xIzatawONLvjF7/j7HljXx0/uBR1nFCUeilbdJWmGBtIEFi
+jX6hK19pwWf09JMvrEVD/iq/lE9AQ1VD/clPtKCr0abPyHywKu7ttC91P75VRC+
yW6f99cS8lqQcOR8EPbJ03YFAW6MTx9GD7Sn3vbvC15r7i7h2uyFsPSVn1/R7rHS
p3T1yaa7j0i1bSCISJHSrna/1xyjP+wH/uyYWg7OrrHPJcLGNGsSApg/dE24l+MH
yWt9fNE0trsv16k5EcJM
=Sth2
-----END PGP SIGNATURE-----

--=-Olbj6FHkbuKV8pZrFWY2--

