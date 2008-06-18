Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34927 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbYFRPhw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2008 11:37:52 -0400
Subject: Re: [PATCH 2/2] mac80211: add spectrum capabilities
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1213800824-32107-2-git-send-email-tomas.winkler@intel.com>
References: <1213800824-32107-1-git-send-email-tomas.winkler@intel.com>
	 <1213800824-32107-2-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fs161osdBjvI0XFu2i+v"
Date: Wed, 18 Jun 2008 17:37:11 +0200
Message-Id: <1213803431.1312.24.camel@johannes.berg> (sfid-20080618_173755_197115_54C6AEA5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fs161osdBjvI0XFu2i+v
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-06-18 at 17:53 +0300, Tomas Winkler wrote:
> This patch add spectrum capability and required information
> elements to association request providing AP has requested it and
> it is supported by the driver

Why bother splitting this up into two patches, the Kconfig option isn't
even being used?

> +		if ((bss->capability & WLAN_CAPABILITY_SPECTRUM_MGMT) &&
> +		    (local->hw.flags & IEEE80211_HW_SPECTRUM_MGMT))
> +			capab |=3D WLAN_CAPABILITY_SPECTRUM_MGMT;

Why do we need a hardware capability flag for this? The only thing you
seem to be doing with it is determine whether to send the power
capability IE?

Will you follow up with more patches to enable radar detection and
things like that, and shouldn't we merge that as one series? This looks
sane enough, but it seems hard to judge whether or not it's actually the
best way to do things.

What else will depend on the hw capability flag?

[and yes, I should read 11h/-2007 again]

johannes

--=-fs161osdBjvI0XFu2i+v
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIWSukAAoJEKVg1VMiehFYzbkP/i8W3c8Vfn/YpCHkGiREikU5
KkA5gnNYtceWXKV6rldMUODp3+Oi093xkim/WNbOUQqGj6Os8dE0KBPmy9IrQKRk
VXTQMe8iwz4JWCl1QRJ1AtzKja0aPiFNNRCqs0y/kWc88dN1hxVQT5SZA/vbWKZw
7JePXw3ngfKF6tanfsNLZsO3UaSEVZL6jHTCex+jeVHbeP0a2EC/9nTJdYiQ7lla
Mw1Zmf6z7d2kZeA0+Lv0BIRkxgwiazE8rXPIBKrh2vnX6ft5vuQM0/M3AL0oCgXS
qphcSJ3CRAkX1j7g2TezmNWmhYSvzBFpSmgcBbxyfyQ48VJczct1xC8d4Ew4U967
iJzAUPXk7a+B45L1+trDMW/FM1/HccLM8BMpXd5LLTjPldNYldU1RCRNVKkIOhB1
49PvigZMUM7x9yB0QsGlLlvxHXS/me1qm3jUifH5n5NS8ouBSMR69ja0knx6bOPu
ERLnw+dUAdfQAt04NjT12dbOVQv5WwHi5Vvypop2B8si9GUEfjDMUfQ4nkw9XvVz
SznYixRf46EkpXtNL4DQmkhx5NKbUmMfhpw5Sik38RnMgK5cZ85ZPThgaWZLcsEl
WX9Im9kcimOIUagixGh773E5TW/PmZZ9n1Z8VdSxUp0DQpSalRWU4104oz7Hsd+x
tAbWCpFJuz1adlE0kFvo
=hW3y
-----END PGP SIGNATURE-----

--=-fs161osdBjvI0XFu2i+v--

