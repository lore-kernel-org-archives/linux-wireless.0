Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:32976 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763729AbXFEK4J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2007 06:56:09 -0400
Subject: Re: nl80211 status? (implying cfg80211 status)
From: Johannes Berg <johannes@sipsolutions.net>
To: David Lamparter <lists@diac24.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20070604193034.GA16350@charon.n2.diac24.net>
References: <20070604193034.GA16350@charon.n2.diac24.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3DsUXjw2HoAFVhbIcDKD"
Date: Tue, 05 Jun 2007 12:53:18 +0200
Message-Id: <1181040798.8274.10.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3DsUXjw2HoAFVhbIcDKD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi David,

> together with a friend of mine, I recently pondered about making linux
> wireless configuration utilities more friendly to use. He did some =20
> hacking to add wext to iproute2, but got "use nl80211" as reply. (cf.
> http://marc.info/?l=3Dlinux-netdev&m=3D117305184005985&w=3D2)

Ah right, I remember that. Yeah, wext isn't really going anywhere.

> However, nl80211 still isn't near any usable state. Worse yet, even
> the API is nowhere near sufficient for replacing wext. So I was
> wondering if anyone is working on this. (google pointed me to
> pynl80211, hence Cc: Johannes)

This, unfortunately, is true. If you look at the wireless-dev version of
include/linux/nl80211.h that's what I planned right now and that should
(unless I forgot something) be sufficient to replace some more wext
things, but there are also things missing, notably event reporting.
However, there's also hardly any code to unwrap the netlink messages and
translate them to cfg80211 calls (what there is is all in
net/wireless/nl80211.c).

> As far as I understand, the first thing to tackle is converting
> everything to cfg80211 and making wext call cfg80211 functions,
> putting all the compatibility cruft into that layer while at it.

I wouldn't necessarily start with that.

>  This
> could be done incrementally, step-by-step, couldn't it?

Yes, it could

>  Or is there
> major restructuring planned? If not, I'd certainly like spending a bit
> of work on this (my time is as limited as everyone's, but I do have
> some wasted time here and there). However, a proper outline of the API
> needs to be thought of first.

The outline of what the nl80211 userspace API provides is in
include/linux/nl80211.h, the outline of what cfg80211 provides is in
include/net/cfg80211.h (both in wireless-dev, mainline contains *really*
stripped down versions)

> My very-humble totally-irrelevant opinion would be that nl80211 should
> provide all neccessary operations, only much more cleanly than wext
> ;).

That's the plan :)

>  So that means, at least a PHY configuration command (am I missing
> something or is there none yet?) with attributes to specify channel &
> co.

Oh, heh, that does indeed seem to be missing...

>  The "set association" command might be extended to work for
> interfaces.

Not sure what you mean here. The NL80211_CMD_ASSOCIATE command as I see
it is modeled after the 802.11 mlme interface, nl80211.h says:

> * @NL80211_CMD_ASSOCIATE: associate with the given parameters
>  *      (%NL80211_ATTR_SSID is mandatory, %NL80211_ATTR_TIMEOUT_TU,
>  *      %NL80211_ATTR_BSSID, %NL80211_ATTR_CHANNEL, %NL80211_ATTR_PHYMODE=
,
>  *      and %NL80211_ATTR_IE may be given)

Hence, here we also have the ability to set the phy mode/channel. We
still need an explicit command for that though for monitor interfaces.

>  Proprietary/custom driver extensions could be handled as
> special attributes and/or special commands. (that explicitly excludes
> the PRISM2 cruft though, those are actually rather generic IMHO)

Do I look dead yet? No way. Proprietary/custom driver extensions live in
debugfs. If you need something that's generally useful, we can add it to
nl80211/cfg80211, otherwise you get to feel the pain of having it in
debugfs.

> P.S.: While I'm aware that changing kernel APIs is a very bad idea,
> I'm really thinking nl80211 isn't frozen yet. As far as I can tell,
> only iwspy and pynl80211 are using it at all. This hopefully won't end
> up as a compatibility nightmare AGAIN?

Oh, I very much agree, nl80211 isn't frozen yet (except for that tiny
part that's in mainline already). And all of nl80211 API are the numbers
in the nl80211.h header file that userspace gets to see, so...

johannes

--=-3DsUXjw2HoAFVhbIcDKD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGZUCd/ETPhpq3jKURAqw4AJ0aHaYgFFuy77REhLlTPSqDHM4/owCcCHCV
E37+XEAZjQrczoUjbQRP3Z0=
=tH0A
-----END PGP SIGNATURE-----

--=-3DsUXjw2HoAFVhbIcDKD--

