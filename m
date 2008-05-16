Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53692 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbYEPUb0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 16:31:26 -0400
Subject: Re: [RFC-PATCH] mac80211: add helpers for frame control tests
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1210966704.5915.51.camel@brick> (sfid-20080516_213833_934385_1E372539)
References: <1210966154.5915.50.camel@brick>
	 <1210966704.5915.51.camel@brick> (sfid-20080516_213833_934385_1E372539)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-INUYnybLZLnAqY7Yl41v"
Date: Fri, 16 May 2008 22:31:06 +0200
Message-Id: <1210969866.6381.46.camel@johannes.berg> (sfid-20080516_223131_709907_6A706BD2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-INUYnybLZLnAqY7Yl41v
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +static inline int ieee80211_fctl_tods(struct ieee80211_hdr *hdr)

> +static inline int ieee80211_fctl_fromds(struct ieee80211_hdr *hdr)

These seem fine though I don't see why you implement them with a > 0
rather than !=3D 0 comparison?

> +static inline int ieee80211_fctl_has_a4(struct ieee80211_hdr *hdr)

That seems fine too.

> +static inline int ieee80211_ftype(struct ieee80211_hdr *hdr, u16 ftype)

That, I think, is misnamed, it should be ieee80211_is_ftype()

> +static inline int ieee80211_stype(struct ieee80211_hdr *hdr, u16 stype)
> +{
> +	return (hdr->frame_control & cpu_to_le16(stype)) !=3D 0;
> +}

And that even seems implemented wrongly? stype is a 4-bit field, this
doesn't make much sense to me.

> +static inline int ieee80211_ftype_mgmt(struct ieee80211_hdr *hdr)

> +static inline int ieee80211_ftype_ctl(struct ieee80211_hdr *hdr)

> +static inline int ieee80211_ftype_data(struct ieee80211_hdr *hdr)

similarly, ieee80211_is_data() (remove the ftype, everybody hacking
wireless should know that data/mgmt/ctl are frame types)

johannes

--=-INUYnybLZLnAqY7Yl41v
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASC3vCaVg1VMiehFYAQLbAg/+KOEvVyBg5Odm3+6r7/cEcU+kpmB1Jp8N
8JjEYf30l0qY6jeOw1ggEyR8jvblrk5J/vIAnS+BWQaFtjvooiIYFHivEnSACyT7
19pRlhN79JS7XcE9SpCPVXfzhRKLRnCsMhaswo4a6OeejjNmeuhxI7G/tN62OYnM
vkSGwtXNWPTqctFaCrfhV1tallXHIF4aj9RgXajueHX99sPQ2KUlBc6Cuumt3GoN
LOv62qdiF7IBFei/y4eOmtK2uxfLIboNt06RZXGoYx+fVeVTtYdjiI+uBPPJnKyI
JkP98kDiwto1P0iGr77AmQUy+qJOvW9Pjgp3qu/zlc6UAVaCpdYzDa/W7mEk/ql4
jQAythEmyuxYUkcUbQLXhsmTSf0DBEuo/1ga6PA9CnXYtyADz5i8YXSzXBgP8Krr
689XkpJDHLZv8FkSo2Hne//noNKdEczGxi6jwW5jGGRuTfRT0kxzP90asmDViJ8Y
EbKLB9Gga8hxbXPveqGe1YEKjDeR/PTUGZASVUWfdaydxzIVvYWPmqiZ7f57unPe
Tt5mFri97aoCLpuUhcDacOZpHYjClstFAYXktUoIjnx3dxQbMAaY4U0FtSbutyZ+
v95whdryCKPXZHTpli1pMy8EqPvUfb71r19z9SSC9oA9SMaagJl1rks0DNKBXgAl
B2MQVTcFgjQ=
=kCRo
-----END PGP SIGNATURE-----

--=-INUYnybLZLnAqY7Yl41v--

