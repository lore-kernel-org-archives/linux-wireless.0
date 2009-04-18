Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51772 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbZDRR7e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Apr 2009 13:59:34 -0400
Subject: Re: rfkill rewrite bug
From: Johannes Berg <johannes@sipsolutions.net>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <49EA10F3.3070309@tuffmail.co.uk> (sfid-20090418_194244_839181_896F358B)
References: <49DCA88E.6060400@tuffmail.co.uk>
	 (sfid-20090408_153722_059382_FB44D658) <1239204090.16477.1.camel@johannes.local>
	 <49DCDD2E.80705@tuffmail.co.uk>  <49E38BBC.5010708@tuffmail.co.uk>
	 (sfid-20090413_205524_915082_56358705) <1239741968.4205.1.camel@johannes.local>
	 <49E98C86.2040308@tuffmail.co.uk>
	 (sfid-20090418_101208_980691_83127E2F) <1240043283.5792.0.camel@johannes.local>
	 <49E9A0C7.8040602@tuffmail.co.uk>
	 (sfid-20090418_114338_695917_3CBF9024) <1240057470.4755.7.camel@johannes.local>
	 <49EA10F3.3070309@tuffmail.co.uk> (sfid-20090418_194244_839181_896F358B)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-wibPDPg65PvVToB49OY+"
Date: Sat, 18 Apr 2009 19:59:31 +0200
Message-Id: <1240077571.25100.3.camel@johannes.local> (sfid-20090418_195936_704740_94651F66)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wibPDPg65PvVToB49OY+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-04-18 at 18:42 +0100, Alan Jenkins wrote:

> > That's odd, I thought I added a set_sw_state() to rfkill which would
> > disable that rfkill. But there's rfkill_set_global_sw_state() which
> > should do what you want -- can you try replacing the EEE set_sw_state
> > call with that?

> Yes, that fixes it.  Now it works the same as the old code which used
> rfkill_set_default().

Cool.

> +static int eeepc_hotk_resume(struct acpi_device *device);
> =20
>  static const struct acpi_device_id eeepc_device_ids[] =3D {
>  	{EEEPC_HOTK_HID, 0},
> @@ -191,6 +192,7 @@ static struct acpi_driver eeepc_hotk_driver =3D {
>  	.ops =3D {
>  		.add =3D eeepc_hotk_add,
>  		.remove =3D eeepc_hotk_remove,
> +		.resume =3D eeepc_hotk_resume

Please add a , at the end so other people updating that in the future
don't need to change that line too.

> +static void eeepc_rfkill_hotplug()

Need (void) not ()

If you change those and give me a S-o-b I'll integrate it into my patch
with something like

S-o-b: <you> [eeepc driver parts]

johannes

--=-wibPDPg65PvVToB49OY+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ6hUAAAoJEKVg1VMiehFYtsMP/A9S+EwK7r3M+mIJ870mWgXO
wYBWFBdHjPeMNw2okVXmKB2NIGInYT7L3+uqsCJGvc+t/4Qk2MckJgbPRo74KveA
iiPQBmkT6nZac8dLq2TyUm+kar1lqeCR2psDPR4oVvrQn8FsNahF02jISS04HJoP
AeAEHKXp/j+YqgZcUcTUxMtOxmxME3MoEoo+gPU3lhZc0nPDbi3C2E+NoSLsfpQW
QH7PYNyI9WI7Mf9KInWO+Sl1rOn1YRfWHtyRC5W7AgfiEBI2TKBnfpl6cFtKYw04
aspBQwXvlw+s4i+suW/4zCE097k/2tvggtmYEE0Y/EizzwJDNde84wueY0dlnVmq
U0I0djtRg8HG8nsh727+UA0fau1KGmk7X9o9xRsF3QFY/GVrg5NNQs4T3O2PDYDF
Jz7QiS0awjXRiQJalR8VaaRFZcWCBXFsHCiGrFJ6pH6OEkPNOzelGheJSIXu3Bcw
Fc5qLaFb9gvh43km+Oxz9ICA9TIHRR4lsg0wAGoyhGsgLrqj9V5hpSSVBtr2uMeI
0xG5QRFO3PFGNtL94Ze1ZdSDoJ5c/Ktu6fCPFJNY/1xzjiY+cN4gNUcnQz+6sNBc
h3ql3yWFE9gragepuClnc8gqHgSh7kpZdNdXGynpKZF9kaN9jP7aZjAb8/Z9ySUi
kwdS9r7nTKvBJp7wjZAl
=TV9c
-----END PGP SIGNATURE-----

--=-wibPDPg65PvVToB49OY+--

