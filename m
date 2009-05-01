Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.webfaction.com ([70.85.44.146]:54761 "EHLO
	mail3.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763351AbZEAAEN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2009 20:04:13 -0400
Date: Thu, 30 Apr 2009 20:03:31 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: Greg KH <greg@kroah.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH 7/8] vt6655: Replace net_device->priv accesses with
	netdev_priv calls.
Message-ID: <20090501000330.GC6996@storm.local.network>
References: <20090425001405.GB23173@kroah.com> <20090425143235.GG11201@storm.local.network>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xo44VMWPx7vlQ2+2"
In-Reply-To: <20090425143235.GG11201@storm.local.network>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--xo44VMWPx7vlQ2+2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I haven't had a chance to test this on real hardware yet.  Sorry, I will tr=
y to
do this soon.

On Sat, Apr 25, 2009 at 10:32:35AM -0400, Forest Bond wrote:
> @@ -1226,11 +1227,6 @@ static BOOL device_init_info(struct pci_dev* pcid,=
 PSDevice* ppDevice,
> =20
>      PSDevice p;
>     =20
> -    *ppDevice =3D kmalloc(sizeof(DEVICE_INFO),GFP_ATOMIC);
> -   =20
> -    if (*ppDevice =3D=3D NULL)
> -        return FALSE;
> -       =20
>      memset(*ppDevice,0,sizeof(DEVICE_INFO));
>     =20
>      if (pDevice_Infos =3D=3D NULL) {

I realized that I did not remove the corresponding kfree calls for this rem=
oved
kmalloc.  Should I resend, or is it better to send an additional patch to be
applied on top of the original patches?

Thanks,
Forest
--=20
Forest Bond
http://www.alittletooquiet.net
http://www.pytagsfs.org

--xo44VMWPx7vlQ2+2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJ+jxSRO4fQQdv5AwRAoCAAJ45lt0ihV9Hp/ecG6R68yqpkH6rvwCeLBqO
4eWk8mbJwhjvxD82ZHJN8FM=
=+dWs
-----END PGP SIGNATURE-----

--xo44VMWPx7vlQ2+2--
