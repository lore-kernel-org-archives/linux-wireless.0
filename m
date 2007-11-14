Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54544 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197AbXKNQJm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2007 11:09:42 -0500
Subject: Re: [PATCH 0/15] mac80211/iwlwifi (#everything): integrate
	IEEE802.11n support
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com
In-Reply-To: <11950541913679-git-send-email-ron.rindjunsky@intel.com>
References: <11950541913679-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mtyt09QoD2ccg1QdNqv3"
Date: Wed, 14 Nov 2007 17:11:02 +0100
Message-Id: <1195056662.4091.29.camel@johannes.berg> (sfid-20071114_160959_913359_F8851EF2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mtyt09QoD2ccg1QdNqv3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Overall, looks pretty good. I personally prefer things like (!xyz)
rather than (xyz =3D=3D NULL) but that's totally minor. I'll take a more
detailed look later and check out the frame flow etc.

>  - Changes to Rx handlers PAE and drop unencrypted (for EAPOL frames in a=
msdu)
>  - Examine config flows in mac80211 (RFC is prepered)

I'd prefer to have this patch series depend on these two items instead
because as it stands, we have a weird behaviour here and quite a lot of
duplicated code in the data/agg_data RX handlers. I thought your RFC was
pretty good except that you didn't want to convert existing stuff to it,
so...

johannes

--=-mtyt09QoD2ccg1QdNqv3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzseFaVg1VMiehFYAQJtnw/9Fe+NYUdSEi+CQ8AnBq9f+kuhaK5B5Uvq
rBfHKy/5Os6gCRg8xyijU6cAXeDXTevkBNwFrofGhhxoGWn651d3pqLXof1+WWg9
oD5PtQMqTFKEvvAPkrnEM8SGeAVEjJN7v5vD55F0DdHMiyw7ryR8Bbv2zs0QZEUX
Uw+8Xf6qm+6xQGxAOtAtA+eIUisnDQJj07INhP9LCvyjaAuYUi1/58+NKJVUNFvb
pduaHKLpGh4wPE6ow0NJEtcXGdZF7FWc9z0rlTxqbBV7hMiemQ+Wvh+fTEce6NqX
OmnND70AmBQM8w8gju8lqKPTY5dDSZ6DFwo/BeM2Pjc5/lc3Bncsn/ezJJhDDK33
J9AZeepPfwnoSRIdT9lriN3XilY83zejXpX9KROfZtEiYVf8U3mGZJ41nohqb7b2
n/g/Y8olA7eCg4ZMuhvU38yS+oBpiNo0XT8SN5RivfeNysElM5cBeAJjxJBtqPLX
GB2xk5mREsY6yRXCa6xpwSE/fLp6cTHpfXQZ6V89kdBz8NP5l2HOi/y5hu1c01Es
PyPIjo5Ea4kZLJpgS9qm1bZak0m4LsAU2TdImyVmKXIfYi3SYDM27lIwXJjJVIp2
9JrWoehJAumIWN9DBghuT18Ma3nc8Fl9geVxkOZQ2ICFx7IZq1ahwefpnDWf3xmr
fA7HRUoR+3g=
=TklL
-----END PGP SIGNATURE-----

--=-mtyt09QoD2ccg1QdNqv3--

