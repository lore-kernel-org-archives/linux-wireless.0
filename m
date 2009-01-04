Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix.szarvasnet.hu ([87.101.127.3]:38662 "EHLO
	phoenix.szarvas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbZADLS7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Jan 2009 06:18:59 -0500
Message-ID: <49609AFE.2010209@openwrt.org> (sfid-20090104_121901_588626_6C03BEE6)
Date: Sun, 04 Jan 2009 12:18:22 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>, Imre Kaloz <kaloz@openwrt.org>
Subject: Re: [RFC 07/12] ath9k: introduce platform driver for AHB bus	support
References: <1230990262-22923-1-git-send-email-juhosg@openwrt.org> <1230990262-22923-8-git-send-email-juhosg@openwrt.org> <20090104073022.GC12905@infradead.org>
In-Reply-To: <20090104073022.GC12905@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christoph Hellwig =EDrta:
> On Sat, Jan 03, 2009 at 02:44:17PM +0100, Gabor Juhos wrote:
>> +static dma_addr_t ath_ahb_map_single_to_device(struct ath_softc *sc=
,
>> +					       void *p, size_t size)
>> +{
>> +	return dma_map_single(NULL, p, size, DMA_TO_DEVICE);
>> +}
>=20
> As said before you should just use dma_* directly.  And please make s=
ure
> to always pass a struct device to the dma_* routines, even if your
> platform might currently not required it the API does.
>=20
>> +static void ath_ahb_cleanup(struct ath_softc *sc)
>> +{
>> +	struct platform_device *pdev =3D to_platform_device(sc->dev);
>> +	struct ieee80211_hw *hw =3D sc->hw;
>> +	struct resource *res;
>> +
>> +	res =3D platform_get_resource(pdev, IORESOURCE_IRQ, 0);
>> +	if (res)
>> +		free_irq(res->start, sc);
>=20
> If you stored the irq value directly in the softc this whole thing mi=
ght
> be able to be done in a generic way..
>=20
>=20

I did not want to store it in the softc, because 'struct pci_dev' has i=
t already
and we will duplicate it. However the code will be simpler, so i can ad=
d it of
course.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
