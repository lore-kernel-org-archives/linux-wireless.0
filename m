Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54994 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbYHDKXH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 06:23:07 -0400
Subject: Re: [PATCH 4/4] ath9k: Add new Atheros IEEE 802.11n driver
	[reference to URL]
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Felix Fietkau <nbd@openwrt.org>,
	Christoph Hellwig <hch@lst.de>,
	Jack Howarth <howarth@bromo.msbb.uc.edu>,
	Jouni Malinen <jouni.malinen@atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Pavel Roskin <proski@gnu.org>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
In-Reply-To: <1217835007-15173-1-git-send-email-lrodriguez@atheros.com> (sfid-20080804_093022_372695_B212066D)
References: <1217835007-15173-1-git-send-email-lrodriguez@atheros.com>
	 (sfid-20080804_093022_372695_B212066D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2WuVo6y9DLJRBog0qYnw"
Date: Mon, 04 Aug 2008 11:34:23 +0200
Message-Id: <1217842463.4721.28.camel@johannes.berg> (sfid-20080804_122311_398479_4E5A86D2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2WuVo6y9DLJRBog0qYnw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-08-04 at 00:30 -0700, Luis R. Rodriguez wrote:
> This adds the new mac80211 11n ath9k Atheros driver. Only STA support
> is currently enabled and tested.

Couple of comments:

ath_softc is _huge_, and the spinlocks in it are at the worst possible
place. Placing them together with the data they protect should be
better.


There's talk about sysctls that do not exist.


+/* Until mac80211 includes these fields */

please just post a patch doing so.


You haven't explained ath_scan_end et al. yet.


+               /* For HT capable stations, we save tidno for later use.
+                * We also override seqno set by upper layer with the
one
+                * in tx aggregation state.
+                *
+                * First, the fragmentation stat is determined.
+                * If fragmentation is on, the sequence number is
+                * not overridden, since it has been
+                * incremented by the fragmentation routine.

do you really still need to override the seqno? Did I make a mistake? Or
is this just older code? Or is it necessary because the aggregation
callback wants the seqno? In that case I can preassign it there to the
right thing...


+        * Calculate duration.  This logically belongs in the 802.11
+        * layer but it lacks sufficient information to calculate it.

what information does it lack? It _does_ in fact calculate the duration.
Something wrong there with aggregation? Please realise that you can, in
fact, change the upper layer.


+#ifdef USE_LEGACY_HAL

eh?


I'd appreciate somebody else reviewing the driver from a stack
perspective too, I don't have all that much time right now.

johannes

--=-2WuVo6y9DLJRBog0qYnw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIls0bAAoJEKVg1VMiehFYP50P/1A3P/y8CQ1ocDDWKhIy6pPl
NEhvQiDVIkuBMSU8fREPwnJi8YdIdmGtN4olcqLZgdDxWrG3nf7JbffoSlbE9sUM
007utCoizHEZczw9J9IYD5VG8uzV8OCW5eUhiWV4/XngwxNnnChI00KlUSDt++Uw
voAFbFtjqXPi/HV/CDi4rwruUfgIIYBt/T5jbdY3JtQPwdz+SlCOtmCDl8FxWiqO
yeqDu3Ti2dmCMEwghC8gcHRl6cmUU15/5XU/EGCuHVBFhcscJOXUyMV6z8d4JAl7
VEZTawJZ8fFkx6epsRfP08DgGREjl282DPGstjhKWN+mdbeeXFk883xzR6Q3/gor
jL2Djauo1QtJ1PHH3pfpMMSRFx1Qx6KzkhGmwOQZWjYnEETskaNb8gBkYRJkUJ8G
btAIxOPMimCFXbS/mth9ZvSZIn64wE9l/ByVcCidRVQ/2GjuMe+52tkp+MMExzdB
u0Q7LBIxpzlftA0R/zcNnWN/majz8Yu8qGOyVfeAAIblJJokQhlGf2b7Dqa6iKNw
d+ndsT1E8uuIwdXYVdzuItsR7MPeNAT1DvRX3Rr2+4Apzx9vMSpwKGMrAwA0yN8N
S7dvyBLyyMlpDhLIDNRux5Nrxbe+xMTM0ZxsqjPK3qaKyFNErpqFcHJk/Wk0Qrw8
C7TuXOTgCCpJmMMGpEB2
=+ScM
-----END PGP SIGNATURE-----

--=-2WuVo6y9DLJRBog0qYnw--

