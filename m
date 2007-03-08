Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34649 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933065AbXCHTJp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2007 14:09:45 -0500
Subject: Re: cfg/nl80211 primitives
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jkm@devicescape.com>
Cc: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070308004940.GC31388@devicescape.com>
References: <1173219649.3503.50.camel@johannes.berg>
	 <20070308004940.GC31388@devicescape.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UFgAVs/ah76TcbSQh51L"
Date: Thu, 08 Mar 2007 20:09:37 +0100
Message-Id: <1173380977.3248.55.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UFgAVs/ah76TcbSQh51L
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-03-07 at 16:49 -0800, Jouni Malinen wrote:

> And where would
>    (5) change some parameters within this association without triggering
>        new authentication/association
> fit in?

For that case it's just a new configure command I suppose.

> > However, I don't see why we shouldn't go to a model where we give the
> > kernel all information it needs to do an operation when we want it to d=
o
> > it, like the procedure
> >  (1) tell the kernel to do X
> >    - using parameter A=3DB
> >    - using parameter C=3DD
> >    - ...
> >  (2) tell the kernel to do Y
>=20
> Would this be all parameters as in _no_ other parameters could be set
> before or after the command? As an example, how would one set
> fragmentation threshold and then change that value after having
> associated?

Actually, things like the fragmentation threshold or say rx sensitivity
(where it can be set) don't really influence the association so for
those I'd think they are out of scope for the MLME SAP primitives.

> MLME SAP primitives may be okay for many cases, but we cannot limit
> ourselves to just the parameters defined there. Number of parameters do
> not go through MLME SAP interface and some of the options may require
> getting used to (e.g., power management options would use their own
> primitive, not MLME-ASSOCIATE, etc.).

Right.

> MLME SAP interface is between MLME and SME, but when we have some parts
> of MLME in user space and some in kernel, things can get bit confusing
> since the interface between MLME and SME is not the same as interface
> between kernel and user space.

True.

I think what I should have said when I wrote this email is that I
dislike having this "transaction layer" in the kernel where you set a
bunch of settings and then "commit" them by saying "please associate now
with whatever settings I told you to use".

What I'd like to see instead is that you give the MLME (whether it's in
the kernel or in userspace[1]) all the parameters it needs to do one
action when telling it to do that action.

I'm not saying that we should limit ourselves to the parameters outlined
in the MLME SAP interface nor that we should really follow it closely.

johannes

[1] since we said we'd want the userspace mlme to be controlled by
nl80211 through the kernel

--=-UFgAVs/ah76TcbSQh51L
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF8F9x/ETPhpq3jKURAt4CAKCwhIFfSlDIQry4iPKU0tRGQYK7ygCgsn1o
0Ux013zjgVn6sbXqFc4IA/A=
=OENd
-----END PGP SIGNATURE-----

--=-UFgAVs/ah76TcbSQh51L--

