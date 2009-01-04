Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix.szarvasnet.hu ([87.101.127.3]:38161 "EHLO
	phoenix.szarvas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbZADLRG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Jan 2009 06:17:06 -0500
Message-ID: <49609A84.3070600@openwrt.org> (sfid-20090104_121711_116696_CC5915BD)
Date: Sun, 04 Jan 2009 12:16:20 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>, Imre Kaloz <kaloz@openwrt.org>
Subject: Re: [RFC 01/12] ath9k: introduce bus specific DMA routines
References: <1230990262-22923-1-git-send-email-juhosg@openwrt.org> <1230990262-22923-2-git-send-email-juhosg@openwrt.org> <20090104072628.GA12905@infradead.org>
In-Reply-To: <20090104072628.GA12905@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christoph Hellwig =EDrta:
> On Sat, Jan 03, 2009 at 02:44:11PM +0100, Gabor Juhos wrote:
>> In the AR913x SoCs, the WMAC devices are connected to the CPU throug=
h
>> the internal AHB bus instead of PCI. We first patch ath9k driver to =
use
>> replaceable DMA routines, so we can use different code for the AHB b=
us.
>=20
>> -		pci_unmap_single(sc->pdev, bf->bf_dmacontext,
>> -				 skb->len,
>> -				 PCI_DMA_TODEVICE);
>> +		ath_unmap_single_to_device(sc, bf->bf_dmacontext, skb->len);
>=20
> Just use the dma_* routines, as they are bus-agnostic and make sure t=
he
> implementation on your mips SOC works for the ahb bus.
>=20
>=20

Ok, i will try it.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
