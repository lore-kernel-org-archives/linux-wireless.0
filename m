Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58188 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbXLCKga (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2007 05:36:30 -0500
Subject: Re: mac80211 / iwl3945 + dynamic wep (again)
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: dragoran <drago01@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <20071127033408.GB5698@jm.kir.nu>
References: <47494851.4070504@gmail.com>
	 <1195987773.4149.214.camel@johannes.berg> <474955E1.30603@gmail.com>
	 <f6ca9fed0711260650j749de7a3x3edc084ae820d2eb@mail.gmail.com>
	 <20071127033408.GB5698@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZPpS08UMMcGN631IVnUC"
Date: Mon, 03 Dec 2007 11:14:54 +0100
Message-Id: <1196676895.6060.19.camel@johannes.berg> (sfid-20071203_103645_940885_317BA775)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZPpS08UMMcGN631IVnUC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

> While I fully agree that these messages should be rate limited, it is
> somewhat surprising to see this large a number of reported ICV failures.
> Does the ipw3945 not filter out FCS errors before passing the frame for
> WEP decryption? Or is there something odd about this network/client
> configuration that makes the client try to decrypt frames that are not
> really for it?

I agree. We have the following chunk of code in the decrypt handler:

        /*
         * No point in finding a key and decrypting if the frame is neither
         * addressed to us nor a multicast frame.
         */
        if (!(rx->flags & IEEE80211_TXRXD_RXRA_MATCH))
                return TXRX_CONTINUE;

the RA_MATCH flag is cleared when the frame is neither multicast nor
addressed to us so I don't see how we can get into WEP decryption. A
concurrently running tcpdump might help though without the keys it'd be
hard to verify everything.

The fact that ipw3945 doesn't print out any such messages is hardly
indicative of a mac80211 problem btw, maybe it simply doesn't contain
such debug messages.

johannes

--=-ZPpS08UMMcGN631IVnUC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR1PXHaVg1VMiehFYAQLu+A/+IX1+YJBwrK0iQx0vGg9s83ldMzJdviWo
xLlVkctrELHz8l+PO1df3esHPgtTkwzS4of2t92/W+EFJmwtsF3QG5ZmUtPsF2i6
JU76tWrHrXXI3uT8THtggqE5RUONRb3CREG7bjb801bB9ihZHmMQzgSeC1PhwsmV
uojjSYduBLJ8TUOc9Wd3+ANPRZ2ghisQQ1WnvG+ueCv4Ba0Bsp5nULdaWyRG82pa
5nIrOaWfbOOH3oM9ehWnQa5dTgR48RgZSThM+k0NL9rUmJlxX0gbHAmmKvh4Vi91
LpDrvgOKAvC8ks5u3wTTn3L1qVOp5Lim/Y/6V/dpwMMAnLvsMk1RDg/bu3x48QYs
ZFAgPA2TZ1WNpYx649NudvxzPgZc+ucM2Crf+wYrJW5BZku633nKD2eR1qeXD/L3
jwV8WTUo04vNdNCm2iTc0e9+lQqUzFrxNDNOEmg3lv1jVgflTdH+uqTwGgQWTMpd
wNKJqMOpYig+o7MXh01g4W7NHabFbfpLE0JIm03IAxf+I86GV+H1HB2TuhCotZHQ
aio1Kf7GviCLrk4aRal6Lv17s42Z8wdwRWxGd6Oer/Q3LgbJH+YwrKAe9JuERQNf
7KvCmilN32iXuuoaixA816IqTpkJmS/rbzBAjBvzDXb5oijatezcNsrmD2wv/1Kl
TXXde9hAzh8=
=kqAz
-----END PGP SIGNATURE-----

--=-ZPpS08UMMcGN631IVnUC--

