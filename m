Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39898 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756419AbYBAXaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 18:30:12 -0500
Subject: Re: mac80211 QoS/aggregation questions, thoughts
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>, Ivo van Doorn <ivdoorn@gmail.com>,
	Patrick McHardy <kaber@trash.net>
In-Reply-To: <1ba2fa240802011524g38a9583fs7c4b792bda844327@mail.gmail.com> (sfid-20080201_232419_709731_495E9739)
References: <1201882512.4188.66.camel@johannes.berg>
	 <1201902217.4188.82.camel@johannes.berg>
	 <1ba2fa240802011524g38a9583fs7c4b792bda844327@mail.gmail.com>
	 (sfid-20080201_232419_709731_495E9739)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Uxi+pqI7sb4Nv3FxpLpm"
Date: Sat, 02 Feb 2008 00:30:03 +0100
Message-Id: <1201908603.4188.97.camel@johannes.berg> (sfid-20080201_233017_535795_91C74BED)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Uxi+pqI7sb4Nv3FxpLpm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> 4965 has 4 queues which are used for regular WMM.  Only 11 queues
> might be used for aggregation, but in AP mode we might map one of the
> queues to after beacon multicast traffic.
> One queue is reserved for communicating with FW.  The number my differ
> on further NICs.

Ok, makes sense.

> All the traffic queues 4 WMM + 11 AGG are served according regular WMM
> policy, 4 AC - these are configured by conf_tx.  The aggregation
> queues are needed for handling ordering of frames correctly and not
> for on media prioritizing

Yeah I realise those are just for the right ordering (which is
interesting btw, Broadcom gets away without extra queues, not sure yet
how), but I those have to have media access too and I wonder how that is
configured. But it's not too important right now.

I'm trying to grasp the qdisc/multiqueue netdev stuff right now, it's
proving harder than I expected :)

> Sorry but I have to review your patch later

No worries, I just whipped that up as proof-of-concept.

johannes

--=-Uxi+pqI7sb4Nv3FxpLpm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6OreqVg1VMiehFYAQJOdg//UQ5NK5DRfEl23nDw/ZkMbBl/3sFRGHbH
5p21+w2XIeK4FZGGx8KSLafTpDryWcnGUzT8U4bgNqBX+jS5KgBeneDUS4ye8/jz
nRrMoxj04hhUz3XV8LaYrf1nseulhXu6L/r9Xp5dtzSb533vZ4mKyG4R86yjFw34
qlbe1Vl8tnwOcTrOQlSwTysus+k+SfCsE4iXKEa9Apemb0nJtonMW1QDWiV8YxZP
lnx/ZJbGkowNlKS6hh0jpfyza7qG2Glj7uvleCT50d0KgH8sM4Cl3ZKZe/Z1Q+TX
7/NRDj5pJ9zJ4ZsPcdI4oFPDSaWfpW8UnSuXaIKpcJdZ9PQUVXr5IqHP1A1Yix9T
CIy9jo9/3EBbIiVAFawtnDILYpdXphi2whzqrzgRQk+iPlpASA4bzbhr67QJT0Ro
8t+XJSiO2oVupeNPXHTSgjc1feSse5kgTQk9eIFsofMUqchL7TeDCRuCwMS82Hq/
NcirzaGvu4t7xCMUYPWQDf4e5vBtHjDDu/ru7x50EF05iD3t9YvI5jwBAJGXJ2MX
DJg2yc2ZZ41Iq6iowq+GNviqltcGcvN9VX/LIsjFIQAQMkw2s4CaV6QJ8heJMly/
SZTgAyr0qNkUHj3fV4tw0s3yuFuq+Kktqxsx/Filo4NVxVATD97aTUzzr7mPkhO6
G8SboKtBwYw=
=Nwel
-----END PGP SIGNATURE-----

--=-Uxi+pqI7sb4Nv3FxpLpm--

