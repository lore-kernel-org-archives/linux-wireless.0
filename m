Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53614 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbYDXKAR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2008 06:00:17 -0400
Subject: RE: Roaming problems
From: Johannes Berg <johannes@sipsolutions.net>
To: Lars Ericsson <Lars_Ericsson@telia.com>
Cc: "'John W. Linville'" <linville@tuxdriver.com>,
	'Dan Williams' <dcbw@redhat.com>, hostap@lists.shmoo.com,
	'Holger Schurig' <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <009e01c8a5f1$625e0790$0b3ca8c0@gotws1589>
References: <009e01c8a5f1$625e0790$0b3ca8c0@gotws1589>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4sudm9aGOvswO1D4KnGb"
Date: Thu, 24 Apr 2008 11:59:52 +0200
Message-Id: <1209031192.3357.61.camel@johannes.berg> (sfid-20080424_120051_046235_F0AD86D8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4sudm9aGOvswO1D4KnGb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> It's OK, but then the wpa_supplicant needs to 'cancel' current settings i=
n
> the driver before it start prepare for the new AP.
> As I have understood it, that is done by issuing a BSSID of
> 00:00:00:00:00:00. I will look into a patch for that.

No, wpa_supplicant shouldn't have to do that, mac80211 should do that
automatically once a new BSSID comes in. The problem seems to be between
mac80211 and your AP in that mac80211 associates to another AP and then
tries the target one but the target one doesn't like that so we should
at least try to disassociate from the previous one first.

> An other aspect of the selected design. If the driver (STA) is associated
> with an BSSID and the wpa_supplicant would like to change BSSID, who is
> responsible for a proper de- association/authentication from the first BS=
SID
> ?

mac80211 should be responsible.

> My findings says that the network does not allow an STA to
> associate/authenticate with one BSSID while it still have a valid aid wit=
h
> an other BSSID. At least my Cisco AP does not allow that.=20

I tend to think that is rather questionable behaviour, how can the
second AP know that you're still in range to the first and can even
disassociate from that one?

johannes

--=-4sudm9aGOvswO1D4KnGb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASBBaFqVg1VMiehFYAQJy1RAAs8fnRAc7cb9BRgYYYAB2sOICCz6fWmIS
g8QJlzQXja/GWaRbS0nRevxt1t70EOTj3hPuJmD4miX2pz3YVy+kpY2Fk/P7J9Gb
FnETduyo7QRxjowI1wHhR0N3bDr33D4N/ACWrY2BoKmXHhLMnB2PivpyZCF1YpdU
qhWwwkWyzi4wSx5f3HnvYdyUdi0rK6d6nVvRz5VGsNpCWISi6w8ingVoUw7KPkaZ
PSJwtL7jwFA0FwFPlgqBVk8NDXbeiscsNnzhRP9Wayii25VLdjkLt+2aVfm0Wfhc
5r8Bn3mjBAYLuMLplvNrfQzIuf605zWb7l4Quf59PL/nWed14qSpz3cA1gblIv93
KAjrIJUieUNxTrdhuMOmXK9MKUX+CMQFn8hlTzIPT9YRl1bVCzDWbQSqKwB0pYCg
Ku8CuWsx7IrKc9xImohqBoVSWvY1Z5d/kLvLCAIXqA3YgHxLuoxmH6bkajUR2rUC
ak0l954OUoNFHPUeQpYS2GEa2IbPJzYepX7XeCORfHijphT0b49GNsOyyY3WjSci
q9ZF6PZ/DHfBG2b3TRiwVH5KbxDeoIrBLECbaPNmG1MzwIVOpBqq8E3+kUabT80u
geTNfU2M4tURR1JP0lPJnE02NLh/a5PuSNBGv8xX5VefZmQf1jrdL9EDkNALmE9W
zvJUpYjQwD0=
=ZLQB
-----END PGP SIGNATURE-----

--=-4sudm9aGOvswO1D4KnGb--

