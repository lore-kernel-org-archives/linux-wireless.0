Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from haggis.pcug.org.au ([203.10.76.10]:54026 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090Ab2EGNBy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 09:01:54 -0400
Date: Mon, 7 May 2012 23:01:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 01/20] NFC: Fix up for NLA_PUT_ api changes
Message-Id: <20120507230140.2d0a120217a91136613846f8@canb.auug.org.au> (sfid-20120507_150200_498186_95A730AF)
In-Reply-To: <1336386691-24840-2-git-send-email-sameo@linux.intel.com>
References: <1336386691-24840-1-git-send-email-sameo@linux.intel.com>
	<1336386691-24840-2-git-send-email-sameo@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__7_May_2012_23_01_40_+1000_gnAVIa0+o/EiTvQh"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Signature=_Mon__7_May_2012_23_01_40_+1000_gnAVIa0+o/EiTvQh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

On Mon,  7 May 2012 12:31:12 +0200 Samuel Ortiz <sameo@linux.intel.com> wro=
te:
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
> ---
>  net/nfc/netlink.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
> index ebdb605..6c558bc 100644
> --- a/net/nfc/netlink.c
> +++ b/net/nfc/netlink.c
> @@ -197,8 +197,10 @@ int nfc_genl_target_lost(struct nfc_dev *dev, u32 ta=
rget_idx)
>  	if (!hdr)
>  		goto free_msg;
> =20
> -	NLA_PUT_STRING(msg, NFC_ATTR_DEVICE_NAME, nfc_device_name(dev));
> -	NLA_PUT_U32(msg, NFC_ATTR_TARGET_INDEX, target_idx);
> +	if (nla_put_string(msg, NFC_ATTR_DEVICE_NAME, nfc_device_name(dev)))
> +		goto nla_put_failure;
> +	if (nla_put_u32(msg, NFC_ATTR_TARGET_INDEX, target_idx))
> +		goto nla_put_failure;
> =20
>  	genlmsg_end(msg, hdr);

This has been superceded by the merge fix Dave Miller did when he merged
the wireless-next tree into the net-next tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__7_May_2012_23_01_40_+1000_gnAVIa0+o/EiTvQh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPp8e0AAoJEECxmPOUX5FECK4QAIQ5KpDGU6QHNvlZ3QnZViZf
cgHa7lWMvRbvPbfboZztw76WfQKVbjOovs1ZYDQT6nUEzjAIswBYT04+EAsH1HZ6
rrIlCnF8hTl36817JVqW2CbaIdl221aYeRDlHJWjuwv+SqFb+guzZNOCFYRhZWzt
CXJ203n0/Q0mHIXavQaTyrva5uMHOK88Q+sestEgbqqYb3c+C00aLjkELINjFYcm
36gL8DMoJSrJjk+PT9wG2eO1KLF/80Q0yRgw5rrWntZpKyNxaZjsBSaOLWZCqnCh
jK5omf5mMnjb1TPpVSDvKaQWFeXqUP3caxwPO6exYzH608XqPBX2YQ3CoHjxm7fm
SfPsvYG2ofZJTKh2HrkoacR+gFnUcAZ7RMFZIzWQ13NSak0BmIWA1GScar8PFq4e
kRGVnUoIVkvf1jRKK1q+cQMbi7HGNK6f1eYpuJNHW0aduXsFzCis64hKZWiaMdW1
W4H5VkPXutiaPHlpew0AoXVwYz7Nj+51ZW2uoqyPqBglZ/vIfbMjtzZGOgGDaq9d
arjI+oRHE+8ObpIvWam7gUkjhTP5LVuqDxS8280UNJHT8oI2DkchYOFkGdaNtpgq
eq7ynU4fkVBgVDpr/CmRUwhxZ2n4TPJW+Hp2243ZdPXTu4Ah24i+jPuvT/jdXfT8
wCcrogVOYnqT7z0Y+egC
=1dBy
-----END PGP SIGNATURE-----

--Signature=_Mon__7_May_2012_23_01_40_+1000_gnAVIa0+o/EiTvQh--
