Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:7857 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbZAOCvE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2009 21:51:04 -0500
Received: by wa-out-1112.google.com with SMTP id v27so462344wah.21
        for <linux-wireless@vger.kernel.org>; Wed, 14 Jan 2009 18:51:03 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18798.41971.397753.279649@localhost.localdomain> (sfid-20090115_035109_913465_409A1727)
Date: Thu, 15 Jan 2009 08:18:19 +0530
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jmalinen@atheros.com>,
	Christoph Hellwig <hch@infradead.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [ath9k-devel] [PATCH v4 07/11] ath9k: get EEPROM contents from
	platform data on AHB bus
In-Reply-To: <1231960632-4452-8-git-send-email-juhosg@openwrt.org>
References: <1231960632-4452-1-git-send-email-juhosg@openwrt.org>
	<1231960632-4452-8-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gabor Juhos wrote:
> +static bool ath_ahb_eeprom_read(struct ath_hal *ah, u32 off, u16 *data)
> +{
> +	struct ath_softc *sc = ah->ah_sc;
> +	struct platform_device *pdev = to_platform_device(sc->dev);
> +	struct ath9k_platform_data *pdata;
> +
> +	pdata = (struct ath9k_platform_data *) pdev->dev.platform_data;
> +	if (off >= (ARRAY_SIZE(pdata->eeprom_data))) {
> +		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
> +			"%s: flash read failed, offset %08x is out of range\n",
> +				__func__, off);
> +		return false;
> +	}
> +
> +	*data = pdata->eeprom_data[off];
> +	return true;
> +}
> +

Shouldn't pdev->dev.platform_data be initalized somewhere ?

Sujith

