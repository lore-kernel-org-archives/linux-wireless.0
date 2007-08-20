Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44095 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223AbXHTL5m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2007 07:57:42 -0400
Subject: Re: [PATCH] hostapd: use eapol frames from ethernet device
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Tomas Winkler <tomasw@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
In-Reply-To: <20070815041602.GP1415@jm.kir.nu>
References: <1186789737.4862.3.camel@johannes.berg>
	 <1186790012.4862.8.camel@johannes.berg>
	 <1ba2fa240708120358rb22a2f9me1a1020e669406e7@mail.gmail.com>
	 <1186995104.27916.56.camel@johannes.berg>
	 <1ba2fa240708130346h6175701cr2daab916afaed00f@mail.gmail.com>
	 <1187002921.27916.77.camel@johannes.berg> <20070815041602.GP1415@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-X7GgRNg7NtbAC32+oJSj"
Date: Mon, 20 Aug 2007 13:57:15 +0200
Message-Id: <1187611035.6090.98.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-X7GgRNg7NtbAC32+oJSj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-08-14 at 21:16 -0700, Jouni Malinen wrote:

> - user space needs to be able to transmit EAPOL frames encrypted
>   (WPA/WPA2) and in plain (IEEE 802.1X with dynamic WEP) even if keys
>   are configured for the receiver; how is this done for the IEEE 802.1X
>   rekeying case?

Indeed, I hadn't fully considered the rekeying case. However, we
currently injected EAPOL frames via the management interface to achieve
this behaviour, it should be easy to achieve the same via the radiotap
injection interface.

> - management frames will need to be encrypted and decrypted in kernel
>   (802.11w), e.g., when user space is sending and receiving action
>   frames; i.e., there would need to be a mechanism to receive management
>   frames that has been decrypted by the kernel and to be able to send
>   management frames with kernel doing encryption; both are optional and
>   depend on the key configuration for the sender/receiver

Again, when sending them this should be part of the radiotap interface,
reception is a bit more complicated, however; see below.

> - plaintext EAPOL frames need to be received in some cases (mainly, IEEE
>   802.1X with dynamic WEP) even if there is a configured key for the
>   sending; ideally, user space apps would know whether the frame was
>   encrypted or not

If they're received unencrypted they will show up on monitor interfaces
regardless of encryption, they may or may not show up on the
802.3-framed device. Currently, EAPOL packets seem to be allowed
through, but if we go for monitor interfaces we might as well not have
them come through the 802.3-framed interface unless 802.1X is configured
to allow unencrypted frames through.

> I don't really like the idea of having to implement encryption and
> decryption for all these frames in both the user and kernel space.
> Furthermore, some things like receiption of unencrypted EAPOL frames
> would be quite difficult to do in user space unless the kernel were
> actually to help here.

I agree. The radiotap injection provides us with a means to fully
control what is happening when we need to send frames, so I wouldn't
worry about that. If anything, we'd need to extend the radiotap a bit;
there is apparently some work underway to make a "vendor-specific"
extension for radiotap that we could use in Linux.

As for receiving encrypted frames, I recently floated the idea to
introduce a crypto hook very early in frame processing so that to the
rest of the code it looks almost though the hardware was fully capable
of doing hardware offload for all encryption operations (might or might
not include MIC etc).

This has some seemingly weird implications, but ultimately it would mean
that the distinction between software and hardware encryption becomes
transparent at all levels which is a good thing. It would also mean that
the decrypted frames (if decryption was possible) show up on monitor
interfaces with a flag indicating that they were encrypted which should
address all needs here.

johannes

--=-X7GgRNg7NtbAC32+oJSj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGyYGb/ETPhpq3jKURAuB0AKCkNBCBzyjmUNy9i4BrOaO+zG4/pQCgk7o3
CUuVsTd/vxSg/mxvEc+xvUU=
=fWZ2
-----END PGP SIGNATURE-----

--=-X7GgRNg7NtbAC32+oJSj--

