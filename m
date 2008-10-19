Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57568 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbYJSKTq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Oct 2008 06:19:46 -0400
Subject: Re: Warning from mac80211 with p54usb
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Christian Lamparter <chunkeey@web.de>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <48FA6E1E.5070303@lwfinger.net>
References: <48F7D0D2.6090604@lwfinger.net>
	 <200810170226.28774.chunkeey@web.de>  <48FA6E1E.5070303@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2wFbnWUVBgXOEXir1UOG"
Date: Sun, 19 Oct 2008 12:19:41 +0200
Message-Id: <1224411581.6324.38.camel@johannes.berg> (sfid-20081019_121948_924496_A0CD606B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2wFbnWUVBgXOEXir1UOG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-10-18 at 16:15 -0700, Larry Finger wrote:

> Note that none of the p54u callback routines are entered. From here, each
> successive call to p54_config() adds 3 new queue entries, non of which ar=
e ever
> removed. Eventually, the number of entries gets to 59 and the free space =
is less
> that the requested length causing the failure.
>=20
> I'm still trying to analyze the output from usbmon and to correlate it wi=
th the
> data in /var/log/messages, but callbacks stop occurring at a certain poin=
t,
> which is consistent with what is seen above. Unless you have other ideas,=
 I'm
> content to attribute this problem to the old firmware. If I see similar t=
roubles
> with newer firmware, I'll be back.

Looks to me like that for some reason the firmware doesn't tell the
driver when the config callback was completed, which will lead to the
space invariably filling up over time. It probably should be possible to
work around it (say by recycling the config once the firmware has
transmitted the next frame, since by then it should be reconfigured) but
I'm not sure it's worth it.

Btw, I tried getting my hands on a p54 device but it ended up being
acx111... I'll try again.

johannes

--=-2wFbnWUVBgXOEXir1UOG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI+wm5AAoJEKVg1VMiehFYpM0QAKA9nC2u7XfVYuiabi5lsKnO
10KzXuwiTIcBZN9rJppAmzea71PxZV1rJthoXNkqV58NrhefG5X2cv3x995HbH/v
GKg+KZ1JOWLYBgU9wDRtpxUn4k5Z5M+StJlByLc65kuDEkoE+3Dq5wir1+JeMloZ
8HMVrGI53cgSHXxy7d3tPen2XOyuxwaJGbNEjV12I7BzRMOjVlIkRkAipR5wRXKb
s13ycKV9KG/C40LLtKlq+YsTZfd2zQNirQw7NDb+5JaBATIOXrkZiRaScOkTo384
4O+W6Dby1oUGfnfYocAEnY7TGGaZ9jocvZ8BzziykSdwhDFz3MTwFH5syAqbTd+7
mE9Imv4DJsPIfYAbpDfG2HFyNzu2+RBb3jHVTNGieeXggjA2XZpkPSbFkPTT4rh2
i7LiQrEusl58RPkLK8CGvZtJ920cqNNQPt6gXsCj27GRG0kNbWtjOBSPrWc3tbrX
ZmnY/x8O4NNLnM6vjd2hvhrybthqsUkLOgd08TU3LPDx4LYpmgWFnXBM0D0jC9l2
86An+GKYlLU0JkGpZmo7VMzjXU3TzhEBtX4AEGTu1kj0Wwu1pR/Urn3KCSG1I/sm
ewfv2gOpIv2mC6vMvq1ULShFZ05yLyCJmX+q08PaLZcmUwdi3NaHE7Uh/Jj9PPlx
bXqRNCQpFf/TsbKT8O20
=F1+i
-----END PGP SIGNATURE-----

--=-2wFbnWUVBgXOEXir1UOG--

