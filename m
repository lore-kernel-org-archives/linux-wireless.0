Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:58261 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752480AbdGEI2l (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Jul 2017 04:28:41 -0400
Date: Wed, 5 Jul 2017 10:28:37 +0200
From: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
To: Tony Lindgren <tony@atomide.com>
Cc: "Reizer, Eyal" <eyalr@ti.com>, Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wlcore: add missing nvs file name info for wilink8
Message-ID: <20170705082837.g6tmsfeeld6dvsw3@earth> (sfid-20170705_102902_842219_ECE9A559)
References: <8665E2433BC68541A24DFFCA87B70F5B363E1A3D@DFRE01.ent.ti.com>
 <87y3s5kbc3.fsf@kamboji.qca.qualcomm.com>
 <20170704081757.GH3730@atomide.com>
 <8665E2433BC68541A24DFFCA87B70F5B363E29C8@DFRE01.ent.ti.com>
 <20170705080653.GJ3730@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="sqemetu5rv5v2zdr"
In-Reply-To: <20170705080653.GJ3730@atomide.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--sqemetu5rv5v2zdr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jul 05, 2017 at 01:06:54AM -0700, Tony Lindgren wrote:
> > > Not sure if this really is a regression as we've always had a bogus
> > > wl1271-nvs.bin in linux-firmware.git. Sure would be nice to fix it,
> > > but going back to using a generic wl1271-nvs.bin sure does not seem
> > > like a good long term fix to me :)
> > A lot of legacy here...
> > Wl1271-nvs has been used mainly with wilink6/7 and indeed was device sp=
ecific
> > Holding calibration info etc.
> > When they started with wilink8 the device specific configuration that w=
as=20
> > Part of it has switched to wl18xx-conf.bin and using the wlaconf tool f=
or setting it.
> > Also there is no calibration specific info per device with wilink8 so t=
he wl18xx-conf.bin
> > The only thing left in wl1271-nvs.bin for wilink8 was the mac address o=
verride.
>=20
> And the default wl1271-nvs.bin sets the mac address to a bogus deadbeef a=
ddress,
> so it's wrong to use and totally broken for distros :(

So use something like the following pseudo-code?

if (fw->mac_address =3D=3D deadbeef) {
    fw->mac_address =3D get_random_mac();
    dev_warn(dev, "Detected unconfigured wl1271-nvs.bin.\n"
        "Your device will run with limited performance.\n"
        "Please use ti-utils to configure your device.\n");
}

-- Sebastian

--sqemetu5rv5v2zdr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAllcozIACgkQ2O7X88g7
+pogOQ//VTlAJ1fuDbP4Ay0nbuAMyszrL7v5fhftWyeapncf9VKOjgzzQctF6/T0
HzUTa5ffvtAGEV3mqwlipvx0SytrjRh5y90H0LJwTrC4FG3BwvpohozA6nXrBYw6
jst3DPcy0K9vfX58rxBvHQLp9EIE8+eJth8pCRW8oVcD+8XY10mxh+A1abVryBpF
apDygqyfq56LiwYcDmFR2fJm4PGJ54U+yWn0SNcbt9zHpZpoEz4bDfJWuq2JGxpe
dZbn0Zijwu8wYuTe505GmNM4LdEYG2lUKEeS6UhD5kCHz4yt3tpW2kRs4Rl33IHu
+BlY38RQ1CtO4tJv8a+LHu5Ihd5xzGVupBVYpPkMeEsAz/x4BJXLRTYWgEAJIfyM
q2xMC0nCQXDncIlna7uD0sL9MQX9R/4DNthyhTkUUEturOnG7YdvN6QPnfLq0LPr
5IHoGoXr/7t1E4HKg6dki8pm22FAPFNJHr2w6Ym/cpFW4z+JY9dKLyUQnRK7nrJM
osv7Bvf8hWqN2AzQheRD5yLLarS3Ejx4eYA/F/AYQjRPBeRa8jfHB5hFGLD5lA/T
aOU/M7k1vtqhhCfKs7Y0FUANnzxfMW/RFINg5hU+j79UqLhOWWAuleuIxF9RKRVY
FiLYDfgxRsTWZs+1yNRlsrcXSK+KX8OaFmTWqvdlutvNzVuy6UM=
=3f5F
-----END PGP SIGNATURE-----

--sqemetu5rv5v2zdr--
