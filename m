Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:51177
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756662Ab3FETMA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 15:12:00 -0400
Date: Wed, 5 Jun 2013 15:11:52 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: Kalle Valo <kvalo@adurom.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	linux-wireless@vger.kernel.org
Subject: Re: cw1200: add driver for the ST-E CW1100 & CW1200 WLAN chipsets
Message-ID: <20130605191151.GA14694@shaftnet.org> (sfid-20130605_211206_142653_444145CE)
References: <20130604130955.GA13788@debian>
 <20130604134340.GA3813@shaftnet.org>
 <87d2s13rsm.fsf@purkki.adurom.net>
 <20130605111258.GA15549@shaftnet.org>
 <87vc5s3i24.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
In-Reply-To: <87vc5s3i24.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 05, 2013 at 02:36:51PM +0300, Kalle Valo wrote:
> What do you mean with bring up netdev? I don't understand.
>=20
> Even now you call ieee80211_register_hw() before cw1200_debug_init(). At
> least from a quick look I don't see any technical reason why you can't
> use testmode (unless I'm missing something).

A dozen-ish lines above the call to ieee80211_register_hw() you'll see:

 #ifdef CONFIG_CW1200_ETF
        if (etf_mode)
                goto done;
 #endif

In other words, when in that debugging-only mode, the device never=20
gets registered.

> We have been working hard to get rid of all sort ugly driver specific
> interfaces. If you don't want to use the proper interface then I guess
> it's better to remove the custom debugfs interface from cw1200.

It's not a matter of not wanting to use the proper interface so much as=20
having to pick my battles.  (I no longer have access to the vendor=20
tools, nor am I inclined to spend my free time hacking on something=20
end-users aren't going to need)

I'm fine with the ETF support getting stripped out of the mainline.  In=20
the shorter term it can live as an out-of-tree patch; in the longer term=20
it can be implemented properly using the nl80211_testmode hooks.

Meanwhile, there's a second debugfs interface ("itp") in the cw1200=20
driver that basically implements a continuous tx/rx function on top of=20
regular production firmware.  This should probably just go as well.

I'll prepare a couple of patches to do this.

 - Solommon
--=20
Solomon Peachy        		       pizza at shaftnet dot org	=20
Delray Beach, FL                          ^^ (email/xmpp) ^^
Quidquid latine dictum sit, altum viditur.

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iD8DBQFRr413PuLgii2759ARAkn9AKCMQsx+X7yoa3kXBs5WJMJP3PjtdwCfWL8X
fbJ8OAaLTtNI56fLKiX3fRA=
=GbLO
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
