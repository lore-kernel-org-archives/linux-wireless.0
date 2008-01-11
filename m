Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42105 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757459AbYAKLis (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2008 06:38:48 -0500
Subject: IP header alignment vs. A-MSDU packets
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Tomas Winkler <tomasw@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9ByHMqKBHFVTaxl/5qy6"
Date: Fri, 11 Jan 2008 01:38:25 +0100
Message-Id: <1200011905.3861.126.camel@johannes.berg> (sfid-20080111_113851_818532_AA3F3775)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9ByHMqKBHFVTaxl/5qy6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Writing about NET_IP_ALIGN made me think of the A-MSDU case. Tomas, if
you're looking into getting firmware changed, please consider this.

When we receive an A-MSDU packet, it will consist of an 802.11 header
followed by subframes. Thankfully, the 802.11 specs require that each
subframe is padded to a length that is a multiple of four bytes.

However, the alignment requirements are different!

Each subframe contains its own 802.3 header, which means that the IP
header starts on +14 from the 802.11 data payload. This means, that in
the case of A-MSDUs, my WARN_ON_ONCE is incorrect!

Let me explain: Currently, I require that the 802.11 payload and with it
the IP header starts at an address that is divisible by four. However,
adding the 14 bytes 802.3 header the IP header now starts at an address
that modulo 4 gives two, not zero as required.

Hence, when the frame is an A-MSDU frame, it needs to be aligned
differently and have no padding in the QoS case. I think all those
frames are required to be QoS frames, so only legacy-QoS frames would
require the padding. I'll send a patch.

johannes

--=-9ByHMqKBHFVTaxl/5qy6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4a6gKVg1VMiehFYAQK8gQ/5AWSNXDcd/sAa79wjL/nzbY1OWA1vR4RK
Gxi28QLGgY35215MVz509H2SxqsJp0FE2Neg5dceXrF7vRlFJiEFwhWrshqdc5F9
1ZDtu32ZZ3G/eapoFQSnUvKyp3nMiS5IE35jX71gqHXndJa8eu7bPBBJxs0hZ6n3
FH55k5aSJ5F9eM8VcUHO1ryNRnVQAkJS3lXtSoXIxupJGzZdhGwfgmZJaVXCPwRY
3dnD187IWoNNZYW4XRPW9kLR56QbcHj6ppf+KS0qgc3NNjA1/9mpDMUTUetegoyY
TDPxVyTFUVhri4KHJ0ar//Eiw5ug9sUpS1e8HgW4sezfhpH2hqccr8AAeuoHVG1H
7Cpcws4cAQ+KgoUrZBME5jNAAemojFE/O8o6c87eIe3xlF2eex/HpToBsTbiQhQz
Ef9VRNVByWu5Gc0kOuOikYWTVLxF8JZn8IoM15mHuzYW05PvVTZN8JQpTvdg1k/P
guPmSKRqAk8fDKTMf+6AMBNfoEayUoedyG1QYVa1OtxOd3C1s8ofHAZKP2hKLC2y
Bfl3yeTNwcNKzegh6JQPEBipUYGd2vL5HoPyIImFU6RlwGYLhnAD8PgiBUvvg53R
RD3sorvkam2/SfqjkHGYgVh+T+jLmg1t8yPJodpk3MtApVhfCSIrcuQbpXCvAmi+
Vou25w0Uz5I=
=L7P/
-----END PGP SIGNATURE-----

--=-9ByHMqKBHFVTaxl/5qy6--

