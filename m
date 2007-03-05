Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52293 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbXCEAMA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2007 19:12:00 -0500
Subject: Re: [patch] at76_usb wireless driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: Guido Guenther <agx@sigxcpu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070304020920.b5lej3sw0oogwg4w@webmail.spamcop.net>
References: <20070110145724.GA4171@bogon.ms20.nix>
	 <20070223221230.GA9965@bogon.ms20.nix>
	 <20070303150029.GA19940@bogon.ms20.nix>
	 <1172934588.4966.46.camel@johannes.berg>
	 <1172939037.4966.97.camel@johannes.berg>
	 <20070304020920.b5lej3sw0oogwg4w@webmail.spamcop.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mFqlMJ+syZTEhJalQjpz"
Date: Mon, 05 Mar 2007 01:11:33 +0100
Message-Id: <1173053493.6131.35.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mFqlMJ+syZTEhJalQjpz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

And some more ;) These are mostly like "couldn't you do this and it'd
make changing the driver a bit less hazardous" :)

(We need to fix this in mac80211 too in various places)
You should probably use ARRAY_SIZE() in quite a few places, e.g.
at76c503_handler_def, getRegDomain and possibly more

I don't really remember, but wasn't the general concensus last time this
came up that the wext nickname is pretty much useless and doesn't really
need to be settable? I know, it's only like 5 lines of code :)


        /* do the restart after two seconds to catch
         * following ioctl's (from more params of iwconfig)
         * in _one_ restart */
        mod_timer(&dev->restart_timer, jiffies+2*HZ);

Isn't that why you should have a commit call in the first place? This
seems pointless. Or do you just do this because people expect "iwconfig
ethN essid mygreatAP" to actually do something right away (they really
shouldn't)?

"Firmware names - this must be in sync with boardtype definitions"

I guess you could use C99 array initialisers for the firmwares array to
make it safer.

#define DRIVER_AUTHOR ...

I think it's perfectly valid to have multiple MODULE_AUTHOR lines and
having a define for this (and DRIVER_DESC) seems pointless.

You can probably replace the semaphore by a mutex.

johannes

--=-mFqlMJ+syZTEhJalQjpz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF62A1/ETPhpq3jKURAq3qAJwL5wq/eD5IrFRjRetN9FDvLzoj4QCgjGng
Dps94ojGX2pZqCqBPE7dfkY=
=jU1A
-----END PGP SIGNATURE-----

--=-mFqlMJ+syZTEhJalQjpz--

