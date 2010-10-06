Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49727 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755427Ab0JFVye (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 17:54:34 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Julien Cristau <jcristau@debian.org>, 599345@bugs.debian.org
Cc: ilw@linux.intel.com, linux-wireless@vger.kernel.org
In-Reply-To: <20101006191947.GA3036@radis.liafa.jussieu.fr>
References: <20101006191947.GA3036@radis.liafa.jussieu.fr>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-SbZtQ1ZoJL9pfoGF61xE"
Date: Wed, 06 Oct 2010 22:54:03 +0100
Message-ID: <1286402043.2955.81.camel@localhost>
Mime-Version: 1.0
Subject: Re: Bug#599345: linux-image-2.6.32-5-amd64: iwlagn allocation
 failure
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SbZtQ1ZoJL9pfoGF61xE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-10-06 at 21:19 +0200, Julien Cristau wrote:
> Package: linux-2.6
> Version: 2.6.32-23
> Severity: normal
>=20
> iwlagn decided 2 weeks of uptime was enough and it wanted me to reboot,
> because it was unhappy after resume.

You also told me that this machine had no swap enabled, which is an
unusual configuration and restricts the ability of the VM to defragment
memory.  I would recommend adding a small swap file/partition.  However:

> Bit of kern.log:
>=20
> Oct  6 21:05:02 radis kernel: [378665.326381] NetworkManager: page alloca=
tion failure. order:4, mode:0x40d0
> Oct  6 21:05:02 radis kernel: [378665.326393] Pid: 25555, comm: NetworkMa=
nager Not tainted 2.6.32-5-amd64 #1
[...]
> Oct  6 21:05:02 radis kernel: [378665.363630] iwlagn 0000:0c:00.0: kmallo=
c for auxiliary BD structures failed
[...]

This particular allocation is for an array which is not used for DMA and
therefore could be stored in non-contiguous pages allocated with
vmalloc().  But there may be some good reason not to do this.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-SbZtQ1ZoJL9pfoGF61xE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUATKzv8+e/yOyVhhEJAQKXgg/9GrOgKAbBcrTcKtqTeo/7gHISsAQXQpHZ
mOPenVbsx9/zW9WGW4z32vEchc8OHIN7TM/ddlbmQOX8jVnnD/xyrgGOdKZIjVir
Ejxfjo4NV1PcEk/DfxUhaayhDQlh2mtxDPzsk3sxwha01lAphTxWMvOqiLns31w+
ptnCW22XHq6NuNi27+Jizc/dF0Yq4lRqq0syQOe29hqF58PF8yVkY4ORqm2X1sh1
Fo+128pJxmzaXMOFFNCFnC2/6HBZ3Ij2Z03ntOs2WZ33QiuTjTK4BaSMb4ZwC47a
r5vqMJ8lRNPg0ClwGUrrW08eIHwI2zQueQV1/lJGdJWYtkNbSkXuvnyk0qkQcyZ9
RFGocjMAYO0wTLLdbyA7CDti4Ja9rs1mH4VUXIdSJpuGMHjGOQxXdb9WCYZhIsyT
2X9QgYTqJKpqUc9u2eZBv47LU6DcguCJxoCVNSR6B9qQ3vnXHGt4xexT4QSeHpP9
6RFeuYArUchtgmEXnFijnT6/fmZvlhGWkNxg/yeK95GzD5iC0FKbhD2BDo6lmXpG
ZWRlElGhxSfRuqVQ/+PdfxZYo3L2f5vacw6Ns4rH+JAqTn5DtzGYFcz2CuOcAvhd
TJaTQG4vdQMbBsM70NaFooypQkSzjTkANAMYCFzqLlD73un1Jn8g1rRngooTLAmv
CmhIK16PCLQ=
=QD72
-----END PGP SIGNATURE-----

--=-SbZtQ1ZoJL9pfoGF61xE--
