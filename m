Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36931 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbZBFO0A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2009 09:26:00 -0500
Subject: turning off IBSS (with wext)
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-e1vPZirTMQShIoiei3k2"
Date: Fri, 06 Feb 2009 14:57:02 +0100
Message-Id: <1233928622.4175.9.camel@johannes.local> (sfid-20090206_152605_216563_03443ACB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-e1vPZirTMQShIoiei3k2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

so I was testing IBSS, and found this strange behaviour:

 * wpa_supplicant (or NM?) will try to do SIWMLME(disassoc) in IBSS
   mode, which seems kinda wrong. Why do we accept it? We send out a
   frame and then do nothing else.
 * Then I thought "iwconfig wlan1 essid off" - but that fails with
   -EINVAL due to ieee80211_sta_find_ibss

It seems to me that either one of those, or both, should actually turn
off beaconing.

johannes

--=-e1vPZirTMQShIoiei3k2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJjEGsAAoJEKVg1VMiehFYFS0P/j/ScWvVnv2/TAf3YEfcDh3N
7WzElWigAYiq0Oth91q0ldEWlRqnySVus6UB5PsTAcN5R5TsD79nr9HVI/sJ2Lhb
axibd6wbUL4/Eid/P+MOusswjg01U/LuBZ2c+s3szSTZHnjzcH0FkMu5DU5G4KrD
dqyy6Ia6zNFi0gL3+4PGuZ7VavCgJE1hu0t9BuDPW1zR7mAyn4PecNJcW1xSTtM5
HX2sC9bTd6Xi3dEohSAY63NqNb57DJQ2LaMdYLTUruYft3yKB23tDr5MnR67wv2l
Y4DH3HbrjWbn3qMWZzdSP7lQzkBBxSF/dwZQPqxnZykIsKSft+Q7O+chZ/OEN+Zo
kw8y+hFU5PUKCTJGEYVozbCfp/jh8yjLSEDjM9KAcPEBHvOLoA6eCItYxG4dXDJv
LQ1DZ9HgiJ4DEPWqGpjQcpfaqn/MbsvTZnXfxs+2Cb2p5gZ56A0L+4gA2EyKQyls
UhFGmrphdKP3mIw/e5bW74RiypYXc3FhmjmQAQQia8tyeeW9Y/iQ+YKrA+LhU7JE
R1nDXDOp5qg9nsg1bnRDlLAQgdJrnNUMDBGc9ggtCCAwbaJijR7XosK1Pv7UZ8Ej
tmN0S9UIj6c/5v7ZJ/nyeL77w6dA3i5pOZ2gfdtA94U5VnqFRSKkpOGw+t+VBA3l
ZQyWvr3KFz5WFsClHAjM
=crA0
-----END PGP SIGNATURE-----

--=-e1vPZirTMQShIoiei3k2--

