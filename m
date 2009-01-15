Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:19288 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755535AbZAOI0r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 03:26:47 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 15 Jan 2009 00:26:47 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Message-ID: <18798.62076.794358.415474@gargle.gargle.HOWL> (sfid-20090115_092652_785123_3C2CC4BC)
Date: Thu, 15 Jan 2009 13:53:24 +0530
To: Gabor Juhos <juhosg@openwrt.org>
CC: "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Christoph Hellwig <hch@infradead.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [ath9k-devel] [PATCH v4 07/11] ath9k: get EEPROM contents from
 platform data on AHB bus
In-Reply-To: <496EEE6D.6090300@openwrt.org>
References: <1231960632-4452-1-git-send-email-juhosg@openwrt.org>
	<1231960632-4452-8-git-send-email-juhosg@openwrt.org>
	<18798.41971.397753.279649@localhost.localdomain>
	<496EEE6D.6090300@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gabor Juhos wrote:
> Sujith  rta:
> > Gabor Juhos wrote:
> >> +static bool ath_ahb_eeprom_read(struct ath_hal *ah, u32 off, u16 *data)
> >> +{
> >> +    struct ath_softc *sc = ah->ah_sc;
> >> +    struct platform_device *pdev = to_platform_device(sc->dev);
> >> +    struct ath9k_platform_data *pdata;
> >> +
> >> +    pdata = (struct ath9k_platform_data *) pdev->dev.platform_data;
> >> +    if (off >= (ARRAY_SIZE(pdata->eeprom_data))) {
> >> +            DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
> >> +                    "%s: flash read failed, offset %08x is out of range\n",
> >> +                            __func__, off);
> >> +            return false;
> >> +    }
> >> +
> >> +    *data = pdata->eeprom_data[off];
> >> +    return true;
> >> +}
> >> +
> >
> > Shouldn't pdev->dev.platform_data be initalized somewhere ?
> 
> It must be initialized by the board specific setup code,
> 

Ok.

Sujith
