Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48109 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S943521AbXHMLAF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 07:00:05 -0400
Subject: Re: [PATCH] hostapd: use eapol frames from ethernet device
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <1ba2fa240708130346h6175701cr2daab916afaed00f@mail.gmail.com>
References: <1186789737.4862.3.camel@johannes.berg>
	 <1186790012.4862.8.camel@johannes.berg>
	 <1ba2fa240708120358rb22a2f9me1a1020e669406e7@mail.gmail.com>
	 <1186995104.27916.56.camel@johannes.berg>
	 <1ba2fa240708130346h6175701cr2daab916afaed00f@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bxvJ6VCkwHg/QNgvYHyM"
Date: Mon, 13 Aug 2007 13:02:01 +0200
Message-Id: <1187002921.27916.77.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bxvJ6VCkwHg/QNgvYHyM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-08-13 at 13:46 +0300, Tomas Winkler wrote:

>  I think it was a polite query I've made, don't see any reason to use
> this language. If you precept it otherwise I apologize it wasn't my
> intention.

Apologies. I seriously don't understand that comment though, the patch
didn't touch the management interface at all, in fact it renamed only a
few variables and changed EAPOL frame receiving from using the
management interface to the ethernet framed interface.

> They have management meaning. So it was appropriate to route them
> through management interface rather then from data interface.

I'm not sure we understand each other. The only thing I changed with
this patch and the corresponding kernel patch is that all data frames
including those that are used for management purposes are now routed
through the data interface. Why do you think that is wrong? Reordering
your mail a bit, you also said

> On the contrary what I'm saying that EAPOL packets are the only data
> packets that should go up until handshake is done.

which seems to agree with me. You can achieve the effect of letting
*only* EAPOL packets through by setting the 802.1X protection parameter
on the network interface via the private prism ioctl, hostapd doesn't
seem to do that unless explicitly requested though.

The actual technical reason for doing is that subsequent patches totally
remove the management interface and on the monitor interface the EAPOL
frames show up undecrypted.

johannes

--=-bxvJ6VCkwHg/QNgvYHyM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGwDop/ETPhpq3jKURAqNFAKCmmmcoqWf/QIXSSlxlvnepQXTuLACeNFbM
aIYUtEle3yoefgeL8TabsL8=
=jwiz
-----END PGP SIGNATURE-----

--=-bxvJ6VCkwHg/QNgvYHyM--

