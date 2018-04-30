Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35049 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751064AbeD3Kl3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Apr 2018 06:41:29 -0400
Date: Mon, 30 Apr 2018 12:41:24 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Nipun Gupta <nipun.gupta@nxp.com>
Cc: robin.murphy@arm.com, hch@lst.de, linux@armlinux.org.uk,
        gregkh@linuxfoundation.org, m.szyprowski@samsung.com,
        bhelgaas@google.com, zajec5@gmail.com, andy.gross@linaro.org,
        david.brown@linaro.org, dan.j.williams@intel.com,
        vinod.koul@intel.com, robh+dt@kernel.org, frowand.list@gmail.com,
        jarkko.sakkinen@linux.intel.com, rafael.j.wysocki@intel.com,
        dmitry.torokhov@gmail.com, johan@kernel.org, msuchanek@suse.de,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-wireless@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-soc@vger.kernel.org, dmaengine@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        devicetree@vger.kernel.org, linux-pci@vger.kernel.org,
        bharat.bhushan@nxp.com, leoyang.li@nxp.com
Subject: Re: [PATCH v4 1/2] dma-mapping: move dma configuration to bus
 infrastructure
Message-ID: <20180430104124.GE2476@ulmo> (sfid-20180430_124136_008759_7196D6E6)
References: <1520868292-2479-1-git-send-email-nipun.gupta@nxp.com>
 <1524883919-29484-1-git-send-email-nipun.gupta@nxp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Ns7jmDPpOpCD+GE/"
In-Reply-To: <1524883919-29484-1-git-send-email-nipun.gupta@nxp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--Ns7jmDPpOpCD+GE/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 28, 2018 at 08:21:58AM +0530, Nipun Gupta wrote:
[...]
> diff --git a/drivers/gpu/host1x/bus.c b/drivers/gpu/host1x/bus.c
> index 88a3558..a9ec99d 100644
> --- a/drivers/gpu/host1x/bus.c
> +++ b/drivers/gpu/host1x/bus.c
> @@ -314,6 +314,13 @@ static int host1x_device_match(struct device *dev, s=
truct device_driver *drv)
>  	return strcmp(dev_name(dev), drv->name) =3D=3D 0;
>  }
> =20
> +static int host1x_dma_configure(struct device *dev)
> +{
> +	if (dev->of_node)
> +		return of_dma_configure(dev, dev->of_node);

The conditional here is somewhat pointless since the of_node should
always be set. If it weren't it should be considered a bug and this
function welcome to crash to make that very obvious.

Either way:

Acked-by: Thierry Reding <treding@nvidia.com>

--Ns7jmDPpOpCD+GE/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAlrm8tIACgkQ3SOs138+
s6HAJg/9FscZP4vLRd/bBp6+rBZLIilAu8k5gn/V+Tv9DJZRIXPsbeOuuixcznXK
Sc940MSfERPYXl8fscrW9kdJWuFM4W3bdXJGzZ08T+IdVVSyFdbldOoPAVpeLi8Y
C8pT3jlCLD5r6foGpUXy52rt6Jtuh7Tc4+3rr+D5h/efg9kbudcOjb2p3hcUDum+
6BJSl7yVKDN6yjK1+o7GHu0wic6CWZe/mNmaQ7g8jn7ahWV3kHnwrHj3/3l4N+h+
cDiZhl34yzyEJRyQ0aHr1r2qdEJTXYA33JpX0zMhqzpv9JCMa+VlteQ48kXSxxTN
X6TuS4pmeihUA9h3pFsuGAogPvW/tznL8tr9c2F2cJ/VDL3itQmfNmzT44ybrZYT
uNPIULOaNePPf10DGcd4RZCJIMUDQeza1IHEmiwlDnr5lYJWJUDtSb4ZfyA2j87y
q5wcupDKuqQ4v2tdkcZb9z8Mm5jYGsrWDVKFxKDPfx0LAwzmo5MNOcbGHnPiy8Oo
N24oBFW3v1ESkzX9Yfd7VCDcKIms1qjO2hyVmIb6jCvPg36E8mqG3f599zn8zCdu
i7xUnhwOs64t/yj62rPEd++T6dEsn7idUd6RGkZxLAWwSMipQ7dFhh0nBbKUGwwU
8yRNFMAtpLAaTnt4FqcLN/0BFZ09zwCVHJFw/mYxeUTFGN/V4Xc=
=hGR3
-----END PGP SIGNATURE-----

--Ns7jmDPpOpCD+GE/--
