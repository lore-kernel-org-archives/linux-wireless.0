Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:63339 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759355Ab3BNVFF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 16:05:05 -0500
Date: Thu, 14 Feb 2013 16:05:03 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Solomon Peachy <speachy@sagrad.com>
Subject: Re: [PATCH] rt2800usb: Add support for eeprom writes.
Message-ID: <20130214210502.GA24641@shaftnet.org> (sfid-20130214_220511_455754_F4C2E8AB)
References: <1360872580-24334-1-git-send-email-pizza@shaftnet.org>
 <1360872580-24334-2-git-send-email-pizza@shaftnet.org>
 <CAOZOX0Vva3ObJp6hW85i6m33zYxieTsbER78UVrp23uo=t4B9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
In-Reply-To: <CAOZOX0Vva3ObJp6hW85i6m33zYxieTsbER78UVrp23uo=t4B9A@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 14, 2013 at 09:25:56PM +0100, Ivo Van Doorn wrote:
> This is incorrect, all other debugfs files are read/write, so there is
> no point in a extra commit file.

The other eeprom debugfs files only modify the in-memory copy of the=20
eeprom data; they do not actually write it back out to the eeprom.

Furthermore, the rt2800usb driver often "validates" (ie modifies) the=20
in-memory copy of the eeprom data, so I needed to have a way to re-read=20
the raw data so I would only modify what was absolutely necessary.

(IIRC the PCI-based modules expose a standard I2C eeprom which can be=20
 accessed/updated independently)

> rt2800 specific code doesn't belong in the generic code. You should=20
> make your solution completely driver independent.

I see your point.

This should come via bolting on generic eeprom read/write functions to=20
rt2x00lib_ops, and calling those from the debugfs hooks, correct?

Alternatively this could be bolted up to ethtool's eeprom manipulation=20
hooks instead of the debugfs hook I hacked in there.

Let me know what you'd prefer.

> Have you checked if this is specific to rt2800 or would other Ralink=20
> USB devices be able to work with this as well?

I only have access to RT2870 modules at the moment, so I don't have any=20
way of verifying this applies to non-RT2800 modules.  I suppose I could=20
wade through ralink's posted source code, but the comments in=20
rt2x00usb.h seem to indicate eeprom write support is generic.

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org	=20
Melbourne, FL                          ^^ (mail/jabber/gtalk) ^^
Quidquid latine dictum sit, altum viditur.

--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iD8DBQFRHVF+PuLgii2759ARAjeYAJ46lwzIu8R3GbxK/E1nj1uYcyQmHACdGQZl
F4MEB8txtKtCf2uxyHY6k+Y=
=r1LW
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--
