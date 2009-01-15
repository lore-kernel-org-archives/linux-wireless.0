Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix.szarvasnet.hu ([87.101.127.3]:50660 "EHLO
	phoenix.szarvas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756228AbZAOIHW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 03:07:22 -0500
Message-ID: <496EEE6D.6090300@openwrt.org> (sfid-20090115_090741_751033_0C103C79)
Date: Thu, 15 Jan 2009 09:06:05 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Sujith <m.sujith@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jmalinen@atheros.com>,
	Christoph Hellwig <hch@infradead.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [ath9k-devel] [PATCH v4 07/11] ath9k: get EEPROM contents from
 platform data on AHB bus
References: <1231960632-4452-1-git-send-email-juhosg@openwrt.org>	<1231960632-4452-8-git-send-email-juhosg@openwrt.org> <18798.41971.397753.279649@localhost.localdomain>
In-Reply-To: <18798.41971.397753.279649@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith =EDrta:
> Gabor Juhos wrote:
>> +static bool ath_ahb_eeprom_read(struct ath_hal *ah, u32 off, u16 *d=
ata)
>> +{
>> +	struct ath_softc *sc =3D ah->ah_sc;
>> +	struct platform_device *pdev =3D to_platform_device(sc->dev);
>> +	struct ath9k_platform_data *pdata;
>> +
>> +	pdata =3D (struct ath9k_platform_data *) pdev->dev.platform_data;
>> +	if (off >=3D (ARRAY_SIZE(pdata->eeprom_data))) {
>> +		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
>> +			"%s: flash read failed, offset %08x is out of range\n",
>> +				__func__, off);
>> +		return false;
>> +	}
>> +
>> +	*data =3D pdata->eeprom_data[off];
>> +	return true;
>> +}
>> +
>=20
> Shouldn't pdev->dev.platform_data be initalized somewhere ?

It must be initialized by the board specific setup code,

> @@ -48,6 +69,12 @@ static int ath_ahb_probe(struct platform_device *p=
dev)
>  	int ret =3D 0;
>  	struct ath_hal *ah;
> =20
> +	if (!pdev->dev.platform_data) {
> +		dev_err(&pdev->dev, "no platform data specified\n");
> +		ret =3D -EINVAL;
> +		goto err_out;
> +	}
> +

=2E.. and we have checked it in the probe routine anyway.

-Gabor

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
