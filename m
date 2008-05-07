Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44646 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851AbYEGWCi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2008 18:02:38 -0400
Subject: iwlwifi and tx info in skb->cb
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YXuaRUzOF8MRBNdcM7xj"
Date: Thu, 08 May 2008 00:01:50 +0200
Message-Id: <1210197711.3547.1.camel@johannes.berg> (sfid-20080508_000144_687548_B3C22466)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YXuaRUzOF8MRBNdcM7xj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

I was just trying to make iwlwifi work again with tx info in skb->cb,
but am running into something I don't understand:

What is a TFD, and why can it have multiple SKBs with a single tx
status? I'm referring to:

/* One for each TFD */
struct iwl3945_tx_info {
	struct ieee80211_tx_status status;
	struct sk_buff *skb[MAX_NUM_OF_TBS];
};

I would have expected something like this with 4965 that has aggregation
support (and aggregation is reported just once) but here? Confused.

johannes

--=-YXuaRUzOF8MRBNdcM7xj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCImzaVg1VMiehFYAQLwchAAk1Ew97TSkuSdgocheKQvUPB62T+MA/Gw
n9Z4xrEM4b7H13FBlgx/4FnOy2Fw1ke9GSmJG3JDdgjw/d4VEOZZ49zzssrHpsZC
BZm23h5F94t+SMVxTXbvb8SgZqCnpGGbp2XWyPKeCTt0vygkDdBIiXI19ghHVPVA
/GgDWKq7J3CvSF/ci+0FOCHZSen+pj/2hLY5gQaoUFoymNH4buswH35UmXFSwi0A
zoeTfPe+paIsDLV7TU/HR67QlZdsVZUzD/7TZIP95vnerWSmydyE3fsMAvP1uqBK
Q4HyOio1y8d9kKxefXdH4s4HxH5Bz3xZwGNDUM8rOT/xtpgTMnMkqgB2Tttvje5k
xBjZL8s1O1mlkBYDAXFmyqroT0PWfDvvxIijPYjoskLaYmOEcGXR8/1r/xzmnHnQ
hnxye2pv7FjBHI/WNovf6guDWBx6O4zs9do7qQHxjhLu+CsjumulmchUz7Vmg4kk
s8+Vm4fA3eUgJ64ydFlMdDIkVyhWQrBCkGfYfdASswXasGnzsa0K/dvHhkl5dlJJ
wTOYSxh+vN+HWqK5XnLmg6rIaIT/6OgfMWVyJ6HJlkYx1qkrJv5fut2VTIThKoiP
Mmuy0JWAgkk7D4bRdr92blPM5dh83K8bbCuZphjsXNZDCewTeSIxYqU97O0HbsV6
qWFnkR9b/1U=
=WQgo
-----END PGP SIGNATURE-----

--=-YXuaRUzOF8MRBNdcM7xj--

