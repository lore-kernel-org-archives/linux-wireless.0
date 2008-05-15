Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35950 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297AbYEOLuH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2008 07:50:07 -0400
Subject: Re: [PATCH 5/5] mac80211: move TX info into skb->cb
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
In-Reply-To: <200805151358.36340.IvDoorn@gmail.com> (sfid-20080515_134607_757865_EB404B1A)
References: <20080515105524.359863000@sipsolutions.net>
	 <200805151332.35758.IvDoorn@gmail.com>
	 <1210850544.8709.3.camel@johannes.berg>
	 <200805151358.36340.IvDoorn@gmail.com>
	 (sfid-20080515_134607_757865_EB404B1A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4wFyl0IO1urcuziXx+yo"
Date: Thu, 15 May 2008 13:49:14 +0200
Message-Id: <1210852154.8709.10.camel@johannes.berg> (sfid-20080515_135013_794014_71253778)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4wFyl0IO1urcuziXx+yo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Yeah, but the patch you had sent me was removing the "driver generated"
> > flag, and I kept that around now for this purpose.
>=20
> I think we refer to different things when we talk about "queue kicking" ;=
)
> Anyway, I'm fine with how it looks like now. It means I can remove a few
> patches from rt2x00.git :)

Maybe :) I was talking about this hunk:

@@ -179,8 +176,10 @@ void rt2x00queue_write_tx_descriptor(str
=20
        /*
         * We are done writing the frame to the queue entry,
-        * if this entry is a RTS of CTS-to-self frame we are done,
-        * otherwise we need to kick the queue.
+        * also kick the queue in case the correct flags are set,
+        * note that this will automatically filter beacons and
+        * RTS/CTS frames since those frames don't have this flag
+        * set.
         */
        if (rt2x00dev->ops->lib->kick_tx_queue &&
            !(skbdesc->flags & FRAME_DESC_DRIVER_GENERATED))

which looked vastly different in your original version and tested
IEEE80211_TX_CTL_READY_FOR_TX I think.

But if you're ok with that, that's great :)

> > I have thought about this a bit, you may want to wait wrt. fragments
> > because I'm going to rewrite fragmentation, and then we could change th=
e
> > mac80211/driver API to hand the driver an skb with all the fragments at
> > once instead of handing it each fragment one by one, thoughts?
>=20
> Well that would mostly be beneficial for rt61pci who is able to attach
> multiple fragments into a single queue entry. But for the others that wou=
ldn't
> matter that much since each fragment occupies a single queue entry, so fo=
r
> those drivers having mac80211 calling tx() multiple times, or having rt2x=
00
> call write_tx_frame() multiple times isn't a big difference other then rt=
2x00
> being able to better control frame flow by kicking the TX queue only when
> all fragments are in the queue.

Well I expect that this would have to be controlled by a hardware flag
anyway. Also, it might get you into trouble with the number of free
queue entries because mac80211 would definitely expect you to take all
fragments then, you couldn't just take the first 2 and leave 2 to
mac80211, for example.

johannes

--=-4wFyl0IO1urcuziXx+yo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCwjOKVg1VMiehFYAQJ2cRAAxKnPXN7lKP1UEFXy8x8oivddqCQxXYxJ
Hl+acoXkajlwJIC4XsfOXzeZ7AusG3nfm11XSRZw9jvPVOArjVIfpwz5VsY24F91
qIKFwmI6rqeUlIsNeV59FPi8DAzH9xpEUHRAFrHIf13g0zZBLP/4c/63rBDic9Hm
7m/Su+nFnLL4Tnl0FrhqVBQN6r0rmgCqNLewuRIvB16xEpZpPj6vsFQ2lJac0lmS
nmA0FpCW/Gaq9Q+xnyT6oXxVn4zRL3ADscRJjSHdeeO8aHBAy+9deqYK8cSsEZ84
w8kc0miGbXU7g4xv/XvN0ZA4W7zwIs4nmnxRAvxJGFUca5BKZqZthx9f57g7Xxos
65tnScg6bQC6LZOJwtWy2moItQwnnH8hkARjqqeyfIPWrO79kTqk2YaqSAbi7p0Z
YBGwKYbFxYxJ/RU84TQSsWpm3egDH3e0qToHe4QB0jAH6uh8yRuUdeDMgRsiLKhl
N3Xk2gz3FwzUhvOBcFc7rw7CuUBWOHFEj/uQEXrWqmltOP/E1hCvfpt9aA0nAEoN
FcuGCHkQ8PIR+Kj1Q36Nm5zkq1iEN5VUy5kh4uV/aU6Xxj80hGXiohgOmyHkNXSx
N09z/l1BBRN9QvQ+WVkJNzEab14Sb+RqWmyghVt6rm82b/hBXvIxcKuu2pBSGoa3
LqzLnBYYh6w=
=/BuW
-----END PGP SIGNATURE-----

--=-4wFyl0IO1urcuziXx+yo--

