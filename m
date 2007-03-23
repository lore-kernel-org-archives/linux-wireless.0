Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41497 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422916AbXCWN6g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 09:58:36 -0400
Subject: Re: [PATCH 0/4] Try #5: Radiotap on Monitor Mode interfaces for rx  and tx
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Green <andy@warmcat.com>
Cc: linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <46039679.6080401@warmcat.com>
References: <20070320103955.600509703@warmcat.com>
	 <1174500637.3944.9.camel@johannes.berg>  <46039679.6080401@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RAFa5/XeNE8pg6Q3bCJm"
Date: Fri, 23 Mar 2007 14:57:15 +0100
Message-Id: <1174658235.3366.19.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RAFa5/XeNE8pg6Q3bCJm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-03-23 at 08:57 +0000, Andy Green wrote:

> $ cd wireless-dev
> $ grep cfg80211 Documentation/* -R
>=20
> As a Johnny-come-lately noob, how should I find out that cfg80211 either=20
> exists or how it works?  Far from some kind of turf war initiating=20
> gauntlet throwing, I was unaware cfg80211 was an option.

Yep, my mistake. I blame lack of time and cooperation, nobody but me
seems to be actually interested in working on cfg80211.

> My interest is being able to inject broadcast packets from userspace=20
> with fine control over how it goes out.  I have now tried several ways=20
> to get that to happen with varying success, patching drivers in the old=20
> stack (worked but impractical for wide uptake), using the management=20
> interface in the new stack (works but it is heading towards deprecation=20
> and did not allow rate control) and finally the Monitor mode injection=20
> (works perfectly but requires to convince you guys to include it).

Yep, I know.

> send()ing packets back up a Monitor Mode interface with the same=20
> radiotap semantics as the came out of it with is the most natural and=20
> portable (libpcap pcap_inject() just works with it on the same network=20
> interface as it can capture on) way to do injection from a usermode and=20
> architectural standpoint.

Right, and I'm not saying it doesn't make sense. I'm just trying to say
that before we add this interface we really need to figure out whether
it's feasible that this interface replaces all the wext/prism ioctl foo.

> I don't understand why Monitor Mode injection needs to fly under the=20
> cfg80211 flag.  It seems to belong to mac80211 code and would continue=20
> to work if cfg80211 was disabled.  Can you explain a bit more why it=20
> logically belongs in that category?

Because of the userspace MLME that cfg80211 needs to support. At the
second wireless summit in London we have decided that the userspace MLME
should be transparent to users in that they still simply use nl80211 and
the kernel forwards the requests to the userspace MLME and also forwards
the responses. Therefore, most of the userspace MLME handling needs to
live in cfg80211, which makes cfg80211 also the logical point to define
injection at since the userspace MLME requires it.

johannes

--=-RAFa5/XeNE8pg6Q3bCJm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGA9y7/ETPhpq3jKURAjaxAKCSoMax6rMwcMjA2Bxf+KnYIkjbMACgm6f9
cnF1Ui5qDVTjD71N3Po6zdc=
=1bQl
-----END PGP SIGNATURE-----

--=-RAFa5/XeNE8pg6Q3bCJm--

