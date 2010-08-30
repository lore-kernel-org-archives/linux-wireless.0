Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from liberdade2.minaslivre.org ([74.50.53.203]:57349 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab0H3P2t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Aug 2010 11:28:49 -0400
Date: Mon, 30 Aug 2010 12:28:42 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Rogerio Luz Coelho <rogluz.news@gmail.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <hintak.leung@gmail.com>
Subject: Re: [PATCH] rtl8187b: do not do per packet TX AGC
Message-ID: <20100830152841.GB2950@barata.holoscopio.com>
References: <1282974868-22237-1-git-send-email-cascardo@holoscopio.com>
 <4C798080.8010002@lwfinger.net>
 <20100830141218.GB30864@tuxdriver.com>
 <4C7BC4D9.1010108@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mxv5cy4qt+RJ9ypb"
In-Reply-To: <4C7BC4D9.1010108@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--mxv5cy4qt+RJ9ypb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 30, 2010 at 09:48:57AM -0500, Larry Finger wrote:
> On 08/30/2010 09:12 AM, John W. Linville wrote:
> > On Sat, Aug 28, 2010 at 04:32:48PM -0500, Larry Finger wrote:
> >> On 08/28/2010 12:54 AM, Thadeu Lima de Souza Cascardo wrote:
> >>> The code for rtl8187 does not do per packet TX AGC. Resetting the per
> >>> packet TX AGC for rtl8187b appears to increase its overall TX power.
> >>> This allows the device to associate and a connection be established
> >>> using APs a little further away.
> >>>
> >>> Tested-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> >>> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> >>> Cc: linux-wireless@vger.kernel.org
> >>> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> >>> Cc: Rogerio Luz Coelho <rogluz.news@gmail.com>
> >>> Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
> >>> Cc: Hin-Tak Leung <hintak.leung@gmail.com>
> >>> ---
> >>
> >> I'm a little confused here. The subject says not to set the per packet=
 TX AGC,
> >> while the submission text says that setting it helps. I don't have acc=
ess to any
> >> documents that describe this register, but I expect that clearing
> >> RTL818X_TX_AGC_CTL_PERPACKET_GAIN_SHIFT would disable that feature. As=
 a result
> >> the code change seems to match the subject.
> >>
> >> I have not yet tested this code, but I do note that all the Realtek dr=
ivers for
> >> the RTL8187B set this bit.
> >>
> >> Until testing, I withhold judgment on the actual code change, but NACK=
 for the
> >> inconsistency.
> >=20
> > Perhaps the word "clearing" rather than "resetting" would be less confu=
sing?
>=20

Thanks, John, for the clarification. Clearing is much better, really.

> I see the source of my confusion. I am in the habit of using lower case to
> indicate the driver and upper case for the device. I would rewrite the co=
mmit
> code to say "The code for the RTL8187L does not do per packet TX AGC. Cle=
aring
> the per packet TX AGC for RTL8187B ..."
>=20

I will use your rewriting. Thanks.

> I have now tested the patch. For my RTL8187B device, I get the following:
>=20
> Distance from AP      Indicated rate       Signal       Measured TX rate
>       2m                   18 Mb/s         -17 dBm      10 Mb/s
>      10m(original)         11 Mb/s         -48 dBm      2.6 Mb/s
>      10m(with patch)       11 Mb/s         -43 dBm      4.1 Mb/s
>=20
> The measured TX rates were obtained using tcpperf. At a distance of 2 m, =
the
> results were the same with and without the patch. At 10 m, the patch went
> through 2 exterior walls with drywall, insulation, and stucco. I'm not su=
re that
> the increase from 2.6 to 4.1 Mb/s is reproducible. About all I can say is=
 that
> the change did not hurt the performance of the device, which is already p=
retty bad.
>=20
> If the OP can post numbers documenting the improvement, I have no objecti=
on to
> this patch, even though every Realtek driver that I have seen turns "per =
packet
> TX AGC" on for the RTL8187B and turns it off for the RTL8187L.
>=20

Hum. Did you take a look at the version I've pointed out in the last
message, rtl8187B_linux_26.1056.1112.2009.release? It does not clear
PERPACKET_GAIN in the same function that it does for non-RTL8187B
devices. But it does in what should be the code for RTL8225Z2, in the
function r8180_rtl8225z2.c:InitializeExtraRegsOn8185.

I did not measure the distances exactly here, while doing my tests. But
I could move the AP further away by about 5 or 6 meters. The AP
indicated a -84dB signal while receiving injected packages. It was a
rt73usb device. File transmission through scp was not working that
further away, but I could still get an improvement of about 3 to 4
meters of distance.

I am still going to do some more testing today in a customer's facility.
And I would like very much that Rog=C3=A9rio, who has reported some problems
too, did some testing.

> Larry

Best regards,
Cascardo.

--mxv5cy4qt+RJ9ypb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJMe84pAAoJEEWxSg7udFZIP8AQAMHuMXHPJ4fX2YybdvepXaXT
fXbCuGq4CoRK2fF4ML29a2/Lgqls1dtgIu5ZjDC9SIRyxJFjLE6TBo3a/R3/4bBw
IBVxIASJhcPyVWMDNjrwikInH8h2azED34jCStVp0XhyMM+UmlJctpRcZ3DgbFBU
yrwmew76eBQwY8cbwKDy6wAElDNX5JV8M8tFaBG2gHX1UCdhk/RV6olzEhx/Ab2D
EdG/2P3U1xzGusv4xZigvuetTR6wVIBeCmlxGkMitrkB8jkmdoHn4RHL6QLAXxyI
TR2FvfiaXrfBeIKjpsIXFdFmvW6TSQr/TYQnTcyrbkZ5xYGojwbmDwfsew6Ogo3z
LqQR0Zhs2MP/t8AJCSHVjfpCjMUsIP7yQyd5h5F1EYL8a1bWMavKwLrsYVNcOzKj
ORDfJ+m3ztKstCX213Ub1NHsDbsschOkehJtSAabyJoyCDHqB0fFJfWB208EOUYl
EQ3XBZ9A+1ZarU/Bi51gKGLa6S/3ub47E6zCsKg0E5zkcNkOzmTVeVZD6TneHkYq
wN5edaIVcjd+LNMzzYPJakz0DdcUYA3iH2qqk6BA0fyDVuD5xBbTtgea2jwbdGC8
vS0Z25jjG/FreyfyPQZY4h6qEuaufzeCZIaRAwIto0mKR7ShY8Q6smZQt4eNiNcc
CFlKZ32QHSv1DH7khfX/
=jjhS
-----END PGP SIGNATURE-----

--mxv5cy4qt+RJ9ypb--
