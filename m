Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59350 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbcDULMA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2016 07:12:00 -0400
Date: Thu, 21 Apr 2016 12:11:49 +0100
From: Mark Brown <broonie@kernel.org>
To: "Reizer, Eyal" <eyalr@ti.com>
Cc: "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
	=?utf-8?B?77+977+977+977+9IO+/ve+/ve+/ve+/ve+/vQ==?=
	<eyalreizer@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>
Message-ID: <20160421111149.GO3217@sirena.org.uk> (sfid-20160421_131253_655318_F4CEEAC4)
References: <1463330011.BhWEcYYuGD@wuerfel>
 <8665E2433BC68541A24DFFCA87B70F5B360C0745@DFRE01.ent.ti.com>
 <20160419171239.GC3217@sirena.org.uk>
 <sjdvun1fuj4nyi0bgf268g53.1461086401627@email.android.com>
 <20160419172706.GD3217@sirena.org.uk>
 <oe8hqfknrcljrjawnrxlohvr.1461087275186@email.android.com>
 <20160419175402.GE3217@sirena.org.uk>
 <us0dopt1inbrt0x47njgc2vy.1461089085965@email.android.com>
 <20160419184627.GG3217@sirena.org.uk>
 <8665E2433BC68541A24DFFCA87B70F5B360C2E14@DFRE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="xdTJfaku+U7U7swX"
In-Reply-To: <8665E2433BC68541A24DFFCA87B70F5B360C2E14@DFRE01.ent.ti.com>
Subject: Re: [PATCHv2] wlcore: spi: add wl18xx support
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--xdTJfaku+U7U7swX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 21, 2016 at 11:07:37AM +0000, Reizer, Eyal wrote:

> * (i) If the transfer isn't the last one in the message, this flag is
> * used to make the chipselect briefly go inactive in the middle of the
> * message.  Toggling chipselect in this way may be needed to terminate
> * a chip command, letting a single spi_message perform all of group of
> * chip transactions together.

> Now, in my case I need the CS pin to go inactive and stay inactive during=
 the transfer=20
> of the next byte for completing the SPI init correctly (sending the extra=
 clock cycles while CS is inactive)
> If I read the above correctly, CS will only briefly go inactive but will =
when the next byte=20
> is sent it will be active again.
> What am I missing?

No, it changes the state.  The main use case is a brief bounce but
you can use it for other things.

--xdTJfaku+U7U7swX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJXGLVzAAoJECTWi3JdVIfQkeUH/RBLOC8k+a4OGBOzYmJ7lVvu
7sU/PY/57UsPjArOTRDnm1aGjROe12wGh900nPut6kOx2fa8pH++o1EHQykQa4S2
xGiyz6vnxzDGMmUpep5CVOw/lUxY6vf2/n/RMcrY46zX/Yn4DXBtbIVkiCJ0Y5PB
tJ6SDX/Ot5gGmoKgYV5Uc6rrUEnn7H4TMYOpCg//F78N9cUXupXvcmeoiYVVzEPW
zc/dao8tnVqRFVmM/qoHIXt7EpjHRO2akfx27OXm+QsRZJ1pBlqosqO1BAccMSqN
AbQKlCDbJa+6BviXb6dIiUuavNH8hSXiPpmS0o3YNN55B9mDlIgN3E9wE2oZiMo=
=TiYQ
-----END PGP SIGNATURE-----

--xdTJfaku+U7U7swX--
