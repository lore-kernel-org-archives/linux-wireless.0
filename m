Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43832 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbYIHPRF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 11:17:05 -0400
Subject: Re: [PATCH 1/1] mac80211: scan on IBSS mode like on STA mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Ester Kummer <ester.kummer@intel.com>,
	Luis Carlos Cobo <luisca@cozybit.com>
In-Reply-To: <1220886337.31304.71.camel@johannes.berg> (sfid-20080908_170546_243399_2C0B190E)
References: <1220880686-5620-1-git-send-email-tomas.winkler@intel.com>
	 <1220885742.31304.67.camel@johannes.berg>
	 (sfid-20080908_165552_656021_8FF20D03)  <1220886337.31304.71.camel@johannes.berg>
	 (sfid-20080908_170546_243399_2C0B190E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-f6fPKnA7Ebw1wYNDruQD"
Date: Mon, 08 Sep 2008 17:16:58 +0200
Message-Id: <1220887018.31304.74.camel@johannes.berg> (sfid-20080908_171710_772361_C3B2980E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-f6fPKnA7Ebw1wYNDruQD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-09-08 at 17:05 +0200, Johannes Berg wrote:

> > Can you explain why? Or can anybody else explain why we do this
> > difference at all? And how should mesh behave?
>=20
> Actually, I do understand the difference now (explanation added below)
> and if I'm guessing the problem you're having correctly your patch is
> wrong. I think you want something like the patch below (never mind the
> fact that it's against scan.c, I'm shuffling code)

>  	if (local->sta_sw_scanning || local->sta_hw_scanning) {
>  		if (local->scan_sdata =3D=3D sdata)
>  			return 0;
>  		return -EBUSY;
>  	}

Then again, ieee80211_sta_start_scan does that check as well, so now I'm
confused.

johannes

--=-f6fPKnA7Ebw1wYNDruQD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIxUHmAAoJEKVg1VMiehFYt+AQALOhdSapbHZ4JHFSzkt2zM1j
eQNqcuMXc6y1qLEQYvnjeRtPDaFr8D3wsowfFIFqSRVAtePJwZUc0iC+AVp9o/0D
BfeCfVm+CgvrsQEMaIRq0zUQz+1N+678zX3f+q9frMcnB0F9yTargsEiLdto5lIK
HL0uEiKMYm9omxowIttD+eiKS9HqJQTHQKj9qnImsLr5ZtDAw3OXZVQH5ie2Zjkp
o7p5qsESvYEUgP73vvrvnjDFkvidQjuHSWwA7eKym9yhwt2B647GmP1AB6mJ6+Bq
SQITAK7li7VENHDLrkSJbPt+wzruxQAwSQwuPm5TT2rnf1gxS192ALDB29Hd02Os
40l1BjQxCPtslEOnY4CX1Pk/3Bu57I0Uf4FsX9LwwRXiLfXJ1eM5hbV1GobnB+/A
tKYJy+YuHAAsgLMdpEg18YbYqxVsCilHtBXTWJBgGM2kOd76BBNXzJzLSD6+SD0g
PixN4PU1zesSnr0HQU+0+BV9Oz8MlyK5sjYo3Jr/pfTuqV8tdPWBxgaRlnoBC13D
f9LJYjuMtPbCHGODwWFQbJs/p+OhuV03i683xfxVesEPwolDO7Nex7qr+oGZdsFO
PcPeUXXV3W9M/gevPXN/yUsHxWI1tQ7HFmXVHPKQ+x7xgIXZ6Irgfuro9Fxymxq/
1tjyS9Eq/DZneQrRCLFR
=RRXK
-----END PGP SIGNATURE-----

--=-f6fPKnA7Ebw1wYNDruQD--

