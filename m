Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49219 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbZELQpn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 12:45:43 -0400
Subject: Re: [PATCH 6/6] ar9170: stop data queues on channel switch
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200905121715.39702.chunkeey@web.de>
References: <200905120109.09906.chunkeey@web.de>
	 <1242110389.3873.53.camel@johannes.local>
	 <200905121715.39702.chunkeey@web.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-pba6NrYf/t9UkLrnvrmd"
Date: Tue, 12 May 2009 18:45:11 +0200
Message-Id: <1242146711.5797.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-pba6NrYf/t9UkLrnvrmd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-05-12 at 17:15 +0200, Christian Lamparter wrote:
> On Tuesday 12 May 2009 08:39:49 Johannes Berg wrote:
> > On Tue, 2009-05-12 at 01:09 +0200, Christian Lamparter wrote:
> >=20
> > > +		if ((ar->tx_stats[i].len < ar->tx_stats[i].limit) &&
> > > +		    (ieee80211_queue_stopped(ar->hw, i)))
> > > +			ieee80211_wake_queue(ar->hw, i);
> >=20
> > There's no reason to test _stopped first, and doing so is racy.
> uhh, agreed _stopped is not necessary, but where's the race condition?

Well if _stopped returns false but you were just about to stop you're
now racing against whoever is stopping.

johannes

--=-pba6NrYf/t9UkLrnvrmd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKCaeTAAoJEODzc/N7+QmaMoEP/2UcXHvFRcfRUDpQGX9uDHQw
F+HhA08eqJAIziu2U7QOZYfSRnP7S3wFQWuhv+1WQSysGCR/6dJiXEIPakmMM/39
ZQwgQdBGzT0laADJg8UOSn6Y2mFz1lBMuwY1ehO40+RFc05flTHY9SGsvg4jEyqm
KQKWJbhjunfPxUTGN5TkWtX34NGADmDcjkBx/KGdX1LifYYgOtHZdzoJzvUyodhU
CjcC7XqZzfxSawCweOiD8clo9LFJghJeoqpUaR2rJrtZ4pscFhdqc5RLo6JzYXrh
lhiZxgjkvOXf/v76uH9tJcJdnHq21XtYyxy9vbCrnUXebKex8AQDJ1Rm6gBjYXjv
yPbQ5mydvD9++afOPy/OUzJn9dAXPvThrzhtdObewVgbRoNNX89icsBJw4Te8E3E
8153lg2n7U6bts+v8XPUIzJZ9b+YtVAJIwRGaNZDg6wvWya5KijQi+1eNW+MWEWr
GOG8txaMq5XM7h9blwgcARP/4f91kg5RcRkAwgxIY0PTrDNOjR/HyW3qMOd4ELmU
30ODuDDFrfuNecGvDe+nYeAsZfMhS3jjKSQQJhlUqWCudDO3yAIHvyEGBY8v/U7E
HEHGwb+PevtKssNQuReJuEA0Y+SvDe/PQjcaFdT8LAYdUK6BZ/la2I4pTzJXNe1/
4HCKD//v6rZSVmSgs+QR
=yWAj
-----END PGP SIGNATURE-----

--=-pba6NrYf/t9UkLrnvrmd--

