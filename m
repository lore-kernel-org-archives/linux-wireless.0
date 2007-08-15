Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51326 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbXHOK4o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 06:56:44 -0400
Subject: Re: [PATCH] hostapd: use eapol frames from ethernet device
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <1ba2fa240708141546g4de44ff1v94db00213a3187aa@mail.gmail.com>
References: <1186789737.4862.3.camel@johannes.berg>
	 <1186790012.4862.8.camel@johannes.berg>
	 <1ba2fa240708120358rb22a2f9me1a1020e669406e7@mail.gmail.com>
	 <1186995104.27916.56.camel@johannes.berg>
	 <1ba2fa240708130346h6175701cr2daab916afaed00f@mail.gmail.com>
	 <1187002921.27916.77.camel@johannes.berg>
	 <1ba2fa240708141546g4de44ff1v94db00213a3187aa@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rp/ZzOCLY2+xqlG3LB2+"
Date: Wed, 15 Aug 2007 12:58:56 +0200
Message-Id: <1187175536.3998.21.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rp/ZzOCLY2+xqlG3LB2+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-08-15 at 01:46 +0300, Tomas Winkler wrote:

> Can you enlighten me and tell me why the monitor interface is
> preferable over management interface? I've probably got busy and
> missed the whole conversation.

Oh, I can name a number of reasons :)
 * magic needed to conjure it
 * munged prism2 header that nothing but hostapd/wpa_supplicant
   understands
 * special cases all over the code to stuff frames there

> I'm not so familiar with monitor interface but isn't it to be
> sniffing interface - everything goes up including data raw packets.

Well, in a way you're right. But please review the recent filter flags
patches I posted. And I'm using BPF to avoid seeing data frames other
than those I need.

> What if management frames needs decryption? I think this is 802.11w
> specs that defines that.

I thought radiotap injection could handle that, but it turns out that I
need to think again, especially about EAPOL frames. I'll address these
things in a reply to Jouni's mail, but that'll take a bit longer than
just going through and replying.

johannes

--=-rp/ZzOCLY2+xqlG3LB2+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGwtxw/ETPhpq3jKURAvShAKCFQYsfGY751vSa94vYsgFXt8d6HACfTiFv
rJiHH/bp3oUGMpbeaaukXU0=
=/qJs
-----END PGP SIGNATURE-----

--=-rp/ZzOCLY2+xqlG3LB2+--

