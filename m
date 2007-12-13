Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51238 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762827AbXLMRde (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 12:33:34 -0500
Subject: iwl4965 vs b43 time drift?
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BFVdVZgn/w49r6tlw7G9"
Date: Thu, 13 Dec 2007 18:33:17 +0100
Message-Id: <1197567197.8313.27.camel@johannes.berg> (sfid-20071213_173345_742079_655EF7D5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BFVdVZgn/w49r6tlw7G9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

I'm debugging a timing problem with b43, can you tell me exactly when
the timestamp iwl4965 shows in radiotap is taken? Is it the first bit of
the preamble?

When associated to my b43 AP, I'd expect the difference between the
beacon/proberesp timestamp and the MAC timestamp of the iwl4965 monitor
mode to be 192us for the MAC header and another 192us for the PLCP
preamble/PLCP header, a total of 384 us.

However, when I have just associated, the difference starts out at 383us
and decreases, down to ~370us and then varies between 370-380us, afaict
never reaching 384us.

The strange thing is that it doesn't seem to recover. No matter which of
the timers is actually wrong (I guess I could find out by comparing with
the system timestamp and hoping that the delay through mac80211 into
wireshark is constant) shouldn't it recover the time?

Another problem is that when I enable powersave on the iwl4965, I see no
beacons at all. And oddly, the difference between the timestamp in the
probe responses and the iwl4965 MAC timestamp starts varying wildly, up
to almost 5000us.

I guess that b43 has a timing problem otherwise we'd be seeing totally
bad behaviour of iwl4965 on stock APs. I'm just trying to understand the
problem better right now. Do you know when iwl4965 will resync the
timer?

Thanks,
johannes

--=-BFVdVZgn/w49r6tlw7G9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2Fs3KVg1VMiehFYAQIyDRAApnCJjf6h5kL3evKj57XmC2ncuNqnLmyd
87wmIJ6S5bYZHdYGVOEgqz0clV8NVl4zdF+u7w74b5x643qB15/SqBOVu3DGD2fz
8opWgjN6CAmSUsf6stx0IAkn9UJCBKPrNoYhJw3bzDtfX5H0CoAeD14I9sScqxH8
aFyQxGEaHJXj2oTvucDJifYRFueaW6hu15oMjIYib88970E9oBDWSylNY2062lCz
x9YKHtk6P0P/suos84onsx/4CLV4xqKfaECl49n++2LE1ZPrsnskkK2bbVNSoSVV
YZUR6WSeZl28qloqHCg/Z3xVcY94W3YU+rLF+7zdr7sr4F4p+gG5+l44snG1d1nI
xU5smPGGmcrn5lrXtj0R9Nf3y1SFCfjwV+txBXa06j1tJNG6UVDMSexxcl3HiKKg
8CxRmcREZ05BqYeCKFOwn2gHQtw6OvTDlJtZvBOpLq92snAadJd5Xq0oxqT+Ug7U
gSz1U+lt3OIF4Kug9+tkuLpaJ38hmy516nJ2OVWRixELe28ywz08tXe0nWAVpIev
+DGvkbVGMfdtXjU6zVQB+Ov8A7ErU/Csurz55Bbff/uYbjuHtGnGgEX8ebwui0dX
+D0xmdWkyHN09LSwTrF1osWsH47sJfPYpfLt/X2/lOJn6wkDhO0yGF0QAsxcou24
m6fdq4cviPs=
=na1T
-----END PGP SIGNATURE-----

--=-BFVdVZgn/w49r6tlw7G9--

