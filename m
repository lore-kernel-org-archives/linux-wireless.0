Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:37283 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab3FXRdr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 13:33:47 -0400
Received: by mail-wg0-f42.google.com with SMTP id z11so2639613wgg.3
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jun 2013 10:33:46 -0700 (PDT)
References: <1371915734-13966-1-git-send-email-juhosg@openwrt.org> <1371915734-13966-3-git-send-email-juhosg@openwrt.org>
Mime-Version: 1.0 (1.0)
In-Reply-To: <1371915734-13966-3-git-send-email-juhosg@openwrt.org>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <0FD84B83-9DFB-4548-BBB7-9F4FDD8D0D53@gmail.com> (sfid-20130624_193350_640521_F328B885)
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	Gabor Juhos <juhosg@openwrt.org>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 2/3] rt2x00: rt2800lib: turn on secondary PAs/LNAs for 3T/3R devices
Date: Mon, 24 Jun 2013 19:33:42 +0200
To: Gabor Juhos <juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Gabor,

Sent from my iPad

On 22 jun. 2013, at 17:42, Gabor Juhos <juhosg@openwrt.org> wrote:

> The secondary PAs/LNAs are turned on only for 2T/2R
> devices, however these are used for 3T/3R devices as
> well. Always turn those on if the device uses more
> than one tx/rx chains.
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

Looks good to me. However, please resubmit with the typo noticed by Helmut fixed.

You can add my Acked-by in that resubmission.

> ---
> drivers/net/wireless/rt2x00/rt2800lib.c |    8 ++++----
> 1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 4072242..f4cd3d8 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -2678,16 +2678,16 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
> 
>    tx_pin = 0;
> 
> -    /* Turn on unused PA or LNA when not using 1T or 1R */
> -    if (rt2x00dev->default_ant.tx_chain_num == 2) {
> +    if (rt2x00dev->default_ant.tx_chain_num > 1) {
> +        /* Turn on secondary PAs for 2T adn for 3T devices*/
>        rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A1_EN,
>                   rf->channel > 14);
>        rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G1_EN,
>                   rf->channel <= 14);
>    }
> 
> -    /* Turn on unused PA or LNA when not using 1T or 1R */
> -    if (rt2x00dev->default_ant.rx_chain_num == 2) {
> +    if (rt2x00dev->default_ant.rx_chain_num > 1) {
> +        /* Turn on secondary LNAs for 2R and for 3R devices */
>        rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_A1_EN, 1);
>        rt2x00_set_field32(&tx_pin, TX_PIN_CFG_LNA_PE_G1_EN, 1);
>    }
> -- 
> 1.7.10
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
