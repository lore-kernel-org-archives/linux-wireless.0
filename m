Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50592 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378AbXJLUsT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2007 16:48:19 -0400
Subject: Mode/Channel/Bitrate API
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Michael Wu <flamingice@sourmilk.net>, Jouni Malinen <j@w1.fi>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ukypSlx8S6+wUM/nDaDf"
Date: Fri, 12 Oct 2007 22:48:30 +0200
Message-Id: <1192222110.4770.81.camel@johannes.berg> (sfid-20071012_214822_655609_9AA1C92C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ukypSlx8S6+wUM/nDaDf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hey,

So many people seem to agree that the capability registering in mac80211
is somewhat awkward to use. Also, it doesn't really match how hardware
works with the separation of B and G mode.

I've been thinking about this for a while and would like to get your
input on the following replacement API.

First, I think we should completely get rid of the mode stuff. This is
an artificial distinction between hardware supports operating in
frequency bands, not in modes, and the actual mode differences are
controlled differently.

Hence, what I'm thinking is that

 (a) the driver registers which channel center frequencies it can
     operate with, it could in theory just be a range (e.g. 2400-2500
     MHz) or more practically be list of center frequencies. Just
     contains frequencies and possibly hardware dependent values for the
     frequency. This is done in "bands", something like
     FREQUENCY_BAND_2_4GHZ and FREQUENCY_BAND_5GHZ, "bands" replace the
     current "modes".
 (b) additionally, the driver registers as flags
     - whether it can support G mode short slot operation
     - whether it can receive B mode short barker preambles
     (both of which are only relevant if it supports 2.4 GHz operation)
 (c) for each registered band, the driver registers which bitrates the
     hw supports. this implicitly defines the modulation too.
 (d) now, selecting a channel by frequency is unique, but we need to
     give new options to select short slot, short preamble and allowed
     bitrates. For client mode, these are initialised to what the AP
     supports and you can't for example turn off short slot when the AP
     requires it; for AP mode it's initialised to what the HW supports
     but if you want less you can select that. Rate control algorithms
     need to take into account this as well similar to what they already
     do.

Does anyone see problems with this? I think it matches hardware much
better than the current scheme where B and G mode almost totally
overlap. Also, right now we only advertise short preamble for when we
have G mode support which is wrong since short preamble was an optional
feature of 11B, currently 11B hardware that supports short preambles
will never be able to associate to an AP that requires it with mac80211.

johannes

--=-ukypSlx8S6+wUM/nDaDf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARw/dnaVg1VMiehFYAQJkdhAArQYkT59BDtttlyJgwyyyPkaBsmmUo/yl
yNlJBD6QehVrb0ZfNtWhEt4+YCgOgcjjLeOijCGFG7KPHI+CyGnvnzkCQJxx0Q8I
xY3N2pRZwb9zXAXqAhqnZDYg0b1v0JrRNlUfbxuLpcjIIY/CZ97/L57CtucFMMqN
ZlwfZKsFdCKlD77H5K9imTcQmMuDRWbuXNFPZqMfV2mWGk7Pu27fj3CRS/6KFAes
stSZUoPa48lTksvYtSqyxtRtvMsZw0BUnkg5Mze1igWDRgE5YA9m0zTusmKOZe8H
T57/NLBCeiiXN3rsqRBq2Btc1Q5e1NProxF2Ka4hHzLOKIoPhFZ1KXm24AJAeZGP
3dfdM2c2CmLcKDjcH7bjdLroOP2/BhDBT/ftVFbRgnk9gMNtNRF20mboNdT23F7T
50NaCah+Tk+VCx7HXAknIoN0hIJkPdpZTc8MJHk+F5MsQN6eChWsWvfkaJUwkwb5
uA1YrpFE2/GCJLYmApa/aLPLcDWHPdR0TzZbAxzPycbuUFCNuyMsvOpEn7UhRjUg
SZ1IJQ55L8DLmjwJU6Z3o3+gmCuCAJ88zdfeSG47cAlUXqrt449NaY6BXEzoI58y
HzZo3fRS2Px3TK+6e94NfN/KUNQixdo1DUB2XxIxBchkEV0TtzeMnNGgMcjosRea
FoamVgovF2I=
=OyNi
-----END PGP SIGNATURE-----

--=-ukypSlx8S6+wUM/nDaDf--

