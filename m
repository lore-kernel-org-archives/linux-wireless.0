Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60545 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbZASI3m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 03:29:42 -0500
Subject: Re: [PATCH] mac80211: Reconfigure beacons after a merge run in
	IBSS mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni.Malinen@Atheros.com
In-Reply-To: <18804.11602.400684.88722@gargle.gargle.HOWL>
References: <18804.11602.400684.88722@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jGLoXkfiBbgAX0ySDqmq"
Date: Mon, 19 Jan 2009 09:29:32 +0100
Message-Id: <1232353772.3799.1.camel@johannes> (sfid-20090119_092951_315021_CCA99CD1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jGLoXkfiBbgAX0ySDqmq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-01-19 at 13:05 +0530, Sujith wrote:
> On completion of a merge scan run in IBSS mode, beacons have
> to be reconfigured in the driver, so that the HW timers are updated
> properly when coming back to the home channel. This patch fixes this issu=
e.

I think instead we should have an enable-beacon flag that we disable
before scanning, and then re-enable after scanning like here. That way,
we also don't need any extra code in the driver to stop beaconing before
scanning, and it generally helps too when userspace deletes the beacon
we stop beaconing in a controlled fashion.

The best way is probably to add a conf flag like CONF_PS and a change
flag for this, what do you think?

johannes

--=-jGLoXkfiBbgAX0ySDqmq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJdDnqAAoJEKVg1VMiehFYMakP/jgVLBTRsgLxSJj9cTs7TGdn
jIO2rwmL6O760DCvVdx8bDSSom/IB7ZI31J/E6kZLiGkSe+OkRNLfUrP8sxHYlq4
KfuCPBVHrGPlLafchMzx5JMn8PCh7pDG0IbhxX+Ku8HMPkfHLxw526pWeSvZYNQ5
TfwY2/SEp2eG2eYBgxCpQRpecGkCASauXjIutG3dIXIyy1J5X1Fcz+syNaj3UXZt
15ItJNe2fau9xtP42Gv2hEMzkRSpMUWLfHG7iidw0joEcdWa0HXK+OP1FGjGPRCR
mr0PBh1G2JCF4wJy3VDYTCeo9qljVpeB4ZNybuTs4huj5lLfAY5Rw0fW2JPpMPtc
lfxEz1KQtDWIsgMIYa1oeF0QZtg1IrMLcNY/pOVmDYLvkcFZgZz+Rfq07QxUu713
pk66onvGbwgrLZNVxPkGX5XgxYzwB7zUgeBbj6bcvk6p/l3R9w/ugIMR6iqWH9vg
1wH0D1t0FjIR8QHOToyq07cAif9D6/eTeDgmyzSVJ1xvXWNHAGQSVV2FkKanpUgs
UgGoFqloo2gMsNPLFIgbldqkoJPp/yfJYFToZ0GCMedRzQY3mMftZG+SZ6HADe1y
Q1mJ2TkBNIlvl05A6NWw+nZ8FV+vSsocMseCGgkKd/eVSf0ahdtE5C0R0HIspby/
Wl90Ai+JRUpiSnkq//6E
=IdKh
-----END PGP SIGNATURE-----

--=-jGLoXkfiBbgAX0ySDqmq--

