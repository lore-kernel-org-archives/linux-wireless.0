Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.mail.ru ([94.100.176.17]:3591 "EHLO mx3.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754281AbZBTS0T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 13:26:19 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: orinoco-devel@lists.sourceforge.net
Subject: Re: [Orinoco-devel] [PATCH 1/2] orinoco: validate firmware header
Date: Fri, 20 Feb 2009 21:26:08 +0300
Cc: David Kilroy <kilroyd@googlemail.com>,
	linux-wireless@vger.kernel.org
References: <1235087187-23425-1-git-send-email-kilroyd@googlemail.com> <1235087187-23425-2-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1235087187-23425-2-git-send-email-kilroyd@googlemail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4662805.4LgVx2D9MH";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200902202126.12230.arvidjaar@mail.ru> (sfid-20090220_192640_366900_5BB6450C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart4662805.4LgVx2D9MH
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 20 of February 2009 02:46:26 David Kilroy wrote:
>
> +static const char *fw_err[] =3D {
> +	"image too small",
> +	"format not recognised",
> +	"bad headersize",
> +	"bad block offset",
> +	"bad PDR offset",
> +	"bad PRI offset",
> +	"bad compat offset"
> +};
> +
>  /* Structure used to access fields in FW
>   * Make sure LE decoding macros are used
>   */
> @@ -43,6 +53,32 @@ struct orinoco_fw_header {
>  	char signature[0];      /* FW signature length headersize-20 */
>  } __attribute__ ((packed));
>
> +/* Check the range of various header entries */
> +static int validate_fw(const struct orinoco_fw_header *hdr, size_t
> len) +{
> +	u16 hdrsize;
> +
> +	if (len < sizeof(*hdr))
> +		return 1;
> +	if (memcmp(hdr->hdr_vers, "HFW", 3) !=3D 0)
> +		return 2;
> +
> +	hdrsize =3D le16_to_cpu(hdr->headersize);
> +	if (hdrsize > len)
> +		return 3;
> +	if ((hdrsize + le32_to_cpu(hdr->block_offset)) > len)
> +		return 4;
> +	if ((hdrsize + le32_to_cpu(hdr->pdr_offset)) > len)
> +		return 5;
> +	if ((hdrsize + le32_to_cpu(hdr->pri_offset)) > len)
> +		return 6;
> +	if ((hdrsize + le32_to_cpu(hdr->compat_offset)) > len)
> +		return 7;
> +
> +	/* TODO: consider adding a checksum or CRC to the firmware format
> */ +	return 0;
> +}


I am afraid this can easily go off sync. Any reason those messages=20
cannot be printed inline in validate_fw()?

Otherwise what about

#define FW_ERR_OK	0
#define FW_ERR_TOO_SMALL 1
=2E..
static const char *fw_err[] =3D {
	[FW_ERR_TOO_SMALL] =3D "image too small",
=2E..

	if (len < sizeof(*hdr))
		return FW_ERR_TOO_SMALL;
=2E..
	return FW_ERR_OK;

?

--nextPart4662805.4LgVx2D9MH
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkme9cMACgkQR6LMutpd94wrXQCg0HeAL/mGnHe1u2WeMDujQTNI
fy4AniRgyk+fZ2ecZJ2mOYOfoG1hlYAc
=73Xs
-----END PGP SIGNATURE-----

--nextPart4662805.4LgVx2D9MH--
