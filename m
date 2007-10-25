Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60325 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbXJYN2O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 09:28:14 -0400
Subject: Re: [ipw3945-devel] iwl3945/mac80211 cannot connect to dynamic wep
	network
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Zhu Yi <yi.zhu@intel.com>, dragoran <drago01@gmail.com>,
	linux-wireless@vger.kernel.org,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <j@w1.fi>, Jean Tourrilhes <jt@hpl.hp.com>
In-Reply-To: <1193238423.2557.41.camel@localhost.localdomain>
References: <f6ca9fed0710230054i2b2849bfpc79c6090627b8625@mail.gmail.com>
	 <1193127280.3069.261.camel@debian.sh.intel.com>
	 <1193148453.8648.20.camel@localhost.localdomain>
	 (sfid-20071023_150810_118446_E87EE8F5)  <1193161034.7733.38.camel@johannes.berg>
	 <1193238423.2557.41.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ARbSM+ASIYyKQcUbbeZ3"
Date: Thu, 25 Oct 2007 15:29:29 +0200
Message-Id: <1193318969.6092.19.camel@johannes.berg> (sfid-20071025_142817_470187_BB4FE63C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ARbSM+ASIYyKQcUbbeZ3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-10-24 at 11:07 -0400, Dan Williams wrote:

> Could you educate me a bit more about the problem if you've got a bit of
> time?

As much as I've understood, the problem comes from the privacy mismatch
function returning non-zero. This means that wpa_supplicant doesn't set
IW_AUTH_KEY_MGMT_802_1X because if you check the function then the
key_manegement_enabled variable is checked first thing.

> A normal Dynamic WEP configuration should result in wpa_supplicant
> sending IW_AUTH_KEY_MGMT with IW_AUTH_KEY_MGMT_802_1X since ieee8021x is
> specified in the wpa_supplicant config.  Is this not happening here?  I
> seem to be seeing that wpa_supplicant _should_ be setting key
> management, and mac80211 _should_ be returning 0 from
> ieee80211_privacy_mismatch() because key management has been set, and
> therefore this should succeed...

Yes, it seems that wpa_supplicant is not setting key management
properly, possibly because internally it only translates two of the key
management possibilities into the right wext state.

johannes

--=-ARbSM+ASIYyKQcUbbeZ3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARyCaOKVg1VMiehFYAQIKdg//Q2BVkzEnTzKw4lD5P87ZUynHmgHcdflt
nAvpawzkC26BhQzZ10ihZMTEh1eh3NFG+6mzFU+NuuVERBfNzeqiyld7LF3FGxkM
SQoyhPtKK4Yu3vOzh6L9Xk74mbinphXXg1vGC/slZqLcBVAJEpIqfl/cNSOlFX50
48UvQy/TlgE/Lsru/7bYH9ooLt55Pb1f/YU3uwybNKJ0r/y2tWqSWsS0EBgusXpX
sjzcs6rYIxQhvpBWJuaPyOWb6lUEp1hI1hzDwkfCiUsgEZo3Lt/0yhqvlNTzr1rg
vG+xx/j4uvIzi3cKJ3RyZqMvKVkJomrGSJgg6WJS5gPBnhwDlTSwCsvQpZLL99EG
RzBRNNX2//6xlwp84X/zUbIuVm5TLTH3WnvowrAUhK64m21zt23j7nl6qQEzJOCf
VElV7mHXw4KAcJbo9Rg3YQRcSmKFwNPWMRFSQzfjLZOC5Hm/6Xs6Rap7qTv7PcuL
8NXMGRJ2e7ssmNN32YeBRSFI2uWnNoiWoULh4CtYc4JV6OuUk+hHLYXZWBCQstdg
GF13z5uiFvgPkZSK5u4Z6DXeBLvGWjL5QfNasAPXxS8spppmyGfvnk9iWyZF0D6U
k127g2Mw9n+zLlcd0X4rZwICJTgcAOJJxjpq8lkK7QEmLe6JM8iRW1Z+wjsi+UH1
GnZCOwqp2T8=
=Kbqy
-----END PGP SIGNATURE-----

--=-ARbSM+ASIYyKQcUbbeZ3--

