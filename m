Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:37025 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792Ab0LEWqw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Dec 2010 17:46:52 -0500
Subject: Re: PCI: make pci_restore_state return void
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Jon Mason <jon.mason@exar.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
	Andrew Gallatin <gallatin@myri.com>,
	Brice Goglin <brice@myri.com>, netdev@vger.kernel.org,
	Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
	Steve Hodgson <shodgson@solarflare.com>,
	Ben Hutchings <bhutchings@solarflare.com>,
	Stephen Hemminger <shemminger@linux-foundation.org>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org, Brian King <brking@us.ibm.com>,
	Anil Ravindranath <anil_ravindranath@pmc-sierra.com>,
	linux-scsi@vger.kernel.org, Jaya Kumar <jayakumar.alsa@gmail.com>,
	boyod.yang@siliconmotion.com.cn
In-Reply-To: <1291160606-31494-1-git-send-email-jon.mason@exar.com>
References: <1291160606-31494-1-git-send-email-jon.mason@exar.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-hIo3ss+mqY7LCWIJJSeq"
Date: Mon, 06 Dec 2010 09:46:50 +1100
Message-ID: <1291589210.8514.17.camel@concordia>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hIo3ss+mqY7LCWIJJSeq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2010-11-30 at 17:43 -0600, Jon Mason wrote:
> pci_restore_state only ever returns 0, thus there is no benefit in
> having it return any value.  Also, a large majority of the callers do
> not check the return code of pci_restore_state.  Make the
> pci_restore_state a void return and avoid the overhead.

It does kind of make me nervous that (basically) no one ever checks the
return code from the PCI config space accessors, even though in theory
they can fail. This code being but one example.

/end random comment :)

cheers


--=-hIo3ss+mqY7LCWIJJSeq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkz8FloACgkQdSjSd0sB4dIPhwCeNnj0SmUov+MFuxEIOmKoioHa
Tl4An1+jVELgYgfllAqQnNuGjRly4Xgt
=nazf
-----END PGP SIGNATURE-----

--=-hIo3ss+mqY7LCWIJJSeq--

