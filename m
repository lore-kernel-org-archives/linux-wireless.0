Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39259 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbZK0Jfz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2009 04:35:55 -0500
Subject: Re: [RFC 1/2] wireless: add ieee80211_asmdu_to_8023s
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1259314407.5428.8.camel@johannes.local>
References: <1259215413-16753-1-git-send-email-yi.zhu@intel.com>
	 <1259229943.32372.50.camel@johannes.local>
	 <1259290376.13126.219.camel@debian>
	 <1259313653.5428.5.camel@johannes.local>  <1259314217.12157.3.camel@debian>
	 <1259314407.5428.8.camel@johannes.local>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-RDUglph1VS1mqO2C2k1/"
Date: Fri, 27 Nov 2009 10:35:58 +0100
Message-ID: <1259314558.5428.10.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RDUglph1VS1mqO2C2k1/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-11-27 at 10:33 +0100, Johannes Berg wrote:

> The thing is that I'm not even sure if we can possibly forward a frame
> after this deaggregation. I'll poke at the code.

Ah, yes, it is possible -- the destination of the A-MSDU subframes might
be associated to mac80211 acting as an AP. I was thinking multicast
frames can't be encapsulated that way so it can't happen. So yes, adding
a headroom parameter would be good I think.

johannes

--=-RDUglph1VS1mqO2C2k1/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLD516AAoJEODzc/N7+Qma4OgQAJeE+jqWrvbtWFwofKH+WDmg
UVUX2oKo3QXFnvTYvqVZ7FEBYc4UeXn+M+RFBG1wAD7n5CaOPq9zFsEvHsmnElnu
X163DTS9cIK9myRichn1bTfm6N93eOQbVNxG6gfD7r+SVx5i58mAgpRTE1Sohxn4
BLNUhalC+hBViX7/oGAfNgG+sFVKTKM8FrY+BYi0gmdJpOkmrTSVrGi1YLNW0ngS
RCJ9Pe4PFQCuveNTxVeHWtiqe5EzY0qE8cNwfhLCr38QofcW5PRMcxm79jNHpVJu
Hrc58e5XmAjwIBWdAGhf1L8BHDEmxJ3nHXg/ZtF4l0Ibfv2RSIsNcPh7pvifw2tm
Suf+Q2iZq3coJnge7WN79T33HlxpFoFQUk/3D4ykZyxcsnFw+40mnZ3mkKh0ZAXC
QlSUnsDg0C5ALOTFrOnP6iwRoiRDmIELwrkREJ//gxDiwU6M1L8RwnGd7SpiRsK7
hp9AZ+eK21fPdjV+3D7kIT1l1yzGBXC6hDmg7/YRGfmdZns9WVuU+NcMqsOamOxg
QR2MHQ9Ci15t45biPMwy8D8UoftwrtrDEl7LSnlc7T+rZr8zTIONmcng6RNTILT9
3NWkz4umvIbUPFYOkD6hyK/LQGPYDsZyEZdidU63rFELUoS0aFYoHwhq20Lt+g9R
hqMa9qEX2QB1aiHyAxwn
=TAsf
-----END PGP SIGNATURE-----

--=-RDUglph1VS1mqO2C2k1/--

