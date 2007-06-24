Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57784 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbXFXJhE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jun 2007 05:37:04 -0400
Subject: Re: [WIP] mac80211: kill mgmt interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Green <andy@warmcat.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <467E3089.2080602@warmcat.com>
References: <1182418939.10821.8.camel@johannes.berg>
	 <20070621143558.68fc8e4a@griffin.suse.cz>
	 <1182429920.21939.1.camel@johannes.berg>
	 <20070621151441.500d62d5@griffin.suse.cz>
	 <20070622154545.29eeebdb@griffin.suse.cz> <467BDCB1.1010604@warmcat.com>
	 <1182526221.21939.94.camel@johannes.berg>
	 <20070622174953.500817e0@griffin.suse.cz>
	 <1182543620.21939.98.camel@johannes.berg>  <467CB691.2090806@warmcat.com>
	 <1182581630.21939.105.camel@johannes.berg>  <467CE130.2080306@warmcat.com>
	 <1182635313.21939.122.camel@johannes.berg>  <467E3089.2080602@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SI62rmQhKwHxIgjhHwb8"
Date: Sun, 24 Jun 2007 11:38:37 +0200
Message-Id: <1182677917.21939.133.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SI62rmQhKwHxIgjhHwb8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-06-24 at 09:51 +0100, Andy Green wrote:

> The thing that it buys is allowing injection in a standardized format on
> interfaces in any mode.  Currently the fact that a TX packet comes on a
> Monitor Mode interface is used to infer the format of it, that it will
> have a radiotap header.  That's not too ugly, but allowing
> injection/radiotap format packets to be accepted on any interface in any
> mode (eg, Master) and to use an ethhdr to determine the structure of the
> packet is a bit more general and clean, since that is the job of the
> ethhdr everywhere.

The real question IMHO is if we actually want that. And I don't think
we'll find an easy solution for say the qdisc dropping the packet before
we see it.

> It'll be interesting to see what the genuine primitives are for the MLME
> after you are finished ejecting the ioctl type cruft.  I don't have much
> idea of what is truly needed as it stands.

I think I'm pretty much done killing all the currently unused ioctls.
Jouni's mail contained a short overview that seemed fairly complete
though lacking details.

johannes

--=-SI62rmQhKwHxIgjhHwb8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGfjud/ETPhpq3jKURAlnCAJ0eV7/TVJ5M4IPuMCXv8LvSAi7zOQCfR7ul
dcHg73Ag8w3YMmIWukB9vgI=
=K02g
-----END PGP SIGNATURE-----

--=-SI62rmQhKwHxIgjhHwb8--

