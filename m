Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43828 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbXBMSlX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Feb 2007 13:41:23 -0500
Subject: cfg80211 configuration vs. actions
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Jouni Malinen <jkm@devicescape.com>, Dan Williams <dcbw@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-F9aiyO5JuoGDw4Ld4XY5"
Date: Tue, 13 Feb 2007 19:38:54 +0100
Message-Id: <1171391934.10344.96.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-F9aiyO5JuoGDw4Ld4XY5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

After some consideration I've been thinking that cfg80211 really should
be changed a bit. I'm trying to think of what we need at this point.

Right now, I have a ->set_config() call for each netdev which sets a
whole bunch of configuration parameters. But we said in London that
changing e.g. the SSID should not actually trigger any association right
away.

So now when only ->associate() actually makes the configuration take
effect, we'll need to have
 * a way to know what configuration is "pending"
 * a way to get the configuration that is "active"

That's fine. But why would we want drivers to handle it? Obviously,
drivers are going to need to handle the ->get_association() which
currently returns the current BSSID but should also return all the other
parameters.

However, cfg80211 could, with some hand-holding from the driver via
->get_config_valid() handle the whole issue of keeping the "pending"
config, and then pass it to the driver for ->associate(). ->get_config()
and ->configure() get dropped completely.

Another thing is... For ->reassociate(), which config to use? "re" seems
to imply to use the previous one, but people might also expect it uses
the new one. Maybe we should just refuse reassociate with some
well-defined error code (e.g. -ESTALE) in the cfg80211 itself when the
configuration has been changed? That might help networkmanager and
wpa_supplicant when a user interferes with it.

{Luis: this enables configfs support without that transaction layer in
configfs because we have our own transaction layer now}

{as another side effect, this allows us to implement wext compat much
easier}

Does that make sense?

johannes

--=-F9aiyO5JuoGDw4Ld4XY5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF0gW+/ETPhpq3jKURArzkAJ9DGjnVTAxJpHqGaDKthEJpMOyoagCfR5Mr
1xNPSUCMpdz32MkopAwitqU=
=hpBf
-----END PGP SIGNATURE-----

--=-F9aiyO5JuoGDw4Ld4XY5--

