Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55026 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbYJXJ43 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2008 05:56:29 -0400
Subject: Re: [PATCH] wireless: add regulatory_struct_hint
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1224816184.2917.162.camel@debian.sh.intel.com>
References: <1224585110.5521.8.camel@johannes.berg>
	 <1224816184.2917.162.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PkQmpGWCqxkkkXkwDDAw"
Date: Fri, 24 Oct 2008 11:39:36 +0200
Message-Id: <1224841176.6002.124.camel@johannes.berg> (sfid-20081024_115632_549814_985DF6B5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PkQmpGWCqxkkkXkwDDAw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-10-24 at 10:43 +0800, Zhu Yi wrote:
>        =20
>         The patch extends the current regulatory framework to support reg=
ulatory
>         enforcement by device hardware (firmware). If the regulatory chec=
k is
>         performed by hardware, the driver uses a special flag to indicate=
 the
>         regulatory framework, so that the regulatory framework will bypas=
s all
>         the regulatory checks for this device and delegate it to the hard=
ware.

The way I'm reading this, it's incorrect because it doesn't allow the
user to override the hardware's idea of the regulatory domain. I think
it's just a wrong description though.

However, there is another major problem with this, if I use a USB device
that has no regulatory information on a laptop that has this virtual
regdomain configured because of a built-in Intel device, my USB device
will wrongly enable all channels.

But inspired by your patch, here's a different idea:

 * remove the struct regdomain hint thing
 * introduce a "hardware has regulatory check" flag, which means that
    - hardware will enforce regulatory compliance to whatever it thinks
      the regulatory domain is
    - the driver will, of course, still also enforce the information in
      wiphy->bands as it does now
 * if a wiphy has the "hw regulatory" flag set and the
   cfg80211_regdomain is the world regdomain (whether hard-coded or
   gotten from CRDA), then (and only then!) don't apply the
   cfg80211_regdomain to it

This would have the following consequences:
 + much less code since all the hint stuff goes away
 + still works for users who move around with a hw-regulatory based
   laptop if they set the regdomain to something other than world
   manually
 - secondary hardware cannot benefit of the, now no longer given, hint
   which regdomain the laptop is in and will be restricted to world
 - some degree of confusion possible when one device can use channel 13
   (say iwl-agn hardware configured for Europe) and another cannot (say
   a USB device without regulatory information, leading to the world
   regdomain being the used one)

johannes

--=-PkQmpGWCqxkkkXkwDDAw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJAZfVAAoJEKVg1VMiehFY9lQP/0ghUfhlMUb+yphPkjDsa+iQ
CIVpQqQ1Afyr/06k/hBdW6i8mPMR344ePpEOIPziCWX8dYBToVgYB+sA5FySlhZ4
Q+BG5G0gwoHMXAjhC1w2nQkcGpj/e53hNO8sgHev3eV9OYPEQBDLqGlYPOXbd+nq
2Z+413r2bRHi/TrXtlcv8bApUVMceya5P9X0bF7awBvKFBXp/7sFAOxypWYcHF6Q
+n53ETFP9oG+uRJeSrSdqlVmpAP4etalOdNK2Jx/9O/lzcSdODGcdNMhojy5db6W
lcGSJf/hAXRf0+DFBOvG7fSrItQURjFHnkjd0fLrpDyfkc5OrfoRPJB/SweOIZDT
SZq8XgTWEPDfDanzLi0P3jSUjNvXjV7WGdqp8TkR9k+PQ+p4NbSEE2NM0K6Fcpym
Too5YCTJH134xE0RnLIQ1roTtg+bS2QI1q0hsbdJLIoX/4OGVDBpQMGa2WKJ6y9L
vgcp/GOIeQ8B2ZJz2Cs4swUkyorzT9Y7cfzudbN52xpLncm0mEDZxoqyK5x29kRQ
2W3iwo+v92ufZHSPrrrG0WTD3IFmdZFrmdiCjya/HOvJTx78JtVhX+HCvgEjNKe7
AEm5uLio7rRC08APnr4G9q1VAa/lBitX9Q+hMKO9M2CUGSncJZBhlFIJBjrRWO30
nXVo5hHqkyE9fzXM/jaE
=oDKa
-----END PGP SIGNATURE-----

--=-PkQmpGWCqxkkkXkwDDAw--

