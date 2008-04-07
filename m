Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37066 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbYDGNrY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Apr 2008 09:47:24 -0400
Subject: Re: mac80211 hardware encryption
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200804071534.38526.IvDoorn@gmail.com> (sfid-20080407_143157_497315_70B0D37E)
References: <200804051931.58895.IvDoorn@gmail.com>
	 <1207573761.12481.4.camel@johannes.berg>
	 <200804071534.38526.IvDoorn@gmail.com>
	 (sfid-20080407_143157_497315_70B0D37E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-E9Df6O4v/xqTCuUkNIe1"
Date: Mon, 07 Apr 2008 15:47:21 +0200
Message-Id: <1207576041.12481.21.camel@johannes.berg> (sfid-20080407_144726_443312_90792A9C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-E9Df6O4v/xqTCuUkNIe1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

For the TX path, I don't think a memmove() of the header further down is
really expensive, it should be within the CPU cache since we operate on
the skb header a lot. However, you'd have to undo that too before TX
status reporting to get radiotap working properly :/

> I agree, but overall I think this would mean for rt2x00 it will be easier=
 to stop
> sending the skb->data directly to the USB host and use the preallocated D=
MA
> instead.
> Especially the RX path could benefit since otherwise it will be continuou=
sly using
> memmove on the header and payload to insert the IV and have the payload 4=
-byte aligned.

How would you go about handling out-of-band IV in the RX path? In the TX
path, I can see how you could do that, but in RX?

In any case, if you can make usable patches for out-of-band IV I'm not
totally against it, but I'd like to keep the overhead as low as
possible. In particular, I was thinking of embedding tx_conf into
skb->cb[] so you wouldn't have space in there for the IV.

johannes

--=-E9Df6O4v/xqTCuUkNIe1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/ol6KVg1VMiehFYAQL5ZRAAuCk0AEpXy8rDk63eDAgAJR8/fYqCr6Ee
3chiu0VSyE1256YcIJtrmi2FZ+NTb0OjRaBiZznDE/VZRFfVjzyO7d63akHodt4U
jRdVjjl++Q+gVf/dsWU2UIutZVXCtlpZLv5g7IYu1CBp5nbfPkHZSfNsoFm0x147
K4hEmLteqtqj9SP9FvP2+h6Gooluaf+H9ErOGRTM5dk6HHHV4gyDTM1DAtpElxbj
rvHpZoP/RxtkUUavP13WOujnuqkSmt/dR+POMQXMxMNoPDRpKsDnJP9Ik092UezJ
TYvFe6a5d6pAMtRtL4vg5sX4vxmkKtR41TlAaL4lAIPScZfknVXQUA/55f7O85II
0hdek/G6c1xPtXwE8Sr1UuM8dleckIBOF04cYXbbny/urKHZqJW2DF6E2Gle+XBG
unN8W0FhGSVdzRpMwMDOYTFOIq6HODDbVMJYgyLsaltRvNF4Plmndppp6PERSiZl
v35Iofj/YjQHxiX97jWYAXCFy1+dzMiLrQmwIb3RJ++AzmGx8Zp0hGzULdkMRNXt
cBDkwiEDiKZEOL4SxaTURQ8KwKXnGC5hSocrr/z2/hdj++RR2oJNfmUDvIbLAKVr
tKfJhIa82n2M2A8ZZ1QnV1t6lN+nx7A0rgCuWKhMGl0UCkhReaQ1Ys30ay3rnHpO
633IR5SY1Ok=
=MMFo
-----END PGP SIGNATURE-----

--=-E9Df6O4v/xqTCuUkNIe1--

