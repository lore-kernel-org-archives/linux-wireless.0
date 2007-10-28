Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36234 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821AbXJ1K1E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Oct 2007 06:27:04 -0400
Subject: Re: [ipw3945-devel] iwl3945/mac80211 cannot connect to dynamic wep
	network
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Zhu Yi <yi.zhu@intel.com>, dragoran <drago01@gmail.com>,
	linux-wireless@vger.kernel.org,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <j@w1.fi>, Jean Tourrilhes <jt@hpl.hp.com>
In-Reply-To: <1193548708.7779.10.camel@localhost.localdomain>
References: <f6ca9fed0710230054i2b2849bfpc79c6090627b8625@mail.gmail.com>
	 <1193127280.3069.261.camel@debian.sh.intel.com>
	 <1193148453.8648.20.camel@localhost.localdomain>
	 (sfid-20071023_150810_118446_E87EE8F5)  <1193161034.7733.38.camel@johannes.berg>
	 <1193238423.2557.41.camel@localhost.localdomain>
	 <1193318969.6092.19.camel@johannes.berg>
	 <1193320140.5542.11.camel@localhost.localdomain>
	 <1193320661.14136.10.camel@johannes.berg>
	 <1193548708.7779.10.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-B+YVzvrShwJ6VtIN3F8r"
Date: Sun, 28 Oct 2007 11:28:14 +0100
Message-Id: <1193567294.3966.6.camel@johannes.berg> (sfid-20071028_102733_876548_18D08A9C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-B+YVzvrShwJ6VtIN3F8r
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> This turned out to be a wpa_supplicant issue.  wpa_supplicant uses
> KEY_MGMT_802_1X_NO_WPA (instead of KEY_MGMT_802_1X) to handle Dynamic
> WEP where the AP doesn't broadcast WPA IEs (ie, a pure Dynamic WEP
> network), and that value wasn't being handled correctly by
> wpa_driver_wext_keymgmt2wext().

Great, thanks for tracking this down.

> This has been fixed on the wpa_supplicant 0.6.x branch but not
> backported to the 0.5.x branch yet.  Tested with EAP-TLS and LEAP with
> iwl4965 on kernel-2.6.23.1-35.fc8.
>=20
> For Fedora, I've built wpa_supplicant-0.5.7-15.fc8 to fix this issue.

Alright. Jouni, will you push this fix for 0.5.x?

johannes

--=-B+YVzvrShwJ6VtIN3F8r
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARyRkPaVg1VMiehFYAQJtuRAApMSIe6f4XWvevFBnh5Dno/BGTRwWdWD6
TXyJIi67umZclCaYT9GohTpOVLnqyOiYToXjvZ3G/q2+JQ57wB19meH1SyWndC4z
nfBBp0mG2a4HjzV0nMIPSm4znIf/ohez5MCyn/DE7UPhVCJYl/rXY6CxTgpJK6Ij
rlL9lgKKF4AiNl/Hrm9YcYXLWI6+eT+bl/HzqcHCi/5PY3WSJ/rfUBMdfr2LMIS7
DIAXWaacewsgFmJkeF8Th781z39MomWh8S//L+la7XTeOE4PZ3lnk0/qcZvLbAe0
cPTxri4UgsSi7ex95dEQuijFAJAem8fAy3kTFIK7rZX9Hm/tSO2UGtM2tsugU4DZ
Zwd/dqNefAYLCLxJj/Th70UC95O2kPzGWImnD4f8Y5w6Ggi5V6V9Qqid53n/O7Cz
G5k7//vpZbgE9kV1Ur+ObaQqeQbEkhodGIqgDEmTFzcodpDeGsGmy0KEWqWiVbhK
pwv4pBbNvhSzRYUgA+PCt3WmCOng6eKyZGsAdCqWvHE9a8PeU7kBEhs6vpeXsgJl
bu42Tz2PTxAimnyL6jh+1sq9M93Tbmth4/J+CRax1+cDnlKWU3juYKafXrPXS0H2
621NAdCyk8D/6vkyftZ1cKFlKpasnbu3LHmB7BkP7/EutoFxaVcUIAXzRra988eH
wU15uJQeWA8=
=RQTK
-----END PGP SIGNATURE-----

--=-B+YVzvrShwJ6VtIN3F8r--

