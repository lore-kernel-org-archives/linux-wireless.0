Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56091 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772AbYJKPW2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Oct 2008 11:22:28 -0400
Subject: Re: [PATCH] mac80211: provide sequence numbers
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200810111649.51946.IvDoorn@gmail.com> (sfid-20081011_164956_649332_7640E1CF)
References: <1223637719.17594.6.camel@johannes.berg>
	 <200810111649.51946.IvDoorn@gmail.com>
	 (sfid-20081011_164956_649332_7640E1CF)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jzvxhYDvmkev5x1b9m7y"
Date: Sat, 11 Oct 2008 17:22:20 +0200
Message-Id: <1223738540.29811.46.camel@johannes.berg> (sfid-20081011_172232_315021_95BE3C49)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jzvxhYDvmkev5x1b9m7y
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-10-11 at 16:49 +0200, Ivo van Doorn wrote:

> >  	if (!ieee80211_is_data_qos(hdr->frame_control)) {
> > +		/* driver should assign sequence number */
> >  		info->flags |=3D IEEE80211_TX_CTL_ASSIGN_SEQ;
> > +		/* for pure STA mode without beacons, we can do it */
> > +		hdr->seq_ctrl =3D cpu_to_le16(tx->sdata->sequence_number);
> > +		tx->sdata->sequence_number +=3D 0x10;
> > +		tx->sdata->sequence_number &=3D IEEE80211_SCTL_SEQ;
> >  		return TX_CONTINUE;
> >  	}
>=20
> Shouldn't this be changed to only setting the IEEE80211_TX_CTL_ASSIGN_SEQ
> flag when the sequence counter was _not_ set (with beacons)?

No, if you implement interface modes that beacon then you need to assign
the sequence number for beacons and these frames from a _single_
counter, which then has to be in the hw/firmware/driver. IOW, you have
to override these numbers.

johannes

--=-jzvxhYDvmkev5x1b9m7y
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI8MSoAAoJEKVg1VMiehFYdigQAL86TDUKikpG4X+kRjJD4r15
A3xBjvTW+bK2P16frk18zbGiK1pAL2pEx6bIrl0WELpZeJg4F9Rz7NPuDcw/UGw0
1BbbGGxNIv7i2LOiu/zZcz64FBGatRQZXFnxY9mnAkN+8IXVasUJd20JmOlY9ZlQ
QurT0+1gPrIouQRDvcFkmY94WtPY0QRhxkls1l1mO/l+Au+9anuqz3/saDNqfRyF
+qzkHi71d3LGdC9hVRJXvng+wZ2e7+UOB04nTL1l5XbdrCPnefNd7ueA8i2Y2T5X
PQx77m6NtWeSs5q+krXA/+UE0HzGc3oNvEISw39yB4KvNP3gLjiUTGiFclVmGx7E
Vvp2cy/djJu6SkKvbWpaeHoEr35MJbqu9V5ZhYsjV3XPqPilYWNJgiLQWeZ0cYSA
Tah69un/qUJeqcDboNFrVo3otkXEQESP3IwAlk8gEPn1ihSp8SsGqEVI8oZsKI1m
s2Cb9hhTgSQguGsBZk5LcLLZE3FfTQaIpURbjlO8wTEagFFuzWH8pRBB5lTgS1UW
h1DGYS0lAv8pYn04+BkqBqEMHJ/SnKExB7aWcIqZ2+9Jy/lfwfFC1I8wrNpTLcGG
EEbnBbagPiSmT0SJ5rWFk8XQ85j0pcVdkVpsYRccXQ8otPrjG7I2Lm5jwU/Lc332
bdIU3c9DIkfrZq7d1V+F
=iMCJ
-----END PGP SIGNATURE-----

--=-jzvxhYDvmkev5x1b9m7y--

