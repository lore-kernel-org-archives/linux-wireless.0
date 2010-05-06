Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:49335 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100Ab0EFG0w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 02:26:52 -0400
Message-ID: <4BE26123.5040209@free.fr>
Date: Thu, 06 May 2010 08:26:43 +0200
From: Benoit Papillault <benoit.papillault@free.fr>
MIME-Version: 1.0
To: rt2x00 Users List <users@rt2x00.serialmonkey.com>
CC: Gertjan van Wingerde <gwingerde@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [rt2x00-users] [PATCH 3/4] rt2x00: Fix HT40+/HT40- setting in
 rt2800.
References: <1272919385-18004-1-git-send-email-gwingerde@gmail.com> <1272919385-18004-4-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1272919385-18004-4-git-send-email-gwingerde@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le 03/05/2010 22:43, Gertjan van Wingerde a écrit :
> Inspection of the Ralink vendor driver shows that the TX_BAND_CFG register
> and BBP register 3 are about HT40- indication, not about HT40+ indication.
> Inverse the meaning of these fields in the code.
>
> Signed-off-by: Gertjan van Wingerde<gwingerde@gmail.com>

Acked-by: Benoit Papillault <benoit.papillault@free.fr>

> ---
>   drivers/net/wireless/rt2x00/rt2800.h    |    4 ++--
>   drivers/net/wireless/rt2x00/rt2800lib.c |    4 ++--
>   2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
> index 4c0b481..2aa0375 100644
> --- a/drivers/net/wireless/rt2x00/rt2800.h
> +++ b/drivers/net/wireless/rt2x00/rt2800.h
> @@ -845,7 +845,7 @@
>    * TX_BAND_CFG: 0x1 use upper 20MHz, 0x0 use lower 20MHz
>    */
>   #define TX_BAND_CFG			0x132c
> -#define TX_BAND_CFG_HT40_PLUS		FIELD32(0x00000001)
> +#define TX_BAND_CFG_HT40_MINUS		FIELD32(0x00000001)
>   #define TX_BAND_CFG_A			FIELD32(0x00000002)
>   #define TX_BAND_CFG_BG			FIELD32(0x00000004)
>
> @@ -1519,7 +1519,7 @@ struct mac_iveiv_entry {
>    * BBP 3: RX Antenna
>    */
>   #define BBP3_RX_ANTENNA			FIELD8(0x18)
> -#define BBP3_HT40_PLUS			FIELD8(0x20)
> +#define BBP3_HT40_MINUS			FIELD8(0x20)
>
>   /*
>    * BBP 4: Bandwidth
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 7310f34..6d2c66d 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -867,7 +867,7 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
>   	}
>
>   	rt2800_register_read(rt2x00dev, TX_BAND_CFG,&reg);
> -	rt2x00_set_field32(&reg, TX_BAND_CFG_HT40_PLUS, conf_is_ht40_plus(conf));
> +	rt2x00_set_field32(&reg, TX_BAND_CFG_HT40_MINUS, conf_is_ht40_minus(conf));
>   	rt2x00_set_field32(&reg, TX_BAND_CFG_A, rf->channel>  14);
>   	rt2x00_set_field32(&reg, TX_BAND_CFG_BG, rf->channel<= 14);
>   	rt2800_register_write(rt2x00dev, TX_BAND_CFG, reg);
> @@ -900,7 +900,7 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
>   	rt2800_bbp_write(rt2x00dev, 4, bbp);
>
>   	rt2800_bbp_read(rt2x00dev, 3,&bbp);
> -	rt2x00_set_field8(&bbp, BBP3_HT40_PLUS, conf_is_ht40_plus(conf));
> +	rt2x00_set_field8(&bbp, BBP3_HT40_MINUS, conf_is_ht40_minus(conf));
>   	rt2800_bbp_write(rt2x00dev, 3, bbp);
>
>   	if (rt2x00_rt_rev(rt2x00dev, RT2860, REV_RT2860C)) {

