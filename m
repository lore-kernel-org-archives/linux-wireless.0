Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58318 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756816AbYG2OVh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 10:21:37 -0400
Subject: Re: iwlwifi aggregation info
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240807290706h70f89f68xf8fe7e672c0275ad@mail.gmail.com> (sfid-20080729_160613_116490_52110707)
References: <1217331138.10489.24.camel@johannes.berg>
	 <1217334452.10489.42.camel@johannes.berg>
	 <1ba2fa240807290535h3ebd4121h399b8a8cd1d8b276@mail.gmail.com>
	 <1217336023.10489.51.camel@johannes.berg>
	 <1ba2fa240807290604y47edafe1k7cf93831c31b6112@mail.gmail.com>
	 <1217336870.10489.55.camel@johannes.berg>
	 <1ba2fa240807290618j67db294w524f3885f0e94c7b@mail.gmail.com>
	 <1217337819.10489.57.camel@johannes.berg>
	 <1ba2fa240807290643l4192ca62ia4db9966501caf0b@mail.gmail.com>
	 <1217339170.10489.62.camel@johannes.berg>
	 <1ba2fa240807290706h70f89f68xf8fe7e672c0275ad@mail.gmail.com>
	 (sfid-20080729_160613_116490_52110707)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-aLgcQZVF6OBvvE8e7lbW"
Date: Tue, 29 Jul 2008 16:21:33 +0200
Message-Id: <1217341293.10489.73.camel@johannes.berg> (sfid-20080729_162140_500137_989AE2E0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aLgcQZVF6OBvvE8e7lbW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-29 at 17:06 +0300, Tomas Winkler wrote:

> Please put some reasoning behind this 'wrong'?  Different doesn't mean
> wrong and 'only one' certainly doesn't mean wrong.
> And it also doesn't mean that this hw should not operates correctly
> under Linux. I also cannot publish any performance comparison but it
> doesn't look wrong at all.

Well I read that that you said one needs hardware queues for
correctness, which clearly cannot be the case since neither Atheros nor
Broadcom have hardware queues used for this.

> If Intel is the only vendor implements this that way that we may push
> the extra queuing into driver
> but so far I've seen only athk9 with 11n.

I think we need a terminology update and a bit of a big picture thing
here.

First of all, let me ask a question: Why should stations that enable
aggregation be treated preferentially by giving them an extra qdisc?

As far as I'm concerned, they should _not_ be, and thus their packets
should flow through the qdisc for the same AC that packets from non-agg
stations go through. If this AC queue gets full because it's background
and video is hogging the air, then for fairness reasons we really should
stop the whole AC and not let aggregation frames continue to flow.

I think we're talking about two different queue stopping issues here
maybe?

johannes

--=-aLgcQZVF6OBvvE8e7lbW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIjydpAAoJEKVg1VMiehFYDd4P/1/KA0Uy28YmkZSze1y8yUPZ
Hj7HzgkDHyDhtW0k+BSpO9ORskqlq7rnuF0VnL7w0MGRQS1C3I1lvMscWOOlwObT
pHoh6wkl8B40eSLo1vN+1GvgUEZoJZLZzdsqv/MpJSO4aZJG43ZcYqA8Idb6Esv8
T92nuV8snbdrwK9Rz6JA4SYrgtrrki9qw0WwhNxn/Ui6TGOpWfjCGnSWdR5yCOI/
qM29cfPDyexNF+0ZZGTa646do9WH3lITv3rbPhvykeE5kwyFwl3OlMqgVjOjwUzj
qq2ggJplAfKBJ6IetVCt3QzbrpWPnRglMv5dBoNdR+xuxdQ27ogHGLJpxkTDn4HO
WL7J0yCQdfJbXWD37cLWdbqNKDWelo94YeLwcS+9XK6ZmFFblQwH4eT5dGrIQsC5
1i699SDGh30u3xcA+KuIrgy+UnTrbSzb9gbRK/ScCvBPirRl7tGoTlJIzTFvmFn/
OFc6Ma9PKgDBd2+TqHHl/OnLMoJyr9g2cCMklJbRcaYBvc/a4GxT8pyazlRiqaad
I9lPqs6+pu7ojyH/PjlPgruPxZbccLhVZ0vFn4Ee7s+4xxzHHHlyPzuQXVBaE0g8
1uGvGGq9q7Z433bI8/+STBIRklryOLpWBRZ6EnyYdnLyYR+HbDubqgGPWpKSFteK
6jjwKbMnNGD7VtPZQ5L+
=fHdF
-----END PGP SIGNATURE-----

--=-aLgcQZVF6OBvvE8e7lbW--

