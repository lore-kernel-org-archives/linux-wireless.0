Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49794 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750991AbdAPKUC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Jan 2017 05:20:02 -0500
Date: Mon, 16 Jan 2017 11:17:44 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Daniel Golle <daniel@makrotopia.org>
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: Re: [PATCH v2 14/14] rt2x00: add support for RT5350 WiSoC
Message-ID: <20170116101743.GF6968@redhat.com> (sfid-20170116_112006_605135_CBBA85E3)
References: <874m114lwq.fsf@codeaurora.org>
 <20170116031734.GA32321@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170116031734.GA32321@makrotopia.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 16, 2017 at 04:17:58AM +0100, Daniel Golle wrote:
> @@ -7131,6 +7236,12 @@ static int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
>  		rt2x00_set_field16(&word, EEPROM_NIC_CONF0_RF_TYPE, RF2820);
>  		rt2800_eeprom_write(rt2x00dev, EEPROM_NIC_CONF0, word);
>  		rt2x00_eeprom_dbg(rt2x00dev, "Antenna: 0x%04x\n", word);
> +	} else if (rt2x00_rt(rt2x00dev, RT5350)) {
> +		rt2x00_set_field16(&word, EEPROM_NIC_CONF0_RXPATH, 1);
> +		rt2x00_set_field16(&word, EEPROM_NIC_CONF0_TXPATH, 1);
> +		rt2x00_set_field16(&word, EEPROM_NIC_CONF0_RF_TYPE, RF3320);

Here you set RF3320 ..
> +		rt2x00_eeprom_write(rt2x00dev, EEPROM_NIC_CONF0, word);
> +		rt2x00_eeprom_dbg(rt2x00dev, "Antenna: 0x%04x\n", word);
>  	} else if (rt2x00_rt(rt2x00dev, RT2860) ||
>  		   rt2x00_rt(rt2x00dev, RT2872)) {
>  		/*
> @@ -7265,6 +7376,8 @@ static int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
>  		rt2800_eeprom_read(rt2x00dev, EEPROM_CHIP_ID, &rf);
>  	else if (rt2x00_rt(rt2x00dev, RT3352))
>  		rf = RF3322;
> +	else if (rt2x00_rt(rt2x00dev, RT5350))
> +		rf = RF5350;

and here RF5350. This does not seems to be correct.

Stanislaw
