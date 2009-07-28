Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36902 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973AbZG1NTf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2009 09:19:35 -0400
Subject: Re: rt2x00: rt73usb doesn't receive PS Poll frames in the AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Igor Perminov <igor.perminov@inbox.ru>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1248784603.29068.44.camel@sunlight>
References: <1248784603.29068.44.camel@sunlight>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-CxppQ849F/sTgMfVvSUL"
Date: Tue, 28 Jul 2009 15:19:02 +0200
Message-Id: <1248787142.8113.10.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CxppQ849F/sTgMfVvSUL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-07-28 at 16:36 +0400, Igor Perminov wrote:

> And here is my question: what would be the correct behaviour?
> A) The mac80211 stack should pass the FIF_CONTROL flag to the driver
> when the device is configured in the AP mode.
> B) The driver should configure the hardware to receive PS Poll frames by
> itself when the device is configured in the AP mode, even if the
> FIF_CONTROL flag isn't passed by the mac80211 stack.

Hmm. Passing up *all* control frames wouldn't really be good -- think of
all the ACK frames. Do you have filters per frame type?

Maybe we should introduce a FIF_PSPOLL flag?

johannes

--=-CxppQ849F/sTgMfVvSUL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKbvrCAAoJEODzc/N7+QmaGJcQAMU7OmJiWe5l3huAE8+B8bj4
NfmdvZXaPXcl4gVRAU6pTgn5yc4mUaGf1I9tMRvANW4zXUPmpdkmLqcV5XtWfd0J
jM7+QpwbmydQfCrmgbt5QJqgA8TsU4Sn6qoatd/0a351fyx+dq+BdEB80JF4PR+N
VkjDw2215YmwTQ0S3+29gvB4bdrwzPIqmnQXzdtA+W35pbnHRHbGEBBY8yOKX5og
C5rUMs92yp5CUm+UNtyXWsDy3cOILcycmxRPf+SK54LMQ7YWlgC8ofnMdz4Lxdky
JYUSmSxS4mTJEhKrHW4eAnDYDXbklZTzSMoXPJpFbAvIzzaB+k8MgZFX4XTdRZMV
JL5RYf/tZiP48FQkt3q/2Q4yesBUUo0cmAZog5dB32BPz+ibgcrq5moDMKsMW8FM
OFTLNUHkLXFK46BF3uZUYa9R55GNVRJtSUUdGs/bq9k41JYtfhtQK22StSON6DBq
jq9lY0CkrPVSrKiR5Jz83Zu+rc3FqH1JfpTe8nnsSX+i2XMbmtUkbcASny8LaNk5
a54rYtL778VPkqHt0a/vMbPk5fkAVXqtfQja68hRdzhCijudFxWbPOSKLx+IqkBO
5tqM2cfYuHK5K3q/F70Y3SNG4vHGF0o+nJDLkiv+GY7dz9Bvq/DXYs+DPcivrbEY
0gu7DYZmAEofEoLWp4Tx
=t2fk
-----END PGP SIGNATURE-----

--=-CxppQ849F/sTgMfVvSUL--

