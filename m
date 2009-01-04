Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53990 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbZADHa0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Jan 2009 02:30:26 -0500
Date: Sun, 4 Jan 2009 02:30:22 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>, Imre Kaloz <kaloz@openwrt.org>
Subject: Re: [RFC 07/12] ath9k: introduce platform driver for AHB bus
	support
Message-ID: <20090104073022.GC12905@infradead.org> (sfid-20090104_083032_843595_9BE5D1F3)
References: <1230990262-22923-1-git-send-email-juhosg@openwrt.org> <1230990262-22923-8-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1230990262-22923-8-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 03, 2009 at 02:44:17PM +0100, Gabor Juhos wrote:
> +static dma_addr_t ath_ahb_map_single_to_device(struct ath_softc *sc,
> +					       void *p, size_t size)
> +{
> +	return dma_map_single(NULL, p, size, DMA_TO_DEVICE);
> +}

As said before you should just use dma_* directly.  And please make sure
to always pass a struct device to the dma_* routines, even if your
platform might currently not required it the API does.

> +static void ath_ahb_cleanup(struct ath_softc *sc)
> +{
> +	struct platform_device *pdev = to_platform_device(sc->dev);
> +	struct ieee80211_hw *hw = sc->hw;
> +	struct resource *res;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> +	if (res)
> +		free_irq(res->start, sc);

If you stored the irq value directly in the softc this whole thing might
be able to be done in a generic way..

