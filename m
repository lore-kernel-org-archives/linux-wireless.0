Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:49730 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab2LBWdQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Dec 2012 17:33:16 -0500
Received: by mail-wg0-f46.google.com with SMTP id dr13so1225884wgb.1
        for <linux-wireless@vger.kernel.org>; Sun, 02 Dec 2012 14:33:14 -0800 (PST)
References: <1354469687-20895-1-git-send-email-juhosg@openwrt.org>
Mime-Version: 1.0 (1.0)
In-Reply-To: <1354469687-20895-1-git-send-email-juhosg@openwrt.org>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <CC1D2AED-6B67-49FC-9CD7-1E587663FA76@gmail.com> (sfid-20121202_233318_923401_39531EAA)
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	Gabor Juhos <juhosg@openwrt.org>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH] rt2x00: rt2800lib: introduce RFCSR3_VCOCAL_EN
Date: Sun, 2 Dec 2012 22:33:12 +0000
To: Gabor Juhos <juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Sent from my iPad

On 2 dec. 2012, at 17:34, Gabor Juhos <juhosg@openwrt.org> wrote:

> On the RF3290,RF5360,RF5370,RF5372,RF5390,RF5392
> radio frontends, the VCO calibration can be
> controlled via the RFCSR3 register. The current
> code uses the RFCSR30_RF_CALIBRATION constant to
> enable the calibration, however that belongs to
> the RFCSR30 register. Although the values of the
> constant is correct, but using that for another
> register is confusing.
> 
> Add a new definition for the VCO calibration enable
> bit of the RFCSR3 register and use that in the
> relevant places in order to avoid confusions.
> 
> The patch contains no functional changes.
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
> This depends on the following patch:
> 'rt2x00: rt2800lib: remove trailing semicolons from RFCSR3_* defines'
> 
> drivers/net/wireless/rt2x00/rt2800.h    |    2 ++
> drivers/net/wireless/rt2x00/rt2800lib.c |    4 ++--
> 2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
> index 1157b06..4db1088 100644
> --- a/drivers/net/wireless/rt2x00/rt2800.h
> +++ b/drivers/net/wireless/rt2x00/rt2800.h
> @@ -1995,6 +1995,8 @@ struct mac_iveiv_entry {
> /* Bits [7-4] for RF3320 (RT3370/RT3390), on other chipsets reserved */
> #define RFCSR3_PA1_BIAS_CCK        FIELD8(0x70)
> #define RFCSR3_PA2_CASCODE_BIAS_CCKK    FIELD8(0x80)
> +/* Bits for RF3290/RF5360/RF5370/RF5372/RF5390/RF5392 */
> +#define RFCSR3_VCOCAL_EN        FIELD8(0x80)
> 
> /*
>  * FRCSR 5:
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 1cc6599..d4d0c36 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -2243,7 +2243,7 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
>        rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
> 
>        rt2800_rfcsr_read(rt2x00dev, 3, &rfcsr);
> -        rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 1);
> +        rt2x00_set_field8(&rfcsr, RFCSR3_VCOCAL_EN, 1);
>        rt2800_rfcsr_write(rt2x00dev, 3, rfcsr);
>    }
> 
> @@ -2804,7 +2804,7 @@ void rt2800_vco_calibration(struct rt2x00_dev *rt2x00dev)
>    case RF5390:
>    case RF5392:
>        rt2800_rfcsr_read(rt2x00dev, 3, &rfcsr);
> -        rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 1);
> +        rt2x00_set_field8(&rfcsr, RFCSR3_VCOCAL_EN, 1);
>        rt2800_rfcsr_write(rt2x00dev, 3, rfcsr);
>        break;
>    default:
> -- 
> 1.7.10
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
