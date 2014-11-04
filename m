Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43905 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751235AbaKDAHR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2014 19:07:17 -0500
Message-ID: <1415059621.27313.39.camel@decadent.org.uk> (sfid-20141104_010721_820703_5481FFB8)
Subject: Re: [PATCH 3.16 0/7] Backort firmware monitor to 3.16
From: Ben Hutchings <ben@decadent.org.uk>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: stable@vger.kernel.org, linux-wireless@vger.kernel.org,
	=?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
	767088@bugs.debian.org
Date: Tue, 04 Nov 2014 00:07:01 +0000
In-Reply-To: <1414476686-3407-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1414476686-3407-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-+Etj/+k9cXv1Xz2ddaNY"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+Etj/+k9cXv1Xz2ddaNY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2014-10-28 at 08:11 +0200, Emmanuel Grumbach wrote:
> This patch series allows to use the firmware debugging features
> of iwlwifi on 3.16. These features are already in 3.17.
>=20
> I know that this patch series is not compliant with Greg's
> rules for stable patches. It is unlikely that these patches
> will be applied on vanilla 3.16 - I know that.
> I send them here so that distros can apply them if they want
> to.
> I know there are distros shipping 3.16, and having these
> patches in can greatly help our ability to debug nasty
> issues.

Thanks, I've applied these to Debian's package.

Ben.

> Emmanuel Grumbach (7):
>   iwlwifi: add device / firmware to fw-error-dump file
>   iwlwifi: rename iwl_mvm_fw_error_next_data
>   iwlwifi: pcie: add firmware monitor capabilities
>   iwlwifi: remove wrong comment about alignment in iwl-fw-error-dump.h
>   iwlwifi: mvm: don't collect logs in the interrupt thread
>   iwlwifi: mvm: kill iwl_mvm_fw_error_rxf_dump
>   iwlwifi: mvm: update layout of firmware error dump
>=20
>  drivers/net/wireless/iwlwifi/iwl-drv.c           |   6 ++
>  drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h |  50 ++++++++-
>  drivers/net/wireless/iwlwifi/iwl-fw-file.h       |   5 +-
>  drivers/net/wireless/iwlwifi/iwl-fw.h            |   3 +
>  drivers/net/wireless/iwlwifi/iwl-modparams.h     |   2 +
>  drivers/net/wireless/iwlwifi/iwl-prph.h          |   6 ++
>  drivers/net/wireless/iwlwifi/mvm/mac80211.c      | 100 +++++++++++++++++=
+
>  drivers/net/wireless/iwlwifi/mvm/mvm.h           |   9 --
>  drivers/net/wireless/iwlwifi/mvm/ops.c           |  72 -------------
>  drivers/net/wireless/iwlwifi/mvm/utils.c         |  65 ------------
>  drivers/net/wireless/iwlwifi/pcie/internal.h     |   7 ++
>  drivers/net/wireless/iwlwifi/pcie/trans.c        | 125 +++++++++++++++++=
+++++-
>  12 files changed, 294 insertions(+), 156 deletions(-)
>=20

--=20
Ben Hutchings
Larkinson's Law: All laws are basically false.

--=-+Etj/+k9cXv1Xz2ddaNY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVFgYque/yOyVhhEJAQo2bRAAuVYPLeJQZofVTHA7HvpDFdPS57YCn+si
KSwlkZq4HInGzS4ar3CocD+Q7K8cZa+GFH8VyI3EPrD9aDR8i/FJgNWNEB+7uG6O
bcuvmDFLt4gImkvp2UbV6ZQcE2ATMO8YXO7gyScmu/MKy436yYbXhpRYAmhpm7eZ
nXJNWNGODsqGs3VCmboZQ6C/w8nPfciHXN9XakvRg6oJA33lcTeUZziA0M70CbRQ
KjmUzjm/JY8MI5Z7jUJdvQON96gHniFGcQvUxyi7JqFeAU1xRWAQ6O9kogS3ReMq
+/F0ltlbiRfsnFAwpML+L2GRmv/5Hoiwk51E8HyeKg9P2GFLqu53uTgUpyUxUcNP
vGN9//3KwZ8dwRAgC+9J5W/JAy2QejV7s28GYeCssyJb4JFDrZoZX7QpkDxj0wxw
clfK/yI680kUMG8T2Uz+FhzfWoIKSrT4e7Mg/ICg2voVI//eh+ZA0q5lwTRxrub8
hs7q8+i9FRMGcn3FoHsIUc4Np7lwAT2EAsWlxAC17UEUj2WvhG+DEsNb5pASb1PW
ZxxG8Luhs3YUBSKtwdhXhZ0iT5dRzz8834cNciH9BD7Oflq8HTb6l1KWnTBWavFA
06k+i52Eh7K/0aiBh2B510jy96BeofVPGIIaClNtmcdVXGnZdjMgibyuVHTv7Jlu
LwR6ImPdXvM=
=IQ3t
-----END PGP SIGNATURE-----

--=-+Etj/+k9cXv1Xz2ddaNY--
