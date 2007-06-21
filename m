Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52507 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365AbXFUMoS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2007 08:44:18 -0400
Subject: Re: [WIP] mac80211: kill mgmt interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070621143558.68fc8e4a@griffin.suse.cz>
References: <1182418939.10821.8.camel@johannes.berg>
	 <20070621143558.68fc8e4a@griffin.suse.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-z6ufNBI422nbaG34cecW"
Date: Thu, 21 Jun 2007 14:45:19 +0200
Message-Id: <1182429920.21939.1.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-z6ufNBI422nbaG34cecW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-06-21 at 14:35 +0200, Jiri Benc wrote:

> 1. I'm still not sure if using monitor interface for this purpose is a
> good idea. Given the fact we want to switch to user space MLME, this
> will mean that at least one monitor interface is always present. So we
> got rid of management interface just to introduce another user visible
> magic interface.

Well, that's not a bad point, but at least it's not created via magic
ioctls etc.

> 2. How is hostapd (or other programs) supposed to connect frames
> returned on monitor interface with frames it sent? Does it need to
> remember each sent frame and compare it with the ones received through
> the monitor interface? (It probably wouldn't work anyway because of seq
> numbers, sw encryption, etc).

Actually, I first thought that as well, but in fact the userspace MLME
in wpa_supplicant doesn't even need to connect these events, it simply
checks which auth sequence number it sent and then assumes that whatever
it did was correct and adds the sta to the associated/auth list on the
callback.

johannes

--=-z6ufNBI422nbaG34cecW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGenLf/ETPhpq3jKURApRqAKCyW8QIirkfFFFRz1udXF8am2XlXACgrke2
Vclec+wwZ5EJxUexGU7vxX0=
=KA6c
-----END PGP SIGNATURE-----

--=-z6ufNBI422nbaG34cecW--

