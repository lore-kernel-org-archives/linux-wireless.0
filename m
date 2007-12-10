Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45665 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbXLJMLs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 07:11:48 -0500
Subject: Re: [PATCH 1/1] mac80211: pass in PS_POLL frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <1197278205280-git-send-email-ron.rindjunsky@intel.com>
References: <1197278205280-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1xmeNvvcGZMboDYcyID8"
Date: Mon, 10 Dec 2007 13:08:59 +0100
Message-Id: <1197288539.6035.55.camel@johannes.berg> (sfid-20071210_121151_296631_6DC3C25F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1xmeNvvcGZMboDYcyID8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> -	if ((hdr->frame_control & cpu_to_le16(IEEE80211_FCTL_FTYPE)) =3D=3D
> -			cpu_to_le16(IEEE80211_FTYPE_CTL))
> +	if (((hdr->frame_control & cpu_to_le16(IEEE80211_FCTL_FTYPE)) =3D=3D
> +			cpu_to_le16(IEEE80211_FTYPE_CTL)) &&
> +	    ((hdr->frame_control & cpu_to_le16(IEEE80211_FCTL_STYPE)) !=3D
> +			cpu_to_le16(IEEE80211_STYPE_PSPOLL)))

Hm. Don't we have macros for this?

johannes

--=-1xmeNvvcGZMboDYcyID8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR10sWqVg1VMiehFYAQLCmg//YiJxxUUqhGWB8fI5zWUaPRO1XOgmDJA6
M/Op+SPLIrkZT/RIoY5LayzzD+7WyXDQKffsjLhZ4WgvFwQ1G6DbyktFq5a/diUi
RCZBVAoLwkKURHcz0A/MIHA+OpXmWxdj4HZ59a0oOBusPqoDaGTOZvYquG1gAnu7
6MrJf2d4h4HKY1fKAGPByIP/Xn4tdx+Oyb8RuBv0RMeBbPigqm6i4CjUzfmLesAM
MoIu9K4S3kU4/vdHnO1Fw/ky6QQgCgJYhVt6BIDrPJGveUZ8bgUc0k9ZPqH8b4T1
9Qo2SlBVvzMhFZu1nwip64/9WfwCSLps3ydKfWoWAuzqpkceHEdk5ZQDY0BJgFFB
XYYYDXlBdQmIfIFDd0Y3ydCbi4/d/TSInbIr9ohUaj1resNwLmtf+2q8CeAx0rbA
XAyITdBwRsDlg4TmdW8gHxrTiNCU5Oy5M5GOSZkCC1mP9CINO9qavt4seh1wBUTz
oOy8E7nThIlZmRo3uFR1jNOpvCQz65MfmYAndUGrpmZoVgBovZIa4C2rWDA2w6n5
YgqRzq/XWDqzVctFe0kuYZa/qJdCLC+UP52A9aa4G9zFaJfhXMKeK7zTO7kGWpir
pgsCvYh7PFJ7j5Us4X0YPWr7jeLtE192lrAuYxHKXu9j5bTI/3soPH/xKhrb22t6
KUEScuU3M3o=
=iNRS
-----END PGP SIGNATURE-----

--=-1xmeNvvcGZMboDYcyID8--

