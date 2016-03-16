Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52895 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966001AbcCPMuF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2016 08:50:05 -0400
Message-ID: <1458132594.31907.13.camel@decadent.org.uk> (sfid-20160316_135020_110586_20706C87)
Subject: Re: [PATCH 4.4 24/50] wext: fix message delay/ordering
From: Ben Hutchings <ben@decadent.org.uk>
To: Beniamino Galvani <bgalvani@redhat.com>,
	Johannes Berg <johannes.berg@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 16 Mar 2016 12:49:54 +0000
In-Reply-To: <20160314175016.873890285@linuxfoundation.org>
References: <20160314175013.403628835@linuxfoundation.org>
	 <20160314175016.873890285@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-aOLEjWJm7mKfKDKJeDf8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aOLEjWJm7mKfKDKJeDf8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2016-03-14 at 10:50 -0700, Greg Kroah-Hartman wrote:
[
> 4.4-stable review patch.=C2=A0=C2=A0If anyone has any objections, please =
let me know.

I don't have any objections, so I dropped Greg and stable from the
recipients.

[...]
> --- a/net/wireless/wext-core.c
> +++ b/net/wireless/wext-core.c
[...]
> =C2=A0static int __init wireless_nlevent_init(void)
> =C2=A0{
> -	return register_pernet_subsys(&wext_pernet_ops);
> +	int err =3D register_pernet_subsys(&wext_pernet_ops);
> +
> +	if (err)
> +		return err;
> +
> +	return register_netdevice_notifier(&wext_netdev_notifier);
> =C2=A0}
[...]

In practice this is safe as=C2=A0register_netdevice_notifier() will only
return an error if your notifier does so, which it does not. =C2=A0But it
seem like a good idea to future-proof it by adding a check for failure
and calling unregister_pernet_subsys() in that case.

Ben.
l
--=20
Ben Hutchings
If you seem to know what you are doing, you'll be given more to do.
--=-aOLEjWJm7mKfKDKJeDf8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJW6VZyAAoJEOe/yOyVhhEJ6zgP/1EXNk6CED7qoHkFDlS749Un
5dyBP/8RwlEcQpg4CJCcf6I1nJu/E5BcO93NJl3dnZifvfW2eEAmMIcguWUIxppl
hpCUMyPL1xQ5rnSAkfpMAta1EchaQEzsRfXLNNAvquwRdgFO+3VCglJ30B9zhYMN
WN8mPg/koagYuqlRi0E6XwJ4x8mR0WHwP4+LLZmH1o8IStLtb/8ZsHQBIhi6Lnvb
bAE0ZbaRPWXVc6WcXcDx58kIzDJxlVmYo5xsi0RGt35jL01w+XaF8rSjwSBHvzgz
XmGyGmKTzsLSwLgGIbVsB4xUmtYGF7Mevj8tIAKnYc6P2BF16k097UBBWSrmOQO5
PLH98TacmKSLELigdtIsUlNcWjxdntnEurJ2Ixv2NVXOCTuzsstTZdNoNi8TLKFU
wenRwnKNkDvk/FG9PYm7vioe0cKx3PmisJ8ptA8lN6NbQMN2sr2MfMsoeH07E4y2
4mgF4dk0k9D0PzinGKALXiWA3TmbTi7AMYEluPtVCAIn504jhjbnZW7QE/htj/7L
Z/UcNzdf8Ro1y0hT5o8mlRTm5/vREQtZmBtvoiSGMphYKuxO5x0QXWtXgTHDPTdo
5mZqxaiVXkzXRLAANfeFTECzbxSJQa9a7QvTWX5fQ6AZXo1p9yN3q/dV2ptRkc5T
IaiS4TgJ4Qr7t55YtfKQ
=cVbf
-----END PGP SIGNATURE-----

--=-aOLEjWJm7mKfKDKJeDf8--
