Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38948 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030818AbXCHWfX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2007 17:35:23 -0500
Subject: Re: wireless extensions vs. 64-bit architectures
From: Johannes Berg <johannes@sipsolutions.net>
To: jt@hpl.hp.com
Cc: Jouni Malinen <jkm@devicescape.com>, Michael Buesch <mb@bu3sch.de>,
	linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
	Jeff Garzik <jgarzik@pobox.com>, Dan Williams <dcbw@redhat.com>
In-Reply-To: <20070308221128.GA24884@bougret.hpl.hp.com>
References: <1173144447.15891.93.camel@johannes.berg>
	 <20070306171316.GA19669@bougret.hpl.hp.com>
	 <200703061943.07350.mb@bu3sch.de>
	 <20070307020310.GA20466@bougret.hpl.hp.com>
	 <1173364747.14001.7.camel@johannes.berg>
	 <20070308184954.GA24485@bougret.hpl.hp.com>
	 <1173382042.3248.63.camel@johannes.berg>
	 <20070308193412.GG23040@devicescape.com>
	 <1173382802.3248.68.camel@johannes.berg>
	 <20070308221128.GA24884@bougret.hpl.hp.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MKmjLJ2Pf7rQsDWiGxsQ"
Date: Thu, 08 Mar 2007 23:35:26 +0100
Message-Id: <1173393326.3831.21.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MKmjLJ2Pf7rQsDWiGxsQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-03-08 at 14:11 -0800, Jean Tourrilhes wrote:

> 	First possiblity, we could stick with this band-aid
> permanently.

It sucks for various reasons, one for example being that I don't even
understand your recognition code but all userspace programs that use
wext will have to include such code!

> 	Second possiblity : we do the right thing and plan a API
> change to return struct always aligned on 32 bits. This way, when we
> get 128 bit processor, we don't have to add another band aid ;-)
> 	It would work like the ESSID changeover. We pick a WE version
> changeover. We introduce userspace that can deal with before and
> after. After 1 or 2 years, we flip the switch. After another 1 or 2
> years, we get rid of backward compatibility.

Probably doesn't make much sense, we might as well schedule wext for
removal by then and just make the effort to replace at least for all
IEEE 802.11 hardware. And then we rip out the compat ioctls completely
(just deny them) so if someone's stupid enough to use really really old
hw in new machines (where that even works) they need a 64-bit userspace.

> 	Third possibility : we declare 32 bit userspace on 64 bit
> kernel as not supported and advise users to get a 64 bit
> userspace. The number of bug report on that issue would suggest that
> very few users are in this case.

Randy is right here, most a lot of powerpc64 users don't bother
compiling 64-bit userspace apps since there's not much point in it.
Also, a lot of distros don't even distinguish between powerpc32 and
powerpc64 so debian for example can't possibly fix this by shipping
64-bit versions of the affected tools. Besides, a 64-bit network manager
couldn't integrate with gnome-panel I'd think.

The only real fix to me is fixing it in the kernel, but as you say
that's very icky.

johannes

--=-MKmjLJ2Pf7rQsDWiGxsQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF8I+u/ETPhpq3jKURAv/xAJ4mcI6TiFV3NPEYhRw7OhvTLFiCfACgsjME
DouP/SNnPbcvXe6qH2lhBcQ=
=A8Yv
-----END PGP SIGNATURE-----

--=-MKmjLJ2Pf7rQsDWiGxsQ--

