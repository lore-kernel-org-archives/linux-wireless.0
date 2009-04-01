Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48343 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756753AbZDALFS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2009 07:05:18 -0400
Subject: more thoughts on power saving (was: wireless powersaving (in NM?))
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kalle.valo@iki.fi>,
	Matthew Garrett <mjg@redhat.com>,
	Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1237891149.4320.73.camel@johannes.local> (sfid-20090324_133306_274219_3B7517AB)
References: <1237891149.4320.73.camel@johannes.local>
	 (sfid-20090324_133306_274219_3B7517AB)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-H0p0vghamGstR7Y/BBUW"
Date: Wed, 01 Apr 2009 13:04:39 +0200
Message-Id: <1238583879.5970.195.camel@johannes.local> (sfid-20090401_130541_956793_D008053E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-H0p0vghamGstR7Y/BBUW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

So I had a few more thoughts.

Let me start with a story :)

        I use my N810 device for landline calls via SIP these days.
        Every time I'm in a call, audio is very choppy and I can barely
        understand the person I'm talking to -- my fix is to "ping -i
        0.05" the device to disable its powersaving...


Now, why is audio choppy? I was blaming it on the wireless powersaving,
and disabling that clearly fixes it. But is the problem really just
there? I think it might also be the application -- its playback buffer
is smaller than the networking latency I am experiencing due to
wireless. I think I could probably tolerate an additional audio latency
of 150ms (my beacon interval being 102.4ms) or so, if audio wasn't
choppy. That means the application (telepathy sofiasip I guess) would
have to have 150ms or so playback buffer to make the playback smooth
with delay. [1]

Typical voip codecs will use between 8 and 64 Kibps net, adding IP
overhead and whatever you might be somewhere between 10 and 90 Kibps
which means you need to transfer at most 10KB per second -- which even
at a data rate of 1Mbps can be done, again with lots of overhead, in
much less than half the beacon interval (correct me if I'm wrong),
therefore your radio could still be sleeping quite a while!

Therefore, to properly do pm_qos, would the application request a 150ms
network latency in accordance with its playback buffer? Or this broken
application request 20ms and thereby disable PS completely?

johannes

[1] I don't quite see why this doesn't happen automatically, it seems it
must discard packets that don't fit into its idea of the stream timing


--=-H0p0vghamGstR7Y/BBUW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ00pFAAoJEKVg1VMiehFYtzYQALAUNM5s1cVLviXbEyZUHicz
N2bfVvxLJnBDNX4Q18gToIC2bK1w8iuTKPY9j6AHivax8HDaKtqTrGUqLNLjT7pJ
cy9SZlKg7bLxg5Cfi6CzMTcCxTXD6Avl+S9dSL7VPOd1WNTwdvnnuqwMe/vbJ6RO
pb4mw/4OooNKdtyL4Bvp26FLBZ1PRgkt0b7cajn7cHHPpTcu1l2JImCrRq7pwqge
MkatSDJ5UgrT/0w1ypSFWY2mfhtWao5ohAQs/zeOgiPJtqV1JGSAjxVlfyBjP05u
4NaQuL1FZPUlko5wN/eOY+psAfFi+CzyvqWsm8h2+7ZCOCjVk2prwaJqh8PD3gJR
oQXQEbmN8he1wkQD2R+dUCspgemhtUcm8k5muUPdbBMIrhJOcXlH4hGuZt46AhkP
Ff7qHzwP21xsFBR565VWK+RunB3YToCXwk4CAYc9x34LrbNZ5UmWuT9U1cwtIAn3
lacxpNmnkGajh0QE/nSYAxzjKj/U7WaFieDQTPVFJvBGuvEyg4L7AvnONYpLbwzj
RDTpJP+gPetOaCjQs0Mh8M+XvaIRUgYc0N9ywU0J3qPHyxCTcFwSXrZfJpZmhGCE
gNfjRM4uGs9v8zI/01/GVilFsAaB/SMeDCGga1PlgleL/J7y/dL80JE0wuhwjQHt
9kNrnvMfZPeepuLucwwc
=lsa8
-----END PGP SIGNATURE-----

--=-H0p0vghamGstR7Y/BBUW--

