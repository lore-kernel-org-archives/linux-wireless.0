Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56480 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933640AbZGPXyb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 19:54:31 -0400
Subject: Re: unable to bring up iwlagn wireless after update from 2.6.29.6
 to 2.6.31-rc3
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Backlund <tmb@mandriva.org>
Cc: reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4A5FBD19.6000803@mandriva.org>
References: <4A5D0374.5040702@mandriva.org>
	 <1247611024.1796.21.camel@johannes.local>  <4A5D0A7F.5090108@mandriva.org>
	 <1247672725.17896.1974.camel@rc-desk>  <4A5FA52D.7030701@mandriva.org>
	 <1247782731.31442.3.camel@johannes.local>
	 <1247783433.31442.11.camel@johannes.local> <4A5FB957.80407@mandriva.org>
	 <4A5FBD19.6000803@mandriva.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Ai/2LWTXBe4aovZYCOb8"
Date: Fri, 17 Jul 2009 01:53:58 +0200
Message-Id: <1247788438.1055.14.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Ai/2LWTXBe4aovZYCOb8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-07-17 at 02:51 +0300, Thomas Backlund wrote:

> > pressing rfkill when I have a working wireless gets this:

> And here is the above rfkill/ iwlagn error with "debug=3D0x01043fff":
>=20
> Jul 17 02:41:06 tmb-laptop klogd: rfkill_schedule_toggle(1)
> Jul 17 02:41:06 tmb-laptop klogd: __rfkill_handle_normal_op(1, 1) [1]
> Jul 17 02:41:06 tmb-laptop klogd: ieee80211 phy0: I iwl_rx_handle r =3D=20
> 77, i =3D 75, REPLY_RX, 0xc3

Yeah the errors are kinda expected.. not sure how we can hide them.

> Oh, btw is this below a refcounting bug?
> For each time I unload & reload the iwlagn,
> the number in front of phy0 gets increased:
>=20
> [root@tmb-laptop rfkill]# ./rfkill list
> 0: acer-wireless: Wireless LAN
> 	Soft blocked: no
> 	Hard blocked: no
> 1: acer-bluetooth: Bluetooth
> 	Soft blocked: yes
> 	Hard blocked: no
> 5: phy0: Wireless LAN
> 	Soft blocked: no
> 	Hard blocked: no

No, we just assign increasing numbers all the time.

johannes

--=-Ai/2LWTXBe4aovZYCOb8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKX72TAAoJEODzc/N7+QmawKIQAJrW+qT5TdDfhOpalFqnxbXD
HT83KE2TfpUYw/T3/lEuBuGeboYDFgaxXhAUKssAsb9WKrrNO9ex5cFAd/bSpHY9
FuHSRQ4u4dvcdexFuJingt/fuJGgU63YFQR7YxxL1UsRbv4nif9MWfrIviYNUcfy
zgNeUdYAJ4y4Ll5LSAUZ31L1uFwZTR+K3u+XiHEp6aRQVJFtoVC2+6If53E0ghFr
XWU5dPTYhGH6IjwrMjb1WVcGFgD4dfabA49incJYZi50u7JPkwDbzycCP2BR34hn
jd+CL1mDwhtZ62mrRqfcivmFPrwzYPQW+11RBeKlpqO1Z/jyVT7BMQbL5dv4xadr
ikJNghH9X1jQoBlJdrqJMur/ByPRO5g88iDkQ5yhMccoY3yJGp9I/ouzA6xOfiGk
Pw5xreekyaNFB+CMdDN3hX09nfKAsKE9nSjK89X2X0hrhIY1Qe5psq1qX5a/a+uA
ubepPCzvb05K2OoI2IVt/XnSdK8F+pUOnzp3QYyEIFq/usI9uXnOE1DGSrBlsnQO
4Ws701n8JLN+CkC23dneQmbu019vyZUwih++c7IA6Qoic+E496BPwW3SlPJI01/F
hds/uPq4sXP+drvKitJDWHzXYz8FCxMXlix/yXjSOFqWFGTKfObudyoKTTgI0k4l
RwLFoLAdytdf/t0d6bzS
=J/U3
-----END PGP SIGNATURE-----

--=-Ai/2LWTXBe4aovZYCOb8--

