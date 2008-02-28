Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59611 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757833AbYB1QBh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2008 11:01:37 -0500
Subject: RE: Roaming issues: Monitoring of a usable link to the AP.
From: Johannes Berg <johannes@sipsolutions.net>
To: Lars Ericsson <Lars_Ericsson@telia.com>
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <001e01c879fc$46372e00$0b3ca8c0@gotws1589>
References: <001e01c879fc$46372e00$0b3ca8c0@gotws1589>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CUZRIvvWefFhDG6939Sd"
Date: Thu, 28 Feb 2008 17:00:55 +0100
Message-Id: <1204214455.6309.68.camel@johannes.berg> (sfid-20080228_160145_611070_C14ED161)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CUZRIvvWefFhDG6939Sd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> First, I was wrong about receiving frames from other STA using same AP. I=
t
> was my fault.

Ok, no worries, just seemed weird to me :)

> Below (see attachment) is a trace from ieee80211_rx_h_sta_process()=20
> You can see the frames that will update the last_rx field.

So what's the problem with this trace? It means we update the last_rx
field whenever we receive a frame from the AP, no matter whether it's
for us or not. Is that wrong?

> In my code I have added a feature that monitors BEACONS from 'my' AP.
> When number of received beacons drops below 5 / 2 seconds, I assume out o=
f
> range.
> I do not know if this is necessary but it gives faster roaming in the
> out-of-range scenario.

That is indeed a good feature and some hardware even has offload
capabilities for it, would be interested in seeing patches. Of course,
it can't be fixed to 5/2sec, it should be calculated based on the beacon
interval instead.

johannes

--=-CUZRIvvWefFhDG6939Sd
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8bat6Vg1VMiehFYAQKKexAAjtww2+2EwBBBlGh4njcFAStYWQAFEC3/
7WB4MRbc0ECbxSqv0L7qLhrX3ty9iO9zm4pwB6EqDemtB2ga7PuC0qAUGxM79126
Cw0r611ZOcBAnKekA4vPyJ6oiMX8vU+XvK4zSvDBOPA954pZvzps0luLMKRE6cyE
semaEcvLFKfAXS6zXPtHs0qcziRA4tHWOUGuTnFdsSpbatzaga3RrylN62/BCEX2
RdG008VmlnUM5oC8W+vHot0jr6+gdcvkeU1kQPPql2DvS/dQkkthOf9SfY3kyqb5
WzXJVZCdap4M6lUTw42dBYHM66nGHRGdzc+59XyQCYKXjsBQ5Dy5WPxXayHBoOsx
iHEBKdL81Ujd0BRoAHyktrABixQ3IV9OfwXGFgHyi5xNYN8OXS2rM5WCQKrvDopU
M5hGO5ERq2jayBJFjH62mkYRq/XNkcRbS5wAm/ImvbQ9oJAcwlBCMScd6KOO+b2J
SgHnVWn6UpMbUjFHxG0b/hUCvwMTu2gH6JYAs5l2v1nlfKLLZvynHyy3GYkxzD3x
BXnrDoDggvJ16K8Wb2E6i8H/K+vdORIqekThT+mffa0s+X4S/yHvmloVMUX9/L+k
4ZUr4ipQVRzVL/BNVFb2FMdwCuhVQeHx2Z8f6gxquRRjpyycIV+aQg2TWehD2+L6
QHOwSgnqdTo=
=UFDu
-----END PGP SIGNATURE-----

--=-CUZRIvvWefFhDG6939Sd--

