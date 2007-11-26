Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:60561
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbXKZPNN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 10:13:13 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH V3] b43: Changes to enable BCM4311 rev 02 with wireless core revision 13
Date: Mon, 26 Nov 2007 16:11:52 +0100
Cc: John Linville <linville@tuxdriver.com>,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
References: <474ADA53.808@lwfinger.net>
In-Reply-To: <474ADA53.808@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200711261611.52975.mb@bu3sch.de> (sfid-20071126_151315_332134_8F0FA333)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 26 November 2007 15:38:11 Larry Finger wrote:
> The BCM94311MCG rev 02 chip has an 802.11 core with revision 13 and
> has not been supported until now. The changes include the following:
>=20
> (1) Add the 802.11 rev 13 device to the ssb_device_id table to load b=
43.
> (2) Add PHY revision 9 to the supported list.
> (3) Change the 2-bit routing code for address extensions to 0b10 rath=
er
>     than the 0b01 used for the 32-bit case.
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
> This patch has been tested on my system, and by C=C3=A9dric Caumont
> <icare40@hotmail.com> and by Matthieu PATOU <mat@matws.net> on a BCM4=
312.
>=20
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>


>  static int alloc_ringmemory(struct b43_dmaring *ring)
>  {
>  	struct device *dev =3D ring->dev->dev->dev;
> +	gfp_t flags =3D GFP_KERNEL;
>=20
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

Whoops, didn't notice this before. This needs to be
	flags |=3D GFP_DMA;

>  	ring->descbase =3D dma_alloc_coherent(dev, B43_DMA_RINGMEMSIZE,
> -					    &(ring->dmabase), GFP_KERNEL);
> +					    &(ring->dmabase), flags);
>  	if (!ring->descbase) {
>  		b43err(ring->dev->wl, "DMA ringmemory allocation failed\n");
>  		return -ENOMEM;

The rest is acked.

--=20
Greetings Michael.
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
