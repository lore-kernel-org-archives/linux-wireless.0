Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:46060 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab3GHKCf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 06:02:35 -0400
Received: by mail-ie0-f171.google.com with SMTP id qd12so9584303ieb.16
        for <linux-wireless@vger.kernel.org>; Mon, 08 Jul 2013 03:02:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1373275556-6482-4-git-send-email-juhosg@openwrt.org>
References: <1373275556-6482-1-git-send-email-juhosg@openwrt.org>
	<1373275556-6482-4-git-send-email-juhosg@openwrt.org>
Date: Mon, 8 Jul 2013 12:02:35 +0200
Message-ID: <CAL1gcdNfdt2MnRm1=GRhhTz8nONVkgGRikrvHU-2G=xQM_n4+w@mail.gmail.com> (sfid-20130708_120238_705586_74F3FA33)
Subject: Re: [PATCH v2 3/5] rt2x00: rt2800lib: introduce rt2800_eeprom_read_from_array
 helper
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 8, 2013 at 11:25 AM, Gabor Juhos <juhosg@openwrt.org> wrote:
> Add a new helper function and use that for reading
> single elements of various arrays in the EEPROM.
>
> The patch does not change the current behaviour,
> but it allows to use sequential values for the
> rt2800_eeprom_word enums. The conversion will be
> implemented in a subsequent change.
>
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
> Changes since v1: ---
> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |   23 ++++++++++++++++-------
>  1 file changed, 16 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 522f0b1..b59772a 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -239,6 +239,14 @@ static void rt2800_eeprom_write(struct rt2x00_dev *rt2x00dev,
>         rt2x00_eeprom_write(rt2x00dev, word, data);
>  }
>
> +static void rt2800_eeprom_read_from_array(struct rt2x00_dev *rt2x00dev,
> +                                         const enum rt2800_eeprom_word array,
> +                                         unsigned int offset,
> +                                         u16 *data)
> +{
> +       rt2x00_eeprom_read(rt2x00dev, array + offset, data);
> +}
> +
>  static int rt2800_enable_wlan_rt3290(struct rt2x00_dev *rt2x00dev)
>  {
>         u32 reg;
> @@ -2995,8 +3003,8 @@ static u8 rt2800_compensate_txpower(struct rt2x00_dev *rt2x00dev, int is_rate_b,
>                  * .11b data rate need add additional 4dbm
>                  * when calculating eirp txpower.
>                  */
> -               rt2800_eeprom_read(rt2x00dev, EEPROM_TXPOWER_BYRATE + 1,
> -                                  &eeprom);
> +               rt2800_eeprom_read_from_array(rt2x00dev, EEPROM_TXPOWER_BYRATE,
> +                                             1, &eeprom);
>                 criterion = rt2x00_get_field16(eeprom,
>                                                EEPROM_TXPOWER_BYRATE_RATE0);
>
> @@ -3101,8 +3109,8 @@ static void rt2800_config_txpower(struct rt2x00_dev *rt2x00dev,
>                 rt2800_register_read(rt2x00dev, offset, &reg);
>
>                 /* read the next four txpower values */
> -               rt2800_eeprom_read(rt2x00dev, EEPROM_TXPOWER_BYRATE + i,
> -                                  &eeprom);
> +               rt2800_eeprom_read_from_array(rt2x00dev, EEPROM_TXPOWER_BYRATE,
> +                                             i, &eeprom);
>
>                 is_rate_b = i ? 0 : 1;
>                 /*
> @@ -3150,8 +3158,8 @@ static void rt2800_config_txpower(struct rt2x00_dev *rt2x00dev,
>                 rt2x00_set_field32(&reg, TX_PWR_CFG_RATE3, txpower);
>
>                 /* read the next four txpower values */
> -               rt2800_eeprom_read(rt2x00dev, EEPROM_TXPOWER_BYRATE + i + 1,
> -                                  &eeprom);
> +               rt2800_eeprom_read_from_array(rt2x00dev, EEPROM_TXPOWER_BYRATE,
> +                                             i + 1, &eeprom);
>
>                 is_rate_b = 0;
>                 /*
> @@ -4579,7 +4587,8 @@ static void rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
>         }
>
>         for (i = 0; i < EEPROM_BBP_SIZE; i++) {
> -               rt2800_eeprom_read(rt2x00dev, EEPROM_BBP_START + i, &eeprom);
> +               rt2800_eeprom_read_from_array(rt2x00dev, EEPROM_BBP_START, i,
> +                                             &eeprom);
>
>                 if (eeprom != 0xffff && eeprom != 0x0000) {
>                         reg_id = rt2x00_get_field16(eeprom, EEPROM_BBP_REG_ID);
> --
> 1.7.10
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--
---
Gertjan
