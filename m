Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4015 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625AbXKGCdS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2007 21:33:18 -0500
Date: Tue, 6 Nov 2007 21:32:53 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Miguel =?iso-8859-1?Q?Bot=F3n?= <mboton.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	mb@bu3sch.de
Subject: Re: [PATCH 1/2] ssb: Add "ssb_pci_set_power_state" function
Message-ID: <20071107023253.GA30169@tuxdriver.com> (sfid-20071107_023325_064103_2596C138)
References: <200710242131.21959.mboton.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <200710242131.21959.mboton.lkml@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Miguel,

Along with the style point Michael suggested, I'll need you to repost
both this one and the b44 patch with at least a Signed-off-by line.

	http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt

Also, please include the patches as plain text using a mailer that
does not damage whitespace.

Thanks,

John

On Wed, Oct 24, 2007 at 09:31:21PM +0200, Miguel Bot=F3n wrote:
> Add "ssb_pci_set_power_state" function. This allows set the power sta=
te of a=20
> PCI device (for example b44 ethernet device).
>=20
> diff -ruN linux-2.6.23/include/linux/ssb/ssb.h=20
> linux-2.6.23.orig/include/linux/ssb/ssb.h
> --- linux-2.6.23.orig/include/linux/ssb/ssb.h	2007-10-24 19:02:33.000=
000000=20
> +0200
> +++ linux-2.6.23/include/linux/ssb/ssb.h	2007-10-24 19:49:37.00000000=
0 +0200
> @@ -402,6 +402,14 @@
>  {
>  	pci_unregister_driver(driver);
>  }
> +
> +/* Set PCI device power state */
> +static inline
> +void ssb_pci_set_power_state(struct ssb_device *dev, pci_power_t sta=
te)
> +{
> +	if(dev->bus->bustype =3D=3D SSB_BUSTYPE_PCI)
> +		pci_set_power_state(dev->bus->host_pci, state);
> +}
>  #endif /* CONFIG_SSB_PCIHOST */
> =20
> =20
>=20
> --=20
> 	Miguel Bot=F3n

--=20
John W. Linville
linville@tuxdriver.com
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
