Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49545 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756647AbYDCOB7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 10:01:59 -0400
Subject: Re: mac80211 -- My log files are filling up with: "wlan0: RX
	non-WEP frame, but expected encryption"
From: Johannes Berg <johannes@sipsolutions.net>
To: Miles Lane <miles.lane@gmail.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <1207226756.3636.66.camel@johannes.berg> (sfid-20080403_135257_509725_35FED48D)
References: <a44ae5cd0804021732s6ae5ed81ma5e229ae0faf4aaf@mail.gmail.com>
	 (sfid-20080403_013238_466005_CF563BE7)  <1207226756.3636.66.camel@johannes.berg>
	 (sfid-20080403_135257_509725_35FED48D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RQXjw6wR2Qne1k5ac4qM"
Date: Thu, 03 Apr 2008 16:01:53 +0200
Message-Id: <1207231313.3636.100.camel@johannes.berg> (sfid-20080403_150208_976496_CEC31E7F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RQXjw6wR2Qne1k5ac4qM
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


On Thu, 2008-04-03 at 14:45 +0200, Johannes Berg wrote:
> Hi,
>=20
> Please copy the mailing list, I've done that now.
>=20
> > My log files are filling up with these messages:
> >=20
> >        [ 8722.198929] wlan0: RX non-WEP frame, but expected encryption
> >        [ 8726.506345] __ratelimit: 14 messages suppressed

> > It seems that others who are using Netgear WPN824 access points are
> > also seeing these messages in their logs.
> > http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=3D1614
> > http://ubuntuforums.org/showthread.php?t=3D637084

Ok, I got packets from Miles, and this is what I found:

IEEE 802.11 Data, Flags: ......F.
    Type/Subtype: Data (0x20)
    Frame Control: 0x0208 (Normal)
        Version: 0
        Type: Data frame (2)
        Subtype: 0
        Flags: 0x2
            DS status: Frame from DS to a STA via AP(To DS: 0 From DS: 1) (=
0x02)
            .... .0.. =3D More Fragments: This is the last fragment
            .... 0... =3D Retry: Frame is not being retransmitted
            ...0 .... =3D PWR MGT: STA will stay up
            ..0. .... =3D More Data: No data buffered
            .0.. .... =3D Protected flag: Data is not protected
            0... .... =3D Order flag: Not strictly ordered
    Duration: 44
    Destination address: <his STA MAC>
    BSS Id: <his Netgear AP>
    Source address: <his Netgear AP>
    Fragment number: 0
    Sequence number: 3874
Logical-Link Control
    DSAP: NULL LSAP (0x00)
    IG Bit: Individual
    SSAP: NULL LSAP (0x00)
    CR Bit: Command
    Control field: I, N(R)=3D0, N(S)=3D0 (0x0000)
        0000 000. .... .... =3D N(R): 0
        .... .... 0000 000. =3D N(S): 0
        .... .... .... ...0 =3D Frame type: Information frame (0x0000)
Data (1472 bytes)

0000  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
* all zeroes
05b0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
    Data: 000000000000000000000000000000000000000000000000...


Note how the LLC header is also all-zeroes. =EF=BB=BFAlso note how the dura=
tion
field is totally bogus. The sequence number is actually correct.

Does anybody have an explanation for that except that the AP software is
messing it up?

In any case, I suppose the message in question isn't actually necessary.
I'll make it depend on verbose debugging maybe.

johannes

--=-RQXjw6wR2Qne1k5ac4qM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/TjUKVg1VMiehFYAQICCw//YNZGMZCN6IkHHs72OgbIpUKNVfDg4S4w
Q03RJu0EWeYCzCxLMEPJjrRSpAXvFtM+Gkj9ISFBM9iKWazzaU8vaEpdMhPVJIva
qUTT4bjo8Jgd4/tuTCMGYIUdzJZTVwNwQ4W5YOpiodmIdzwCdaK3anL1qdLp7B9P
Uwc1XiIKvexS4rQwDmylkwYkpP1pIoveF0L9y21kta4WN2nQqiN9nYVP8ZP21OVj
+Ow4ME8TTfqv6B+1UNT+a5m/53bkD7wXRhxpA1UZQxApfBvmyek/uuUn/k3mPDMm
PTDX6MuOmxT3jdfbeX6kRnbEcShVfMJrJP0dIqwn7YzehQxnczW9Zb3nY/Dv7FDY
ShZyX4rI2YMylA5xCuM+FZfwU33+Bj/fO/ROq8A8Dm1+7kcBeqzLMz5/BA2YMP74
1QaQPbzzfWstMpquuH7Qz4lUY8pC1eVoQ7ruVVB1++78An4K2rjrI/tsed46roY5
i9w0JdIckL0BbCE8Gl95G7ZqTAOLLPIpJodXtJq6wUkY13VIXoIdVFu39paBX4I6
s3yk+Jrs2BKDvkwQR0uYfhisCqb+vRcPUoRJuz8YHYEYU1oIJzUJlCtr9I/TprcS
k+SJERPbAgc2Tpw5YUo7uq/JEmr3Kf8sF6vlNCg81V2rYFVA/6cgiRaGMSXMrw5z
zQUl9EAqDSM=
=kZUC
-----END PGP SIGNATURE-----

--=-RQXjw6wR2Qne1k5ac4qM--

