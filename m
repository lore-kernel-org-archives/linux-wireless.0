Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49378 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbZFJHa6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 03:30:58 -0400
Subject: Re: Testing AP mode with WLAN-USB-Stick: How to obtain?
From: Johannes Berg <johannes@sipsolutions.net>
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	Stefan Steuerwald <salsasepp@googlemail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <3ace41890906092018o76b0ee62n91819779a8ccd6db@mail.gmail.com>
References: <f76a32050906081007q19e9361w8c1fad6fc73c47e7@mail.gmail.com>
	 <f76a32050906081011o589474f2geba321c58c0872c2@mail.gmail.com>
	 <3ace41890906081659o23cb9ee1sd82ca4fc28a3793d@mail.gmail.com>
	 <69e28c910906090426l4c383665rdc4bffc501085661@mail.gmail.com>
	 <3ace41890906092018o76b0ee62n91819779a8ccd6db@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-FAO70DTvJ5JSDargv8N+"
Date: Wed, 10 Jun 2009 09:30:27 +0200
Message-Id: <1244619027.18481.55.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FAO70DTvJ5JSDargv8N+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-06-10 at 04:18 +0100, Hin-Tak Leung wrote:

> But I have been using vendor driver 3.0 for a few weeks in AP mode and
> I am as happy with it as I could be, I think; I have
> suspended//resumed clients.  It works adequately.=20

We're not concerned about suspend/hibernate, we're concerned about
802.11 power saving, where the AP is required to buffer frames until the
clients wake up again. This will work adequately, but not perfectly, for
unicast frames, but we have not found a way of making zd1211 send
buffered multicast frames after the DTIM beacon as required.

This means that your sleeping clients will not be receiving multicast,
and as such be invisible to the network once they fall off the ARP/NDP
caches. This is the reason we have said that it will not be possible to
support AP mode with this card. I'm curious how, if at all, the vendor
driver handles that.

johannes

--=-FAO70DTvJ5JSDargv8N+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKL2EQAAoJEODzc/N7+QmarqkP/2RrkA1QgqfMuuTtP45VqDCJ
Jfl8SzFAab4FHpuOXanfR+PtWjCTKhcy3Xs1pgSwUa7phaRm/z+0QrIVEAzio+Qk
XbYjW69FCxbx2PnE1KKsntGMQxoY8eEfbJeH+XBcVeb8+k58Do8bWPYN1yFKTioF
3aXPjqsJVgb2nCfeBmNEMzWdvRJ+xYq3qjMnGNM+naOyehv8TYDI33Rw55v9yVzr
sBFfFtJs9111Jx/aDiaSvA0EyrgNdFKtC8S/JGS8ewMvgXJVuUZFiwti9dGyzj0F
NVt4xldWD5OkPeTEbMs2GT0vFS9Q1G47UDZsm0mmMPNLTWPvflNWDt7IUZf2NzGV
TcKakHoFNcAWtOtXdrkz19KtAvZrrbog+4kUU0w0ODqG9hGKlbl02xPJsZz8LP7Y
JRWeZUUY0vBsHZGKkkTI6Ex067tzJZukNLIx5TaawZvLvhfo/uasbPIeG2oaHqCV
RsP/2OFGFcnsHeXf3rYZPOm0WfIrV4bEH+GlLMO5A96e8vz3PnPsATve2S+AR2+y
5LbZjHVRzA1hCveQjyMs0IMIszmuRsg+8eQyqLNrIM2PADKlB5iWIL9U/B/xjXUu
qObzPcQytgP8nNqWZSndoXBMJo0GP0jndL4da8Cn+okNBd5QUoTapBvRPmwuyeRn
44ubExLsFUQZ1qCgNuye
=nZ3Y
-----END PGP SIGNATURE-----

--=-FAO70DTvJ5JSDargv8N+--

