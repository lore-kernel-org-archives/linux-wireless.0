Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56449 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbZADH0g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Jan 2009 02:26:36 -0500
Date: Sun, 4 Jan 2009 02:26:28 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>, Imre Kaloz <kaloz@openwrt.org>
Subject: Re: [RFC 01/12] ath9k: introduce bus specific DMA routines
Message-ID: <20090104072628.GA12905@infradead.org> (sfid-20090104_082657_712447_F9DF0B0A)
References: <1230990262-22923-1-git-send-email-juhosg@openwrt.org> <1230990262-22923-2-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1230990262-22923-2-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 03, 2009 at 02:44:11PM +0100, Gabor Juhos wrote:
> In the AR913x SoCs, the WMAC devices are connected to the CPU through
> the internal AHB bus instead of PCI. We first patch ath9k driver to use
> replaceable DMA routines, so we can use different code for the AHB bus.

> -		pci_unmap_single(sc->pdev, bf->bf_dmacontext,
> -				 skb->len,
> -				 PCI_DMA_TODEVICE);
> +		ath_unmap_single_to_device(sc, bf->bf_dmacontext, skb->len);

Just use the dma_* routines, as they are bus-agnostic and make sure the
implementation on your mips SOC works for the ahb bus.

