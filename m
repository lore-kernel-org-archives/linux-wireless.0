Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36651 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965544AbXCGQl5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2007 11:41:57 -0500
Subject: cfg/nl80211 primitives
From: Johannes Berg <johannes@sipsolutions.net>
To: wireless <linux-wireless@vger.kernel.org>
Cc: Jouni Malinen <jkm@devicescape.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UjYXY+oeKeT/Ago+MESD"
Date: Tue, 06 Mar 2007 23:20:49 +0100
Message-Id: <1173219649.3503.50.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UjYXY+oeKeT/Ago+MESD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

I know this has been discussed a bunch of times and also at the London
summit but I'm still not convinced.

In London, we've talked a lot about separating actions from settings.
I've thought about this again and again but haven't really made sense of
it yet.

To me, separating actions from settings is basically this procedure:
 (1) give the kernel a bunch of parameters
 (2) give it some other parameter
 (3) change some parameters again
 (4) tell it to use the "current parameters" to do X
(where X may be "associate", "authenticate", ...)

[with possibly added "(3') wtf did I set there? let me query the kernel
for it"]

That's also how the current wext interface works as well as how the
currently unimplemented nl80211 interface is defined.

However, I don't see why we shouldn't go to a model where we give the
kernel all information it needs to do an operation when we want it to do
it, like the procedure
 (1) tell the kernel to do X
   - using parameter A=3DB
   - using parameter C=3DD
   - ...
 (2) tell the kernel to do Y

The parameters here would be an SSID, BSSID, channel, key, ... We'd
completely get rid of the ->configure call in cfg80211 if we did this.

This would also be a lot more in line with primitives outlined in the
IEEE 802.11 specification, like MLME-ASSOCIATE.request et al. In fact,
it seems that the interface could be modelled pretty much after the MLME
SAP interface outlined in clause 10.3.

Obviously, we wouldn't need to actually have all of them. For example,
MLME-START.request for BSSes wouldn't be implemented within mac80211 but
rather in hostapd. I don't know how ipw2200 master mode works though,
maybe we would in fact need to have the MLME-START.request in nl80211
for some devices. For a whole range of hardware MLME-JOIN also makes no
sense, but for bcm43xx for example it almost would [1].

To fully do this we'd have to get rid of the intrinsic "mode" of a
device, the mode would be decided based on what you want to do with the
device: start an IBSS or a BSS, join an existing (I)BSS etc. I actually
like that.

Of course this is not sufficient; since we still want to move to a
userspace MLME a lot of lower level primitives need to be added since we
then need to have a MAC/MLME communication interface as well, similar
for hostapd.

It still seems to me that this would make a lot of sense and get us some
more implicit documentation by referring to the 802.11 spec. Where's the
problem with this?

johannes

[1] The action taken on MLME-JOIN.request would be to set the BSSID for
the firmware. However, the firmware doesn't generate MLME-JOIN.confirm
so you'd have to set the TSF to 0 and then check if the firmware changed
it to be able to generate MLME-JOIN.confirm. It's entirely possible :)

--=-UjYXY+oeKeT/Ago+MESD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF7elB/ETPhpq3jKURAiLHAJ0TYkYE9IoboAHYF+e4kBLzG4QpcwCbBfVt
riSWbkIaNkhrh/ATz29FM7w=
=52kH
-----END PGP SIGNATURE-----

--=-UjYXY+oeKeT/Ago+MESD--

