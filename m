Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58649 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751661Ab0HXMPq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Aug 2010 08:15:46 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Dan Carpenter <error27@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Mike Frysinger <vapier.adi@gmail.com>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	kernel-janitors@vger.kernel.org
In-Reply-To: <20100824120743.GG29330@bicker>
References: <20100824120743.GG29330@bicker>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-6E3cDtw135peAR+NVFDq"
Date: Tue, 24 Aug 2010 13:15:21 +0100
Message-ID: <1282652121.2968.9.camel@localhost>
Mime-Version: 1.0
Subject: Re: [rfc patch] libertas: fix if_spi_prog_helper_firmware()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6E3cDtw135peAR+NVFDq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2010-08-24 at 14:07 +0200, Dan Carpenter wrote:
> The indenting is not correct here.  I don't have this hardware and I'm
> just guessing as to what was intended.  I think that if there is an
> error we should return an error code, but if there isn't an error we
> should return success directly without releasing the firmware.
[...]

The driver doesn't use or refer to the firmware image once it's copied
into device RAM, so this just leaks the firmware.

The driver *should* keep a reference so it can restore the firmware
after suspend/resume without filesystem access (which is likely to
deadlock).

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-6E3cDtw135peAR+NVFDq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUATHO3zue/yOyVhhEJAQJVtw/9EJk3ezlWAUfbHqfAZu89KMA4QM39Q3Q7
2s6eLI8Am+TDjiztCaBu0asi5cHR992wp+1bOr2VdZIhAJdvp5s1PCO/WdBAoHjc
cl01Jqp8sAz1l+5oDfJfzeIlLXC+sP4iNp+XouSmPjWYwJRNM9d6hdj5sLKua83f
+k5Tuk97Dizt1CooMQVpJKPcV8ooYaRyUQtjWhDAV9bQ0VJcwE+aK0iPpe0LA48S
SKH7xXS4QBwyZqG3pwPV65RC+six8K/gNAQYBKjNQ4/8YaPwtzxGohtL+OS8A5Xr
gK/15jrs3IswUsAi7GNijh75K6jiVKVByJAIPOzdNc4aRo8goncOaEYnHkdoVcEl
Mqy4jqyHOVMBUr7v7zPzYt7MvbKuqu8vGVsgoiXpU8E5nMv5dp0hyZMha2lZSeGn
OL4XRCZAUCvTn29NQY2emklKbDEvYBozdPX7dyzom5F36plNJbjT+vatUzJGgVnb
0Dg4QXIJlO38dwYwNX3WhLNIm/83081WGRpJaM+4J2I1IhAP9m6hNDUML4A7VgSZ
noJnlnTI192/hhLNSIWhCxU3kTjataVEIklnFlfUwn+lk4K2QKj57swkj1vbJbm9
I9LYTSI6JED4mCygmkoA01vE/kaxw4sC0xmRMcLnTXtW0N1iHoNHxnCwtnOKp0LC
MCJqOsnwckM=
=o9za
-----END PGP SIGNATURE-----

--=-6E3cDtw135peAR+NVFDq--
