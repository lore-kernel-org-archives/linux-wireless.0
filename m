Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:38294
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbXKVRgh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2007 12:36:37 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH V2] b43: Changes to enable BCM4311 rev 02 with wireless core revision 13
Date: Thu, 22 Nov 2007 18:34:31 +0100
Cc: John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <4744a544.OLz3JRLe85L+V2nd%Larry.Finger@lwfinger.net>
In-Reply-To: <4744a544.OLz3JRLe85L+V2nd%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200711221834.32026.mb@bu3sch.de> (sfid-20071122_173642_842316_A234025F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 21 November 2007 22:38:12 Larry Finger wrote:
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
> this problem is thought to arise from a hardware error.
>=20
> This patch has been tested on my system and by C=C3=A9dric Caumont
> <icare40@hotmail.com>.
>=20
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>=20
> John,
>=20
> This patch is intended for the everything branch of wireless-2.6.
>=20
> Larry
> ---
>=20
>  dma.c  |   50 ++++++++++++++++++++++++++------------------------
>  main.c |    3 ++-
>  wa.c   |    1 +
>  3 files changed, 29 insertions(+), 25 deletions(-)
>=20
> Index: wireless-2.6/drivers/net/wireless/b43/dma.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-2.6.orig/drivers/net/wireless/b43/dma.c
> +++ wireless-2.6/drivers/net/wireless/b43/dma.c
> @@ -165,7 +165,7 @@ static void op64_fill_descriptor(struct=20
>  	addrhi =3D (((u64) dmaaddr >> 32) & ~SSB_DMA_TRANSLATION_MASK);
>  	addrext =3D (((u64) dmaaddr >> 32) & SSB_DMA_TRANSLATION_MASK)
>  	    >> SSB_DMA_TRANSLATION_SHIFT;
> -	addrhi |=3D ssb_dma_translation(ring->dev->dev);
> +	addrhi |=3D (ssb_dma_translation(ring->dev->dev) << 1);
>  	if (slot =3D=3D ring->nr_slots - 1)
>  		ctl0 |=3D B43_DMA64_DCTL0_DTABLEEND;
>  	if (start)
> @@ -426,9 +426,21 @@ static inline
>  static int alloc_ringmemory(struct b43_dmaring *ring)
>  {
>  	struct device *dev =3D ring->dev->dev->dev;
> +	gfp_t flags =3D GFP_KERNEL;
> =20
> +	/* The specs call for 4K buffers for 30- and 32-bit DMA with 4K
> +	 * alignment and 8K buffers for 64-bit DMA with 8K alignment. Testi=
ng
> +	 * has shown that 4K is sufficient for the latter as long as the bu=
ffer
> +	 * does not cross an 8K boundary.
> +	 *
> +	 * For unknown reasons - possibly a hardware error - the BCM4311 re=
v
> +	 * 02, which uses 64-bit DMA, needs the ring buffer in very low mem=
ory,
> +	 * which accounts for the GFP_DMA flag below.
> +	 */
> +	if (ring->dma64)
> +		flags =3D GFP_DMA;
>  	ring->descbase =3D dma_alloc_coherent(dev, B43_DMA_RINGMEMSIZE,
> -					    &(ring->dmabase), GFP_KERNEL);
> +					    &(ring->dmabase), flags);
>  	if (!ring->descbase) {
>  		b43err(ring->dev->wl, "DMA ringmemory allocation failed\n");
>  		return -ENOMEM;
> @@ -483,7 +495,7 @@ int b43_dmacontroller_rx_reset(struct b4
>  	return 0;
>  }
> =20
> -/* Reset the RX DMA channel */
> +/* Reset the TX DMA channel */
>  int b43_dmacontroller_tx_reset(struct b43_wldev *dev, u16 mmio_base,=
 int dma64)
>  {
>  	int i;
> @@ -636,18 +648,12 @@ static int dmacontroller_setup(struct b4
>  		if (ring->dma64) {
>  			u64 ringbase =3D (u64) (ring->dmabase);
> =20
> -			addrext =3D ((ringbase >> 32) & SSB_DMA_TRANSLATION_MASK)
> -			    >> SSB_DMA_TRANSLATION_SHIFT;
> -			value =3D B43_DMA64_TXENABLE;
> -			value |=3D (addrext << B43_DMA64_TXADDREXT_SHIFT)
> -			    & B43_DMA64_TXADDREXT_MASK;
> -			b43_dma_write(ring, B43_DMA64_TXCTL, value);
> +			b43_dma_write(ring, B43_DMA64_TXCTL,
> +				      B43_DMA64_TXENABLE);
>  			b43_dma_write(ring, B43_DMA64_TXRINGLO,
>  				      (ringbase & 0xFFFFFFFF));
>  			b43_dma_write(ring, B43_DMA64_TXRINGHI,
> -				      ((ringbase >> 32) &
> -				       ~SSB_DMA_TRANSLATION_MASK)
> -				      | trans);
> +				      (ringbase >> 32));
>  		} else {
>  			u32 ringbase =3D (u32) (ring->dmabase);
> =20
> @@ -668,20 +674,15 @@ static int dmacontroller_setup(struct b4
>  		if (ring->dma64) {
>  			u64 ringbase =3D (u64) (ring->dmabase);
> =20
> -			addrext =3D ((ringbase >> 32) & SSB_DMA_TRANSLATION_MASK)
> -			    >> SSB_DMA_TRANSLATION_SHIFT;
> -			value =3D (ring->frameoffset << B43_DMA64_RXFROFF_SHIFT);
> -			value |=3D B43_DMA64_RXENABLE;
> -			value |=3D (addrext << B43_DMA64_RXADDREXT_SHIFT)
> -			    & B43_DMA64_RXADDREXT_MASK;
> +			value =3D (ring->frameoffset << B43_DMA64_RXFROFF_SHIFT)
> +				| B43_DMA64_RXENABLE;
>  			b43_dma_write(ring, B43_DMA64_RXCTL, value);
>  			b43_dma_write(ring, B43_DMA64_RXRINGLO,
>  				      (ringbase & 0xFFFFFFFF));
>  			b43_dma_write(ring, B43_DMA64_RXRINGHI,
> -				      ((ringbase >> 32) &
> -				       ~SSB_DMA_TRANSLATION_MASK)
> -				      | trans);
> -			b43_dma_write(ring, B43_DMA64_RXINDEX, 200);
> +				      (ringbase >> 32));
> +			b43_dma_write(ring, B43_DMA64_RXINDEX, ring->nr_slots *
> +				      sizeof(struct b43_dmadesc64));
>  		} else {
>  			u32 ringbase =3D (u32) (ring->dmabase);
> =20
> @@ -695,11 +696,12 @@ static int dmacontroller_setup(struct b4
>  			b43_dma_write(ring, B43_DMA32_RXRING,
>  				      (ringbase & ~SSB_DMA_TRANSLATION_MASK)
>  				      | trans);
> -			b43_dma_write(ring, B43_DMA32_RXINDEX, 200);
> +			b43_dma_write(ring, B43_DMA32_RXINDEX, ring->nr_slots *
> +				      sizeof(struct b43_dmadesc32));
>  		}
>  	}
> =20
> -      out:
> +out:
>  	return err;
>  }
> =20
> Index: wireless-2.6/drivers/net/wireless/b43/main.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-2.6.orig/drivers/net/wireless/b43/main.c
> +++ wireless-2.6/drivers/net/wireless/b43/main.c
> @@ -93,6 +93,7 @@ static const struct ssb_device_id b43_ss
>  	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 7),
>  	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 9),
>  	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 10),
> +	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 13),
>  	SSB_DEVTABLE_END
>  };
> =20
> @@ -3064,7 +3065,7 @@ static int b43_phy_versioning(struct b43
>  			unsupported =3D 1;
>  		break;
>  	case B43_PHYTYPE_G:
> -		if (phy_rev > 8)
> +		if (phy_rev > 9)
>  			unsupported =3D 1;
>  		break;
>  	default:
> Index: wireless-2.6/drivers/net/wireless/b43/wa.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-2.6.orig/drivers/net/wireless/b43/wa.c
> +++ wireless-2.6/drivers/net/wireless/b43/wa.c
> @@ -642,6 +642,7 @@ void b43_wa_all(struct b43_wldev *dev)
>  		case 6:
>  		case 7:
>  		case 8:
> +		case 9:
>  			b43_wa_tr_ltov(dev);
>  			b43_wa_crs_ed(dev);
>  			b43_wa_rssi_lt(dev);
>=20
>=20

partially acked.
Though, I'm not quite sure yet why you remove that
address extension bits. The specs clearly say that they _are_ there.
And it makes sense to use them, as two bytes of the address are used
for the routing stuff. So the highest 2 bits of the address have to be =
put
somewhere else. That's the "Transmit Channel Control Word" and
"Receive Channel Control Word" where 0x00030000 are the extension bits.

However I do think that this might be related to the bug you are explai=
ning
in the comment:
> +	 * For unknown reasons - possibly a hardware error - the BCM4311 re=
v
> +	 * 02, which uses 64-bit DMA, needs the ring buffer in very low mem=
ory,
> +	 * which accounts for the GFP_DMA flag below.

--=20
Greetings Michael.
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
