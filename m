Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:46919
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670AbXKUTpY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2007 14:45:24 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] b43: Changes to enable BCM4311 rev 02 with wireless core revision 13
Date: Wed, 21 Nov 2007 20:44:08 +0100
Cc: John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <474487a9.9c54/m97tX72L4+l%Larry.Finger@lwfinger.net>
In-Reply-To: <474487a9.9c54/m97tX72L4+l%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200711212044.08265.mb@bu3sch.de> (sfid-20071121_194530_703609_8BB843C5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 21 November 2007 20:31:53 Larry Finger wrote:
> The BCM94311MCG rev 02 chip has an 802.11 core with revision 13 and
> has not been supported until now. The changes include the following:
>=20
> (1) Add the 802.11 rev 13 device to the ssb_device_id table to load b=
43.
> (2) Add PHY revision 9 to the supported list.
> (3) Fix 64-bit addressing errors.
> (4) Remove some magic numbers in the DMA setup.
>=20
> The DMA implementation for this chip supports full 64-bit addressing =
with
> one exception. Whenever the Descriptor Ring Buffer is in high memory,=
 a
> fatal DMA error occurs. This problem was not present in 2.6.24-rc2 du=
e
> to code to "Bias the placement of kernel pages at lower PFNs". When
> commit 44048d70 reverted that code, the DMA error appeared. As a "fix=
",
> use the GFP_DMA flag when allocating the buffer for 64-bit DMA. At pr=
esent,
> this problem is thought to arise from a hardware error. The present d=
river
> allocates one ring buffer for RX and six for TX; however, only one of=
 the
> TX buffers is used. To minimize any system impact associated with usi=
ng low
> memory, this patch removes the allocation of the unused buffers.
>=20
> This patch has been tested by C=C3=A9dric Caumont <icare40@hotmail.co=
m>.
>=20

> @@ -954,19 +955,21 @@ int b43_dma_init(struct b43_wldev *dev)
> =20
>  	err =3D -ENOMEM;
>  	/* setup TX DMA channels. */
> -	ring =3D b43_setup_dmaring(dev, 0, 1, dma64);
> +	ring =3D b43_setup_dmaring(dev, 1, 1, dma64);
>  	if (!ring)
>  		goto out;
> -	dma->tx_ring0 =3D ring;
> +	dma->tx_ring1 =3D ring;
> =20
> -	ring =3D b43_setup_dmaring(dev, 1, 1, dma64);
> +	/* The driver only uses ring1 for TX - skip setup for the rest */
> +#if 0

NACK.

> +	ring =3D b43_setup_dmaring(dev, 0, 1, dma64);
>  	if (!ring)
> -		goto err_destroy_tx0;
> -	dma->tx_ring1 =3D ring;
> +		goto err_destroy_tx1;
> +	dma->tx_ring0 =3D ring;
> =20
>  	ring =3D b43_setup_dmaring(dev, 2, 1, dma64);
>  	if (!ring)
> -		goto err_destroy_tx1;
> +		goto err_destroy_tx0;
>  	dma->tx_ring2 =3D ring;
> =20
>  	ring =3D b43_setup_dmaring(dev, 3, 1, dma64);
> @@ -983,6 +986,7 @@ int b43_dma_init(struct b43_wldev *dev)
>  	if (!ring)
>  		goto err_destroy_tx4;
>  	dma->tx_ring5 =3D ring;
> +#endif


--=20
Greetings Michael.
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
