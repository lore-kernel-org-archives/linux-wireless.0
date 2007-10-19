Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52908 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758232AbXJSNta (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Oct 2007 09:49:30 -0400
Subject: Re: [PATCH 1/1] mac80211: adding bss_config to low driver ops
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
In-Reply-To: <1ba2fa240710181146t111bd63ek97cf0c102d17369@mail.gmail.com> (sfid-20071018_194612_884567_BC7A460B)
References: <11926651061687-git-send-email-tomas.winkler@intel.com>
	 <1192726084.15285.31.camel@johannes.berg>
	 <1ba2fa240710181146t111bd63ek97cf0c102d17369@mail.gmail.com>
	 (sfid-20071018_194612_884567_BC7A460B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Fpg2tzGi56k8YsW1GL/k"
Date: Fri, 19 Oct 2007 14:25:44 +0200
Message-Id: <1192796744.4167.7.camel@johannes.berg> (sfid-20071019_144933_003455_D9436C99)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Fpg2tzGi56k8YsW1GL/k
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-10-18 at 20:46 +0200, Tomas Winkler wrote:

> > I think this is a bit dangerous. Above, you defined the structure membe=
r
> > 'changed_map' which I personally would read as "take care, in this
> > structure the fields X, Y and Z changed over what I gave you last time"=
.
> > However, the way it's used here is as a 'valid' bitmap, in "In this
> > struct, only the fields X, Y and Z are valid". This is a huge differenc=
e
> > if the driver happens to need multiple things at the same time, with th=
e
> > approach you're doing here you'd need to keep track of everything in th=
e
> > driver.
> >
> Yes we can have both valid and change bitmap to lower that burden from
> form driver.

Oh I just realised that I didn't read this closely enough. If you
actually keep this structure around then we don't need a 'valid' bitmap
at all because all info will be valid all the time. If possible, I think
that would be much preferable, but I haven't really given much thought
to how complex it would be to implement.

johannes

--=-Fpg2tzGi56k8YsW1GL/k
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARxiiR6Vg1VMiehFYAQKkABAAvVB7rsIruP1G+gAWQD3GWpyJpRitLREN
bh/SsGjwXQn05BxL9DT68yp8MIyl8b6d/pm7T4lwlNvAc552281X2+dCp7ub64Zx
MZljpb8aKQz+6Vn+FLeG3PT9LBbzYRSjEfUKSIQYo8CW99U6LSApm6k39lOWVDI3
Xwb+4G7WDN6FK0GDSx4J3pxeZl6Jwg/lVCc1cY5YzR+4Xq4oufYs18trsPrmUReN
gwWeKs+Vx3Qpi1mqFT8jUwBunBZRXHTGIHmq3gt+H5HmcQ5woRUbiSnJ4QA6s8qw
EkewGmB1nahLYuwM7bCpu+YLWNE/5lTjbN2JcKKBTrT0Vi11111dGyCni9f93rn+
wSpP62cSAftEmFIyb2nYEUTQKYLHY+VHEfEMF7gBvSAycqCo9ve1P7aDPQbu0NJA
WJml8bjCIqXKMnoQLPYSZ7z2zUP/kT35xTSh023/vD4EEMzVvOVr61nhBv0z5yfM
4K2DRl1xNTLSH8Om5PGgZNolWgM56OYMcw6PckTM04OeTunvoomNHysYKBMpAOPo
DSHf9s/JWyIvrCmEB3FfnyjM1thr6wzkcztE/6DtErBCRTB7byYy7JfkFuIjhkFt
PVHz+NIkGBLUjHZBIPqzw4ncfaVRLL7soDae2g4YlGUZTmfTpjULzs2pXI5qtr4p
lDlB4aguj6c=
=Nb4o
-----END PGP SIGNATURE-----

--=-Fpg2tzGi56k8YsW1GL/k--

