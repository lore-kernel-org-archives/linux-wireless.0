Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:4713 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754392Ab2A3WGz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 17:06:55 -0500
Message-ID: <4F271479.4090303@gmail.com> (sfid-20120130_230701_625313_A7777383)
Date: Mon, 30 Jan 2012 23:06:49 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 2/4] rt2800: radio 3xxx: program RF_R1
 during channel switch
References: <1327936679-12576-1-git-send-email-sgruszka@redhat.com> <1327936679-12576-2-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1327936679-12576-2-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/30/12 16:17, Stanislaw Gruszka wrote:
> Synchronize code with Ralink driver:
> 2011_0719_RT3070_RT3370_RT5370_RT5372_Linux_STA_V2.5.0.3_DPO
> Based on functions:
> RT33xx_ChipSwitchChannel
> RT30xx_ChipSwitchChannel
> RT33xx_Init
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |   34 +++++++++++++++++++++++++++++++
>  1 files changed, 34 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 6edf566..a841918 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -1666,6 +1666,40 @@ static void rt2800_config_channel_rf3xxx(struct rt2x00_dev *rt2x00dev,
>  	rt2x00_set_field8(&rfcsr, RFCSR13_TX_POWER, info->default_power2);
>  	rt2800_rfcsr_write(rt2x00dev, 13, rfcsr);
>  
> +	rt2800_rfcsr_read(rt2x00dev, 1, &rfcsr);
> +	rt2x00_set_field8(&rfcsr, RFCSR1_RX0_PD, 0);
> +	rt2x00_set_field8(&rfcsr, RFCSR1_TX0_PD, 0);
> +	if (rt2x00_rt(rt2x00dev, RT3390)) {
> +		rt2x00_set_field8(&rfcsr, RFCSR1_RX1_PD,
> +				  rt2x00dev->default_ant.rx_chain_num == 1);
> +		rt2x00_set_field8(&rfcsr, RFCSR1_TX1_PD,
> +				  rt2x00dev->default_ant.tx_chain_num == 1);
> +	} else {
> +		rt2x00_set_field8(&rfcsr, RFCSR1_RX1_PD, 0);
> +		rt2x00_set_field8(&rfcsr, RFCSR1_TX1_PD, 0);
> +		rt2x00_set_field8(&rfcsr, RFCSR1_RX2_PD, 0);
> +		rt2x00_set_field8(&rfcsr, RFCSR1_TX2_PD, 0);
> +
> +		switch (rt2x00dev->default_ant.tx_chain_num) {
> +		case 1:
> +			rt2x00_set_field8(&rfcsr, RFCSR1_TX1_PD, 1);
> +			/* fall through */
> +		case 2:
> +			rt2x00_set_field8(&rfcsr, RFCSR1_TX2_PD, 1);
> +			break;
> +		}
> +
> +		switch (rt2x00dev->default_ant.rx_chain_num) {
> +		case 1:
> +			rt2x00_set_field8(&rfcsr, RFCSR1_RX1_PD, 1);
> +			/* fall through */
> +		case 2:
> +			rt2x00_set_field8(&rfcsr, RFCSR1_RX2_PD, 1);
> +			break;
> +		}
> +	}
> +	rt2800_rfcsr_write(rt2x00dev, 1, rfcsr);
> +
>  	rt2800_rfcsr_read(rt2x00dev, 23, &rfcsr);
>  	rt2x00_set_field8(&rfcsr, RFCSR23_FREQ_OFFSET, rt2x00dev->freq_offset);
>  	rt2800_rfcsr_write(rt2x00dev, 23, rfcsr);

To be honest, I think that this can be simplied to a single case for
both RT30xx and RT33xx. Just take the RT30xx branch of the added
if-statement and it should just work fine on both chipset families.

Yes, I am aware the Ralink driver has slightly different code here, but
that just seems to be because they work with knowledge of the
limitations of RT33xx, which ensures that tx_chain_num and rx_chain_num
can never be 2 on that chipset, but still handling it doesn't harm. It
would merely result in better readable code.

---
Gertjan
