Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48287 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbXIVKbR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Sep 2007 06:31:17 -0400
Subject: API to regulatory control (2)
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1190456574.18521.220.camel@johannes.berg>
References: <1190456574.18521.220.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IHyQthSvsLmsRVd0SzZr"
Date: Sat, 22 Sep 2007 12:32:35 +0200
Message-Id: <1190457155.18521.230.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-IHyQthSvsLmsRVd0SzZr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

So in the first part I covered how information on channel restrictions
is communicated between the central regulatory control agent and drivers
and/or mac80211.

This second part is rather short, but important.

Devices that are capable of operating in a wide range of regulatory
restrictions usually also have country information encoded in their
EEPROM. I understand that Intel devices will need to make this EEPROM
information part of their channels list because the firmware rejects
tuning to other channels, but most devices fully enforce these
restrictions in software.

Hence, it is necessary that drivers are able to set the regulatory
domain they think they are operating in. It would probably be possible
to override by the user, but when the user has just booted it would be
good to be able to read the EEPROM of a wireless card to set the initial
operating domain.

For this, we need two exported functions:

void cfg80211_regulatory_set_alpha2(const char *alpha2);
void cfg80211_regulatory_set_domain(int ieee80211_domain);

These functions, when called, internally look up the value and, if
found, update each registered wiphy's channels list for the new
restrictions. They also set the internal domain to the value given
(well, I suppose the _set_domain function internally looks up an alpha2
value and calls the other one). Also, it will call the notifier chain I
talked about earlier so drivers can be notified of the change if
necessary.

Similarly, userspace can set the alpha2 value through some
nl80211/configfs API which will also cause the the same updates and
notifier chain calls.

I think this covers all the public API to regulatory control. Did I miss
anything? Everything else should be internal.

johannes

--=-IHyQthSvsLmsRVd0SzZr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG9O9D/ETPhpq3jKURAkKxAKC3h2S3svsCYWD+ymIOioe+j/gICwCdH8j/
bplPaoqQEFe89ozBZ693vnE=
=b+b8
-----END PGP SIGNATURE-----

--=-IHyQthSvsLmsRVd0SzZr--

