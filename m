Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:32948 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751240AbdBTGZ1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Feb 2017 01:25:27 -0500
Received: by mail-lf0-f67.google.com with SMTP id 86so1517777lfv.0
        for <linux-wireless@vger.kernel.org>; Sun, 19 Feb 2017 22:25:27 -0800 (PST)
Subject: Re: [PATCH] ath10k: Update available channel list for 5G radio
To: c_traja@qti.qualcomm.com, ath10k@lists.infradead.org
References: <1487567326-18346-1-git-send-email-c_traja@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <3ef14794-30e3-729b-b601-3962e52ef6ed@gmail.com> (sfid-20170220_072552_319688_3C3C0C31)
Date: Mon, 20 Feb 2017 07:25:24 +0100
MIME-Version: 1.0
In-Reply-To: <1487567326-18346-1-git-send-email-c_traja@qti.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/20/2017 06:08 AM, c_traja@qti.qualcomm.com wrote:
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index 3029f25..0840efb 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -7623,6 +7623,38 @@ static void ath10k_mac_op_sta_pre_rcu_remove(struct ieee80211_hw *hw,
>  	CHAN2G(14, 2484, 0),
>  };
>
> +static const struct ieee80211_channel ath10k_low_5ghz_channels[] = {
> +	CHAN5G(36, 5180, 0),
> +	CHAN5G(40, 5200, 0),
> +	CHAN5G(44, 5220, 0),
> +	CHAN5G(48, 5240, 0),
> +	CHAN5G(52, 5260, 0),
> +	CHAN5G(56, 5280, 0),
> +	CHAN5G(60, 5300, 0),
> +	CHAN5G(64, 5320, 0),
> +};
> +
> +static const struct ieee80211_channel ath10k_high_5ghz_channels[] = {
> +	CHAN5G(100, 5500, 0),
> +	CHAN5G(104, 5520, 0),
> +	CHAN5G(108, 5540, 0),
> +	CHAN5G(112, 5560, 0),
> +	CHAN5G(116, 5580, 0),
> +	CHAN5G(120, 5600, 0),
> +	CHAN5G(124, 5620, 0),
> +	CHAN5G(128, 5640, 0),
> +	CHAN5G(132, 5660, 0),
> +	CHAN5G(136, 5680, 0),
> +	CHAN5G(140, 5700, 0),
> +	CHAN5G(144, 5720, 0),
> +	CHAN5G(149, 5745, 0),
> +	CHAN5G(153, 5765, 0),
> +	CHAN5G(157, 5785, 0),
> +	CHAN5G(161, 5805, 0),
> +	CHAN5G(165, 5825, 0),
> +	CHAN5G(169, 5845, 0),
> +};

This isn't too flexible. What if one day you'll see hardware that supports
channels 100-144 only?

It should be much better idea to just disable unavailable channels, see what we
did in wiphy_freq_limits_apply (net-next).
