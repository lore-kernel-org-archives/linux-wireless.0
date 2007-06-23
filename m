Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42251 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbXFWGwd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jun 2007 02:52:33 -0400
Subject: Re: [WIP] mac80211: kill mgmt interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Green <andy@warmcat.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <467CB691.2090806@warmcat.com>
References: <1182418939.10821.8.camel@johannes.berg>
	 <20070621143558.68fc8e4a@griffin.suse.cz>
	 <1182429920.21939.1.camel@johannes.berg>
	 <20070621151441.500d62d5@griffin.suse.cz>
	 <20070622154545.29eeebdb@griffin.suse.cz> <467BDCB1.1010604@warmcat.com>
	 <1182526221.21939.94.camel@johannes.berg>
	 <20070622174953.500817e0@griffin.suse.cz>
	 <1182543620.21939.98.camel@johannes.berg>  <467CB691.2090806@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fls3WQF1S7a/0zvT0Bth"
Date: Sat, 23 Jun 2007 08:53:50 +0200
Message-Id: <1182581630.21939.105.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fls3WQF1S7a/0zvT0Bth
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-06-23 at 06:58 +0100, Andy Green wrote:
> Johannes Berg wrote:
>=20
> >> I think netlink is fine if it is used for injection too (at least of
> >> management frames and WPA stuff).
> >=20
> > I don't disagree. I'd even say that having both injection interfaces is
> > fine since they really cover different use cases.
>=20
> What are these different usage cases such that you need to maintain the
> two different ways of doing it?

Well one is yours which is rather similar to the "security-related"
tools (airsnort, aireplay, ...), you want to be able to send the frame
as much as you hand it to the kernel as possible.

On the other hand, I do consider userspace MLME needs slightly
different; it needs to be able to have frames encrypted, needs to see
frames that have been decrypted even though they would otherwise be
dropped [and this is very different to what you want], and probably
more.

I haven't seen a good proposal to unify this. To me, Jiri's proposal of
packing what is essentially out-of-band data into some sort of special
frames is no use, and your proposal to use monitor mode interfaces is
perfect for the first use case, but still leaves us with more
out-of-band data that the userspace MLME needs and hence doesn't gain us
much.

Who started this anti-nl80211 thing anyway? I still don't see what's so
wrong with sending frames down a PF_NETLINK socket rather than a
PF_PACKET socket.

johannes

--=-fls3WQF1S7a/0zvT0Bth
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGfMN+/ETPhpq3jKURAqy3AJ91x/fHRgjws00SBKqi1/5GVgrsPQCeOq2u
esbSnWcax4rgTyiX9ubYb2M=
=8Q9g
-----END PGP SIGNATURE-----

--=-fls3WQF1S7a/0zvT0Bth--

