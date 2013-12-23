Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:3827 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab3LWHBS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Dec 2013 02:01:18 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: add set_bitrate_mask callback
References: <1387653946-2988-1-git-send-email-janusz.dziedzic@tieto.com>
Date: Mon, 23 Dec 2013 09:01:13 +0200
In-Reply-To: <1387653946-2988-1-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Sat, 21 Dec 2013 20:25:46 +0100")
Message-ID: <87d2koxd8m.fsf@kamboji.qca.qualcomm.com> (sfid-20131223_080125_956367_ED0770D3)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> Add set_bitrate_mask callback. Currently
> ath10k HW is limited to handle only single
> fixed rate setting or limit number of used
> spatial streams.
>
> Example:
> iw wlanX set bitrates legacy-5 ht-mcs-5 vht-mcs-5 2:9
> will setup VHT, nss=2, mcs=9
>
> iw wlanX set bitrates legacy-5 18 ht-mcs-5 vht-mcs-5
> will setup legacy, 18Mbps
>
> iw wlanX set bitrates legacy-5 ht-mcs-5 3 vht-mcs-5
> will setup HT, nss=1, mcs=3
>
> iw wlanX set bitrate legacy-5 ht-mcs-5 vht-mcs-5 1:0-9
> will setup nss=1
>
> iw wlanX set bitrate legacy-5 ht-mcs-5 vht-mcs-5 1:0-9 2:0-9
> will setup nss=2
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

I see a new warning with this patch:

ath10k/mac.c:3593:52: error: unknown field name in initializer

> Depends on, nl80211: add VHT support for set_bitrate_mask

Good, I need to always know this. I now merged wireless-next to ath-next
to get the dependency included.

> --- a/drivers/net/wireless/ath/ath10k/wmi.h
> +++ b/drivers/net/wireless/ath/ath10k/wmi.h
> @@ -3003,6 +3003,24 @@ struct wmi_vdev_install_key_arg {
>  	const void *key_data;
>  };
>  
> +/*
> + * CCK:  0 - 11Mbps, 1 - 5,5Mbps, 2 - 2Mbps, 3 - 1Mbps,
> + *       4 - 11Mbps (s), 5 - 5,5Mbps (s), 6 - 2Mbps (s)
> + * OFDM: 0 - 48Mbps, 1 - 24Mbps, 2 - 12Mbps, 3 - 6Mbps,
> + *       4 - 54Mbps, 5 - 36Mbps, 6 - 18Mbps, 7 - 9Mbps
> + * HT/VHT: MCS index
> + */
> +struct wmi_vdev_fixed_rate {
> +	union {
> +		u8 rate;
> +		struct {
> +			u8 preamble:2, /* %WMI_RATE_PREAMBLE_ */
> +			   nss:2,
> +			   rate_mcs:4; /* see above */
> +		} __packed;
> +	} __packed;
> +} __packed;

Bitfields are frowned upon in kernel, better to use SM() and MS().

-- 
Kalle Valo
