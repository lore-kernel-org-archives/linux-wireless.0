Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54442 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbZEOL00 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2009 07:26:26 -0400
Subject: Re: ar9170 deadlock report
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200905151318.06411.chunkeey@web.de>
References: <1242384642.5799.48.camel@johannes.local>
	 <200905151318.06411.chunkeey@web.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-wMwDB3ByWriTYeuaEJXE"
Date: Fri, 15 May 2009 13:25:59 +0200
Message-Id: <1242386759.5799.50.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wMwDB3ByWriTYeuaEJXE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-05-15 at 13:18 +0200, Christian Lamparter wrote:

> > Don't cancel a work under a lock that it needs!
> >=20
> > johannes
> >=20
> do you have the module this time?

Yes, why? The bug is trivial:

        mutex_lock(&ar->mutex);
        cancel_delayed_work_sync(&ar->tx_status_janitor);
        cancel_work_sync(&ar->filter_config_work);
        cancel_work_sync(&ar->beacon_work);

vs.

static void ar9170_tx_status_janitor(struct work_struct *work)
{
	...
        mutex_lock(&ar->mutex);


johannes

--=-wMwDB3ByWriTYeuaEJXE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKDVFDAAoJEODzc/N7+Qma+A8P/21LUIkJA+uQ1MonMQFyOFBZ
2KURxq8igAJqNozwe9qMkewcX8CCrEJWke5tKqyWLpG/vVm9kqO6y43iBStOvb/l
mgWzJM4epltLInUeiXaUtnOPbNbjPDzZEeeQ2LltfEhyU4avZP0ZoyveDAyK+vhg
1/KgZKhgHdQpfukYTQ/clRx073gj5NLoQ5buroA/S/iQhDYr5TEIk+Cs1jR4M9D9
2o1ShwzNNyxBLlCMzHWnHclsf7ygtseUQ2sdBcaSCV1EgAXP/TCtR/wTJxgmb9qj
UmUAsWvZFRGoPohs+LQn99Zi0VKPZ6ZFIlm4KZoyW3XsxUjMsPfA2alLxEZAEmca
ktWQ4e/NQ3nfjUFiCt5KeC+OcqUqlHfO9TbmWvAQ8f1qk3TEgy4/7yK3HF7Knrkk
HOqjpSwslI6kpN9wIwvAOgk0P5+C7igqTeZZpuV2T/Xd2x/XBmuOlqzYTmHNmONl
a5mhAz8mr2rc46jHc8zk0QFoS7uWgXp4P/d8Ip4s3k1FJmEgrlfy+YLLCCNf1Ra6
qJshMNz7TcAjAeKMcjgb6fGHW5hn/5xzUDokE/HL7QP/YEfAuS6aJ539HoNB6/a6
XLnnlbV47HQNZjZ7IbG3JauPTfnehpwdL42gA7eA8YfzQXig/19PaDFjZ0QjAzrz
bzHoH81/vYv5eV2VsaJC
=iqKP
-----END PGP SIGNATURE-----

--=-wMwDB3ByWriTYeuaEJXE--

