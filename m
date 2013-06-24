Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:42568 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab3FXNCU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 09:02:20 -0400
Received: by mail-ie0-f179.google.com with SMTP id c10so24916230ieb.10
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jun 2013 06:02:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1371915734-13966-4-git-send-email-juhosg@openwrt.org>
References: <1371915734-13966-1-git-send-email-juhosg@openwrt.org>
	<1371915734-13966-4-git-send-email-juhosg@openwrt.org>
Date: Mon, 24 Jun 2013 15:02:19 +0200
Message-ID: <CAGXE3d_SOf-Jq_Ke6TJHbbHVChCQWZvgGQSW11z-mnHzPsxQ8Q@mail.gmail.com> (sfid-20130624_150222_892583_A3AA0EFC)
Subject: Re: [PATCH 3/3] rt2x00: rt2800lib: turn on tertiary PAs/LNAs for
 3T/3R devices
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 22, 2013 at 5:42 PM, Gabor Juhos <juhosg@openwrt.org> wrote:
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

Looks also good to me.

Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index f4cd3d8..664e9e1 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -2684,12 +2684,26 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
>                                    rf->channel > 14);
>                 rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G1_EN,
>                                    rf->channel <= 14);
> +
> +               if (rt2x00dev->default_ant.tx_chain_num > 2) {
> +                       /* Turn on tertiary PAs for 3T devices */
> +                       rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A2_EN,
> +                                       rf->channel > 14);
> +                       rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G2_EN,
> +                                       rf->channel <= 14);
> +               }
>         }
>
>         if (rt2x00dev->default_ant.rx_chain_num > 1) {
>                 /* Turn on secondary LNAs for 2R and for 3R devices */
>                 rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_A1_EN, 1);
>                 rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_G1_EN, 1);
> +
> +               if (rt2x00dev->default_ant.rx_chain_num > 2) {
> +                       /* Turn on tertiary LNAs for 3R devices */
> +                       rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_A2_EN, 1);
> +                       rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_G2_EN, 1);
> +               }
>         }
>
>         rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_A0_EN, 1);
> --
> 1.7.10
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
